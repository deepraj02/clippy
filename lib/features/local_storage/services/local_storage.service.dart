import 'package:shared_preferences/shared_preferences.dart';

abstract interface class LocalStorage {
  static const String languageKey = "language";
  static const String themeKey = "theme";
  Future<void> init();
  String? getString(String key);
  Future<bool> setString(String key, value);
  bool? getBool(String key);
  Future<bool> setBool(String key, bool value);
  int? getInt(String key);
  Future<bool> setInt(String key, int value);
}

class LocalStorageService implements LocalStorage {
  static late SharedPreferences _prefs;

  @override
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  @override
  String? getString(String key) {
    return _prefs.getString(key);
  }

  @override
  Future<bool> setString(String key, value) async {
    return await _prefs.setString(key, value);
  }

  @override
  bool? getBool(String key) {
    return _prefs.getBool(key);
  }

  @override
  Future<bool> setBool(String key, bool value) async {
    return await _prefs.setBool(key, value);
  }

  @override
  int? getInt(String key) {
    return _prefs.getInt(key);
  }

  @override
  Future<bool> setInt(String key, int value) async {
    return await _prefs.setInt(key, value);
  }
}
