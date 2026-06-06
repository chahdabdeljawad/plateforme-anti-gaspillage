import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../lang.dart';

class LocationPickerPage extends StatefulWidget {
  final Function(Map<String, dynamic>) onConfirm;
  final VoidCallback onCancel;

  const LocationPickerPage({
    super.key,
    required this.onConfirm,
    required this.onCancel,
  });

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late MapController _mapController;
  LatLng _currentCenter = const LatLng(36.8065, 10.1815);
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    setState(() => _isLoading = true);
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _showErrorDialog("Location services are disabled. Please enable them.");
        return;
      }
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      if (permission == LocationPermission.deniedForever) {
        _showErrorDialog("Location permission denied permanently.");
        return;
      }
      final position = await Geolocator.getCurrentPosition();
      setState(() {
        _currentCenter = LatLng(position.latitude, position.longitude);
        _mapController.move(_currentCenter, 15);
      });
    } catch (e) {
      _showErrorDialog("Could not get your location: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _searchPlace() async {
    final query = _searchController.text.trim();
    if (query.isEmpty) return;

    setState(() => _isLoading = true);
    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/search?q=${Uri.encodeComponent(query)}&format=json&limit=1",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final List<dynamic> data = json.decode(response.body);
        if (data.isNotEmpty) {
          final lat = double.parse(data[0]['lat']);
          final lon = double.parse(data[0]['lon']);
          setState(() {
            _currentCenter = LatLng(lat, lon);
            _mapController.move(_currentCenter, 15);
          });
        } else {
          _showErrorDialog(
            "No places found for '$query'.\nTry a different name or use the map.",
          );
        }
      } else {
        _showErrorDialog(
          "Search failed (HTTP ${response.statusCode}). Check your internet.",
        );
      }
    } catch (e) {
      _showErrorDialog(
        "Search error: $e\nPlease check your internet connection.",
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<String?> _reverseGeocode(LatLng point) async {
    try {
      final url = Uri.parse(
        "https://nominatim.openstreetmap.org/reverse?lat=${point.latitude}&lon=${point.longitude}&format=json",
      );
      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final address = data['address'] as Map<String, dynamic>?;
        if (address != null) {
          return address['city'] ??
              address['town'] ??
              address['village'] ??
              address['county'] ??
              address['state'] ??
              address['country'] ??
              "Selected location";
        }
      }
      return null;
    } catch (e) {
      return null;
    }
  }

  Future<void> _confirmLocation() async {
    setState(() => _isLoading = true);
    try {
      String placeName = await _reverseGeocode(_currentCenter) ?? "";
      if (placeName.isEmpty) {
        placeName = await _manualNameEntry() ?? "";
        if (placeName.isEmpty) {
          setState(() => _isLoading = false);
          return;
        }
      }
      if (mounted) {
        widget.onConfirm({
          'lat': _currentCenter.latitude,
          'lng': _currentCenter.longitude,
          'name': placeName,
        });
      }
    } catch (e) {
      final manualName = await _manualNameEntry();
      if (manualName != null && mounted) {
        widget.onConfirm({
          'lat': _currentCenter.latitude,
          'lng': _currentCenter.longitude,
          'name': manualName,
        });
      } else {
        _showErrorDialog(
          "Could not determine location name.\nPlease try again.",
        );
        setState(() => _isLoading = false);
      }
    }
  }

  Future<String?> _manualNameEntry() async {
    final controller = TextEditingController();
    final lang = Provider.of<Lang>(context, listen: false);
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: Text(lang.t("location_name")),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(hintText: lang.t("location_name_hint")),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t("cancel")),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: Text(lang.t("confirm")),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    final lang = Provider.of<Lang>(context, listen: false);
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(lang.t("error")),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: Text(lang.t("ok")),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _searchController.dispose();
    _mapController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final lang = Provider.of<Lang>(context);
    final isDark = themeProvider.isDarkMode;
    final isRtl = lang.current == "ar";

    // ✅ Scaffold = fournit un Material ancestor (corrige l'erreur TextField)
    return Scaffold(
      backgroundColor: colors.surface,
      appBar: AppBar(
        backgroundColor: colors.primary,
        foregroundColor: colors.onPrimary,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: widget.onCancel,
        ),
        title: Text(
          lang.t("select_location"),
          style: const TextStyle(fontFamily: 'PlayfairDisplay'),
        ),
      ),
      body: SafeArea(
        child: Directionality(
          textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
          child: Column(
            children: [
              // Search Bar + Location Button
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
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 1),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintText: lang.t("search_city_placeholder"),
                            hintStyle: TextStyle(
                              color: colors.onSurface.withOpacity(0.5),
                            ),
                            prefixIcon:
                                Icon(Icons.search, color: colors.primary),
                            border: InputBorder.none,
                            contentPadding:
                                const EdgeInsets.symmetric(vertical: 10),
                          ),
                          style: TextStyle(color: colors.onSurface),
                          onSubmitted: (_) => _searchPlace(),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      flex: 2,
                      child: SizedBox(
                        height: 42,
                        child: ElevatedButton.icon(
                          onPressed: _getCurrentLocation,
                          icon: const Icon(Icons.my_location, size: 16),
                          label: Text(lang.t("use_current_location")),
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

              // MAP
              Expanded(
                child: FlutterMap(
                  mapController: _mapController,
                  options: MapOptions(
                    initialCenter: _currentCenter,
                    initialZoom: 13,
                    backgroundColor: isDark
                        ? const Color(0xFF121212)
                        : const Color(0xFFF5F0E6),
                    onTap: (_, latLng) {
                      setState(() {
                        _currentCenter = latLng;
                      });
                    },
                  ),
                  children: [
                    TileLayer(
                      urlTemplate: isDark
                          ? "https://cartodb-basemaps-a.global.ssl.fastly.net/dark_all/{z}/{x}/{y}.png"
                          : "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
                    ),
                    MarkerLayer(
                      markers: [
                        Marker(
                          point: _currentCenter,
                          width: 40,
                          height: 40,
                          child: const Icon(
                            Icons.location_pin,
                            color: Colors.red,
                            size: 40,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              // Confirm Button
              Padding(
                padding: const EdgeInsets.all(16),
                child: Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: _isLoading ? null : _confirmLocation,
                        icon: const Icon(Icons.check_circle),
                        label: Text(lang.t("confirm_location")),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: colors.primary,
                          foregroundColor: colors.onPrimary,
                          padding: const EdgeInsets.symmetric(vertical: 14),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
