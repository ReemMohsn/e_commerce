import 'dart:convert';

import 'package:e_commeric/core/constants/shared_preferences_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SharedPreferencesService {
  SharedPreferencesService({SharedPreferencesAsync? preferences})
    : _preferences = preferences ?? SharedPreferencesAsync();

  final SharedPreferencesAsync _preferences;

  Future<bool> get isLoggedIn async =>
      await _preferences.getBool(SharedPreferencesKeys.isLoggedIn) ?? false;

  Future<String?> get accessToken =>
      _preferences.getString(SharedPreferencesKeys.accessToken);

  Future<Map<String, dynamic>?> get profile async {
    final value = await _preferences.getString(SharedPreferencesKeys.profile);
    if (value == null || value.isEmpty) return null;

    try {
      final decoded = jsonDecode(value);
      if (decoded is Map) return Map<String, dynamic>.from(decoded);
    } on FormatException {
      await _preferences.remove(SharedPreferencesKeys.profile);
    }
    return null;
  }

  Future<void> saveSession({
    String? token,
    Map<String, dynamic>? profile,
  }) async {
    if (token != null && token.isNotEmpty) {
      await _preferences.setString(SharedPreferencesKeys.accessToken, token);
    }
    if (profile != null && profile.isNotEmpty) {
      await _preferences.setString(
        SharedPreferencesKeys.profile,
        jsonEncode(profile),
      );
    }
    await _preferences.setBool(SharedPreferencesKeys.isLoggedIn, true);
  }

  Future<void> clearSession() async {
    await _preferences.remove(SharedPreferencesKeys.accessToken);
    await _preferences.remove(SharedPreferencesKeys.profile);
    await _preferences.setBool(SharedPreferencesKeys.isLoggedIn, false);
  }

  Future<bool> get isOnboardingCompleted async =>
      await _preferences.getBool(SharedPreferencesKeys.onboardingCompleted) ??
      false;

  Future<void> setOnboardingCompleted() =>
      _preferences.setBool(SharedPreferencesKeys.onboardingCompleted, true);

  Future<void> setResetEmail(String email) =>
      _preferences.setString(SharedPreferencesKeys.resetEmail, email);

  Future<String?> get resetEmail =>
      _preferences.getString(SharedPreferencesKeys.resetEmail);

  Future<void> removeResetData() async {
    await _preferences.remove(SharedPreferencesKeys.resetEmail);
    await _preferences.remove(SharedPreferencesKeys.otpCode);
  }

  Future<void> setString(String key, String value) =>
      _preferences.setString(key, value);

  Future<String?> getString(String key) => _preferences.getString(key);

  Future<void> setBool(String key, bool value) =>
      _preferences.setBool(key, value);

  Future<bool?> getBool(String key) => _preferences.getBool(key);

  Future<void> remove(String key) => _preferences.remove(key);

  Future<void> clear() => _preferences.clear();
}
