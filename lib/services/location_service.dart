// Location service
// This service will handle location-related operations (getting current location, geocoding, etc.)
import 'package:geolocator/geolocator.dart';
import 'dart:async';

class LocationService{
  // Method to check permissions
  Future<bool> _checkLocationPermission() async {
    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        return false;
      }

      // Check current permission status
      LocationPermission permission = await Geolocator.checkPermission();
      
      if (permission == LocationPermission.denied) {
        // Request permission
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          return false;
        }
      }

      // Handle permanently denied case
      if (permission == LocationPermission.deniedForever) {
        return false;
      }

      // Permission granted (whileInUse or always)
      return permission == LocationPermission.whileInUse || 
             permission == LocationPermission.always;
             
    } catch (e) {
      print('Error checking location permission: $e');
      return false;
    }
  }
  Future<Position?> getCurrentLocation() async {
  try {
    // Check location permission
    bool hasPermission = await _checkLocationPermission();
    if (!hasPermission) {
      print('Location permission denied');
      return null;
    }

    // Get current location once
    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.high,
        timeLimit: Duration(seconds: 10),
      ),
    );
    
    print('Current position: ${position.latitude}, ${position.longitude}');
    return position;
  } catch (e) {
    print('Error getting current location: $e');
    return null;
  }
}

}