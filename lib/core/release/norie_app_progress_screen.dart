import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../account/norie_account_service.dart';
import '../account/norie_demo_access_service.dart';
import '../cloud/norie_cloud_sync.dart';
import '../progression/norie_lesson_journey.dart';
import '../progression/norie_progress_backup.dart';
import '../progression/norie_progression.dart';
import 'norie_app_info.dart';
import 'norie_update_bridge.dart';

class NorieAppProgressScreen extends StatefulWidget {
  const NorieAppProgressScreen({super.key});
  @override
  State<NorieAppProgressScreen> createState() => _NorieAppProgressScreenState();
}

class _NorieAppProgressScreenState extends State<NorieAppProgressScreen> {
  static const _recoveryKey = 'norie.lastRestoreBackup.v1';
  bool _busy = false;
  String? _notice;
  String? get _owner => NorieAccountService.instance.user?.id;

  Future<void> _perform(Future<void> Function() operation) async {
    if (_busy) return;
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      await operation();
    } on FormatException catch (error) {
      _notice = error.message;
    } catch (_) {
      _notice =
          'Could not finish. Your previous backup is still available; please retry.';
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _export() => _perform(() async {
        final owner = _owner;
        await NorieLessonJourney.instance.flush();
        if (owner != _owner) {
          throw const FormatException('Account changed. Please retry.');
        }
        final text = NorieProgressBackup.encode(
            NorieProgression.instance.exportCloudState(),
            owner: owner);
        final result = await FilePicker.saveFile(
          dialogTitle: 'Save learning progress',
          fileName:
              'NorieLearning-progress-${DateTime.now().toIso8601String().substring(0, 10)}.json',
          type: FileType.custom,
          allowedExtensions: ['json'],
          bytes: Uint8List.fromList(utf8.encode(text)),
        );
        _notice = result == null
            ? 'Save dialog closed. Check your Downloads folder if your browser started a download.'
            : 'Progress backup saved.';
      });

  Future<void> _restore({bool undo = false}) => _perform(() async {
        if (NorieCloudSync.instance.isSyncing) {
          throw const FormatException(
              'Wait for account synchronization to finish before restoring.');
        }
        final owner = _owner;
        final prefs = await SharedPreferences.getInstance();
        final sessionCurrent = NorieCloudSync.instance.captureSessionGuard();
        String? source;
        if (undo) {
          source = prefs.getString(_recoveryKey);
          if (source == null) {
            throw const FormatException(
                'There is no previous restore to undo on this device.');
          }
        } else {
          final file = await FilePicker.pickFile(
              type: FileType.custom, allowedExtensions: ['json']);
          if (file == null) return;
          final fileSize = file.lengthSync() ?? await file.length();
          if (fileSize == null || fileSize > NorieProgressBackup.maxBytes) {
            throw const FormatException(
                'Choose a Norie progress JSON file under 5 MB.');
          }
          final bytes = await file.readAsBytes();
          if (bytes.length > NorieProgressBackup.maxBytes) {
            throw const FormatException(
                'Choose a Norie progress JSON file under 5 MB.');
          }
          source = utf8.decode(bytes);
        }
        if (owner != _owner) {
          throw const FormatException('Account changed. Please retry.');
        }
        final state = NorieProgressBackup.decode(source, currentOwner: owner);
        if (!mounted) return;
        final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: Text(undo
                      ? 'Undo the last restore?'
                      : 'Restore this learning progress?'),
                  content: Text(
                      'This replaces the current learning progress with ${state['completed_lessons']} completed lessons and ${state['total_xp']} XP. It does not restore Study Lab files, passwords, or audio settings. A recovery copy of your current progress is kept on this device.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Restore progress'))
                  ],
                ));
        if (confirmed != true) return;
        if (owner != _owner || NorieCloudSync.instance.isSyncing) {
          throw const FormatException('Account state changed. Please retry.');
        }
        await NorieLessonJourney.instance.flush();
        final previous = NorieProgressBackup.encode(
            NorieProgression.instance.exportCloudState(),
            owner: owner);
        final recoverySaved = await prefs.setString(_recoveryKey, previous);
        if (!recoverySaved) {
          throw const FormatException(
              'Could not save a recovery copy. Your current progress was not replaced.');
        }
        if (owner != _owner) {
          throw const FormatException('Account changed. Please retry.');
        }
        bool stillCurrent() => owner == _owner && sessionCurrent();
        final restored = await NorieProgression.instance.importCloudState(
          state,
          remoteModifiedAt: DateTime.now().toUtc(),
          stillCurrent: stillCurrent,
        );
        if (!restored || !stillCurrent()) {
          throw const FormatException(
              'Account state changed. Restore was cancelled.');
        }
        _notice =
            'Progress restored on this device. Account availability depends on successful cloud synchronization.';
      });

  Future<void> _downloads() => _perform(() async {
        if (!await launchUrl(NorieAppInfo.downloads,
            mode: LaunchMode.externalApplication)) {
          throw const FormatException(
              'Could not open the download page. Try again when connected.');
        }
      });

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('App & progress')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 720),
          child: AnimatedBuilder(
              animation: Listenable.merge([
                NorieCloudSync.instance,
                NorieAccountService.instance,
                NorieDemoAccessService.instance
              ]),
              builder: (context, _) {
                final cloud = NorieCloudSync.instance;
                final allowed = NorieDemoAccessService.instance.isAllowed;
                final status = switch (cloud.status) {
                  NorieCloudSyncStatus.synced => 'Saved to your account',
                  NorieCloudSyncStatus.syncing =>
                    'Synchronizing with your account…',
                  NorieCloudSyncStatus.pending =>
                    'Saved on this device · waiting to synchronize',
                  NorieCloudSyncStatus.error =>
                    'Saved on this device · sync needs attention',
                  _ => 'Saved on this device',
                };
                return ListView(padding: const EdgeInsets.all(20), children: [
                  Text('NorieLearning ${NorieAppInfo.version}',
                      style: Theme.of(context).textTheme.headlineSmall),
                  const Text('Build ${NorieAppInfo.build} · Public preview'),
                  const SizedBox(height: 12),
                  const Text(
                      'Core lessons and progress work offline. Account sync, downloads, and AI generation need a connection.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                      onPressed: _busy
                          ? null
                          : () {
                              if (!checkNorieWebUpdate()) _downloads();
                            },
                      icon: const Icon(Icons.system_update),
                      label: const Text('Check for updates')),
                  OutlinedButton.icon(
                      onPressed: _busy ? null : _downloads,
                      icon: const Icon(Icons.download),
                      label: const Text('Windows & Android downloads')),
                  const Divider(height: 32),
                  Text(status, style: Theme.of(context).textTheme.titleLarge),
                  if (cloud.lastSyncedAt != null)
                    Text('Last synchronized: ${cloud.lastSyncedAt!.toLocal()}'),
                  if (cloud.message != null) Text(cloud.message!),
                  if (!allowed)
                    const Text(
                        'Cloud accounts are currently limited to approved preview users. Keep a backup of your local progress.'),
                  OutlinedButton(
                      onPressed: _busy || cloud.isSyncing || !allowed
                          ? null
                          : () => _perform(cloud.syncNow),
                      child: const Text('Sync now')),
                  const Divider(height: 32),
                  Text('Learning progress backup',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text(
                      'Includes lesson completion, reading position, XP, credits, owned rewards, and mastery. Study Lab source files and generated sets are not included. Keep the JSON file private.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                      onPressed: _busy ? null : _export,
                      icon: const Icon(Icons.save_alt),
                      label: const Text('Export progress backup')),
                  OutlinedButton.icon(
                      onPressed:
                          _busy || cloud.isSyncing ? null : () => _restore(),
                      icon: const Icon(Icons.restore),
                      label: const Text('Restore progress backup')),
                  TextButton(
                      onPressed: _busy || cloud.isSyncing
                          ? null
                          : () => _restore(undo: true),
                      child: const Text('Undo last restore')),
                  if (_busy) const LinearProgressIndicator(),
                  if (_notice != null)
                    Padding(
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        child:
                            Semantics(liveRegion: true, child: Text(_notice!))),
                ]);
              }),
        ))),
      );
}
