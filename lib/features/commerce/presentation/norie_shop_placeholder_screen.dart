import 'package:flutter/material.dart';

import '../../../core/account/norie_account_service.dart';
import '../../../core/audio/norie_reward_sound.dart';
import '../../../core/cloud/norie_cloud_sync.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/sync/norie_economy_store.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../../core/widgets/norie_glass_card.dart';
import '../../profile/data/norie_profile_appearance_store.dart';
import '../../profile/presentation/norie_appearance_studio.dart';
import '../domain/norie_shop_models.dart';
import 'norie_shop_activity.dart';

class NorieShopPlaceholderScreen extends StatefulWidget {
  const NorieShopPlaceholderScreen({super.key});
  @override
  State<NorieShopPlaceholderScreen> createState() => _NorieShopState();
}

class _NorieShopState extends State<NorieShopPlaceholderScreen> {
  final progression = NorieProgression.instance;
  final economy = NorieEconomyStore.instance;
  String category = 'All';
  NorieShopItem? preview;
  bool busy = false;
  String? notice;
  final Set<String> buying = {};
  late bool Function() learner;

  @override
  void initState() {
    super.initState();
    learner = NorieAccountService.instance.captureLearnerGuard();
  }

  bool equipped(NorieShopItem item) => switch (item.type) {
        NorieShopItemType.profileFrame =>
          progression.equippedFrameId == item.id,
        NorieShopItemType.badge => progression.equippedBadgeId == item.id,
        NorieShopItemType.theme => progression.equippedThemeId == item.id,
        NorieShopItemType.consumable => false,
      };

  bool canBuy(NorieShopItem item) =>
      economy.available &&
      economy.lastError == null &&
      (NorieShopCatalog.accountPricingReady ||
          !(economy.active || NorieAccountService.instance.isSignedIn)) &&
      !buying.contains(item.id) &&
      !economy.pendingPurchases.contains(item.id) &&
      (item.consumable || !progression.ownsShopItem(item.id)) &&
      progression.credits >= item.price &&
      (!(economy.active || NorieAccountService.instance.isSignedIn) ||
          economy.offlineCreditRemaining >= item.price);

