import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:get/get.dart';

class ConsentFormController extends GetxController {
  final isAgreed = false.obs;

  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }

  void navigateToGroupScreen() {
    Get.toNamed(AppRoutes.homeScreen);
  }
}
