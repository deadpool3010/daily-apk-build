import 'dart:convert';
import 'dart:io';

import 'package:bandhucare_new/services/variables.dart';
import 'package:bandhucare_new/core/network/api_constant.dart';
import 'package:bandhucare_new/services/shared_pref_localization.dart';
import 'package:http/http.dart' as http;

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
          await SharedPrefLocalization().saveUserInfo(dataMap);
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
          await SharedPrefLocalization().saveUserInfo(dataMap);
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
  final url = baseUrl + getMessagesApi(page: page, limit: limit);
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
}) async {
  try {
    final url = baseUrl + chatApi;

    // If file is provided, use multipart/form-data
    if (file != null && fileType != null) {
      if (fileType == 'audio') {
        var request = http.MultipartRequest('POST', Uri.parse(url));
        request.headers['Authorization'] = 'Bearer $accessToken';
        request.fields['conversationId'] = conversationId;
        request.fields['targetLanguage'] = targetLanguage;
        request.fields['fileType'] = fileType;
        request.fields['senderType'] = 'patient';
        // Send WAV file with correct content type
        request.files.add(
          await http.MultipartFile.fromPath(
            'file',
            file.path,
            filename: file.path
                .split('/')
                .last, // Ensure .wav extension in filename
          ),
        );
        final streamedResponse = await request.send();
        final response = await http.Response.fromStream(streamedResponse);
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

      return jsonDecode(response.body);
    }
  } catch (e) {
    print('Error sending message: $e');
    throw Exception('Failed to send message: $e');
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
