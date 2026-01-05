import 'package:bandhucare_new/presentation/content_type_home_screen/controller/content_type_home_screen_controller.dart';
import 'package:get/get.dart';

class ContentTypeHomeScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ContentTypeHomeScreenController>(
      () => ContentTypeHomeScreenController(),
    );
  }
}

