// Home screen - displays current location weather
// This screen will show weather details for the user's current location
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:weatherapp/providers/location_provider.dart';

class HomeScreen extends ConsumerStatefulWidget {
  const HomeScreen({super.key});

  @override
  ConsumerState<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends ConsumerState<HomeScreen> with TickerProviderStateMixin {
  late AnimationController _fadeController, _slideController;


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
    // Start the animations
    _fadeController.forward();
    _slideController.forward();
  }

  @override
  void dispose(){
    _fadeController.dispose();
    _slideController.dispose();
    super.dispose();
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
          
          // Text with responsive styling and positioning
          Positioned(
            top: screenHeight * 0.02, // 2% from top (responsive)
            left: screenWidth * 0.005,  // 0.5% from left (responsive)
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: screenWidth * 0.04, // 4% horizontal padding
                vertical: screenHeight * 0.02,  // 2% vertical padding
              ),
              child: Row(
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
                  Text(
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
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ],
      )
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
}