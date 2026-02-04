import 'package:bandhucare_new/core/services/shared_pref_localization.dart';
import 'package:bandhucare_new/model/patientModel.dart';
import 'package:get/get.dart';

class SessionController extends GetxController {
  PatientModel? user;
  bool isLoggedIn = false;

  void loadFromCache(Map<String, dynamic> cachedUser) {
    // Extract profile from profileDetails or profile key, otherwise use cachedUser directly
    Map<String, dynamic> userData = cachedUser;
    if (cachedUser.containsKey('profileDetails') &&
        cachedUser['profileDetails'] is Map<String, dynamic>) {
      userData = cachedUser['profileDetails'] as Map<String, dynamic>;
    } else if (cachedUser.containsKey('profile') &&
        cachedUser['profile'] is Map<String, dynamic>) {
      userData = cachedUser['profile'] as Map<String, dynamic>;
    }
    user = PatientModel.fromJson(userData);
    isLoggedIn = true;
    update();
  }

  void setUser(PatientModel newUser) {
    user = newUser;
    isLoggedIn = true;
    update();
  }

  /// Updates user from API profile response and persists to SharedPreferences.
  /// Call this after update profile API succeeds.
  Future<void> updateUserFromProfile(Map<String, dynamic> profile) async {
    user = PatientModel.fromJson(profile);
    isLoggedIn = true;
    update();
    await SharedPrefLocalization().saveUserInfo(profile);
  }

  void clearSession() {
    user = null;
    isLoggedIn = false;
    update();
  }
}
