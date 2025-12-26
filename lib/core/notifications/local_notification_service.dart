import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'dart:io';
import 'package:firebase_messaging/firebase_messaging.dart';

class LocalNotificationService {
  static final _plugin = FlutterLocalNotificationsPlugin();

  static Future<void> init() async {
    const settings = InitializationSettings(
      android: AndroidInitializationSettings('@mipmap/ic_launcher'),
    );

    await _plugin.initialize(
      settings,
      onDidReceiveNotificationResponse: (NotificationResponse response) {
        // Handle notification tap when app is in foreground
        print('Local notification tapped: ${response.payload}');
        // Note: For proper routing, we rely on FirebaseMessaging.onMessageOpenedApp
        // This handler is mainly for when notifications are tapped while app is open
      },
    );

    // Create notification channel for Android
    if (Platform.isAndroid) {
      await _createNotificationChannel();
    }
  }

  static Future<void> _createNotificationChannel() async {
    const channel = AndroidNotificationChannel(
      'high_importance_channel',
      'High Importance Notifications',
      description: 'This channel is used for important notifications.',
      importance: Importance.high,
      playSound: true,
      enableVibration: true,
    );

    await _plugin
        .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin
        >()
        ?.createNotificationChannel(channel);
  }

  static Future<void> show(
    String? title,
    String? body, {
    RemoteMessage? message,
  }) async {
    const details = NotificationDetails(
      android: AndroidNotificationDetails(
        'high_importance_channel',
        'High Importance Notifications',
        channelDescription: 'This channel is used for important notifications.',
        importance: Importance.high,
        priority: Priority.high,
        showWhen: true,
        icon: '@mipmap/ic_launcher', // Small icon in status bar
        largeIcon: const DrawableResourceAndroidBitmap(
          '@mipmap/ic_launcher',
        ), // App logo in expanded notification
      ),
    );

    // Store message data as JSON string for routing
    String? payload;
    if (message != null && message.data.isNotEmpty) {
      // Store screen and sessionId if available for routing
      final screen = message.data['screen'];
      final sessionId = message.data['sessionId'];
      if (screen != null) {
        payload = '{"screen":"$screen","sessionId":"${sessionId ?? ""}"}';
      }
    }

    await _plugin.show(
      message?.hashCode ??
          DateTime.now().millisecondsSinceEpoch.remainder(100000),
      title ?? 'Notification',
      body ?? 'New message',
      details,
      payload: payload,
    );
  }
}
