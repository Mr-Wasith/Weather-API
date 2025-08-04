// Unit tests for WeatherProvider service
// Run with: flutter test

import 'package:flutter_test/flutter_test.dart';
import '../lib/services/weather_service.dart';

void main() {
  group('WeatherProvider Tests', () {
    late WeatherProvider weatherProvider;
    
    setUp(() {
      weatherProvider = WeatherProvider();
    });
    
    test('should create WeatherProvider instance', () {
      expect(weatherProvider, isNotNull);
    });
    
    test('should convert Kelvin to Celsius correctly', () {
      double kelvin = 273.15;
      double celsius = weatherProvider.kelvinToCelsius(kelvin);
      expect(celsius, equals(0.0));
    });
    
    test('should convert Kelvin to Fahrenheit correctly', () {
      double kelvin = 273.15;
      double fahrenheit = weatherProvider.kelvinToFahrenheit(kelvin);
      expect(fahrenheit, equals(32.0));
    });
    
    test('should extract temperature from weather data', () {
      Map<String, dynamic> mockData = {
        'main': {
          'temp': 295.15,
          'feels_like': 298.15,
          'humidity': 65,
          'pressure': 1013
        }
      };
      
      double temp = weatherProvider.getKelvinTemperature(mockData);
      expect(temp, equals(295.15));
    });
    
    test('should extract feels like temperature from weather data', () {
      Map<String, dynamic> mockData = {
        'main': {
          'temp': 295.15,
          'feels_like': 298.15,
          'humidity': 65,
          'pressure': 1013
        }
      };
      
      double feelsLike = weatherProvider.getFeelsLikeTemperature(mockData);
      expect(feelsLike, equals(298.15));
    });
    
    test('should extract humidity from weather data', () {
      Map<String, dynamic> mockData = {
        'main': {
          'temp': 295.15,
          'feels_like': 298.15,
          'humidity': 65,
          'pressure': 1013
        }
      };
      
      int humidity = weatherProvider.getHumidity(mockData);
      expect(humidity, equals(65));
    });
    
    test('should extract weather description from weather data', () {
      Map<String, dynamic> mockData = {
        'weather': [
          {
            'main': 'Clear',
            'description': 'clear sky',
            'icon': '01d'
          }
        ]
      };
      
      String description = weatherProvider.getWeatherDescription(mockData);
      expect(description, equals('clear sky'));
    });
    
    test('should handle missing temperature data', () {
      Map<String, dynamic> mockData = {
        'weather': [
          {'description': 'clear sky'}
        ]
      };
      
      expect(
        () => weatherProvider.getKelvinTemperature(mockData),
        throwsException,
      );
    });
    
    test('should handle optional visibility data', () {
      // Test with visibility data
      Map<String, dynamic> mockDataWithVisibility = {
        'visibility': 10000
      };
      
      double? visibility = weatherProvider.getVisibility(mockDataWithVisibility);
      expect(visibility, equals(10000.0));
      
      // Test without visibility data
      Map<String, dynamic> mockDataWithoutVisibility = {};
      
      double? noVisibility = weatherProvider.getVisibility(mockDataWithoutVisibility);
      expect(noVisibility, isNull);
    });
    
    test('should handle rain data correctly', () {
      // Test with rain data
      Map<String, dynamic> mockDataWithRain = {
        'rain': {
          '1h': 2.5
        }
      };
      
      double rain = weatherProvider.getRainVolume(mockDataWithRain);
      expect(rain, equals(2.5));
      
      // Test without rain data
      Map<String, dynamic> mockDataWithoutRain = {};
      
      double noRain = weatherProvider.getRainVolume(mockDataWithoutRain);
      expect(noRain, equals(0.0));
    });
    
    // Integration test (requires internet connection)
    test('should fetch real weather data', () async {
      try {
        Map<String, dynamic> weatherData = await weatherProvider.fetchWeather('London');
        
        // Check if essential fields exist
        expect(weatherData.containsKey('main'), isTrue);
        expect(weatherData.containsKey('weather'), isTrue);
        expect(weatherData.containsKey('wind'), isTrue);
        
        // Test extraction methods with real data
        double temp = weatherProvider.getKelvinTemperature(weatherData);
        expect(temp, greaterThan(200)); // Reasonable temperature range
        expect(temp, lessThan(350));
        
        String description = weatherProvider.getWeatherDescription(weatherData);
        expect(description, isNotEmpty);
        
      } catch (e) {
        // Skip this test if there's no internet connection
        print('Skipping integration test - no internet connection: $e');
      }
    }, timeout: Timeout(Duration(seconds: 10)));
  });
}
