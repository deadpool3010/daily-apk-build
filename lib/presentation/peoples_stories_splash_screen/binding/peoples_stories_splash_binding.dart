import 'package:bandhucare_new/presentation/peoples_stories_splash_screen/controller/peoples_stories_splash_controller.dart';
import 'package:get/get.dart';

class PeoplesStoriesSplashBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeoplesStoriesSplashController>(
      () => PeoplesStoriesSplashController(),
    );
  }
}

