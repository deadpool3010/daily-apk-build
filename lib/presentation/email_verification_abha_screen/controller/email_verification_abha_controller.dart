import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:bandhucare_new/core/constants/variables.dart';

class EmailVerificationAbhaController extends GetxController {
  // Text Controller for email
  late TextEditingController emailController;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    emailController = TextEditingController();
  }

  @override
  void onClose() {
    emailController.dispose();
    super.onClose();
  }

  // Handle email verification
  Future<void> handleVerifyEmail() async {
    final email = emailController.text.trim();

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email address",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    // Basic email validation
    if (!GetUtils.isEmail(email)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid email address",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    // Check if sessionId is available
    if (sessionId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Session ID is missing. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Call send verification link API (does NOT update sessionId, only uses it)
      final result = await sendVerificationLinkApi(
        email,
        sessionId, // Use existing sessionId from global variable
      );

      Fluttertoast.showToast(
        msg: result['message'] ?? "Verification link sent successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to create ABHA username screen
      Get.offNamed(AppRoutes.createAbhaUsernameScreen);
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
      } else if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      Fluttertoast.showToast(
        msg: errorMessage,
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }

  // Handle skip action
  void handleSkip() {
    // TODO: Navigate to next screen without email
    // Get.offNamed(AppRoutes.homeScreen);
    Fluttertoast.showToast(
      msg: "Skipped email verification",
      toastLength: Toast.LENGTH_SHORT,
      backgroundColor: Colors.blue,
      textColor: Colors.white,
    );
    Get.toNamed(AppRoutes.createAbhaUsernameScreen);
  }
}
