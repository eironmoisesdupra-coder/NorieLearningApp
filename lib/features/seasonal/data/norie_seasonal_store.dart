import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../domain/norie_seasonal_models.dart';
import 'norie_seasonal_catalog.dart';

typedef NorieSeasonalRead = Future<String?> Function(String key);
typedef NorieSeasonalWrite = Future<bool> Function(String key, String value);

/// Keepsakes are portable inside the account snapshot envelope. Local storage
/// is reset by the snapshot owner coordinator. Standalone stores may bindOwner.
class NorieSeasonalStore extends ChangeNotifier {
  NorieSeasonalStore(
      {NorieSeasonalRead? read,
      NorieSeasonalWrite? write,
      DateTime Function()? clock})
      : _read = read ?? _defaultRead,
        _write = write ?? _defaultWrite,
        _clock = clock ?? DateTime.now;
  static final instance = NorieSeasonalStore();
  static Future<String?> _defaultRead(String key) async =>
      (await SharedPreferences.getInstance()).getString(key);
  static Future<bool> _defaultWrite(String key, String value) async =>
      (await SharedPreferences.getInstance()).setString(key, value);
  final NorieSeasonalRead _read;
  final NorieSeasonalWrite _write;
  final DateTime Function() _clock;
  String _owner = 'guest';
  int _epoch = 0;
  bool _loaded = false;
  List<Map<String, dynamic>> _receipts = [];
  Future<void> _tail = Future<void>.value();

