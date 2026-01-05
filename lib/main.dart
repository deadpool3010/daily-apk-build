import 'package:bandhucare_new/core/notifications/local_notification_service.dart';
import 'package:bandhucare_new/core/notifications/notification_router.dart';
import 'package:bandhucare_new/core/notifications/notification_service.dart';
import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/localization/app_localization.dart';
import 'package:bandhucare_new/core/services/shared_pref_localization.dart';
import 'package:toastification/toastification.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:bandhucare_new/core/controller/session_controller.dart';

// Flutter Local Notifications plugin instance
// final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
//     FlutterLocalNotificationsPlugin();

// // IMPORTANT: Background message handler must be a top-level function
// @pragma('vm:entry-point')
// Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
//   try {
//     await Firebase.initializeApp();
//     print('📩 Background message received: ${message.messageId}');
//     print('📩 Title: ${message.notification?.title}');
//     print('📩 Body: ${message.notification?.body}');
//     print('📩 Data: ${message.data}');

//     // Show local notification for background messages
//     if (message.notification != null) {
//       await _showLocalNotification(message);
//     }
//   } catch (e) {
//     print('Error in background handler: $e');
//   }
// }

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved locale before app starts
  final prefs = SharedPrefLocalization();
  final savedLocale = await prefs.getAppLocale();
  final locale = _parseLocale(savedLocale);

  print("Initializing Firebase...");
  await Firebase.initializeApp();

  // Initialize Local Notifications first (needed for background handler)
  await LocalNotificationService.init();

  // Initialize Notification Service (registers background handler)
  await NotificationService.init();

  // Initialize Firebase Messaging (get token, etc.)
  await _initializeFirebaseMessaging();
  final initialMessage = await NotificationService.getInitial();
  // Initialize Local Notifications first
  // await _initializeLocalNotifications();

  // Initialize Firebase with error handling
  // try {

  //  // print("Firebase initialized successfully");
  // } catch (e) {
  //   // print('Firebase not configured (this is optional):');
  //   // print('  - To enable Firebase, add google-services.json to android/app/');
  //   // print('  - App will continue to work without Firebase');
  // }

  // Store initial notification for handling after app starts
  // final initialMessage = await handleInitialNotification();
  // if (initialMessage != null) {
  //   printNotificationPayload(initialMessage);
  // }
  Get.put(SessionController(), permanent: true);
  runApp(
    ToastificationWrapper(
      child: MyApp(initialLocale: locale, initialMessage: initialMessage),
    ),
  );
}

// Helper function to parse locale string to Locale object
Locale _parseLocale(String localeString) {
  final parts = localeString.split('_');
  if (parts.length == 2) {
    return Locale(parts[0], parts[1]);
  }
  return const Locale('en', 'US');
}

class MyApp extends StatefulWidget {
  final Locale initialLocale;
  final RemoteMessage? initialMessage;

  const MyApp({super.key, required this.initialLocale, this.initialMessage});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    super.initState();
    // _setupForegroundMessageHandler();

    // if (widget.initialMessage != null) {
    //   Future.delayed(const Duration(seconds: 2), () {
    //     _handleNotificationTap(widget.initialMessage!);
    //   });
    // }
  }

  // void _setupForegroundMessageHandler() {
  //   FirebaseMessaging.onMessage.listen((RemoteMessage message) {
  //     print('📩 Foreground notification: ${message.notification?.title}');
  //     printNotificationPayload(message);
  //     _showForegroundNotification(message);
  //   });

  //   FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
  //     print(
  //       '📩 Notification tapped (app in background): ${message.notification?.title}',
  //     );
  //     _handleNotificationTap(message);
  //   });
  // }

  // void _showForegroundNotification(RemoteMessage message) async {
  //   // Show local notification when app is in foreground
  //   // Firebase doesn't show notifications automatically when app is open
  //   if (message.notification != null) {
  //     await _showLocalNotification(message);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (widget.initialMessage != null) {
        NotificationRouter.handle(widget.initialMessage!);
      }
    });
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
      ),
      translations: AppLocalization(),
      locale: widget.initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.pages,
    );
  }
}

