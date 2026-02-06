import 'dart:convert';
import 'dart:io';

import 'package:bandhucare_new/core/controller/session_controller.dart';
import 'package:bandhucare_new/model/city_model.dart';
import 'package:bandhucare_new/model/patientModel.dart';
import 'package:bandhucare_new/core/constants/variables.dart';
import 'package:bandhucare_new/core/api/api_constant.dart';
import 'package:bandhucare_new/core/services/shared_pref_localization.dart';
import 'package:bandhucare_new/model/state_model.dart';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:toastification/toastification.dart';

Future<Map<String, dynamic>> signUpApi({
  required String name,
  required String emailNumber,
  required String password,
  String userType = "patient",
}) async {
  try {
    final url = baseUrl + signUp;
    print('SignUp API URL: $url');
    print('Name: $name, Email/Number: $emailNumber, UserType: $userType');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "name": name,
        "email_number": emailNumber,
        "password": password,
        "userType": userType,
      }),
    );

    print('SignUp Response Status: ${response.statusCode}');
    print('SignUp Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 201) {
      // Attempt to extract tokens from response
      try {
        // Try to get tokens from data object first, then from root
        Map<String, dynamic>? dataMap;
        if (result['data'] != null && result['data'] is Map) {
          dataMap = result['data'] as Map<String, dynamic>;
        }

        // Extract tokens from data or root level
        final extractedAccessToken =
            dataMap?['accessToken'] ??
            dataMap?['token'] ??
            dataMap?['access_token'] ??
            result['accessToken'] ??
            result['token'] ??
            result['access_token'] ??
            '';

        final extractedRefreshToken =
            dataMap?['refreshToken'] ??
            dataMap?['refresh_token'] ??
            result['refreshToken'] ??
            result['refresh_token'] ??
            '';

        // Save to globals
        if (extractedAccessToken is String && extractedAccessToken.isNotEmpty) {
          accessToken = extractedAccessToken;
          print('AccessToken saved: ${accessToken.substring(0, 20)}...');
        }
        if (extractedRefreshToken is String &&
            extractedRefreshToken.isNotEmpty) {
          refreshToken = extractedRefreshToken;
          print('RefreshToken saved: ${refreshToken.substring(0, 20)}...');
        }

        // Persist tokens if available
        if (accessToken.isNotEmpty || refreshToken.isNotEmpty) {
          await SharedPrefLocalization().saveTokens(accessToken, refreshToken);
          print('Tokens saved to SharedPreferences');
        }

        // Optionally persist user info if provided
        if (dataMap != null && dataMap.isNotEmpty) {
          await SharedPrefLocalization().saveUserInfo(
            result['data']['profileDetails'],
          );
          final userModel = PatientModel.fromJson(
            result['data']['profileDetails'],
          );
          final session = Get.find<SessionController>();
          session.setUser(userModel);
        }
      } catch (e) {
        print('SignUp token save warning: $e');
      }

      return result;
    } else {
      throw Exception(
        "Failed to sign up: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('SignUp Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> signInApi(String mobileNumber) async {
  try {
    final url = baseUrl + signIn;
    print('SignIn API URL: $url');
    print('Mobile Number: $mobileNumber');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "mobileNumber": mobileNumber,
        "signInWith": "abhaMobile",
      }),
    );

    print('SignIn Response Status: ${response.statusCode}');
    print('SignIn Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Extract sessionId from nested data object or root level
      String? extractedSessionId;
      if (result['data'] != null && result['data'] is Map) {
        final data = result['data'] as Map<String, dynamic>;
        extractedSessionId = data['sessionId']?.toString();
      }
      if (extractedSessionId == null || extractedSessionId.isEmpty) {
        extractedSessionId = result['sessionId']?.toString();
      }
      if (extractedSessionId != null && extractedSessionId.isNotEmpty) {
        sessionId = extractedSessionId;
        print('Session ID saved: $sessionId');
      }
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

Future<Map<String, dynamic>> signInWithCredentialsApi({
  required String emailNumber,
  required String password,
}) async {
  try {
    final url = baseUrl + signIn;
    print('SignInWithCredentials API URL: $url');
    print('Email/Number: $emailNumber');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "email_number": emailNumber,
        "password": password,
        "signInWith": "credentials",
      }),
    );

    print('SignInWithCredentials Response Status: ${response.statusCode}');
    print('SignInWithCredentials Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Attempt to extract tokens from response
      try {
        // Try to get tokens from data object first, then from root
        Map<String, dynamic>? dataMap;
        if (result['data'] != null && result['data'] is Map) {
          dataMap = result['data'] as Map<String, dynamic>;
        }

        // Extract tokens from data or root level
        final extractedAccessToken =
            dataMap?['accessToken'] ??
            dataMap?['token'] ??
            dataMap?['access_token'] ??
            result['accessToken'] ??
            result['token'] ??
            result['access_token'] ??
            '';

        final extractedRefreshToken =
            dataMap?['refreshToken'] ??
            dataMap?['refresh_token'] ??
            result['refreshToken'] ??
            result['refresh_token'] ??
            '';

        // Save to globals
        if (extractedAccessToken is String && extractedAccessToken.isNotEmpty) {
          accessToken = extractedAccessToken;
          print('AccessToken saved: ${accessToken.substring(0, 20)}...');
        }
        if (extractedRefreshToken is String &&
            extractedRefreshToken.isNotEmpty) {
          refreshToken = extractedRefreshToken;
          print('RefreshToken saved: ${refreshToken.substring(0, 20)}...');
        }

        // Persist tokens if available
        if (accessToken.isNotEmpty || refreshToken.isNotEmpty) {
          await SharedPrefLocalization().saveTokens(accessToken, refreshToken);
          print('Tokens saved to SharedPreferences');
        }

        // Optionally persist user info if provided
        if (dataMap != null && dataMap.isNotEmpty) {
          await SharedPrefLocalization().saveUserInfo(
            result['data']['profileDetails'],
          );
          final userModel = PatientModel.fromJson(
            result['data']['profileDetails'],
          );
          final session = Get.find<SessionController>();
          session.setUser(userModel);
        }
      } catch (e) {
        print('SignIn token save warning: $e');
      }

      return result;
    } else {
      throw Exception(
        "Failed to sign in: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('SignInWithCredentials Error: $e');
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
    print('OTP: $otp, SessionId: $sessionId, MobileNumber: $phoneNumber');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "otp": otp,
        "sessionId": sessionId,
        "verifyFor": "createAbha",
        "mobileNumber": phoneNumber,
      }),
    );

    print('VerifyOtpforAadhaarNumber Response Status: ${response.statusCode}');
    print('VerifyOtpforAadhaarNumber Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Check if OTP verification actually succeeded by examining the message
      String message = result['message'] ?? '';
      if (message.toLowerCase().contains('invalid') ||
          message.toLowerCase().contains('incorrect') ||
          message.toLowerCase().contains('expired')) {
        throw Exception(message);
      }

      // Extract and save sessionId from response
      try {
        // Try to get sessionId from data object first, then from root
        String? extractedSessionId;
        if (result['data'] != null && result['data'] is Map) {
          final data = result['data'] as Map<String, dynamic>;
          extractedSessionId = data['sessionId']?.toString();
        }

        // If not found in data, check root level
        if (extractedSessionId == null || extractedSessionId.isEmpty) {
          extractedSessionId = result['sessionId']?.toString();
        }

        // Save to global variable if found
        if (extractedSessionId != null && extractedSessionId.isNotEmpty) {
          sessionId = extractedSessionId;
          print('Session ID saved from verify OTP: $sessionId');
        }
      } catch (e) {
        print('VerifyOtpforAadhaarNumber sessionId save warning: $e');
      }

      return result;
    } else {
      throw Exception(
        "Failed to verify OTP: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('VerifyOtpforAadhaarNumber Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> verifyOtpForUpdateMobileApi(
  String otp,
  String sessionId,
) async {
  try {
    final url = baseUrl + verifyOtp;
    print('VerifyOtpForUpdateMobile API URL: $url');
    print('OTP: $otp, SessionId: $sessionId');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "otp": otp,
        "sessionId": sessionId,
        "verifyFor": "updateMobile",
      }),
    );

    print('VerifyOtpForUpdateMobile Response Status: ${response.statusCode}');
    print('VerifyOtpForUpdateMobile Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Check if OTP verification actually succeeded by examining the message
      String message = result['message'] ?? '';
      if (message.toLowerCase().contains('invalid') ||
          message.toLowerCase().contains('incorrect') ||
          message.toLowerCase().contains('expired')) {
        throw Exception(message);
      }

      // Extract and save sessionId from response
      try {
        // Try to get sessionId from data object first, then from root
        String? extractedSessionId;
        if (result['data'] != null && result['data'] is Map) {
          final data = result['data'] as Map<String, dynamic>;
          extractedSessionId = data['sessionId']?.toString();
        }

        // If not found in data, check root level
        if (extractedSessionId == null || extractedSessionId.isEmpty) {
          extractedSessionId = result['sessionId']?.toString();
        }

        // Save to global variable if found
        if (extractedSessionId != null && extractedSessionId.isNotEmpty) {
          sessionId = extractedSessionId;
          print(
            'Session ID saved from verify OTP for updateMobile: $sessionId',
          );
        }
      } catch (e) {
        print('VerifyOtpForUpdateMobile sessionId save warning: $e');
      }

      return result;
    } else {
      throw Exception(
        "Failed to verify OTP: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('VerifyOtpForUpdateMobile Error: $e');
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
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({
        "abhaNumber": abhaNumber,
        "sessionId": sessionId,
        "signInWith": "abhaMobile",
      }),
    );

    print('SelectAccount Response Status: ${response.statusCode}');
    print('SelectAccount Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('SelectAccount Response: $result');
      print('Profile Details: ${result['data']['profileDetails']}');
      await SharedPrefLocalization().saveUserInfo(
        result['data']['profileDetails'],
      );
      final userModel = PatientModel.fromJson(result['data']['profileDetails']);
      final session = Get.find<SessionController>();
      session.setUser(userModel);

      return result;
    } else {
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
  try {
    final url = baseUrl + createAbhaNumber;
    print('CreateAbhaNumber API URL: $url');
    print(
      'Aadhaar Number: ${adharNumber.substring(0, 4)}****${adharNumber.substring(8)}',
    );

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"aadhaarNumber": adharNumber}),
    );

    print('CreateAbhaNumber Response Status: ${response.statusCode}');
    print('CreateAbhaNumber Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
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
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"abhaAddress": abhaAddress, "sessionId": sessionId}),
    );

    print('CreateAbhaAddress Response Status: ${response.statusCode}');
    print('CreateAbhaAddress Response Body: ${response.body}');

    final result = jsonDecode(response.body);
    print('CreateAbhaAddress Result: $result');
    await SharedPrefLocalization().saveUserInfo(
      result['data']['profileDetails'],
    );
    final userModel = PatientModel.fromJson(result['data']['profileDetails']);
    final session = Get.find<SessionController>();
    session.setUser(userModel);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(
        "Failed to create ABHA address: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('CreateAbhaAddress Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> addMeToCommunityApi(
  List<String> communityIds,
  String uniqueCode,
) async {
  try {
    final url = baseUrl + addMeTOCommunity;
    print('AddMeToCommunity API URL: $url');
    print('AccessToken: $accessToken');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Authorization": "Bearer $accessToken",
        "Content-Type": "application/json",
      },
      body: jsonEncode({
        "communityIds": communityIds,
        "uniqueCode": uniqueCode,
      }),
    );

    print('AddMeToCommunity Response Status: ${response.statusCode}');
    print('AddMeToCommunity Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print('AddMeToCommunity Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> getChatHistory({
  int page = 1,
  int limit = 10,
}) async {
  final url = baseUrl + getAllMessagesApi(page: page, limit: limit);
  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {'Authorization': 'Bearer $accessToken'},
    );

    return jsonDecode(response.body);
  } catch (e) {
    print('Error getting chat history: $e');
    return {'success': false, 'message': 'Failed to get chat history: $e'};
  }
}

