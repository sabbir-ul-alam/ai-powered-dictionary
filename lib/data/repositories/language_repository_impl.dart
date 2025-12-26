import '../../domain/repositories/language_repository.dart';
import '../local/db/app_database.dart';
import '../local/db/daos/languages_dao.dart';
import '../preferences/preferences_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LanguageRepositoryImpl implements LanguageRepository {
  final LanguagesDao languagesDao;
  final PreferencesRepository preferences;

  LanguageRepositoryImpl(this.languagesDao, this.preferences);

  @override
  Future<List<Language>> listLanguages() {
    return languagesDao.listLanguages();
  }

  @override
  Future<void> setActiveLanguage(String code) async {
    // Ensure language exists
    await languagesDao.upsertLanguage(
      LanguagesCompanion.insert(
        code: code,
        displayName: code, // replace later with mapping
        createdAt: DateTime.now().millisecondsSinceEpoch,
      ),
    );

    await preferences.setActiveLanguage(code);
  }

  @override
  Future<Language?> getActiveLanguage() async {
    final code = await preferences.getActiveLanguage();
    if (code == null) return null;
    return languagesDao.getLanguage(code);
  }
}
