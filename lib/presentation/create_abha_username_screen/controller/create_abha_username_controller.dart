import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:bandhucare_new/routes/app_routes.dart';

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

    // Listen to username changes for validation and suggestions
    usernameController.addListener(() {
      _validateUsername();
      _generateSuggestions();
    });

    // Generate initial suggestions
    _generateSuggestions();
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

  // Generate suggestions based on current input
  void _generateSuggestions() {
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

    isLoading.value = true;

    try {
      // TODO: Implement API call for username creation
      // final result = await createAbhaUsernameApi(username);

      // Simulate API call
      await Future.delayed(Duration(seconds: 2));

      Fluttertoast.showToast(
        msg: "ABHA address created successfully!",
        toastLength: Toast.LENGTH_SHORT,
        backgroundColor: Colors.green,
        textColor: Colors.white,
      );

      // Navigate to ABHA Created screen
      Get.toNamed(AppRoutes.abhaCreatedScreen);
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
