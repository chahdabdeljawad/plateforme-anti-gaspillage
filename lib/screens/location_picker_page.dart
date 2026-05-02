import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:http/http.dart' as http;

class LocationPickerPage extends StatefulWidget {
  const LocationPickerPage({super.key});

  @override
  State<LocationPickerPage> createState() => _LocationPickerPageState();
}

class _LocationPickerPageState extends State<LocationPickerPage> {
  late MapController _mapController;
  LatLng _currentCenter = const LatLng(36.8065, 10.1815); // Tunis
  final TextEditingController _searchController = TextEditingController();
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    _getCurrentLocation();
  }

  // ------------------------------------------------------------------
  // GET CURRENT LOCATION (GPS)
  // ------------------------------------------------------------------
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

  // ------------------------------------------------------------------
  // SEARCH USING OPENSTREETMAP NOMINATIM (NO API KEY)
  // ------------------------------------------------------------------
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

  // ------------------------------------------------------------------
  // REVERSE GEOCODING USING NOMINATIM
  // ------------------------------------------------------------------
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
          // Prefer city/town/village, then county, then state
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

  // ------------------------------------------------------------------
  // CONFIRM LOCATION (with fallback to manual name)
  // ------------------------------------------------------------------
  Future<void> _confirmLocation() async {
    setState(() => _isLoading = true);
    try {
      String placeName = await _reverseGeocode(_currentCenter) ?? "";
      if (placeName.isEmpty) {
        // No geocoding result -> ask user to enter a name
        placeName = await _manualNameEntry() ?? "";
        if (placeName.isEmpty) {
          setState(() => _isLoading = false);
          return;
        }
      }
      // Return the location
      if (mounted) {
        Navigator.pop(context, {
          'lat': _currentCenter.latitude,
          'lng': _currentCenter.longitude,
          'name': placeName,
        });
      }
    } catch (e) {
      // Final fallback: manual entry
      final manualName = await _manualNameEntry();
      if (manualName != null && mounted) {
        Navigator.pop(context, {
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

  // ------------------------------------------------------------------
  // MANUAL ENTRY DIALOG
  // ------------------------------------------------------------------
  Future<String?> _manualNameEntry() async {
    final controller = TextEditingController();
    return showDialog<String>(
      context: context,
      barrierDismissible: false,
      builder: (ctx) => AlertDialog(
        title: const Text("Location name"),
        content: TextField(
          controller: controller,
          decoration: const InputDecoration(
            hintText: "e.g., Downtown Tunis, Carthage, La Marsa",
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("Cancel"),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, controller.text.trim()),
            child: const Text("Confirm"),
          ),
        ],
      ),
    );
  }

  void _showErrorDialog(String message) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text("Error"),
        content: Text(message),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text("OK"),
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),
      appBar: AppBar(
        title: const Text("Choose your location"),
        backgroundColor: const Color(0xFF0A3B2A),
        foregroundColor: Colors.white,
        elevation: 0,
        actions: [
          // Manual entry button in app bar
          TextButton.icon(
            onPressed: _isLoading
                ? null
                : () async {
                    final name = await _manualNameEntry();
                    if (name != null && mounted) {
                      Navigator.pop(context, {
                        'lat': _currentCenter.latitude,
                        'lng': _currentCenter.longitude,
                        'name': name,
                      });
                    }
                  },
            icon: const Icon(Icons.edit, color: Colors.white),
            label: const Text("Enter manually"),
          ),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    decoration: InputDecoration(
                      hintText: "Search city or place...",
                      prefixIcon: const Icon(Icons.search),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                      ),
                      filled: true,
                      fillColor: Colors.white,
                    ),
                    onSubmitted: (_) => _searchPlace(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton(
                  icon: const Icon(Icons.my_location),
                  onPressed: _getCurrentLocation,
                  tooltip: "Use my current location",
                ),
              ],
            ),
          ),
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: _currentCenter,
                initialZoom: 13,
                onTap: (_, latLng) {
                  setState(() {
                    _currentCenter = latLng;
                  });
                },
              ),
              children: [
                TileLayer(
                  urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isLoading ? null : _confirmLocation,
                    icon: const Icon(Icons.check_circle),
                    label: const Text("Confirm location"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0A3B2A),
                      foregroundColor: Colors.white,
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
    );
  }
}
