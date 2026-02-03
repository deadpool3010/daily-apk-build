import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

/// Validator utility class for form validation and error handling
class Validator {
  // Private constructor to prevent instantiation
  Validator._();

  /// Validates phone number
  /// Returns true if valid, false otherwise
  /// Shows snackbar if invalid
  static bool validatePhoneNumber(String phone, {bool showError = true}) {
    if (phone.isEmpty) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter your mobile number',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
          titleStyle: GoogleFonts.lato(color: Colors.white, fontSize: 16, fontWeight: FontWeight.w600),
          messageStyle: GoogleFonts.lato(color: Colors.white, fontSize: 14, fontWeight: FontWeight.w400),
        );
      }
      return false;
    }

    if (phone.length != 10) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter a valid 10-digit phone number',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    // Check if phone contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(phone)) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Phone number should contain only digits',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    return true;
  }

  /// Validates OTP
  /// Returns true if valid, false otherwise
  /// Shows snackbar if invalid
  static bool validateOTP(String otp, {bool showError = true}) {
    if (otp.isEmpty) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter the OTP',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    if (otp.length != 6) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter complete 6-digit OTP',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    // Check if OTP contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(otp)) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'OTP should contain only digits',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    return true;
  }

  /// Validates email address
  /// Returns true if valid, false otherwise
  /// Shows snackbar if invalid
  static bool validateEmail(String email, {bool showError = true}) {
    if (email.isEmpty) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter your email address',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    final emailRegex = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );

    if (!emailRegex.hasMatch(email)) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter a valid email address',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    return true;
  }

  /// Validates password
  /// Returns true if valid, false otherwise
  /// Shows snackbar if invalid
  static bool validatePassword(String password, {bool showError = true}) {
    if (password.isEmpty) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter your password',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    if (password.length < 6) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Password must be at least 6 characters long',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    return true;
  }

  /// Validates Aadhaar number (12 digits)
  /// Returns true if valid, false otherwise
  /// Shows snackbar if invalid
  static bool validateAadhaarNumber(String aadhaar, {bool showError = true}) {
    if (aadhaar.isEmpty) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter your Aadhaar number',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    if (aadhaar.length != 12) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Please enter a valid 12-digit Aadhaar number',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    // Check if Aadhaar contains only digits
    if (!RegExp(r'^[0-9]+$').hasMatch(aadhaar)) {
      if (showError) {
        _showSnackbar(
          title: 'Validation Error',
          message: 'Aadhaar number should contain only digits',
          backgroundColor: Colors.red,
          duration: Duration(seconds: 2),
        );
      }
      return false;
    }

    return true;
  }

  /// Validates ABHA address
  /// Returns true if valid, false otherwise
  static bool validateAbhaAddress(String address) {
    // Min 8 characters, Max 18 characters
    if (address.length < 8 || address.length > 18) {
      return false;
    }

    // Count special characters (only dot and underscore allowed)
    int dotCount = address.split('.').length - 1;
    int underscoreCount = address.split('_').length - 1;

    // Maximum 1 dot and/or 1 underscore
    if (dotCount > 1 || underscoreCount > 1) {
      return false;
    }

    // Check for any other special characters
    RegExp allowedPattern = RegExp(r'^[a-zA-Z0-9._]+$');
    if (!allowedPattern.hasMatch(address)) {
      return false;
    }

    return true;
  }

  /// Extracts user-friendly error message from exception
  /// Removes technical prefixes and provides fallback messages
  static String extractErrorMessage(dynamic error) {
    String errorMessage = error.toString();

    // Remove common prefixes recursively
    while (errorMessage.startsWith('Exception: Exception: ')) {
      errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
    }
    while (errorMessage.startsWith('Exception: ')) {
      errorMessage = errorMessage.replaceFirst('Exception: ', '');
    }

    // Remove "Failed to sign in:" prefix if present
    if (errorMessage.startsWith('Failed to sign in: ')) {
      errorMessage = errorMessage.replaceFirst('Failed to sign in: ', '');
    }
    if (errorMessage.startsWith('Failed to verify OTP: ')) {
      errorMessage = errorMessage.replaceFirst('Failed to verify OTP: ', '');
    }
    if (errorMessage.startsWith('Failed to login: ')) {
      errorMessage = errorMessage.replaceFirst('Failed to login: ', '');
    }

    // Check for technical error patterns (stack traces, etc.)
    if (errorMessage.contains('at ') ||
        errorMessage.contains('package:') ||
        errorMessage.contains('dart:') ||
        (errorMessage.contains('Error:') && errorMessage.length > 100)) {
      // This looks like a technical error, use fallback messages
      if (errorMessage.toLowerCase().contains('mobile number') ||
          errorMessage.toLowerCase().contains('does not match')) {
        return 'The mobile number you entered is not registered. Please check and try again.';
      }
      if (errorMessage.toLowerCase().contains('otp') &&
          errorMessage.toLowerCase().contains('invalid')) {
        return 'Invalid OTP. Please enter the correct OTP or request a new one.';
      }
      if (errorMessage.toLowerCase().contains('session') ||
          errorMessage.toLowerCase().contains('expired')) {
        return 'Session expired. Please request OTP again.';
      }
      if (errorMessage.toLowerCase().contains('email')) {
        return 'Invalid email or password. Please check and try again.';
      }
      return 'Something went wrong. Please try again.';
    }

    // Provide user-friendly fallback messages for specific cases
    if (errorMessage.toLowerCase().contains('mobile number') &&
        errorMessage.toLowerCase().contains('does not match')) {
      return 'The mobile number you entered is not registered. Please check and try again.';
    }

    if (errorMessage.toLowerCase().contains('otp') &&
        (errorMessage.toLowerCase().contains('invalid') ||
            errorMessage.toLowerCase().contains('incorrect'))) {
      return 'Invalid OTP. Please enter the correct OTP or request a new one.';
    }

    if (errorMessage.toLowerCase().contains('session') ||
        errorMessage.toLowerCase().contains('expired')) {
      return 'Session expired. Please request OTP again.';
    }

    if (errorMessage.toLowerCase().contains('email') &&
        (errorMessage.toLowerCase().contains('invalid') ||
            errorMessage.toLowerCase().contains('not found'))) {
      return 'Invalid email or password. Please check and try again.';
    }

    // If message is too long or contains technical details, use generic message
    if (errorMessage.length > 150) {
      return 'Something went wrong. Please try again.';
    }

    // Return the cleaned message (should be user-friendly at this point)
    return errorMessage;
  }

  /// Safely shows GetX snackbar with overlay check
  /// Prevents overlay errors by using postFrameCallback
  static void showSnackbar({
    required String title,
    required String message,
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    _showSnackbar(
      title: title,
      message: message,
      backgroundColor: backgroundColor,
      duration: duration,
      position: position,
      titleStyle: titleStyle,
      messageStyle: messageStyle,
    );
  }

  /// Shows success snackbar
  static void showSuccessSnackbar(
    String message, {
    Duration? duration,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    _showSnackbar(
      title: 'Success',
      message: message,
      backgroundColor: Colors.green,
      duration: duration ?? Duration(seconds: 2),
      titleStyle: titleStyle,
      messageStyle: messageStyle,
    );
  }

  /// Shows error snackbar
  static void showErrorSnackbar(
    String message, {
    Duration? duration,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    _showSnackbar(
      title: 'Error',
      message: message,
      backgroundColor: Colors.red,
      duration: duration ?? Duration(seconds: 3),
      titleStyle: titleStyle,
      messageStyle: messageStyle,
    );
  }

  /// Shows warning snackbar
  static void showWarningSnackbar(
    String message, {
    Duration? duration,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    _showSnackbar(
      title: 'Warning',
      message: message,
      backgroundColor: Colors.orange,
      duration: duration ?? Duration(seconds: 2),
      titleStyle: titleStyle,
      messageStyle: messageStyle,
    );
  }

  /// Shows info snackbar
  static void showInfoSnackbar(
    String message, {
    Duration? duration,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    _showSnackbar(
      title: 'Info',
      message: message,
      backgroundColor: Colors.blue,
      duration: duration ?? Duration(seconds: 2),
      titleStyle: titleStyle,
      messageStyle: messageStyle,
    );
  }

  /// Private method to safely show snackbar
  /// Uses addPostFrameCallback to ensure overlay is available
  static void _showSnackbar({
    required String title,
    required String message,
    Color backgroundColor = Colors.red,
    Duration duration = const Duration(seconds: 3),
    SnackPosition position = SnackPosition.BOTTOM,
    TextStyle? titleStyle,
    TextStyle? messageStyle,
  }) {
    // Default text styles
    final defaultTitleStyle = titleStyle ??
        TextStyle(
          color: Colors.white,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        );

    final defaultMessageStyle = messageStyle ??
        TextStyle(
          color: Colors.white,
          fontSize: 14,
          fontWeight: FontWeight.w400,
        );

    // Use addPostFrameCallback to ensure overlay is available
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (Get.context != null && Get.isDialogOpen != true) {
        try {
          Get.snackbar(
            title,
            message,
            snackPosition: position,
            backgroundColor: backgroundColor,
            colorText: Colors.white,
            duration: duration,
            margin: EdgeInsets.all(16),
            titleText: Text(
              title,
              style: defaultTitleStyle,
            ),
            messageText: Text(
              message,
              style: defaultMessageStyle,
            ),
          );
        } catch (e) {
          // Fallback to print if snackbar fails
          print('Snackbar error: $e');
        }
      }
    });
  }
}

