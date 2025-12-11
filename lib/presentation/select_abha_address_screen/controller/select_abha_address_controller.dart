import 'package:get/get.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:bandhucare_new/services/variables.dart';
import 'package:bandhucare_new/services/shared_pref_localization.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter/material.dart';

class SelectAbhaAddressController extends GetxController {
  // List of ABHA accounts from API
  final abhaAccounts = <Map<String, dynamic>>[].obs;

  // Selected account index
  final selectedIndex = (-1).obs;

  // Loading state
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Get ABHA accounts from arguments or controller
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      if (arguments['abhaAccounts'] != null) {
        abhaAccounts.value = List<Map<String, dynamic>>.from(
          arguments['abhaAccounts'],
        );
        // Auto-select first account if available
        if (abhaAccounts.isNotEmpty) {
          selectedIndex.value = 0;
        }
      }
    }
  }

  // Select an ABHA address
  void selectAccount(int index) {
    selectedIndex.value = index;
  }

  // Handle next button
  Future<void> handleNext() async {
    if (selectedIndex.value == -1) {
      Fluttertoast.showToast(
        msg: "Please select an ABHA address",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    if (sessionId.isEmpty) {
      Fluttertoast.showToast(
        msg: "Session expired. Please try again.",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.red,
        textColor: Colors.white,
      );
      return;
    }

    isLoading.value = true;

    try {
      final selectedAccount = abhaAccounts[selectedIndex.value];
      final abhaNumber = selectedAccount['abhaNumber']?.toString() ?? '';

      // Call select account API
      final result = await selectAccountApi(sessionId, abhaNumber);

      print('SelectAccount API Response: $result');

      // Extract tokens from response
      if (result['data'] != null) {
        final data = result['data'] as Map<String, dynamic>;

        // Extract accessToken and refreshToken
        String? extractedAccessToken =
            data['accessToken']?.toString() ??
            data['token']?.toString() ??
            result['accessToken']?.toString();
        String? extractedRefreshToken =
            data['refreshToken']?.toString() ??
            result['refreshToken']?.toString();

        if (extractedAccessToken != null && extractedAccessToken.isNotEmpty) {
          accessToken = extractedAccessToken;
          // Save to SharedPreferences
          await SharedPrefLocalization().saveTokens(
            extractedAccessToken,
            extractedRefreshToken ?? '',
          );
        }

        if (extractedRefreshToken != null && extractedRefreshToken.isNotEmpty) {
          refreshToken = extractedRefreshToken;
        }
      }

      Fluttertoast.showToast(
        msg: result['message'] ?? "Account selected successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Extract newRegistration flag from response
      bool newRegistration = false;
      if (result['data'] != null && result['data'] is Map) {
        final data = result['data'] as Map<String, dynamic>;
        newRegistration = data['newRegistration'] as bool? ?? false;
      } else {
        newRegistration = result['newRegistration'] as bool? ?? false;
      }

      // Navigate to ABHA Created screen with newRegistration flag
      Get.toNamed(
        AppRoutes.abhaCreatedScreen,
        arguments: {
          'newRegistration': newRegistration,
          'fromRegistration': false,
        },
      );
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

  // Handle back button
  void handleBack() {
    Get.back();
  }
}
