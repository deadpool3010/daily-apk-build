import 'package:get/get.dart';
import 'package:bandhucare_new/presentation/stories_screen/controller/stories_screen_controller.dart';

class StoriesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => StoriesScreenController());
  }
}