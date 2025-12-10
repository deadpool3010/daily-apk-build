import 'package:get/get.dart';
import '../controller/consent_form_controller.dart';

class ConsentFormBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ConsentFormController>(() => ConsentFormController());
  }
}
