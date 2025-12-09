import 'package:bandhucare_new/presentation/create_abha_username_screen/controller/create_abha_username_controller.dart';
import 'package:get/get.dart';

class CreateAbhaUsernameBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CreateAbhaUsernameController());
  }
}
