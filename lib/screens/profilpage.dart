import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../screens/addproductpage.dart';
import '../screens/scanqrpage.dart'; // 📷 store scanne
import '../screens/qrpage.dart';     // 📷 client affiche son QR
import '../lang.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class ProfilePage extends StatefulWidget {
  final String role;
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.role, required this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class EditProfilePage extends StatefulWidget {
  final int id;
  final String role;
  final String name;
  final String email;
  final String num;
  final String categorie;
  final String localisation;
  const EditProfilePage({
    super.key,
    required this.id,
    required this.role,
    required this.name,
    required this.email,
    required this.num,
    required this.categorie,
    required this.localisation,
  });
  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController numController;
  late TextEditingController categorieController;
  late TextEditingController localisationController;
  bool isLoading = false;
  @override
  void initState() {
    super.initState();
    nameController = TextEditingController(text: widget.name);
    emailController = TextEditingController(text: widget.email);
    numController = TextEditingController(text: widget.num);
    categorieController = TextEditingController(text: widget.categorie);
    localisationController = TextEditingController(text: widget.localisation);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    numController.dispose();
    categorieController.dispose();
    localisationController.dispose();
    super.dispose();
  }

  Future<void> updateProfile() async {
    setState(() => isLoading = true);
    try {
      final response = await http.put(
        Uri.parse("${ApiService.baseUrl}/auth/update-profile"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "id": widget.id,
          "role": widget.role,
          "name": nameController.text.trim(),
          "email": emailController.text.trim(),
          "num": numController.text.trim(),
          "categorie": categorieController.text.trim(),
          "localisation": localisationController.text.trim(),
        }),
      );
      print("UPDATE PROFILE STATUS = ${response.statusCode}");
      print("UPDATE PROFILE BODY = ${response.body}");
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Profile updated")));
        Navigator.pop(context, true);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(data["message"] ?? "Update failed")),
        );
      }
    } catch (e) {
      print("UPDATE PROFILE ERROR = $e");
      ScaffoldMessenger.of(context)
          .showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Edit Profile")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            TextField(
              controller: nameController,
              decoration: const InputDecoration(labelText: "Name"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: emailController,
              decoration: const InputDecoration(labelText: "Email"),
            ),
            const SizedBox(height: 15),
            TextField(
              controller: numController,
              decoration: const InputDecoration(labelText: "Phone"),
            ),
            if (widget.role == "store") ...[
              const SizedBox(height: 15),
              TextField(
                controller: categorieController,
                decoration: const InputDecoration(labelText: "Categorie"),
              ),
              const SizedBox(height: 15),
              TextField(
                controller: localisationController,
                decoration: const InputDecoration(labelText: "Localisation"),
              ),
            ],
            const SizedBox(height: 30),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: isLoading ? null : updateProfile,
                child: isLoading
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: Colors.white,
                        ),
                      )
                    : const Text("Save"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProfilePageState extends State<ProfilePage> {
  String name = "";
  String email = "";
  String role = "";

  String localisation = "";
  String latitude = "";
  String longitude = "";
  String categorie = "";
  String num = "";

  int clientId = 0;

  bool isLoading = true;

  List products = [];

  // 🏪 commandes reçues (store)
  List storeReservations = [];

  @override
  void initState() {
    super.initState();
    loadProfile();
    fetchProducts();
  }

  // 👤 PROFILE
  Future<void> loadProfile() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) {
      setState(() => isLoading = false);
      return;
    }

    final result = await ApiService.getProfile(token);
    print("PROFILE RESULT = $result");

    if (result["success"] == true) {
      final user = result["user"];
      if (user == null) {
        setState(() => isLoading = false);
        return;
      }

      setState(() {
        clientId = user["id"] ?? 0;
        name = user["name"]?.toString() ?? "";
        email = user["email"]?.toString() ?? "";
        role = user["role"]?.toString() ?? "";
        num = user["num"]?.toString() ?? "";
        categorie = user["categorie"]?.toString() ?? "";
        localisation = user["localisation"]?.toString() ?? "";
        latitude = user["latitude"]?.toString() ?? "";
        longitude = user["longitude"]?.toString() ?? "";
        isLoading = false;
      });

      if (role == "store") {
        fetchStoreReservations();
      }
    } else {
      setState(() => isLoading = false);
    }
  }

  // 📦 GET PRODUCTS
  Future<void> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return;

    final result = await ApiService.getMyProducts(token);
    if (result["success"] == true) {
      setState(() {
        products = result["products"].map((p) {
          return {
            ...p,
            "image": p["image"] != null
                ? "http://localhost:5000/uploads/${p["image"]}"
                : "",
          };
        }).toList();
      });
    }
  }

  // 📋 GET STORE RESERVATIONS
  Future<void> fetchStoreReservations() async {
    final res = await ApiService.getStoreReservations(clientId);
    if (!mounted) return;
    setState(() => storeReservations = res);
  }

  // ✅ VALIDER RESERVATION (pending → confirmed)
  Future<void> validateReservation(int id) async {
    final ok = await ApiService.updateReservationStatus(id, "confirmed");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? "Commande validée ✅" : "Erreur")),
      );
    }
    await fetchStoreReservations();
  }

  // ✅ MARQUER LIVRÉ / RÉCUPÉRÉ (confirmed → completed)
  Future<void> markCompleted(int id) async {
    final ok = await ApiService.updateReservationStatus(id, "completed");
    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(ok ? "Commande terminée ✅" : "Erreur")),
      );
    }
    await fetchStoreReservations();
  }

  // 🗑 DELETE PRODUCT
  Future<void> deleteProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("token");
    if (token == null) return;

    final success = await ApiService.deleteProduct(token, id);
    if (success) {
      await fetchProducts();
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Product deleted")));
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final safeRole = role.isEmpty ? widget.role : role;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [
              const SizedBox(height: 20),

              // 👤 PROFILE CARD (sans photo)
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        color: Color(0xFF0A3B2A),
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      email,
                      style: const TextStyle(fontSize: 15, color: Colors.grey),
                    ),
                    const SizedBox(height: 15),

                    if (safeRole == "store") ...[
                      Text("Num : $num",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text("Catégorie : $categorie",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text("Localisation : $localisation",
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text("Latitude : $latitude",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
                      const SizedBox(height: 8),
                      Text("Longitude : $longitude",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
                    ],

                    if (safeRole == "client") ...[
                      Text("Num : $num",
                          style: const TextStyle(
                              fontSize: 15, color: Colors.black87)),
                    ],

                    const SizedBox(height: 16),

                    SizedBox(
                      width: 170,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF0A3B2A),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(
                              horizontal: 18, vertical: 8),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (_) => EditProfilePage(
                                id: clientId,
                                role: safeRole,
                                name: name,
                                email: email,
                                num: num,
                                categorie: categorie,
                                localisation: localisation,
                              ),
                            ),
                          );
                        },
                        child: Text(
                          safeRole == "store" ? "STORE" : "CLIENT",
                          style: const TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 15),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🏪 STORE SECTION
              if (safeRole == "store") ...[
                // 📊 SUIVI DES VENTES
                _buildSalesSummary(),
                const SizedBox(height: 24),

                // 📋 COMMANDES REÇUES
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _buildSectionTitle("Commandes reçues"),
                    IconButton(
                      icon: const Icon(Icons.refresh, color: Color(0xFF0A3B2A)),
                      onPressed: fetchStoreReservations,
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // 📷 SCANNER QR
                ElevatedButton.icon(
                  onPressed: () async {
                    final done = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ScanQrPage()),
                    );
                    if (done == true) fetchStoreReservations();
                  },
                  icon: const Icon(Icons.qr_code_scanner),
                  label: const Text("Scanner QR client"),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3B2A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 50),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                if (storeReservations.isEmpty)
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8),
                    child: Text("Aucune commande pour le moment"),
                  )
                else
                  ...storeReservations.map((r) => _buildReservationCard(r)),
                const SizedBox(height: 30),

                // 🛍 PRODUITS
                _buildSectionTitle(lang.t("my_store")),
                const SizedBox(height: 16),
                ...products.map((product) => Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: _buildStoreCard(product),
                    )),
                const SizedBox(height: 20),
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3B2A),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 55),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () async {
                    await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const AddProductPage()),
                    );
                    await fetchProducts();
                  },
                  icon: const Icon(Icons.add_business),
                  label: const Text(
                    "Add Product",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 40),
              ],

              // 📅 CLIENT RESERVATIONS
              if (safeRole == "client") ...[
                _buildSectionTitle("My Reservations"),
                const SizedBox(height: 16),
                FutureBuilder(
                  future: ApiService.getClientReservations(clientId),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    final data = snapshot.data as Map<String, dynamic>;
                    final reservations = data["reservations"] ?? [];
                    if (reservations.isEmpty) {
                      return const Text("No reservations found");
                    }
                    return Column(
                      children: reservations.map<Widget>((reservation) {
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.05),
                                blurRadius: 8,
                                offset: const Offset(0, 3),
                              ),
                            ],
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Product : ${reservation["product_name"]}",
                                style: const TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 16),
                              ),
                              const SizedBox(height: 8),
                              Text("Store : ${reservation["store_name"]}"),
                              const SizedBox(height: 8),
                              Text("Date : ${reservation["reservation_date"]}"),
                              const SizedBox(height: 8),
                              Text("Statut : ${reservation["status"] ?? "-"}"),
                              const SizedBox(height: 10),
                              ElevatedButton.icon(
                                onPressed: () {
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                      builder: (_) => QrPage(
                                        qrCode: reservation["qr_code"]
                                                ?.toString() ??
                                            "",
                                        productName: reservation["product_name"]
                                            ?.toString(),
                                        storeName: reservation["store_name"]
                                            ?.toString(),
                                        status:
                                            reservation["status"]?.toString(),
                                        quantity: reservation["quantity"]
                                            ?.toString(),
                                      ),
                                    ),
                                  );
                                },
                                icon: const Icon(Icons.qr_code_2),
                                label: const Text("Voir mon QR"),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF0A3B2A),
                                  foregroundColor: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    );
                  },
                ),
                const SizedBox(height: 30),
              ],

              // 🚪 LOGOUT
              SizedBox(
                width: double.infinity,
                child: ElevatedButton.icon(
                  onPressed: widget.onLogout,
                  icon: const Icon(Icons.logout),
                  label: Text(lang.t("logout")),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3B2A),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 30),
            ],
          ),
        ),
      ),
    );
  }

  // 🏷 TITLE
  Widget _buildSectionTitle(String title) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
          color: Color(0xFF0A3B2A),
        ),
      ),
    );
  }

  // 📊 SUIVI DES VENTES
  Widget _buildSalesSummary() {
    final total = storeReservations.length;
    final completed = storeReservations
        .where((r) => (r["status"] ?? "") == "completed")
        .length;
    final pending = storeReservations
        .where((r) => (r["status"] ?? "") == "pending")
        .length;

    double revenu = 0;
    for (final r in storeReservations) {
      if ((r["status"] ?? "") == "completed") {
        final price =
            double.tryParse((r["product_price"] ?? "0").toString()) ?? 0;
        final qty = int.tryParse((r["quantity"] ?? "0").toString()) ?? 0;
        revenu += price * qty;
      }
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF0A3B2A),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "📊 Suivi des ventes",
            style: TextStyle(
              color: Colors.white,
              fontSize: 18,
              fontWeight: FontWeight.bold,
              fontFamily: 'PlayfairDisplay',
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              _statBox("Total", "$total"),
              _statBox("Récupérées", "$completed"),
              _statBox("En attente", "$pending"),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Text(
              "💰 Revenu : ${revenu.toStringAsFixed(2)} DT",
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _statBox(String label, String value) {
    return Column(
      children: [
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(color: Colors.white70, fontSize: 12),
        ),
      ],
    );
  }

  // 📋 RESERVATION CARD (store)
  Widget _buildReservationCard(Map r) {
    final status = (r["status"] ?? "").toString();

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  "🛍 ${r["product_name"] ?? ""}",
                  style: const TextStyle(
                      fontWeight: FontWeight.bold, fontSize: 16),
                ),
              ),
              _statusChip(status),
            ],
          ),
          const SizedBox(height: 8),
          Text("👤 Client : ${r["client_name"] ?? "-"}"),
          Text("📞 Tél : ${r["client_num"] ?? "-"}"),
          Text("📦 Quantité : ${r["quantity"] ?? "-"}"),

          // pending → Valider
          if (status == "pending") ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton(
                onPressed: () => validateReservation(r["id"]),
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0A3B2A),
                  foregroundColor: Colors.white,
                ),
                child: const Text("Valider"),
              ),
            ),
          ],

