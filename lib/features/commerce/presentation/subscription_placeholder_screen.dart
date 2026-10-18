import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../../core/widgets/norie_glass_card.dart';
import '../domain/norie_membership.dart';
import 'norie_commerce_art.dart';

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
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          tooltip: 'Back',
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 8),
                        const Expanded(
                          child: Text('Norie Membership',
                              style: TextStyle(
                                  fontSize: 21, fontWeight: FontWeight.w900)),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),
                    const NorieGlassCard(
                      accent: NorieColors.orange,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Billing unavailable',
                              style: TextStyle(
                                  fontSize: 20, fontWeight: FontWeight.w900)),
                          SizedBox(height: 10),
                          Text(
                              'Compare proposed plans. No plan can be purchased or activated in this build.'),
                          SizedBox(height: 10),
                          Text(
                              'Core offline lessons, quizzes, XP, progression, achievements and mastery stay free. Paying will not award XP or an academic advantage.'),
                        ],
                      ),
                    ),
                    const SizedBox(height: 18),
                    const Text('PROPOSED PHILIPPINES PRICING',
                        style: TextStyle(
                            color: NorieColors.cyan,
                            fontWeight: FontWeight.w800)),
                    const SizedBox(height: 8),
                    const Text(
                        'PHP means Philippine pesos, not earned Norie Credits. Paid benefits and prices below are proposals; AI allowances and managed-profile services are not implemented by these plans.'),
                    const SizedBox(height: 16),
                    for (final plan in NorieMembershipCatalog.plans) ...[
                      _MembershipPlanCard(plan: plan),
                      const SizedBox(height: 12),
                    ],
                    const SizedBox(height: 8),
                    const Text('Membership help',
                        style: TextStyle(
                            fontSize: 21, fontWeight: FontWeight.w900)),
                    const SizedBox(height: 8),
                    for (final help in _MembershipHelp.values)
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: OutlinedButton.icon(
                          onPressed: () => showDialog<void>(
                            context: context,
                            builder: (context) => AlertDialog(
                              title: Text(help.title),
                              content: SingleChildScrollView(
                                  child: Text(help.message)),
                              actions: [
                                TextButton(
                                  onPressed: () => Navigator.of(context).pop(),
                                  child: const Text('Close'),
                                )
                              ],
                            ),
                          ),
                          icon: const Icon(Icons.help_outline_rounded),
                          label: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(help.title),
                          ),
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

class _MembershipPlanCard extends StatelessWidget {
  const _MembershipPlanCard({required this.plan});

  final NorieMembershipPlan plan;

