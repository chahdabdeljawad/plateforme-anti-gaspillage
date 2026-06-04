import 'package:flutter/material.dart';
// ❌ Supprimer l'import inutile : import 'package:zerogaspi/screens/categorydetailspage.dart';
import 'package:zerogaspi/screens/reservationpage.dart';
import 'package:zerogaspi/screens/paymentpage.dart';
import 'package:provider/provider.dart';
import 'package:latlong2/latlong.dart';
import '../components/footer.dart';
import '../lang.dart';
import '../providers/location_provider.dart';
import 'location_picker_page.dart';
import 'package:flutter/foundation.dart';
import 'categorydetailspage.dart';     

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  String searchQuery = "";
  String? selectedCategory;
  bool _showLocationPicker = false;

  // Stocke toutes les infos du produit sélectionné
  Map<String, dynamic>? _selectedProduct;

  void _openReservation(
    Map<String, dynamic> product,
    Map<String, dynamic> store,
  ) {
    setState(() {
      _selectedProduct = {
        'productId': product['id'] ?? 0,
        'clientId': 0, // À récupérer depuis SharedPreferences ou provider
        'productName': product['name'],
        'price': product['promo'],
        'oldPrice': product['price'] ?? '',
        'description': product['description'] ?? '',
        'image': product['image'],
        'lat': store['lat'],
        'lng': store['lng'],
        'storeName': store['name'],
        'time': product['time'] ?? '18:00',
      };
    });
  }

  Map<String, dynamic>? _paymentDetails;

  void _openPayment(Map<String, dynamic> details) {
    // details provient de ReservationPage (contenant toutes les données)
    setState(() {
      _paymentDetails = details;
    });
  }

  void _closePayment() {
    setState(() {
      _paymentDetails = null;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _openLocationPicker();
    });
  }

  void _openLocationPicker() {
    setState(() {
      _showLocationPicker = true;
    });
  }

  void _onLocationConfirmed(Map<String, dynamic> result) {
    setState(() {
      _showLocationPicker = false;
    });
    if (result.containsKey('lat')) {
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

  void _navigateToCategory(String categoryName) {
    setState(() {
      selectedCategory = categoryName;
    });
  }

  void _goBackToGrid() {
    setState(() {
      selectedCategory = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final locationProvider = Provider.of<LocationProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final isRtl = lang.current == "ar";

    if (!locationProvider.hasLocation && !_showLocationPicker) {
      return Directionality(
        textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
        child: Scaffold(
          backgroundColor: colors.surface,
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(Icons.location_off, size: 80, color: Colors.grey),
                const SizedBox(height: 16),
                Text(
                  lang.t("no_location_selected"),
                  style: TextStyle(color: colors.onSurface),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: _openLocationPicker,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: colors.primary,
                    foregroundColor: colors.onPrimary,
                  ),
                  child: Text(lang.t("select_location")),
                ),
              ],
            ),
          ),
        ),
      );
    }

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: colors.surface,
        body: SafeArea(
          child: Column(
            children: [
              // Barre de recherche et bouton carte
              if (!_showLocationPicker &&
                  _selectedProduct == null &&
                  _paymentDetails == null) ...[
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
                  child: Row(
                    children: [
                      Expanded(
                        flex: 3,
                        child: Container(
                          height: 42,
                          decoration: BoxDecoration(
                            color: colors.surface,
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.04), // ✅ withOpacity remplacé
                                blurRadius: 4,
                                offset: const Offset(0, 1),
                              ),
                            ],
                          ),
                          child: TextField(
                            onChanged: (value) => setState(
                              () => searchQuery = value.toLowerCase(),
                            ),
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
                      Expanded(
                        flex: 2,
                        child: SizedBox(
                          height: 42,
                          child: ElevatedButton.icon(
                            onPressed: _openLocationPicker,
                            icon: const Icon(Icons.map, size: 16),
                            label: Text(lang.t("change_maps")),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: colors.primary,
                              foregroundColor: colors.onPrimary,
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
              ],

              // Zone de contenu : paiement, réservation, localisation, catégories
              Expanded(
                child: _paymentDetails != null
                    ? PaymentPage(
                        productId: _paymentDetails!['productId'] ?? 0,
                        clientId: _paymentDetails!['clientId'] ?? 0,
                        productName: _paymentDetails!['productName'],
                        price: _paymentDetails!['price'],
                        oldPrice: _paymentDetails!['oldPrice'] ?? '',
                        description: _paymentDetails!['description'] ?? '',
                        storeName: _paymentDetails!['storeName'],
                        pickupTime: _paymentDetails!['time'],
                        deliveryType: _paymentDetails!['deliveryType'],
                        onBack: _closePayment,
                      )
                    : _selectedProduct != null
                    ? ReservationPage(
                        productId: _selectedProduct!['productId'] ?? 0,
                        clientId: _selectedProduct!['clientId'] ?? 0,
                        productName: _selectedProduct!['productName'],
                        price: _selectedProduct!['price'],
                        oldPrice: _selectedProduct!['oldPrice'],
                        description: _selectedProduct!['description'],
                        image: _selectedProduct!['image'],
                        lat: _selectedProduct!['lat'],
                        lng: _selectedProduct!['lng'],
                        storeName: _selectedProduct!['storeName'],
                        time: _selectedProduct!['time'],
                        onBack: () => setState(() => _selectedProduct = null),
                        onConfirm: (Map<String, dynamic> data) {
                          // data est ce que ReservationPage envoie (probablement toutes les données)
                          _openPayment(data);
                        },
                      )
                    : _showLocationPicker
                    ? LocationPickerPage(
                        onConfirm: _onLocationConfirmed,
                        onCancel: () =>
                            setState(() => _showLocationPicker = false),
                      )
                    : selectedCategory == null
                    ? _buildGridContent(lang, colors)
                    : CategoryDetailsPage(
                        categoryName: selectedCategory!,
                        onBack: _goBackToGrid,
                        onReserve: _openReservation,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGridContent(Lang lang, ColorScheme colors) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionTitle(lang.t("large_stores"), colors),
          const SizedBox(height: 12),
          _buildLargeStoresGrid(lang, colors),
          const SizedBox(height: 32),
          _buildSectionTitle(lang.t("other_stores"), colors),
          const SizedBox(height: 12),
          _buildSmallCategoriesGrid(lang, colors),
          const SizedBox(height: 40),
          const AppFooter(),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title, ColorScheme colors) {
    return Text(
      title.toUpperCase(),
      style: TextStyle(
        fontFamily: 'PlayfairDisplay',
        fontSize: 18,
        fontWeight: FontWeight.bold,
        color: colors.primary,
        letterSpacing: 1.2,
      ),
    );
  }

  Widget _buildLargeStoresGrid(Lang lang, ColorScheme colors) {
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
      return Center(
        child: Text(
          lang.t("no_results"),
          style: TextStyle(color: colors.onSurface),
        ),
      );
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
          onTap: () => _navigateToCategory(brand['name']!),
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

  Widget _buildSmallCategoriesGrid(Lang lang, ColorScheme colors) {
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
      return Center(
        child: Text(
          lang.t("no_results"),
          style: TextStyle(color: colors.onSurface),
        ),
      );
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
          onTap: () => _navigateToCategory(cat['title']!),
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
                    colors: [Colors.transparent, Colors.black.withValues(alpha: 0.7)], // ✅ withOpacity remplacé
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
    final colors = Theme.of(context).colorScheme;
    return GestureDetector(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: colors.surface,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: child,
      ),
    );
  }
}
