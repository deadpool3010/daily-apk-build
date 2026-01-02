import 'package:bandhucare_new/core/network/api_services.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:get/get.dart';

class ChatbotSplashScreenController extends GetxController {
  late String sessionId;
  late String mode;
  bool _apiReady = false;
  bool _animationReady = false;
  String? formQuestion;

  @override
  void onReady() {
    final arg = Get.arguments ?? {};
    print('arg: $arg');
    sessionId = arg['sessionId'] ?? '';
    mode = arg['mode'] ?? '';

    _prepareChat();
    super.onReady();
  }

  Future<void> _prepareChat() async {
    if (mode == 'assignment') {
      print('sessionId: $sessionId');
      await getFormQuestionApi(sessionId);
      //print('formQuestion: $formQuestion');
    }

    _apiReady = true;
    _tryToNavigate();
  }

  void onAnimationComplete() {
    _animationReady = true;
    _tryToNavigate();
  }

  void _tryToNavigate() {
    print('formQuestion: $formQuestion');
    if (_apiReady && _animationReady) {
      Get.offNamed(
        AppRoutes.chatScreen,
        // arguments: {'textMessage': formQuestion},
      );
    }
  }
}
