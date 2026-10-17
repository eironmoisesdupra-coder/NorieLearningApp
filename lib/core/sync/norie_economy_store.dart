import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'norie_economy_models.dart';

/// The durable envelope owns balances, receipts, origin sequences and budgets.
/// Compatibility scalar preferences must be saved only after [flush].
class NorieEconomyStore extends ChangeNotifier {
  NorieEconomyStore(
      {Future<String?> Function()? read,
      Future<bool> Function(String)? write,
      DateTime Function()? clock,
      String Function()? deviceIdFactory})
      : _read = read ?? _readPreferences,
        _write = write ?? _writePreferences,
        _clock = clock ?? DateTime.now,
        _deviceIdFactory = deviceIdFactory ?? const Uuid().v4;
  static final instance = NorieEconomyStore();
  static const storageKey = 'norie.economy.envelope.v1';
  final Future<String?> Function() _read;
  final Future<bool> Function(String) _write;
  final DateTime Function() _clock;
  final String Function() _deviceIdFactory;
  Map<String, dynamic> _state = {
    'version': 1,
    'baseline': economyBaseline({}),
    'checkpoint': null,
    'pending': <dynamic>[]
  };
  Map<String, dynamic>? _reservation;
  String _deviceId = '';
  int _nextSeq = 1, _generation = 0, _revision = 0, _savedRevision = 0;
  bool _loaded = false;
  Future<void> _writes = Zone.root.run(() => Future<void>.value());
  Future<void>? _loading;
  Object? _writeFailure, _loadFailure;
  String? _lastMessage;
  static Future<String?> _readPreferences() async =>
      (await SharedPreferences.getInstance()).getString(storageKey);
  static Future<bool> _writePreferences(String value) async =>
      (await SharedPreferences.getInstance()).setString(storageKey, value);

  String get deviceId => _deviceId;
  int get nextSeq => _nextSeq;
  String? get lastMessage => _lastMessage;
  String? get lastError => (_writeFailure ?? _loadFailure)?.toString();
  bool get active => _state['checkpoint'] != null;
  bool get available => _loaded && _loadFailure == null;
  bool get hasPendingWrites =>
      _savedRevision < _revision || _writeFailure != null;
  Map<String, dynamic> get baseline =>
      economyCopy(_state['baseline'] as Map<String, dynamic>);
  Map<String, dynamic>? get checkpoint => _state['checkpoint'] == null
      ? null
      : economyCopy(_state['checkpoint'] as Map<String, dynamic>);
  Map<String, dynamic>? get reservation =>
      _reservation == null ? null : economyCopy(_reservation!);
  List<Map<String, dynamic>> get pendingOperations =>
      List.unmodifiable((_state['pending'] as List)
          .map((op) => economyCopy(op as Map<String, dynamic>)));
  Map<String, dynamic> get _projection => economyProjection(_state);
  int get totalXp => _projection['total_xp'] as int;
  int get credits => _projection['credits'] as int;
  int get streakShields => _projection['streak_shields'] as int;
  Set<String> get ownedShopItems => Set.unmodifiable(
      (_projection['owned_shop_items'] as List).cast<String>());
  Set<String> get pendingPurchases => Set.unmodifiable(pendingOperations
      .where((op) =>
          op['kind'] == 'spend' &&
          op['item_id'] != null &&
          (active || op['reservation_id'] != null))
      .map((op) => op['item_id'] as String));
  DateTime? get reservationExpiresAt => _reservation == null
      ? null
      : DateTime.parse(_reservation!['expires_at'] as String);
  bool get _validBudget =>
      active &&
      _reservation != null &&
      _reservation!['device_id'] == _deviceId &&
      _clock().toUtc().isBefore(reservationExpiresAt!);
  int get offlineCreditRemaining {
    if (!_validBudget) return 0;
    final pending = pendingOperations
        .where((op) =>
            op['kind'] == 'spend' &&
            op['reservation_id'] == _reservation!['id'])
        .fold<int>(0, (sum, op) => sum - (op['credits'] as int));
    final amount = (_reservation!['limit'] as int) -
        (_reservation!['spent'] as int) -
        pending;
    return amount > 0 ? amount : 0;
  }

  int get offlineShieldsRemaining {
    if (!_validBudget) return 0;
    final pending = pendingOperations
        .where((op) =>
            op['kind'] == 'consume_shield' &&
            op['reservation_id'] == _reservation!['id'])
        .length;
    final amount = (_reservation!['shield_limit'] as int) -
        (_reservation!['shields_spent'] as int) -
        pending;
    return amount > 0 ? amount : 0;
  }

