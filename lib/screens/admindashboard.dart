import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  static const Color primaryColor = Color(0xFF0A3B2A);
  static const Color backgroundColor = Color(0xFFF5F0E6);

  int clientsCount = 0;
  int storesCount = 0;
  int productsCount = 0;
  int reservationsCount = 0;

  @override
  void initState() {
    super.initState();
    fetchDashboardData();
  }

  Future<void> fetchDashboardData() async {
    try {
      final clientsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/clients'),
      );

      final storesResponse = await http.get(
        Uri.parse('http://localhost:5000/api/stores'),
      );

      final productsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/products'),
      );

      final reservationsResponse = await http.get(
        Uri.parse('http://localhost:5000/api/reservations'),
      );

      if (clientsResponse.statusCode == 200) {
        final clients = jsonDecode(clientsResponse.body);

        setState(() {
          clientsCount = clients.length;
        });
      }

      if (storesResponse.statusCode == 200) {
        final stores = jsonDecode(storesResponse.body);

        setState(() {
          storesCount = stores.length;
        });
      }

      if (productsResponse.statusCode == 200) {
        final products = jsonDecode(productsResponse.body);

        setState(() {
          productsCount = products.length;
        });
      }

      if (reservationsResponse.statusCode == 200) {
        final reservations = jsonDecode(reservationsResponse.body);

        setState(() {
          reservationsCount = reservations.length;
        });
      }
    } catch (e) {
      print("ERROR: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: backgroundColor,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: backgroundColor,
        centerTitle: true,

        title: const Text(
          "Admin Dashboard",
          style: TextStyle(
            color: primaryColor,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'PlayfairDisplay',
          ),
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: const Icon(Icons.logout, color: primaryColor),
              onPressed: () {
                Navigator.pop(context);
              },
            ),
          ),
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(20),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [
            const SizedBox(height: 10),

            const Text(
              "Welcome Admin 👋",
              style: TextStyle(
                fontSize: 30,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Manage your application easily",
              style: TextStyle(
                fontSize: 15,
                color: Colors.grey.shade700,
              ),
            ),

            const SizedBox(height: 30),

            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                crossAxisSpacing: 18,
                mainAxisSpacing: 18,
                childAspectRatio: 1,

                children: [
                  buildCard(
                    context,
                    "Clients",
                    Icons.people_alt_rounded,
                    clientsCount.toString(),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ClientsPage(),
                        ),
                      );
                    },
                  ),

                  buildCard(
                    context,
                    "Stores",
                    Icons.storefront_rounded,
                    storesCount.toString(),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => StoresPage(),
                        ),
                      );
                    },
                  ),

                  buildCard(
                    context,
                    "Products",
                    Icons.shopping_bag_rounded,
                    productsCount.toString(),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ProductsPage(),
                        ),
                      );
                    },
                  ),

                  buildCard(
                    context,
                    "Reservations",
                    Icons.bookmark_rounded,
                    reservationsCount.toString(),
                    () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ReservationsPage(),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(
    BuildContext context,
    String title,
    IconData icon,
    String count,
    VoidCallback onTap,
  ) {
    return GestureDetector(
      onTap: onTap,

      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(28),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,

          children: [
            Container(
              padding: const EdgeInsets.all(18),

              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 42,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 18),

            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'PlayfairDisplay',
              ),
            ),

            const SizedBox(height: 10),

            Text(
              count,
              style: const TextStyle(
                fontSize: 32,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ================= CLIENTS PAGE =================

class ClientsPage extends StatelessWidget {
  ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildSimplePage(
      title: "Clients",
      icon: Icons.people_alt_rounded,
      text: "Liste des clients",
    );
  }
}

// ================= STORES PAGE =================

class StoresPage extends StatelessWidget {
  StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildSimplePage(
      title: "Stores",
      icon: Icons.storefront_rounded,
      text: "Liste des stores",
    );
  }
}

// ================= PRODUCTS PAGE =================

class ProductsPage extends StatelessWidget {
  ProductsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildSimplePage(
      title: "Products",
      icon: Icons.shopping_bag_rounded,
      text: "Liste des produits",
    );
  }
}

// ================= RESERVATIONS PAGE =================

class ReservationsPage extends StatelessWidget {
  ReservationsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return buildSimplePage(
      title: "Reservations",
      icon: Icons.bookmark_rounded,
      text: "Liste des réservations",
    );
  }
}

// ================= REUSABLE PAGE =================

Widget buildSimplePage({
  required String title,
  required IconData icon,
  required String text,
}) {
  const Color primaryColor = Color(0xFF0A3B2A);
  const Color backgroundColor = Color(0xFFF5F0E6);

  return Scaffold(
    backgroundColor: backgroundColor,

    appBar: AppBar(
      backgroundColor: backgroundColor,
      elevation: 0,
      centerTitle: true,

      iconTheme: const IconThemeData(color: primaryColor),

      title: Text(
        title,
        style: const TextStyle(
          color: primaryColor,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),
      ),
    ),

    body: Center(
      child: Container(
        margin: const EdgeInsets.all(20),
        padding: const EdgeInsets.all(30),

        decoration: BoxDecoration(
          color: Colors.white,

          borderRadius: BorderRadius.circular(30),

          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            Container(
              padding: const EdgeInsets.all(20),

              decoration: BoxDecoration(
                color: primaryColor.withValues(alpha: 0.1),
                shape: BoxShape.circle,
              ),

              child: Icon(
                icon,
                size: 55,
                color: primaryColor,
              ),
            ),

            const SizedBox(height: 25),

            Text(
              text,
              textAlign: TextAlign.center,

              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: primaryColor,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}