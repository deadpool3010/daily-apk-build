import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:bandhucare_new/core/api/api_services.dart';
import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:bandhucare_new/core/services/shared_pref_localization.dart';

class CreateAbhaUsernameController extends GetxController {
  // Text Controller for username
  late TextEditingController usernameController;

  // Loading state
  final isLoading = false.obs;

  // Username validation state
  final isUsernameValid = false.obs;

  // Suggestions list
  final suggestions = <String>[].obs;

  @override
  void onInit() {
    super.onInit();
    usernameController = TextEditingController();

    // Listen to username changes for validation
    usernameController.addListener(() {
      _validateUsername();
    });

    // Fetch suggestions from API when screen loads
    _fetchSuggestionsFromApi();
  }

  @override
  void onClose() {
    usernameController.dispose();
    super.onClose();
  }

  // Validate username
  void _validateUsername() {
    final username = usernameController.text.trim();

    // ABHA username rules:
    // - Minimum 8 characters
    // - Maximum 18 characters
    // - Allows one dot (.) and/or one underscore (_) as special characters
    if (username.length >= 8 && username.length <= 18) {
      // Check for valid characters (alphanumeric, one dot, one underscore)
      final dotCount = username.split('.').length - 1;
      final underscoreCount = username.split('_').length - 1;
      final hasValidChars = RegExp(r'^[a-zA-Z0-9._]+$').hasMatch(username);

      if (hasValidChars && dotCount <= 1 && underscoreCount <= 1) {
        isUsernameValid.value = true;
        return;
      }
    }
    isUsernameValid.value = false;
  }

  // Fetch suggestions from API
  Future<void> _fetchSuggestionsFromApi() async {
    if (sessionId.isEmpty) {
      print('SessionId is empty, cannot fetch suggestions');
      return;
    }

    try {
      final result = await getAbhaAddressSuggestionsApi(sessionId);

      // Extract suggestions from API response
      // The response structure may vary, so we'll handle different possible formats
      if (result['data'] != null) {
        if (result['data'] is List) {
          suggestions.value = (result['data'] as List)
              .map((item) => item.toString())
              .toList();
        } else if (result['data'] is Map) {
          final dataMap = result['data'] as Map<String, dynamic>;
          if (dataMap['suggestions'] != null &&
              dataMap['suggestions'] is List) {
            suggestions.value = (dataMap['suggestions'] as List)
                .map((item) => item.toString())
                .toList();
          } else if (dataMap['abhaAddresses'] != null &&
              dataMap['abhaAddresses'] is List) {
            suggestions.value = (dataMap['abhaAddresses'] as List)
                .map((item) => item.toString())
                .toList();
          }
        }
      } else if (result['suggestions'] != null &&
          result['suggestions'] is List) {
        suggestions.value = (result['suggestions'] as List)
            .map((item) => item.toString())
            .toList();
      } else if (result['abhaAddresses'] != null &&
          result['abhaAddresses'] is List) {
        suggestions.value = (result['abhaAddresses'] as List)
            .map((item) => item.toString())
            .toList();
      }

      // If no suggestions found, generate fallback suggestions
      if (suggestions.isEmpty) {
        _generateFallbackSuggestions();
      }
    } catch (e) {
      print('Error fetching suggestions from API: $e');
      // On error, use fallback suggestions
      _generateFallbackSuggestions();
    }
  }

  // Generate fallback suggestions based on current input
  void _generateFallbackSuggestions() {
    final currentText = usernameController.text.trim();
    final baseName = currentText.isEmpty
        ? 'Siddharth'
        : currentText.replaceAll(RegExp(r'[._]'), '');

    // Only show suggestions if base name is not empty
    if (baseName.isNotEmpty) {
      suggestions.value = [
        '${baseName}273890',
        '${baseName}19823',
        '${baseName}456789',
      ];
    } else {
      suggestions.value = [];
    }
  }

  // Select a suggestion
  void selectSuggestion(String suggestion) {
    usernameController.text = suggestion;
    _validateUsername();
  }

