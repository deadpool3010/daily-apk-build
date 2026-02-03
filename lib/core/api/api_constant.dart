import 'package:bandhucare_new/core/constants/variables.dart';

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
String chatApi = "chat/answerv2";
String getAllMessagesApi({int page = 1, int limit = 10}) {
  return "chat/?page=$page&limit=$limit";
}

String getFormQuestion(String sessionId) => "form/get-question/$sessionId";

String addMemberToGroup = "groups/add-members";
String getGroupInfoApi(String groupId, String uniqueCode, [String? language]) {
  String url = "groups/get-group-info/$groupId?uniqueCode=$uniqueCode";
  if (language != null && language.trim().isNotEmpty) {
    url += "&language=${Uri.encodeComponent(language.trim())}";
  }
  print('getGroupInfoApi - language parameter: "$language", final URL: $url');
  return url;
}

String getCommunityApi(String groupId) =>
    "community?groupId=$groupId&search=&page&limit&sort&uniqueCode=$uniqueCode";
String sendVerificationLink = "auth/send-verification-link";
String abhaAddressSuggestions(String sessionId) =>
    "auth/abha-address-suggestions/$sessionId";
String updateFcmToken = "auth/update-fcm";
String getFormSessions(String date, String status) =>
    "form/sessions?date=$date&status=$status";

String getTranscription = "auth/audio-transcript";
String getHospitalInformation(String language) =>
    "auth/get-hospital-info?language=$language";

String getUserGroups(String language) {
  return "groups/get-user-groups?language=$language";
}

String likeMessage = 'chat/like-message';
String disLikeMessage = 'chat/dislike-message';
String getFormQuestionAns(String sessionId) => "form/report/$sessionId";
String getHomepage = "auth/homepage";
String editAnswer = "form/edit-question";
String switchGroup(String groupId) => "groups/switch-group/$groupId";
String updateProfile = "auth/profile";
String getAllStates = "auth/get-all-states";
String getAllCities(String stateId) => "auth/get-cities-by-state/$stateId";
