import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bandhucare_new/routes/app_routes.dart';

class AbhaCreatedController extends GetxController {
  // ABHA User Data (These would typically come from API response)
  final userName = 'Siddharth'.obs;
  final abhaNumber = '91 1234 5678 9101'.obs;
  final abhaAddress = 'Sid2000@abdm'.obs;
  final gender = 'Male'.obs;
  final dob = '03032004'.obs;
  final mobile = '1234567891'.obs;
  final profileImageUrl = ''.obs; // URL for profile image if available
  final showAbhaCard = true.obs; // Flag to show/hide ABHA card

  @override
  void onInit() {
    super.onInit();
    // Check if screen was opened from mobile/email registration
    final arguments = Get.arguments;
    if (arguments != null && arguments is Map<String, dynamic>) {
      final fromRegistration = arguments['fromRegistration'] as bool? ?? false;
      showAbhaCard.value = !fromRegistration;

      // Load user name from arguments if available (from email/mobile registration)
      final userNameFromArgs = arguments['userName'] as String?;
      if (userNameFromArgs != null && userNameFromArgs.isNotEmpty) {
        userName.value = _extractFirstName(userNameFromArgs.trim());
      }

      // Load ABHA details from arguments if available
      final abhaDetails = arguments['abhaDetails'] as Map<String, dynamic>?;
      if (abhaDetails != null) {
        _loadAbhaDetails(abhaDetails);
      }

      // Check newRegistration flag and navigate accordingly
      // Only auto-navigate if newRegistration is explicitly true
      // When false or coming from select_abha_address, user stays on screen
      if (arguments.containsKey('newRegistration')) {
        final newRegistration = arguments['newRegistration'] as bool? ?? false;
        if (newRegistration) {
          // If newRegistration is true, navigate to scan QR screen after 2 seconds
          WidgetsBinding.instance.addPostFrameCallback((_) {
            Future.delayed(Duration(milliseconds: 2000), () {
              // Show screen for 2 seconds before navigating
              Get.offAllNamed(AppRoutes.scanQrScreen);
            });
          });
        }
        // If newRegistration is false, don't auto-navigate
        // User can manually click "Scan to Join Group" button
      }
    }
  }

  // Load ABHA details from API response
  void _loadAbhaDetails(Map<String, dynamic> abhaDetails) {
    try {
      // Extract and format name
      final name = abhaDetails['name']?.toString().trim();
      if (name != null && name.isNotEmpty) {
        userName.value = _extractFirstName(name);
      }

      // Extract and format ABHA number (add spaces for readability if needed)
      final abhaNum = abhaDetails['abhaNumber']?.toString().trim();
      if (abhaNum != null && abhaNum.isNotEmpty) {
        // Format: 91 1234 5678 9101 (add spaces every 4 digits after first 2)
        abhaNumber.value = abhaNum;
      }

      // Extract ABHA address
      final abhaAddr = abhaDetails['abhaAddress']?.toString().trim();
      if (abhaAddr != null && abhaAddr.isNotEmpty) {
        abhaAddress.value = abhaAddr;
      }

      // Extract and format gender (M -> Male, F -> Female, etc.)
      final genderValue = abhaDetails['gender']
          ?.toString()
          .trim()
          .toUpperCase();
      if (genderValue != null && genderValue.isNotEmpty) {
        switch (genderValue) {
          case 'M':
            gender.value = 'Male';
            break;
          case 'F':
            gender.value = 'Female';
            break;
          case 'O':
            gender.value = 'Other';
            break;
          default:
            gender.value = genderValue;
        }
      }

      // Extract and format DOB
      // First check if dob is already formatted (DDMMYYYY)
      final dobValue = abhaDetails['dob']?.toString().trim();
      if (dobValue != null && dobValue.isNotEmpty) {
        dob.value = dobValue;
      } else {
        // If not formatted, try to build from dayOfBirth, monthOfBirth, yearOfBirth
        final dayOfBirth = abhaDetails['dayOfBirth']?.toString().trim() ?? '';
        final monthOfBirth =
            abhaDetails['monthOfBirth']?.toString().trim() ?? '';
        final yearOfBirth = abhaDetails['yearOfBirth']?.toString().trim() ?? '';

        if (dayOfBirth.isNotEmpty &&
            monthOfBirth.isNotEmpty &&
            yearOfBirth.isNotEmpty) {
          // Format as DDMMYYYY
          final day = dayOfBirth.padLeft(2, '0');
          final month = monthOfBirth.padLeft(2, '0');
          dob.value = '$day$month$yearOfBirth';
        }
      }

      // Extract mobile number
      final mobileValue = abhaDetails['mobileNumber']?.toString().trim();
      if (mobileValue != null && mobileValue.isNotEmpty) {
        mobile.value = mobileValue;
      }

      // Extract profile photo URL
      final profilePhoto = abhaDetails['profilePhoto']?.toString().trim();
      if (profilePhoto != null && profilePhoto.isNotEmpty) {
        profileImageUrl.value = profilePhoto;
      }

      print('ABHA Details loaded successfully:');
      print('Name: ${userName.value}');
      print('ABHA Number: ${abhaNumber.value}');
      print('ABHA Address: ${abhaAddress.value}');
      print('Gender: ${gender.value}');
      print('DOB: ${dob.value}');
      print('Mobile: ${mobile.value}');
      print('Profile Photo: ${profileImageUrl.value}');
    } catch (e) {
      print('Error loading ABHA details: $e');
    }
  }

  // Extract first name from full name (text before first space)
  String _extractFirstName(String fullName) {
    if (fullName.isEmpty) return fullName;
    final trimmedName = fullName.trim();
    final firstSpaceIndex = trimmedName.indexOf(' ');
    if (firstSpaceIndex == -1) {
      // No space found, return the whole name
      return trimmedName;
    }
    // Return text before first space
    return trimmedName.substring(0, firstSpaceIndex);
  }

  // Handle Scan to Join Group button
  void handleScanToJoinGroup() {
    Get.toNamed(AppRoutes.scanQrScreen);
  }

  // Handle Contact Us button
  void handleContactUs() {
    // TODO: Implement contact us functionality
    // Could open email, phone dialer, or contact screen
  }
}
