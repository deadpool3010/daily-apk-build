import 'package:bandhucare_new/core/app_exports.dart';
import 'package:flutter/material.dart';

class ChooseLanguageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Animation Controller
  late AnimationController dropdownAnimationController;
  late Animation<double> dropdownAnimation;

  // Reactive variables using .obs
  final selectedLanguage = 'English'.obs;
  final isDropdownExpanded = false.obs;

  // Languages list
  final List<String> languages = [
    'English',
    'Telugu',
    'Gujarati',
    'Tamil',
    'Hindi',
    'Malayalam',
  ];

  @override
  void onInit() {
    super.onInit();
    dropdownAnimationController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    dropdownAnimation = CurvedAnimation(
      parent: dropdownAnimationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void onClose() {
    dropdownAnimationController.dispose();
    super.onClose();
  }

  // Toggle dropdown state
  void toggleDropdown() {
    isDropdownExpanded.value = !isDropdownExpanded.value;
    if (isDropdownExpanded.value) {
      dropdownAnimationController.forward();
    } else {
      dropdownAnimationController.reverse();
    }
  }

  // Select a language
  void selectLanguage(String language) {
    selectedLanguage.value = language;
    isDropdownExpanded.value = false;
    dropdownAnimationController.reverse();
  }

  // Navigate to login screen
  void proceedToLogin() {
    Get.offNamed(AppRoutes.loginScreen);
  }
}
