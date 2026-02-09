import 'package:flutter/material.dart';

extension ContextExtensions on BuildContext {
  /// Check if device is using 3-button navigation
  bool get hasThreeButtonNavigation {
    return MediaQuery.of(this).padding.bottom >= 40;
  }

  /// Get bottom safe area padding
  double get bottomSafeArea => MediaQuery.of(this).padding.bottom;

  /// Get top safe area padding
  double get topSafeArea => MediaQuery.of(this).padding.top;

  /// Get screen width
  double get screenWidth => MediaQuery.of(this).size.width;

  /// Get screen height
  double get screenHeight => MediaQuery.of(this).size.height;

  /// Check if landscape
  bool get isLandscape =>
      MediaQuery.of(this).orientation == Orientation.landscape;

  /// Check if tablet
  bool get isTablet => MediaQuery.of(this).size.width > 600;
}

// can u explain this and explain extension also
