import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:bandhucare_new/core/utils/validator.dart';

class EmailRegisterController extends GetxController {
  late TextEditingController fullNameController;
  late TextEditingController emailController;
  late TextEditingController createPasswordController;
  late TextEditingController confirmPasswordController;

  final isCreatePasswordVisible = false.obs;
  final isConfirmPasswordVisible = false.obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fullNameController = TextEditingController();
    emailController = TextEditingController();
    createPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void onClose() {
    fullNameController.dispose();
    emailController.dispose();
    createPasswordController.dispose();
    confirmPasswordController.dispose();
    super.onClose();
  }

  void toggleCreatePasswordVisibility() {
    isCreatePasswordVisible.value = !isCreatePasswordVisible.value;
  }

  void toggleConfirmPasswordVisibility() {
    isConfirmPasswordVisible.value = !isConfirmPasswordVisible.value;
  }

  // Validate full name
  bool validateFullName(String fullName) {
    if (fullName.isEmpty) {
      Validator.showErrorSnackbar('Please enter your full name');
      return false;
    }
    if (fullName.length < 2) {
      Validator.showErrorSnackbar('Full name must be at least 2 characters');
      return false;
    }
    return true;
  }

  // Validate email using Validator utility
  bool validateEmail(String email) {
    return Validator.validateEmail(email);
  }

  // Validate password using Validator utility
  bool validatePassword(String password) {
    return Validator.validatePassword(password);
  }

  // Validate confirm password
  bool validateConfirmPassword(String password, String confirmPassword) {
    if (confirmPassword.isEmpty) {
      Validator.showErrorSnackbar('Please confirm your password');
      return false;
    }
    if (password != confirmPassword) {
      Validator.showErrorSnackbar('Passwords do not match');
      return false;
    }
    return true;
  }

  Future<void> handleRegister() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final createPassword = createPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    // Validate full name
    if (!validateFullName(fullName)) {
      return;
    }

    // Validate email - this will show snackbar if invalid
    if (email.isEmpty) {
      Validator.showErrorSnackbar('Please enter your email address');
      return;
    }

    if (!validateEmail(email)) {
      return;
    }

    // Validate password - this will show snackbar if invalid
    if (createPassword.isEmpty) {
      Validator.showErrorSnackbar('Please enter a password');
      return;
    }

    if (!validatePassword(createPassword)) {
      return;
    }

    // Validate confirm password
    if (!validateConfirmPassword(createPassword, confirmPassword)) {
      return;
    }

    isLoading.value = true;

    try {
      // Call sign-up API with email
      final result = await signUpApi(
        name: fullName,
        emailNumber: email,
        password: createPassword,
        userType: "patient",
      );

      // Check if registration was successful
      // Backend may return success: false even with 200 status code
      if (result['success'] == true) {
        Validator.showSuccessSnackbar(
          result['message'] ?? "Registration successful!",
        );

        // After successful signUpApi, call updateFcmTokenApi
        // Use fcmToken from variables.dart
        if (fcmToken != null && fcmToken!.isNotEmpty) {
          try {
            print('Calling updateFcmTokenApi after signUpApi success...');
            print(
              'Using FCM Token from variables.dart: ${fcmToken!.substring(0, 20)}...',
            );
            await updateFcmTokenApi(fcmToken!);
            print('FCM token updated successfully after email registration');
          } catch (e) {
            // Log error but don't fail the signUpApi call
            print('Error updating FCM token after signUpApi: $e');
          }
        } else {
          print('FCM token is null or empty, skipping updateFcmTokenApi call');
        }

        // Use post-frame callback to ensure proper widget disposal before navigation
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Future.delayed(Duration(milliseconds: 300), () {
            Get.offAllNamed(
              AppRoutes.abhaCreatedScreen,
              arguments: {'fromRegistration': true, 'userName': fullName},
            );
          });
        });
      } else {
        // Backend returned an error - show the backend error message directly
        final backendMessage = result['message'] ?? 
                               result['error'] ?? 
                               result['errorMessage'] ??
                               result['status'] ??
                               'Registration failed. Please try again.';
        // Show backend error message directly without modification
        Validator.showErrorSnackbar(backendMessage);
      }
    } catch (e) {
      // Extract backend error message from exception
      String errorMessage = '';
      String exceptionString = e.toString();
      
      // The API service wraps backend errors as "Failed to sign up: {backend_message}"
      // Extract the actual backend message
      if (exceptionString.contains('Failed to sign up: ')) {
        errorMessage = exceptionString.split('Failed to sign up: ').last.trim();
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
          errorMessage = "Registration failed. Please try again.";
        }
        Validator.showErrorSnackbar(errorMessage);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
