import 'package:bandhucare_new/presentation/blog_screen/widgets/tiptap/tiptap_renderer_registration.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:get/get.dart';

class ConsentFormController extends GetxController {
  final isAgreed = false.obs;

  @override
  void onInit() {
    super.onInit();
    // Register TipTap renderers for consent form content
    registerTiptapRenderers();
  }

  void toggleAgreement() {
    isAgreed.value = !isAgreed.value;
  }

  void navigateToGroupScreen() {
    Get.offAllNamed(AppRoutes.homeScreen);
  }
}
