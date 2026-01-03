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

  Future<void> _exportBackup() async {
    setState(() => _isWorking = true);
    try {
      // Force DB initialization
      await AppDatabase.getDatabaseFile();

      final file = await _backupService.exportBackup();
      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Backup created: ${file.path.split('/').last}')),
      );
    } catch (e) {
      _showError(e.toString());
    } finally {
      if (mounted) setState(() => _isWorking = false);
    }
  }

  Future<void> _restoreBackup() async {
    final backups = await _backupService.listBackups();

    if (!mounted) return;

    if (backups.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('No backups found')),
      );
      return;
    }

    final selected = await showModalBottomSheet<File>(
      context: context,
      builder: (context) {
        return ListView(
          children: backups.map((file) {
            return ListTile(
              title: Text(file.path.split('/').last),
              onTap: () => Navigator.of(context).pop(file),
            );
          }).toList(),
        );
      },
    );

    if (selected == null) return;

    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
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

      // HARD restart is required to reload DB
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
      builder: (context) => AlertDialog(
        title: const Text('Restart required'),
        content: const Text(
          'Backup restored successfully.\n\nPlease restart the app.',
        ),
        actions: [
          TextButton(
            onPressed: () {
              // Exit app; OS will restart on next launch
              exit(0);
            },
            child: const Text('Exit'),
          ),
        ],
      ),
    );
  }

  void _showError(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(message)),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Settings')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ListTile(
              leading: const Icon(Icons.backup),
              title: const Text('Export backup'),
              onTap: _isWorking ? null : _exportBackup,
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
  }
}
