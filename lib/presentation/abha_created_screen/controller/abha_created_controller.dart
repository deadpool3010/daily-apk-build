import 'package:get/get.dart';

class AbhaCreatedController extends GetxController {
  // ABHA User Data (These would typically come from API response)
  final userName = 'Siddharth'.obs;
  final abhaNumber = '91 1234 5678 9101'.obs;
  final abhaAddress = 'Sid2000@abdm'.obs;
  final gender = 'Male'.obs;
  final dob = '03032004'.obs;
  final mobile = '1234567891'.obs;
  final profileImageUrl = ''.obs; // URL for profile image if available

  @override
  void onInit() {
    super.onInit();
    // TODO: Load ABHA data from API or passed parameters
    // This data should come from the previous screen or API response
  }

  // Handle Continue button
  void handleContinue() {
    // TODO: Navigate to home screen or next screen
    // Get.offNamed(AppRoutes.homeScreen);
  }
}