  bool hasClaim(String key) =>
      (_projection['claim_keys'] as List).contains(key);
  Map<String, dynamic> exportState() {
    if (_loadFailure != null) {
      throw StateError('Recover the quarantined economy before export.');
    }
    return economyCopy(_state);
  }

  static Map<String, dynamic> validateState(Object? raw) =>
      economyValidate(raw);
  static Map<String, dynamic> merge(Object? a, Object? b) => economyMerge(a, b);
  String _newDevice() {
    final id = _deviceIdFactory();
    if (!economyUuid(id)) {
      throw const FormatException('Device factory must return a UUID.');
    }
    return id;
  }

  void _ready() {
    if (!_loaded || _loadFailure != null) {
      throw StateError('Load or recover economy before changing it.');
    }
  }

  Map<String, dynamic> _envelope(
          {Map<String, dynamic>? state,
          Map<String, dynamic>? budget,
          bool replaceBudget = false,
          String? device,
          int? sequence}) =>
      {
        'local_version': 1,
        ...(state ?? _state),
        'device_id': device ?? _deviceId,
        'next_seq': sequence ?? _nextSeq,
        'reservation': replaceBudget ? budget : _reservation
      };

  Future<void> load(Map<String, dynamic> legacy, {bool force = false}) async {
    if (_loaded && !force) return;
    if (_loading != null) return _loading;
    final generation = _generation;
    final task = () async {
      if (force && hasPendingWrites) {
        // A failed write owns newer in-memory operations than disk. Preserve
        // them for explicit retry instead of replacing them with an old file.
        await _writes;
        if (_writeFailure != null) return;
      }
      try {
        final encoded = await _read();
        if (generation != _generation) return;
        if (encoded == null) {
          _state = economyValidate({
            'version': 1,
            'baseline': economyBaseline(legacy),
            'checkpoint': null,
            'pending': []
          });
          _deviceId = _newDevice();
          _nextSeq = 1;
          _reservation = null;
        } else {
          if (utf8.encode(encoded).length > economyMaxBytes) {
            throw const FormatException('Saved economy envelope too large.');
          }
          final local = economyMap(jsonDecode(encoded), 'local envelope');
          economyKeys(
              local,
              {
                'local_version',
                'version',
                'baseline',
                'checkpoint',
                'pending',
                'device_id',
                'next_seq',
                'reservation'
              },
              'local envelope');
          if (local['local_version'] != 1) {
            throw const FormatException('Unknown local economy version.');
          }
          final device = economyString(local['device_id'], 'installation');
          if (!economyUuid(device)) {
            throw const FormatException('Invalid installation UUID.');
          }
          final state = economyValidate({
            for (final key in ['version', 'baseline', 'checkpoint', 'pending'])
              key: local[key]
          });
          final next = economyInt(local['next_seq'], 'next sequence', min: 1);
          final budget = local['reservation'] == null
              ? null
              : economyReservation(local['reservation']);
          if (budget != null && budget['device_id'] != device) {
            throw const FormatException(
                'Saved reservation belongs to another installation.');
          }
          final maxPending = (state['pending'] as List)
              .where((op) => op['device_id'] == device)
              .fold<int>(
                  0,
                  (max, op) => (op['device_seq'] as int) > max
                      ? op['device_seq'] as int
                      : max);
          final accepted = state['checkpoint'] == null
              ? 0
              : ((state['checkpoint']['device_sequences'] as Map)[device]
                      as int? ??
                  0);
          if (next <= maxPending || next <= accepted) {
            throw const FormatException(
                'Saved economy device sequence regressed.');
          }
          _state = state;
          _deviceId = device;
          _nextSeq = next;
          _reservation = budget;
        }
        _loaded = true;
        _loadFailure = null;
        _revision++;
        if (encoded == null) {
          _queueSave();
        } else {
          _savedRevision = _revision;
        }
        notifyListeners();
      } catch (error) {
        if (generation == _generation) {
          _loadFailure = error;
          _loaded = false;
          notifyListeners();
          // Quarantine the canonical file. Core lessons still open using a
          // read-only legacy display; neither retry nor cloud may overwrite it.
          _state = {
            'version': 1,
            'baseline': economyBaseline(legacy),
            'checkpoint': null,
            'pending': <dynamic>[]
          };
          _reservation = null;
        }
      }
    }();
    _loading = task;
    try {
      await task;
    } finally {
      if (generation == _generation) _loading = null;
    }
  }

