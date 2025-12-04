import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:bandhucare_new/services/shared_pref_localization.dart';

enum LanguageSelectionTarget { app, mitra }

class LanguageSettingController extends GetxController {
  final selectedAppLanguage = 'English'.obs;
  final selectedMitraLanguage = 'English'.obs;
  final activeTarget = Rx<LanguageSelectionTarget?>(null);
  late final FixedExtentScrollController scrollControllerApp =
      FixedExtentScrollController(initialItem: currentSelectedIndexApp.value);
  late final FixedExtentScrollController scrollControllerMitra =
      FixedExtentScrollController(initialItem: currentSelectedIndexMitra.value);
  final currentSelectedIndexApp = 3.obs;
  final currentSelectedIndexMitra = 3.obs;
  final List<String> languages = [
    'Kannada',
    'Malayalam',
    'Gujarati',
    'English',
    'Hindi',
    'Telugu',
    'Tamil',
  ];
  final _prefs = SharedPrefLocalization();

  @override
  void onInit() async {
    super.onInit();
    await _loadPersistedLanguages();

    print(selectedAppLanguage.value);
    print(selectedMitraLanguage.value);
    print(languages.indexOf(selectedAppLanguage.value));
    print(languages.indexOf(selectedMitraLanguage.value));
    currentSelectedIndexApp.value = languages.indexOf(
      selectedAppLanguage.value,
    );
    currentSelectedIndexMitra.value = languages.indexOf(
      selectedMitraLanguage.value,
    );
    //syncPickerToTarget(LanguageSelectionTarget.app);
    //currentSelectedIndex.value = languages.indexOf(selectedAppLanguage.value);
    // // Set an initial target (example: app language)
    // // Calculate initial index based on saved language
    // final initialIndex = languages.indexOf(selectedAppLanguage.value);
    // currentSelectedIndex.value = initialIndex >= 0 ? initialIndex : 3;

    // scrollController = FixedExtentScrollController(
    //   initialItem: currentSelectedIndex.value,
    // );

    // // IMPORTANT: sync after controller is created
    // Future.delayed(Duration(milliseconds: 50), () {
    //   syncPickerToTarget(LanguageSelectionTarget.app);
    // });
  }

  @override
  void onClose() {
    scrollControllerApp.dispose();
    scrollControllerMitra.dispose();
    super.onClose();
  }

  void toggleTarget(LanguageSelectionTarget target) {
    if (activeTarget.value == target) {
      activeTarget.value = null;
      return;
    }
    activeTarget.value = target;
    _syncPickerToSelectedLanguage(target);
  }

  void handleWheelChange(int index) {
    if (activeTarget.value == LanguageSelectionTarget.app) {
      _updateAppSelection(index);
    } else if (activeTarget.value == LanguageSelectionTarget.mitra) {
      _updateMitraSelection(index);
    }
  }

  void _updateAppSelection(int index) {
    currentSelectedIndexApp.value = index;
    selectedAppLanguage.value = languages[index];
  }

  void _updateMitraSelection(int index) {
    currentSelectedIndexMitra.value = index;
    selectedMitraLanguage.value = languages[index];
  }

  void _syncPickerToSelectedLanguage(LanguageSelectionTarget target) {
    final selectedLanguage = target == LanguageSelectionTarget.app
        ? selectedAppLanguage.value
        : selectedMitraLanguage.value;
    final controller = target == LanguageSelectionTarget.app
        ? scrollControllerApp
        : scrollControllerMitra;
    final index = languages
        .indexOf(selectedLanguage)
        .clamp(0, languages.length - 1);

    if (target == LanguageSelectionTarget.app) {
      currentSelectedIndexApp.value = index;
    } else {
      currentSelectedIndexMitra.value = index;
    }

    controller.animateToItem(
      index,
      duration: const Duration(milliseconds: 250),
      curve: Curves.easeInOut,
    );
  }

  Future<void> saveLanguages() async {
    await _prefs.appLanguage(selectedAppLanguage.value);
    await _prefs.mitraLanguage(selectedMitraLanguage.value);
  }

  Future<void> _loadPersistedLanguages() async {
    final appLang = await _prefs.getAppLanguage();
    final mitraLang = await _prefs.getMitraLanguage();
    if (languages.contains(appLang)) {
      selectedAppLanguage.value = appLang;
    }
    if (languages.contains(mitraLang)) {
      selectedMitraLanguage.value = mitraLang;
    }
  }
}
