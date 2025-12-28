import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/words_table.dart';

part 'words_dao.g.dart';

@DriftAccessor(tables: [Words])
class WordsDao extends DatabaseAccessor<AppDatabase> with _$WordsDaoMixin {
  WordsDao(AppDatabase db) : super(db);

  /// -------------------------------------------------------------------------
  /// INSERT OR REVIVE WORD
  /// -------------------------------------------------------------------------
  ///
  /// If a word exists but is soft-deleted, revive it instead of inserting.
  ///
  Future<void> insertOrReviveWord(WordsCompanion word) async {
    final existing = await (select(words)
      ..where((w) =>
      w.languageCode.equals(word.languageCode.value) &
      w.wordText.equals(word.wordText.value)))
        .getSingleOrNull();

    if (existing != null) {
      // Revive soft-deleted word
      await (update(words)..where((w) => w.id.equals(existing.id))).write(
        WordsCompanion(
          deletedAt: const Value(null),
          updatedAt: Value(word.updatedAt.value),
        ),
      );
    } else {
      // Fresh insert
      await into(words).insert(word);
    }
  }

  // Future<void> insertWord(WordsCompanion word) => into(words).insert(word);

  Future<void> updateWord(WordsCompanion word) => update(words).replace(word);

  Future<void> softDeleteWord(String id, int deletedAt) =>
      (update(words)..where((w) => w.id.equals(id))).write(
        WordsCompanion(
          deletedAt: Value(deletedAt),
          updatedAt: Value(deletedAt),
        ),
      );

  Future<List<Word>> listWords(
      String languageCode, {
        int limit = 200,
        int offset = 0,
      }) =>
      (select(words)
        ..where((w) =>
        w.languageCode.equals(languageCode) & w.deletedAt.isNull())
        ..orderBy([(w) => OrderingTerm.desc(w.updatedAt)])
        ..limit(limit, offset: offset))
          .get();

  /// Prefix suggestions for AddWordScreen
  Future<List<String>> suggestWords(
      String languageCode,
      String prefix, {
        int limit = 10,
      }) =>
      (select(words)
        ..where((w) =>
        w.languageCode.equals(languageCode) &
        w.deletedAt.isNull() &
        w.wordText.like('$prefix%'))
        ..orderBy([(w) => OrderingTerm.asc(w.wordText)])
        ..limit(limit))
          .map((row) => row.wordText)
          .get();

  /// -------------------------------------------------------------------------
  /// REAL CONTAINS SEARCH (NEW)
  /// -------------------------------------------------------------------------
  ///
  /// Returns Word objects (id included) so UI can open WordDetailScreen.
  /// Uses LIKE '%query%' for "contains" matching.
  ///
  Future<List<Word>> searchWords(
      String languageCode,
      String query, {
        int limit = 200,
      }) {
    final q = query.trim();

    // Guard: if query is empty, return nothing (UI will show full list instead)
    if (q.isEmpty) {
      return Future.value(const <Word>[]);
    }

    final pattern = '%$q%';

    return (select(words)
      ..where((w) =>
      w.languageCode.equals(languageCode) &
      w.deletedAt.isNull() &
      w.wordText.like(pattern))
      ..orderBy([(w) => OrderingTerm.asc(w.wordText)])
      ..limit(limit))
        .get();
  }

  Future<int> countWords(String languageCode) async {
    // For large data sets, prefer a COUNT(*) query. This is fine for Phase 1.
    final result = await (select(words)
      ..where((w) =>
      w.languageCode.equals(languageCode) & w.deletedAt.isNull()))
        .get();
    return result.length;
  }
}