  /// Once receipts exist, a scalar snapshot cannot safely change their baseline.
  void applyLegacy(Map<String, dynamic> legacy) {
    _ready();
    if (active || pendingOperations.isNotEmpty) return;
    _state = economyValidate({
      'version': 1,
      'baseline': economyBaseline(legacy),
      'checkpoint': null,
      'pending': []
    });
    _changed();
  }

  void reset(Map<String, dynamic> legacy) {
    final state = economyValidate({
      'version': 1,
      'baseline': economyBaseline(legacy),
      'checkpoint': null,
      'pending': []
    });
    final device = _newDevice();
    _generation++;
    _loading = null;
    _loaded = true;
    _loadFailure = null;
    _writeFailure = null;
    _state = state;
    _reservation = null;
    _deviceId = device;
    _nextSeq = 1;
    _lastMessage = null;
    _changed();
  }

  void collapseGuestToBaseline() {
    _ready();
    if (active || _reservation != null) {
      throw StateError('Only a guest economy can be collapsed.');
    }
    _state = economyValidate({
      'version': 1,
      'baseline': {
        ..._projection,
        'modified_at': _clock().toUtc().toIso8601String()
      },
      'checkpoint': null,
      'pending': []
    });
    _deviceId = _newDevice();
    _nextSeq = 1;
    _changed();
  }

  void prepareGuestAdoption(Map<String, dynamic>? canonicalCheckpoint) {
    _ready();
    if (active) return;
    if (canonicalCheckpoint == null) {
      collapseGuestToBaseline();
      return;
    }
    final cp = economyCheckpoint(canonicalCheckpoint);
    _state = economyValidate({..._state, 'checkpoint': cp});
    _reservation = null;
    _lastMessage =
        'Account balance and purchases restored. Pending guest learning will sync.';
    _changed();
  }

  Future<void> recoverRetiredDevice(
      {required bool Function() stillCurrent}) async {
    _ready();
    if (!stillCurrent()) return;
    final generation = _generation;
    final complete = Completer<void>();
    _writes = _writes.then((_) async {
      if (generation != _generation || !stillCurrent()) {
        complete.complete();
        return;
      }
      try {
        if (_writeFailure != null) {
          throw StateError(
              'Retry pending economy writes before device recovery.');
        }
        final device = _newDevice();
        while (true) {
          final revision = _revision;
          if (!await _write(jsonEncode(_envelope(
              budget: null,
              replaceBudget: true,
              device: device,
              sequence: 1)))) {
            throw StateError('Recovered economy identity could not be saved.');
          }
          if (generation != _generation || !stillCurrent()) {
            if (!await _write(jsonEncode(_envelope()))) {
              throw StateError('Economy recovery compensation failed.');
            }
            complete.complete();
            return;
          }
          if (revision != _revision) continue;
          _deviceId = device;
          _nextSeq = 1;
          _reservation = null;
          _revision++;
          _savedRevision = _revision;
          _lastMessage =
              'Device identity recovered. Sync again to fund offline purchases.';
          notifyListeners();
          complete.complete();
          return;
        }
      } catch (error, stack) {
        if (generation == _generation) _writeFailure ??= error;
        complete.completeError(error, stack);
      }
    });
    await complete.future;
  }

  void applyValidatedState(Object? raw, {bool preserveLocalPending = false}) {
    if (raw == null) return;
    final imported = economyValidate(raw);
    if (preserveLocalPending && active && imported['checkpoint'] == null) {
      return;
    }
    final baselineOnlyOverLedger = active && imported['checkpoint'] == null;
    final state = baselineOnlyOverLedger
        ? _state
        : preserveLocalPending
            ? economyMerge(_state, imported)
            : imported;
    final mergedCheckpoint = state['checkpoint'] as Map<String, dynamic>?;
    if (preserveLocalPending &&
        _reservation != null &&
        pendingOperations.any((op) =>
            op['kind'] != 'reward' &&
            op['reservation_id'] == _reservation!['id'] &&
            economyCovered(op, mergedCheckpoint))) {
      // Portable checkpoints have no authoritative budget settlement counters.
      // A covered operation may have been accepted or rejected: refetch rather
      // than reopen an allowance or invent a cumulative spent amount.
      _reservation = null;
    }
    final device =
        preserveLocalPending && _deviceId.isNotEmpty ? _deviceId : _newDevice();
    if (!preserveLocalPending) {
      _reservation = null;
      _nextSeq = 1;
    }
    _generation++;
    _loading = null;
    _loaded = true;
    _loadFailure = null;
    _writeFailure = null;
    _state = state;
    _deviceId = device;
    for (final op
        in pendingOperations.where((op) => op['device_id'] == device)) {
      if (_nextSeq <= (op['device_seq'] as int)) {
        _nextSeq = (op['device_seq'] as int) + 1;
      }
    }
    final accepted = checkpoint?['device_sequences'] as Map?;
    if (_nextSeq <= (accepted?[device] as int? ?? 0)) {
      _nextSeq = (accepted![device] as int) + 1;
    }
    _changed();
  }

