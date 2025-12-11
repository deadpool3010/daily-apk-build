import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:bandhucare_new/localization/app_localization.dart';
import 'package:bandhucare_new/services/shared_pref_localization.dart';
import 'routes/app_routes.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Load saved locale before app starts
  final prefs = SharedPrefLocalization();
  final savedLocale = await prefs.getAppLocale();
  final locale = _parseLocale(savedLocale);
  
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
