import 'dart:async';
import 'dart:convert';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/account/norie_account_service.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_guided_learning.dart';
import 'anatomy_backup_persistence.dart';

/// Offline study evidence, isolated by account (including the local guest).
/// Every identity change increments a generation, including A -> B -> A.
class AnatomyStudyStore extends ChangeNotifier {
  AnatomyStudyStore({
    required AnatomyAtlasCatalog catalog,
    String? Function()? ownerId,
    Listenable? ownerChanges,
    Future<String?> Function(String key)? read,
    Future<void> Function(String key, String value)? write,
    AnatomyBackupPersistence? persistence,
  })  : _validIds = catalog.structures.map((s) => s.id).toSet(),
        _ownerId = ownerId ?? (() => NorieAccountService.instance.user?.id),
        _ownerChanges = ownerChanges ??
            (ownerId == null ? NorieAccountService.instance : null),
        _read = read ?? _readPreferences,
        _write = write ?? _writePreferences,
        _persistence = persistence ??
            (read == null && write == null
                ? AnatomyBackupPersistence.instance
                : null) {
    _ownerChanges?.addListener(_synchronizeOwner);
    _persistence?.register(
      this,
      owner: () => _started && !_disposed ? _backupOwner : null,
      flush: () async {
        await initialize();
        await _pending;
        if (!_ready || _saveError != null) {
          throw StateError('Saved Anatomy study needs recovery before backup.');
        }
      },
      restored: _adoptBackup,
      transactionChanged: () {
        if (!_disposed) notifyListeners();
      },
    );
  }

  static const _maxEntries = 128;
  static const _maxPayload = 262144;
  final Set<String> _validIds;
  final String? Function() _ownerId;
  final Listenable? _ownerChanges;
  final Future<String?> Function(String) _read;
  final Future<void> Function(String, String) _write;
  final AnatomyBackupPersistence? _persistence;
  final _entries = <String, AnatomyStudyProgress>{};
  String? _selected, _owner;
  bool _started = false, _ready = false, _disposed = false;
  int _generation = 0;
  Future<void> _pending = Future.value();
  Future<void>? _loading;
  String? _saveError;

  bool get ready =>
      _ready && !(_persistence?.isRestoring(_backupOwner) ?? false);
  String? get saveError => (_persistence?.isRestoring(_backupOwner) ?? false)
      ? 'Anatomy backup is being restored. Please wait.'
      : _saveError;
  AnatomyStudyProgress? get current {
    final entry = _entries[_selected];
    if (entry != null &&
        !entry.answersRevealed &&
        (_persistence?.wasAnswerRevealed(_backupOwner, entry.structureId) ??
            false)) {
      return entry.copyWith(answersRevealed: true);
    }
    return entry;
  }

  Map<String, AnatomyStudyProgress> get entries => Map.unmodifiable(_entries);

  /// Guards delayed UI/model callbacks across identity changes, even A -> B -> A.
  bool Function() captureOwnerGuard() {
    final generation = _generation;
    return () => _isCurrent(generation);
  }

