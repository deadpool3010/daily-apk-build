import 'package:get/get.dart';
import '../controller/register_homescreen_controller.dart';

class RegisterHomescreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<RegisterHomescreenController>(
      () => RegisterHomescreenController(),
    );
  }
}
