
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

import 'package:apd/data/local/db/tables/word_learning_progress.dart';
import 'package:drift/drift.dart';
import 'package:drift/native.dart';
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
    WordLearningProgress
  ]

)
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(_openConnection());

  static Future<File> getDatabaseFile() async {
    final dir = await getApplicationDocumentsDirectory();
    return File('${dir.path}/dictionary.db');
  }


  // IMPORTANT: bump schemaVersion whenever you change schema
  // If you already have schemaVersion = 1, bump to 2.
  @override
  int get schemaVersion => 3;

  @override
  MigrationStrategy get migration => MigrationStrategy(
    onCreate: (Migrator m) async {
      // Create all tables
      await m.createAll();
      onUpgrade: (m, from, to) async {
        // Upgrade path for adding isFavorite column
        if (from < 2) {
          await m.addColumn(words, words.isFavorite);
        }
        // NEW learning progress table introduced at schemaVersion=3
        if (from < 3) {
          await m.createTable(wordLearningProgress);

          // Backfill progress for existing words
          // Default: unlearned
          await customStatement('''
              INSERT OR IGNORE INTO word_learning_progress
                (word_id, learning_status, correct_count, incorrect_count, last_reviewed_at, created_at, updated_at)
              SELECT
                w.id,
                'unlearned',
                0,
                0,
                NULL,
                w.created_at,
                w.updated_at
              FROM words w
              WHERE w.deleted_at IS NULL;
            ''');
        }

      };

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
      {'code': 'en-US', 'name': 'English'},
      {'code': 'de-DE', 'name': 'German'},
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


