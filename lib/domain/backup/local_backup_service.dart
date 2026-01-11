// import 'dart:io';
//
// import 'package:path/path.dart' as p;
// import 'package:path_provider/path_provider.dart';
//
// import '../../data/local/db/app_database.dart';
//
// class LocalBackupService {
//   static const String _backupDirName = 'backups';
//
//   /// Returns path to the live database
//   Future<File> _getDatabaseFile() async {
//     final file = await AppDatabase.getDatabaseFile();
//
//     // Ensure file exists by touching it
//     if (!await file.exists()) {
//       // This forces SQLite to create the file if it hasn't yet
//       await file.create(recursive: true);
//     }
//
//     return file;
//   }
//
//   /// Returns (and creates if needed) backup directory
//   Future<Directory> _getBackupDirectory() async {
//     final dir = await getApplicationDocumentsDirectory();
//     final backupDir = Directory(p.join(dir.path, _backupDirName));
//
//     if (!await backupDir.exists()) {
//       await backupDir.create(recursive: true);
//     }
//
//     return backupDir;
//   }
//
//   /// Export DB to a timestamped backup file
//   Future<File> exportBackup() async {
//     final dbFile = await _getDatabaseFile();
//
//     if (!await dbFile.exists()) {
//       throw StateError('Database file does not exist');
//     }
//
//     final backupDir = await _getBackupDirectory();
//     final timestamp = DateTime.now()
//         .toIso8601String()
//         .replaceAll(':', '-')
//         .split('.')
//         .first;
//
//     final backupFile = File(
//       p.join(backupDir.path, 'apd_backup_$timestamp.db'),
//     );
//
//     return dbFile.copy(backupFile.path);
//   }
//
//   /// List all available backups
//   Future<List<File>> listBackups() async {
//     final backupDir = await _getBackupDirectory();
//
//     final files = backupDir
//         .listSync()
//         .whereType<File>()
//         .where((f) => f.path.endsWith('.db'))
//         .toList();
//
//     files.sort(
//           (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
//     );
//
//     return files;
//   }
//
//   /// Restore a selected backup
//   /// IMPORTANT: App must restart after this
//   Future<void> restoreBackup(File backupFile) async {
//     final dbFile = await _getDatabaseFile();
//
//     if (!await backupFile.exists()) {
//       throw StateError('Backup file not found');
//     }
//
//     // Close DB connections BEFORE calling this (handled in UI layer)
//     await backupFile.copy(dbFile.path);
//   }
// }



import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

/// Local backup + restore.
/// Android:
/// - Export/List/Restore via MediaStore to public Documents/APD/Backups
/// - Survives uninstall
///
/// iOS:
/// - Uses app sandbox Documents/backups (will be deleted on uninstall)
class LocalBackupService {
  static const MethodChannel _channel =
  MethodChannel('apd.backup.channel');

  static const String _dbFileName = 'app.db';
  static const String _iosBackupDirName = 'backups';

  /// --- ANDROID (MediaStore) ------------------------------------------------

  Future<void> exportBackup(String? dbFilePath) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('exportBackup',{'dbFilePath': dbFilePath});
      return;
    }

    // iOS fallback: internal backup file
    // await _exportBackupIosInternal();
  }

  Future<List<BackupEntry>> listBackups() async {
    if (Platform.isAndroid) {
      final raw = await _channel.invokeMethod<List<dynamic>>('listBackups');
      final list = raw ?? const [];
      return list
          .whereType<Map>()
          .map((m) => BackupEntry.fromMap(Map<String, dynamic>.from(m)))
          .toList()
        ..sort((a, b) => b.modifiedAtMs.compareTo(a.modifiedAtMs));
    }

    return _listBackupsIosInternal();
  }

  /// Restores selected backup into the live DB location.
  /// IMPORTANT: After restore, you must fully restart the app (exit & relaunch).
  Future<void> restoreBackup(BackupEntry entry) async {
    if (Platform.isAndroid) {
      await _channel.invokeMethod('restoreBackup', {
        'uri': entry.uri,
      });
      return;
    }

    await _restoreBackupIosInternal(entry);
  }

  /// --- iOS INTERNAL IMPLEMENTATION ----------------------------------------

  Future<File> _getDatabaseFileIos() async {
    final dir = await getApplicationDocumentsDirectory();
    final dbFile = File(p.join(dir.path, _dbFileName));

    // If DB hasn't been created yet, create an empty file so export doesn't fail.
    if (!await dbFile.exists()) {
      await dbFile.create(recursive: true);
    }
    return dbFile;
  }

  Future<Directory> _getBackupDirectoryIos() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, _iosBackupDirName));
    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }
    return backupDir;
  }

  Future<void> _exportBackupIosInternal() async {
    final dbFile = await _getDatabaseFileIos();

    if (!await dbFile.exists()) {
      throw StateError('Database file does not exist');
    }

    final backupDir = await _getBackupDirectoryIos();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;

    final backupFile = File(
      p.join(backupDir.path, 'apd_backup_$timestamp.db'),
    );

    await dbFile.copy(backupFile.path);
  }

  Future<List<BackupEntry>> _listBackupsIosInternal() async {
    final backupDir = await _getBackupDirectoryIos();

    final files = backupDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.db'))
        .toList();

    return files.map((f) {
      final stat = f.statSync();
      return BackupEntry(
        name: p.basename(f.path),
        uri: f.path, // on iOS we use file path as "uri"
        modifiedAtMs: stat.modified.millisecondsSinceEpoch,
        sizeBytes: stat.size,
      );
    }).toList()
      ..sort((a, b) => b.modifiedAtMs.compareTo(a.modifiedAtMs));
  }

  Future<void> _restoreBackupIosInternal(BackupEntry entry) async {
    final src = File(entry.uri);
    if (!await src.exists()) {
      throw StateError('Backup file not found');
    }

    final dbFile = await _getDatabaseFileIos();
    await src.copy(dbFile.path);
  }
}

@immutable
class BackupEntry {
  final String name;

  /// Android: content:// Uri string
  /// iOS: absolute file path
  final String uri;

  final int modifiedAtMs;
  final int sizeBytes;

  const BackupEntry({
    required this.name,
    required this.uri,
    required this.modifiedAtMs,
    required this.sizeBytes,
  });

  factory BackupEntry.fromMap(Map<String, dynamic> map) {
    return BackupEntry(
      name: (map['name'] as String?) ?? 'backup.db',
      uri: (map['uri'] as String?) ?? '',
      modifiedAtMs: (map['modifiedAtMs'] as int?) ?? 0,
      sizeBytes: (map['sizeBytes'] as int?) ?? 0,
    );
  }
}

