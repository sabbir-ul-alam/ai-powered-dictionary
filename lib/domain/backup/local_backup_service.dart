import 'dart:io';

import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';

import '../../data/local/db/app_database.dart';

class LocalBackupService {
  static const String _dbFileName = 'app.db';
  static const String _backupDirName = 'backups';

  /// Returns path to the live database
  Future<File> _getDatabaseFile() async {
    final file = await AppDatabase.getDatabaseFile();

    // Ensure file exists by touching it
    if (!await file.exists()) {
      // This forces SQLite to create the file if it hasn't yet
      await file.create(recursive: true);
    }

    return file;
  }

  /// Returns (and creates if needed) backup directory
  Future<Directory> _getBackupDirectory() async {
    final dir = await getApplicationDocumentsDirectory();
    final backupDir = Directory(p.join(dir.path, _backupDirName));

    if (!await backupDir.exists()) {
      await backupDir.create(recursive: true);
    }

    return backupDir;
  }

  /// Export DB to a timestamped backup file
  Future<File> exportBackup() async {
    final dbFile = await _getDatabaseFile();

    if (!await dbFile.exists()) {
      throw StateError('Database file does not exist');
    }

    final backupDir = await _getBackupDirectory();
    final timestamp = DateTime.now()
        .toIso8601String()
        .replaceAll(':', '-')
        .split('.')
        .first;

    final backupFile = File(
      p.join(backupDir.path, 'apd_backup_$timestamp.db'),
    );

    return dbFile.copy(backupFile.path);
  }

  /// List all available backups
  Future<List<File>> listBackups() async {
    final backupDir = await _getBackupDirectory();

    final files = backupDir
        .listSync()
        .whereType<File>()
        .where((f) => f.path.endsWith('.db'))
        .toList();

    files.sort(
          (a, b) => b.lastModifiedSync().compareTo(a.lastModifiedSync()),
    );

    return files;
  }

  /// Restore a selected backup
  /// IMPORTANT: App must restart after this
  Future<void> restoreBackup(File backupFile) async {
    final dbFile = await _getDatabaseFile();

    if (!await backupFile.exists()) {
      throw StateError('Backup file not found');
    }

    // Close DB connections BEFORE calling this (handled in UI layer)
    await backupFile.copy(dbFile.path);
  }
}
