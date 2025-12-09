import 'package:bandhucare_new/presentation/abha_register_screen/controller/abha_register_controller.dart';
import 'package:get/get.dart';

class AbhaRegisterBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AbhaRegisterController>(() => AbhaRegisterController());
  }
}
