import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/words_table.dart';

part 'words_dao.g.dart';

@DriftAccessor(tables: [Words])
class WordsDao extends DatabaseAccessor<AppDatabase>
    with _$WordsDaoMixin {
  //   WordsDao(AppDatabase db) : super(db);
  WordsDao(super.db);


  Future<void> insertWord(WordsCompanion word) =>
      into(words).insert(word);

  Future<void> updateWord(WordsCompanion word) =>
      update(words).replace(word);

  Future<void> softDeleteWord(String id, int deletedAt) =>
      (update(words)..where((w) => w.id.equals(id)))
          .write(WordsCompanion(
        deletedAt: Value(deletedAt),
        updatedAt: Value(deletedAt),
      ));

  Future<List<Word>> listWords(String languageCode) =>
      (select(words)
        ..where((w) =>
        w.languageCode.equals(languageCode) &
        w.deletedAt.isNull())
        ..orderBy([
              (w) => OrderingTerm.desc(w.updatedAt),
        ]))
          .get();

  Future<List<String>> suggestWords(
      String languageCode,
      String prefix,
      ) =>
      (select(words)
        ..where((w) =>
        w.languageCode.equals(languageCode) &
        w.deletedAt.isNull() &
        w.wordText.like('$prefix%'))
        ..limit(10))
          .map((row) => row.wordText)
          .get();

  Future<int> countWords(String languageCode) async {
    final result = await (select(words)
      ..where((w) =>
      w.languageCode.equals(languageCode) &
      w.deletedAt.isNull()))
        .get();
    return result.length;
  }
}
