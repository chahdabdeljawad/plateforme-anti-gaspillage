import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';
import '../services/api_service.dart';
import '../screens/addproductpage.dart';
import '../lang.dart';

class ProfilePage extends StatefulWidget {
  final String role;
  final VoidCallback onLogout;

  const ProfilePage({super.key, required this.role, required this.onLogout});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
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

  bool isLoading = true;

  List products = [];

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
      setState(() {
        isLoading = false;
      });

      return;
    }

    final result = await ApiService.getProfile(token);

    print("PROFILE RESULT = $result");

    if (result["success"] == true) {
      final user = result["user"];

      if (user == null) {
        setState(() {
          isLoading = false;
        });

        return;
      }

      setState(() {
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
    } else {
      setState(() {
        isLoading = false;
      });
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

  // 🗑 DELETE PRODUCT
  Future<void> deleteProduct(int id) async {
    final prefs = await SharedPreferences.getInstance();

    final token = prefs.getString("token");

    if (token == null) return;

    final success = await ApiService.deleteProduct(token, id);

    if (success) {
      await fetchProducts();

      setState(() {});

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Product deleted")));
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Delete failed")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final colors = Theme.of(context).colorScheme;

    final safeRole = role.isEmpty ? widget.role : role;

    if (isLoading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      backgroundColor: colors.surface,

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),

          child: Column(
            children: [
              const SizedBox(height: 20),

              // 👤 PROFILE CARD
              Container(
                width: double.infinity,

                padding: const EdgeInsets.all(24),

                decoration: BoxDecoration(
                  color: colors.surface,
                  borderRadius: BorderRadius.circular(30),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    CircleAvatar(
                      radius: 55,
                      backgroundColor: colors.primary,
                      backgroundImage: AssetImage(
                        safeRole == "store"
                            ? 'assets/how1.png'
                            : 'assets/how4.png',
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'PlayfairDisplay',
                        color: colors.primary,
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(
                      email,
                      style: TextStyle(
                        fontSize: 15,
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                    ),

                    const SizedBox(height: 15),

                    if (safeRole == "store") ...[
                      Text(
                        "📞 Num : $num",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "🏪 Catégorie : $categorie",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "📍 Localisation : $localisation",
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "🌍 Latitude : $latitude",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Text(
                        "🌍 Longitude : $longitude",
                        style: const TextStyle(
                          fontSize: 15,
                          color: Colors.black87,
                        ),
                      ),
                    ],

                    const SizedBox(height: 16),

                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color: colors.primary,
                        borderRadius: BorderRadius.circular(30),
                      ),

                      child: Text(
                        safeRole.isNotEmpty ? safeRole.toUpperCase() : "USER",
                        style: TextStyle(
                          color: colors.onPrimary,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🏪 PRODUCTS
              if (safeRole == "store") ...[
                _buildSectionTitle(lang.t("my_store"), colors),

                const SizedBox(height: 16),

                _buildStoreCard('assets/how2.png', "Product 1", colors),
                const SizedBox(height: 12),
                _buildStoreCard('assets/how3.png', "Product 2", colors),
              ],

              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: colors.primary,
                  foregroundColor: colors.onPrimary,
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15),
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const AddProductPage()),
                  );
                },
                icon: const Icon(Icons.add_business),
                label: const Text(
                  "Add Product",
                  style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                ),
              ),

              // CLIENT SECTION
              if (safeRole == "client") ...[
                _buildSectionTitle(lang.t("comments"), colors),

                const SizedBox(height: 16),

                _buildCommentCard(lang.t("good_person"), colors),
                const SizedBox(height: 12),
                _buildCommentCard(lang.t("trusted_client"), colors),
              ],

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,

                child: ElevatedButton.icon(
                  onPressed: widget.onLogout,
                  icon: const Icon(Icons.logout),
                  label: Text(lang.t("logout")),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
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

  Widget _buildSectionTitle(String title, ColorScheme colors) {
    return Align(
      alignment: Alignment.centerLeft,

      child: Text(
        title,
        style: TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
          color: colors.primary,
        ),
      ),
    );
  }

  Widget _buildStoreCard(String image, String title, ColorScheme colors) {
    return Container(
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
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
              ? Image.network(image, width: 60, height: 60, fit: BoxFit.cover)
              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(Icons.image_not_supported),
                ),
        ),
        title: Text(title, style: TextStyle(color: colors.onSurface)),
        trailing: Icon(
          Icons.arrow_forward_ios,
          size: 18,
          color: colors.primary,
        ),
      ),
    );
  }

  Widget _buildCommentCard(String text, ColorScheme colors) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: colors.surface,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 30,
                backgroundImage: AssetImage(
                  role == "store" ? 'assets/how1.png' : 'assets/how4.png',
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.onSurface,
                      ),
                    ),

                    Text(
                      email,
                      style: TextStyle(
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                    ),

                    Text(
                      role.toUpperCase(),
                      style: TextStyle(
                        color: colors.onSurface.withOpacity(0.6),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          Row(
            children: [
              Icon(Icons.comment, color: colors.primary),
              const SizedBox(width: 12),
              Expanded(
                child: Text(text, style: TextStyle(color: colors.onSurface)),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
