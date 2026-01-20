import 'package:bandhucare_new/feature/hospital_information/binding/binding.dart';
import 'package:bandhucare_new/feature/hospital_information/presentation/hospital_information.dart';
import 'package:bandhucare_new/feature/personal_information/presentation/personal_information.dart';
import 'package:bandhucare_new/feature/user_profile/presentation/user_profile_screen.dart';
import 'package:bandhucare_new/feature/weekly_questionner/binding/binding.dart';
import 'package:bandhucare_new/feature/weekly_questionner/presentation/weekly_questionner_ui.dart';
import 'package:bandhucare_new/presentation/chat_screen/binding/chat_screen_binding.dart';
import 'package:bandhucare_new/presentation/chat_screen/chat_bot_screen.dart';
import 'package:bandhucare_new/presentation/concent_form_screen/binding/consent_form_binding.dart';
import 'package:bandhucare_new/presentation/concent_form_screen/consent_form_screen.dart';
import 'package:bandhucare_new/presentation/scan_qr_screen/binding/scan_qr_binding.dart';
import 'package:bandhucare_new/presentation/scan_qr_screen/scan_qr_screen.dart';
import 'package:bandhucare_new/presentation/health_calendar/health_calendar.dart';
import 'package:bandhucare_new/presentation/chat_splash_screen/chatbot_splash_loading_screen.dart';
import 'package:bandhucare_new/presentation/home_screen/binding/home_screen_binding.dart';
import 'package:bandhucare_new/presentation/join_community_screen/binding/join_community_binding.dart';
import 'package:bandhucare_new/presentation/join_community_screen/join_community_screen.dart';
import 'package:bandhucare_new/presentation/join_group_screen/join_group_screen.dart';
import 'package:bandhucare_new/presentation/join_group_screen/binding/join_group_binding.dart';
import 'package:bandhucare_new/presentation/language_setting_screen/binding/language_setting_binding.dart';
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
import '../presentation/select_abha_address_screen/select_abha_address_screen.dart';
import '../presentation/select_abha_address_screen/binding/select_abha_address_binding.dart';
import '../presentation/carehub_home_screen/carehub_home_screen.dart';
import '../presentation/carehub_home_screen/binding/carehub_home_screen_binding.dart';
import '../presentation/content_type_home_screen/content_type_home_screen.dart';
import '../presentation/content_type_home_screen/binding/content_type_home_screen_binding.dart';
import '../presentation/blog_screen/blog_screen.dart';
import '../presentation/blog_screen/binding/blog_screen_binding.dart';
import '../presentation/documents_screen/documents_screen.dart';
import '../presentation/documents_screen/binding/documents_screen_binding.dart';
import '../presentation/affirmations_screen/affirmations_screen.dart';
import '../presentation/affirmations_screen/binding/affirmations_screen_binding.dart';
import '../presentation/peoples_stories_splash_screen/peoples_stories_splash_screen.dart';
import '../presentation/peoples_stories_splash_screen/binding/peoples_stories_splash_binding.dart';
import '../presentation/peoples_stories_screen/peoples_stories_screen.dart';
import '../presentation/peoples_stories_screen/binding/peoples_stories_screen_binding.dart';

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
  static const userProfileScreen = '/user-profile-screen';
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
  static const selectAbhaAddressScreen = '/select-abha-address';
  static const personalInformationScreen = '/personal-information';
  static const chatScreen = '/chat-screen';
  static const carehubHomeScreen = '/carehub-home';
  static const contentTypeHomeScreen = '/content-type-home';
  static const blogScreen = '/blog-screen';
  static const documentsScreen = '/documents-screen';
  static const affirmationsScreen = '/affirmations-screen';
  static const peoplesStoriesSplashScreen = '/peoples-stories-splash-screen';
  static const peoplesStoriesScreen = '/peoples-stories-screen';
  static const hospitalInformationScreen = '/hospital-information';
  static const weeklyQuestionnerScreen = '/weekly-questionner';
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
    ),
    GetPage(
      name: AppRoutes.consentFormScreen,
      page: () => ConsentFormScreen(),
      binding: ConsentFormBinding(),
      transition: Transition.leftToRightWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.loginScreen,
      page: () => const LoginScreen(),
      binding: LoginBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.emailPasswordLoginScreen,
      page: () => const EmailPasswordLoginScreen(),
      binding: EmailPasswordLoginBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.mobilePasswordLoginScreen,
      page: () => const MobilePasswordLoginScreen(),
      binding: MobilePasswordLoginBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.registerHomescreen,
      page: () => const RegisterHomescreen(),
      binding: RegisterHomescreenBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.emailRegisterScreen,
      page: () => const EmailRegisterScreen(),
      binding: EmailRegisterBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.mobileRegisterScreen,
      page: () => const MobileRegisterScreen(),
      binding: MobileRegisterBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.abhaRegisterScreen,
      page: () => const AbhaRegisterScreen(),
      binding: AbhaRegisterBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.otpVerificationScreen,
      page: () => const OtpVerificationScreen(),
      binding: OtpVerificationBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.emailVerificationAbhaScreen,
      page: () => const EmailVerificationAbhaScreen(),
      binding: EmailVerificationAbhaBinding(),
      transition: Transition.rightToLeftWithFade,
    ),
    GetPage(
      name: AppRoutes.createAbhaUsernameScreen,
      page: () => const CreateAbhaUsernameScreen(),
      binding: CreateAbhaUsernameBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.abhaCreatedScreen,
      page: () => const AbhaCreatedScreen(),
      binding: AbhaCreatedBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.selectAbhaAddressScreen,
      page: () => const SelectAbhaAddressScreen(),
      binding: SelectAbhaAddressBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.homeScreen,
      page: () => const HomepageScreen(),
      transition: Transition.rightToLeftWithFade,
      binding: HomepageBinding(),
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.scanQrScreen,
      page: () => const ScanQrScreen(),
      binding: ScanQrBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.joinGroupScreen,
      page: () => const GroupScreen(),
      binding: JoinGroupBinding(),
    ),
    GetPage(
      name: AppRoutes.joinCommunityScreen,
      page: () => JoinCommunityScreen(),
      binding: JoinCommunityBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),

    GetPage(
      name: AppRoutes.userProfileScreen,
      page: () => const UserProfileScreen(),
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
    GetPage(
      name: AppRoutes.healthCalendar,
      page: () => const HealthCalendar(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 500),
    ),
    GetPage(
      name: AppRoutes.personalInformationScreen,
      page: () => const PersonalInformation(),
    ),
    GetPage(
      name: AppRoutes.chatScreen,
      page: () => ChatBotScreen(),
      binding: ChatScreenBinding(),
    ),
    GetPage(
      name: AppRoutes.carehubHomeScreen,
      page: () => const CarehubHomeScreen(),
      binding: CarehubHomeScreenBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.contentTypeHomeScreen,
      page: () => const ContentTypeHomeScreen(),
      binding: ContentTypeHomeScreenBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.blogScreen,
      page: () => const BlogScreen(),
      binding: BlogScreenBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.documentsScreen,
      page: () => const DocumentsScreen(),
      binding: DocumentsScreenBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.affirmationsScreen,
      page: () => const AffirmationsScreen(),
      binding: AffirmationsScreenBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.peoplesStoriesSplashScreen,
      page: () => const PeoplesStoriesSplashScreen(),
      binding: PeoplesStoriesSplashBinding(),
      transition: Transition.fadeIn,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.peoplesStoriesScreen,
      page: () => const PeoplesStoriesScreen(),
      binding: PeoplesStoriesScreenBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 300),
    ),
    GetPage(
      name: AppRoutes.hospitalInformationScreen,
      page: () => HospitalInformation(),
      binding: HospitalInformationBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
    GetPage(
      name: AppRoutes.weeklyQuestionnerScreen,
      page: () => WeeklyQuestionnerUi(),
      binding: WeeklyQuestionnerBinding(),
      transition: Transition.rightToLeftWithFade,
      transitionDuration: const Duration(milliseconds: 400),
    ),
  ];
}
