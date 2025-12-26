// import 'package:shared_preferences/shared_preferences.dart';

import 'package:shared_preferences/shared_preferences.dart';


class PreferencesRepository {
  static const _activeLanguageKey = 'active_language';

  Future<void> setActiveLanguage(String code) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_activeLanguageKey, code);
  }

  Future<String?> getActiveLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_activeLanguageKey);
  }
}
