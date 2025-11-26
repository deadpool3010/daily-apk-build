import 'package:bandhucare_new/scan_qr_screen/binding/scan_qr_binding.dart';
import 'package:bandhucare_new/scan_qr_screen/scan_qr_screen.dart';
import 'package:bandhucare_new/screens/homeScreen/binding.dart';
import 'package:bandhucare_new/screens/join_community_screen/binding.dart';
import 'package:bandhucare_new/screens/join_community_screen/join_community_screen.dart';
import 'package:bandhucare_new/screens/join_group_screen.dart/join_group_screen.dart';
import 'package:get/get.dart';
import '../screens/homeScreen/homepage_ui.dart';
import '../screens/login_screen/binding.dart';
import '../screens/login_screen/login_screen.dart';
import '../screens/splash_screen/splash_binding.dart';
import '../screens/splash_screen/splash_screen.dart';

class AppRoutes {
  AppRoutes._();

  static const splashScreen = '/';
  static const consentFormScreen = '/consent-form';
  static const loginScreen = '/login';
  static const homeScreen = '/home';
  static const imagePreviewRoute = '/image-preview';
  static const videoPreviewRoute = '/video-preview';
  static const documentPreviewRoute = '/document-preview';
  static const scanQrScreen = '/scan-qr';
  static const joinGroupScreen = '/join-group';
  static const joinCommunityScreen = '/join-community';
}

class AppPages {
  AppPages._();

  static final pages = <GetPage<dynamic>>[
    GetPage(
      name: AppRoutes.splashScreen,
      page: () => const SplashScreen(),
      binding: SplashBinding(),
    ),
    GetPage(
      name: AppRoutes.consentFormScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomepageScreen(),
      transition: Transition.fadeIn,
      binding: HomepageBinding(),
    ),
    GetPage(
      name: AppRoutes.scanQrScreen,
      page: () => const ScanQrScreen(),
      binding: ScanQrBinding(),
    ),
    GetPage(name: AppRoutes.joinGroupScreen, page: () => const GroupScreen()),
    GetPage(
      name: AppRoutes.joinCommunityScreen,
      page: () => JoinCommunityScreen(),
      binding: JoinCommunityBinding(),
    ),
  ];
}
