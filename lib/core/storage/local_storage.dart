/*
 * ==============================================================================
 * [LocalStorage] - Bộ Lưu Trữ Dữ Liệu Cục Bộ (SharedPreferences)
 * ==============================================================================
 */

import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../utils/logger.dart';

abstract class ILocalStorage {
  Future<bool> setString(String key, String value);
  String? getString(String key);
  Future<bool> setBool(String key, bool value);
  bool? getBool(String key);
  Future<bool> setInt(String key, int value);
  int? getInt(String key);
  Future<bool> setObject(String key, Map<String, dynamic> jsonMap);
  Map<String, dynamic>? getObject(String key);
  Future<bool> remove(String key);
  Future<bool> clear();

  // Common UI Preferences
  Future<bool> setThemeMode(String themeMode);
  String getThemeMode();
  Future<bool> setLanguageCode(String code);
  String getLanguageCode();
  Future<bool> setIsFirstInstall(bool isFirst);
  bool isFirstInstall();
}

class LocalStorageImpl implements ILocalStorage {
  static const String _keyThemeMode = 'THEME_MODE';
  static const String _keyLanguageCode = 'LANGUAGE_CODE';
  static const String _keyIsFirstInstall = 'IS_FIRST_INSTALL';

  final SharedPreferences _prefs;

  LocalStorageImpl({required SharedPreferences prefs}) : _prefs = prefs;

  @override
  Future<bool> setString(String key, String value) =>
      _prefs.setString(key, value);

  @override
  String? getString(String key) => _prefs.getString(key);

  @override
  Future<bool> setBool(String key, bool value) => _prefs.setBool(key, value);

  @override
  bool? getBool(String key) => _prefs.getBool(key);

  @override
  Future<bool> setInt(String key, int value) => _prefs.setInt(key, value);

  @override
  int? getInt(String key) => _prefs.getInt(key);

  @override
  Future<bool> setObject(String key, Map<String, dynamic> jsonMap) {
    return _prefs.setString(key, jsonEncode(jsonMap));
  }

  @override
  Map<String, dynamic>? getObject(String key) {
    final str = _prefs.getString(key);
    if (str == null || str.isEmpty) return null;
    try {
      final decoded = jsonDecode(str);
      if (decoded is Map) {
        return Map<String, dynamic>.from(decoded);
      }
      return null;
    } catch (e) {
      AppLogger.w('Lỗi giải mã object từ SharedPreferences với key "$key": $e');
      return null;
    }
  }

  @override
  Future<bool> remove(String key) => _prefs.remove(key);

  @override
  Future<bool> clear() => _prefs.clear();

  @override
  Future<bool> setThemeMode(String themeMode) =>
      setString(_keyThemeMode, themeMode);

  @override
  String getThemeMode() => getString(_keyThemeMode) ?? 'system';

  @override
  Future<bool> setLanguageCode(String code) =>
      setString(_keyLanguageCode, code);

  @override
  String getLanguageCode() => getString(_keyLanguageCode) ?? 'vi';

  @override
  Future<bool> setIsFirstInstall(bool isFirst) =>
      setBool(_keyIsFirstInstall, isFirst);

  @override
  bool isFirstInstall() => getBool(_keyIsFirstInstall) ?? true;
}
