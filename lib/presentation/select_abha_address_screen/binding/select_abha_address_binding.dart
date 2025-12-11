import 'package:get/get.dart';
import '../controller/select_abha_address_controller.dart';

class SelectAbhaAddressBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<SelectAbhaAddressController>(
      () => SelectAbhaAddressController(),
    );
  }
}