  /// Test fixtures must drain writes before replacing their asynchronous zone.
  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _tail = Future<void>.value();
  }

  String get owner => _owner;
  bool get loaded => _loaded;
  Set<String> get earnedRewards =>
      Set.unmodifiable(_receipts.map((r) => r['reward_id'] as String));
  bool isEarned(String id) => earnedRewards.contains(id);
  void bindOwner(String owner) {
    if (owner.isEmpty || owner.length > 256) {
      throw ArgumentError.value(owner, 'owner');
    }
    if (owner == _owner) return;
    _owner = owner;
    _epoch++;
    _loaded = false;
    _receipts = [];
    notifyListeners();
  }

  String _key(String owner) =>
      'norie.seasonal.v1.${Uri.encodeComponent(owner)}';
  bool _current(String owner, int epoch, bool Function()? guard) =>
      owner == _owner && epoch == _epoch && (guard?.call() ?? true);
  Future<T> _serial<T>(Future<T> Function() action) {
    final result = _tail.then((_) => action());
    _tail = result.then<void>((_) {}, onError: (Object _, StackTrace __) {});
    return result;
  }

  Future<void> _load(String owner, int epoch, {bool force = false}) async {
    if (!_current(owner, epoch, null) || (_loaded && !force)) return;
    final raw = await _read(_key(owner));
    if (!_current(owner, epoch, null)) return;
    final state = raw == null ? emptyState() : validatedState(jsonDecode(raw));
    _receipts = (state['receipts'] as List).cast<Map<String, dynamic>>();
    _loaded = true;
    notifyListeners();
  }

  Future<void> load({bool force = false}) {
    final owner = _owner, epoch = _epoch;
    return _serial(() => _load(owner, epoch, force: force));
  }

  bool complete(NorieSeason season, Set<String> completed) =>
      season.missions.isNotEmpty &&
      season.missions.every(
          (m) => m.topicIds.isNotEmpty && m.topicIds.every(completed.contains));
  static Map<String, dynamic> emptyState() =>
      {'version': 1, 'receipts': <Map<String, dynamic>>[]};
  Map<String, dynamic> exportState() => {
        'version': 1,
        'receipts': _receipts.map((r) => Map<String, dynamic>.from(r)).toList()
      };
  static Map<String, dynamic> validatedState(Object? value) {
    if (value is! Map || value['version'] != 1 || value['receipts'] is! List) {
      throw const FormatException('Invalid seasonal state');
    }
    final rows = value['receipts'] as List;
    if (rows.length > NorieSeasonalCatalog.seasons.length) {
      throw const FormatException('Too many keepsakes');
    }
    final seen = <String>{};
    final receipts = <Map<String, dynamic>>[];
    for (final row in rows) {
      if (row is! Map ||
          row['season_id'] is! String ||
          row['reward_id'] is! String ||
          row['claimed_at'] is! String) {
        throw const FormatException('Invalid keepsake receipt');
      }
      final seasons = NorieSeasonalCatalog.seasons.where(
          (s) => s.id == row['season_id'] && s.rewardId == row['reward_id']);
      final time = DateTime.tryParse(row['claimed_at'] as String);
      if (seasons.length != 1 ||
          time == null ||
          !time.isUtc ||
          seasons.single.statusAt(time) != NorieSeasonStatus.active ||
          !seen.add(row['reward_id'] as String)) {
        throw const FormatException('Invalid keepsake evidence');
      }
      receipts.add({
        'season_id': row['season_id'],
        'reward_id': row['reward_id'],
        'claimed_at': time.toIso8601String()
      });
    }
    receipts.sort((a, b) =>
        (a['reward_id'] as String).compareTo(b['reward_id'] as String));
    return {'version': 1, 'receipts': receipts};
  }

  /// Deterministic union; earliest valid receipt wins duplicate rewards.
  static Map<String, dynamic> merge(Object? primary, Object? secondary) {
    final a = validatedState(primary ?? emptyState()),
        b = validatedState(secondary ?? emptyState());
    final rows = <String, Map<String, dynamic>>{};
    for (final r in [...a['receipts'] as List, ...b['receipts'] as List]
        .cast<Map<String, dynamic>>()) {
      final old = rows[r['reward_id']];
      if (old == null ||
          (r['claimed_at'] as String).compareTo(old['claimed_at'] as String) <
              0) {
        rows[r['reward_id'] as String] = r;
      }
    }
    return validatedState({'version': 1, 'receipts': rows.values.toList()});
  }

  Future<bool> claim(NorieSeason season, Set<String> completed,
      {bool Function()? stillCurrent}) {
    final owner = _owner, epoch = _epoch, topics = Set<String>.of(completed);
    return _serial(() async {
      await _load(owner, epoch);
      if (!_current(owner, epoch, stillCurrent)) return false;
      final published =
          NorieSeasonalCatalog.seasons.where((s) => identical(s, season));
      final now = _clock().toUtc();
      if (published.isEmpty ||
          season.statusAt(now) != NorieSeasonStatus.active ||
          !complete(season, topics) ||
          isEarned(season.rewardId)) {
        return false;
      }
      return _persist(
          owner,
          epoch,
          [
            ..._receipts,
            {
              'season_id': season.id,
              'reward_id': season.rewardId,
              'claimed_at': now.toIso8601String()
            }
          ],
          stillCurrent: stillCurrent);
    });
  }

  Future<bool> _persist(
      String owner, int epoch, List<Map<String, dynamic>> rows,
      {bool Function()? stillCurrent}) async {
    final state = validatedState({'version': 1, 'receipts': rows});
    if (!_current(owner, epoch, stillCurrent)) return false;
    final previousRaw = await _read(_key(owner));
    if (!_current(owner, epoch, stillCurrent)) return false;
    if (!await _write(_key(owner), jsonEncode(state))) {
      throw StateError('Keepsake save failed. Please try again.');
    }
    if (!_current(owner, epoch, stillCurrent)) {
      await _compensateStaleWrite(owner, epoch, previousRaw);
      return false;
    }
    final next = (state['receipts'] as List).cast<Map<String, dynamic>>();
    final changed = jsonEncode(_receipts) != jsonEncode(next);
    _receipts = next;
    _loaded = true;
    if (changed) notifyListeners();
    return true;
  }

  // A platform write cannot be cancelled. Repair its disk effect before the
  // serialized queue advances, preserving any newer authorized account apply.
  Future<void> _compensateStaleWrite(
      String owner, int attemptedEpoch, String? previousRaw) async {
    while (true) {
      final observedEpoch = _epoch;
      final replacement =
          owner == _owner && _loaded && observedEpoch != attemptedEpoch
              ? jsonEncode(exportState())
              : previousRaw ?? jsonEncode(emptyState());
      if (!await _write(_key(owner), replacement)) {
        throw StateError('The interrupted keepsake save needs recovery.');
      }
      if (owner != _owner || observedEpoch == _epoch) return;
    }
  }

  /// Replace a validated account snapshot; caller must await flush before success.
  void applyValidatedState(Object? value, {bool Function()? stillCurrent}) {
    final state = validatedState(value);
    if (!(stillCurrent?.call() ?? true)) return;
    _epoch++;
    _receipts = (state['receipts'] as List).cast<Map<String, dynamic>>();
    _loaded = true;
    notifyListeners();
  }

  Future<bool> flush({bool Function()? stillCurrent}) {
    return _serial(() async {
      // Flush the latest authorized snapshot, including a replacement staged
      // while another account import was awaiting its own durable writes.
      while (true) {
        final owner = _owner, epoch = _epoch;
        final rows =
            _receipts.map((r) => Map<String, dynamic>.from(r)).toList();
        if (await _persist(owner, epoch, rows, stillCurrent: stillCurrent)) {
          return true;
        }
        if (!(stillCurrent?.call() ?? true) ||
            (owner == _owner && epoch == _epoch)) {
          throw StateError(
              'Keepsake save cancelled after the learner changed.');
        }
      }
    });
  }

  Future<bool> applyState(Object? value, {bool Function()? stillCurrent}) {
    final state = validatedState(value), owner = _owner, epoch = _epoch;
    final rows = (state['receipts'] as List).cast<Map<String, dynamic>>();
    return _serial(
        () => _persist(owner, epoch, rows, stillCurrent: stillCurrent));
  }

  Future<bool> reset({bool Function()? stillCurrent}) =>
      applyState(emptyState(), stillCurrent: stillCurrent);
}
