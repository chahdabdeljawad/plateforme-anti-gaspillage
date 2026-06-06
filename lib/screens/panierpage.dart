import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../services/cart_service.dart';
import '../services/api_service.dart';

class PanierPage extends StatefulWidget {
  const PanierPage({super.key});

  @override
  State<PanierPage> createState() => _PanierPageState();
}

class _PanierPageState extends State<PanierPage> {
  bool loading = false;

  Future<void> _checkout() async {
    if (CartService.items.isEmpty) return;

    final prefs = await SharedPreferences.getInstance();
    final clientId = prefs.getInt("client_id");
    if (clientId == null) {
      _msg("Connectez-vous d'abord");
      return;
    }

    setState(() => loading = true);

    int ok = 0;
    for (final item in List.from(CartService.items)) {
      final res = await ApiService.createReservation(
        clientId,
        item["productId"],
        item["quantity"],
      );
      if (res["success"] == true) ok++;
    }

    setState(() => loading = false);

    if (ok > 0) {
      CartService.clear();
      _msg("Commande validée ✅ ($ok réservation(s))");
      setState(() {});
    } else {
      _msg("Erreur lors de la validation");
    }
  }

  void _msg(String m) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(m)));
  }

  @override
  Widget build(BuildContext context) {
    const primary = Color(0xFF0A3B2A);
    final items = CartService.items;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      appBar: AppBar(
        title: const Text("Mon Panier"),
        backgroundColor: primary,
        foregroundColor: Colors.white,
      ),
      body: items.isEmpty
          ? const Center(child: Text("Panier vide 🛒"))
          : Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: items.length,
                    itemBuilder: (_, i) {
                      final item = items[i];
                      return Card(
                        margin: const EdgeInsets.only(bottom: 12),
                        child: Padding(
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      item["productName"] ?? "",
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                      ),
                                    ),
                                    const SizedBox(height: 4),
                                    Text("🏪 ${item["storeName"] ?? "-"}"),
                                    Text("💰 ${item["price"]}"),
                                  ],
                                ),
                              ),

                              // ➖ quantité ➕
                              Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  IconButton(
                                    icon: const Icon(Icons.remove_circle_outline),
                                    color: primary,
                                    onPressed: () {
                                      CartService.decrement(item["productId"]);
                                      setState(() {});
                                    },
                                  ),
                                  Text(
                                    "${item["quantity"]}",
                                    style: const TextStyle(
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  IconButton(
                                    icon: const Icon(Icons.add_circle_outline),
                                    color: primary,
                                    onPressed: () {
                                      CartService.increment(item["productId"]);
                                      setState(() {});
                                    },
                                  ),
                                ],
                              ),

                              IconButton(
                                icon: const Icon(Icons.delete, color: Colors.red),
                                onPressed: () {
                                  CartService.remove(item["productId"]);
                                  setState(() {});
                                },
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text("Total",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          Text("${CartService.total.toStringAsFixed(2)} DT",
                              style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: primary)),
                        ],
                      ),
                      const SizedBox(height: 12),
                      SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: loading ? null : _checkout,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primary,
                            foregroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 16),
                          ),
                          child: loading
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                      color: Colors.white, strokeWidth: 2))
                              : const Text("Valider la commande"),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
    );
  }
}