import 'dart:convert';
import 'package:flutter/foundation.dart';

import 'package:uuid/uuid.dart';

import '../../features/classroom/data/norie_classroom_store.dart';
import '../../features/seasonal/data/norie_seasonal_store.dart';
import 'norie_sync_event_journal.dart';

/// Portable extensions to the legacy progress read model. Cloud RPCs store
/// these separately; older app binaries never receive unsupported state keys.
abstract final class NorieFeatureState {
  /// Mirrors the progression fixture boundary; never used during app recovery.
  @visibleForTesting
  static void resetAsyncQueuesForTesting() {
    // ignore: invalid_use_of_visible_for_testing_member
    NorieSyncEventJournal.instance.resetAsyncQueuesForTesting();
    // ignore: invalid_use_of_visible_for_testing_member
    NorieClassroomStore.instance.resetAsyncQueuesForTesting();
    // ignore: invalid_use_of_visible_for_testing_member
    NorieSeasonalStore.instance.resetAsyncQueuesForTesting();
  }

  static Object? _captureFailure;
  static final List<Object> _loadFailures = [];

  static Map<String, dynamic> exportState() => {
        'sync_event_journal': NorieSyncEventJournal.instance.exportState(),
        'classroom_state': NorieClassroomStore.instance.exportState(),
        'seasonal_state': NorieSeasonalStore.instance.exportState(),
      };

  static void validate(Map<String, dynamic> state) {
    if (state.containsKey('sync_event_journal')) {
      NorieSyncEventJournal.validateState(state['sync_event_journal']);
    }
    if (state.containsKey('classroom_state')) {
      NorieClassroomStore.validatedState(state['classroom_state']);
    }
    if (state.containsKey('seasonal_state')) {
      NorieSeasonalStore.validatedState(state['seasonal_state']);
    }
    final extensions = {
      for (final key in [
        'sync_event_journal',
        'classroom_state',
        'seasonal_state'
      ])
        if (state.containsKey(key)) key: state[key],
    };
    if (utf8.encode(jsonEncode(extensions)).length > 4 * 1024 * 1024) {
      throw const FormatException(
          'Saved classroom, seasonal and event data is too large.');
    }
  }

  static Future<void> load({bool force = false}) async {
    _loadFailures.clear();
    // Damaged optional feature files must not prevent core offline lessons
    // opening. Retain the failure so sync/backup cannot silently overwrite them.
    await Future.wait([
      for (final operation in <Future<void> Function()>[
        () => NorieSyncEventJournal.instance.load(force: force),
        () => NorieClassroomStore.instance.load(force: force),
        () => NorieSeasonalStore.instance.load(force: force),
      ])
        () async {
          try {
            await operation();
          } catch (error) {
            _loadFailures.add(error);
          }
        }(),
    ]);
    _captureFailure = null;
    if (_loadFailures.isEmpty) {
      // A feature's durable commit can precede its notification/event write.
      // Reconcile these idempotent facts after a crash without replaying awards.
      recordClassroomFacts();
      recordSeasonalFacts();
    }
  }

  static void applyValidatedState(Map<String, dynamic> state) {
    validate(state);
    // Legacy imports have no event history: preserve their existing numeric
    // totals without inventing receipts or replaying their embedded rewards.
    NorieSyncEventJournal.instance.applyValidatedState(
        state['sync_event_journal'] ?? NorieSyncEventJournal.emptyState);
    NorieClassroomStore.instance.applyValidatedState(
        state['classroom_state'] ?? NorieClassroomStore.emptyState);
    NorieSeasonalStore.instance.applyValidatedState(
        state['seasonal_state'] ?? NorieSeasonalStore.emptyState());
    _captureFailure = null;
    _loadFailures.clear();
  }

  static Map<String, dynamic> merge(
          Map<String, dynamic> a, Map<String, dynamic> b) =>
      {
        'sync_event_journal': NorieSyncEventJournal.merge(
            a['sync_event_journal'], b['sync_event_journal']),
        'classroom_state': NorieClassroomStore.merge(
            a['classroom_state'] ?? NorieClassroomStore.emptyState,
            b['classroom_state'] ?? NorieClassroomStore.emptyState),
        'seasonal_state': NorieSeasonalStore.merge(
            a['seasonal_state'] ?? NorieSeasonalStore.emptyState(),
            b['seasonal_state'] ?? NorieSeasonalStore.emptyState()),
      };

  /// A bounded migration receipt, never a command that awards currency.
  /// Failure cannot cancel already performed local learning; explicit saves
  /// and cloud sync report it instead of silently dropping an accepted receipt.
  static void recordFact(String type, String entity,
      {Map<String, dynamic> data = const {}}) {
    if (entity.isEmpty) return;
    try {
      NorieSyncEventJournal.instance.record(
          type: type,
          entityId: entity,
          data: data,
          eventId: const Uuid()
              .v5(Namespace.url.value, jsonEncode(['norie', type, entity])));
    } catch (error) {
      _captureFailure = error;
    }
  }

  static void recordClassroomFacts() {
    for (final assignment in NorieClassroomStore.instance.assignments) {
      recordFact('classroom_assignment', assignment.id);
    }
    for (final submission in NorieClassroomStore.instance.submissions) {
      recordFact('classroom_submission', submission.id);
    }
  }

  static void recordSeasonalFacts() {
    for (final reward in NorieSeasonalStore.instance.earnedRewards) {
      recordFact('season_reward_earned', reward);
    }
  }

  static Future<void> flush({bool retry = false}) async {
    // An unloaded store may hold an empty in-memory placeholder. Never let a
    // retry persist that placeholder over the damaged file needing recovery.
    if (_loadFailures.isNotEmpty) {
      throw StateError(
          'Some saved feature data needs recovery: ${_loadFailures.first}');
    }
    await Future.wait([
      NorieSyncEventJournal.instance.flush(retry: retry),
      NorieClassroomStore.instance.flush(),
      NorieSeasonalStore.instance.flush(),
    ]);
    if (_captureFailure != null) {
      throw StateError('Operation receipts need attention: $_captureFailure');
    }
  }
}
