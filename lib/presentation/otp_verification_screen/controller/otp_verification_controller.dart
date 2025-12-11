import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:bandhucare_new/services/variables.dart';

class OtpVerificationController extends GetxController {
  // Loading state
  final isLoading = false.obs;

  // OTP value
  final enteredOtp = ''.obs;

  // Handle OTP change
  void handleOtpChange(String value) {
    enteredOtp.value = value;
  }

  // Handle OTP submission
  Future<void> handleSubmitOtp() async {
    final otp = enteredOtp.value;

    if (otp.isEmpty || otp.length != 6) {
      Fluttertoast.showToast(
        msg: "Please enter complete 6-digit OTP",
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
    enteredOtp.value = otp;

    try {
      // Call verify OTP API for updateMobile with updated sessionId
      final result = await verifyOtpForUpdateMobileApi(otp, sessionId);

      Fluttertoast.showToast(
        msg: result['message'] ?? "OTP verified successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to email verification screen after successful verification
      Get.toNamed(AppRoutes.emailVerificationAbhaScreen);
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
}
