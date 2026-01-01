import 'package:bandhucare_new/presentation/affirmations_screen/controller/affirmations_screen_controller.dart';
import 'package:get/get.dart';

class AffirmationsScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<AffirmationsScreenController>(
      () => AffirmationsScreenController(),
    );
  }
}

