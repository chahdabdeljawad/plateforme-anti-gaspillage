import 'package:flutter/material.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String searchQuery = "";

  final List<Map<String, dynamic>> categories = [
    {"name": "Fruits", "icon": Icons.apple},
    {"name": "Légumes", "icon": Icons.eco},
    {"name": "Boulangerie", "icon": Icons.bakery_dining},
    {"name": "Repas", "icon": Icons.fastfood},
    {"name": "Boissons", "icon": Icons.local_drink},
    {"name": "Desserts", "icon": Icons.cake},
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),

      appBar: AppBar(
        title: const Text("Catégories"),
        backgroundColor: const Color(0xFF2E7D32),
        elevation: 0,
        centerTitle: true,
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            /// 🔍 SEARCH BAR
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 8,
                  )
                ],
              ),
              child: TextField(
                onChanged: (value) {
                  setState(() {
                    searchQuery = value.toLowerCase();
                  });
                },
                decoration: const InputDecoration(
                  hintText: "Rechercher une catégorie...",
                  prefixIcon: Icon(Icons.search),
                  border: InputBorder.none,
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// 📦 GRID CATEGORIES
            Expanded(
              child: GridView.builder(
                itemCount: categories.length,
                gridDelegate:
                    const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  mainAxisSpacing: 15,
                  crossAxisSpacing: 15,
                  childAspectRatio: 1,
                ),
                itemBuilder: (context, index) {
                  final category = categories[index];

                  if (!category["name"]
                      .toLowerCase()
                      .contains(searchQuery)) {
                    return const SizedBox();
                  }

                  return GestureDetector(
                    onTap: () {
                      // navigation vers détail
                    },

                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 300),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black12,
                            blurRadius: 10,
                          )
                        ],
                      ),

                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [

                          /// ICON
                          CircleAvatar(
                            radius: 30,
                            backgroundColor:
                                const Color(0xFF2E7D32).withOpacity(0.1),
                            child: Icon(
                              category["icon"],
                              size: 30,
                              color: const Color(0xFF2E7D32),
                            ),
                          ),

                          const SizedBox(height: 10),

                          /// NAME
                          Text(
                            category["name"],
                            style: const TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}