Future<void> _initializeFirebaseMessaging() async {
  try {
    // For iOS - get APNS token
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      print('APNS token: $apnsToken');
    }

    // Get FCM token
    fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      print('FCM Token: $fcmToken');
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('FCM Token refreshed: $fcmToken');
    });
  } catch (e) {
    print('Error initializing Firebase Messaging: $e');
  }
}

// void printNotificationPayload(RemoteMessage message) {
//   print("📩 FCM NOTIFICATION RECEIVED");
//   print("🔹 Message ID: ${message.messageId}");
//   print("🔹 From: ${message.from}");
//   print("🔹 Data Payload: ${message.data}");
//   print("🔹 Title: ${message.notification?.title}");
//   print("🔹 Body: ${message.notification?.body}");
// }

// Future<RemoteMessage?> handleInitialNotification() async {
//   return await FirebaseMessaging.instance.getInitialMessage();
// }

// void _handleNotificationTap(RemoteMessage message) {
//   try {
//     print('🔔 Handling notification tap: ${message.data}');
//     final data = message.data;
//     final sessionId = message.data['sessionId'];
//     if (data.containsKey('screen')) {
//       final type = data['screen'];
//       switch (type) {
//         case 'ChatBotScreen':
//           Get.toNamed(
//             AppRoutes.chatbotSplashLoadingScreen,
//             arguments: {'sessionId': sessionId},
//           );
//           break;
//         case 'reminder':
//           // Get.toNamed(AppRoutes.reminderScreen, arguments: data);
//           break;
//         default:
//           break;
//       }
//     }
//   } catch (e) {
//     print('Error handling notification tap: $e');
//   }
// }

// Initialize Local Notifications
// Future<void> _initializeLocalNotifications() async {
//   const AndroidInitializationSettings initializationSettingsAndroid =
//       AndroidInitializationSettings('@mipmap/ic_launcher');

//   const InitializationSettings initializationSettings = InitializationSettings(
//     android: initializationSettingsAndroid,
//   );

//   await flutterLocalNotificationsPlugin.initialize(
//     initializationSettings,
//     onDidReceiveNotificationResponse: (NotificationResponse response) {
//       // Handle notification tap
//       print('Notification tapped: ${response.payload}');
//       if (response.payload != null) {
//         // You can parse payload and navigate here
//       }
//     },
//   );

// Create high importance notification channel for Android
//   if (Platform.isAndroid) {
//     await _createNotificationChannel();
//   }
// }

// Create notification channel for Android
// Future<void> _createNotificationChannel() async {
//   const AndroidNotificationChannel channel = AndroidNotificationChannel(
//     'high_importance_channel', // Must match the one in AndroidManifest.xml
//     'High Importance Notifications',
//     description: 'This channel is used for important notifications.',
//     importance: Importance.high,
//     playSound: true,
//     enableVibration: true,
//   );

//   await flutterLocalNotificationsPlugin
//       .resolvePlatformSpecificImplementation<
//         AndroidFlutterLocalNotificationsPlugin
//       >()
//       ?.createNotificationChannel(channel);
// }

// Show local notification
// Future<void> _showLocalNotification(RemoteMessage message) async {
//   const AndroidNotificationDetails androidPlatformChannelSpecifics =
//       AndroidNotificationDetails(
//         'high_importance_channel', // Must match channel ID
//         'High Importance Notifications',
//         channelDescription: 'This channel is used for important notifications.',
//         importance: Importance.high,
//         priority: Priority.high,
//         showWhen: true,
//       );

//   const NotificationDetails platformChannelSpecifics = NotificationDetails(
//     android: androidPlatformChannelSpecifics,
//   );

//   await flutterLocalNotificationsPlugin.show(
//     message.hashCode,
//     message.notification?.title ?? 'Notification',
//     message.notification?.body ?? 'New message',
//     platformChannelSpecifics,
//     payload: message.data.toString(),
//   );
// }
