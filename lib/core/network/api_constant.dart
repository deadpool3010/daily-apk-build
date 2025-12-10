import 'package:bandhucare_new/services/variables.dart';

String baseUrl = "https://devbandhucareapis.revanai.in/v2/api/";
// String createAbhaNumber = "auth/create-abha";
String getAbhaAddressSuggetions(String sessionId) =>
    "auth/abha-address-suggestions/$sessionId";
String createAbhaAddress = "auth/create-abha-address";
String signIn = "auth/sign-in";
String signUp = "auth/sign-up";
String verifyOtp = "auth/verify-otp";
String selectAccount = "auth/select-account";
String createAbhaNumber = "auth/create-abha";
String verifyEmail = "auth/send-verification-link";
String addMeTOCommunity = "community/add-me";
String chatApi = "chat/answer";
String getMessagesApi({int page = 1, int limit = 10}) {
  return "chat/?page=$page&limit=$limit";
}

String addMemberToGroup = "groups/add-members";
String getCommunityApi(String groupId) =>
    "community?groupId=$groupId&search=&page&limit&sort&uniqueCode=$uniqueCode";
String sendVerificationLink = "auth/send-verification-link";
String abhaAddressSuggestions(String sessionId) =>
    "auth/abha-address-suggestions/$sessionId";
