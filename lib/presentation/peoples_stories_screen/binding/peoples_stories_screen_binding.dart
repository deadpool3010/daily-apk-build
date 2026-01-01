import 'package:bandhucare_new/presentation/peoples_stories_screen/controller/peoples_stories_screen_controller.dart';
import 'package:get/get.dart';

class PeoplesStoriesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<PeoplesStoriesScreenController>(
      () => PeoplesStoriesScreenController(),
    );
  }
}

