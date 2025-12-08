import 'package:get/get.dart';
import '../controller/email_password_login_controller.dart';

class EmailPasswordLoginBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailPasswordLoginController>(
      () => EmailPasswordLoginController(),
    );
  }
}
