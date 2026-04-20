import 'package:flutter/material.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    // 🔥 DATA REALISTE (Tunisie)
    final Map<String, List<Map<String, String>>> data = {
      'Carrefour': [
        {
          'name': 'Lait Délice 1L',
          'price': '1.400 DT',
          'promo': '1.100 DT',
          'image': 'assets/images/products/lait.png',
        },
        {
          'name': 'Huile Cristal 1L',
          'price': '8.500 DT',
          'promo': '7.200 DT',
          'image': 'assets/images/products/huile.png',
        },
        {
          'name': 'Pâtes Warda',
          'price': '1.200 DT',
          'promo': '0.950 DT',
          'image': 'assets/images/products/pates.png',
        },
      ],

      'MG': [
        {
          'name': 'Yaourt Vitalait',
          'price': '0.700 DT',
          'promo': '0.500 DT',
          'image': 'assets/images/products/yaourt.png',
        },
        {
          'name': 'Jus Boga',
          'price': '2.200 DT',
          'promo': '1.800 DT',
          'image': 'assets/images/products/jus.png',
        },
      ],

      'Monoprix': [
        {
          'name': 'Sandwich Thon',
          'price': '5 DT',
          'promo': '3.5 DT',
          'image': 'assets/images/products/sandwich.png',
        },
        {
          'name': 'Salade Fraîche',
          'price': '6 DT',
          'promo': '4 DT',
          'image': 'assets/images/products/salade.png',
        },
      ],

      'Aziza': [
        {
          'name': 'Biscuits Saida',
          'price': '1.800 DT',
          'promo': '1.200 DT',
          'image': 'assets/images/products/biscuit.png',
        },
        {
          'name': 'Chocolat Said',
          'price': '2.500 DT',
          'promo': '1.900 DT',
          'image': 'assets/images/products/choco.png',
        },
      ],

      // 🍽️ AUTRES
      'Restaurants': [
        {
          'name': 'Pizza Escalope',
          'price': '12 DT',
          'promo': '8 DT',
          'image': 'assets/images/products/pizzaa.png',
        },
        {
          'name': 'Burger + Frites',
          'price': '10 DT',
          'promo': '7 DT',
          'image': 'assets/images/products/burgeer.png',
        },
        {
          'name': 'Tacos',
          'price': '9 DT',
          'promo': '6.5 DT',
          'image': 'assets/images/products/tac.png',
        },
      ],

      'Boulangeries': [
        {
          'name': 'Baguette',
          'price': '0.500 DT',
          'promo': '0.350 DT',
          'image': 'assets/images/products/pain.png',
        },
        {
          'name': 'Croissant',
          'price': '1.200 DT',
          'promo': '0.900 DT',
          'image': 'assets/images/products/croi.png',
        },
      ],

      'Pâtisseries': [
        {
          'name': 'Gâteau',
          'price': '18 DT',
          'promo': '12 DT',
          'image': 'assets/images/products/gateauu.png',
        },
        {
          'name': 'Tarte fruits',
          'price': '9 DT',
          'promo': '5 DT',
          'image': 'assets/images/products/tarte.png',
        },
      ],

      'Poissonneries': [
        {
          'name': 'Dorade 1kg',
          'price': '28 DT',
          'promo': '22 DT',
          'image': 'assets/images/products/dorade.png',
        },
      ],

      'Fromageries': [
        {
          'name': 'Fromage frais',
          'price': '6 DT',
          'promo': '4.5 DT',
          'image': 'assets/images/products/fromaage.png',
        },
      ],

      'Primeurs': [
        {
          'name': 'Panier légumes',
          'price': '10 DT',
          'promo': '7 DT',
          'image': 'assets/images/products/legumes.png',
        },
        {
          'name': 'Fruits mix',
          'price': '12 DT',
          'promo': '9 DT',
          'image': 'assets/images/products/fruit.png',
        },
      ],

      'Petits commerces': [
        {
          'name': 'Café Express',
          'price': '1.200 DT',
          'promo': '1 DT',
          'image': 'assets/images/products/cafe.png',
        },
        {
          'name': 'Œufs (6)',
          'price': '3.5 DT',
          'promo': '2.8 DT',
          'image': 'assets/images/products/oeufs.png',
        },
      ],
    };

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
                crossAxisCount: 5,
                crossAxisSpacing: 8,
                mainAxisSpacing: 8,
                childAspectRatio: 1,
              ),

              itemBuilder: (context, index) {
                final item = products[index];

                return Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    image: DecorationImage(
                      image: AssetImage(item['image']!),
                      fit: BoxFit.cover,
                    ),
                  ),

                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      gradient: LinearGradient(
                        colors: [
                          Colors.transparent,
                          Colors.black.withValues(alpha: 0.8),
                        ],
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                      ),
                    ),

                    padding: const EdgeInsets.all(10),

                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item['name']!,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 14,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Row(
                          children: [
                            Text(
                              item['price']!,
                              style: const TextStyle(
                                color: Colors.white70,
                                decoration: TextDecoration.lineThrough,
                                fontSize: 12,
                              ),
                            ),

                            const SizedBox(width: 6),

                            Text(
                              item['promo']!,
                              style: const TextStyle(
                                color: Colors.greenAccent,
                                fontWeight: FontWeight.bold,
                                fontSize: 13,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
