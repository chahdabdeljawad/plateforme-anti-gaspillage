import 'package:flutter/material.dart';
import 'package:zerogaspi/screens/categorydetailspage.dart';
//import '../style/screens/categoriespage_style.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../components/footer.dart';
import '../lang.dart';
import '../providers/location_provider.dart';
import 'location_picker_page.dart';
import 'categorydetailspage.dart';


class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String searchQuery = "";

  @override
  void initState() {
    super.initState();
    // If no location is stored when the page loads, open the picker automatically
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      if (!locationProvider.hasLocation) {
        _openLocationPicker();
      }
    });
  }

  Future<void> _openLocationPicker() async {
    final result = await Navigator.push<Map<String, dynamic>>(
      context,
      MaterialPageRoute(builder: (_) => const LocationPickerPage()),
    );
    if (result != null && result.containsKey('lat')) {
      final locationProvider = Provider.of<LocationProvider>(
        context,
        listen: false,
      );
      locationProvider.setLocation(
        LatLng(result['lat'], result['lng']),
        result['name'],
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final isRtl = lang.current == "ar";

    // If still no location (user pressed back on picker), show a message + retry button
    if (!locationProvider.hasLocation) {
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: const Color(0xFFF5F0E6),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.location_off, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(lang.t("no_location_selected")),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _openLocationPicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF0A3B2A),
                  ),
                  child: Text(lang.t("select_location")),
                ),
              ],
            ),
          ),
        ),
      );
    }

    // Location exists – show the normal categories page
    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFF5F0E6),
        body: SafeArea(
          child: Column(
            children: [
              // Header with search bar + change maps button (now opens location picker)
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                child: Row(
                  children: [
                    // Search bar
                    Expanded(
                      flex: 3,
                      child: Container(
                        height: 42,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          onChanged: (value) {
                            setState(() {
                              searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: lang.t("search_hint"),
                            prefixIcon: const Icon(Icons.search, size: 18),
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    // Change maps button – now opens location picker
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: () async {
                            await _openLocationPicker();
                          },
                          icon: const Icon(Icons.map, size: 16),
                          label: Text(lang.t("change_maps")),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFF0A3B2A),
                            foregroundColor: Colors.white,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                            elevation: 0,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              // Scrollable content (original grids)
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      _buildSectionTitle(lang.t("large_stores")),
                      const SizedBox(height: 12),
                      _buildLargeStoresGrid(lang),
                      const SizedBox(height: 32),
                      _buildSectionTitle(lang.t("other_stores")),
                      const SizedBox(height: 12),
                      _buildSmallCategoriesGrid(lang),
                      const SizedBox(height: 40),
                      const AppFooter(),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ---------------------- ALL ORIGINAL HELPER METHODS REMAIN IDENTICAL ----------------------
  Widget _buildSectionTitle(String title) {
    return Text(
      title.toUpperCase(),
      style: const TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: Color(0xFF0A3B2A),
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLargeStoresGrid(Lang lang) {
    final List<Map<String, String?>> brands = [
      {'name': 'Carrefour', 'logo': 'assets/images/carrefour.png'},
      {'name': 'MG', 'logo': 'assets/images/mg.png'},
      {'name': 'Monoprix', 'logo': 'assets/images/monoprix.png'},
      {'name': 'Aziza', 'logo': 'assets/images/aziza.png'},
    ];

    final filtered = brands
        .where((b) => (b['name'] as String).toLowerCase().contains(searchQuery))
        .toList();

    if (filtered.isEmpty) {
      return Center(child: Text(lang.t("no_results")));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final brand = filtered[index];
        return _buildCard(
          onTap: () => _navigateToCategory(context, brand['name']!),
          child: Center(
            child: Image.asset(
              brand['logo']!,
              height: brand['name'] == 'Monoprix' ? 100 : 80,
              fit: BoxFit.contain,
              errorBuilder: (_, _, _) => const Icon(Icons.store, size: 35),
            ),
          ),
        );
      },
    );
  }

  Widget _buildSmallCategoriesGrid(Lang lang) {
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

    if (filtered.isEmpty) {
      return Center(child: Text(lang.t("no_results")));
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: filtered.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 4,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 1.0,
      ),
      itemBuilder: (context, index) {
        final cat = filtered[index];
        return _buildCard(
          onTap: () => _navigateToCategory(context, cat['title']!),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Image.asset(
                cat['image']!,
                fit: BoxFit.cover,
                errorBuilder: (_, _, _) =>
                    const Icon(Icons.image_not_supported, size: 35),
              ),
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Colors.transparent,
                      Colors.black.withValues(alpha: 0.7),
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomLeft,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Text(
                    cat['title']!,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCard({required VoidCallback onTap, required Widget child}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.zero,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: Offset(0, 1),
            ),
          ],
        ),
        child: child,
      ),
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
