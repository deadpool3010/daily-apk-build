import 'package:get/get.dart';

class SessionController extends GetxController {
  Map<String, dynamic>? user;
  bool isLoggedIn = false;

  void loadFromCache(Map<String, dynamic> cachedUser) {
    user = cachedUser;
    isLoggedIn = true;
    update();
  }
}
