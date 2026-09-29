import 'package:flutter/material.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_credit_coin.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../../core/widgets/norie_glass_card.dart';

class NorieShopPlaceholderScreen extends StatelessWidget {
  const NorieShopPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  children: [
                    _Header(onBack: () => Navigator.of(context).maybePop()),
                    const SizedBox(height: 22),
                    AnimatedBuilder(
                      animation: NorieProgression.instance,
                      builder: (context, _) => _WalletCard(
                        balance: NorieProgression.instance.credits,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      'Learning Shop',
                      style: TextStyle(
                        fontSize: 21,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 5),
                    const Text(
                      'Preview items only — no purchases are active yet.',
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 13),
                    const _ShopItem(
                      icon: Icons.shield_rounded,
                      title: 'Streak Shield',
                      subtitle: 'Protect one missed study day.',
                      price: 200,
                      accent: NorieColors.cyan,
                    ),
                    const SizedBox(height: 10),
                    const _ShopItem(
                      icon: Icons.bolt_rounded,
                      title: 'XP Booster',
                      subtitle: 'Future limited-time bonus XP item.',
                      price: 350,
                      accent: NorieColors.orange,
                    ),
                    const SizedBox(height: 10),
                    const _ShopItem(
                      icon: Icons.palette_rounded,
                      title: 'Norie Theme Pack',
                      subtitle: 'Unlock cosmetic app themes and profile styles.',
                      price: 500,
                      accent: NorieColors.violet,
                    ),
                    const SizedBox(height: 10),
                    const _ShopItem(
                      icon: Icons.trending_up_rounded,
                      title: 'Level Boost',
                      subtitle: 'Preview level-progression purchase concept.',
                      price: 750,
                      accent: NorieColors.magenta,
                    ),
                    const SizedBox(height: 20),
                    const _CreditPackPreview(),
                  ],
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
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onBack,
          tooltip: 'Back',
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
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Credits and rewards preview',
                style: TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.storefront_rounded,
          color: NorieColors.orange,
        ),
      ],
    );
  }
}

class _WalletCard extends StatelessWidget {
  const _WalletCard({required this.balance});

  final int balance;

  @override
  Widget build(BuildContext context) {
    return NorieGlassCard(
      accent: NorieColors.orange,
      padding: const EdgeInsets.all(22),
      child: Row(
        children: [
          const SizedBox(
            width: 66,
            height: 66,
            child: Center(
              child: NorieCreditCoin(size: 52),
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'NORIE CREDITS',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 9,
                    letterSpacing: 1.2,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  '$balance',
                  style: const TextStyle(
                    fontSize: 31,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const Text(
                  'Wallet backend is not active yet.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
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

class _ShopItem extends StatelessWidget {
  const _ShopItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.price,
    required this.accent,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final int price;
  final Color accent;

  @override
  Widget build(BuildContext context) {
    return NorieGlassCard(
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
                Text(
                  title,
                  style: const TextStyle(
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                    height: 1.35,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  const NorieCreditCoin(
                    size: 15,
                    animate: false,
                  ),
                  const SizedBox(width: 3),
                  Text(
                    '$price',
                    style: const TextStyle(
                      color: NorieColors.orange,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'LOCKED',
                style: TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 7,
                  letterSpacing: .7,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CreditPackPreview extends StatelessWidget {
  const _CreditPackPreview();

  @override
  Widget build(BuildContext context) {
    return NorieGlassCard(
      accent: NorieColors.cyan,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Row(
            children: [
              Icon(
                Icons.account_balance_wallet_rounded,
                color: NorieColors.cyan,
              ),
              SizedBox(width: 9),
              Expanded(
                child: Text(
                  'Credit Packs',
                  style: TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'COMING SOON',
                style: TextStyle(
                  color: NorieColors.cyan,
                  fontSize: 8,
                  fontWeight: FontWeight.w900,
                ),
              ),
            ],
          ),
          const SizedBox(height: 9),
          const Text(
            'Future packs can add Norie Credits after secure store billing and receipt verification are implemented.',
            style: TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 11,
              height: 1.4,
            ),
          ),
          const SizedBox(height: 13),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock_clock_rounded),
              label: const Text('Credit purchases disabled'),
            ),
          ),
        ],
      ),
    );
  }
}