  bool reward(String claimKey, {int xp = 0, int credits = 0}) {
    if (_loadFailure != null) return false;
    _ready();
    economyString(claimKey, 'claim');
    economyInt(xp, 'reward XP', max: economyMaxAmount);
    economyInt(credits, 'reward credits', max: economyMaxAmount);
    if (hasClaim(claimKey) || xp + credits == 0) return false;
    _append(kind: 'reward', claim: claimKey, xp: xp, credits: credits);
    return true;
  }

  bool spend(int amount, {String? itemId, bool requiresReservation = false}) {
    if (_loadFailure != null) return false;
    _ready();
    economyInt(amount, 'spend amount', min: 1, max: economyMaxAmount);
    if (itemId != null) economyString(itemId, 'shop item', max: 128);
    if (itemId != null &&
        itemId != 'streak-shield' &&
        (ownedShopItems.contains(itemId) ||
            pendingPurchases.contains(itemId))) {
      return false;
    }
    final reserved = requiresReservation || active;
    if (amount > credits || reserved && amount > offlineCreditRemaining) {
      _lastMessage = reserved
          ? 'Connect to sync your account spending allowance.'
          : 'Not enough credits.';
      notifyListeners();
      return false;
    }
    _append(
        kind: 'spend',
        claim: 'spend:${const Uuid().v4()}',
        credits: -amount,
        item: itemId,
        reservation: reserved ? _reservation!['id'] as String : null);
    return true;
  }

  bool consumeShield({bool requiresReservation = false}) {
    if (_loadFailure != null) return false;
    _ready();
    final reserved = requiresReservation || active;
    if (streakShields < 1 || reserved && offlineShieldsRemaining < 1) {
      _lastMessage = reserved
          ? 'Connect to sync your account shield allowance.'
          : 'No streak shields available.';
      notifyListeners();
      return false;
    }
    _append(
        kind: 'consume_shield',
        claim: 'shield:${const Uuid().v4()}',
        reservation: reserved ? _reservation!['id'] as String : null);
    return true;
  }

  void _append(
      {required String kind,
      required String claim,
      int xp = 0,
      int credits = 0,
      String? item,
      String? reservation}) {
    final op = economyOperation({
      'id': const Uuid().v4(),
      'device_id': _deviceId,
      'device_seq': _nextSeq,
      'kind': kind,
      'claim_key': claim,
      'xp': xp,
      'credits': credits,
      'item_id': item,
      'occurred_at': _clock().toUtc().toIso8601String(),
      'reservation_id': reservation
    });
    _state = economyValidate({
      ..._state,
      'pending': [..._state['pending'] as List, op]
    });
    _nextSeq++;
    _lastMessage = null;
    _changed();
  }

  void _changed() {
    _revision++;
    _queueSave();
    notifyListeners();
  }

  void _queueSave({bool retry = false}) {
    final generation = _generation;
    _writes = _writes.then((_) async {
      if (generation != _generation) return;
      final revision = _revision;
      try {
        if (!_loaded || _loadFailure != null) {
          throw StateError('Economy storage needs recovery.');
        }
        if (!await _write(jsonEncode(_envelope()))) {
          throw StateError('Economy transaction could not be saved.');
        }
        if (generation != _generation) return;
        _savedRevision = revision;
        if (retry) _writeFailure = null;
      } catch (error) {
        if (generation == _generation) _writeFailure ??= error;
      }
      notifyListeners();
    });
  }

  Future<void> flush({bool retry = false}) async {
    if (_loadFailure != null) {
      throw StateError('Economy storage needs recovery: $_loadFailure');
    }
    if (retry) _queueSave(retry: true);
    while (true) {
      final pending = _writes;
      await pending;
      if (identical(pending, _writes)) break;
    }
    if (_writeFailure != null) {
      throw StateError('Economy transaction needs retry: $_writeFailure');
    }
  }

