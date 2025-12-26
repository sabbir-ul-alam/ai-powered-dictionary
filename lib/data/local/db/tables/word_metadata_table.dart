import 'package:drift/drift.dart';
import 'words_table.dart';

class WordMetadata extends Table {
  TextColumn get wordId =>
      text().named('word_id')
          .references(Words, #id, onDelete: KeyAction.cascade)();

  TextColumn get metadataJson =>
      text().named('metadata_json')();

  TextColumn get source =>
      text()(); // AI | USER | SYSTEM

  IntColumn get version =>
      integer()();

  IntColumn get updatedAt =>
      integer().named('updated_at')();

  @override
  Set<Column> get primaryKey => {wordId};
}
