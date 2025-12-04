import 'package:bandhucare_new/routes/routes.dart';
import 'package:bandhucare_new/screens/userProfile/bottomsheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';

class UserProfileController extends GetxController {
  final RxBool showPersonalInfo = false.obs;
  final RxString selectedLanguage = 'English'.obs;
  final RxString selectedAppLanguage = 'English'.obs;
  final RxString selectedMitraLanguage = 'English'.obs;

  final List<String> languages = const [
    'Kannada',
    'Malayalam',
    'Gujarati',
    'English',
    'Hindi',
    'Telugu',
    'Tamil',
  ];

  void togglePersonalInfo() {
    // showPersonalInfo.toggle();
  }

  void updateLanguage(int index) {
    if (index >= 0 && index < languages.length) {
      selectedLanguage.value = languages[index];
    }
  }

  void setAppLanguage(String language) {
    if (languages.contains(language)) {
      selectedAppLanguage.value = language;
    }
  }

  void setMitraLanguage(String language) {
    if (languages.contains(language)) {
      selectedMitraLanguage.value = language;
    }
  }

  Future<void> navigateToLanguageSettings() async {
    Get.toNamed(AppRoutes.languageSettingsScreen);
  }

  // Future<void> navigateToPrivacySecurity() async {
  //   Get.toNamed(AppRoutes.privacySecurityScreen);
  // }

  //   Future<void> openProfileActions(BuildContext context) async {
  //     await AppBottomSheet.show(
  //       context: context,
  //       height: 240,
  //       child: ProfileActionSheet(
  //         onEditProfile: () {
  //           Get.back();
  //           // placeholder for edit navigation
  //         },
  //         onLogout: () {
  //           Get.back();
  //           // placeholder for logout
  //         },
  //       ),
  //     );
  //   }
}
