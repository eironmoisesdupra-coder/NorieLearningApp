import 'dart:async';
import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/account/norie_account_service.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_guided_learning.dart';

/// Offline study evidence, isolated by account (including the local guest).
/// Every identity change increments a generation, including A -> B -> A.
class AnatomyStudyStore extends ChangeNotifier {
  AnatomyStudyStore({
    required AnatomyAtlasCatalog catalog,
    String? Function()? ownerId,
    Listenable? ownerChanges,
    Future<String?> Function(String key)? read,
    Future<void> Function(String key, String value)? write,
  })  : _validIds = catalog.structures.map((s) => s.id).toSet(),
        _ownerId = ownerId ?? (() => NorieAccountService.instance.user?.id),
        _ownerChanges = ownerChanges ??
            (ownerId == null ? NorieAccountService.instance : null),
        _read = read ?? _readPreferences,
        _write = write ?? _writePreferences {
    _ownerChanges?.addListener(_synchronizeOwner);
  }

  static const _maxEntries = 128;
  static const _maxPayload = 262144;
  final Set<String> _validIds;
  final String? Function() _ownerId;
  final Listenable? _ownerChanges;
  final Future<String?> Function(String) _read;
  final Future<void> Function(String, String) _write;
  final _entries = <String, AnatomyStudyProgress>{};
  String? _selected, _owner;
  bool _started = false, _ready = false, _disposed = false;
  int _generation = 0;
  Future<void> _pending = Future.value();
  Future<void>? _loading;
  String? _saveError;

  bool get ready => _ready;
  String? get saveError => _saveError;
  AnatomyStudyProgress? get current => _entries[_selected];
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
      final raw = await _read(key);
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
            if (entry != null) _entries[entry.structureId] = entry;
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
    return !_disposed && _ready;
  }

  void select(String id) {
    if (!_canMutate || !_validIds.contains(id)) return;
    if (!_entries.containsKey(id) && _entries.length >= _maxEntries) {
      _entries.remove(_entries.keys.first);
    }
    _selected = id;
    _entries.putIfAbsent(id, () => AnatomyStudyProgress(structureId: id));
    _changed();
  }

  void _update(AnatomyStudyProgress Function(AnatomyStudyProgress) transform) {
    if (!_canMutate || current == null) return;
    _entries[_selected!] = transform(current!);
    _changed();
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

  void recordAnswerReveal() =>
      _update((progress) => progress.copyWith(answersRevealed: true));

  void recordCheck({required bool correct, required bool assisted}) =>
      _update((progress) {
        final wasAssisted = assisted || progress.answersRevealed;
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

  void _changed() {
    _save();
    notifyListeners();
  }

  void _save() {
    final generation = _generation;
    final key = _storageKey;
    final payload = jsonEncode({
      'version': 1,
      'contentVersion': AnatomyGuidedModule.contentVersion,
      'selected': _selected,
      'entries': _entries.values.map((entry) => entry.toJson()).toList(),
    });
    _pending = _pending.then((_) async {
      if (!_isCurrent(generation)) return;
      try {
        await _write(key, payload);
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
    _entries.clear();
    _selected = null;
    _changed();
    await flush();
  }

  @override
  void dispose() {
    _disposed = true;
    _ownerChanges?.removeListener(_synchronizeOwner);
    super.dispose();
  }
}
