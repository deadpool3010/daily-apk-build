import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:math' as math;

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _centerLogoController;
  late AnimationController _rightCircleController;
  late AnimationController _belowHandController;
  late AnimationController _textController;
  late AnimationController _backgroundController;

  late Animation<double> _centerLogoScale;
  late Animation<double> _rightCircleOpacity;
  late Animation<double> _rightCircleScale;
  late Animation<double> _belowHandOpacity;
  late Animation<double> _belowHandPosition;
  late Animation<double> _textOpacity;
  late Animation<double> _backgroundOpacity;

  @override
  void initState() {
    super.initState();

    // Initialize animation controllers
    _centerLogoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    _rightCircleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _belowHandController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    _backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    // Initialize animations
    _centerLogoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: _centerLogoController, curve: Curves.easeOut),
    );

    _rightCircleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _rightCircleController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Scale up the circle as it wraps around
    _rightCircleScale = Tween<double>(begin: 0.6, end: 1.1).animate(
      CurvedAnimation(parent: _rightCircleController, curve: Curves.easeInOut),
    );

    _belowHandOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _belowHandController, curve: Curves.easeIn),
    );

    // Hand comes from BOTTOM and settles below center (not used for positioning anymore, kept for compatibility)
    _belowHandPosition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _belowHandController, curve: Curves.easeInOut),
    );

    _textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: _textController, curve: Curves.easeIn));

    _backgroundOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _backgroundController, curve: Curves.easeInOut),
    );

    // Start animations
    _startAnimations();

    // Navigate to main screen after delay
    Timer(const Duration(seconds: 5), () {
      _navigateToMain();
    });
  }

  void _startAnimations() {
    // Start center logo scaling immediately
    _centerLogoController.forward();

    // Right circle appears and animates after 600ms
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _rightCircleController.forward();
    });

    // Below hand appears after 1400ms
    Future.delayed(const Duration(milliseconds: 1400), () {
      if (mounted) _belowHandController.forward();
    });

    // Text appears after 1800ms
    Future.delayed(const Duration(milliseconds: 1800), () {
      if (mounted) _textController.forward();
    });

    // Background changes after 2000ms
    Future.delayed(const Duration(milliseconds: 2000), () {
      if (mounted) _backgroundController.forward();
    });
  }

  void _navigateToMain() {
    if (mounted) {
      Navigator.of(context).pushReplacementNamed('/login');
    }
  }

  @override
  void dispose() {
    _centerLogoController.dispose();
    _rightCircleController.dispose();
    _belowHandController.dispose();
    _textController.dispose();
    _backgroundController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final centerX = screenWidth / 2;
    final centerY = screenHeight / 2;

    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        child: Stack(
          children: [
            // Right Circle (Crescent) - flips horizontally and wraps around
            AnimatedBuilder(
              animation: Listenable.merge([
                _rightCircleOpacity,
                _rightCircleScale,
                _rightCircleController,
              ]),
              builder: (context, child) {
                // Interpolate between start (right) and end (left) positions
                final progress = _rightCircleController.value;

                // Start position: right side off-screen
                // End position: left side wrapped around (from Figma: left: 108.25)
                final startX = screenWidth; // Start from right off-screen
                final endX = 108.25;
                final currentX = startX + (endX - startX) * progress;

                // Vertical position from Figma: top: 298.59
                final startY = centerY - 73; // Approximate starting position
                final endY = 298.59;
                final currentY = startY + (endY - startY) * progress;

                return Positioned(
                  left: currentX,
                  top: currentY,
                  child: Opacity(
                    opacity: _rightCircleOpacity.value,
                    child: Transform(
                      alignment: Alignment.center,
                      transform: Matrix4.identity()
                        ..scale(_rightCircleScale.value)
                        ..rotateY(math.pi * progress), // Flip horizontally
                      child: Container(
                        width: 137,
                        height: 147,
                        child: Image.asset(
                          'assets/right_circle.png',
                          fit: BoxFit.contain,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              width: 137,
                              height: 147,
                              decoration: BoxDecoration(
                                color: const Color(0xFF60A5FA).withOpacity(0.8),
                                borderRadius: BorderRadius.circular(70),
                              ),
                            );
                          },
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),

            // Center Logo (appears on top)
            AnimatedBuilder(
              animation: _centerLogoScale,
              builder: (context, child) {
                return Positioned(
                  left: 137.32,
                  top: 358.69,
                  child: Transform.scale(
                    scale: _centerLogoScale.value,
                    child: Container(
                      width: 106,
                      height: 79,
                      child: Image.asset(
                        'assets/center.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 106,
                            height: 79,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(40),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  blurRadius: 10,
                                  spreadRadius: 2,
                                ),
                              ],
                            ),
                            child: const Icon(
                              Icons.person,
                              size: 45,
                              color: Color(0xFF282C34),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            // Below Hand - comes from bottom, centers below logo
            AnimatedBuilder(
              animation: Listenable.merge([
                _belowHandOpacity,
                _belowHandPosition,
              ]),
              builder: (context, child) {
                // Calculate position from Figma: left: 91.36, top: 280.41
                final progress = _belowHandController.value;
                final startY = screenHeight; // Start from bottom off-screen
                final endY = 280.41; // Final position from Figma
                final currentY = startY + (endY - startY) * progress;

                return Positioned(
                  left: 91.36,
                  top: currentY,
                  child: Opacity(
                    opacity: _belowHandOpacity.value,
                    child: Container(
                      width: 225,
                      height: 221,
                      child: Image.asset(
                        'assets/below_hand.png',
                        fit: BoxFit.contain,
                        errorBuilder: (context, error, stackTrace) {
                          return Container(
                            width: 225,
                            height: 221,
                            decoration: BoxDecoration(
                              color: const Color(0xFF1E40AF).withOpacity(0.9),
                              borderRadius: BorderRadius.circular(110),
                            ),
                          );
                        },
                      ),
                    ),
                  ),
                );
              },
            ),

            // BandhuCare Text
            AnimatedBuilder(
              animation: _textOpacity,
              builder: (context, child) {
                return Positioned(
                  left: centerX - 100,
                  bottom: 150,
                  child: Opacity(
                    opacity: _textOpacity.value,
                    child: Image.asset(
                      'assets/bandhu_care_text.png',
                      width: 200,
                      fit: BoxFit.contain,
                      errorBuilder: (context, error, stackTrace) {
                        return Text(
                          'Bandhu Care',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xFF1E3A8A),
                          ),
                        );
                      },
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
