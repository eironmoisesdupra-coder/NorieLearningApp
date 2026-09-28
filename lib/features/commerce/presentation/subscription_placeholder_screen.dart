import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../../core/widgets/norie_glass_card.dart';

class SubscriptionPlaceholderScreen extends StatelessWidget {
  const SubscriptionPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(
            child: NorieAmbientBackdrop(
              primary: NorieColors.violet,
              secondary: NorieColors.magenta,
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
                    const _SubscriptionHero(),
                    const SizedBox(height: 20),
                    const _PlanCard(
                      title: 'Free',
                      badge: 'CURRENT PREVIEW',
                      accent: NorieColors.cyan,
                      features: [
                        'Core lessons and challenges',
                        '3 AI generations per day',
                        '15 Ask Norie questions per day',
                        'Standard study-set limits',
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _PlanCard(
                      title: 'Norie Plus',
                      badge: 'COMING SOON',
                      accent: NorieColors.violet,
                      features: [
                        'Higher daily AI allowance',
                        'Larger source uploads',
                        'More generated questions per set',
                        'Expanded personalization features',
                      ],
                    ),
                    const SizedBox(height: 12),
                    const _PlanCard(
                      title: 'Norie Pro',
                      badge: 'COMING SOON',
                      accent: NorieColors.magenta,
                      features: [
                        'Highest AI allowance',
                        'Priority generation capacity',
                        'Advanced learning analytics',
                        'Premium study and mastery tools',
                      ],
                    ),
                    const SizedBox(height: 18),
                    const NorieGlassCard(
                      accent: NorieColors.orange,
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Icon(
                            Icons.info_outline_rounded,
                            color: NorieColors.orange,
                          ),
                          SizedBox(width: 11),
                          Expanded(
                            child: Text(
                              'Subscription checkout is intentionally disabled in this preview. Pricing, billing, parental/age handling, store receipts, and restore-purchase flows will be implemented in a dedicated commerce sprint.',
                              style: TextStyle(
                                color: NorieColors.textSecondary,
                                fontSize: 11,
                                height: 1.45,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
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
                'Norie Membership',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Subscription preview',
                style: TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        const Icon(
          Icons.workspace_premium_rounded,
          color: NorieColors.orange,
        ),
      ],
    );
  }
}

class _SubscriptionHero extends StatelessWidget {
  const _SubscriptionHero();

  @override
  Widget build(BuildContext context) {
    return const NorieGlassCard(
      accent: NorieColors.violet,
      padding: EdgeInsets.all(22),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'LEARN MORE · CREATE MORE',
            style: TextStyle(
              color: NorieColors.cyan,
              fontSize: 9,
              letterSpacing: 1.5,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 9),
          Text(
            'Memberships that scale with your learning.',
            style: TextStyle(
              fontSize: 28,
              height: 1.02,
              letterSpacing: -.7,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 10),
          Text(
            'Norie will keep core learning useful for free while paid plans unlock more AI capacity and advanced tools.',
            style: TextStyle(
              color: NorieColors.textSecondary,
              height: 1.45,
            ),
          ),
          SizedBox(height: 16),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _BenefitChip(
                icon: Icons.auto_awesome_rounded,
                label: 'More AI',
              ),
              _BenefitChip(
                icon: Icons.upload_file_rounded,
                label: 'Larger Sources',
              ),
              _BenefitChip(
                icon: Icons.analytics_rounded,
                label: 'Advanced Progress',
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _BenefitChip extends StatelessWidget {
  const _BenefitChip({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: .045),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: .08)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: NorieColors.cyan),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}

class _PlanCard extends StatelessWidget {
  const _PlanCard({
    required this.title,
    required this.badge,
    required this.accent,
    required this.features,
  });

  final String title;
  final String badge;
  final Color accent;
  final List<String> features;

  @override
  Widget build(BuildContext context) {
    return NorieGlassCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 19,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 5,
                ),
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .11),
                  borderRadius: BorderRadius.circular(99),
                  border: Border.all(
                    color: accent.withValues(alpha: .25),
                  ),
                ),
                child: Text(
                  badge,
                  style: TextStyle(
                    color: accent,
                    fontSize: 8,
                    letterSpacing: .6,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 13),
          for (final feature in features)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(
                    Icons.check_circle_rounded,
                    size: 17,
                    color: accent,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      feature,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                        height: 1.35,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          const SizedBox(height: 3),
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: null,
              icon: const Icon(Icons.lock_clock_rounded),
              label: const Text('Purchases coming soon'),
            ),
          ),
        ],
      ),
    );
  }
}
