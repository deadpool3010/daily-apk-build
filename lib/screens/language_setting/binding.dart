import 'package:get/get.dart';
import 'controller.dart';

class LanguageSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => LanguageSettingController());
  }
}