// confirmed + sur place → le STORE marque livré
          if (status == "confirmed" &&
              (r["delivery_type"] ?? "sur_place") == "sur_place") ...[
            const SizedBox(height: 10),
            Align(
              alignment: Alignment.centerRight,
              child: ElevatedButton.icon(
                onPressed: () => markCompleted(r["id"]),
                icon: const Icon(Icons.check_circle, size: 18),
                label: const Text("Marquer livré"),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  foregroundColor: Colors.white,
                ),
              ),
            ),
          ],

          // confirmed + livraison → c'est le LIVREUR qui scanne
          if (status == "confirmed" &&
              (r["delivery_type"] ?? "sur_place") == "livraison") ...[
            const SizedBox(height: 10),
            const Text(
              " En livraison — le livreur scannera le QR",
              style: TextStyle(color: Colors.blueGrey, fontSize: 13),
            ),
          ],
        ],
      ),
    );
  }

  // 🎨 STATUS CHIP
  Widget _statusChip(String status) {
    Color c;
    switch (status) {
      case "pending":
        c = Colors.orange;
        break;
      case "confirmed":
        c = Colors.blue;
        break;
      case "completed":
        c = Colors.green;
        break;
      case "cancelled":
        c = Colors.red;
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

  // 🛍 PRODUCT CARD
  Widget _buildStoreCard(Map product) {
    final String image = product["image"] ?? "";
    final String title = product["name"] ?? "";
    final String imageUrl = image.startsWith("http")
        ? image
        : "http://localhost:5000/uploads/$image";

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(12),
        leading: ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: image.isNotEmpty
              ? Image.network(imageUrl,
                  width: 60, height: 60, fit: BoxFit.cover)
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
        ),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            IconButton(
              icon: const Icon(Icons.edit, color: Colors.orange),
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AddProductPage(product: product),
                  ),
                );
                await fetchProducts();
              },
            ),
            IconButton(
              icon: const Icon(Icons.delete, color: Colors.red),
              onPressed: () => deleteProduct(product["id"]),
            ),
          ],
        ),
      ),
    );
  }
}