  Future<void> buy(NorieShopItem item) async {
    if (!canBuy(item)) return;
    final current = NorieAccountService.instance.captureLearnerGuard();
    final before = progression.credits;
    setState(() => buying.add(item.id));
    try {
      final confirmed = await showDialog<bool>(
          context: context,
          builder: (context) => AlertDialog(
                title: Text('Buy ${item.title}?'),
                content: SingleChildScrollView(
                    child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                      Text('Price: ${item.price} Credits'),
                      Text('Balance before: $before Credits'),
                      Text('Balance after: ${before - item.price} Credits'),
                      if (economy.active ||
                          NorieAccountService.instance.isSignedIn)
                        const Text(
                            'This reserves Credits now. Account purchases remain pending until server confirmation.'),
                    ])),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: const Text('Confirm purchase'))
                ],
              ));
      if (!mounted || !current() || confirmed != true) return;
      // A changing wallet needs a fresh review; never submit stale amounts.
      if (progression.credits != before) {
        setState(
            () => notice = 'Your balance changed. Review the purchase again.');
        return;
      }
      if (!economy.available || economy.pendingPurchases.contains(item.id)) {
        return;
      }
      final purchased = progression.purchaseShopItem(item);
      if (!mounted || !current()) return;
      setState(() => notice = purchased
          ? (economy.pendingPurchases.contains(item.id)
              ? '${item.title}: awaiting account confirmation.'
              : '${item.title} purchased on this device.')
          : progression.economyMessage ??
              'Purchase unavailable. Your Credits were not spent.');
      if (purchased) {
        try {
          await progression.flushPendingSaves();
          if (mounted &&
              current() &&
              !NorieAccountService.instance.isSignedIn &&
              !economy.pendingPurchases.contains(item.id)) {
            try {
              await NorieRewardSound.playCoin();
            } catch (_) {
              // Optional sound never changes an already recorded purchase.
            }
          }
        } catch (_) {
          if (mounted && current()) {
            setState(() => notice =
                'Purchase recorded but device saving needs retry. Do not purchase again.');
          }
        }
      }
    } finally {
      if (mounted) setState(() => buying.remove(item.id));
    }
  }

  Future<void> retry() async {
    if (busy) return;
    final current = NorieAccountService.instance.captureLearnerGuard();
    setState(() {
      busy = true;
      notice = null;
    });
    try {
      await progression.flushPendingSaves(retry: true);
      if (!current()) return;
      await NorieCloudSync.instance.syncNow();
      if (mounted && current()) {
        setState(() => notice =
            'Retry finished. See the current storage and account status below.');
      }
    } catch (_) {
      if (mounted && current()) {
        setState(() => notice =
            'Could not save or sync. Keep this device data and retry when available.');
      }
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
          body: Stack(children: [
        const Positioned.fill(
            child: NorieAmbientBackdrop(
                primary: NorieColors.orange, secondary: NorieColors.violet)),
        SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 780),
                    child: AnimatedBuilder(
                      animation: Listenable.merge([
                        progression,
                        economy,
                        NorieCloudSync.instance,
                        NorieAccountService.instance,
                        NorieProfileAppearanceStore.instance
                      ]),
                      builder: (context, _) {
                        if (!learner()) {
                          // Never carry a previous learner's try-on or messages to a new owner.
                          preview = null;
                          notice = null;
                          category = 'All';
                          learner = NorieAccountService.instance
                              .captureLearnerGuard();
                        }
                        final items = NorieShopCatalog.items
                            .where((item) => switch (category) {
                                  'Frames' =>
                                    item.type == NorieShopItemType.profileFrame,
                                  'Badges' =>
                                    item.type == NorieShopItemType.badge,
                                  'Themes' =>
                                    item.type == NorieShopItemType.theme,
                                  'Protection' => item.consumable,
                                  'Owned' => !item.consumable &&
                                      progression.ownsShopItem(item.id),
                                  _ => true,
                                })
                            .toList();
                        return ListView(
                            padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                            children: [
                              Row(children: [
                                IconButton(
                                    onPressed: () =>
                                        Navigator.maybePop(context),
                                    tooltip: 'Back',
                                    icon: const Icon(Icons.arrow_back_rounded)),
                                const Expanded(
                                    child: Text('Norie Shop',
                                        style: TextStyle(
                                            fontSize: 22,
                                            fontWeight: FontWeight.w900)))
                              ]),
                              const SizedBox(height: 16),
                              NorieGlassCard(
                                  accent: NorieColors.orange,
                                  child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                            '${progression.credits} Norie Credits',
                                            style: const TextStyle(
                                                fontSize: 24,
                                                fontWeight: FontWeight.w900)),
                                        Text(
                                            '${progression.streakShields} Streak Shields available'),
                                        const Text(
                                            'Earn Credits by learning. Cosmetics never change lesson access or XP.'),
                                      ])),
                              const SizedBox(height: 12),
                              NorieShopActivityStatus(
                                  economy: economy,
                                  cloud: NorieCloudSync.instance,
                                  busy: busy,
                                  onRetry: retry),
                              if (notice != null)
                                Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 12),
                                    child:
                                        Text(notice!, semanticsLabel: notice)),
                              const SizedBox(height: 16),
                              const Text('Browse rewards',
                                  style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900)),
                              Wrap(spacing: 6, runSpacing: 6, children: [
                                for (final label in [
                                  'All',
                                  'Frames',
                                  'Badges',
                                  'Themes',
                                  'Protection',
                                  'Owned'
                                ])
                                  ChoiceChip(
                                      label: Text(label),
                                      selected: category == label,
                                      onSelected: (_) =>
                                          setState(() => category = label))
                              ]),
                              const SizedBox(height: 12),
                              if (!economy.available)
                                Text(economy.lastError == null
                                    ? 'Loading your wallet…'
                                    : 'Wallet unavailable. Purchases are paused; your saved data is preserved.'),
                              if (items.isEmpty)
                                const Padding(
                                    padding: EdgeInsets.all(16),
                                    child: Text(
                                        'No cosmetics owned yet. Browse rewards to find your first.')),
                              for (final item in items)
                                Padding(
                                    padding: const EdgeInsets.only(bottom: 10),
                                    child: itemCard(item)),
                              if (preview != null) ...[
                                const SizedBox(height: 12),
                                Text('Preview: ${preview!.title}',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900)),
                                const Text(
                                    'Temporary try-on. Your saved appearance stays the same.'),
                                const SizedBox(height: 8),
                                NorieAppearancePreview(
                                    value: NorieProfileAppearanceStore
                                        .instance.value,
                                    displayName: NorieAccountService
                                            .instance.displayName ??
                                        'Norie Learner',
                                    subtitle: 'Shop preview',
                                    shopFrameId: preview!.type ==
                                            NorieShopItemType.profileFrame
                                        ? preview!.id
                                        : progression.equippedFrameId,
                                    shopBadgeId:
                                        preview!.type == NorieShopItemType.badge
                                            ? preview!.id
                                            : progression.equippedBadgeId,
                                    shopThemeId:
                                        preview!.type == NorieShopItemType.theme
                                            ? preview!.id
                                            : progression.equippedThemeId),
                                TextButton(
                                    onPressed: () =>
                                        setState(() => preview = null),
                                    child: const Text('Close preview')),
                              ],
                              const SizedBox(height: 20),
                              NorieShopTransactionHistory(
                                  progression: progression),
                            ]);
                      },
                    )))),
      ]));

  Widget itemCard(NorieShopItem item) {
    final owned = progression.ownsShopItem(item.id) && !item.consumable;
    final pending = economy.pendingPurchases.contains(item.id);
    return NorieGlassCard(
        accent: NorieColors.violet,
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(item.title,
              style:
                  const TextStyle(fontWeight: FontWeight.w900, fontSize: 17)),
          const SizedBox(height: 6),
          Text(item.description),
          const SizedBox(height: 8),
          Text(owned
              ? (equipped(item) ? 'Owned · Equipped' : 'Owned')
              : '${item.price} Credits'),
          if (pending)
            const Text('Awaiting account confirmation. Do not purchase again.'),
          if (!owned && !pending && progression.credits < item.price)
            Text(
                'Earn ${item.price - progression.credits} more Credits to buy.'),
          Wrap(spacing: 8, runSpacing: 8, children: [
            if (!item.consumable)
              OutlinedButton(
                  key: ValueKey('preview-${item.id}'),
                  onPressed: () => setState(() => preview = item),
                  child: const Text('Preview')),
            if (owned)
              FilledButton(
                  key: ValueKey(
                      '${equipped(item) ? 'unequip' : 'equip'}-${item.id}'),
                  onPressed: () async {
                    final current =
                        NorieAccountService.instance.captureLearnerGuard();
                    if (equipped(item)) {
                      progression.unequipShopItem(item);
                    } else {
                      progression.equipShopItem(item);
                    }
                    try {
                      await progression.flushPendingSaves();
                    } catch (_) {
                      if (mounted && current()) {
                        setState(() => notice =
                            'Appearance changed but device saving needs retry. Use Retry save / sync.');
                      }
                    }
                  },
                  child: Text(equipped(item) ? 'Unequip' : 'Equip'))
            else
              FilledButton(
                  key: ValueKey('buy-${item.id}'),
                  onPressed: canBuy(item) ? () => buy(item) : null,
                  child: Text(pending
                      ? 'Pending'
                      : buying.contains(item.id)
                          ? 'Reviewing…'
                          : item.consumable
                              ? 'Buy'
                              : 'Unlock')),
          ]),
        ]));
  }
}
