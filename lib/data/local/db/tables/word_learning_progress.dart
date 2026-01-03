import 'package:drift/drift.dart';


class WordLearningProgress extends Table {
  TextColumn get wordId => text()(); // PK, also FK logically to Words.id

  /// 'unlearned' | 'learned'
  TextColumn get learningStatus =>
      text().withDefault(const Constant('unlearned'))();

  IntColumn get correctCount => integer().withDefault(const Constant(0))();
  IntColumn get incorrectCount => integer().withDefault(const Constant(0))();

  IntColumn get lastReviewedAt => integer().nullable()();

  IntColumn get createdAt => integer()();
  IntColumn get updatedAt => integer()();

  @override
  Set<Column> get primaryKey => {wordId};
}