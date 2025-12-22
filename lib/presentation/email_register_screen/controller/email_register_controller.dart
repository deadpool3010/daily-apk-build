import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/services/variables.dart';

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

  Future<void> handleRegister() async {
    final fullName = fullNameController.text.trim();
    final email = emailController.text.trim();
    final createPassword = createPasswordController.text.trim();
    final confirmPassword = confirmPasswordController.text.trim();

    if (fullName.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your full name",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (email.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter your email address",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (!GetUtils.isEmail(email)) {
      Fluttertoast.showToast(
        msg: "Please enter a valid email address",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (createPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a password",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (createPassword.length < 6) {
      Fluttertoast.showToast(
        msg: "Password must be at least 6 characters",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (confirmPassword.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please confirm your password",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    if (createPassword != confirmPassword) {
      Fluttertoast.showToast(
        msg: "Passwords do not match",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
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

      if (result['success'] == true || result['message'] != null) {
        Fluttertoast.showToast(
          msg: result['message'] ?? "Registration successful!",
          toastLength: Toast.LENGTH_SHORT,
          backgroundColor: Colors.green,
          textColor: Colors.white,
        );

        // After successful signUpApi, call updateFcmTokenApi
        // Use fcmToken from variables.dart
        if (fcmToken != null && fcmToken!.isNotEmpty) {
          try {
            print(
              'Calling updateFcmTokenApi after signUpApi success...',
            );
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
              arguments: {
                'fromRegistration': true,
                'userName': fullName,
              },
            );
          });
        });
      } else {
        throw Exception(result['message'] ?? 'Registration failed');
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
            : "Registration failed. Please try again.",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
    } finally {
      isLoading.value = false;
    }
  }
}