Future<Map<String, dynamic>> sendMessage({
  required String conversationId,
  required String content,
  required String targetLanguage,
  File? file,
  String? fileType, // pass 'document' or 'audio'
  String? transcript,
  String? fileName,
  String? fileUrl,
}) async {
  try {
    print("$chatApi if chatApi is called");
    final url = baseUrl + chatApi;

    // If file is provided, use multipart/form-data
    if (file != null && fileType != null) {
      if (fileType == 'audio') {
        print("object");
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $accessToken';
        request.fields['conversationId'] = conversationId;
        request.fields['content'] = content; // Send text field content
        request.fields['targetLanguage'] = targetLanguage;
        request.fields['fileType'] = fileType;
        request.fields['audioTranscript'] =
            transcript ?? ''; // Send original transcript
        request.fields['senderType'] = 'patient';
        // Use fileUrl from transcription response if available, otherwise use empty string
        // Don't use 'cc' as it causes ExoPlayer errors
        request.fields['fileUrl'] = fileUrl ?? '';
        request.fields['fileName'] = fileName ?? file.path.split('/').last;
        // Send WAV file with correct content type
        // request.files.add(
        //   await http.MultipartFile.fromPath(
        //     'file',
        //     file.path,
        //     filename: file.path
        //         .split('/')
        //         .last, // Ensure .wav extension in filename
        //   ),
        // );
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
        print('SendMessage Response Status: ${response.statusCode}');
        print('SendMessage Response Body: ${response.body}');
        return jsonDecode(response.body);
      } else if (fileType == 'document') {
        var request = http.MultipartRequest('POST', Uri.parse(url));

        // Add headers
        request.headers['Authorization'] = 'Bearer $accessToken';

        // Add text fields
        request.fields['conversationId'] = conversationId;
        request.fields['content'] = content;
        request.fields['targetLanguage'] = targetLanguage;
        request.fields['senderType'] = 'patient';
        request.fields['fileType'] = fileType; // use the provided type
        request.fields['caption'] = content;

        // Add file
        request.files.add(await http.MultipartFile.fromPath('file', file.path));

        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);

        return jsonDecode(response.body);
      } else {
        // Unsupported file type
        throw Exception(
          'Unsupported file type: $fileType. Only "audio" and "document" are supported.',
        );
      }
    } else {
      // No file, use regular JSON
      final Map<String, dynamic> body = {
        'conversationId': conversationId,
        'content': content,
        'targetLanguage': targetLanguage,
        'senderType': 'patient',
      };

      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $accessToken',
        },
        body: jsonEncode(body),
      );
      print('SendMessage Response Status: ${response.statusCode}');
      print('SendMessage Response Body: ${response.body}');
      return jsonDecode(response.body);
    }
  } catch (e) {
    print('Error sending message: $e');
    throw Exception('Failed to send message: $e');
  }
}

