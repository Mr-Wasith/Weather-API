// Location service
// This service will handle location-related operations (getting current location, geocoding, etc.)
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
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
  Future<String?> getCityFromCoordinates(double latitude, double longitude) async {
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if(placemarks.isNotEmpty){
        Placemark placemark = placemarks[0];
        String? city = placemark.locality;
        return city ?? 'Unknown Location';
      }
    }catch (e) {
      print('Error getting city from coordinates: $e');
      return null;
    }
    return null;
  }
  Future<String?> getCountryFromCoordinates(double latitude, double longitude) async {
    try{
      List<Placemark> placemarks = await placemarkFromCoordinates(latitude, longitude);
      if(placemarks.isNotEmpty){
        Placemark placemark = placemarks[0];
        String? country = placemark.country;
        return country ?? 'Unknown Location';
      }
    }catch (e) {
      print('Error getting country from coordinates: $e');
      return null;
    }
    return null;
  }
  // Add this method to your existing LocationService class
  Future<Map<String, double>?> getCoordinatesFromCountryName(String countryName) async {
    try {
      List<Location> locations = await locationFromAddress(countryName);
      if (locations.isNotEmpty) {
        Location location = locations[0];
        return {
          'latitude': location.latitude,
          'longitude': location.longitude,
        };
      }
      return null;
    } catch (e) {
      print('Error getting coordinates from country name: $e');
      return null;
    }
  }
}