  /// A checkpoint is visible and ACKable only after one durable envelope write.
  /// Rewards queued while that I/O runs are included before publishing it.
  Future<void> applyServerResult(Map<String, dynamic> result,
      {required bool Function() stillCurrent}) async {
    _ready();
    if (!stillCurrent()) return;
    if (result['version'] != 1 || result['must_recover'] is! bool) {
      throw const FormatException('Invalid economy server result.');
    }
    final cp = economyCheckpoint(result['checkpoint']);
    final incomingBudget = result['reservation'] == null
        ? null
        : economyReservation(result['reservation']);
    if (incomingBudget != null && incomingBudget['device_id'] != _deviceId) {
      throw const FormatException(
          'Server allowance belongs to another device.');
    }
    final serverSeq =
        economyInt(result['device_seq'], 'server device sequence');
    final accepted = economyStrings(result['accepted'], 'accepted IDs',
            max: economyMaxOperations)
        .toSet();
    final rejected = result['rejected'];
    if (rejected is! List || rejected.length > economyMaxOperations) {
      throw const FormatException('Invalid server rejections.');
    }
    final rejectedIds = <String>{};
    for (final raw in rejected) {
      final item = economyMap(raw, 'rejection');
      economyKeys(item, {'id', 'reason'}, 'rejection');
      rejectedIds.add(economyString(item['id'], 'rejected ID'));
      economyString(item['reason'], 'rejection reason');
    }
    if (accepted.intersection(rejectedIds).isNotEmpty) {
      throw const FormatException('Operation accepted and rejected together.');
    }
    final generation = _generation;
    final complete = Completer<void>();
    _writes = _writes.then((_) async {
      if (generation != _generation || !stillCurrent()) {
        complete.complete();
        return;
      }
      try {
        if (_writeFailure != null) {
          throw StateError(
              'Flush failed economy transactions before applying a server checkpoint.');
        }
        while (true) {
          final revision = _revision;
          if (incomingBudget != null &&
              _reservation != null &&
              incomingBudget['id'] == _reservation!['id']) {
            for (final key in [
              'limit',
              'spent',
              'shield_limit',
              'shields_spent'
            ]) {
              if ((incomingBudget[key] as int) < (_reservation![key] as int)) {
                throw const FormatException(
                    'Server allowance settlement counters regressed.');
              }
            }
          }
          final merged = economyMerge({
            ..._state,
            'pending': []
          }, {
            'version': 1,
            'baseline': _state['baseline'],
            'checkpoint': cp,
            'pending': []
          });
          final old = _state['checkpoint'] as Map<String, dynamic>?;
          if (old != null &&
              (cp['through_seq'] as int) < (old['through_seq'] as int)) {
            throw const FormatException('Server checkpoint regressed.');
          }
          for (final op in pendingOperations) {
            if (accepted.contains(op['id']) && !economyCovered(op, cp)) {
              throw const FormatException(
                  'Accepted operation lacks durable checkpoint coverage.');
            }
          }
          final next = economyValidate({
            ...merged,
            'pending': pendingOperations
                .where((op) =>
                    !rejectedIds.contains(op['id']) && !economyCovered(op, cp))
                .toList()
          });
          final recover = result['must_recover'] as bool;
          final device = recover ? _newDevice() : _deviceId;
          var sequence = recover ? 1 : _nextSeq;
          final covered = (cp['device_sequences'] as Map)[device] as int? ?? 0;
          if (sequence <= covered) sequence = covered + 1;
          if (!recover && sequence <= serverSeq) sequence = serverSeq + 1;
          final budget = recover ? null : incomingBudget;
          if (!await _write(jsonEncode(_envelope(
              state: next,
              budget: budget,
              replaceBudget: true,
              device: device,
              sequence: sequence)))) {
            throw StateError('Server checkpoint could not be saved.');
          }
          if (generation != _generation || !stillCurrent()) {
            // Account reset/import may already have installed a newer local state.
            if (!await _write(jsonEncode(_envelope()))) {
              throw StateError('Economy account-change compensation failed.');
            }
            complete.complete();
            return;
          }
          if (revision != _revision) continue;
          _state = next;
          _reservation = budget;
          _deviceId = device;
          _nextSeq = sequence;
          _revision++;
          _savedRevision = _revision;
          if (rejectedIds.isNotEmpty) {
            _lastMessage =
                'Some pending account purchases were declined. Credits and items have been synced.';
          }
          if (recover) {
            _lastMessage =
                'Account checkpoint recovered. Sync again to fund this device.';
          }
          notifyListeners();
          complete.complete();
          return;
        }
      } catch (error, stack) {
        if (error is! FormatException && generation == _generation) {
          _writeFailure ??= error;
          notifyListeners();
        }
        complete.completeError(error, stack);
      }
    });
    await complete.future;
  }

  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _generation++;
    _writes = Zone.root.run(() => Future<void>.value());
    _loading = null;
    _loaded = false;
    _loadFailure = null;
    _writeFailure = null;
    _savedRevision = _revision;
  }
}