Future<Map<String, dynamic>> getGroupInfo({
  required String groupId,
  required String uniqueCode,
  String? language,
}) async {
  try {
    final url = baseUrl + getGroupInfoApi(groupId, uniqueCode, language);
    print('GetGroupInfo API URL: $url');
    print('GroupId: $groupId, UniqueCode: $uniqueCode, Language: $language');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print('GetGroupInfo Response Status: ${response.statusCode}');
    print('GetGroupInfo Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(
        "Failed to get group info: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('GetGroupInfo Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> joinGroupApi({
  required String groupId,
  required List<Map<String, dynamic>> users,
  String uniqueCode = "",
}) async {
  try {
    final url = baseUrl + addMemberToGroup;
    print('JoinGroup API URL: $url');
    print('GroupId: $groupId, UniqueCode: $uniqueCode');

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "groupId": groupId,
        "users": users,
        "uniqueCode": uniqueCode,
      }),
    );

    print('JoinGroup Response Status: ${response.statusCode}');
    print('JoinGroup Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(
        "Failed to join group: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('JoinGroup Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> getCommunity(String groupId) async {
  try {
    final url = baseUrl + getCommunityApi(groupId);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    final result = jsonDecode(response.body);
    if (response.statusCode == 200) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print("Error getting community: $e");
    throw Exception("Error getting community: $e");
  }
}

