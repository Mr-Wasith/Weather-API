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

class _HomeScreenState extends ConsumerState<HomeScreen>
    with TickerProviderStateMixin {
  late AnimationController _fadeController, _slideController;
  late SlidingUpPanelController _panelController;
  DateTime _currentDateTime = DateTime.now();
  late Timer _timer;
  late Timer _weatherTimer;

  @override
  void initState() {
    super.initState();
    
    _fadeController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _slideController = AnimationController(
      duration: Duration(milliseconds: 1500),
      vsync: this,
    );
    
    _panelController = SlidingUpPanelController();

    _fadeController.forward();
    _slideController.forward();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      setState(() {
        _currentDateTime = DateTime.now();
      });
    });

    _weatherTimer = Timer.periodic(Duration(minutes: 2), (timer) {
      _refreshWeatherData();
    });

    Future.delayed(Duration(seconds: 1), () {
      _refreshWeatherData();
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    _weatherTimer.cancel();
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
  }

  Future<void> _refreshWeatherData() async {
    ref.invalidate(currTemp);
    ref.invalidate(currFeelsLike);
    ref.invalidate(currWindSpeed);
    ref.invalidate(currHumidity);
    ref.invalidate(description);
    ref.invalidate(currLocation);
    ref.invalidate(countryLocation);

    await Future.delayed(Duration(milliseconds: 500));
    print('Weather data refreshed at ${DateTime.now()}');
  }

  String formatDateTime(DateTime dateTime) {
    const months = [
      'Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun',
      'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'
    ];
    return '${months[dateTime.month - 1]} ${dateTime.day}, ${dateTime.year} ${dateTime.hour}:${dateTime.minute.toString().padLeft(2, '0')}';
  }
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isTablet = screenWidth > 600;

    return Scaffold(
      body: Stack(
        children: [
          _buildBackgroundImage(),

          Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildGradientTemperatureText(isTablet),
                SizedBox(height: screenHeight * 0.02),
                Text(
                  ref.watch(description).when(
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

          Positioned(
            top: screenHeight * 0.02,
            left: screenWidth * 0.005,
            right: screenWidth * 0.005,
            child: RefreshIndicator(
              onRefresh: _refreshWeatherData,
              color: Colors.white,
              backgroundColor: Colors.black.withValues(alpha: 0.5),
              child: SingleChildScrollView(
                physics: AlwaysScrollableScrollPhysics(),
                child: Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: screenWidth * 0.04,
                    vertical: screenHeight * 0.02,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
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
                          Flexible(
                            child: Text(
                              ref.watch(currLocation).when(
                                data: (city) => city ?? 'Current Location',
                                loading: () => 'Loading...',
                                error: (error, stack) => 'Error: $error',
                              ),
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: isTablet ? 32 : 20,
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

                      SizedBox(height: screenHeight * 0.03),

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "Today, ${formatDateTime(_currentDateTime)}",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: isTablet ? 24 : 16,
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

                      SizedBox(height: screenHeight * 0.07),

                      _buildGradientFeelsLikeText(isTablet),
                    ],
                  ),
                ),
              ),
            ),
          ),
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
                  Container(
                    width: 50,
                    height: 4,
                    margin: EdgeInsets.only(bottom: 20),
                    decoration: BoxDecoration(
                      color: Colors.grey[300],
                      borderRadius: BorderRadius.circular(3),
                    ),
                  ),

                  Text(
                    'Weather Details',
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w300,
                      color: Colors.black87,
                      letterSpacing: 1.0,
                    ),
                  ),

                  SizedBox(height: 25),

                  Expanded(
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      child: Column(
                        children: [
                          WeatherInfoCard(
                            icon: Icons.wb_sunny_outlined,
                            title: 'Sunrise',
                            content: ref.watch(sunriseTime),
                            formatter: (dynamic sunrise) {
                              if (sunrise is DateTime) {
                                return '${sunrise.hour.toString().padLeft(2, '0')}:${sunrise.minute.toString().padLeft(2, '0')}';
                              }
                              return sunrise.toString();
                            },
                            gradientColors: [
                              Color(0xFFFFE5B4),
                              Color(0xFFFFD700),
                              Color(0xFFFF8C69),
                              Color(0xFFFF6347),
                            ],
                            shadowColor: Colors.orange,
                          ),

                          SizedBox(height: 20),

                          WeatherInfoCard(
                            icon: Icons.wb_twighlight,
                            title: 'Sunset',
                            content: ref.watch(sunsetTime),
                            formatter: (dynamic sunset) {
                              if (sunset is DateTime) {
                                return '${sunset.hour.toString().padLeft(2, '0')}:${sunset.minute.toString().padLeft(2, '0')}';
                              }
                              return sunset.toString();
                            },
                            gradientColors: [
                              Color(0xFF667EEA),
                              Color(0xFF764BA2),
                              Color(0xFF2C3E50),
                              Color(0xFF0F2027),
                            ],
                            shadowColor: Colors.indigo,
                          ),

                          SizedBox(height: 20),

                          WeatherInfoCard(
                            icon: Icons.speed,
                            title: 'Pressure',
                            content: ref.watch(currPressure),
                            formatter: (dynamic pressure) => '${pressure} hPa',
                            gradientColors: [
                              Color(0xFF6C63FF),
                              Color(0xFF3F51B5),
                              Color(0xFF2196F3),
                              Color(0xFF00BCD4),
                            ],
                            shadowColor: Colors.purple,
                          ),

                          SizedBox(height: 20),

                          WeatherInfoCard(
                            icon: Icons.visibility,
                            title: 'Visibility',
                            content: ref.watch(currVisibility),
                            formatter: (dynamic visibility) {
                              if (visibility != null) {
                                return '${(visibility / 1000).toStringAsFixed(1)} km';
                              }
                              return 'N/A';
                            },
                            gradientColors: [
                              Color(0xFF48CAE4),
                              Color(0xFF0077B6),
                              Color(0xFF023E8A),
                              Color(0xFF03045E),
                            ],
                            shadowColor: Colors.cyan,
                          ),

                          SizedBox(height: 20),

                          WeatherInfoCard(
                            icon: Icons.cloud,
                            title: 'Cloud Cover',
                            content: ref.watch(currCloudiness),
                            formatter: (dynamic cloudiness) => '${cloudiness}%',
                            gradientColors: [
                              Color(0xFFE9ECEF),
                              Color(0xFFCED4DA),
                              Color(0xFF6C757D),
                              Color(0xFF495057),
                            ],
                            shadowColor: Colors.grey,
                          ),

                          SizedBox(height: 20),

                          WeatherInfoCard(
                            icon: Icons.grain,
                            title: 'Rain',
                            content: ref.watch(currRainVolume),
                            formatter: (dynamic rain) => '${rain.toStringAsFixed(1)} mm',
                            gradientColors: [
                              Color(0xFF74C0FC),
                              Color(0xFF339AF0),
                              Color(0xFF1C7ED6),
                              Color(0xFF1864AB),
                            ],
                            shadowColor: Colors.blue,
                          ),

                          SizedBox(height: 20),

                          WeatherInfoCard(
                            icon: Icons.ac_unit,
                            title: 'Snow',
                            content: ref.watch(currSnowVolume),
                            formatter: (dynamic snow) => '${snow.toStringAsFixed(1)} mm',
                            gradientColors: [
                              Color(0xFFF8F9FA),
                              Color(0xFFE9ECEF),
                              Color(0xFFDEE2E6),
                              Color(0xFFADB5BD),
                            ],
                            shadowColor: Colors.blueGrey,
                          ),

                          SizedBox(height: 30),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
  Widget _buildBackgroundImage() {
    return AnimatedBuilder(
      animation: _slideController,
      builder: (context, child) {
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
    final weatherService = WeatherProvider();

    return Consumer(
      builder: (context, ref, child) {
        return ref.watch(currTemp).when(
          data: (temp) => ShaderMask(
            shaderCallback: (bounds) => LinearGradient(
              colors: [
                Color(0xFFF8E8D8),
                Color(0xFFFFB899),
                Color(0xFF87CEEB),
                Color(0xFF4682B4),
                Color(0xFF2F4F4F),
              ],
              stops: [0.0, 0.2, 0.5, 0.8, 1.0],
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
            ).createShader(bounds),
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: '${weatherService.kelvinToCelsius(temp).toStringAsFixed(1)}°C',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: isTablet ? 100 : 80,
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

  Widget _buildGradientFeelsLikeText(bool isTablet) {
    return Container(
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.white,
          width: 2,
        ),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: isTablet ? 32 : 16,
        vertical: isTablet ? 16 : 8,
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
                fontSize: isTablet ? 20 : 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: isTablet ? 30 : 25,
            width: 1,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          Expanded(
            child: Text(
              ref.watch(currWindSpeed).when(
                data: (data) => 'Wind ${data.toStringAsFixed(1)} m/s',
                error: (error, stack) => 'Error',
                loading: () => 'Loading...',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 20 : 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Container(
            height: isTablet ? 30 : 25,
            width: 1,
            color: Colors.white,
            margin: EdgeInsets.symmetric(horizontal: 8),
          ),
          Expanded(
            child: Text(
              ref.watch(currHumidity).when(
                data: (data) => 'Humidity ${data.toStringAsFixed(1)}%',
                error: (error, stack) => 'Error',
                loading: () => 'Loading...',
              ),
              style: TextStyle(
                color: Colors.white,
                fontSize: isTablet ? 20 : 12,
                fontWeight: FontWeight.w600,
                shadows: [
                  Shadow(
                    offset: Offset(1, 1),
                    blurRadius: 3,
                    color: Colors.black.withValues(alpha: 0.6),
                  ),
                ],
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }
}

class WeatherInfoCard extends ConsumerWidget {
  final IconData icon;
  final String title;
  final AsyncValue<dynamic> content;
  final String Function(dynamic)? formatter;
  final List<Color> gradientColors;
  final Color shadowColor;

  const WeatherInfoCard({
    Key? key,
    required this.icon,
    required this.title,
    required this.content,
    this.formatter,
    required this.gradientColors,
    required this.shadowColor,
  }) : super(key: key);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: gradientColors,
          stops: [0.0, 0.3, 0.7, 1.0],
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: shadowColor.withValues(alpha: 0.2),
            blurRadius: 15,
            spreadRadius: 2,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(50),
                ),
                child: Icon(
                  icon,
                  color: Colors.white,
                  size: 32,
                ),
              ),
              SizedBox(width: 15),
              Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 22,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.2,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 4,
                      color: Colors.black.withValues(alpha: 0.2),
                    ),
                  ],
                ),
              ),
            ],
          ),
          
          SizedBox(height: 15),

          content.when(
            data: (data) => Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.3),
                  width: 1,
                ),
              ),
              child: Text(
                formatter != null ? formatter!(data) : data.toString(),
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w400,
                  letterSpacing: 2.0,
                  shadows: [
                    Shadow(
                      offset: Offset(0, 2),
                      blurRadius: 6,
                      color: Colors.black.withValues(alpha: 0.3),
                    ),
                  ],
                ),
              ),
            ),
            loading: () => Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Loading...',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),
            ),
            error: (error, stack) => Container(
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Unavailable',
                style: TextStyle(
                  color: Colors.white60,
                  fontSize: 18,
                  fontWeight: FontWeight.w300,
                  letterSpacing: 1.0,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}