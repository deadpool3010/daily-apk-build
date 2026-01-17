import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/core/constants/variables.dart';

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

  Future<void> handleLogin() async {
    final mobile = mobileController.text.trim();
    final password = passwordController.text.trim();

    if (mobile.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your mobile number",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (mobile.length != 10) {
      Fluttertoast.showToast(
        msg: "Please enter a valid 10-digit mobile number",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (password.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your password",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (password.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      // Call sign-in API with mobile number and password
      final result = await signInWithCredentialsApi(
        emailNumber: mobile,
        password: password,
      );

      if (result['success'] == true || result['message'] != null) {
        Fluttertoast.showToast(
          msg: result['message'] ?? "Login successful!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
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
        throw Exception(result['message'] ?? 'Login failed');
      }
    } catch (e) {
      String errorMessage = e.toString();
      if (errorMessage.startsWith('Exception: Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: Exception: ', '');
      } else if (errorMessage.startsWith('Exception: ')) {
        errorMessage = errorMessage.replaceFirst('Exception: ', '');
      }

      Fluttertoast.showToast(
        msg: errorMessage.isNotEmpty
            ? errorMessage
            : "Login failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
