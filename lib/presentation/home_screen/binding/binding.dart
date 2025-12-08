import 'package:bandhucare_new/presentation/home_screen/controller/home_screen_controller.dart';
import 'package:get/get.dart';

class HomepageBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put for immediate initialization to ensure controller is always available
    Get.lazyPut<HomepageController>(() => HomepageController());
  }
}
