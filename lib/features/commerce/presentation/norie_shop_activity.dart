import 'package:flutter/material.dart';
import '../../../core/account/norie_account_service.dart';
import '../../../core/cloud/norie_cloud_sync.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/sync/norie_economy_store.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_glass_card.dart';
import '../domain/norie_shop_models.dart';

/// Describes storage and account confirmation separately: local persistence is
/// not evidence of a server receipt.
class NorieShopActivityStatus extends StatelessWidget {
  const NorieShopActivityStatus(
      {super.key,
      required this.economy,
      required this.cloud,
      required this.busy,
      required this.onRetry});
  final NorieEconomyStore economy;
  final NorieCloudSync cloud;
  final bool busy;
  final VoidCallback onRetry;
  @override
  Widget build(BuildContext context) {
    final signedIn = NorieAccountService.instance.isSignedIn;
    final status = switch (cloud.status) {
      NorieCloudSyncStatus.localOnly =>
        'Cloud sync is not configured. Purchases stay on this device.',
      NorieCloudSyncStatus.signedOut =>
        'Signed out. Purchases stay on this device.',
      NorieCloudSyncStatus.syncing =>
        'Syncing account; purchases may still await confirmation.',
      NorieCloudSyncStatus.pending =>
        'Account sync pending. Keep this device data.',
      NorieCloudSyncStatus.synced =>
        'Account sync completed. Pending purchases below still need confirmation.',
      NorieCloudSyncStatus.error =>
        'Account sync unavailable. Retry when connected.',
    };
    return NorieGlassCard(
        accent: NorieColors.cyan,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(economy.lastError != null
              ? 'Device save needs attention. Keep this device data and retry.'
              : !economy.available
                  ? 'Loading wallet…'
                  : economy.hasPendingWrites
                      ? 'Saving on this device…'
                      : 'Saved on this device.'),
          const SizedBox(height: 6),
          Text(status),
          if (!NorieShopCatalog.accountPricingReady &&
              (signedIn || economy.active))
            const Text(
                'Account purchases are paused until the server catalog prices are updated. No Credits will be spent. Existing owned cosmetics can still be equipped.'),
          if (signedIn || economy.active)
            Text(
                'Available account spending allowance: ${economy.offlineCreditRemaining} Credits'),
          if (economy.pendingPurchases.isNotEmpty)
            Text(
                '${economy.pendingPurchases.length} purchase(s) awaiting account confirmation.'),
          if (cloud.message != null) Text(cloud.message!),
          if (economy.lastMessage != null) Text(economy.lastMessage!),
          OutlinedButton(
              onPressed: busy || cloud.isSyncing ? null : onRetry,
              child: Text(busy ? 'Retrying…' : 'Retry save / sync')),
        ]));
  }
}

class NorieShopTransactionHistory extends StatefulWidget {
  const NorieShopTransactionHistory({super.key, required this.progression});
  final NorieProgression progression;
  @override
  State<NorieShopTransactionHistory> createState() => _HistoryState();
}

class _HistoryState extends State<NorieShopTransactionHistory> {
  String filter = 'All activity';
  @override
  Widget build(BuildContext context) {
    final entries = widget.progression.creditTransactions
        .where((entry) => switch (filter) {
              'Earned' => entry.amount > 0,
              'Spent' => entry.amount < 0,
              'Purchase requests' =>
                entry.reason.startsWith('Purchase requested:'),
              _ => true,
            })
        .toList();
    return NorieGlassCard(
        accent: NorieColors.cyan,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          const Text('Credit activity',
              style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
          const Text(
              'Historical requests record submission, not cloud confirmation. Amounts reflect the price when recorded.'),
          Wrap(spacing: 6, runSpacing: 6, children: [
            for (final label in [
              'All activity',
              'Earned',
              'Spent',
              'Purchase requests'
            ])
              ChoiceChip(
                  label: Text(label),
                  selected: filter == label,
                  onSelected: (_) => setState(() => filter = label))
          ]),
          const SizedBox(height: 8),
          if (entries.isEmpty) const Text('No activity matches this filter.'),
          for (final entry in entries)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 8),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(entry.reason),
                      Text(
                          '${entry.amount > 0 ? '+' : ''}${entry.amount} Credits',
                          style: TextStyle(
                              color: entry.amount > 0
                                  ? NorieColors.green
                                  : NorieColors.orange,
                              fontWeight: FontWeight.w900)),
                      Text(
                          entry.createdAt.toLocal().toString().split('.').first,
                          style: const TextStyle(
                              fontSize: 12, color: NorieColors.textSecondary)),
                    ])),
        ]));
  }
}
