import 'package:drift/drift.dart';

class Words extends Table {
  TextColumn get id => text()();

  TextColumn get wordText =>
      text().named('word_text')();

  TextColumn get languageCode =>
      text().named('language_code')();

  TextColumn get shortMeaning =>
      text().named('short_meaning').nullable()();

  TextColumn get partsOfSpeech =>
      text().named('parts_of_speech').nullable()();

  IntColumn get createdAt =>
      integer().named('created_at')();

  IntColumn get updatedAt =>
      integer().named('updated_at')();

  IntColumn get deletedAt =>
      integer().named('deleted_at').nullable()();

  // NEW: favourite flag
  BoolColumn get isFavorite =>
      boolean().withDefault(const Constant(false))();

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => [
    'UNIQUE(language_code, word_text)'
  ];
}
