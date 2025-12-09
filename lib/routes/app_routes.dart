import 'package:bandhucare_new/presentation/scan_qr_screen/binding/scan_qr_binding.dart';
import 'package:bandhucare_new/presentation/scan_qr_screen/scan_qr_screen.dart';
import 'package:bandhucare_new/presentation/health_calendar/health_calendar.dart';
import 'package:bandhucare_new/presentation/chat_splash_screen/chatbot_splash_loading_screen.dart';
import 'package:bandhucare_new/presentation/home_screen/binding/home_screen_binding.dart';
import 'package:bandhucare_new/presentation/join_community_screen/binding/join_community_binding.dart';
import 'package:bandhucare_new/presentation/join_community_screen/join_community_screen.dart';
import 'package:bandhucare_new/presentation/join_group_screen/join_group_screen.dart';
import 'package:bandhucare_new/presentation/language_setting_screen/binding/language_setting_binding.dart';
import 'package:bandhucare_new/presentation/user_profile_screen/userProfile.dart';
import 'package:bandhucare_new/presentation/user_profile_screen/binding/user_profile_binding.dart';
import 'package:bandhucare_new/presentation/language_setting_screen/language_setting_screen.dart';
import 'package:get/get.dart';
import '../presentation/home_screen/home_screen.dart';
import '../presentation/login_screen/binding/login_screen_binding.dart';
import '../presentation/login_screen/login_screen.dart';
import '../presentation/splash_screen/binding/splash_binding.dart';
import '../presentation/splash_screen/splash_screen.dart';
import '../presentation/choose_language_screen/binding/choose_language_binding.dart';
import '../presentation/choose_language_screen/choose_language_screen.dart';
import '../presentation/email_password_login_screen/email_password_login_screen.dart';
import '../presentation/email_password_login_screen/binding/email_password_login_binding.dart';
import '../presentation/mobile_password_login_screen/mobile_password_login_screen.dart';
import '../presentation/mobile_password_login_screen/binding/mobile_password_login_binding.dart';
import '../presentation/register_homescreen/register_homescreen.dart';
import '../presentation/register_homescreen/binding/register_homescreen_binding.dart';
import '../presentation/email_register_screen/email_register_screen.dart';
import '../presentation/email_register_screen/binding/email_register_binding.dart';
import '../presentation/mobile_register_screen/mobile_register_screen.dart';
import '../presentation/mobile_register_screen/binding/mobile_register_binding.dart';
import '../presentation/abha_register_screen/abha_register_screen.dart';
import '../presentation/abha_register_screen/binding/abha_register_binding.dart';
import '../presentation/otp_verification_screen/otp_verification_screen.dart';
import '../presentation/otp_verification_screen/binding/otp_verification_binding.dart';
import '../presentation/email_verification_abha_screen/email_verification_abha_screen.dart';
import '../presentation/email_verification_abha_screen/binding/email_verification_abha_binding.dart';
import '../presentation/create_abha_username_screen/create_abha_username_screen.dart';
import '../presentation/create_abha_username_screen/binding/create_abha_username_binding.dart';
import '../presentation/abha_created_screen/abha_created_screen.dart';
import '../presentation/abha_created_screen/binding/abha_created_binding.dart';

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
  static const languageSettingsScreen = '/language-settings';
  static const simpleLanguageScreen = '/simple-language-settings';
  static const userProfile = '/user-profile';
  static const privacyScreen = '/privacy-screen';
  static const chatbotSplashLoadingScreen = '/chatbot-splash-loading-screen';
  static const healthCalendar = '/health-calendar';
  static const chooseLanguageScreen = '/choose-language';
  static const emailPasswordLoginScreen = '/email-password-login';
  static const mobilePasswordLoginScreen = '/mobile-password-login';
  static const registerHomescreen = '/register-homescreen';
  static const emailRegisterScreen = '/email-register';
  static const mobileRegisterScreen = '/mobile-register';
  static const abhaRegisterScreen = '/abha-register';
  static const otpVerificationScreen = '/otp-verification';
  static const emailVerificationAbhaScreen = '/email-verification-abha';
  static const createAbhaUsernameScreen = '/create-abha-username';
  static const abhaCreatedScreen = '/abha-created';
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
      name: AppRoutes.chooseLanguageScreen,
      page: () => const ChooseLanguageScreen(),
      binding: ChooseLanguageBinding(),
      transition: Transition.fadeIn,
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
      name: AppRoutes.emailPasswordLoginScreen,
      page: () => const EmailPasswordLoginScreen(),
      binding: EmailPasswordLoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.mobilePasswordLoginScreen,
      page: () => const MobilePasswordLoginScreen(),
      binding: MobilePasswordLoginBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.registerHomescreen,
      page: () => const RegisterHomescreen(),
      binding: RegisterHomescreenBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.emailRegisterScreen,
      page: () => const EmailRegisterScreen(),
      binding: EmailRegisterBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.mobileRegisterScreen,
      page: () => const MobileRegisterScreen(),
      binding: MobileRegisterBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.abhaRegisterScreen,
      page: () => const AbhaRegisterScreen(),
      binding: AbhaRegisterBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.emailVerificationAbhaScreen,
      page: () => const EmailVerificationAbhaScreen(),
      binding: EmailVerificationAbhaBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.createAbhaUsernameScreen,
      page: () => const CreateAbhaUsernameScreen(),
      binding: CreateAbhaUsernameBinding(),
      transition: Transition.fadeIn,
    ),
    GetPage(
      name: AppRoutes.abhaCreatedScreen,
      page: () => const AbhaCreatedScreen(),
      binding: AbhaCreatedBinding(),
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

    GetPage(
      name: AppRoutes.userProfile,
      page: () => const UserProfile(),
      binding: UserProfileBinding(),
    ),
    GetPage(
      name: AppRoutes.simpleLanguageScreen,
      page: () => const SimpleLanguageScreen(),
      binding: LanguageSettingBinding(),
    ),
    GetPage(
      name: AppRoutes.chatbotSplashLoadingScreen,
      page: () => const ChatbotSplashLoadingScreen(),
    ),
    GetPage(name: AppRoutes.healthCalendar, page: () => const HealthCalendar()),
  ];
}
