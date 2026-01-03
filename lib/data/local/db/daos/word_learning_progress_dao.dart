import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/word_learning_progress.dart';
import '../tables/words_table.dart';

part 'word_learning_progress_dao.g.dart';

class LearningStats {
  final int total;
  final int learned;

  const LearningStats({required this.total, required this.learned});

  int get unlearned => total - learned;
}

@DriftAccessor(tables: [WordLearningProgress, Words])
class WordLearningProgressDao extends DatabaseAccessor<AppDatabase>
    with _$WordLearningProgressDaoMixin {
  WordLearningProgressDao(AppDatabase db) : super(db);

  Future<void> ensureRowForWord({
    required String wordId,
    required int createdAt,
    required int updatedAt,
  }) async {
    await into(wordLearningProgress).insert(
      WordLearningProgressCompanion.insert(
        wordId: wordId,
        createdAt: createdAt,
        updatedAt: updatedAt,
      ),
      mode: InsertMode.insertOrIgnore,
    );
  }

  Future<void> setLearned({
    required String wordId,
    required bool learned,
  }) async {
    final now = DateTime.now().millisecondsSinceEpoch;

    await (update(wordLearningProgress)..where((p) => p.wordId.equals(wordId)))
        .write(
      WordLearningProgressCompanion(
        learningStatus: Value(learned ? 'learned' : 'unlearned'),
        lastReviewedAt: Value(now),
        updatedAt: Value(now),
        correctCount: learned ? const Value(1) : const Value.absent(),
      ),
    );
  }

  /// Stats for All or Favorites, scoped to active language.
  Future<LearningStats> getStats({
    required String languageCode,
    required bool favoritesOnly,
  }) async {
    final totalQuery = select(words)
      ..where((w) => w.languageCode.equals(languageCode) & w.deletedAt.isNull());

    if (favoritesOnly) {
      totalQuery.where((w) => w.isFavorite.equals(true));
    }

    final total = (await totalQuery.get()).length;

    // Learned count via join
    final w = words; //.as('w');
    final p = wordLearningProgress;//.as('p');

    final joinQuery = selectOnly(w).join([
      innerJoin(p, p.wordId.equalsExp(w.id)),
    ])
      ..addColumns([w.id])
      ..where(w.languageCode.equals(languageCode) & w.deletedAt.isNull());

    if (favoritesOnly) {
      joinQuery.where(w.isFavorite.equals(true));
    }

    joinQuery.where(p.learningStatus.equals('learned'));

    final learnedRows = await joinQuery.get();
    final learned = learnedRows.length;

    return LearningStats(total: total, learned: learned);
  }

  /// Session word ids (All vs Favorites, All vs Unlearned)
  Future<List<String>> listWordIdsForSession({
    required String languageCode,
    required bool favoritesOnly,
    required bool unlearnedOnly,
  }) async {
    final w = words;
    final p = wordLearningProgress;

    final q = selectOnly(w).join([
      leftOuterJoin(p, p.wordId.equalsExp(w.id)),
    ])
      ..addColumns([w.id, p.learningStatus])
      ..where(w.languageCode.equals(languageCode) & w.deletedAt.isNull());

    if (favoritesOnly) {
      q.where(w.isFavorite.equals(true));
    }

    if (unlearnedOnly) {
      // Treat missing progress as unlearned too
      q.where(p.learningStatus.isNull() | p.learningStatus.equals('unlearned'));
    }

    q.orderBy([OrderingTerm.asc(w.wordText)]);

    final rows = await q.get();

    return rows.map((r) => r.read(w.id)!).toList();
  }
}
