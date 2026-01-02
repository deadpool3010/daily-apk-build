import 'package:flutter/material.dart';
import 'package:get/get.dart';

class PeoplesStoriesSplashController extends GetxController
    with GetTickerProviderStateMixin {
  late AnimationController centerImageController;
  final List<AnimationController> orbitImageControllers = [];
  final List<Animation<double>> orbitImageAnimations = [];

  late AnimationController headingTextController;
  late AnimationController subtitleTextController;
  late AnimationController buttonController;

  late Animation<double> centerScaleAnimation;
  late Animation<double> centerOpacityAnimation;

  late Animation<Offset> headingSlideAnimation;
  late Animation<double> headingFadeAnimation;
  late Animation<Offset> subtitleSlideAnimation;
  late Animation<double> subtitleFadeAnimation;
  late Animation<Offset> buttonSlideAnimation;
  late Animation<double> buttonFadeAnimation;

  static const int orbitImageCount = 8;

  @override
  void onInit() {
    super.onInit();
    _initializeAnimations();
    _startAnimations();
  }

  void _initializeAnimations() {
    // Center image: zoom in then zoom out animation (scale from small to normal to larger)
    centerImageController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    centerScaleAnimation = TweenSequence<double>([
      // Zoom in: from small (0.3) to normal (1.0)
      TweenSequenceItem(
        tween: Tween<double>(
          begin: 0.0,
          end: 1.2,
        ).chain(CurveTween(curve: Curves.easeOutCubic)),
        weight: 40,
      ),
      // Zoom out: from normal (1.0) to larger (1.2)
      // TweenSequenceItem(
      //   tween: Tween<double>(
      //     begin: 1.0,
      //     end: 1.2,
      //   ).chain(CurveTween(curve: Curves.easeInCubic)),
      //   weight: 40,
      // ),
    ]).animate(centerImageController);

    centerOpacityAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: centerImageController,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    // Orbiting images: each with its own controller for simultaneous animation
    for (int i = 0; i < orbitImageCount; i++) {
      final controller = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 700),
      );

      final animation = Tween<double>(begin: 0.0, end: 1.0).animate(
        CurvedAnimation(parent: controller, curve: Curves.easeOutCubic),
      );

      orbitImageControllers.add(controller);
      orbitImageAnimations.add(animation);
    }

    // Text animations: slide from bottom to top with fade in
    headingTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    headingSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start from below (50% down)
      end: Offset.zero, // End at normal position
    ).animate(
      CurvedAnimation(
        parent: headingTextController,
        curve: Curves.easeOutCubic,
      ),
    );

    headingFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: headingTextController,
        curve: Curves.easeIn,
      ),
    );

    subtitleTextController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    subtitleSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start from below (50% down)
      end: Offset.zero, // End at normal position
    ).animate(
      CurvedAnimation(
        parent: subtitleTextController,
        curve: Curves.easeOutCubic,
      ),
    );

    subtitleFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: subtitleTextController,
        curve: Curves.easeIn,
      ),
    );

    // Button animation: slide from bottom to top with fade in
    buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    buttonSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.5), // Start from below (50% down)
      end: Offset.zero, // End at normal position
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.easeOutCubic,
      ),
    );

    buttonFadeAnimation = Tween<double>(
      begin: 0.0,
      end: 1.0,
    ).animate(
      CurvedAnimation(
        parent: buttonController,
        curve: Curves.easeIn,
      ),
    );
  }

  void _startAnimations() {
    // Start center image animation immediately
    centerImageController.forward();

    // Start all orbiting images animation simultaneously (at the same time)
    Future.delayed(const Duration(milliseconds: 300), () {
      for (int i = 0; i < orbitImageCount; i++) {
        if (i < orbitImageControllers.length) {
          orbitImageControllers[i].forward();
        }
      }
    });

    // Start text animations with delay (after images start animating)
    Future.delayed(const Duration(milliseconds: 600), () {
      headingTextController.forward();
    });

    Future.delayed(const Duration(milliseconds: 800), () {
      subtitleTextController.forward();
    });

    // Start button animation after subtitle
    Future.delayed(const Duration(milliseconds: 1000), () {
      buttonController.forward();
    });
  }

  Animation<double> getOrbitAnimation(int index) {
    if (index >= 0 && index < orbitImageAnimations.length) {
      return orbitImageAnimations[index];
    }
    return AlwaysStoppedAnimation(1.0);
  }

  @override
  void onClose() {
    centerImageController.dispose();
    headingTextController.dispose();
    subtitleTextController.dispose();
    buttonController.dispose();
    for (var controller in orbitImageControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}
