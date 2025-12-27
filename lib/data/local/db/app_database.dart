// import 'dart:io';
// import 'package:drift/drift.dart';
// import 'package:drift_flutter/drift_flutter.dart';
// import 'package:path_provider/path_provider.dart';
//
// import 'tables/words_table.dart';
// import 'tables/languages_table.dart';
// import 'tables/word_metadata_table.dart';
//
// part 'app_database.g.dart';
//
// @DriftDatabase(
//   tables: [
//     Words,
//     Languages,
//     WordMetadata,
//   ],
// )
// class AppDatabase extends _$AppDatabase {
//   // AppDatabase() : super(_openConnection());
//   AppDatabase([QueryExecutor? executor]) : super(executor ?? _openConnection());
//
//   @override
//   int get schemaVersion => 1;
//
// // LazyDatabase _openConnection() {
// //   return LazyDatabase(() async {
// //     final dir = await getApplicationDocumentsDirectory();
// //     final file = File('${dir.path}/dictionary.db');
// //     return NativeDatabase(file);
// //   });
// // }
//
//
//
//
//
//
//
//   static QueryExecutor _openConnection() {
//     return driftDatabase(
//       name: 'my_database',
//       native: const DriftNativeOptions(
// // By default, `driftDatabase` from `package:drift_flutter` stores the
// // database files in `getApplicationDocumentsDirectory()`.
//         databaseDirectory: getApplicationSupportDirectory,
//       ),
// // If you need web support, see https://drift.simonbinder.eu/platforms/web/
//     );
//   }
// }

import 'dart:io';

import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
  AppDatabase() : super(_openConnection());

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // Create all tables
      await m.createAll();

      // Seed languages AFTER tables are created
      await _seedLanguages();
    },
  );

  /// -------------------------------------------------------------------------
  /// LANGUAGE SEEDING
  /// -------------------------------------------------------------------------
  ///
  /// This runs only once when the database is first created.
  /// It is safe, deterministic, and offline-friendly.
  ///
  Future<void> _seedLanguages() async {
    final now = DateTime.now().millisecondsSinceEpoch;

    // Define supported languages here
    const seedLanguages = [
      {'code': 'en', 'name': 'English'},
      {'code': 'de', 'name': 'German'},
      {'code': 'es', 'name': 'Spanish'},
      {'code': 'fr', 'name': 'French'},
      {'code': 'it', 'name': 'Italian'},
      {'code': 'pt', 'name': 'Portuguese'},
    ];

    for (final lang in seedLanguages) {
      await into(languages).insert(
        LanguagesCompanion.insert(
          code: lang['code']!,
          displayName: lang['name']!,
          createdAt: now,
        ),
        // If already exists, do nothing (idempotent)
        onConflict: DoNothing(),
      );
    }
  }
}

LazyDatabase _openConnection() {
  return LazyDatabase(() async {
    final dir = await getApplicationDocumentsDirectory();
    final file = File('${dir.path}/dictionary.db');
    return NativeDatabase(file);
  });
}
