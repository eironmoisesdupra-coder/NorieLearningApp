import 'package:flutter/material.dart';

import '../../../core/audio/norie_reward_sound.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../../core/widgets/norie_credit_coin.dart';
import '../../../core/widgets/norie_glass_card.dart';
import '../domain/norie_shop_models.dart';

class NorieShopPlaceholderScreen extends StatelessWidget {
  const NorieShopPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final progression = NorieProgression.instance;
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: NorieAmbientBackdrop(
              primary: NorieColors.orange,
              secondary: NorieColors.violet,
            ),
          ),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 780),
                child: AnimatedBuilder(
                  animation: progression,
                  builder: (context, _) => ListView(
                    padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                    children: [
                      _Header(onBack: () => Navigator.of(context).maybePop()),
                      const SizedBox(height: 18),
                      _Wallet(
                        credits: progression.credits,
                        shields: progression.streakShields,
                      ),
                      const SizedBox(height: 22),
                      const Text(
                        'Learning Shop',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 5),
                      const Text(
                        'Earn Credits by learning. Spend them on protection and cosmetic customization.',
                        style: TextStyle(
                          color: NorieColors.textSecondary,
                          fontSize: 11,
                        ),
                      ),
                      const SizedBox(height: 14),
                      for (final item in NorieShopCatalog.items) ...[
                        _ShopItemCard(
                          item: item,
                          progression: progression,
                        ),
                        const SizedBox(height: 10),
                      ],
                      const SizedBox(height: 12),
                      _InventoryCard(progression: progression),
                      const SizedBox(height: 12),
                      _TransactionCard(progression: progression),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.onBack});
  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) => Row(
        children: [
          IconButton(
            onPressed: onBack,
            style: IconButton.styleFrom(
              backgroundColor: NorieColors.surface,
              side: const BorderSide(color: NorieColors.border),
            ),
            icon: const Icon(Icons.arrow_back_rounded),
          ),
          const SizedBox(width: 10),
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Norie Shop',
                  style: TextStyle(fontSize: 22, fontWeight: FontWeight.w900),
                ),
                Text(
                  'Rewards · Inventory · Customization',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
          Icon(Icons.storefront_rounded, color: NorieColors.orange),
        ],
      );
}

class _Wallet extends StatelessWidget {
  const _Wallet({required this.credits, required this.shields});
  final int credits;
  final int shields;

  @override
  Widget build(BuildContext context) => NorieGlassCard(
        accent: NorieColors.orange,
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            const NorieCreditCoin(size: 54),
            const SizedBox(width: 15),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'NORIE CREDITS',
                    style: TextStyle(
                      color: NorieColors.textSecondary,
                      fontSize: 9,
                      letterSpacing: 1.1,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  Text(
                    '$credits',
                    style: const TextStyle(
                      fontSize: 31,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
            ),
            Column(
              children: [
                const Icon(Icons.shield_rounded, color: NorieColors.cyan),
                Text(
                  '$shields',
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const Text(
                  'SHIELDS',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 7,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
}

class _ShopItemCard extends StatelessWidget {
  const _ShopItemCard({
    required this.item,
    required this.progression,
  });

  final NorieShopItem item;
  final NorieProgression progression;

  IconData get icon => switch (item.iconName) {
        'shield' => Icons.shield_rounded,
        'frame' => Icons.account_box_rounded,
        'badge' => Icons.workspace_premium_rounded,
        'theme' => Icons.palette_rounded,
        _ => Icons.redeem_rounded,
      };

  Color get accent => switch (item.type) {
        NorieShopItemType.consumable => NorieColors.cyan,
        NorieShopItemType.profileFrame => NorieColors.violet,
        NorieShopItemType.badge => NorieColors.orange,
        NorieShopItemType.theme => NorieColors.magenta,
      };

  bool get owned => progression.ownsShopItem(item.id);

  bool get equipped => switch (item.type) {
        NorieShopItemType.profileFrame =>
          progression.equippedFrameId == item.id,
        NorieShopItemType.badge => progression.equippedBadgeId == item.id,
        NorieShopItemType.theme => progression.equippedThemeId == item.id,
        NorieShopItemType.consumable => false,
      };

  Future<void> _buy(BuildContext context) async {
    final purchased = progression.purchaseShopItem(item);
    if (!purchased) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Not enough Norie Credits.')),
      );
      return;
    }
    await NorieRewardSound.playCoin();
    if (!context.mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${item.title} purchased.')),
    );
  }

  @override
  Widget build(BuildContext context) => NorieGlassCard(
        accent: accent,
        padding: const EdgeInsets.all(15),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: accent.withValues(alpha: .12),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Icon(icon, color: accent),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(item.title,
                      style: const TextStyle(fontWeight: FontWeight.w900)),
                  const SizedBox(height: 3),
                  Text(
                    item.description,
                    style: const TextStyle(
                      color: NorieColors.textSecondary,
                      fontSize: 10,
                      height: 1.35,
                    ),
                  ),
                  const SizedBox(height: 7),
                  Row(
                    children: [
                      const NorieCreditCoin(size: 15, animate: false),
                      const SizedBox(width: 4),
                      Text(
                        '${item.price}',
                        style: const TextStyle(
                          color: NorieColors.orange,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            if (equipped)
              const Chip(label: Text('EQUIPPED'))
            else if (owned && !item.consumable)
              FilledButton(
                onPressed: () => progression.equipShopItem(item),
                child: const Text('Equip'),
              )
            else
              FilledButton(
                onPressed: progression.credits >= item.price
                    ? () => _buy(context)
                    : null,
                child: Text(item.consumable ? 'Buy' : 'Unlock'),
              ),
          ],
        ),
      );
}

class _InventoryCard extends StatelessWidget {
  const _InventoryCard({required this.progression});
  final NorieProgression progression;

  @override
  Widget build(BuildContext context) {
    final owned = NorieShopCatalog.items
        .where((item) => progression.ownsShopItem(item.id))
        .toList();
    return NorieGlassCard(
      accent: NorieColors.violet,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Inventory',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 9),
          Text(
            owned.isEmpty
                ? 'No cosmetics unlocked yet.'
                : owned.map((item) => item.title).join(' · '),
            style: const TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 11,
              height: 1.45,
            ),
          ),
          if (progression.streakShields > 0) ...[
            const SizedBox(height: 8),
            Text(
              '${progression.streakShields} Streak Shield(s) available',
              style: const TextStyle(
                color: NorieColors.cyan,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.progression});
  final NorieProgression progression;

  @override
  Widget build(BuildContext context) {
    final entries = progression.creditTransactions.take(8).toList();
    return NorieGlassCard(
      accent: NorieColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Recent Credit Activity',
            style: TextStyle(fontSize: 17, fontWeight: FontWeight.w900),
          ),
          const SizedBox(height: 10),
          if (entries.isEmpty)
            const Text(
              'Earn or spend Credits to start your history.',
              style: TextStyle(
                color: NorieColors.textSecondary,
                fontSize: 11,
              ),
            )
          else
            for (final entry in entries)
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        entry.reason,
                        style: const TextStyle(fontSize: 11),
                      ),
                    ),
                    Text(
                      entry.amount > 0 ? '+${entry.amount}' : '${entry.amount}',
                      style: TextStyle(
                        color: entry.amount > 0
                            ? NorieColors.green
                            : NorieColors.orange,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                  ],
                ),
              ),
        ],
      ),
    );
  }
}
