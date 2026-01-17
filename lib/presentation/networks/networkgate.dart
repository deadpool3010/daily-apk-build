import 'package:bandhucare_new/core/network/service/network_service.dart';
import 'package:bandhucare_new/core/network/widget/network_ui.dart';
import 'package:bandhucare_new/localization/app_localization.dart';
import 'package:bandhucare_new/routes/app_routes.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';

class NetworkGate extends StatefulWidget {
  final Locale initialLocale;
  final RemoteMessage? initialMessage;
  const NetworkGate({
    super.key,
    required this.initialLocale,
    required this.initialMessage,
  });

  @override
  State<NetworkGate> createState() => _NetworkGateState();
}

class _NetworkGateState extends State<NetworkGate> {
  final NetworkService _networkService = NetworkService();
  bool? _hasInternet;
  bool _isInitializing = true;

  @override
  void initState() {
    super.initState();
    // Check connectivity immediately on app start
    _checkConnectivity();

    // Listen to ongoing connectivity changes
    _networkService.onStatusChange.listen((hasInternet) {
      if (mounted) {
        setState(() {
          _hasInternet = hasInternet;
          // Only mark as no longer initializing after we get first stream value
          if (_isInitializing) {
            _isInitializing = false;
          }
        });
      }
    });
  }

  Future<void> _checkConnectivity() async {
    final hasInternet = await _networkService.checkNow();
    if (mounted) {
      setState(() {
        _hasInternet = hasInternet;
        _isInitializing = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    // Show loading during initial connectivity check
    if (_isInitializing || _hasInternet == null) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const Scaffold(body: Center(child: CircularProgressIndicator())),
      );
    }

    // Show NoInternetScreen if no internet connection
    if (_hasInternet == false) {
      return MaterialApp(
        debugShowCheckedModeBanner: false,
        home: NoInternetScreen(),
      );
    }

    // Show App only when we have confirmed internet connection
    return App(
      initialLocale: widget.initialLocale,
      initialMessage: widget.initialMessage,
    );
  }
}

class App extends StatelessWidget {
  final Locale initialLocale;
  final RemoteMessage? initialMessage;
  App({super.key, required this.initialLocale, required this.initialMessage});

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
