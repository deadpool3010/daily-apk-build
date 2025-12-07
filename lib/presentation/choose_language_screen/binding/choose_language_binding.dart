import 'package:get/get.dart';
import '../controller/choose_language_controller.dart';

class ChooseLanguageBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ChooseLanguageController());
  }
}

