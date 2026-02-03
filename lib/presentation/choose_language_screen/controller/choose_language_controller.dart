import 'package:bandhucare_new/core/export_file/app_exports.dart';
import 'package:flutter/material.dart';
import 'package:bandhucare_new/core/services/shared_pref_localization.dart';
import 'package:bandhucare_new/core/utils/validator.dart';

class ChooseLanguageController extends GetxController
    with GetSingleTickerProviderStateMixin {
  // Animation Controller
  late AnimationController dropdownAnimationController;
  late Animation<double> dropdownAnimation;

  final _prefs = SharedPrefLocalization();

  // Reactive variables using .obs
  final selectedLanguageKey = 'lbl_english'.obs;
  final isDropdownExpanded = false.obs;

  // Languages list - storing keys instead of translated values
  final List<String> languageKeys = [
    'lbl_english',
    'lbl_telugu',
    'lbl_gujarati',
    'lbl_tamil',
    'lbl_hindi',
    'lbl_malayalam',
  ];

  // Mapping language keys to locale codes
  final Map<String, Locale> _languageKeyToLocale = {
    'lbl_english': Locale('en', 'US'),
    'lbl_hindi': Locale('hi', 'IN'),
    'lbl_tamil': Locale('ta', 'IN'),
    'lbl_telugu': Locale('te', 'IN'),
    'lbl_gujarati': Locale('gu', 'IN'),
    'lbl_malayalam': Locale('ml', 'IN'),
  };

  // Mapping language keys to locale code strings for storage
  final Map<String, String> _languageKeyToLocaleString = {
    'lbl_english': 'en_US',
    'lbl_hindi': 'hi_IN',
    'lbl_tamil': 'ta_IN',
    'lbl_telugu': 'te_IN',
    'lbl_gujarati': 'gu_IN',
    'lbl_malayalam': 'ml_IN',
  };

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
    _loadSavedLanguage();
  }

  // Load saved language preference
  Future<void> _loadSavedLanguage() async {
    final savedLocale = await _prefs.getAppLocale();
    // Find the language key from locale string
    final languageKey = _languageKeyToLocaleString.entries
        .firstWhere(
          (entry) => entry.value == savedLocale,
          orElse: () => MapEntry('lbl_english', 'en_US'),
        )
        .key;
    selectedLanguageKey.value = languageKey;
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
  Future<void> selectLanguage(String languageKey) async {
    // Get the translated language name for snackbar
    final languageName = languageKey.tr;
    
    selectedLanguageKey.value = languageKey;
    isDropdownExpanded.value = false;
    dropdownAnimationController.reverse();

    // Save the selected language
    final localeString = _languageKeyToLocaleString[languageKey] ?? 'en_US';
    await _prefs.saveAppLocale(localeString);

    // Update GetX locale after a microtask to avoid build phase issues
    final locale = _languageKeyToLocale[languageKey] ?? Locale('en', 'US');
    Future.microtask(() {
      Get.updateLocale(locale);
      // Show snackbar after locale is updated to display in selected language
      Validator.showSuccessSnackbar(
        'Language changed to $languageName',
        duration: Duration(seconds: 2),
      );
    });
  }

  // Navigate to login screen
  // In ChooseLanguageController
  Future<void> proceedToLogin() async {
    // Get the selected language name for snackbar
    final languageName = selectedLanguageKey.value.tr;
    
    // Save locale
    final localeString =
        _languageKeyToLocaleString[selectedLanguageKey.value] ?? 'en_US';
    await _prefs.saveAppLocale(localeString);

    final locale =
        _languageKeyToLocale[selectedLanguageKey.value] ??
        const Locale('en', 'US');
    Get.updateLocale(locale);

    // Show snackbar with selected language
    Validator.showSuccessSnackbar(
      'Proceeding with $languageName',
      duration: Duration(seconds: 2),
    );

    // Navigate with custom transition after a short delay to show snackbar
    Future.delayed(Duration(milliseconds: 500), () {
      Get.toNamed(AppRoutes.loginScreen);
    });
  }
}
