import 'dart:math' as math;

/// Location data model class
/// This contains the structure for location information (coordinates, city name, country, etc.)
class LocationData {
  final double latitude;
  final double longitude;
  final String? cityName;
  final String? countryName;
  final String? countryCode;
  final String? stateName;
  final String? postalCode;
  final String? timezone;
  final DateTime? timestamp;

  const LocationData({
    required this.latitude,
    required this.longitude,
    this.cityName,
    this.countryName,
    this.countryCode,
    this.stateName,
    this.postalCode,
    this.timezone,
    this.timestamp,
  });

  /// Factory constructor for creating LocationData from coordinates only
  factory LocationData.fromCoordinates({
    required double latitude,
    required double longitude,
  }) {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for creating LocationData from geocoding API response
  factory LocationData.fromGeocodingApi(Map<String, dynamic> json) {
    return LocationData(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
      cityName: json['name'] as String?,
      countryName: json['country'] as String?,
      countryCode: json['country'] as String?, // Usually country code is provided
      stateName: json['state'] as String?,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for creating LocationData from reverse geocoding
  factory LocationData.fromReverseGeocoding(Map<String, dynamic> json) {
    return LocationData(
      latitude: (json['lat'] as num).toDouble(),
      longitude: (json['lon'] as num).toDouble(),
      cityName: json['name'] as String?,
      countryName: json['country'] as String?,
      countryCode: json['country'] as String?,
      stateName: json['state'] as String?,
      timestamp: DateTime.now(),
    );
  }

  /// Factory constructor for creating LocationData from GPS position
  factory LocationData.fromPosition({
    required double latitude,
    required double longitude,
    String? cityName,
    String? countryName,
  }) {
    return LocationData(
      latitude: latitude,
      longitude: longitude,
      cityName: cityName,
      countryName: countryName,
      timestamp: DateTime.now(),
    );
  }

  /// Convert to JSON for storage or API calls
  Map<String, dynamic> toJson() {
    return {
      'latitude': latitude,
      'longitude': longitude,
      'cityName': cityName,
      'countryName': countryName,
      'countryCode': countryCode,
      'stateName': stateName,
      'postalCode': postalCode,
      'timezone': timezone,
      'timestamp': timestamp?.toIso8601String(),
    };
  }

  /// Create LocationData from JSON (for local storage)
  factory LocationData.fromJson(Map<String, dynamic> json) {
    return LocationData(
      latitude: (json['latitude'] as num).toDouble(),
      longitude: (json['longitude'] as num).toDouble(),
      cityName: json['cityName'] as String?,
      countryName: json['countryName'] as String?,
      countryCode: json['countryCode'] as String?,
      stateName: json['stateName'] as String?,
      postalCode: json['postalCode'] as String?,
      timezone: json['timezone'] as String?,
      timestamp: json['timestamp'] != null 
          ? DateTime.parse(json['timestamp'] as String)
          : null,
    );
  }

  /// Get formatted display name
  String get displayName {
    if (cityName != null && countryName != null) {
      return '$cityName, $countryName';
    } else if (cityName != null) {
      return cityName!;
    } else if (countryName != null) {
      return countryName!;
    } else {
      return 'Location (${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)})';
    }
  }

  /// Get short display name (city only or coordinates)
  String get shortDisplayName {
    return cityName ?? '${latitude.toStringAsFixed(2)}, ${longitude.toStringAsFixed(2)}';
  }

  /// Get coordinates as a formatted string
  String get coordinatesString {
    return '${latitude.toStringAsFixed(4)}, ${longitude.toStringAsFixed(4)}';
  }

  /// Check if this location has detailed information (city, country)
  bool get hasDetailedInfo => cityName != null && countryName != null;

  /// Check if location data is recent (within last hour)
  bool get isRecent {
    if (timestamp == null) return false;
    final now = DateTime.now();
    final difference = now.difference(timestamp!);
    return difference.inHours < 1;
  }

  /// Calculate distance to another location (in kilometers)
  double distanceTo(LocationData other) {
    const double earthRadiusKm = 6371.0;
    
    final double lat1Rad = latitude * (math.pi / 180);
    final double lat2Rad = other.latitude * (math.pi / 180);
    final double deltaLatRad = (other.latitude - latitude) * (math.pi / 180);
    final double deltaLonRad = (other.longitude - longitude) * (math.pi / 180);

    final double a = math.sin(deltaLatRad / 2) * math.sin(deltaLatRad / 2) +
        math.cos(lat1Rad) * math.cos(lat2Rad) *
        math.sin(deltaLonRad / 2) * math.sin(deltaLonRad / 2);
    final double c = 2 * math.asin(math.sqrt(a));

    return earthRadiusKm * c;
  }

  /// Create a copy with updated fields
  LocationData copyWith({
    double? latitude,
    double? longitude,
    String? cityName,
    String? countryName,
    String? countryCode,
    String? stateName,
    String? postalCode,
    String? timezone,
    DateTime? timestamp,
  }) {
    return LocationData(
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
      cityName: cityName ?? this.cityName,
      countryName: countryName ?? this.countryName,
      countryCode: countryCode ?? this.countryCode,
      stateName: stateName ?? this.stateName,
      postalCode: postalCode ?? this.postalCode,
      timezone: timezone ?? this.timezone,
      timestamp: timestamp ?? this.timestamp,
    );
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is LocationData &&
        other.latitude == latitude &&
        other.longitude == longitude &&
        other.cityName == cityName &&
        other.countryName == countryName &&
        other.countryCode == countryCode;
  }

  @override
  int get hashCode {
    return Object.hash(
      latitude,
      longitude,
      cityName,
      countryName,
      countryCode,
    );
  }

  @override
  String toString() {
    return 'LocationData(lat: $latitude, lon: $longitude, city: $cityName, country: $countryName)';
  }
}
