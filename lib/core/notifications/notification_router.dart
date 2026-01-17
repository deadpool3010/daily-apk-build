import 'package:get/get.dart';
import '../../routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

class NotificationRouter {
  static bool _handled = false;

  static void handle(RemoteMessage message) {
    if (_handled) return;
    _handled = true;

    final data = message.data;
    final screen = data['screen'];
    final sessionId = data['sessionId'];

    switch (screen) {
      case 'ChatBotScreen':
        Get.toNamed(
          AppRoutes.chatbotSplashLoadingScreen,
          arguments: {'sessionId': sessionId},
        );
        break;
    }
  }
}
