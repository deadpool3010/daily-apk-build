import 'package:bandhucare_new/presentation/blog_screen/controller/blog_screen_controller.dart';
import 'package:get/get.dart';

class BlogScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<BlogScreenController>(
      () => BlogScreenController(),
    );
  }
}

