import 'package:flutter/material.dart';
import 'reservationpage.dart';

class CategoryDetailsPage extends StatelessWidget {
  final String categoryName;

  const CategoryDetailsPage({super.key, required this.categoryName});

  @override
  Widget build(BuildContext context) {
    /// STORES kébili
    final Map<String, Map<String, dynamic>> stores = {
      'Carrefour': {'lat': 33.705, 'lng': 8.969, 'name': 'Carrefour Kébili'},
      'MG': {'lat': 33.707, 'lng': 8.971, 'name': 'MG Kébili'},
      'Monoprix': {'lat': 33.706, 'lng': 8.968, 'name': 'Monoprix Kébili'},
      'Aziza': {'lat': 33.704, 'lng': 8.970, 'name': 'Aziza Kébili'},
      'Restaurants': {'lat': 33.708, 'lng': 8.972, 'name': 'Restaurant Kébili'},
      'Boulangeries': {
        'lat': 33.709,
        'lng': 8.973,
        'name': 'Boulangerie Kébili',
      },
      'Pâtisseries': {'lat': 33.710, 'lng': 8.974, 'name': 'Pâtisserie Kébili'},
      'Poissonneries': {
        'lat': 33.703,
        'lng': 8.967,
        'name': 'Poissonnerie Kébili',
      },
      'Fromageries': {'lat': 33.702, 'lng': 8.966, 'name': 'Fromagerie Kébili'},
      'Primeurs': {'lat': 33.701, 'lng': 8.965, 'name': 'Primeur Kébili'},
      'Petits commerces': {
        'lat': 33.700,
        'lng': 8.964,
        'name': 'Commerce Kébili',
      },
    };

    /// PRODUITS
    final Map<String, List<Map<String, String>>> data = {
      'Carrefour': [
        {
          'name': 'Pack 6 Lait Délice 1L',
          'price': '8.100 DT',
          'promo': '4.000 DT',
          'image': 'images/products/lait.png',
          'time': '18:00',
        },
        {
          'name': 'Huile Cristal 1L',
          'price': '8.500 DT',
          'promo': '4.200 DT',
          'image': 'images/products/huile.png',
          'time': '19:00',
        },
        {
          'name': 'Pâtes Warda',
          'price': '0.800 DT',
          'promo': '0.350 DT',
          'image': 'images/products/pates.png',
          'time': '17:30',
        },
      ],

      'MG': [
        {
          'name': 'Yaourt Vitalait',
          'price': '0.550 DT',
          'promo': '0.200 DT',
          'image': 'images/products/yaourt.png',
          'time': '18:30',
        },
        {
          'name': 'Jus Delice',
          'price': '3.600 DT',
          'promo': '1.800 DT',
          'image': 'images/products/jus.png',
          'time': '19:30',
        },
      ],

      'Monoprix': [
        {
          'name': 'Sandwich Thon',
          'price': '5 DT',
          'promo': '3.5 DT',
          'image': 'images/products/sandwich.png',
          'time': '12:00',
        },
        {
          'name': 'Salade Fraîche',
          'price': '6 DT',
          'promo': '4 DT',
          'image': 'images/products/salade.png',
          'time': '17:00',
        },
      ],

      'Aziza': [
        {
          'name': 'Biscuits Saida',
          'price': '1.800 DT',
          'promo': '0.700 DT',
          'image': 'images/products/biscuit.png',
          'time': '18:00',
        },
        {
          'name': 'Chocolat Said',
          'price': '2.500 DT',
          'promo': '1.000 DT',
          'image': 'images/products/choco.png',
          'time': '16:30',
        },
      ],

      // 🍽️ AUTRES
      'Restaurants': [
        {
          'name': 'Pizza Escalope',
          'price': '12 DT',
          'promo': '6 DT',
          'image': 'images/products/pizzaa.png',
          'time': '17:00',
        },
        {
          'name': 'Burger + Frites',
          'price': '10 DT',
          'promo': '5 DT',
          'image': 'images/products/burgeer.png',
          'time': '13:30',
        },
        {
          'name': 'Tacos',
          'price': '9 DT',
          'promo': '3 DT',
          'image': 'images/products/tac.png',
          'time': '18:00',
        },
      ],

      'Boulangeries': [
        {
          'name': 'Baguette',
          'price': '0.250 DT',
          'promo': '0.100 DT',
          'image': 'images/products/baguette.png',
          'time': '20:30',
        },
        {
          'name': 'Croissant',
          'price': '1.200 DT',
          'promo': '0.500 DT',
          'image': 'images/products/croi.png',
          'time': '19:30',
        },
        {
          'name': 'Pain complet',
          'price': '0.800 DT',
          'promo': '0.300 DT',
          'image': 'images/products/pain_complett.png',
          'time': '17:30',
        },
      ],

      'Pâtisseries': [
        {
          'name': 'Gâteau',
          'price': '8 DT',
          'promo': '3 DT',
          'image': 'images/products/gateauu.png',
          'time': '15:30',
        },
        {
          'name': 'Tarte fruits',
          'price': '9 DT',
          'promo': '3 DT',
          'image': 'images/products/tarte.png',
          'time': '16:00',
        },
        {
          'name': 'Millefeuille',
          'price': '3.000 DT',
          'promo': '1.000 DT',
          'image': 'images/products/millefeuille.png',
          'time': '16:30',
        },
        {
          'name': 'Pack hlou 1kg',
          'price': '70.000 DT',
          'promo': '30.000 DT',
          'image': 'images/products/hlow.png',
          'time': '17:00',
        },
        {
          'name': 'Pack tiramisu 6 pièces variées',
          'price': '36.000 DT',
          'promo': '16.000 DT',
          'image': 'images/products/paquet-tiramisus-varies.png',
          'time': '17:30',
        },
      ],

      'Poissonneries': [
        {
          'name': 'Dorade 1kg',
          'price': '28 DT',
          'promo': '10 DT',
          'image': 'images/products/dorade.png',
          'time': '14:30',
        },
        {
          'name': 'Sardine',
          'price': '7.000 DT/kg',
          'promo': '2.500 DT/kg',
          'image': 'images/products/sardine.png',
          'time': '14:30',
        },
        {
          'name': 'Crevettes',
          'price': '22.000 DT/kg',
          'promo': '12.000 DT/kg',
          'image': 'images/products/crevettes.png',
          'time': '14:30',
        },
        {
          'name': 'Calamar',
          'price': '19.000 DT/kg',
          'promo': '8.000 DT/kg',
          'image': 'images/products/calamar.png',
          'time': '16:30',
        },
      ],

      'Fromageries': [
        {
          'name': 'Fromage frais',
          'price': '6 DT',
          'promo': '2 DT',
          'image': 'images/products/fromaage.png',
          'time': '17:00',
        },
        {
          'name': 'Yaourt 1 litre',
          'price': '2.500 DT',
          'promo': '1.000 DT',
          'image': 'images/products/yaourt.png',
          'time': '17:00',
        },
        {
          'name': 'Lben (1L)',
          'price': '3.500 DT',
          'promo': '1.500 DT',
          'image': 'images/products/lben.png',
          'time': '16:30',
        },
        {
          'name': 'Lait frais (1L)',
          'price': '1.700 DT',
          'promo': '0.900 DT',
          'image': 'images/products/lait.png',
          'time': '16:00',
        },
        {
          'name': 'Raïeb (1L)',
          'price': '3.500 DT',
          'promo': '1.500 DT',
          'image': 'images/products/raieb.png',
          'time': '16:00',
        },
        {
          'name': 'Ricotta (100g)',
          'price': '5.000 DT',
          'promo': '2.000 DT',
          'image': 'images/products/gouta.png',
          'time': '16:30',
        },
      ],

      'Primeurs': [
        {
          'name': 'Panier légumes',
          'price': '10 DT',
          'promo': '4 DT',
          'image': 'images/products/legumes.png',
          'time': '15:30',
        },
        {
          'name': 'Fruits mix',
          'price': '12 DT',
          'promo': '5 DT',
          'image': 'images/products/fruit.png',
          'time': '17:30',
        },
      ],

      'Petits commerces': [
        {
          'name': 'Café Express',
          'price': '1.200 DT',
          'promo': '1 DT',
          'image': 'images/products/cafe.png',
          'time': '19:30',
        },
        {
          'name': 'Œufs (6)',
          'price': '3.5 DT',
          'promo': '2.8 DT',
          'image': 'images/products/oeufs.png',
          'time': '17:30',
        },
      ],
    };

    final products = data[categoryName] ?? [];
    final store = stores[categoryName];
    if (store == null) {
      return const Center(child: Text("Store not found"));
    }

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

                return InkWell(
                  borderRadius: BorderRadius.circular(15),

                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ReservationPage(
                          productName: item['name']!,
                          price: item['promo']!,
                          image: item['image']!,
                          lat: store['lat'],
                          lng: store['lng'],
                          storeName: store['name'],
                          time: item['time'] ?? "18:00",
                        ),
                      ),
                    );
                  },
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: DecorationImage(
                        image: AssetImage(item['image'] ?? ''),
                        fit: BoxFit.cover,
                        onError: (_, __) {},
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
                  ),
                );
              },
            ),
    );
  }
}
