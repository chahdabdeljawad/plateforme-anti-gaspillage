import 'package:flutter/material.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Admin Dashboard"),
        backgroundColor: Colors.green,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              Navigator.pop(context);
            },
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          children: [
            buildCard(
              context,
              "Clients",
              Icons.people,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const ClientsPage()),
                );
              },
            ),
            buildCard(
              context,
              "Stores",
              Icons.store,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const StoresPage()),
                );
              },
            ),
            buildCard(
              context,
              "Products",
              Icons.shopping_bag,
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const CategoriesPage()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget buildCard(BuildContext context, String title, IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 6,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 50, color: Colors.green),
            const SizedBox(height: 10),
            Text(title, style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          ],
        ),
      ),
    );
  }
}

// صفحات مؤقتة
class ClientsPage extends StatelessWidget {
  const ClientsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Clients")),
      body: const Center(child: Text("Liste des clients 👥")),
    );
  }
}

class StoresPage extends StatelessWidget {
  const StoresPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Stores")),
      body: const Center(child: Text("Liste des stores 🏪")),
    );
  }
}

class CategoriesPage extends StatelessWidget {
  const CategoriesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Categories")),
      body: const Center(child: Text("Liste des catégories 📦")),
    );
  }
}