// Weather API service
// This service will handle all API calls to fetch weather data
import 'dart:convert';
import 'package:http/http.dart' as http;

/// Weather service provider class that handles all weather-related API operations
/// Uses OpenWeatherMap API to fetch current weather data for cities
class WeatherProvider{
  // Define state variables and methods for weather data management
  
  /// Base URL for OpenWeatherMap current weather API
  late final String _baseUrl = "http://api.openweathermap.org/data/2.5/weather?";
  
  /// API key for authenticating with OpenWeatherMap API
  late String _apiKey;
  
  /// Constructor that initializes the weather provider with an API key
  /// [apiKey] - Optional API key parameter, defaults to provided key
  WeatherProvider([String apiKey = "704bd5251017df351ddd36cabc695cff"]) {
    _apiKey = apiKey;
  }
  
  /// Fetches weather data for a specific city from the API
  /// [city] - Name of the city to get weather data for
  /// Returns a Map containing the complete weather response
  /// Throws Exception if the API request fails
  /// Fetches weather data for a specific city from the API
  /// [city] - Name of the city to get weather data for
  /// Returns a Map containing the complete weather response
  /// Throws Exception if the API request fails
  Future<Map<String, dynamic>> fetchWeather(String city) async{
    try{
      // Build the complete API URL with city parameter
      final url = _getWeatherUrl(city);
      
      // Make HTTP GET request to the weather API
      final response = await http.get(Uri.parse(url));
      
      // Check if the request was successful (status code 200)
      if(response.statusCode == 200){
        // Parse JSON response body and return as Map
        return json.decode(response.body);
      }else{
        // Throw exception for non-200 status codes
        throw Exception("Failed to load weather data");
      }
    }catch(e){
      // Log error and re-throw for caller to handle
      print("Error fetching weather data: $e");
      throw e;
    }
  }
  
  /// Extracts temperature in Kelvin from weather data response
  /// [weatherData] - The complete weather API response
  /// Returns temperature value in Kelvin
  /// Throws Exception if temperature data is not found
  /// Extracts temperature in Kelvin from weather data response
  /// [weatherData] - The complete weather API response
  /// Returns temperature value in Kelvin
  /// Throws Exception if temperature data is not found
  double getKelvinTemperature(Map<String, dynamic> weatherData){
    try{
      // Check if main object and temp field exist in response
      if(weatherData.containsKey('main') && weatherData['main'].containsKey('temp')){
        return weatherData['main']['temp'];
      }else{
        throw Exception("Temperature data not found in the response");
      }
    }catch(e){
      print("Error getting temperature: $e");
      throw e;
    }
  }
  
  /// Extracts "feels like" temperature in Kelvin from weather data
  /// [weatherData] - The complete weather API response
  /// Returns "feels like" temperature value in Kelvin
  /// Throws Exception if feels like temperature data is not found
  /// Extracts "feels like" temperature in Kelvin from weather data
  /// [weatherData] - The complete weather API response
  /// Returns "feels like" temperature value in Kelvin
  /// Throws Exception if feels like temperature data is not found
  double getFeelsLikeTemperature(Map<String, dynamic> weatherData){
    try{
      // Check if main object and feels_like field exist in response
      if(weatherData.containsKey('main') && weatherData['main'].containsKey('feels_like')){
        return weatherData['main']['feels_like'];
      }else{
        throw Exception("Feels like temperature data not found in the response");
      }
    }catch(e){
      print("Error getting feels like temperature: $e");
      throw e;
    }
  }
  
  /// Extracts timezone offset from weather data (deprecated method name)
  /// [weatherData] - The complete weather API response
  /// Returns timezone offset in seconds from UTC
  /// Note: Consider using getTimezoneOffset() for better naming consistency
  /// Extracts timezone offset from weather data (deprecated method name)
  /// [weatherData] - The complete weather API response
  /// Returns timezone offset in seconds from UTC
  /// Note: Consider using getTimezoneOffset() for better naming consistency
  double getLocalTimeZone(Map<String, dynamic> weatherData){
    try{
      // Check if timezone field exists in response
      if(weatherData.containsKey('timezone')){
        return weatherData['timezone'];
      }else{
        throw Exception("Timezone data not found in the response");
      }
    }catch(e){
      print("Error getting timezone: $e");
      throw e;
    }
  }
  
  // =================================================================
  // TEMPERATURE CONVERSION UTILITIES
  // =================================================================
  
  /// Converts temperature from Kelvin to Celsius
  /// [kelvin] - Temperature value in Kelvin
  /// Returns temperature in Celsius
  double kelvinToCelsius(double kelvin){
    // Formula: Celsius = Kelvin - 273.15
    return (kelvin - 273.15);
  }
  
  /// Converts temperature from Kelvin to Fahrenheit
  /// [kelvin] - Temperature value in Kelvin
  /// Returns temperature in Fahrenheit
  double kelvinToFahrenheit(double kelvin){
    // First convert to Celsius, then to Fahrenheit
    double celsius = kelvinToCelsius(kelvin);
    // Formula: Fahrenheit = Celsius × (9/5) + 32
    return (celsius * (9/5) + 32);
  }
  
  // =================================================================
  // WEATHER DATA EXTRACTION METHODS
  // =================================================================
  
