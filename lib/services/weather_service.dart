// Weather API service
// This service will handle all API calls to fetch weather data
import 'dart:convert';

import 'package:http/http.dart' as http;
class WeatherProvider{
  // Define state variables and methods for weather data management
  late final String _baseUrl = "http://api.openweathermap.org/data/2.5/weather?";
  late String _apiKey;
  // Initialize the weather provider with an API key
  WeatherProvider([String apiKey = "704bd5251017df351ddd36cabc695cff"]) {
    _apiKey = apiKey;
  }
  // Fetch weather data for a given city
  Future<Map<String, dynamic>> fetchWeather(String city) async{
    try{
      final url = _getWeatherUrl(city);
      final response = await http.get(Uri.parse(url));
      if(response.statusCode == 200){
        return json.decode(response.body);
      }else{
        throw Exception("Failed to load weather data");
      }
    }catch(e){
      print("Error fetching weather data: $e");
      rethrow;
    }
  }
  // Temperature extraction
  double getKelvinTemperature(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('main') && weatherData['main'].containsKey('temp')){
        return weatherData['main']['temp'];
      }else{
        throw Exception("Temperature data not found in the response");
      }
    }catch(e){
      print("Error getting temperature: $e");
      rethrow;
    }
  }
  // Feels like temperature extraction
  double getFeelsLikeTemperature(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('main') && weatherData['main'].containsKey('feels_like')){
        return weatherData['main']['feels_like'];
      }else{
        throw Exception("Feels like temperature data not found in the response");
      }
    }catch(e){
      print("Error getting feels like temperature: $e");
      rethrow;
    }
  }
  // Local time zone extraction
  DateTime getLocalTimeZone(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('timezone')){
        return weatherData['timezone'];
      }else{
        throw Exception("Timezone data not found in the response");
      }
    }catch(e){
      print("Error getting timezone: $e");
      rethrow;
    }
  }
  double kelvinToCelsius(double kelvin){
    return (kelvin - 273.15);
  }
  double kelvinToFahrenheit(double kelvin){
    double celsius = kelvinToCelsius(kelvin);
    return (celsius * (9/5) + 32);
  }
  
  // Wind speed extraction
  double getWindSpeed(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('wind') && weatherData['wind'].containsKey('speed')){
        return weatherData['wind']['speed'].toDouble();
      }else{
        throw Exception("Wind speed data not found in the response");
      }
    }catch(e){
      print("Error getting wind speed: $e");
      rethrow;
    }
  }
  
  // Humidity extraction
  int getHumidity(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('main') && weatherData['main'].containsKey('humidity')){
        return weatherData['main']['humidity'];
      }else{
        throw Exception("Humidity data not found in the response");
      }
    }catch(e){
      print("Error getting humidity: $e");
      rethrow;
    }
  }
  
  // Weather description extraction
  String getWeatherDescription(Map<String, dynamic> weatherData){
    try{
      if(weatherData.containsKey('weather') && weatherData['weather'].isNotEmpty){
        return weatherData['weather'][0]['description'];
      }else{
        throw Exception("Weather description not found in the response");
      }
    }catch(e){
      print("Error getting weather description: $e");
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
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
      rethrow;
    }
  }
  
  // Local time calculation
  DateTime getLocalTime(Map<String, dynamic> weatherData){
    try{
      int timezoneOffset = getTimezoneOffset(weatherData);
      return DateTime.now().toUtc().add(Duration(seconds: timezoneOffset));
    }catch(e){
      print("Error calculating local time: $e");
      rethrow;
    }
  }
  
  String _getWeatherUrl(String city){
    //BASE_URL + "appid=" + API_KEY + "&q=" + CITY
    return "${_baseUrl}appid=$_apiKey&q=$city";
  }
  
}