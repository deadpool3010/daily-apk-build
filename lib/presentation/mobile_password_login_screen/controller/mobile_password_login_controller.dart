import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:bandhucare_new/core/utils/validator.dart';

class MobilePasswordLoginController extends GetxController {
  late TextEditingController mobileController;
  late TextEditingController passwordController;

  final isPasswordVisible = false.obs;
  final rememberMe = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    mobileController = TextEditingController();
    passwordController = TextEditingController();
  }

  @override
  void onClose() {
    mobileController.dispose();
    passwordController.dispose();
    super.onClose();
  }

  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  void toggleRememberMe() {
    rememberMe.value = !rememberMe.value;
  }

  // Validate mobile number using Validator utility
  bool validateMobileNumber(String mobile) {
    return Validator.validatePhoneNumber(mobile);
  }

  // Validate password using Validator utility
  bool validatePassword(String password) {
    return Validator.validatePassword(password);
  }

  Future<void> handleLogin() async {
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    // Validate mobile number - this will show snackbar if invalid
    if (mobile.isEmpty) {
      Validator.showErrorSnackbar('Please enter your mobile number');
      return;
    }

    if (!validateMobileNumber(mobile)) {
      return;
    }

    // Validate password - this will show snackbar if invalid
    if (password.isEmpty) {
      Validator.showErrorSnackbar('Please enter your password');
      return;
    }

    if (!validatePassword(password)) {
      return;
    }

    isLoading.value = true;

    try {
      // Call sign-in API with mobile number and password
      final result = await signInWithCredentialsApi(
        emailNumber: mobile,
        password: password,
      );

      // Check if login was successful
      // Backend may return success: false even with 200 status code
      if (result['success'] == true) {
        Validator.showSuccessSnackbar(
          result['message'] ?? "Login successful!",
        );

        // After successful signInWithCredentialsApi, call updateFcmTokenApi
        // Use fcmToken from variables.dart
        if (fcmToken != null && fcmToken!.isNotEmpty) {
          try {
            print(
              'Calling updateFcmTokenApi after signInWithCredentialsApi success...',
            );
            print(
              'Using FCM Token from variables.dart: ${fcmToken!.substring(0, 20)}...',
            );
            await updateFcmTokenApi(fcmToken!);
            print('FCM token updated successfully after mobile login');
          } catch (e) {
            // Log error but don't fail the signInWithCredentialsApi call
            print(
              'Error updating FCM token after signInWithCredentialsApi: $e',
            );
          }
        } else {
          print('FCM token is null or empty, skipping updateFcmTokenApi call');
        }

        // Check if newRegistration is true in response
        final newRegistration =
            result['newRegistration'] ??
            result['data']?['newRegistration'] ??
            false;

        // Use post-frame callback to ensure proper widget disposal before navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 300), () {
            // If newRegistration is true, navigate to scan QR screen, otherwise home screen
            if (newRegistration == true) {
              Get.offAllNamed(AppRoutes.scanQrScreen);
            } else {
              Get.offAllNamed(AppRoutes.homeScreen);
            }
          });
        });
      } else {
        // Backend returned an error - show the backend error message directly
        final backendMessage = result['message'] ?? 
                               result['error'] ?? 
                               result['errorMessage'] ??
                               result['status'] ??
                               'Login failed. Please try again.';
        // Show backend error message directly without modification
        Validator.showErrorSnackbar(backendMessage);
      }
    } catch (e) {
      // Extract backend error message from exception
      String errorMessage = '';
      String exceptionString = e.toString();
      
      // The API service wraps backend errors as "Failed to sign in: {backend_message}"
      // Extract the actual backend message
      if (exceptionString.contains('Failed to sign in: ')) {
        errorMessage = exceptionString.split('Failed to sign in: ').last.trim();
      } else if (exceptionString.contains('Exception: ')) {
        // Try to extract message after "Exception: "
        final parts = exceptionString.split('Exception: ');
        if (parts.length > 1) {
          errorMessage = parts.last.trim();
          // Remove nested "Exception: " if present
          while (errorMessage.startsWith('Exception: ')) {
            errorMessage = errorMessage.replaceFirst('Exception: ', '').trim();
          }
        }
      }
      
      // If extracted message looks like a backend error (not technical), use it directly
      // Otherwise, use Validator utility to clean it up
      if (errorMessage.isNotEmpty && 
          !errorMessage.contains('at ') && 
          !errorMessage.contains('package:') &&
          !errorMessage.contains('dart:') &&
          errorMessage.length <= 200) {
        // This looks like a backend error message, use it directly
        Validator.showErrorSnackbar(errorMessage);
      } else {
        // Use Validator utility to extract and clean the message
        errorMessage = Validator.extractErrorMessage(e);
        if (errorMessage.isEmpty) {
          errorMessage = "Login failed. Please try again.";
        }
        Validator.showErrorSnackbar(errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
