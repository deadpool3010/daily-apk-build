import 'package:bandhucare_new/presentation/home_screen/controller/home_screen_controller.dart';
import 'package:get/get.dart';

class HomepageBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put with permanent to ensure controller persists across navigation
    if (!Get.isRegistered<HomepageController>()) {
      Get.put<HomepageController>(HomepageController(), permanent: true);
    }
  }
}
