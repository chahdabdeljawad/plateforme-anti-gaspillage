import 'package:flutter/material.dart';
import 'package:zerogaspi/screens/categorydetailspage.dart';
import '../components/navbar.dart';
import 'categorydetailspage.dart';
import '../style/screens/categoriespage_style.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _buildSectionLabel('Grandes surfaces'),
                    const SizedBox(height: 10),
                    _buildGrandesSurfacesGrid(context),

                    const SizedBox(height: 20),

                    _buildSectionLabel('Autres commerces'),
                    const SizedBox(height: 10),
                    _buildSmallCategoriesGrid(context),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // 🔍 APPBAR + SEARCH
  Widget _buildAppBar() {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                radius: 14,
                backgroundColor: const Color(0xFF1D9E75),
                child: const Text('Z', style: TextStyle(color: Colors.white)),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const [
                  Text(
                    'Catégories',
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  Text(
                    'Trouve les meilleures offres',
                    style: TextStyle(fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 10),

          TextField(
            onChanged: (value) {
              setState(() {
                searchQuery = value.toLowerCase();
              });
            },
            decoration: InputDecoration(
              hintText: 'Rechercher...',
              prefixIcon: const Icon(Icons.search),
              filled: true,
              fillColor: const Color(0xFFF5F5F5),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(20),
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label.toUpperCase(),
      style: const TextStyle(
        fontSize: 12,
        fontWeight: FontWeight.w600,
        color: Colors.grey,
      ),
    );
  }

  // 🛒 GRANDES SURFACES (LOGOS ONLY + MONOPRIX BIGGER)
  Widget _buildGrandesSurfacesGrid(BuildContext context) {
    final List<Map<String, String?>> brands = [
      {'name': 'Carrefour', 'logo': 'assets/images/carrefour.png'},
      {'name': 'MG', 'logo': 'assets/images/mg.png'},
      {'name': 'Monoprix', 'logo': 'assets/images/monoprix.png'},
      {'name': 'Aziza', 'logo': 'assets/images/aziza.png'},
    ];

    final filtered = brands
        .where((b) => (b['name'] as String).toLowerCase().contains(searchQuery))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5,
        crossAxisSpacing: 6,
        mainAxisSpacing: 6,
        childAspectRatio: 1.3,
      ),
      itemBuilder: (context, index) {
        final brand = filtered[index];

        return GestureDetector(
          onTap: () => _navigateToCategory(context, brand['name'] as String),
          child: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFFE0E0E0), width: 0.5),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.03),
                  blurRadius: 6,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Center(
              child: Image.asset(
                brand['logo']!,
                height: brand['name'] == 'Monoprix' ? 150 : 100,
                fit: BoxFit.contain,
                errorBuilder: (_, __, ___) {
                  return const Icon(Icons.store, size: 35);
                },
              ),
            ),
          ),
        );
      },
    );
  }

  // 🍽️ AUTRES CATEGORIES
  Widget _buildSmallCategoriesGrid(BuildContext context) {
    final List<Map<String, String>> categories = [
      {'title': 'Restaurants', 'image': 'assets/images/res.png'},
      {'title': 'Boulangeries', 'image': 'assets/images/boulangerie.png'},
      {'title': 'Pâtisseries', 'image': 'assets/images/wittamer.png'},
      {'title': 'Poissonneries', 'image': 'assets/images/pois.png'},
      {'title': 'Fromageries', 'image': 'assets/images/fromage.png'},
      {'title': 'Primeurs', 'image': 'assets/images/legume.png'},
      {
        'title': 'Petits commerces',
        'image': 'assets/images/petits_commerces.png',
      },
    ];

    final filtered = categories
        .where((c) => c['title']!.toLowerCase().contains(searchQuery))
        .toList();

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 5, 
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
        childAspectRatio: 1,
      ),
      itemBuilder: (context, index) {
        final cat = filtered[index];

        return GestureDetector(
          onTap: () => _navigateToCategory(context, cat['title']!),
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: AssetImage(cat['image']!),
                fit: BoxFit.cover,
                onError: (_, __) {
                  print("Image not found: ${cat['image']}");
                },
              ),
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: [Colors.transparent, Colors.black.withOpacity(0.7)],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ),
              ),
              padding: const EdgeInsets.all(8),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Text(
                  cat['title']!,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  void _navigateToCategory(BuildContext context, String categoryName) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => CategoryDetailsPage(categoryName: categoryName),
      ),
    );
  }
}
