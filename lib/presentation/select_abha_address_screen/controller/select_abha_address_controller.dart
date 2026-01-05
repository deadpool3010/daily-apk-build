import 'package:get/get.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:bandhucare_new/core/services/shared_pref_localization.dart';
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
      print("helfloo");
      final result = await selectAccountApi(sessionId, abhaNumber);

      print('SelectAccount API Response: $result');

      // Extract tokens from response
      String extractedAccessToken = '';

      if (result['data'] != null && result['data'] is Map) {
        final data = result['data'] as Map<String, dynamic>;

        // Extract accessToken and refreshToken
        extractedAccessToken =
            data['accessToken']?.toString() ??
            data['token']?.toString() ??
            result['accessToken']?.toString() ??
            '';
        String? extractedRefreshToken =
            data['refreshToken']?.toString() ??
            result['refreshToken']?.toString();

        // Store accessToken in global variable and SharedPreferences
        if (extractedAccessToken.isNotEmpty) {
          accessToken = extractedAccessToken;
          print(
            'AccessToken extracted and stored: ${accessToken.substring(0, 20)}...',
          );

          // Save to SharedPreferences
          try {
            await SharedPrefLocalization().saveTokens(
              extractedAccessToken,
              extractedRefreshToken ?? '',
            );
            print('AccessToken saved to SharedPreferences');
          } catch (e) {
            print('Error saving accessToken to SharedPreferences: $e');
          }
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

      // After successful selectAccountApi, call updateFcmTokenApi
      // Use fcmToken from variables.dart
      if (fcmToken != null && fcmToken!.isNotEmpty) {
        try {
          print('Calling updateFcmTokenApi after selectAccountApi success...');
          print(
            'Using FCM Token from variables.dart: ${fcmToken!.substring(0, 20)}...',
          );
          await updateFcmTokenApi(fcmToken!);
          print('FCM token updated successfully after account selection');
        } catch (e) {
          // Log error but don't fail the selectAccountApi call
          print('Error updating FCM token after selectAccountApi: $e');
        }
      } else {
        print('FCM token is null or empty, skipping updateFcmTokenApi call');
      }

      // Profile details are extracted and stored in abhaData if needed for future use
      // Currently not used as we navigate directly to scanQrScreen or homeScreen

      // Extract newRegistration flag from response
      final newRegistration =
          result['newRegistration'] ??
          result['data']?['newRegistration'] ??
          false;

      print('========================================');
      print('New Registration: $newRegistration');
      print('Full Response: $result');
      print('========================================');

      // Set loading to false before navigation
      isLoading.value = false;

      // Navigate after a short delay to ensure UI updates complete
      await Future.delayed(Duration(milliseconds: 300));
      Map<String, dynamic>? abhaData;
      // If newRegistration is true, navigate to scan QR screen, otherwise home screen
      if (result['data'] != null && result['data'] is Map) {
        final data = result['data'] as Map<String, dynamic>;

        // Extract accessToken from data
        extractedAccessToken =
            data['accessToken']?.toString() ?? data['token']?.toString() ?? '';

        if (data['profileDetails'] != null && data['profileDetails'] is Map) {
          abhaData = data['profileDetails'] as Map<String, dynamic>;
          print('Found ABHA data in result[\'data\'][\'profileDetails\']');
        } else {
          // Fallback: check if data itself contains the profile info
          abhaData = data;
          print('Found ABHA data in result[\'data\']');
        }
      }
      String formattedDob = '';
      if (abhaData != null) {
        final dayOfBirth = abhaData['dayOfBirth']?.toString().trim() ?? '';
        final monthOfBirth = abhaData['monthOfBirth']?.toString().trim() ?? '';
        final yearOfBirth = abhaData['yearOfBirth']?.toString().trim() ?? '';

        print(
          'Date components - Day: $dayOfBirth, Month: $monthOfBirth, Year: $yearOfBirth',
        );

        // Only format if we have all three values
        if (dayOfBirth.isNotEmpty &&
            monthOfBirth.isNotEmpty &&
            yearOfBirth.isNotEmpty) {
          // Pad with zeros if needed (ensure 2 digits for day and month)
          final day = dayOfBirth.padLeft(2, '0');
          final month = monthOfBirth.padLeft(2, '0');
          formattedDob = '$day$month$yearOfBirth';
          print('Formatted DOB: $formattedDob');
        }
      }
      final abhaDetails = {
        'userId': abhaData?['userId']?.toString() ?? '',
        'abhaNumber': abhaData?['abhaNumber']?.toString() ?? '',
        'abhaAddress': abhaData?['abhaAddress']?.toString() ?? '',
        'mobileNumber': abhaData?['mobileNumber']?.toString() ?? '',
        'email': abhaData?['email']?.toString() ?? '',
        'name': abhaData?['name']?.toString() ?? '',
        'profilePhoto': abhaData?['profilePhoto']?.toString() ?? '',
        'gender': abhaData?['gender']?.toString() ?? '',
        'yearOfBirth': abhaData?['yearOfBirth']?.toString() ?? '',
        'dayOfBirth': abhaData?['dayOfBirth']?.toString() ?? '',
        'monthOfBirth': abhaData?['monthOfBirth']?.toString() ?? '',
        'stateName': abhaData?['stateName']?.toString() ?? '',
        'districtName': abhaData?['districtName']?.toString() ?? '',
        'subdistrictName': abhaData?['subdistrictName']?.toString() ?? '',
        'villageName': abhaData?['villageName']?.toString() ?? '',
        'townName': abhaData?['townName']?.toString() ?? '',
        'wardName': abhaData?['wardName']?.toString() ?? '',
        'address': abhaData?['address']?.toString() ?? '',
        'pincode': abhaData?['pincode']?.toString() ?? '',
        'dob': formattedDob, // Formatted as DDMMYYYY
      };

      if (newRegistration == true) {
        print('Navigating to abha created screen...');
        Get.offAllNamed(
          AppRoutes.abhaCreatedScreen,
          arguments: {
            'abhaDetails': abhaDetails,
            'accessToken': extractedAccessToken,
            'fromRegistration':
                false, // This is from ABHA creation, not registration
          },
        );
      } else {
        print('Navigating to home screen...');
        Get.offAllNamed(AppRoutes.homeScreen);
      }
    } catch (e) {
      isLoading.value = false;
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
    }
  }

  // Handle back button
  void handleBack() {
    Get.back();
  }
}
