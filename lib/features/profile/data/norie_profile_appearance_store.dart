import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/norie_profile_appearance.dart';

class NorieProfileAppearanceStore extends ChangeNotifier {
  static final instance = NorieProfileAppearanceStore();
  static const storageKey = 'norie.profile.appearance.v1';
  NorieProfileAppearance _value = const NorieProfileAppearance();
  final List<NorieProfileAppearance> _presets = [];
  int _revision = 0, _rankLevel = 1;
  bool _loaded = false;
  Future<void> _writes = Future.value();
  NorieProfileAppearance get value => _value;
  int get revision => _revision;
  int get rankLevel => _rankLevel;
  List<NorieProfileAppearance> get presets => List.unmodifiable(_presets);

  /// Call after the previous test has drained this store's writes.
  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _writes = Future<void>.value();
  }

  Future<void> load({bool force = false}) async {
    if (force) {
      _loaded = false;
      _revision++;
    }
    if (_loaded) return;
    final revision = _revision;
    final prefs = await SharedPreferences.getInstance();
    if (revision != _revision || _loaded) return;
    final raw = prefs.getString(storageKey);
    if (force) {
      _value = const NorieProfileAppearance();
      _presets.clear();
      _rankLevel = 1;
    }
    var restored = false;
    if (raw != null) {
      try {
        applyValidatedState(validateState(jsonDecode(raw)));
        restored = true;
      } on FormatException {
        /* Leave corrupt local snapshots at safe defaults. */
      }
    }
    _loaded = true;
    if (force && !restored) notifyListeners();
  }

  Map<String, dynamic> exportState() => {
        'version': 1,
        'rankLevel': _rankLevel,
        'appearance': _value.toJson(),
        'presets': _presets.map((p) => p.toJson()).toList()
      };

  static Map<String, dynamic> validateState(Object? raw) {
    if (raw is! Map) {
      throw const FormatException('Invalid appearance snapshot.');
    }
    final allowed = raw.containsKey('appearance')
        ? const {'version', 'rankLevel', 'appearance', 'presets'}
        : const {'avatar', 'frame', 'palette', 'pose', 'accent', 'showcase'};
    if (raw.keys.any((key) => key is! String || !allowed.contains(key))) {
      throw const FormatException('Unknown appearance snapshot fields.');
    }
    // Bare appearance values support the editor's reset/import API.
    final appearance =
        NorieProfileAppearance.fromJson(raw['appearance'] ?? raw);
    final rank = raw['rankLevel'] ?? 1;
    final presets = raw['presets'] ?? <dynamic>[];
    if (raw['version'] != null && raw['version'] != 1 ||
        rank is! int ||
        rank < 1 ||
        rank > 50 ||
        presets is! List ||
        presets.length > 5) {
      throw const FormatException('Invalid appearance inventory.');
    }
    final normalized = presets.map(NorieProfileAppearance.fromJson).toList();
    return {
      'version': 1,
      'rankLevel': rank,
      'appearance': appearance.toJson(),
      'presets': normalized.map((p) => p.toJson()).toList()
    };
  }

  void applyValidatedState(Map<String, dynamic> state) {
    final normalized = validateState(state);
    _value = NorieProfileAppearance.fromJson(normalized['appearance']);
    _rankLevel = normalized['rankLevel'] as int;
    _presets
      ..clear()
      ..addAll(
          (normalized['presets'] as List).map(NorieProfileAppearance.fromJson));
    _loaded = true;
    _revision++;
    notifyListeners();
  }

  Future<void> replaceState(Map<String, dynamic> state) {
    applyValidatedState(state);
    return flush();
  }

  Future<void> reset() => replaceState({
        ...exportState(),
        'appearance': const NorieProfileAppearance().toJson()
      });

  Future<void> unlockRank(int level) {
    final earned = level.clamp(1, 50);
    if (earned <= _rankLevel) return Future.value();
    _rankLevel = earned;
    _revision++;
    notifyListeners();
    return flush();
  }

  Future<void> flush() {
    final revision = _revision;
    final encoded = jsonEncode(exportState());
    final write = _writes.catchError((Object _) {}).then((_) async {
      if (revision != _revision) return;
      final prefs = await SharedPreferences.getInstance();
      if (revision != _revision) return;
      if (!await prefs.setString(storageKey, encoded)) {
        throw StateError('Appearance could not be saved on this device.');
      }
    });
    _writes = write;
    return write;
  }

  Future<bool> save(NorieProfileAppearance draft,
      {required int expectedRevision,
      required int level,
      Set<String> trophyIds = const {},
      List<NorieProfileAppearance>? presets,
      bool Function()? stillCurrent}) async {
    if (expectedRevision != _revision || stillCurrent?.call() == false) {
      return false;
    }
    final requested = level.clamp(1, 50);
    final earned = requested > _rankLevel ? requested : _rankLevel;
    // Parse first so unknown identifiers can never enter persisted state.
    NorieProfileAppearance checked;
    try {
      checked = NorieProfileAppearance.fromJson(draft.toJson());
    } on FormatException {
      return false;
    }
    List<NorieProfileAppearance> savedPresets;
    try {
      savedPresets = (presets ?? _presets)
          .map((p) => NorieProfileAppearance.fromJson(p.toJson()))
          .toList();
    } on FormatException {
      return false;
    }
    if (!NorieAppearanceCatalog.canEquip(checked, earned, trophyIds) ||
        savedPresets.length >
            NorieAppearanceCatalog.bundleForLevel(earned).presetCapacity ||
        savedPresets.any(
            (p) => !NorieAppearanceCatalog.canEquip(p, earned, trophyIds))) {
      return false;
    }
    _value = checked;
    _rankLevel = earned;
    _presets
      ..clear()
      ..addAll(savedPresets.toList());
    _revision++;
    notifyListeners();
    final savedRevision = _revision;
    await flush();
    return savedRevision == _revision && stillCurrent?.call() != false;
  }
}