  static Future<String?> _readPreferences(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  static Future<void> _writePreferences(String key, String value) async {
    if (!await (await SharedPreferences.getInstance()).setString(key, value)) {
      throw StateError('Local study save failed');
    }
  }

  String get _storageKey =>
      'norie.anatomy.study.v1.${_owner == null ? 'guest' : 'account.${Uri.encodeComponent(_owner!)}'}';
  String get _backupOwner => _owner == null ? 'guest' : 'account.$_owner';

  void _adoptBackup(Map<String, String?> parts) {
    if (_disposed || !_started || _ownerId() != _owner) return;
    // Invalidates delayed callbacks and snapshots from the replaced activity.
    _generation++;
    final raw = parts['study'];
    final value = raw == null ? null : jsonDecode(raw) as Map<String, dynamic>;
    _entries.clear();
    _selected = null;
    if (value != null) {
      for (final row in value['entries'] as List) {
        final entry = AnatomyStudyProgress.restore(row, _validIds);
        if (entry != null) {
          _entries[entry.structureId] = entry;
          if (entry.answersRevealed) {
            _persistence?.noteAnswerRevealed(_backupOwner, entry.structureId);
          }
        }
      }
      _selected = value['selected'] as String?;
    }
    _ready = true;
    _saveError = null;
    notifyListeners();
  }

  Future<void> initialize() {
    _synchronizeOwner();
    return _loading ?? Future.value();
  }

  void _synchronizeOwner() {
    if (_disposed) return;
    final owner = _ownerId();
    if (_started && owner == _owner) return;
    _started = true;
    _owner = owner;
    _generation++;
    _entries.clear();
    _selected = null;
    _ready = false;
    _saveError = null;
    _loading = _restore(_generation, _storageKey);
    notifyListeners();
  }

  bool _isCurrent(int generation) =>
      !_disposed && generation == _generation && _ownerId() == _owner;

  Future<void> _restore(int generation, String key) async {
    // An already-started write cannot be cancelled. Wait for it before reading
    // this owner again. Queued obsolete generations are discarded by _save.
    await _pending;
    if (!_isCurrent(generation)) return;
    try {
      final raw = _persistence == null
          ? await _read(key)
          : await _persistence.readPart(_backupOwner, 'study');
      if (!_isCurrent(generation)) return;
      if (raw != null && raw.length <= _maxPayload) {
        final value = jsonDecode(raw);
        if (value is Map<String, dynamic> &&
            value['version'] == 1 &&
            value['contentVersion'] == AnatomyGuidedModule.contentVersion &&
            value['entries'] is List &&
            (value['entries'] as List).length <= _maxEntries) {
          for (final row in value['entries'] as List) {
            final entry = AnatomyStudyProgress.restore(row, _validIds);
            if (entry != null) {
              _entries[entry.structureId] = entry;
              if (entry.answersRevealed) {
                _persistence?.noteAnswerRevealed(
                    _backupOwner, entry.structureId);
              }
            }
          }
          final selected = value['selected'];
          if (selected is String && _entries.containsKey(selected)) {
            _selected = selected;
          }
        }
      }
    } on Object catch (_) {
      if (!_isCurrent(generation)) return;
      // Malformed or unavailable local storage must not block offline study.
      _saveError = 'Saved study could not be read. You can continue locally.';
    }
    if (_isCurrent(generation)) {
      _ready = true;
      notifyListeners();
    }
  }

  bool get _canMutate {
    _synchronizeOwner();
    return !_disposed && ready;
  }

  bool select(String id) {
    if (!_canMutate || !_validIds.contains(id)) return false;
    final before = _entries[id];
    if (!_entries.containsKey(id) && _entries.length >= _maxEntries) {
      _entries.remove(_entries.keys.first);
    }
    _selected = id;
    _entries.putIfAbsent(id, () => AnatomyStudyProgress(structureId: id));
    _changed(changedId: id, before: before);
    return true;
  }

  bool _update(AnatomyStudyProgress Function(AnatomyStudyProgress) transform) {
    if (!_canMutate || current == null) return false;
    final before = current!;
    final id = _selected!;
    _entries[id] = transform(before);
    _changed(changedId: id, before: before);
    return true;
  }

  void goToStep(AnatomyStudyStep step) =>
      _update((progress) => progress.copyWith(step: step));

  void completeStep() => _update((progress) => progress.copyWith(
        completedSteps: {...progress.completedSteps, progress.step},
        skippedSteps: {...progress.skippedSteps}..remove(progress.step),
        step: AnatomyStudyStep.values[(progress.step.index + 1)
            .clamp(0, AnatomyStudyStep.values.length - 1)],
      ));

  void skipStep() => _update((progress) => progress.copyWith(
        completedSteps: {...progress.completedSteps}..remove(progress.step),
        skippedSteps: {...progress.skippedSteps, progress.step},
        step: AnatomyStudyStep.values[(progress.step.index + 1)
            .clamp(0, AnatomyStudyStep.values.length - 1)],
      ));

  void recordIdentification() =>
      _update((progress) => progress.copyWith(identified: true));
  void recordStudy() => _update((progress) => progress.copyWith(studied: true));

  bool recordAnswerReveal() => _update((progress) {
        _persistence?.noteAnswerRevealed(_backupOwner, progress.structureId);
        return progress.copyWith(answersRevealed: true);
      });

  bool recordCheck({required bool correct, required bool assisted}) =>
      _update((progress) {
        final wasAssisted = assisted || progress.answersRevealed;
        _persistence?.noteAnswerRevealed(_backupOwner, progress.structureId);
        return progress.copyWith(
          answersRevealed: true,
          assistedAttempts: (progress.assistedAttempts + (wasAssisted ? 1 : 0))
              .clamp(0, 1000000),
          independentAttempts:
              (progress.independentAttempts + (wasAssisted ? 0 : 1))
                  .clamp(0, 1000000),
          independentCorrect:
              (progress.independentCorrect + (!wasAssisted && correct ? 1 : 0))
                  .clamp(0, 1000000),
        );
      });

  void _changed({String? changedId, AnatomyStudyProgress? before}) {
    _save(changedId: changedId, before: before);
    notifyListeners();
  }

  bool _sameProgress(AnatomyStudyProgress? a, AnatomyStudyProgress? b) =>
      a == null || b == null
          ? a == b
          : a.structureId == b.structureId &&
              a.step == b.step &&
              setEquals(a.completedSteps, b.completedSteps) &&
              setEquals(a.skippedSteps, b.skippedSteps) &&
              a.identified == b.identified &&
              a.studied == b.studied &&
              a.answersRevealed == b.answersRevealed &&
              a.assistedAttempts == b.assistedAttempts &&
              a.independentAttempts == b.independentAttempts &&
              a.independentCorrect == b.independentCorrect;

  AnatomyStudyProgress _mergeEvidence(
      AnatomyStudyProgress latest, AnatomyStudyProgress incoming) {
    final done = {...latest.completedSteps, ...incoming.completedSteps};
    return incoming.copyWith(
      completedSteps: done,
      skippedSteps: {...latest.skippedSteps, ...incoming.skippedSteps}
        ..removeAll(done),
      identified: latest.identified || incoming.identified,
      studied: latest.studied || incoming.studied,
      answersRevealed: latest.answersRevealed || incoming.answersRevealed,
      assistedAttempts:
          math.max(latest.assistedAttempts, incoming.assistedAttempts),
      independentAttempts:
          math.max(latest.independentAttempts, incoming.independentAttempts),
      independentCorrect:
          math.max(latest.independentCorrect, incoming.independentCorrect),
    );
  }

  String _upsertStudy(
      String? previousRaw,
      Map<String, AnatomyStudyProgress> changes,
      Map<String, AnatomyStudyProgress?> expected,
      String? selected) {
    final rows = <String, AnatomyStudyProgress>{};
    if (previousRaw != null) {
      final value = jsonDecode(previousRaw);
      if (value is! Map ||
          value['version'] != 1 ||
          value['contentVersion'] != AnatomyGuidedModule.contentVersion ||
          value['entries'] is! List ||
          (value['entries'] as List).length > _maxEntries) {
        throw const FormatException(
            'Saved Anatomy study needs recovery before saving.');
      }
      for (final raw in value['entries'] as List) {
        final entry = AnatomyStudyProgress.restore(raw, _validIds);
        if (entry == null || rows.containsKey(entry.structureId)) {
          throw const FormatException(
              'Saved Anatomy study contains invalid entries.');
        }
        rows[entry.structureId] = entry;
        if (entry.answersRevealed) {
          _persistence?.noteAnswerRevealed(_backupOwner, entry.structureId);
        }
      }
    }
    for (final entry in changes.entries) {
      final latest = rows.remove(entry.key);
      rows[entry.key] =
          latest == null || _sameProgress(latest, expected[entry.key])
              ? entry.value
              : _mergeEvidence(latest, entry.value);
    }
    // Retain the existing bounded recent-entry behavior, using the shared state
    // rather than evicting entries based on a stale instance's whole snapshot.
    while (rows.length > _maxEntries) {
      rows.remove(rows.keys.first);
    }
    return jsonEncode({
      'version': 1,
      'contentVersion': AnatomyGuidedModule.contentVersion,
      'selected': rows.containsKey(selected) ? selected : null,
      'entries': rows.values.map((entry) => entry.toJson()).toList()
    });
  }

  void _save({String? changedId, AnatomyStudyProgress? before}) {
    final generation = _generation;
    final key = _storageKey;
    final backupOwner = _backupOwner;
    final backupRevision = _persistence?.revision(backupOwner);
    final selected = _selected;
    final changes = changedId == null
        ? Map<String, AnatomyStudyProgress>.from(_entries)
        : <String, AnatomyStudyProgress>{changedId: _entries[changedId]!};
    final expected = <String, AnatomyStudyProgress?>{
      if (changedId != null) changedId: before
    };
    final payload = jsonEncode({
      'version': 1,
      'contentVersion': AnatomyGuidedModule.contentVersion,
      'selected': _selected,
      'entries': _entries.values.map((entry) => entry.toJson()).toList(),
    });
    _pending = _pending.then((_) async {
      if (!_isCurrent(generation)) return;
      try {
        if (_persistence == null) {
          await _write(key, payload);
        } else {
          await _persistence.writePart(backupOwner, 'study', payload,
              stillCurrent: () => _isCurrent(generation),
              expectedRevision: backupRevision,
              mergeWithCurrent: (current) =>
                  _upsertStudy(current, changes, expected, selected));
        }
        if (_isCurrent(generation)) _saveError = null;
      } on Object catch (_) {
        if (_isCurrent(generation)) {
          _saveError = 'Study is in memory. Local save failed; retry saving.';
        }
      }
      if (_isCurrent(generation)) notifyListeners();
    });
  }

  Future<void> flush() async {
    await _pending;
    if (!_disposed && _ready && _saveError != null) {
      _save();
      await _pending;
    }
  }

  Future<void> reset() async {
    final initialization = initialize();
    final intendedOwnerIsCurrent = captureOwnerGuard();
    await initialization;
    if (!intendedOwnerIsCurrent() || !_canMutate) return;
    if (_persistence != null) {
      final empty = jsonEncode({
        'version': 1,
        'contentVersion': AnatomyGuidedModule.contentVersion,
        'selected': null,
        'entries': <dynamic>[]
      });
      await _persistence.restore(
          _backupOwner, {'study': empty, 'bookmarks': null},
          stillCurrent: intendedOwnerIsCurrent,
          mergeWithCurrent: (previous) => {...previous, 'study': empty});
      return;
    }
    _entries.clear();
    _selected = null;
    _changed();
    await flush();
  }

  @override
  void dispose() {
    _disposed = true;
    _ownerChanges?.removeListener(_synchronizeOwner);
    _persistence?.unregister(this);
    super.dispose();
  }
}
