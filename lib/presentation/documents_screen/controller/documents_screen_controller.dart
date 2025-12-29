import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DocumentsScreenController extends GetxController with GetTickerProviderStateMixin {
  late AnimationController _animationController;
  final List<AnimationController> _cardAnimationControllers = [];
  final List<Animation<double>> _fadeAnimations = [];
  final List<Animation<Offset>> _slideAnimations = [];
  final List<Animation<double>> _scaleAnimations = [];

  @override
  void onInit() {
    super.onInit();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    // Create animations for 5 folder cards
    for (int i = 0; i < 5; i++) {
      final cardController = AnimationController(
        vsync: this,
        duration: const Duration(milliseconds: 600),
      );
      _cardAnimationControllers.add(cardController);

      // Fade animation
      final fadeAnimation = Tween<double>(
        begin: 0.0,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: cardController,
        curve: Interval(
          i * 0.15,
          1.0,
          curve: Curves.easeOut,
        ),
      ));
      _fadeAnimations.add(fadeAnimation);

      // Slide animation
      final slideAnimation = Tween<Offset>(
        begin: const Offset(0, 0.3),
        end: Offset.zero,
      ).animate(CurvedAnimation(
        parent: cardController,
        curve: Interval(
          i * 0.15,
          1.0,
          curve: Curves.easeOutCubic,
        ),
      ));
      _slideAnimations.add(slideAnimation);

      // Scale animation
      final scaleAnimation = Tween<double>(
        begin: 0.8,
        end: 1.0,
      ).animate(CurvedAnimation(
        parent: cardController,
        curve: Interval(
          i * 0.15,
          1.0,
          curve: Curves.easeOutBack,
        ),
      ));
      _scaleAnimations.add(scaleAnimation);
    }

    // Start animations
    _startAnimations();
  }

  void _startAnimations() {
    _animationController.forward();
    // Stagger the card animations
    for (int i = 0; i < _cardAnimationControllers.length; i++) {
      Future.delayed(Duration(milliseconds: 100 * i), () {
        _cardAnimationControllers[i].forward();
      });
    }
  }

  Animation<double> getFadeAnimation(int index) {
    if (index < _fadeAnimations.length) {
      return _fadeAnimations[index];
    }
    return AlwaysStoppedAnimation(1.0);
  }

  Animation<Offset> getSlideAnimation(int index) {
    if (index < _slideAnimations.length) {
      return _slideAnimations[index];
    }
    return AlwaysStoppedAnimation(Offset.zero);
  }

  Animation<double> getScaleAnimation(int index) {
    if (index < _scaleAnimations.length) {
      return _scaleAnimations[index];
    }
    return AlwaysStoppedAnimation(1.0);
  }

  @override
  void onClose() {
    _animationController.dispose();
    for (var controller in _cardAnimationControllers) {
      controller.dispose();
    }
    super.onClose();
  }
}

