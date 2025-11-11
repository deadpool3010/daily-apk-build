import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:bandhucare_new/screens/chat_bot_screen.dart';

class ChatbotSplashLoadingScreen extends StatefulWidget {
  const ChatbotSplashLoadingScreen({super.key});

  @override
  State<ChatbotSplashLoadingScreen> createState() =>
      _ChatbotSplashLoadingScreenState();
}

class _ChatbotSplashLoadingScreenState extends State<ChatbotSplashLoadingScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _bounceAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _bounceAnimation = TweenSequence<double>([
      // Initial drop down to Mitra top
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 200.0,
          end: 390.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 20,
      ),
      // First bounce up (highest)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 390.0,
          end: 310.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 15,
      ),
      // Second drop
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 310.0,
          end: 390.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 15,
      ),
      // Second bounce up (medium height)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 390.0,
          end: 340.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 12,
      ),
      // Third drop
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 340.0,
          end: 390.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 12,
      ),
      // Third bounce up (smaller)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 390.0,
          end: 365.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 10,
      ),
      // Fourth drop
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 365.0,
          end: 390.0,
        ).chain(CurveTween(curve: Curves.easeIn)),
        weight: 8,
      ),
      // Fourth bounce up (tiny)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 390.0,
          end: 378.0,
        ).chain(CurveTween(curve: Curves.easeOut)),
        weight: 8,
      ),
      // Final settle on Mitra top
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 378.0,
          end: 385.0,
        ).chain(CurveTween(curve: Curves.easeInOut)),
        weight: 10,
      ),
    ]).animate(_animationController);

    // Start animation and navigate when done
    _animationController.forward().then((_) {
      // Wait a moment after animation completes, then navigate
      if (mounted) {
        Future.delayed(Duration(milliseconds: 800), () {
          if (mounted) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => ChatBotScreen()),
            );
          }
        });
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xFF5C83F3),
      body: Stack(
        children: [
          // First star with gradient and layer blur - partially visible at top
          Positioned(
            left: 150,
            top: -300,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 600,
                height: 600,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFAF8EF6), // #AF8EF6 at 0%
                      Color(0xFFF5DAFB), // #F5DAFB at 100%
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Second star with gradient and layer blur
          Positioned(
            top: 500,
            right: 300,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFAF8EF6), // #AF8EF6 at 0%
                      Color(0xFFF5DAFB), // #F5DAFB at 100%
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            left: 300,
            top: 750,
            child: ImageFiltered(
              imageFilter: ImageFilter.blur(sigmaX: 100, sigmaY: 100),
              child: Container(
                width: 300,
                height: 300,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      Color(0xFFAF8EF6), // #AF8EF6 at 0%
                      Color(0xFFF5DAFB), // #F5DAFB at 100%
                    ],
                    stops: [0.0, 1.0],
                  ),
                ),
              ),
            ),
          ),

          // Robot image at specific position
          Positioned(
            top: 100,
            left: 0,
            right: 0,
            child: Center(
              child: Image(
                image: AssetImage('assets/Introducing.png'),
                fit: BoxFit.contain,
                height: 48,
                width: 212,
              ),
            ),
          ),

          // Mitra widget at specific position (using simple Container to avoid rendering conflicts)
          Positioned(
            bottom: 250,
            left: 0,
            right: 0,
            child: Center(
              child: Container(
                width: 150,
                height: 132,
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 5,
                    ),
                  ],
                ),
                child: Center(
                  child: Image(
                    image: AssetImage('assets/Mitra.png'),
                    fit: BoxFit.contain,
                    height: 28,
                    width: 99,
                  ),
                ),
              ),
            ),
          ),

          // Robot with bounce animation - placed AFTER Mitra so it appears on top
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Positioned(
                top: _bounceAnimation.value,
                left: 0,
                right: 0,
                child: RepaintBoundary(child: child!),
              );
            },
            child: Center(
              child: Image(
                image: AssetImage('assets/robot2.png'),
                fit: BoxFit.contain,
                height: 139.77,
                width: 88.24,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
