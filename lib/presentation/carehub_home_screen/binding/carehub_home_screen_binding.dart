import 'package:bandhucare_new/presentation/carehub_home_screen/controller/carehub_home_screen_controller.dart';
import 'package:get/get.dart';

class CarehubHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<CarehubHomeScreenController>(() => CarehubHomeScreenController());
  }
}

