import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../components/navbar.dart';
import '../services/api_service.dart';
import '../screens/scanqrpage.dart'; // 📷

class LivreurDashboard extends StatefulWidget {
  const LivreurDashboard({super.key});

  @override
  State<LivreurDashboard> createState() => _LivreurDashboardState();
}

class _LivreurDashboardState extends State<LivreurDashboard> {
  int? livreurId;
  List available = [];
  List mine = [];
  bool loading = true;

  @override
  void initState() {
    super.initState();
    _init();
  }

  Future<void> _init() async {
    final prefs = await SharedPreferences.getInstance();
    livreurId = prefs.getInt("livreur_id");
    await _loadAll();
  }

  Future<void> _loadAll() async {
    setState(() => loading = true);
    final av = await ApiService.getAvailableDeliveries();
    final my = livreurId != null
        ? await ApiService.getMyDeliveries(livreurId!)
        : [];
    if (!mounted) return;
    setState(() {
      available = av;
      mine = my;
      loading = false;
    });
  }

  Future<void> _accept(int idDelivery) async {
    if (livreurId == null) return;
    final ok = await ApiService.acceptDelivery(idDelivery, livreurId!);
    _msg(ok ? "Livraison acceptée ✅" : "Erreur / déjà prise");
    await _loadAll();
  }

  // 📷 SCAN QR + CONFIRMER LA LIVRAISON
  Future<void> _scanAndConfirm(int idDelivery) async {
    final scanned = await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ScanQrPage()),
    );

    if (scanned == true) {
      // le QR a marqué la réservation 'completed' → on confirme la livraison
      await ApiService.confirmDelivery(idDelivery);
      _msg("Livré ✅ (QR vérifié)");
      await _loadAll();
    } else {
      _msg("QR non vérifié ❌");
    }
  }

  void _msg(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  Future<void> _logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();
    if (!mounted) return;
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const CustomNavbar()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          title: const Text("Espace Livreur"),
          backgroundColor: colors.primary,
          foregroundColor: colors.onPrimary,
          actions: [
            IconButton(icon: const Icon(Icons.refresh), onPressed: _loadAll),
            IconButton(icon: const Icon(Icons.logout), onPressed: _logout),
          ],
          bottom: const TabBar(
            tabs: [
              Tab(text: "Disponibles"),
              Tab(text: "Mes livraisons"),
            ],
          ),
        ),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : TabBarView(
                children: [
                  _buildList(available, colors, isAvailable: true),
                  _buildList(mine, colors, isAvailable: false),
                ],
              ),
      ),
    );
  }

  Widget _buildList(List items, ColorScheme colors, {required bool isAvailable}) {
    if (items.isEmpty) {
      return RefreshIndicator(
        onRefresh: _loadAll,
        child: ListView(
          children: [
            const SizedBox(height: 200),
            Center(
              child: Text(
                isAvailable
                    ? "Aucune livraison disponible"
                    : "Aucune livraison assignée",
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _loadAll,
      child: ListView.builder(
        padding: const EdgeInsets.all(12),
        itemCount: items.length,
        itemBuilder: (_, i) {
          final d = items[i];
          final status = (d["status"] ?? "").toString();

          Widget? action;
          if (isAvailable) {
            action = ElevatedButton(
              onPressed: () => _accept(d["id_delivery"]),
              style: ElevatedButton.styleFrom(
                backgroundColor: colors.primary,
                foregroundColor: colors.onPrimary,
              ),
              child: const Text("Accepter"),
            );
          } else if (status == "delivered") {
            action = const Text(
              "Livré ✅",
              style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),
            );
          } else {
            // 📷 SCANNER QR CLIENT (au lieu de Confirmer)
            action = ElevatedButton.icon(
              onPressed: () => _scanAndConfirm(d["id_delivery"]),
              icon: const Icon(Icons.qr_code_scanner, size: 18),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                foregroundColor: Colors.white,
              ),
              label: const Text("Scanner QR client"),
            );
          }

          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Text(
                          "🛍 ${d["product_name"] ?? ""}",
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      _statusChip(status),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Text("🏪 Magasin : ${d["store_name"] ?? "-"}"),
                  Text("👤 Client : ${d["client_name"] ?? "-"}"),
                  Text("📞 Tél : ${d["client_num"] ?? "-"}"),
                  Text("📦 Quantité : ${d["quantity"] ?? "-"}"),
                  const SizedBox(height: 10),
                  Align(alignment: Alignment.centerRight, child: action),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _statusChip(String status) {
    Color c;
    switch (status) {
      case "pending":
        c = Colors.orange;
        break;
      case "accepted":
        c = Colors.blue;
        break;
      case "delivered":
        c = Colors.green;
        break;
      default:
        c = Colors.grey;
    }
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: c.withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        status,
        style: TextStyle(color: c, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }
}