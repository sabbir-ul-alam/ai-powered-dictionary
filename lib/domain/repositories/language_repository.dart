import '../../data/local/db/app_database.dart';

abstract class LanguageRepository {
  Future<List<Language>> listLanguages();

  Future<void> setActiveLanguage(Language lang);

  Future<Language?> getActiveLanguage();
}
