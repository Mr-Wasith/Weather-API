// Home screen - displays current location weather
// This screen will show weather details for the user's current location

import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/providers/location_provider.dart';
import 'package:weatherapp/providers/weather_provider.dart';
import 'package:weatherapp/services/weather_service.dart';
import 'package:flutter_sliding_up_panel/flutter_sliding_up_panel.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController, _slideController;
  late SlidingUpPanelController _panelController; // Add panel controller
  DateTime _currentDateTime = DateTime.now();
  late Timer _timer;
  late Timer _weatherTimer; // Timer for weather data updates

  @override
  void initState(){
    super.initState();
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    _panelController = SlidingUpPanelController(); // Initialize panel controller
    
    // Start the animations
    _fadeController.forward();
    _slideController.forward();
    
    // Update DateTime every second
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });
    
    // Update weather data every 2 minutes (120 seconds) for more frequent updates
    _weatherTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      _refreshWeatherData();
    });
    
    // Initial refresh of weather data
    Future.delayed(Duration(seconds: 1), () {
      _refreshWeatherData();
    });
  }

  @override
  void dispose(){
    _timer.cancel();
    _weatherTimer.cancel(); // Cancel weather timer
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  // Method to refresh weather data
  Future<void> _refreshWeatherData() async {
    // Invalidate the providers to force refresh
    ref.invalidate(currTemp);
    ref.invalidate(currFeelsLike);
    ref.invalidate(currWindSpeed);
    ref.invalidate(currHumidity);
    ref.invalidate(description);
    ref.invalidate(currLocation);
    ref.invalidate(countryLocation); // Also refresh country location
    
    // Wait a bit to ensure providers have time to refresh
    await Future.delayed(Duration(milliseconds: 500));
    
    print('Weather data refreshed at ${DateTime.now()}'); // Debug print
  }
  String formatDateTime(DateTime dateTime){
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  @override
  Widget build(BuildContext context) {
    // Get screen dimensions for responsive design
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;
    
    return Scaffold(
      body: Stack(
        children: [
          // Background Image Layer
          _buildBackgroundImage(),
          
          // Centered Temperature Display with Description below
          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGradientTemperatureText(isTablet),
                SizedBox(height: screenHeight * 0.02), // Small spacing between temperature and description
                Text(ref.watch(description).when(
                    data: (desc) => desc,
                    loading: () => 'Loading...',
                    error: (error, stack) => 'Error: $error',
                  ),
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: isTablet ? 24 : 18,
                    fontWeight: FontWeight.w600,
                    shadows: [
                      Shadow(
                        offset: Offset(2, 2),
                        blurRadius: 4,
                        color: Colors.black.withValues(alpha: 0.8),
                      ),
                    ],
                  ),
                  textAlign: TextAlign.center,
                ),
              ],
            ),
          ),
          
          // Other content positioned at top
          Positioned(
            top: screenHeight * 0.02, // 2% from top (responsive)
            left: screenWidth * 0.005,  // 0.5% from left (responsive)
            right: screenWidth * 0.005,  // Add right constraint for proper width
            child: RefreshIndicator(
              onRefresh: _refreshWeatherData,
              color: Colors.white,
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(), // Enable pull to refresh
                child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, // 4% horizontal padding
                vertical: screenHeight * 0.02,  // 2% vertical padding
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start, // Align items to start
                mainAxisSize: MainAxisSize.min, // Take only needed space
                children: [
                  // Location Row
                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(
                        Icons.location_on,
                        color: Colors.white,
                        size: isTablet ? 32 : 24,
                        shadows: [
                          Shadow(
                            offset: Offset(2, 2),
                            blurRadius: 4,
                            color: Colors.black.withValues(alpha: 0.8),
                          ),
                        ],
                      ),
                      SizedBox(width: 8),
                      Flexible( // Allow text to wrap if needed
                        child: Text(
                          ref.watch(currLocation).when(
                            data: (city) => city ?? 'Current Location',
                            loading: () => 'Loading...',
                            error: (error, stack) => 'Error: $error',
                          ),
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: isTablet ? 32 : 20, // Larger font on tablets
                            fontWeight: FontWeight.bold,
                            shadows: [
                              Shadow(
                                offset: Offset(2, 2),
                                blurRadius: 4,
                                color: Colors.black.withValues(alpha: 0.8),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  
                  // Add spacing between location and next content
                  SizedBox(height: screenHeight * 0.03), // 3% of screen height

                  Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        "Today, ${formatDateTime(_currentDateTime)}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: isTablet ? 24 : 16, // Responsive font size
                          fontWeight: FontWeight.w600,
                          shadows: [
                            Shadow(
                              offset: Offset(2, 2),
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.8),
                            ),
                          ],
                        ),
                      )
                    ],
                  ),

                  // Add spacing between location and next content
                  SizedBox(height: screenHeight * 0.07), // 7% of screen height

                  //Gradient Feels like temperature
                  _buildGradientFeelsLikeText(isTablet),

                ],
              ),
            ),
                ), // Close SingleChildScrollView
              ), // Close RefreshIndicator
            ), // Close Positioned
          
          // Sliding Up Panel
          SlidingUpPanelWidget(
            controlHeight: screenHeight * 0.2,
            panelController: _panelController,
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.1),
                    blurRadius: 10,
                    spreadRadius: 2,
                  ),
                ],
              ),
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
              child: Column(
                children: [
                  // Drag handle
                  Container(
                    width: 40,
                    height: 5,
                    margin: EdgeInsets.only(bottom: 15),
                    decoration: BoxDecoration(
                      color: Colors.grey[400],
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                  // Panel content
                  Text(
                    'Weather Details',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Additional weather information will appear here...',
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBackgroundImage(){
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child){
        return Transform.translate(
          offset: Offset(0, -20 * _slideController.value),
          child: Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/Background image.jpg'),
                fit: BoxFit.cover,
                alignment: Alignment.center,
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientTemperatureText(bool isTablet) {
    final weatherService = WeatherProvider(); // Create instance to access conversion method
    
    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(currTemp).when(
          data: (temp) => ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Color(0xFFF8E8D8), // Soft cream (moon glow)
                Color(0xFFFFB899), // Warm peach (mountain highlights)
                Color(0xFF87CEEB), // Sky blue (twilight)
                Color(0xFF4682B4), // Steel blue (deeper sky)
                Color(0xFF2F4F4F), // Dark slate gray (mountain shadows)
              ],
              stops: [0.0, 0.2, 0.5, 0.8, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${weatherService.kelvinToCelsius(temp).toStringAsFixed(1)}°',
                    style: TextStyle(
                      color: Colors.white, // This will be replaced by gradient
                      fontSize: isTablet ? 100 : 80, // Even larger for more impact
                      fontWeight: FontWeight.w900, // Maximum boldness
                      letterSpacing: 1.2, // Slightly spaced letters
                      shadows: [
                        Shadow(
                          offset: Offset(3, 3),
                          blurRadius: 8,
                          color: Colors.black.withValues(alpha: 0.4),
                        ),
                        Shadow(
                          offset: Offset(-1, -1),
                          blurRadius: 4,
                          color: Colors.black.withValues(alpha: 0.2),
                        ),
                      ],
                    ),
                  ),
                  WidgetSpan(
                    child: Transform.translate(
                      offset: Offset(0, -(isTablet ? 16.0 : 12.0)), // Move C up like superscript
                      child: Text(
                        'C',
                        style: TextStyle(
                          color: Colors.white, // This will be replaced by gradient
                          fontSize: (isTablet ? 64 : 48) * 0.5, // Smaller superscript
                          fontWeight: FontWeight.w900,
                          letterSpacing: 1.2,
                          shadows: [
                            Shadow(
                              offset: Offset(3, 3),
                              blurRadius: 8,
                              color: Colors.black.withValues(alpha: 0.4),
                            ),
                            Shadow(
                              offset: Offset(-1, -1),
                              blurRadius: 4,
                              color: Colors.black.withValues(alpha: 0.2),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          loading: () => Text(
            'Loading temperature...',
            style: TextStyle(
              color: Colors.white,
              fontSize: isTablet ? 24 : 18,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
          error: (error, stack) => Text(
            'Error: $error',
            style: TextStyle(
              color: Colors.redAccent,
              fontSize: isTablet ? 20 : 16,
              fontWeight: FontWeight.w500,
              shadows: [
                Shadow(
                  offset: Offset(1, 1),
                  blurRadius: 3,
                  color: Colors.black.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildGradientFeelsLikeText(bool isTablet){
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1), // Semi-transparent background
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 16, // Responsive padding
        vertical: isTablet ? 16 : 8, // Responsive padding
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [ 
          Expanded(
            child: Text(
              ref.watch(currFeelsLike).when(
                data: (data) => 'Feels like ${WeatherProvider().kelvinToCelsius(data).toStringAsFixed(1)} °C',
                error: (error, stack) => 'Error',
                loading: () => 'Loading...',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 20 : 12, // Smaller font to fit
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Center the text
            ),
          ),
          Container(
            height: isTablet ? 30 : 25, // Responsive height
            width: 1,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 8), // Add margin
          ),
          Expanded(
            child: Text(ref.watch(currWindSpeed).when(
                data: (data) => 'Wind ${data.toStringAsFixed(1)} m/s',
                error: (error, stack) => 'Error',
                loading: () => 'Loading...',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 20 : 12, // Smaller font to fit
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Center the text
            ),
          ),
          Container(
            height: isTablet ? 30 : 25, // Responsive height
            width: 1,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 8), // Add margin
          ),
          Expanded(
            child: Text(ref.watch(currHumidity).when(
                data: (data) => 'Humidity ${data.toStringAsFixed(1)}%',
                error: (error, stack) => 'Error',
                loading: () => 'Loading...',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 20 : 12, // Smaller font to fit
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ],
              ),
              textAlign: TextAlign.center, // Center the text
            ),
          ),
        ],
      ),
    );
  }
}