import 'package:bandhucare_new/presentation/mobile_register_screen/controller/mobile_register_controller.dart';
import 'package:get/get.dart';

class MobileRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MobileRegisterController>(() => MobileRegisterController());
  }
}
