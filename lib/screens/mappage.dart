import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';

class MapPage extends StatelessWidget {
  final double lat;
  final double lng;
  final String storeName;

  const MapPage({
    super.key,
    required this.lat,
    required this.lng,
    required this.storeName,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6), // beige background
      appBar: AppBar(
        title: Text(
          storeName,
          style: const TextStyle(fontFamily: 'PlayfairDisplay'),
        ),
        backgroundColor: const Color(0xFF0A3B2A), // dark green
        foregroundColor: Colors.white,
        elevation: 0,
      ),
      body: FlutterMap(
        options: MapOptions(initialCenter: LatLng(lat, lng), initialZoom: 15),
        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
          ),
          MarkerLayer(
            markers: [
              Marker(
                point: LatLng(lat, lng),
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
    );
  }
}
