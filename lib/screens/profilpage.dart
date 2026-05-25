import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:provider/provider.dart';

import '../services/api_service.dart';
import '../screens/addproductpage.dart';
import '../lang.dart';

class ProfilePage extends StatefulWidget {

  final String role;
  final VoidCallback onLogout;

  const ProfilePage({
    super.key,
    required this.role,
    required this.onLogout,
  });

  @override
  State<ProfilePage> createState() =>
      _ProfilePageState();
}

class _ProfilePageState
    extends State<ProfilePage> {

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

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString("token");

    if (token == null) {

      setState(() {
        isLoading = false;
      });

      return;
    }

    final result =
        await ApiService.getProfile(token);

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

        name =
            user["name"]?.toString() ?? "";

        email =
            user["email"]?.toString() ?? "";

        role =
            user["role"]?.toString() ?? "";

        num =
            user["num"]?.toString() ?? "";

        categorie =
            user["categorie"]?.toString() ?? "";

        localisation =
            user["localisation"]?.toString() ?? "";

        latitude =
            user["latitude"]?.toString() ?? "";

        longitude =
            user["longitude"]?.toString() ?? "";

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

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString("token");

    if (token == null) return;

    final result =
        await ApiService.getMyProducts(token);

    if (result["success"] == true) {

      setState(() {

        products =
            result["products"].map((p) {

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

    final prefs =
        await SharedPreferences.getInstance();

    final token =
        prefs.getString("token");

    if (token == null) return;

    final success =
        await ApiService.deleteProduct(
          token,
          id,
        );

    if (success) {

      await fetchProducts();

      setState(() {});

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text("Product deleted"),
        ),
      );

    } else {

      ScaffoldMessenger.of(context)
          .showSnackBar(

        const SnackBar(
          content: Text("Delete failed"),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {

    final lang =
        Provider.of<Lang>(context);

    final safeRole =
        role.isEmpty
            ? widget.role
            : role;

    if (isLoading) {

      return const Scaffold(
        body: Center(
          child:
              CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(

      backgroundColor:
          const Color(0xFFF5F0E6),

      body: SafeArea(

        child: SingleChildScrollView(

          padding:
              const EdgeInsets.all(20),

          child: Column(

            children: [

              const SizedBox(height: 20),

              // 👤 PROFILE CARD
              Container(

                width: double.infinity,

                padding:
                    const EdgeInsets.all(24),

                decoration: BoxDecoration(

                  color: Colors.white,

                  borderRadius:
                      BorderRadius.circular(30),

                  boxShadow: [

                    BoxShadow(
                      color: Colors.black
                          .withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),

                child: Column(

                  children: [

                    CircleAvatar(

                      radius: 55,

                      backgroundColor:
                          const Color(0xFF0A3B2A),

                      backgroundImage: AssetImage(

                        safeRole == "store"
                            ? 'assets/how1.png'
                            : 'assets/how4.png',
                      ),
                    ),

                    const SizedBox(height: 20),

                    Text(

                      name,

                      style: const TextStyle(
                        fontSize: 24,
                        fontWeight:
                            FontWeight.bold,
                        fontFamily:
                            'PlayfairDisplay',
                        color:
                            Color(0xFF0A3B2A),
                      ),
                    ),

                    const SizedBox(height: 10),

                    Text(

                      email,

                      style: const TextStyle(
                        fontSize: 15,
                        color: Colors.grey,
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

                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 18,
                        vertical: 8,
                      ),

                      decoration: BoxDecoration(
                        color:
                            const Color(0xFF0A3B2A),
                        borderRadius:
                            BorderRadius.circular(30),
                      ),

                      child: Text(

                        safeRole.toUpperCase(),

                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight:
                              FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 30),

              // 🏪 PRODUCTS
              if (safeRole == "store") ...[

                _buildSectionTitle(
                  lang.t("my_store"),
                ),

                const SizedBox(height: 16),

                ...products.map((product) {

                  return Padding(

                    padding:
                        const EdgeInsets.only(
                      bottom: 12,
                    ),

                    child:
                        _buildStoreCard(product),
                  );

                }).toList(),
              ],

              const SizedBox(height: 20),

              // ➕ ADD PRODUCT
              ElevatedButton.icon(

                style:
                    ElevatedButton.styleFrom(
                  backgroundColor:
                      const Color(0xFF0A3B2A),
                  foregroundColor:
                      Colors.white,
                  minimumSize:
                      const Size(
                    double.infinity,
                    55,
                  ),
                  shape:
                      RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15),
                  ),
                ),

                onPressed: () async {

                  await Navigator.push(

                    context,

                    MaterialPageRoute(
                      builder: (_) =>
                          const AddProductPage(),
                    ),
                  );

                  await fetchProducts();

                  setState(() {});
                },

                icon:
                    const Icon(Icons.add_business),

                label: const Text(

                  "Add Product",

                  style: TextStyle(
                    fontSize: 16,
                    fontWeight:
                        FontWeight.bold,
                  ),
                ),
              ),

              const SizedBox(height: 40),

              // 🚪 LOGOUT
              SizedBox(

                width: double.infinity,

                child: ElevatedButton.icon(

                  onPressed:
                      widget.onLogout,

                  icon:
                      const Icon(Icons.logout),

                  label:
                      Text(lang.t("logout")),

                  style:
                      ElevatedButton.styleFrom(
                    backgroundColor:
                        const Color(0xFF0A3B2A),
                    foregroundColor:
                        Colors.white,
                    padding:
                        const EdgeInsets.symmetric(
                      vertical: 16,
                    ),
                    shape:
                        RoundedRectangleBorder(
                      borderRadius:
                          BorderRadius.circular(20),
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
  Widget _buildSectionTitle(
      String title) {

    return Align(

      alignment:
          Alignment.centerLeft,

      child: Text(

        title,

        style: const TextStyle(
          fontSize: 22,
          fontWeight:
              FontWeight.bold,
          fontFamily:
              'PlayfairDisplay',
          color:
              Color(0xFF0A3B2A),
        ),
      ),
    );
  }

  // 🛍 PRODUCT CARD
  Widget _buildStoreCard(
      Map product) {

    final String image =
        product["image"] ?? "";

    final String title =
        product["name"] ?? "";

    final imageUrl =
        image.startsWith("http")
            ? image
            : "http://localhost:5000/uploads/$image";

    return Container(

      decoration: BoxDecoration(

        color: Colors.white,

        borderRadius:
            BorderRadius.circular(20),

        boxShadow: [

          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),
            blurRadius: 8,
            offset: const Offset(0, 3),
          ),
        ],
      ),

      child: ListTile(

        contentPadding:
            const EdgeInsets.all(12),

        leading: ClipRRect(

          borderRadius:
              BorderRadius.circular(12),

          child: image.isNotEmpty

              ? Image.network(
                  imageUrl,
                  width: 60,
                  height: 60,
                  fit: BoxFit.cover,
                )

              : Container(
                  width: 60,
                  height: 60,
                  color: Colors.grey[300],
                  child: const Icon(
                    Icons.image_not_supported,
                  ),
                ),
        ),

        title: Text(title),

        trailing: Row(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            IconButton(

              icon: const Icon(
                Icons.edit,
                color: Colors.orange,
              ),

              onPressed: () async {

                await Navigator.push(

                  context,

                  MaterialPageRoute(
                    builder: (_) =>
                        AddProductPage(
                      product: product,
                    ),
                  ),
                );

                await fetchProducts();

                setState(() {});
              },
            ),

            IconButton(

              icon: const Icon(
                Icons.delete,
                color: Colors.red,
              ),

              onPressed: () async {

                await deleteProduct(
                    product["id"]);
              },
            ),
          ],
        ),
      ),
    );
  }
}