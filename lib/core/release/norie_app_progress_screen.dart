import 'dart:convert';
import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import '../account/norie_account_service.dart';
import '../account/norie_demo_access_service.dart';
import '../cloud/norie_cloud_sync.dart';
import '../diagnostics/norie_diagnostics_screen.dart';
import '../progression/norie_lesson_journey.dart';
import '../progression/norie_progress_backup.dart';
import '../progression/anatomy_progress_backup.dart';
import '../../features/learning/data/anatomy_backup_persistence.dart';
import '../../features/learning/domain/anatomy_atlas_catalog.dart';
import '../progression/norie_progression.dart';
import '../sync/norie_economy_store.dart';
import '../sync/norie_economy_screen.dart';
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
        final sessionCurrent = NorieCloudSync.instance.captureSessionGuard();
        await NorieProgression.instance.flushPendingSaves(retry: true);
        await NorieLessonJourney.instance.flush();
        if (owner != _owner || !sessionCurrent()) {
          throw const FormatException('Account changed. Please retry.');
        }
        final text = NorieProgressBackup.encode(
            NorieProgression.instance.exportCloudState(),
            owner: owner);
        final result = await FilePicker.saveFile(
          dialogTitle: 'Save learning progress',
          fileName:
              'NorieLearning-progress-${DateTime.now().toIso8601String().substring(0, 10)}.json',
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
        final rewardRecovery = !NorieEconomyStore.instance.available;
        if (rewardRecovery) {
          await NorieProgression.instance.flushForRewardRecovery();
        } else {
          await NorieProgression.instance.flushPendingSaves(retry: true);
        }
        await NorieLessonJourney.instance.flush();
        if (owner != _owner ||
            !sessionCurrent() ||
            NorieCloudSync.instance.isSyncing) {
          throw const FormatException('Account state changed. Please retry.');
        }
        if (rewardRecovery) {
          final damaged = prefs.getString(NorieEconomyStore.storageKey);
          if (damaged != null &&
              !await prefs.setString('norie.economy.quarantineRecovery.v1',
                  jsonEncode({'owner': owner, 'envelope': damaged}))) {
            throw const FormatException(
                'Could not preserve damaged reward storage. Restore was cancelled.');
          }
          if (owner != _owner || !sessionCurrent()) {
            throw const FormatException('Account changed. Please retry.');
          }
        }
        final previous = NorieProgressBackup.encode(
            NorieProgression.instance
                .exportCloudState(includeEconomy: !rewardRecovery),
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
          restoreEconomy: true,
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

  Future<void> _anatomyBackup({bool restore = false}) => _perform(() async {
        final owner = _owner;
        final learnerCurrent =
            NorieAccountService.instance.captureLearnerGuard();
        bool current() => mounted && learnerCurrent() && owner == _owner;
        void checkCurrent() {
          if (!current()) {
            throw const FormatException('Account changed. Please retry.');
          }
        }

        final catalog = await AnatomyAtlasCatalog.load();
        checkCurrent();
        final storage = AnatomyBackupPersistence.instance;
        final ownerKey = AnatomyProgressBackup.ownerKey(owner);
        if (!restore) {
          final parts = await storage.capture(ownerKey);
          checkCurrent();
          final state = AnatomyProgressBackup.fromLocalParts(parts,
              catalog: catalog, currentOwner: owner);
          final text = AnatomyProgressBackup.encode(state,
              catalog: catalog, currentOwner: owner);
          final result = await FilePicker.saveFile(
            dialogTitle: 'Save Anatomy study and views',
            fileName:
                'NorieLearning-anatomy-${DateTime.now().toIso8601String().substring(0, 10)}.json',
            bytes: Uint8List.fromList(utf8.encode(text)),
          );
          checkCurrent();
          _notice = result == null
              ? 'Save dialog closed. Check Downloads if your browser started a download.'
              : 'Anatomy backup saved: ${(state['study'] as List).length} study entries and ${(state['bookmarks'] as List).length} saved views.';
          return;
        }
        final file = await FilePicker.pickFile(
            type: FileType.custom, allowedExtensions: ['json']);
        checkCurrent();
        if (file == null) return;
        final size = file.lengthSync() ?? await file.length();
        checkCurrent();
        if (size == null ||
            size == 0 ||
            size > AnatomyProgressBackup.maxBytes) {
          throw const FormatException(
              'Choose a supported Anatomy backup under 384 KB.');
        }
        final bytes = await file.readAsBytes();
        checkCurrent();
        if (bytes.length > AnatomyProgressBackup.maxBytes) {
          throw const FormatException('Anatomy backup exceeds the size limit.');
        }
        final incoming = AnatomyProgressBackup.decode(utf8.decode(bytes),
            catalog: catalog, currentOwner: owner);
        if (!mounted) return;
        final confirmed = await showDialog<bool>(
            context: context,
            builder: (context) => AlertDialog(
                  title: const Text('Merge Anatomy study and views?'),
                  content: Text(
                      'Merge ${(incoming['study'] as List).length} study entries and ${(incoming['bookmarks'] as List).length} saved views for this learner. Existing evidence is retained. This does not change lessons, XP, credits or mastery.'),
                  actions: [
                    TextButton(
                        onPressed: () => Navigator.pop(context, false),
                        child: const Text('Cancel')),
                    FilledButton(
                        onPressed: () => Navigator.pop(context, true),
                        child: const Text('Merge Anatomy')),
                  ],
                ));
        if (confirmed != true) return;
        checkCurrent();
        var studyCount = 0, viewCount = 0, retained = 0;
        final restored = await storage.restore(
            ownerKey,
            AnatomyProgressBackup.toLocalParts(incoming,
                catalog: catalog, currentOwner: owner),
            stillCurrent: current, mergeWithCurrent: (parts) {
          checkCurrent();
          final local = AnatomyProgressBackup.fromLocalParts(parts,
              catalog: catalog, currentOwner: owner);
          final merged = AnatomyProgressBackup.merge(local, incoming,
              catalog: catalog, currentOwner: owner);
          final localRows = {
            for (final row in local['study'] as List) row['id']: jsonEncode(row)
          };
          final localViews = {
            for (final row in local['bookmarks'] as List) jsonEncode(row)
          };
          studyCount = (merged['study'] as List)
              .where((row) => localRows[row['id']] != jsonEncode(row))
              .length;
          viewCount = (merged['bookmarks'] as List)
              .where((row) => !localViews.contains(jsonEncode(row)))
              .length;
          retained = (merged['study'] as List).length -
              studyCount +
              (merged['bookmarks'] as List).length -
              viewCount;
          return AnatomyProgressBackup.toLocalParts(merged,
              catalog: catalog, currentOwner: owner);
        });
        checkCurrent();
        if (!restored) {
          throw const FormatException(
              'Account changed. Anatomy restore was cancelled.');
        }
        _notice =
            'Anatomy merged: $studyCount study entries and $viewCount views added or updated; $retained entries retained. Incompatible files are rejected in full. Rewards unchanged.';
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
                  OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context)
                                  .push(MaterialPageRoute<void>(
                                settings:
                                    const RouteSettings(name: 'diagnostics'),
                                builder: (_) => const NorieDiagnosticsScreen(),
                              )),
                      icon: const Icon(Icons.privacy_tip_outlined),
                      label: const Text('Local diagnostics')),
                  OutlinedButton.icon(
                      onPressed: _busy
                          ? null
                          : () => Navigator.of(context)
                                  .push(MaterialPageRoute<void>(
                                settings: const RouteSettings(name: 'settings'),
                                builder: (_) => const NorieEconomyScreen(),
                              )),
                      icon: const Icon(Icons.account_balance_wallet_outlined),
                      label: const Text('Credits and device budget')),
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
                  const Divider(height: 32),
                  Text('Anatomy study backup',
                      style: Theme.of(context).textTheme.titleLarge),
                  const Text(
                      'Separate local backup of guided Anatomy study and named saved views. Progress backups above do not include Anatomy. Keep the JSON file private.'),
                  FilledButton.icon(
                      onPressed: _busy ? null : () => _anatomyBackup(),
                      icon: const Icon(Icons.save_alt),
                      label: const Text('Export Anatomy backup')),
                  OutlinedButton.icon(
                      onPressed:
                          _busy ? null : () => _anatomyBackup(restore: true),
                      icon: const Icon(Icons.restore),
                      label: const Text('Import Anatomy backup')),
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
