import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';

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
      // TODO: Implement mobile/password login API call
      // Example:
      // final result = await mobilePasswordLoginApi(mobile, password);

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      Fluttertoast.showToast(
        msg: "Login successful!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to home screen after successful login
      // Get.offAllNamed(AppRoutes.homeScreen);
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
