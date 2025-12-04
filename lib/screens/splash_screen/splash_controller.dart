import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'dart:async';
import 'package:bandhucare_new/constant/variables.dart';
import 'package:bandhucare_new/routes/routes.dart';
import 'package:bandhucare_new/services/shared_pref_localization.dart';

class SplashController extends GetxController with GetTickerProviderStateMixin {
  // Navigation Timer
  Timer? _navigationTimer;
  bool _hasNavigated = false;

  // Animation Controllers
  late AnimationController centerLogoController;
  late AnimationController rightCircleController;
  late AnimationController belowHandController;
  late AnimationController textController;
  late AnimationController backgroundController;

  // Animations
  late Animation<double> centerLogoScale;
  late Animation<double> rightCircleOpacity;
  late Animation<double> rightCircleScale;
  late Animation<double> belowHandOpacity;
  late Animation<double> belowHandPosition;
  late Animation<double> textOpacity;
  late Animation<double> backgroundProgress;
  late Animation<Color?> logoColor;
  late Animation<Color?> rightCircleColor;
  late Animation<Color?> belowHandColor;
  late Animation<Color?> textColor;
  late Animation<double> logoFadeOpacity;
  late Animation<double> rightCircleFadeOpacity;
  late Animation<double> belowHandFadeOpacity;
  late Animation<double> textFadeOpacity;
  late Animation<double> logoFadeOutOpacity;
  late Animation<double> rightCircleFadeOutOpacity;
  late Animation<double> belowHandFadeOutOpacity;
  late Animation<double> textFadeOutOpacity;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimationControllers();
    _initializeAnimations();
    _startAnimations();
    _startNavigationTimer();
  }

  void _initializeAnimationControllers() {
    // Initialize animation controllers
    centerLogoController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );

    rightCircleController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    belowHandController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    textController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );

    backgroundController = AnimationController(
      duration: const Duration(milliseconds: 1800), // Faster animation
      vsync: this,
    );
  }

  void _initializeAnimations() {
    // Initialize animations
    centerLogoScale = Tween<double>(begin: 0.3, end: 1.0).animate(
      CurvedAnimation(parent: centerLogoController, curve: Curves.easeOut),
    );

    rightCircleOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: rightCircleController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );

    // Scale up the circle as it wraps around
    rightCircleScale = Tween<double>(begin: 0.6, end: 1.1).animate(
      CurvedAnimation(parent: rightCircleController, curve: Curves.easeInOut),
    );

    belowHandOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: belowHandController, curve: Curves.easeIn),
    );

    // Hand comes from BOTTOM and settles below center
    belowHandPosition = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: belowHandController, curve: Curves.easeInOut),
    );

    textOpacity = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(CurvedAnimation(parent: textController, curve: Curves.easeIn));

    // Background animation progress (0.0 = bottom, 1.0 = top)
    // Using easeOutCubic for smoother upward animation
    backgroundProgress = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: backgroundController, curve: Curves.easeOutCubic),
    );

    // Logo color changes to white when background passes (around 0.5 progress)
    logoColor =
        ColorTween(
          begin: null, // Original image color
          end: Colors.white,
        ).animate(
          CurvedAnimation(
            parent: backgroundController,
            curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
          ),
        );

    // Right circle color changes to white when background passes
    rightCircleColor =
        ColorTween(
          begin: null, // Original image color
          end: Color(0xFF89A0FD),
        ).animate(
          CurvedAnimation(
            parent: backgroundController,
            curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
          ),
        );

    // Below hand color changes to white when background passes
    belowHandColor =
        ColorTween(
          begin: null, // Original image color
          end: Color(0xFF89A0FD),
        ).animate(
          CurvedAnimation(
            parent: backgroundController,
            curve: const Interval(0.3, 0.7, curve: Curves.easeInOut),
          ),
        );

    // Text color changes to white when background passes
    textColor =
        ColorTween(
          begin: null, // Original image color
          end: Colors.white,
        ).animate(
          CurvedAnimation(
            parent: backgroundController,
            curve: const Interval(0.4, 0.8, curve: Curves.easeInOut),
          ),
        );

    // Fade-in opacity animations when color changes - using linear for smooth fade
    logoFadeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.3, 0.7, curve: Curves.linear),
      ),
    );

    rightCircleFadeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.3, 0.7, curve: Curves.linear),
      ),
    );

    belowHandFadeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.3, 0.7, curve: Curves.linear),
      ),
    );

    textFadeOpacity = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.4, 0.8, curve: Curves.linear),
      ),
    );

    // Fade-out opacity animations for original images - fade out while white version fades in
    logoFadeOutOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.3, 0.7, curve: Curves.linear),
      ),
    );

    rightCircleFadeOutOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.3, 0.7, curve: Curves.linear),
      ),
    );

    belowHandFadeOutOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.3, 0.7, curve: Curves.linear),
      ),
    );

    textFadeOutOpacity = Tween<double>(begin: 1.0, end: 0.0).animate(
      CurvedAnimation(
        parent: backgroundController,
        curve: const Interval(0.4, 0.8, curve: Curves.linear),
      ),
    );
  }

  void _startAnimations() {
    // Start center logo scaling immediately
    centerLogoController.forward();

    // Right circle appears and animates after 600ms
    Future.delayed(const Duration(milliseconds: 600), () {
      rightCircleController.forward();
    });

    // Below hand appears after 1400ms
    Future.delayed(const Duration(milliseconds: 1400), () {
      belowHandController.forward();
    });

    // Text appears after 1800ms
    Future.delayed(const Duration(milliseconds: 1800), () {
      textController.forward();
    });

    // Background animation starts after all images complete (2800ms)
    Future.delayed(const Duration(milliseconds: 2800), () {
      backgroundController.forward();
    });
  }

  void _startNavigationTimer() {
    // Wait for all animations: images (2800ms) + background (1200ms) = 4000ms + buffer
    _navigationTimer = Timer(const Duration(milliseconds: 4400), () {
      _decideNextRoute();
    });
  }

  Future<void> _decideNextRoute() async {
    if (_hasNavigated) return;

    // Check if we're still on the splash screen route
    if (Get.currentRoute != AppRoutes.splashScreen) {
      _hasNavigated = true;
      return;
    }

    _hasNavigated = true;

    final sharedPrefs = SharedPrefLocalization();
    final hasUser = await sharedPrefs.hasPersistedUser();

    if (hasUser) {
      final tokens = await sharedPrefs.getTokens();
      accessToken = tokens['accessToken'] ?? '';
      refreshToken = tokens['refreshToken'] ?? '';
      final cachedUser = await sharedPrefs.getUserInfoMap();

      print('');
      print('========================================');
      print('👤 Restored persisted user session from storage');
      print('🔑 Access token available: ${accessToken.isNotEmpty}');
      print('📄 Cached profile: $cachedUser');
      print('========================================');

      if (Get.context != null && Get.currentRoute == AppRoutes.splashScreen) {
        Get.offNamed(AppRoutes.homeScreen);
      }
    } else {
      if (Get.context != null && Get.currentRoute == AppRoutes.splashScreen) {
        Get.offNamed(AppRoutes.consentFormScreen);
      }
    }
  }

  @override
  void onClose() {
    // Cancel navigation timer first to prevent navigation
    _navigationTimer?.cancel();
    _hasNavigated = true; // Prevent any delayed navigation

    // Dispose animation controllers
    centerLogoController.dispose();
    rightCircleController.dispose();
    belowHandController.dispose();
    textController.dispose();
    backgroundController.dispose();

    super.onClose();
  }
}
