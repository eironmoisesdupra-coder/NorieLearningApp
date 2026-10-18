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
import 'norie_commerce_art.dart';
import '../../content/presentation/norie_subject_world_map.dart';

class NorieShopPlaceholderScreen extends StatefulWidget {
  const NorieShopPlaceholderScreen({super.key});
  @override
  State<NorieShopPlaceholderScreen> createState() => _NorieShopState();
}

class _NorieShopState extends State<NorieShopPlaceholderScreen> {
  final progression = NorieProgression.instance;
  final economy = NorieEconomyStore.instance;
  String category = 'All';
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
                      Center(
                          child: NorieCommerceArt(
                              icon: NorieCommerceArt.itemIcon(item),
                              color: NorieCommerceArt.itemColor(item))),
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

  Future<void> showPreview(NorieShopItem item) async {
    final current = NorieAccountService.instance.captureLearnerGuard();
    await showDialog<void>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text('Preview: ${item.title}'),
              content: SingleChildScrollView(
                  child: SizedBox(
                      width: 420,
                      child: AnimatedBuilder(
                          animation: NorieAccountService.instance,
                          builder: (context, _) {
                            if (!current()) {
                              return const Text(
                                  'Account changed. Close this preview to continue.');
                            }
                            return Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  const Text(
                                      'Temporary try-on. Your saved appearance stays the same.'),
                                  const SizedBox(height: 12),
                                  NorieAppearancePreview(
                                      value: NorieProfileAppearanceStore
                                          .instance.value,
                                      displayName: NorieAccountService
                                              .instance.displayName ??
                                          'Norie Learner',
                                      subtitle: 'Shop preview',
                                      shopFrameId: item.type ==
                                              NorieShopItemType.profileFrame
                                          ? item.id
                                          : progression.equippedFrameId,
                                      shopBadgeId:
                                          item.type == NorieShopItemType.badge
                                              ? item.id
                                              : progression.equippedBadgeId,
                                      shopThemeId:
                                          item.type == NorieShopItemType.theme
                                              ? item.id
                                              : progression.equippedThemeId),
                                ]);
                          }))),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context),
                    child: const Text('Close preview'))
              ],
            ));
  }

  Future<void> reviewUnavailable(NorieShopItem item) async {
    final shortfall = item.price - progression.credits;
    final current = NorieAccountService.instance.captureLearnerGuard();
    final explore = await showDialog<bool>(
        context: context,
        builder: (context) => AlertDialog(
              title: Text(item.title),
              content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                NorieCommerceArt(
                    icon: NorieCommerceArt.itemIcon(item),
                    color: NorieCommerceArt.itemColor(item),
                    frame: item.type == NorieShopItemType.profileFrame),
                Text(item.description),
                const SizedBox(height: 12),
                Text('${item.price} Credits',
                    style: const TextStyle(
                        fontWeight: FontWeight.w900, fontSize: 22)),
                Text('Your balance: ${progression.credits} Credits'),
                const SizedBox(height: 12),
                Text(shortfall > 0
                    ? 'You need $shortfall more Credits'
                    : 'Purchase temporarily unavailable'),
                const SizedBox(height: 8),
                Text(shortfall > 0
                    ? 'Earn Credits through learning rewards. Explore your lessons and continue your progress.'
                    : !NorieShopCatalog.accountPricingReady &&
                            (economy.active ||
                                NorieAccountService.instance.isSignedIn)
                        ? 'Account purchases are waiting for the updated catalog. You can preview rewards and equip items you already own.'
                        : 'Your wallet needs to finish saving or syncing. Close this panel and use Retry save / sync.'),
                if (shortfall > 0 &&
                    !NorieShopCatalog.accountPricingReady &&
                    (economy.active || NorieAccountService.instance.isSignedIn))
                  const Padding(
                      padding: EdgeInsets.only(top: 12),
                      child: Text(
                          'Account purchases are also paused while the catalog is updated. Earning more Credits will not remove this pause.')),
              ])),
              actions: [
                TextButton(
                    onPressed: () => Navigator.pop(context, false),
                    child: const Text('Keep browsing')),
                if (shortfall > 0)
                  FilledButton.icon(
                      onPressed: () => Navigator.pop(context, true),
                      icon: const Icon(Icons.explore_rounded),
                      label: const Text('Explore lessons'))
              ],
            ));
    if (explore == true && mounted && current()) {
      await Navigator.of(context).push(MaterialPageRoute<void>(
          builder: (_) => const NorieSubjectWorldMap()));
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
                              const Icon(Icons.toll_rounded,
                                  color: NorieColors.orange, size: 44),
                              const SizedBox(height: 8),
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
                              ExpansionTile(
                                leading: const Icon(
                                    Icons.account_balance_wallet_rounded,
                                    color: NorieColors.cyan),
                                title: const Text('Wallet & purchase status'),
                                subtitle: Text(!NorieShopCatalog
                                            .accountPricingReady &&
                                        (economy.active ||
                                            NorieAccountService
                                                .instance.isSignedIn)
                                    ? 'Account purchases paused. Owned rewards are ready to equip.'
                                    : 'Device saves, sync and purchase receipts'),
                                children: [
                                  NorieShopActivityStatus(
                                      economy: economy,
                                      cloud: NorieCloudSync.instance,
                                      busy: busy,
                                      onRetry: retry)
                                ],
                              ),
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
                                      avatar: Icon(
                                          switch (label) {
                                            'Frames' =>
                                              Icons.account_circle_rounded,
                                            'Badges' =>
                                              Icons.workspace_premium_rounded,
                                            'Themes' => Icons.palette_rounded,
                                            'Protection' =>
                                              Icons.shield_rounded,
                                            'Owned' =>
                                              Icons.inventory_2_rounded,
                                            _ => Icons.storefront_rounded
                                          },
                                          size: 18),
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
        accent: NorieCommerceArt.itemColor(item),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Center(
              child: NorieCommerceArt(
                  icon: NorieCommerceArt.itemIcon(item),
                  color: NorieCommerceArt.itemColor(item),
                  frame: item.type == NorieShopItemType.profileFrame)),
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
              OutlinedButton.icon(
                  icon: const Icon(Icons.visibility_rounded),
                  key: ValueKey('preview-${item.id}'),
                  onPressed: () => showPreview(item),
                  label: const Text('Preview')),
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
              FilledButton.icon(
                  icon: Icon(canBuy(item)
                      ? Icons.shopping_bag_rounded
                      : Icons.info_outline_rounded),
                  style:
                      FilledButton.styleFrom(minimumSize: const Size(148, 48)),
                  key: ValueKey('buy-${item.id}'),
                  onPressed: pending || buying.contains(item.id)
                      ? null
                      : () =>
                          canBuy(item) ? buy(item) : reviewUnavailable(item),
                  label: Text(pending
                      ? 'Pending'
                      : buying.contains(item.id)
                          ? 'Reviewing…'
                          : item.consumable
                              ? 'Buy shield'
                              : 'Unlock reward')),
          ]),
        ]));
  }
}
