import 'package:bandhucare_new/model/patientModel.dart';
import 'package:get/get.dart';

class SessionController extends GetxController {
  PatientModel? user;
  bool isLoggedIn = false;

  void loadFromCache(Map<String, dynamic> cachedUser) {
    // Extract profileDetails if it exists, otherwise use the cachedUser directly
    Map<String, dynamic> userData = cachedUser;
    if (cachedUser.containsKey('profileDetails') && 
        cachedUser['profileDetails'] is Map<String, dynamic>) {
      userData = cachedUser['profileDetails'] as Map<String, dynamic>;
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

  void clearSession() {
    user = null;
    isLoggedIn = false;
    update();
  }
}
