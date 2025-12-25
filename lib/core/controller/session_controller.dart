import 'package:bandhucare_new/model/patientModel.dart';
import 'package:get/get.dart';

class SessionController extends GetxController {
  PatientModel? user;
  bool isLoggedIn = false;

  void loadFromCache(Map<String, dynamic> cachedUser) {
    user = PatientModel.fromJson(cachedUser);
    isLoggedIn = true;
    update();
  }
}
