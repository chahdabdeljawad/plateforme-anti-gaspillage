import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {

    // 🔥 DATA حسب catégorie
    final Map<String, List<Map<String, String>>> data = {
      'Carrefour': [
        {'name': 'Pack lait', 'price': '6 DT', 'promo': '-20%', 'emoji': '🥛'},
        {'name': 'Riz', 'price': '3 DT', 'promo': '-15%', 'emoji': '🍚'},
        {'name': 'Huile', 'price': '8 DT', 'promo': '-10%', 'emoji': '🛢️'},
        {'name': 'Pâtes', 'price': '2 DT', 'promo': '-5%', 'emoji': '🍝'},
      ],

      'MG': [
        {'name': 'Yaourt', 'price': '1 DT', 'promo': '-30%', 'emoji': '🍶'},
        {'name': 'Jus', 'price': '2.5 DT', 'promo': '-25%', 'emoji': '🧃'},
        {'name': 'Fromage', 'price': '5 DT', 'promo': '-15%', 'emoji': '🧀'},
      ],

      'Monoprix': [
        {'name': 'Panier légumes', 'price': '5 DT', 'promo': '-50%', 'emoji': '🥬'},
        {'name': 'Sandwich', 'price': '3 DT', 'promo': '-40%', 'emoji': '🥪'},
        {'name': 'Salade', 'price': '4 DT', 'promo': '-35%', 'emoji': '🥗'},
        {'name': 'Poulet rôti', 'price': '12 DT', 'promo': '-20%', 'emoji': '🍗'},
      ],

      'Aziza': [
        {'name': 'Biscuits', 'price': '1.5 DT', 'promo': '-20%', 'emoji': '🍪'},
        {'name': 'Chocolat', 'price': '2 DT', 'promo': '-15%', 'emoji': '🍫'},
        {'name': 'Bonbons', 'price': '1 DT', 'promo': '-10%', 'emoji': '🍬'},
      ],

      // 🍽️ AUTRES
      'Restaurants': [
        {'name': 'Pizza', 'price': '8 DT', 'promo': '-30%', 'emoji': '🍕'},
        {'name': 'Burger', 'price': '7 DT', 'promo': '-25%', 'emoji': '🍔'},
        {'name': 'Tacos', 'price': '6 DT', 'promo': '-20%', 'emoji': '🌮'},
      ],

      'Boulangeries': [
        {'name': 'Pain', 'price': '0.5 DT', 'promo': '-20%', 'emoji': '🥖'},
        {'name': 'Croissant', 'price': '1 DT', 'promo': '-15%', 'emoji': '🥐'},
      ],

      'Pâtisseries': [
        {'name': 'Gâteau', 'price': '6 DT', 'promo': '-40%', 'emoji': '🍰'},
        {'name': 'Tarte', 'price': '5 DT', 'promo': '-30%', 'emoji': '🥧'},
      ],

      'Petits commerces': [
        {'name': 'Lait local', 'price': '1.2 DT', 'promo': '-10%', 'emoji': '🥛'},
        {'name': 'Œufs', 'price': '3 DT', 'promo': '-15%', 'emoji': '🥚'},
        {'name': 'Café', 'price': '1 DT', 'promo': '-5%', 'emoji': '☕'},
      ],
    };

    // ✅ نجيب produits حسب catégorie
    final products = data[categoryName] ?? [];

    return Scaffold(
      appBar: AppBar(
        title: Text(categoryName),
        backgroundColor: const Color(0xFF1D9E75),
      ),
      body: products.isEmpty
          ? const Center(child: Text("Aucun produit disponible"))
          : GridView.builder(
              padding: const EdgeInsets.all(12),
              itemCount: products.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),
              itemBuilder: (context, index) {
                final item = products[index];

                return Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(
                        color: const Color(0xFFE0E0E0), width: 0.5),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.03),
                        blurRadius: 5,
                        offset: const Offset(0, 2),
                      )
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(item['emoji']!,
                          style: const TextStyle(fontSize: 30)),

                      const SizedBox(height: 8),

                      Text(
                        item['name']!,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),

                      const SizedBox(height: 4),

                      Text(
                        item['price']!,
                        style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 12,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: Colors.green.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          item['promo']!,
                          style: const TextStyle(
                            color: Colors.green,
                            fontWeight: FontWeight.bold,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
    );
  }
}