import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _selectedLocation;
  String? _placeName;

  LatLng? get selectedLocation => _selectedLocation;
  String? get placeName => _placeName;
  bool get hasLocation => _selectedLocation != null;

  // AUTO GET USER LOCATION
  Future<void> initializeLocation() async {
    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        print("GPS disabled");
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.deniedForever) {
        print("Permission denied forever");
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      _selectedLocation = LatLng(position.latitude, position.longitude);

      final prefs = await SharedPreferences.getInstance();

      await prefs.setDouble('lat', position.latitude);

      await prefs.setDouble('lng', position.longitude);

      notifyListeners();
    } catch (e) {
      print("Location error: $e");
    }
  }

  // LOAD SAVED LOCATION
  Future<void> loadSavedLocation() async {
    final prefs = await SharedPreferences.getInstance();

    double? lat = prefs.getDouble('lat');
    double? lng = prefs.getDouble('lng');
    String? name = prefs.getString('placeName');

    if (lat != null && lng != null) {
      _selectedLocation = LatLng(lat, lng);
      _placeName = name;
      notifyListeners();
    }
  }

  // MANUAL LOCATION
  Future<void> setLocation(LatLng location, String name) async {
    _selectedLocation = location;
    _placeName = name;

    final prefs = await SharedPreferences.getInstance();

    await prefs.setDouble('lat', location.latitude);

    await prefs.setDouble('lng', location.longitude);

    await prefs.setString('placeName', name);

    notifyListeners();
  }

  // CLEAR
  Future<void> clearLocation() async {
    _selectedLocation = null;
    _placeName = null;

    final prefs = await SharedPreferences.getInstance();

    await prefs.remove('lat');
    await prefs.remove('lng');
    await prefs.remove('placeName');

    notifyListeners();
  }
}
