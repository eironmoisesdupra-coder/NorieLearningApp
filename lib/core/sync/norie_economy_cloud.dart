import 'norie_economy_store.dart';
import 'norie_economy_models.dart';

typedef NorieEconomyRpc = Future<Object?> Function(
    String name, Map<String, dynamic> parameters);

/// Ledger requests share the coordinator's captured account generation. A
/// checkpoint is acknowledged only after the local envelope has reached disk.
class NorieEconomyCloud {
  NorieEconomyCloud({
    required NorieEconomyRpc rpc,
    required Future<void> Function(Map<String, dynamic>, bool Function()) apply,
    required Map<String, dynamic> Function() legacyState,
    NorieEconomyStore? store,
  })  : _rpc = rpc,
        _apply = apply,
        _legacyState = legacyState,
        _store = store ?? NorieEconomyStore.instance;

  final NorieEconomyRpc _rpc;
  final Future<void> Function(Map<String, dynamic>, bool Function()) _apply;
  final Map<String, dynamic> Function() _legacyState;
  final NorieEconomyStore _store;

  Future<Map<String, dynamic>?> status(
      String userId, bool Function() stillCurrent) async {
    if (!stillCurrent()) return null;
    final value = await _rpc('norie_economy_status', {'p_user_id': userId});
    if (!stillCurrent() || value == null) return null;
    return economyCheckpoint(value);
  }

  Future<void> reconcile(String userId, bool Function() stillCurrent) async {
    if (!stillCurrent()) return;
    await _store.flush(retry: true);
    if (!stillCurrent()) return;
    // Bound this pass to the captured queue; newly earned rewards schedule the
    // next coordinator pass rather than keeping a busy learner in this loop.
    var remaining = _store.pendingOperations.length;
    var recoveryAttempted = false;
    do {
      if (!stillCurrent()) return;
      final device = _store.deviceId;
      final operations = _store.pendingOperations.take(500).toList();
      final legacy = Map<String, dynamic>.from(_legacyState())
        ..remove('economy_state');
      final response = await _rpc('norie_economy_sync', {
        'p_user_id': userId,
        'p_device_id': device,
        'p_baseline': {..._store.baseline, 'legacy_state': legacy},
        'p_operations': operations,
      });
      if (!stillCurrent()) return;
      final result = economyMap(response, 'server result');
      if (result['must_recover'] == true) {
        if (recoveryAttempted) {
          throw StateError('The account device could not recover.');
        }
        recoveryAttempted = true;
        await _store.recoverRetiredDevice(stillCurrent: stillCurrent);
        if (!stillCurrent()) return;
        continue;
      }
      await _apply(result, stillCurrent);
      if (!stillCurrent()) return;
      await _store.flush(retry: true);
      if (!stillCurrent()) return;
      final checkpoint = _store.checkpoint;
      if (checkpoint == null) {
        throw StateError('The account checkpoint was not saved.');
      }
      final acknowledged = await _rpc('norie_economy_ack', {
        'p_user_id': userId,
        'p_device_id': device,
        'p_epoch': checkpoint['epoch'],
        'p_checkpoint_id': checkpoint['id'],
        'p_through_seq': checkpoint['through_seq'],
      });
      if (!stillCurrent()) return;
      if (acknowledged != true) {
        throw StateError('The account checkpoint was not acknowledged.');
      }
      remaining -= operations.length;
      if (remaining <= 0 || operations.isEmpty) break;
    } while (true);
    if (!stillCurrent()) return;
    await _rpc('norie_economy_compact', {'p_user_id': userId});
  }
}
