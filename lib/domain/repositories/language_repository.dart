import '../../data/local/db/app_database.dart';

abstract class LanguageRepository {
  Future<List<Language>> listLanguages();

  Future<void> setActiveLanguage(String code);

  Future<Language?> getActiveLanguage();
}
