import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationProvider extends ChangeNotifier {
  LatLng? _selectedLocation;
  String? _placeName;

  LatLng? get selectedLocation => _selectedLocation;
  String? get placeName => _placeName;
  bool get hasLocation => _selectedLocation != null;

  void setLocation(LatLng location, String name) {
    _selectedLocation = location;
    _placeName = name;
    notifyListeners();
  }

  void clearLocation() {
    _selectedLocation = null;
    _placeName = null;
    notifyListeners();
  }
}
