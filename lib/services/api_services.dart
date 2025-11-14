import 'dart:convert';

import 'package:bandhucare_new/constant/variables.dart';
import 'package:bandhucare_new/services/apis.dart';
import 'package:http/http.dart' as http;

Future<Map<String, dynamic>> signInApi(String mobileNumber) async {
  try {
    final url = baseUrl + signIn;
    print('SignIn API URL: $url');
    print('Mobile Number: $mobileNumber');

    final response = await http.post(
      Uri.parse(url),
      body: {"mobileNumber": mobileNumber, "signInWith": "abhaMobile"},
    );

    print('SignIn Response Status: ${response.statusCode}');
    print('SignIn Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      // Extract sessionId from nested data object
      sessionId = result["data"]["sessionId"] as String;
      print('Session ID saved: $sessionId');
      return result;
    } else {
      throw Exception(
        "Failed to sign in: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('SignIn Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> verifyOtpforabhaMobileApi(
  String otp,
  String sessionId,
) async {
  try {
    final url = baseUrl + verifyOtp;
    print('VerifyOtp API URL: $url');
    print('OTP: $otp, SessionId: $sessionId');

    final response = await http.post(
      Uri.parse(url),
      body: {"otp": otp, "sessionId": sessionId, "verifyFor": "abhaMobile"},
    );

    print('VerifyOtp Response Status: ${response.statusCode}');
    print('VerifyOtp Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);

      // Check if OTP verification actually succeeded by examining the message
      String message = result['message'] ?? '';
      if (message.toLowerCase().contains('invalid') ||
          message.toLowerCase().contains('incorrect') ||
          message.toLowerCase().contains('expired')) {
        throw Exception(message);
      }

      return result;
    } else {
      final result = jsonDecode(response.body);
      throw Exception(
        "Failed to verify OTP: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('VerifyOtp Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> verifyOtpforAadhaarNumberApi(
  String otp,
  String sessionId,
  String phoneNumber,
) async {
  try {
    final url = baseUrl + verifyOtp;
    print('VerifyOtpforAadhaarNumber API URL: $url');
    print('OTP: $otp, SessionId: $sessionId');
    final response = await http.post(
      Uri.parse(url),
      body: {
        "otp": otp,
        "sessionId": sessionId,
        "verifyFor": "createAbha",
        "mobileNumber": phoneNumber,
      },
    );
    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      // Check if OTP verification actually succeeded by examining the message
      String message = result['message'] ?? '';
      if (message.toLowerCase().contains('invalid') ||
          message.toLowerCase().contains('incorrect') ||
          message.toLowerCase().contains('expired')) {
        throw Exception(message);
      }

      return result;
    } else {
      final result = jsonDecode(response.body);
      throw Exception(
        "Failed to verify OTP: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('VerifyOtp Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> selectAccountApi(
  String sessionId,
  String abhaNumber,
) async {
  try {
    final url = baseUrl + selectAccount;
    print('SelectAccount API URL: $url');
    print('SessionId: $sessionId, AbhaNumber: $abhaNumber');

    final response = await http.post(
      Uri.parse(url),
      body: {
        "abhaNumber": abhaNumber,
        "sessionId": sessionId,
        "signInWith": "abhaMobile",
      },
    );

    print('SelectAccount Response Status: ${response.statusCode}');
    print('SelectAccount Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result;
    } else {
      final result = jsonDecode(response.body);
      throw Exception(
        "Failed to select account: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('SelectAccount Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> createAbhaNumberApi(String adharNumber) async {
  final url = baseUrl + createAbhaNumber;
  try {
    final response = await http.post(
      Uri.parse(url),
      body: {"aadhaarNumber": adharNumber},
    );
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print('CreateAbhaNumber Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> verifyEmailApi(
  String email,
  String sessionId,
) async {
  final url = baseUrl + verifyEmail;
  final response = await http.post(
    Uri.parse(url),
    body: {"email": email, "sessionId": sessionId},
  );
  final result = jsonDecode(response.body);
  if (response.statusCode == 200) {
    return result;
  } else {
    throw Exception(result['message'] ?? 'Unknown error');
  }
}

Future<Map<String, dynamic>> createAbhaAddressApi(
  String abhaAddress,
  String sessionId,
) async {
  try {
    final url = baseUrl + createAbhaAddress;
    print('CreateAbhaAddress API URL: $url');
    print('AbhaAddress: $abhaAddress, SessionId: $sessionId');

    final response = await http.post(
      Uri.parse(url),
      body: {"abhaAddress": abhaAddress, "sessionId": sessionId},
    );

    print('CreateAbhaAddress Response Status: ${response.statusCode}');
    print('CreateAbhaAddress Response Body: ${response.body}');

    if (response.statusCode == 200) {
      final result = jsonDecode(response.body);
      return result;
    } else {
      final result = jsonDecode(response.body);
      throw Exception(
        "Failed to create ABHA address: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('CreateAbhaAddress Error: $e');
    throw Exception(e);
  }
}
