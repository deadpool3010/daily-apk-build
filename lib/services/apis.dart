String baseUrl = "https://acrylic-chair-tray-quality.trycloudflare.com/api/";

// String createAbhaNumber = "auth/create-abha";
String getAbhaAddressSuggetions(String sessionId) =>
    "auth/abha-address-suggestions/$sessionId";
String createAbhaAddress = "auth/create-abha-address";
String signIn = "auth/sign-in";
String verifyOtp = "auth/verify-otp";
String selectAccount = "auth/select-account";
String createAbhaNumber = "auth/create-abha";
String verifyEmail = "auth/send-verification-link";