  /// Extracts wind speed from weather data response
  /// [weatherData] - The complete weather API response
  /// Returns wind speed in meters per second
  /// Throws Exception if wind data is not found
  /// Extracts wind speed from weather data response
  /// [weatherData] - The complete weather API response
  /// Returns wind speed in meters per second
  /// Throws Exception if wind data is not found
  double getWindSpeed(Map<String, dynamic> weatherData){
    try{
      // Check if wind object and speed field exist in response
      if(weatherData.containsKey('wind') && weatherData['wind'].containsKey('speed')){
        return weatherData['wind']['speed'].toDouble();
      }else{
        throw Exception("Wind speed data not found in the response");
      }
    }catch(e){
      print("Error getting wind speed: $e");
      throw e;
    }
  }
  
  /// Extracts humidity percentage from weather data response
  /// [weatherData] - The complete weather API response
  /// Returns humidity as an integer percentage (0-100)
  /// Throws Exception if humidity data is not found
  /// Extracts humidity percentage from weather data response
  /// [weatherData] - The complete weather API response
  /// Returns humidity as an integer percentage (0-100)
  /// Throws Exception if humidity data is not found
  int getHumidity(Map<String, dynamic> weatherData){
    try{
      // Check if main object and humidity field exist in response
      if(weatherData.containsKey('main') && weatherData['main'].containsKey('humidity')){
        return weatherData['main']['humidity'];
      }else{
        throw Exception("Humidity data not found in the response");
      }
    }catch(e){
      print("Error getting humidity: $e");
      throw e;
    }
  }
  
  /// Extracts weather description from weather data response
  /// [weatherData] - The complete weather API response
  /// Returns weather description string (e.g., "clear sky", "light rain")
  /// Throws Exception if weather description is not found
  String getWeatherDescription(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('weather') && weatherData['weather'].isNotEmpty){
        return weatherData['weather'][0]['description'];
      }else{
        throw Exception("Weather description not found in the response");
      }
    }catch(e){
      print("Error getting weather description: $e");
      throw e;
    }
  }
  
  // Timezone offset extraction
  int getTimezoneOffset(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('timezone')){
        return weatherData['timezone'];
      }else{
        throw Exception("Timezone data not found in the response");
      }
    }catch(e){
      print("Error getting timezone offset: $e");
      throw e;
    }
  }
  
  // Pressure extraction
  int getPressure(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('main') && weatherData['main'].containsKey('pressure')){
        return weatherData['main']['pressure'];
      }else{
        throw Exception("Pressure data not found in the response");
      }
    }catch(e){
      print("Error getting pressure: $e");
      throw e;
    }
  }
  
  // Visibility extraction (optional field)
  double? getVisibility(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('visibility')){
        return weatherData['visibility'].toDouble();
      }else{
        return null; // Visibility is optional
      }
    }catch(e){
      print("Error getting visibility: $e");
      return null;
    }
  }
  
  // Cloudiness extraction
  int getCloudiness(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('clouds') && weatherData['clouds'].containsKey('all')){
        return weatherData['clouds']['all'];
      }else{
        throw Exception("Cloudiness data not found in the response");
      }
    }catch(e){
      print("Error getting cloudiness: $e");
      throw e;
    }
  }
  
  // Rain volume extraction (optional field)
  double getRainVolume(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('rain') && weatherData['rain'].containsKey('1h')){
        return weatherData['rain']['1h'].toDouble();
      }else{
        return 0.0; // No rain data available
      }
    }catch(e){
      print("Error getting rain volume: $e");
      return 0.0;
    }
  }
  
  // Snow volume extraction (optional field)
  double getSnowVolume(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('snow') && weatherData['snow'].containsKey('1h')){
        return weatherData['snow']['1h'].toDouble();
      }else{
        return 0.0; // No snow data available
      }
    }catch(e){
      print("Error getting snow volume: $e");
      return 0.0;
    }
  }
  
  // Sunrise time extraction
  DateTime getSunriseTime(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('sys') && weatherData['sys'].containsKey('sunrise')){
        int sunriseTimestamp = weatherData['sys']['sunrise'];
        int timezoneOffset = getTimezoneOffset(weatherData);
        return DateTime.fromMillisecondsSinceEpoch((sunriseTimestamp + timezoneOffset) * 1000, isUtc: true);
      }else{
        throw Exception("Sunrise time not found in the response");
      }
    }catch(e){
      print("Error getting sunrise time: $e");
      throw e;
    }
  }
  
  // Sunset time extraction
  DateTime getSunsetTime(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('sys') && weatherData['sys'].containsKey('sunset')){
        int sunsetTimestamp = weatherData['sys']['sunset'];
        int timezoneOffset = getTimezoneOffset(weatherData);
        return DateTime.fromMillisecondsSinceEpoch((sunsetTimestamp + timezoneOffset) * 1000, isUtc: true);
      }else{
        throw Exception("Sunset time not found in the response");
      }
    }catch(e){
      print("Error getting sunset time: $e");
      throw e;
    }
  }
  
  // Local time calculation
  DateTime getLocalTime(Map<String, dynamic> weatherData){
    try{
      int timezoneOffset = getTimezoneOffset(weatherData);
      return DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    }catch(e){
      print("Error calculating local time: $e");
      throw e;
    }
  }
  
  String _getWeatherUrl(String city){
    //BASE_URL + "appid=" + API_KEY + "&q=" + CITY
    return _baseUrl + "appid=" + _apiKey + "&q=" + city;
  }
  
}