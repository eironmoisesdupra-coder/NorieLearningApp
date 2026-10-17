import 'package:flutter/material.dart';
import '../account/norie_account_service.dart';
import '../cloud/norie_cloud_sync.dart';
import '../cloud/supabase_config.dart';
import 'norie_economy_store.dart';

/// Account controls are optional: lessons and earning remain available offline.
class NorieEconomyScreen extends StatefulWidget {
  const NorieEconomyScreen({super.key});
  @override
  State<NorieEconomyScreen> createState() => _NorieEconomyScreenState();
}

class _NorieEconomyScreenState extends State<NorieEconomyScreen> {
  List<Map<String, dynamic>> _devices = [];
  bool _busy = false;
  String? _devicesOwner;
  String? _notice;

  Future<void> _refresh({String? retire}) async {
    if (_busy) return;
    final owner = NorieAccountService.instance.user?.id;
    final client = NorieSupabase.client;
    if (owner == null || client == null) return;
    final current = NorieCloudSync.instance.captureSessionGuard();
    setState(() {
      _busy = true;
      _notice = null;
    });
    try {
      if (retire != null) {
        await client.rpc('norie_economy_retire_device', params: {
          'p_user_id': owner,
          'p_device_id': retire,
        });
        if (!current()) return;
      }
      await NorieCloudSync.instance.syncNow();
      if (!current()) return;
      if (NorieCloudSync.instance.status == NorieCloudSyncStatus.error) {
        throw StateError('Account sync unavailable');
      }
      final raw = await client
          .rpc('norie_economy_devices', params: {'p_user_id': owner});
      if (!current() || !mounted) return;
      _devicesOwner = owner;
      _devices = (raw as List)
          .map((item) => Map<String, dynamic>.from(item as Map))
          .toList();
      _notice = retire == null
          ? 'Account balances refreshed.'
          : 'Device retired. It must recover before syncing again.';
    } catch (_) {
      if (current()) {
        _notice =
            'Could not reach your account. Keep learning offline and retry when connected.';
      }
    } finally {
      if (mounted) {
        setState(() {
          _busy = false;
          if (!current()) {
            _devices = [];
            _notice = null;
          }
        });
      }
    }
  }

  Future<void> _retire(Map<String, dynamic> device) async {
    final current = NorieCloudSync.instance.captureSessionGuard();
    final confirmed = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: const Text('Retire this device?'),
              content: const Text(
                  'Only retire a device you no longer use. Its offline spending allowance is revoked. Any unsettled purchases need review when that device returns; saved learning and pending reward receipts can recover.'),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Cancel')),
                FilledButton(
                    onPressed: () => Navigator.pop(context, true),
                    child: const Text('Retire device'))
              ],
            ));
    if (confirmed == true && mounted && current()) {
      await _refresh(retire: device['device_id'] as String);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Rewards & devices')),
        body: AnimatedBuilder(
            animation: Listenable.merge(
                [NorieEconomyStore.instance, NorieAccountService.instance]),
            builder: (context, _) {
              final store = NorieEconomyStore.instance;
              final signedIn = NorieAccountService.instance.isSignedIn;
              return ListView(padding: const EdgeInsets.all(20), children: [
                Text('${store.totalXp} XP · ${store.credits} Norie Credits',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 12),
                Text(signedIn
                    ? 'Learning rewards save on this device and reconcile with your account when connected. Each reward receipt is counted once.'
                    : 'Guest rewards save on this device. Back up your progress before changing devices.'),
                const SizedBox(height: 16),
                if (signedIn) ...[
                  Text(
                      'Offline spending allowance: ${store.offlineCreditRemaining} credits'),
                  if (store.reservationExpiresAt != null)
                    Text(
                        'Valid until ${store.reservationExpiresAt!.toLocal().toString().substring(0, 16)}'),
                  const SizedBox(height: 8),
                  const Text(
                      'Sync before going offline to refresh your allowance. Purchases are queued and become usable after account confirmation. Expired allowances cannot be used; lessons still work offline.'),
                  const SizedBox(height: 12),
                  FilledButton.icon(
                      onPressed: _busy ? null : () => _refresh(),
                      icon: const Icon(Icons.sync),
                      label: Text(
                          _busy ? 'Refreshing…' : 'Refresh account & devices')),
                ],
                if (store.pendingOperations.isNotEmpty)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(
                          '${store.pendingOperations.length} reward or purchase receipts awaiting sync.')),
                if (store.pendingPurchases.isNotEmpty)
                  Text(
                      '${store.pendingPurchases.length} purchases awaiting confirmation.'),
                if (!store.available)
                  const Text(
                      'Reward storage needs recovery. Lessons remain available; restore a valid backup before earning or purchasing.'),
                if (store.lastMessage != null) Text(store.lastMessage!),
                if (_notice != null)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Text(_notice!)),
                if (signedIn &&
                    _devicesOwner == NorieAccountService.instance.user?.id &&
                    _devices.isNotEmpty) ...[
                  const SizedBox(height: 16),
                  Text('Registered devices',
                      style: Theme.of(context).textTheme.titleMedium),
                  const Text(
                      'All active devices must save and acknowledge the latest checkpoint before detailed receipts can compact. Devices are never retired automatically.'),
                  for (var index = 0; index < _devices.length; index++)
                    Builder(builder: (context) {
                      final device = _devices[index];
                      final self = device['device_id'] == store.deviceId;
                      final retired = device['retired'] == true;
                      return Card(
                          child: Padding(
                              padding: const EdgeInsets.all(12),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(self
                                        ? 'This device'
                                        : 'Device ${index + 1}'),
                                    Text(retired
                                        ? 'Retired'
                                        : 'Checkpoint acknowledged: ${device['ack_seq']}'),
                                    if (!self && !retired)
                                      TextButton(
                                          onPressed: _busy
                                              ? null
                                              : () => _retire(device),
                                          child: const Text(
                                              'Retire unused device')),
                                  ])));
                    }),
                ],
              ]);
            }),
      );
}