  @override
  Widget build(BuildContext context) {
    final isFree = plan.id == MembershipPlanId.free;
    final icon = switch (plan.id) {
      MembershipPlanId.free => Icons.menu_book_rounded,
      MembershipPlanId.plus => Icons.auto_awesome_rounded,
      MembershipPlanId.pro => Icons.workspace_premium_rounded,
      MembershipPlanId.family => Icons.family_restroom_rounded
    };
    final accent = switch (plan.id) {
      MembershipPlanId.free => NorieColors.cyan,
      MembershipPlanId.plus => NorieColors.violet,
      MembershipPlanId.pro => NorieColors.orange,
      MembershipPlanId.family => NorieColors.magenta
    };
    return NorieGlassCard(
      accent: accent,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(child: NorieCommerceArt(icon: icon, color: accent)),
          Text(plan.title,
              style:
                  const TextStyle(fontSize: 21, fontWeight: FontWeight.w900)),
          const SizedBox(height: 8),
          Text(
              isFree
                  ? 'PHP 0 / month'
                  : 'PROPOSED: PHP ${plan.monthlyPhp} / month',
              style:
                  const TextStyle(fontSize: 17, fontWeight: FontWeight.w800)),
          const SizedBox(height: 12),
          for (final benefit in plan.benefits)
            Padding(
              padding: const EdgeInsets.only(bottom: 8),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Icon(
                    isFree
                        ? Icons.check_circle_rounded
                        : Icons.auto_awesome_rounded,
                    color: accent,
                    size: 20),
                const SizedBox(width: 10),
                Expanded(child: Text(benefit)),
              ]),
            ),
          Text(
              isFree
                  ? 'Available without a subscription. No monthly charge.'
                  : 'Proposed benefits only. Not available to purchase.',
              style: const TextStyle(color: NorieColors.textSecondary)),
          const SizedBox(height: 16),
          SizedBox(
              width: double.infinity,
              child: FilledButton.icon(
                key: ValueKey('plan-${plan.id.name}'),
                style: FilledButton.styleFrom(
                    minimumSize: const Size(0, 52),
                    backgroundColor: accent,
                    foregroundColor: NorieColors.background),
                icon: Icon(isFree
                    ? Icons.check_circle_rounded
                    : Icons.shopping_bag_rounded),
                label: Padding(
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    child: Text(
                        isFree ? 'Explore Free' : 'Explore ${plan.title}')),
                onPressed: () => showDialog<void>(
                    context: context,
                    builder: (context) => AlertDialog(
                          title: Text(isFree
                              ? 'Your free learning plan'
                              : 'Review ${plan.title}'),
                          content: SingleChildScrollView(
                              child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                Center(
                                    child: NorieCommerceArt(
                                        icon: icon, color: accent)),
                                Text(
                                    isFree
                                        ? 'PHP 0 / month'
                                        : 'Proposed: PHP ${plan.monthlyPhp} / month',
                                    style: const TextStyle(
                                        fontSize: 22,
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 12),
                                for (final benefit in plan.benefits)
                                  Padding(
                                      padding:
                                          const EdgeInsets.only(bottom: 10),
                                      child: Text(benefit)),
                                Text(
                                    isFree
                                        ? 'Ready to learn offline'
                                        : 'Checkout not connected',
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w900)),
                                const SizedBox(height: 8),
                                Text(isFree
                                    ? 'Your core lessons, quizzes and progress are available without a subscription.'
                                    : 'Paid plans are previews while secure billing is being set up. Norie Credits cannot pay for a peso subscription.'),
                                const SizedBox(height: 10),
                                const Text(
                                    'No charge. No subscription has started.'),
                              ])),
                          actions: [
                            FilledButton.icon(
                                onPressed: () => Navigator.pop(context),
                                icon: const Icon(Icons.arrow_back_rounded),
                                label: const Text('Keep exploring'))
                          ],
                        )),
              )),
        ],
      ),
    );
  }
}

enum _MembershipHelp {
  renewal(
    'Monthly renewal',
    'No subscription starts and no renewal charge occurs in this build. '
        'The proposed paid plans use a monthly billing period. Before launch, '
        'the purchase screen must disclose the final price, renewal terms and '
        'how to cancel. No renewal terms have been activated here.',
  ),
  cancellation(
    'Cancellation help',
    'There is no active subscription to cancel in this build. If you have a '
        'purchase from another service or store, check its subscription management '
        'and support options. Cancellation timing and access after cancellation '
        'depend on the eventual provider and published terms. This help does not '
        'send a cancellation request.',
  ),
  refund(
    'Refund help',
    'This build cannot charge you or issue a refund. For an existing charge, '
        'check the receipt and contact the store or provider that processed it. '
        'Refund eligibility will depend on that provider and applicable terms; '
        'no refund outcome is promised here.',
  ),
  restore(
    'Restore help',
    'No purchase was restored. Restoration is unavailable until a store '
        'integration and authenticated server receipt verification are configured. '
        'When supported, restoration must verify the purchase and the signed-in '
        'account. A local backup or saved plan label cannot activate membership. '
        'Core offline learning remains available.',
  );

  const _MembershipHelp(this.title, this.message);
  final String title;
  final String message;
}