  // Handle username submission
  Future<void> handleSubmitUsername() async {
    final username = usernameController.text.trim();

    if (username.isEmpty) {
      Fluttertoast.showToast(
        msg: "Please enter a username",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.orange,
        textColor: Colors.white,
      );
      return;
    }

    if (!isUsernameValid.value) {
      Fluttertoast.showToast(
        msg:
            "Username must be 8-18 characters and can contain one dot (.) and/or one underscore (_)",
        toastLength: Toast.LENGTH_LONG,
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
      // Call create ABHA address API
      final result = await createAbhaAddressApi(
        username, // abhaAddress
        sessionId, // sessionId from global variable
      );

      Fluttertoast.showToast(
        msg: result['message'] ?? "ABHA address created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Extract ABHA details from API response
      // The response structure: result['data']['profileDetails']
      Map<String, dynamic>? abhaData;
      String extractedAccessToken = '';

      print('Extracting ABHA details from API response...');
      print('Response keys: ${result.keys.toList()}');

      // First, try to get profileDetails from result['data']['profileDetails']
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
      // If not found, check if the result itself contains the ABHA data
      else if (result.containsKey('abhaNumber') ||
          result.containsKey('abhaAddress')) {
        abhaData = result;
        // Also check for accessToken at root level
        if (extractedAccessToken.isEmpty) {
          extractedAccessToken =
              result['accessToken']?.toString() ??
              result['token']?.toString() ??
              '';
        }
        print('Found ABHA data at root level');
      }
      // If still not found, try result['abhaData'] or similar
      else if (result['abhaData'] != null && result['abhaData'] is Map) {
        abhaData = result['abhaData'] as Map<String, dynamic>;
        // Also check for accessToken at root level
        if (extractedAccessToken.isEmpty) {
          extractedAccessToken =
              result['accessToken']?.toString() ??
              result['token']?.toString() ??
              '';
        }
        print('Found ABHA data in result[\'abhaData\']');
      } else {
        // Final fallback: check for accessToken at root level
        if (extractedAccessToken.isEmpty) {
          extractedAccessToken =
              result['accessToken']?.toString() ??
              result['token']?.toString() ??
              '';
        }
        print('Warning: Could not find ABHA data in expected locations');
      }

      // Store accessToken in global variable and SharedPreferences
      if (extractedAccessToken.isNotEmpty) {
        accessToken = extractedAccessToken;
        print(
          'AccessToken extracted and stored: ${accessToken.substring(0, 20)}...',
        );

        // Save to SharedPreferences
        try {
          await SharedPrefLocalization().saveTokens(accessToken, refreshToken);
          print('AccessToken saved to SharedPreferences');
        } catch (e) {
          print('Error saving accessToken to SharedPreferences: $e');
        }
      }

      // After successful createAbhaAddressApi, call updateFcmTokenApi
      // Use fcmToken from variables.dart
      if (fcmToken != null && fcmToken!.isNotEmpty) {
        try {
          print(
            'Calling updateFcmTokenApi after createAbhaAddressApi success...',
          );
          print(
            'Using FCM Token from variables.dart: ${fcmToken!.substring(0, 20)}...',
          );
          await updateFcmTokenApi(fcmToken!);
          print('FCM token updated successfully after ABHA address creation');
        } catch (e) {
          // Log error but don't fail the createAbhaAddressApi call
          print('Error updating FCM token after createAbhaAddressApi: $e');
        }
      } else {
        print('FCM token is null or empty, skipping updateFcmTokenApi call');
      }

      // Format date of birth (DDMMYYYY)
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

      // Prepare ABHA details to pass to next screen
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

      // Navigate to ABHA Created screen with ABHA details and accessToken
      Get.toNamed(
        AppRoutes.abhaCreatedScreen,
        arguments: {
          'abhaDetails': abhaDetails,
          'accessToken': extractedAccessToken,
          'fromRegistration':
              false, // This is from ABHA creation, not registration
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
}
