import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:firebase_core/firebase_core.dart';
import 'local_notification_service.dart';
import 'notification_router.dart';

class NotificationService {
  // Background message handler must be a top-level function
  // Note: This runs in a separate isolate, so we can't use static methods from other classes
  // Firebase will show the notification automatically if it has a notification payload
  @pragma('vm:entry-point')
  static Future<void> firebaseMessagingBackgroundHandler(
    RemoteMessage message,
  ) async {
    try {
      await Firebase.initializeApp();
      print('📩 Background message received: ${message.messageId}');
      print('📩 Title: ${message.notification?.title}');
      print('📩 Body: ${message.notification?.body}');
      print('📩 Data: ${message.data}');

      // Firebase automatically shows notifications when app is in background/terminated
      // If you need custom local notifications, initialize the plugin here
      // For now, Firebase handles it automatically
    } catch (e) {
      print('Error in background handler: $e');
    }
  }

  static Future<void> init() async {
    // Register background handler BEFORE any other Firebase operations
    FirebaseMessaging.onBackgroundMessage(firebaseMessagingBackgroundHandler);

    // Request notification permissions
    final notificationSettings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: false,
          sound: true,
        );

    print(
      'User granted permission: ${notificationSettings.authorizationStatus}',
    );

    // Handle foreground messages
    FirebaseMessaging.onMessage.listen((msg) {
      print('📩 Foreground notification: ${msg.notification?.title}');
      print('📩 Data: ${msg.data}');

      if (msg.notification != null) {
        LocalNotificationService.show(
          msg.notification!.title,
          msg.notification!.body,
          message: msg,
        );
      }
    });

    // Handle notification tap when app is in background
    FirebaseMessaging.onMessageOpenedApp.listen((msg) {
      print(
        '📩 Notification tapped (app in background): ${msg.notification?.title}',
      );
      NotificationRouter.handle(msg);
    });
  }

  static Future<RemoteMessage?> getInitial() async {
    return await FirebaseMessaging.instance.getInitialMessage();
  }
}
