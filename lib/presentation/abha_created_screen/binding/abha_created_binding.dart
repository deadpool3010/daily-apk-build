import 'package:bandhucare_new/presentation/abha_created_screen/controller/abha_created_controller.dart';
import 'package:get/get.dart';

class AbhaCreatedBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AbhaCreatedController());
  }
}