Future<Map<String, dynamic>> sendVerificationLinkApi(
  String email,
  String sessionId,
) async {
  try {
    final url = baseUrl + sendVerificationLink;
    print('SendVerificationLink API URL: $url');
    print('Email: $email, SessionId: $sessionId');

    final response = await http.post(
      Uri.parse(url),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({"sessionId": sessionId, "email": email}),
    );

    print('SendVerificationLink Response Status: ${response.statusCode}');
    print('SendVerificationLink Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    // Note: This API does NOT update sessionId - it only uses the existing one
    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print("Error sending verification link: $e");
    throw Exception("Error sending verification link: $e");
  }
}

Future<Map<String, dynamic>> getAbhaAddressSuggestionsApi(
  String sessionId,
) async {
  try {
    final url = baseUrl + abhaAddressSuggestions(sessionId);
    print('GetAbhaAddressSuggestions API URL: $url');
    print('SessionId: $sessionId');

    final response = await http.get(
      Uri.parse(url),
      headers: {"Content-Type": "application/json"},
    );

    print('GetAbhaAddressSuggestions Response Status: ${response.statusCode}');
    print('GetAbhaAddressSuggestions Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print("Abha address suggestions: $result");
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print("Error getting abha address suggestions: $e");
    throw Exception("Error getting abha address suggestions: $e");
  }
}

Future<Map<String, dynamic>> updateFcmTokenApi(String fcmToken) async {
  try {
    final url = baseUrl + updateFcmToken;
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"fcmToken": fcmToken}),
    );

    print("FCM Token Update Response Status: ${response.statusCode}");
    print("FCM Token Update Response Body: ${response.body}");

    if (response.statusCode == 200 || response.statusCode == 201) {
      // Handle empty response body
      if (response.body.isEmpty || response.body.trim().isEmpty) {
        return {"success": true, "message": "FCM token updated successfully"};
      }

      // Decode JSON only if body is not empty
      final result = jsonDecode(response.body) as Map<String, dynamic>;
      print("FCM Token Update Result: $result");
      return result;
    } else {
      // Try to parse error message if body exists
      Map<String, dynamic> errorResult = {};
      if (response.body.isNotEmpty && response.body.trim().isNotEmpty) {
        try {
          errorResult = jsonDecode(response.body) as Map<String, dynamic>;
        } catch (_) {
          // If parsing fails, use raw body as message
        }
      }
      throw Exception(
        errorResult['message']?.toString() ??
            'Failed to update FCM token. Status: ${response.statusCode}',
      );
    }
  } catch (e) {
    print("Error updating fcm token: $e");
    rethrow;
  }
}

