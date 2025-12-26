import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/languages_table.dart';

part 'languages_dao.g.dart';

@DriftAccessor(tables: [Languages])
class LanguagesDao extends DatabaseAccessor<AppDatabase>
    with _$LanguagesDaoMixin {
  LanguagesDao(AppDatabase db) : super(db);

  Future<void> upsertLanguage(LanguagesCompanion lang) =>
      into(languages).insertOnConflictUpdate(lang);

  Future<List<Language>> listLanguages() =>
      select(languages).get();
}
