// Weather data model class
// This will contain the structure for weather information received from the API

class WeatherData {
  // Temperature data
  final double temperatureKelvin;
  final double temperatureCelsius;
  final double temperatureFahrenheit;
  
  // Feels like temperature
  final double feelsLikeKelvin;
  final double feelsLikeCelsius;
  final double feelsLikeFahrenheit;
  
  // Location and time data
  final String cityName;
  final int timezoneOffset; // in seconds
  final DateTime localTime;
  final DateTime sunriseTime;
  final DateTime sunsetTime;
  
  // Weather conditions
  final String description;
  final double windSpeed; // in m/s
  final int humidity; // percentage
  final int pressure; // in hPa
  final int cloudiness; // percentage
  
  // Optional weather data
  final double? visibility; // in meters (can be null)
  final double rainVolume; // in mm (last hour)
  final double snowVolume; // in mm (last hour)
  
  // Constructor
  WeatherData({
    required this.temperatureKelvin,
    required this.temperatureCelsius,
    required this.temperatureFahrenheit,
    required this.feelsLikeKelvin,
    required this.feelsLikeCelsius,
    required this.feelsLikeFahrenheit,
    required this.cityName,
    required this.timezoneOffset,
    required this.localTime,
    required this.sunriseTime,
    required this.sunsetTime,
    required this.description,
    required this.windSpeed,
    required this.humidity,
    required this.pressure,
    required this.cloudiness,
    this.visibility,
    required this.rainVolume,
    required this.snowVolume,
  });
  
  // Factory constructor to create WeatherData from API response
  factory WeatherData.fromApiResponse(Map<String, dynamic> response, String cityName) {
    // Extract temperature data
    double tempKelvin = response['main']['temp'].toDouble();
    double tempCelsius = _kelvinToCelsius(tempKelvin);
    double tempFahrenheit = _kelvinToFahrenheit(tempKelvin);
    
    // Extract feels like temperature
    double feelsLikeKelvin = response['main']['feels_like'].toDouble();
    double feelsLikeCelsius = _kelvinToCelsius(feelsLikeKelvin);
    double feelsLikeFahrenheit = _kelvinToFahrenheit(feelsLikeKelvin);
    
    // Extract timezone and time data
    int timezoneOffset = response['timezone'];
    
    // Calculate local time
    DateTime localTime = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    
    // Calculate sunrise and sunset times
    DateTime sunriseTime = DateTime.fromMillisecondsSinceEpoch(
      (response['sys']['sunrise'] + timezoneOffset) * 1000,
      isUtc: true,
    );
    
    DateTime sunsetTime = DateTime.fromMillisecondsSinceEpoch(
      (response['sys']['sunset'] + timezoneOffset) * 1000,
      isUtc: true,
    );
    
    // Extract weather conditions
    String description = response['weather'][0]['description'];
    double windSpeed = response['wind']['speed'].toDouble();
    int humidity = response['main']['humidity'];
    int pressure = response['main']['pressure'];
    int cloudiness = response['clouds']['all'];
    
    // Extract optional data
    double? visibility = response['visibility']?.toDouble();
    double rainVolume = response['rain']?['1h']?.toDouble() ?? 0.0;
    double snowVolume = response['snow']?['1h']?.toDouble() ?? 0.0;
    
    return WeatherData(
      temperatureKelvin: tempKelvin,
      temperatureCelsius: tempCelsius,
      temperatureFahrenheit: tempFahrenheit,
      feelsLikeKelvin: feelsLikeKelvin,
      feelsLikeCelsius: feelsLikeCelsius,
      feelsLikeFahrenheit: feelsLikeFahrenheit,
      cityName: cityName,
      timezoneOffset: timezoneOffset,
      localTime: localTime,
      sunriseTime: sunriseTime,
      sunsetTime: sunsetTime,
      description: description,
      windSpeed: windSpeed,
      humidity: humidity,
      pressure: pressure,
      cloudiness: cloudiness,
      visibility: visibility,
      rainVolume: rainVolume,
      snowVolume: snowVolume,
    );
  }
  
  // Helper methods for temperature conversion
  static double _kelvinToCelsius(double kelvin) {
    return kelvin - 273.15;
  }
  
  static double _kelvinToFahrenheit(double kelvin) {
    double celsius = _kelvinToCelsius(kelvin);
    return celsius * (9 / 5) + 32;
  }
  
  // Convenience getters for formatted strings
  String get temperatureCelsiusString => '${temperatureCelsius.toStringAsFixed(1)}°C';
  String get temperatureFahrenheitString => '${temperatureFahrenheit.toStringAsFixed(1)}°F';
  String get feelsLikeCelsiusString => '${feelsLikeCelsius.toStringAsFixed(1)}°C';
  String get feelsLikeFahrenheitString => '${feelsLikeFahrenheit.toStringAsFixed(1)}°F';
  String get windSpeedString => '${windSpeed.toStringAsFixed(1)} m/s';
  String get visibilityString => visibility != null ? '${(visibility! / 1000).toStringAsFixed(1)} km' : 'N/A';
  String get pressureString => '$pressure hPa';
  String get humidityString => '$humidity%';
  String get cloudinessString => '$cloudiness%';
  String get rainVolumeString => '${rainVolume.toStringAsFixed(1)} mm';
  String get snowVolumeString => '${snowVolume.toStringAsFixed(1)} mm';
  
  // Formatted time strings
  String get localTimeString => localTime.toString().substring(0, 19); // Remove microseconds
  String get sunriseTimeString => sunriseTime.toString().substring(11, 16); // HH:mm format
  String get sunsetTimeString => sunsetTime.toString().substring(11, 16); // HH:mm format
  
  // toString method for debugging
  @override
  String toString() {
    return '''
WeatherData(
  location: $cityName,
  temperature: $temperatureCelsiusString,
  feelsLike: $feelsLikeCelsiusString,
  description: $description,
  humidity: $humidityString,
  windSpeed: $windSpeedString,
  pressure: $pressureString,
  visibility: $visibilityString,
  cloudiness: $cloudinessString,
  rain: $rainVolumeString,
  snow: $snowVolumeString,
  sunrise: $sunriseTimeString,
  sunset: $sunsetTimeString,
  localTime: $localTimeString
)''';
  }
  
  // Method to check if it's daytime
  bool get isDaytime {
    DateTime now = DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    return now.isAfter(sunriseTime) && now.isBefore(sunsetTime);
  }
  
  // Method to get weather icon based on description
  String get weatherIcon {
    String desc = description.toLowerCase();
    if (desc.contains('clear')) {
      return isDaytime ? '☀️' : '🌙';
    } else if (desc.contains('cloud')) {
      return '☁️';
    } else if (desc.contains('rain')) {
      return '🌧️';
    } else if (desc.contains('snow')) {
      return '❄️';
    } else if (desc.contains('storm') || desc.contains('thunder')) {
      return '⛈️';
    } else if (desc.contains('fog') || desc.contains('mist')) {
      return '🌫️';
    } else {
      return '🌤️';
    }
  }
}