Future<Map<String, dynamic>> getFormSessionsApi(
  String date,
  String status,
) async {
  try {
    final url = baseUrl + getFormSessions(date, status);
    print('GetFormSessions API URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print('GetFormSessions Response Status: ${response.statusCode}');
    print('GetFormSessions Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(
        "Failed to get form sessions: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('GetFormSessions Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> getFormQuestionApi(String sessionId) async {
  try {
    final url = baseUrl + getFormQuestion(sessionId);
    print('GetFormQuestion API URL: $url');
    print('SessionId: $sessionId');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print('GetFormQuestion Response Status: ${response.statusCode}');
    print('GetFormQuestion Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      // print('GetFormQuestion Result: ${result['data']['message']['content']}');
      return result;
    } else {
      throw Exception(
        "Failed to get form question: ${result['message'] ?? 'Unknown error'}",
      );
    }
  } catch (e) {
    print('GetFormQuestion Error: $e');
    throw Exception(e);
  }
}

class GoogleAuthService {
  static const String webClientId =
      '711750121236-bmqlvjppt3lo2i1lbvac15nod0br20ip.apps.googleusercontent.com';

  // ✅ Use instance (NEW API – 2024+)
  final GoogleSignIn _googleSignIn = GoogleSignIn.instance;

  bool _isInitialized = false;

  /// Initialize Google Sign-In (MUST be called before using signIn)
  /// Call this once, usually in initState() or service constructor
  Future<void> init() async {
    if (_isInitialized) {
      print('✅ Google Sign-In already initialized');
      return;
    }

    try {
      print('🔵 Initializing Google Sign-In...');
      await _googleSignIn.initialize(
        serverClientId:
            '696005027039-20h7slaanur8amspfheva3736v05muoo.apps.googleusercontent.com',
        clientId:
            '696005027039-9cmiabdb89k15ha939spadfkdl6e5sq8.apps.googleusercontent.com',
      );

      _isInitialized = true;
      print('✅ Google Sign-In initialized successfully');
    } catch (e) {
      print('❌ Failed to initialize Google Sign-In: $e');
      rethrow;
    }
  }

  /// Main Google Login function
  /// Returns the backend response data on success, null if user cancelled
  Future<Map<String, dynamic>?> signInWithGoogle() async {
    try {
      // Ensure Google Sign-In is initialized
      if (!_isInitialized) {
        await init();
      }

      // 1️⃣ Open Google account picker
      print('🔵 Opening Google account picker...');
      final GoogleSignInAccount? account = await _googleSignIn.authenticate();

      if (account == null) {
        print('⚠️ User cancelled Google login');
        return null;
      }

      print('✅ Account selected: ${account.email}');

      // 2️⃣ Get ID token
      print('🔵 Requesting ID token...');
      final GoogleSignInAuthentication auth = await account.authentication;

      final String? idToken = auth.idToken;

      if (idToken == null) {
        throw Exception('ID Token is null - authentication failed');
      }

      print('✅ ID Token received successfully');

      // 3️⃣ Send token to backend
      final result = await _sendTokenToBackend(idToken);
      return result;
    } catch (e) {
      print('❌ Google login failed: $e');
      rethrow; // Re-throw to let caller handle the error
    }
  }

  /// Send ID token to backend API
  /// Returns the response data on success
  Future<Map<String, dynamic>> _sendTokenToBackend(String idToken) async {
    print('🔵 Sending ID token to backend...');

    final response = await http.post(
      Uri.parse('https://devbandhucareapis.revanai.in/v2/api/auth/google'),
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode({'idToken': idToken, 'userType': 'patient'}),
    );

    print('📡 Backend response status: ${response.statusCode}');

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print('✅ Backend login success');

      // Save user info to shared preferences
      if (result['data'] != null && result['data']['profileDetails'] != null) {
        await SharedPrefLocalization().saveUserInfo(
          result['data']['profileDetails'],
        );
        final userModel = PatientModel.fromJson(
          result['data']['profileDetails'],
        );
        final session = Get.find<SessionController>();
        session.setUser(userModel);

        print('✅ User info saved to local storage');
      }

      print('📦 Response data: $result');
      return result;
    } else {
      final errorBody = response.body;
      print('❌ Backend login failed: Status ${response.statusCode}');
      print('❌ Error response: $errorBody');
      throw Exception(
        'Backend login failed: ${response.statusCode} - $errorBody',
      );
    }
  }
}

Future<Map<String, dynamic>> getTranscriptionApi(
  String targetLanguage,
  File file,
) async {
  final url = baseUrl + getTranscription;
  try {
    final request = http.MultipartRequest('POST', Uri.parse(url));
    request.headers['Authorization'] = 'Bearer $accessToken';
    request.fields['targetLanguage'] = targetLanguage;

    request.files.add(
      await http.MultipartFile.fromPath(
        'file',
        file.path,
        filename: file.path.split('/').last,
      ),
    );
    final streamedResponse = await request.send();
    final response = await http.Response.fromStream(streamedResponse);
    final result = jsonDecode(response.body);
    print('Transcription Response Status: ${response.statusCode}');
    print('Transcription Response Body: ${response.body}');
    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Transcription Response: $result');
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print('Error getting transcription: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> getHospitalInformationApi(String language) async {
  final url = baseUrl + getHospitalInformation(language);

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print('Hospital Information Response: $result');
      return result['data']['hospitalInfo'];
    } else {
      final result = jsonDecode(response.body);
      print('Hospital Information Error: $result');
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print('Hospital Information Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> getUserGroupsApi() async {
  try {
    // Get language from SharedPreferences
    final prefs = SharedPrefLocalization();
    final savedLocale = await prefs.getAppLocale();
    final languageCode = savedLocale.isNotEmpty
        ? savedLocale
              .toLowerCase()
              .trim() // "hi_IN" -> "hi_in", "en_US" -> "en_us"
        : 'en_us'; // Default fallback to English

    print('═══════════════════════════════════════════════════════════');
    print('GetUserGroups - SharedPreferences Language:');
    print('  Original Locale: "$savedLocale"');
    print('  API Format: "$languageCode"');
    print('═══════════════════════════════════════════════════════════');

    final url = baseUrl + getUserGroups(languageCode);

    print('GetUserGroups API URL: $url');
    print('Language: $languageCode');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print('GetUserGroups Response Status: ${response.statusCode}');
    print('GetUserGroups Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print('GetUserGroups Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> likeMessageApi(String messageId) async {
  final url = baseUrl + likeMessage;
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"messageId": messageId}),
    );
    final result = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(result);

      return result is Map<String, dynamic>
          ? result
          : {'success': true, 'message': result.toString()};
    } else {
      throw Exception(
        result['message'] ?? result.toString() ?? 'Unknown error',
      );
    }
  } catch (e) {
    print('Error liking message: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> disLikeMessageApi(String messageId) async {
  final url = baseUrl + disLikeMessage;
  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({"messageId": messageId}),
    );
    final result = jsonDecode(response.body);
    if (response.statusCode == 200 || response.statusCode == 201) {
      print(result);
      return result is Map<String, dynamic>
          ? result
          : {'success': true, 'message': result.toString()};
    } else {
      throw Exception(
        result['message'] ?? result.toString() ?? 'Unknown error',
      );
    }
  } catch (e) {
    print('Error disliking message: $e');
    throw Exception(e);
  }
}

Future<List<Map<String, dynamic>>> getFormQuestionAnsApi(
  String sessionId,
) async {
  final url = baseUrl + getFormQuestionAns(sessionId);

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return List<Map<String, dynamic>>.from(
        result['data']['formSession']['questionScores'],
      );
    } else {
      throw Exception('Failed to get form question answers');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> getHomepageApi() async {
  try {
    final url = baseUrl + getHomepage;

    print('GetHomepage API URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print('GetHomepage Response Status: ${response.statusCode}');
    print('GetHomepage Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print('GetHomepage Error: $e');
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> editAnswerApi({
  required String sessionId,
  required String questionId,
  required String updatedAnswer,
}) async {
  try {
    final url = baseUrl + editAnswer;

    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
      body: jsonEncode({
        "sessionId": sessionId,
        "questionId": questionId,
        "response": updatedAnswer,
      }),
    );

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Failed to edit answer');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> switchGroupApi({String? groupId}) async {
  print('Switch Group API URL: $groupId');
  final url = baseUrl + switchGroup(groupId!);

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Switch Group Response :$result');
      return result;
    } else {
      Fluttertoast.showToast(
        msg: result['message'] ?? 'Unknown error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> updateProfileApi({
  String? name,
  File? image,
  String? gender,
  String? houseAddress,
  String? state,
  String? city,
}) async {
  try {
    final url = baseUrl + updateProfile;

    var request = http.MultipartRequest('POST', Uri.parse(url));
    print('Update Profile Request :$request');
    if (name != null) {
      request.fields['name'] = name;
    }
    if (gender != null) {
      request.fields['gender'] = gender;
    }
    if (houseAddress != null) {
      request.fields['address'] = houseAddress;
    }
    if (state != null) {
      request.fields['state'] = state;
    }
    if (city != null) {
      request.fields['city'] = city;
    }
    if (image != null && image.path.isNotEmpty) {
      print('object');
      final fileName = image.path.split('/').last;
      print('Update Profile - Adding image: $fileName');
      request.files.add(
        await http.MultipartFile.fromPath(
          'file',
          image.path,
          filename: fileName,
        ),
      );
    }

    request.headers.addAll({'Authorization': 'Bearer $accessToken'});
    final responseBody = await request.send();
    final response = await http.Response.fromStream(responseBody);

    final result = jsonDecode(response.body);

    print('Update Profile Response :$result');

    if (response.statusCode == 200 || response.statusCode == 201) {
      print('Update Profile Response :$result');
      Toastification().show(
        type: ToastificationType.success,
        title: Text("Profile Update Successfully"),
      );

      return result;
    } else {
      Fluttertoast.showToast(
        msg: result['message'] ?? 'Unknown error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
      );
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<StateModel>> getAllStatesApi() async {
  final url = baseUrl + getAllStates;

  try {
    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
    print("Get All States Response Status: ${response.statusCode}");
    if (response.statusCode == 200 || response.statusCode == 201) {
      final result = jsonDecode(response.body);
      print('States Response :$result');

      final List list = result['data']['states'];
      return list.map((e) => StateModel.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load states');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<List<CityModel>> getAllCitiesApi(String stateId) async {
  final url = baseUrl + getAllCities(stateId);
  try {
    print("StateCode is ${stateId}");
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'content-type': 'application/json',
        'Authorization': 'Bearer $accessToken',
      },
    );
    print(response.body);
    if (response.statusCode == 201 || response.statusCode == 200) {
      final result = jsonDecode(response.body);
      final List list = result['data']['cities'];
      return list.map((e) {
        return CityModel.fromJson(e);
      }).toList();
    } else {
      throw Exception('Failed to load states');
    }
  } catch (e) {
    throw Exception(e);
  }
}

Future<Map<String, dynamic>> getContentByIdApi(String contentId) async {
  try {
    final url = baseUrl + getContentById(contentId);

    print('GetContentById API URL: $url');

    final response = await http.get(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );

    print('GetContentById Response Status: ${response.statusCode}');
    print('GetContentById Response Body: ${response.body}');

    final result = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      return result;
    } else {
      throw Exception(result['message'] ?? 'Unknown error');
    }
  } catch (e) {
    print('GetContentById Error: $e');
    throw Exception(e);
  }
}
