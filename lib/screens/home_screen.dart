// Home screen - displays current location weather
// This screen will show weather details for the user's current location
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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
    return Scaffold(
      body: Stack(
        children: [
          // Background Image Layer
          _buildBackgroundImage()
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