import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final colors = Theme.of(context).colorScheme;
    final themeProvider = Provider.of<ThemeProvider>(context);

    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: colors.surface,
        centerTitle: true,
        title: Text(
          "Admin Dashboard",
          style: TextStyle(
            color: colors.primary,
            fontWeight: FontWeight.bold,
            fontSize: 24,
            fontFamily: 'PlayfairDisplay',
          ),
        ),
        actions: [
          IconButton(
            icon: Icon(
              themeProvider.isDarkMode ? Icons.light_mode : Icons.dark_mode,
              color: colors.primary,
            ),
            onPressed: themeProvider.toggleTheme,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 12),
            child: IconButton(
              icon: Icon(Icons.logout, color: colors.primary),
              onPressed: () => Navigator.pop(context),
            ),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 8),
            Text(
              "Welcome Admin 👋",
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                fontFamily: 'PlayfairDisplay',
                color: colors.primary,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              "Manage your application easily",
              style: TextStyle(
                fontSize: 14,
                color: colors.onSurface.withOpacity(0.6),
              ),
            ),
            const SizedBox(height: 24),
            Expanded(
              child: GridView.count(
                crossAxisCount: 3,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.85,
                children: [
                  buildCard(
                    context,
                    "Clients",
                    Icons.people_alt_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const ClientsPage()),
                    ),
                  ),
                  buildCard(
                    context,
                    "Stores",
                    Icons.storefront_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const StoresPage()),
                    ),
                  ),
                  buildCard(
                    context,
                    "Products",
                    Icons.shopping_bag_rounded,
                    () => Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => const CategoriesPage()),
                    ),
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
    final colors = Theme.of(context).colorScheme;

    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(20),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 8,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 32, color: colors.primary),
            ),
            const SizedBox(height: 14),
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: colors.primary,
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
      context: context, // ✅ Pass context
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
      context: context, // ✅ Pass context
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
      context: context, // ✅ Pass context
      title: "Products",
      icon: Icons.shopping_bag_rounded,
      text: "Liste des catégories",
    );
  }
}

// ================= REUSABLE PAGE (Fixed) =================

Widget buildSimplePage({
  required BuildContext context, // ✅ Accept context
  required String title,
  required IconData icon,
  required String text,
}) {
  final colors = Theme.of(context).colorScheme; // ✅ Now context is valid

  return Scaffold(
    backgroundColor: colors.surface,
    appBar: AppBar(
      backgroundColor: colors.surface,
      elevation: 0,
      centerTitle: true,
      iconTheme: IconThemeData(color: colors.primary),
      title: Text(
        title,
        style: TextStyle(
          color: colors.primary,
          fontWeight: FontWeight.bold,
          fontFamily: 'PlayfairDisplay',
        ),
      ),
    ),
    body: Center(
      child: Container(
        margin: const EdgeInsets.all(16),
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: colors.surface,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: colors.primary.withOpacity(0.12),
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 44, color: colors.primary),
            ),
            const SizedBox(height: 20),
            Text(
              text,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: colors.primary,
                fontFamily: 'PlayfairDisplay',
              ),
            ),
          ],
        ),
      ),
    ),
  );
}