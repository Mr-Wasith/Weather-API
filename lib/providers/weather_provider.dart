// Weather info provider using Riverpod
// This will manage the state for weather data and handle API calls

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:weatherapp/providers/location_provider.dart'; // Add this import

final currTemp = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    
    // Get the city name from currLocation provider
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);
  
      // Extract temperature from the weather data
      final temp = WeatherProvider().getKelvinTemperature(weatherData); // Temperature in Kelvin

      return temp;
    } else {
      throw Exception('Location not available');
    }
  },
);

final currFeelsLike = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();

    // Get the city name from currLocation provider
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);

      // Extract "feels like" temperature from the weather data
      final feelsLike = WeatherProvider().getFeelsLikeTemperature(weatherData); // Temperature in Kelvin

      return feelsLike;
    } else {
      throw Exception('Location not available');
    }
  },
);

final currWindSpeed = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();

    // Get the city name from currLocation provider
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);

      // Extract wind speed from the weather data
      final windSpeed = WeatherProvider().getWindSpeed(weatherData);

      return windSpeed;
    } else {
      throw Exception('Location not available');
    }
  },
);

final currHumidity = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();

    // Get the city name from currLocation provider
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);

      // Extract humidity from the weather data
      final humidity = WeatherProvider().getHumidity(weatherData);

      return humidity;
    } else {
      throw Exception('Location not available');
    }
  },
);

final description = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();

    // Get the city name from currLocation provider
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);

      // Extract weather description from the weather data
      final desc = WeatherProvider().getWeatherDescription(weatherData);

      return desc.toUpperCase();
    } else {
      throw Exception('Location not available');
    }
  },
);

final sunriseTime = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    // Get the city name from currLocation provider
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);

      // Extract weather description from the weather data
      final desc = WeatherProvider().getSunriseTime(weatherData);

      return desc;
    } else {
      throw Exception('Location not available');
    }
  }
);

final sunsetTime = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    // Get the city name from currLocation provider
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);

      // Extract weather description from the weather data
      final desc = WeatherProvider().getSunsetTime(weatherData);
      return desc;
    } else {
      throw Exception('Location not available');
    }
  }
);

final currPressure = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);
      final pressure = WeatherProvider().getPressure(weatherData);
      return pressure;
    } else {
      throw Exception('Location not available');
    }
  },
);

final currVisibility = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);
      final visibility = WeatherProvider().getVisibility(weatherData);
      return visibility;
    } else {
      throw Exception('Location not available');
    }
  },
);

final currCloudiness = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);
      final cloudiness = WeatherProvider().getCloudiness(weatherData);
      return cloudiness;
    } else {
      throw Exception('Location not available');
    }
  },
);

final currRainVolume = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);
      final rainVolume = WeatherProvider().getRainVolume(weatherData);
      return rainVolume;
    } else {
      throw Exception('Location not available');
    }
  },
);

final currSnowVolume = FutureProvider(
  (ref) async {
    WeatherProvider weatherProvider = WeatherProvider();
    final cityName = await ref.watch(currLocation.future);
    final countryName = await ref.watch(countryLocation.future);
    if (cityName != null) {
      Map<String, dynamic> weatherData = await weatherProvider.fetchWeather(cityName, countryName!);
      final snowVolume = WeatherProvider().getSnowVolume(weatherData);
      return snowVolume;
    } else {
      throw Exception('Location not available');
    }
  },
);