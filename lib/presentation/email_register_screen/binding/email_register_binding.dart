import 'package:get/get.dart';
import '../controller/email_register_controller.dart';

class EmailRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<EmailRegisterController>(() => EmailRegisterController());
  }
}
