import 'package:get/get.dart';
import 'package:bandhucare_new/routes/app_routes.dart';

class RegisterHomescreenController extends GetxController {
  void handleAbhaIdRegistration() {
    // Navigate to Abha ID registration flow
    Get.toNamed(AppRoutes.abhaRegisterScreen);
  }

  void handleGoogleRegistration() {
    // Navigate to Google registration flow
    // TODO: Implement Google registration
    // Get.toNamed(AppRoutes.googleRegistrationScreen);
  }

  void handleMobileRegistration() {
    // Navigate to mobile registration screen
    Get.toNamed(AppRoutes.mobileRegisterScreen);
  }

  void handleEmailRegistration() {
    // Navigate to email registration screen
    Get.toNamed(AppRoutes.emailRegisterScreen);
  }
}
