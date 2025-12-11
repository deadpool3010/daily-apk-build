import 'package:bandhucare_new/services/variables.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/localization/app_localization.dart';
import 'package:bandhucare_new/services/shared_pref_localization.dart';
import 'routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Load saved locale before app starts
  final prefs = SharedPrefLocalization();
  final savedLocale = await prefs.getAppLocale();
  final locale = _parseLocale(savedLocale);
  await Firebase.initializeApp();
  await _initializeFirebaseMessaging();
  runApp(MyApp(initialLocale: locale));
}

// Helper function to parse locale string to Locale object
Locale _parseLocale(String localeString) {
  final parts = localeString.split('_');
  if (parts.length == 2) {
    return Locale(parts[0], parts[1]);
  }
  return const Locale('en', 'US');
}

class MyApp extends StatelessWidget {
  final Locale initialLocale;

  const MyApp({super.key, required this.initialLocale});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF1E3A8A)),
        useMaterial3: true,
      ),
      translations: AppLocalization(),
      locale: initialLocale,
      fallbackLocale: const Locale('en', 'US'),
      initialRoute: AppRoutes.splashScreen,
      getPages: AppPages.pages,
    );
  }
}

Future<void> _initializeFirebaseMessaging() async {
  try {
    // Request permission for notifications
    final notificationSettings = await FirebaseMessaging.instance
        .requestPermission(
          alert: true,
          announcement: false,
          badge: true,
          carPlay: false,
          criticalAlert: false,
          provisional: true,
          sound: true
        );

    print(
      'User granted permission: ${notificationSettings.authorizationStatus}',
    );

    // For iOS platforms, ensure the APNS token is available before making any FCM plugin API calls
    final apnsToken = await FirebaseMessaging.instance.getAPNSToken();
    if (apnsToken != null) {
      print('APNS token is available: $apnsToken');
      // APNS token is available, make FCM plugin API requests...
    }

    // Get FCM token
    fcmToken = await FirebaseMessaging.instance.getToken();
    if (fcmToken != null) {
      print('FCM Token: $fcmToken');
      // You can send this token to your server here
    }

    // Listen for token refresh
    FirebaseMessaging.instance.onTokenRefresh.listen((fcmToken) {
      print('FCM Token refreshed: $fcmToken');
      // Send the new token to your server
    });

    // Handle background messages
    FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);
  } catch (e) {
    print('Error initializing Firebase Messaging: $e');
  }
}

// Background message handler
@pragma('vm:entry-point')
Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print('Handling a background message: ${message.messageId}');
}
