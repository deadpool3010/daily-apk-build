import 'package:bandhucare_new/screens/homeScreen/controller.dart';
import 'package:get/get.dart';

class HomepageBinding extends Bindings {
  @override
  void dependencies() {
    // Use Get.put for immediate initialization to ensure controller is always available
    Get.lazyPut<HomepageController>(() => HomepageController());
  }
}
