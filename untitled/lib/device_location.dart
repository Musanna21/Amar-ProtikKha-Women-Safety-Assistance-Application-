import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

class LocationProvider extends ChangeNotifier {
  // Default: Dhaka
  LatLng _currentLocation = const LatLng(23.8103, 90.4125);

  LatLng get currentLocation => _currentLocation;

  void updateLocation(LatLng newLocation) {
    _currentLocation = newLocation;
    notifyListeners(); // This tells the UI to rebuild
  }
}