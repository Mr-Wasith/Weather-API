// Location provider using Riverpod
// This will manage the state for location data and user's current location
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';
import 'package:weatherapp/services/location_service.dart';

final currLocation = FutureProvider(
  (ref) async {
    LocationService locationService = LocationService();
    Position? position = await locationService.getCurrentLocation();
    String? city = await locationService.getCityFromCoordinates(position!.latitude, position.longitude);
    return city;
  },
);

final countryLocation = FutureProvider(
  (ref) async {
    LocationService locationService = LocationService();
    Position? position = await locationService.getCurrentLocation();
    String? country = await locationService.getCountryFromCoordinates(position!.latitude, position.longitude);
    return country;
  },
);