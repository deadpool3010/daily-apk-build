import 'package:get/get.dart';
import 'package:bandhucare_new/routes/app_routes.dart';

class RegisterHomescreenController extends GetxController {
  void handleAbhaIdRegistration() {
    // Navigate to Abha ID registration flow
    // TODO: Implement Abha ID registration
    // Get.toNamed(AppRoutes.abhaIdRegistrationScreen);
  }

  void handleGoogleRegistration() {
    // Navigate to Google registration flow
    // TODO: Implement Google registration
    // Get.toNamed(AppRoutes.googleRegistrationScreen);
  }

  void handleMobileRegistration() {
    // Navigate to mobile registration (OTP-based login screen)
    Get.toNamed(AppRoutes.loginScreen);
  }

  void handleEmailRegistration() {
    // Navigate to email registration (email/password login screen)
    Get.toNamed(AppRoutes.emailPasswordLoginScreen);
  }
}
