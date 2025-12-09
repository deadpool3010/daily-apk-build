import 'package:bandhucare_new/presentation/email_verification_abha_screen/controller/email_verification_abha_controller.dart';
import 'package:get/get.dart';

class EmailVerificationAbhaBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EmailVerificationAbhaController());
  }
}
