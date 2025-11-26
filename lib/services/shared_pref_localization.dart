import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

class SharedPrefLocalization {
  Future<void> saveTokens(String accessToken, String refreshToken) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('accessToken', accessToken);
    prefs.setString('refreshToken', refreshToken);
  }

  Future<void> saveUserInfo(Map<String, dynamic> userData) async {
    final prefs = await SharedPreferences.getInstance();
    final json = jsonEncode(userData);
    prefs.setString('userData', json);
  }

  Future<Map<String, String>> getTokens() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      'accessToken': prefs.getString('accessToken') ?? '',
      'refreshToken': prefs.getString('refreshToken') ?? '',
    };
  }

  Future<String> getUserInfo() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('userData') ?? 'Nothing found';
  }

  Future<Map<String, dynamic>?> getUserInfoMap() async {
    final raw = await getUserInfo();
    if (raw.isEmpty || raw == 'Nothing found') return null;
    try {
      return jsonDecode(raw) as Map<String, dynamic>;
    } catch (_) {
      return null;
    }
  }

  Future<bool> hasPersistedUser() async {
    final tokens = await getTokens();
    final userInfo = await getUserInfo();
    final hasTokens = (tokens['accessToken'] ?? '').isNotEmpty;
    final hasUserInfo = userInfo.isNotEmpty && userInfo != 'Nothing found';
    return hasTokens && hasUserInfo;
  }
}
