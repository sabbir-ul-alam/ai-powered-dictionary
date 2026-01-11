import 'dart:io';

import 'package:flutter/material.dart';

import '../../../data/local/db/app_database.dart';
import '../../../domain/backup/local_backup_service.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _backupService = LocalBackupService();
  bool _isWorking = false;
  late Future<String> dbpath;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    dbpath = AppDatabase.getDatabaseFilePath();
  }

  Future<void> _exportBackup(String? dbPath) async {
    setState(() => _isWorking = true);
    try {
      if (dbPath == null) {
        throw Exception('Database file path not found');
      }

      await _backupService.exportBackup(dbPath);
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Backup created in Documents/APD/Backups'),
        ),
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _restoreBackup() async {
    setState(() => _isWorking = true);
    List<BackupEntry> backups = const [];
    try {
      backups = await _backupService.listBackups();
    } catch (e) {
      _showError(e.toString());
      if (mounted) setState(() => _isWorking = false);
      return;
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }

    if (!mounted) return;

    if (backups.isEmpty) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('No backups found')));
      return;
    }

    final selected = await showModalBottomSheet<BackupEntry>(
      context: context,
      builder: (context) {
        return ListView(
          children:
              backups.map((b) {
                final dt = DateTime.fromMillisecondsSinceEpoch(b.modifiedAtMs);
                return ListTile(
                  title: Text(b.name),
                  subtitle: Text('Modified: $dt • Size: ${b.sizeBytes} bytes'),
                  onTap: () => Navigator.of(context).pop(b),
                );
              }).toList(),
        );
      },
    );

    if (selected == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text('Restore backup'),
            content: const Text(
              'This will overwrite your current data.\n\nAre you sure?',
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('Restore'),
              ),
            ],
          ),
    );

    if (confirmed != true) return;

    setState(() => _isWorking = true);
    try {
      await _backupService.restoreBackup(selected);

      if (!mounted) return;
      await _showRestartRequiredDialog();
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _showRestartRequiredDialog() async {
    await showDialog(
      context: context,
      barrierDismissible: false,
      builder:
          (context) => AlertDialog(
            title: const Text('Restart required'),
            content: const Text(
              'Backup restored successfully.\n\nPlease restart the app.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: const Text('Exit'),
              ),
            ],
          ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(message)));
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: dbpath,
      builder: (context, snapshot) {
        return Scaffold(
          appBar: AppBar(title: const Text('Settings')),
          body: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.backup),
                  title: const Text('Export backup'),
                  subtitle: Text(
                    Platform.isAndroid
                        ? 'Saved in Documents/APD/Backups'
                        : 'Saved inside the app (iOS fallback)',
                  ),
                  onTap: _isWorking ? null : () => _exportBackup(snapshot.data),
                ),
                ListTile(
                  leading: const Icon(Icons.restore),
                  title: const Text('Restore backup'),
                  onTap: _isWorking ? null : _restoreBackup,
                ),
                if (_isWorking)
                  const Padding(
                    padding: EdgeInsets.only(top: 24),
                    child: CircularProgressIndicator(),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
