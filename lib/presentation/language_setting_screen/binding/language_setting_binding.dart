import 'package:get/get.dart';
import '../controller/language_setting_controller.dart';

class LanguageSettingBinding extends Bindings {
  @override
  void dependencies() {
    Get.put(LanguageSettingController(), permanent: false);
  }
}
