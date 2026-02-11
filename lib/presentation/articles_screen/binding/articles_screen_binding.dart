import 'package:get/get.dart';
import 'package:bandhucare_new/presentation/articles_screen/controller/articles_screen_controller.dart';

class ArticlesScreenBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ArticlesScreenController());
  }
}

