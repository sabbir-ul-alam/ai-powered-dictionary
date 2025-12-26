import 'dart:io';
import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:path_provider/path_provider.dart';

import 'tables/words_table.dart';
import 'tables/languages_table.dart';
import 'tables/word_metadata_table.dart';

part 'app_database.g.dart';

@DriftDatabase(
  tables: [
    Words,
    Languages,
    WordMetadata,
  ],
)
class AppDatabase extends _$AppDatabase {
  // AppDatabase() : super(_openConnection());
  AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());

  @override
  int get schemaVersion => 1;

// LazyDatabase _openConnection() {
//   return LazyDatabase(() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final file = File('${dir.path}/dictionary.db');
//     return NativeDatabase(file);
//   });
// }
  static QueryExecutor _openConnection() {
    return driftDatabase(
      name: 'my_database',
      native: const DriftNativeOptions(
// By default, `driftDatabase` from `package:drift_flutter` stores the
// database files in `getApplicationDocumentsDirectory()`.
        databaseDirectory: getApplicationSupportDirectory,
      ),
// If you need web support, see https://drift.simonbinder.eu/platforms/web/
    );
  }
}
