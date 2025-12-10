import 'package:get/get.dart';
import 'package:bandhucare_new/routes/app_routes.dart';

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

  // Handle Scan to Join Group button
  void handleScanToJoinGroup() {
    Get.toNamed(AppRoutes.scanQrScreen);
  }

  // Handle Contact Us button
  void handleContactUs() {
    // TODO: Implement contact us functionality
    // Could open email, phone dialer, or contact screen
  }
}
