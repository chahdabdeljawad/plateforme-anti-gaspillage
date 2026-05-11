import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

class MapPage extends StatefulWidget {
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

  // LIVE GPS TRACKING
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
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E6),

      appBar: AppBar(
        title: Text(
          widget.storeName,
          style: const TextStyle(fontFamily: 'PlayfairDisplay'),
        ),

        backgroundColor: const Color(0xFF0A3B2A),
        foregroundColor: Colors.white,
        elevation: 0,
      ),

      body: FlutterMap(
        mapController: _mapController,

        options: MapOptions(initialCenter: currentLocation, initialZoom: 15),

        children: [
          TileLayer(
            urlTemplate: "https://tile.openstreetmap.org/{z}/{x}/{y}.png",
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
    );
  }
}
