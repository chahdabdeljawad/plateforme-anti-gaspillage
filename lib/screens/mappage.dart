import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:provider/provider.dart';
import '../providers/theme_provider.dart';
import '../lang.dart';
import '../components/footer.dart';

class MapPage extends StatefulWidget {
  final double lat;
  final double lng;
  final String storeName;
  final VoidCallback onBack; // ✅ Callback to return to the previous page

  const MapPage({
    super.key,
    required this.lat,
    required this.lng,
    required this.storeName,
    required this.onBack,
  });

  @override
  State<MapPage> createState() => _MapPageState();
}

class _MapPageState extends State<MapPage> {
  late final MapController _mapController;
  late LatLng currentLocation;
  StreamSubscription<Position>? _positionStream;

  @override
  void initState() {
    super.initState();
    _mapController = MapController();
    currentLocation = LatLng(widget.lat, widget.lng);
    _startLiveLocation();
  }

  void _startLiveLocation() {
    _positionStream =
        Geolocator.getPositionStream(
          locationSettings: const LocationSettings(
            accuracy: LocationAccuracy.high,
            distanceFilter: 10,
          ),
        ).listen((Position position) {
          final newLocation = LatLng(position.latitude, position.longitude);
          setState(() {
            currentLocation = newLocation;
          });
          _mapController.move(newLocation, 15);
        });
  }

  @override
  void dispose() {
    _positionStream?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final lang = Provider.of<Lang>(context);
    final themeProvider = Provider.of<ThemeProvider>(context);
    final colors = Theme.of(context).colorScheme;
    final isDark = themeProvider.isDarkMode;
    final isRtl = lang.current == "ar";

    return Directionality(
      textDirection: isRtl ? TextDirection.rtl : TextDirection.ltr,
      child: Column(
        children: [
          // ✅ Custom Header (Back, Title, Theme Toggle, Language)
          Container(
            decoration: BoxDecoration(
              color: colors.surface.withOpacity(0.95),
              border: Border(
                bottom: BorderSide(color: colors.onSurface.withOpacity(0.1)),
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: Row(
                children: [
                  IconButton(
                    icon: Icon(Icons.arrow_back_ios, color: colors.onSurface),
                    onPressed: widget.onBack, // ✅ Uses the onBack callback
                  ),
                  Expanded(
                    child: Text(
                      widget.storeName,
                      style: TextStyle(
                        fontFamily: 'PlayfairDisplay',
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: colors.primary,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  // 🌗 Day/Night toggle
                  IconButton(
                    icon: Icon(
                      isDark ? Icons.light_mode : Icons.dark_mode,
                      color: colors.onSurface,
                    ),
                    onPressed: themeProvider.toggleTheme,
                  ),
                  // 🌐 Language selector
                  PopupMenuButton<String>(
                    icon: Container(
                      height: 28,
                      width: 28,
                      decoration: const BoxDecoration(shape: BoxShape.circle),
                      child: Image.asset("assets/langue/translator.png"),
                    ),
                    onSelected: (value) => lang.changeLang(value),
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        value: "fr",
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage(
                                "assets/langue/france.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "en",
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage(
                                "assets/langue/united-kingdom.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                      PopupMenuItem(
                        value: "ar",
                        child: Row(
                          children: const [
                            CircleAvatar(
                              radius: 14,
                              backgroundImage: AssetImage(
                                "assets/langue/flag.png",
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),

          // ✅ Map (Takes remaining space)
          Expanded(
            child: FlutterMap(
              mapController: _mapController,
              options: MapOptions(
                initialCenter: currentLocation,
                initialZoom: 15,
                backgroundColor: isDark
                    ? const Color(0xFF121212)
                    : const Color(0xFFF5F0E6),
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
                      point: currentLocation,
                      width: 40,
                      height: 40,
                      child: const Icon(
                        Icons.location_on,
                        color: Colors.red,
                        size: 40,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

         
          
        ],
      ),
    );
  }
}
