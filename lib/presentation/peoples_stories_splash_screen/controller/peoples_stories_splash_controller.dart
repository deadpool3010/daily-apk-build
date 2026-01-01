import 'dart:async';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/routes/app_routes.dart';

class PeoplesStoriesSplashController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController animationController;
  late Animation<double> firstRingAnimation;
  late Animation<double> secondRingAnimation;
  late Animation<double> thirdRingAnimation;
  late Animation<double> centerCircleAnimation;

  Timer? _navigationTimer;
  bool _hasNavigated = false;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
    _startNavigationTimer();
  }

  void _initializeAnimations() {
    // Animation controller for concentric circles
    animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    // First ring animation - expands outward
    firstRingAnimation = Tween<double>(begin: 0.3, end: 1.2).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    // Second ring animation - expands after first
    secondRingAnimation = Tween<double>(begin: 0.3, end: 1.4).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.2, 0.7, curve: Curves.easeOut),
      ),
    );

    // Third ring animation - expands last
    thirdRingAnimation = Tween<double>(begin: 0.3, end: 1.6).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.4, 0.9, curve: Curves.easeOut),
      ),
    );

    // Center circle fades in
    centerCircleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: animationController,
        curve: const Interval(0.0, 0.3, curve: Curves.easeIn),
      ),
    );
  }

  void _startAnimations() {
    animationController.repeat(reverse: false);
  }

  void _startNavigationTimer() {
    // Navigate after 800ms delay as per design specs
    _navigationTimer = Timer(const Duration(milliseconds: 800), () {
      if (!_hasNavigated) {
        _navigateToPeoplesStories();
      }
    });
  }

  void _navigateToPeoplesStories() {
    if (_hasNavigated) return;
    
    _hasNavigated = true;
    
    // Navigate with transition as per design specs
    // Smart animate with ease in and out, 1000ms duration
    // For now, navigate back - the main People's Stories screen will be created next
    Future.delayed(const Duration(milliseconds: 100), () {
      // Navigate to the main People's Stories screen
      // The transition is defined in the route configuration
      Get.offNamed(AppRoutes.peoplesStoriesScreen);
    });
  }

  @override
  void onClose() {
    _navigationTimer?.cancel();
    _hasNavigated = true;
    animationController.dispose();
    super.onClose();
  }
}

