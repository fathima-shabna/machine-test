import 'dart:ui';
import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/splash_background.jpg',
              fit: BoxFit.cover,
            ),
          ),
      
          Positioned.fill(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 5.0, sigmaY: 5.0),
              child: Container(
                color: Colors.black.withOpacity(0.3),
              ),
            ),
          ),
         
          Center(
            child: Image.asset(
              'assets/Layer_1-2.png',
              width: 180, 
              fit: BoxFit.contain,
            ),
          ),
        ],
      ),
    );
  }
}
