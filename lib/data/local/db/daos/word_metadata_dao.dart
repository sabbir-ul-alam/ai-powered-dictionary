import 'package:drift/drift.dart';
import '../app_database.dart';
import '../tables/word_metadata_table.dart';

part 'word_metadata_dao.g.dart';

@DriftAccessor(tables: [WordMetadata])
class WordMetadataDao extends DatabaseAccessor<AppDatabase>
    with _$WordMetadataDaoMixin {
  WordMetadataDao(AppDatabase db) : super(db);

  Future<void> upsertMetadata(WordMetadataCompanion data) =>
      into(wordMetadata).insertOnConflictUpdate(data);

  Future<WordMetadataData?> getByWordId(String wordId) {
    return (select(wordMetadata)
        ..where((m) => m.wordId.equals(wordId)))
          .getSingleOrNull();
  }


///Test
  Future<void> upsertMetadataForWord({
    required String wordId,
    required String metadataJson,
  }) async {
    final existing = await (select(wordMetadata)
      ..where((m) => m.wordId.equals(wordId)))
        .getSingleOrNull();

    if (existing != null) {
      await (update(wordMetadata)
        ..where((m) => m.wordId.equals(wordId)))
          .write(
        WordMetadataCompanion(
          metadataJson: Value(metadataJson),
          updatedAt: Value(DateTime.now().millisecondsSinceEpoch),
        ),
      );
    } else {
      await into(wordMetadata).insert(
        WordMetadataCompanion.insert(
          source: 'USER',
          version: 1,
          wordId: wordId,
          metadataJson: metadataJson,
          updatedAt: DateTime.now().millisecondsSinceEpoch,
        ),
      );
    }
  }


}
