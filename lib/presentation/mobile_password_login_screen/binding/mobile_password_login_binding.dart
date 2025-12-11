import 'package:get/get.dart';
import '../controller/mobile_password_login_controller.dart';

class MobilePasswordLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobilePasswordLoginController>(
      () => MobilePasswordLoginController(),
    );
  }
}
