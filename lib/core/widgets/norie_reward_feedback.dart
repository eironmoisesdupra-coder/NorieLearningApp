import 'dart:async';

import 'package:flutter/material.dart';

import '../audio/norie_reward_sound.dart';
import '../mascot/norie_mascot_controller.dart';
import '../mascot/norie_mascot_view.dart';
import '../theme/norie_theme.dart';
import 'norie_credit_coin.dart';

class NorieRewardBanner extends StatelessWidget {
  const NorieRewardBanner({
    required this.credits,
    required this.xp,
    this.title = 'Reward claimed',
    super.key,
  });

  final int credits;
  final int xp;
  final String title;

  @override
  Widget build(BuildContext context) {
    if (credits <= 0 && xp <= 0) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF102956), Color(0xFF241B5A)],
        ),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NorieColors.cyan.withValues(alpha: .36)),
        boxShadow: [
          BoxShadow(
            color: NorieColors.violet.withValues(alpha: .15),
            blurRadius: 22,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Row(
        children: [
          if (credits > 0) ...[
            const NorieCreditCoin(size: 34),
            const SizedBox(width: 10),
          ] else ...[
            const Icon(Icons.star_rounded, color: NorieColors.orange, size: 28),
            const SizedBox(width: 10),
          ],
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title.toUpperCase(),
                  style: const TextStyle(
                    color: NorieColors.cyan,
                    fontSize: 9,
                    letterSpacing: 1.1,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 3),
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  children: [
                    if (credits > 0)
                      Text(
                        '+$credits Norie Credits',
                        style: const TextStyle(fontWeight: FontWeight.w900),
                      ),
                    if (xp > 0)
                      Text(
                        '+$xp XP',
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
          const Icon(Icons.check_circle_rounded,
              color: NorieColors.green, size: 20),
        ],
      ),
    );
  }
}

abstract final class NorieRewardPopup {
  static Future<void> show(
    BuildContext context, {
    required int credits,
    required int xp,
    String title = 'Reward claimed!',
    bool correctAnswer = false,
  }) async {
    if (credits <= 0 && xp <= 0 && !correctAnswer) return;

    if (credits > 0 && !correctAnswer) {
      unawaited(NorieRewardSound.playCoin());
    }

    await showGeneralDialog<void>(
      context: context,
      barrierDismissible: true,
      barrierLabel: 'Dismiss reward',
      barrierColor: Colors.black.withValues(alpha: .52),
      transitionDuration: MediaQuery.of(context).disableAnimations
          ? Duration.zero
          : Duration(milliseconds: correctAnswer ? 160 : 360),
      pageBuilder: (context, animation, secondaryAnimation) {
        return _NorieRewardPopupCard(
          credits: credits,
          xp: xp,
          title: title,
          correctAnswer: correctAnswer,
        );
      },
      transitionBuilder: (context, animation, secondaryAnimation, child) {
        final curved = CurvedAnimation(
          parent: animation,
          curve: Curves.easeOutBack,
          reverseCurve: Curves.easeIn,
        );
        return FadeTransition(
          opacity: animation,
          child: ScaleTransition(
            scale: Tween<double>(begin: .72, end: 1).animate(curved),
            child: child,
          ),
        );
      },
    );
  }
}

class _NorieRewardPopupCard extends StatefulWidget {
  const _NorieRewardPopupCard({
    required this.credits,
    required this.xp,
    required this.title,
    this.correctAnswer = false,
  });

  final int credits;
  final int xp;
  final String title;
  final bool correctAnswer;

  @override
  State<_NorieRewardPopupCard> createState() => _NorieRewardPopupCardState();
}

class _NorieRewardPopupCardState extends State<_NorieRewardPopupCard> {
  Timer? _dismissTimer;
  late final NorieMascotController _mascot = NorieMascotController()..correct();

  @override
  void initState() {
    super.initState();
    _dismissTimer =
        Timer(Duration(milliseconds: widget.correctAnswer ? 1100 : 2100), () {
      if (mounted && ModalRoute.of(context)?.isCurrent == true) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _dismissTimer?.cancel();
    _mascot.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Material(
        color: Colors.transparent,
        child: Container(
          width: 286,
          margin: const EdgeInsets.all(24),
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(28),
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF102956),
                Color(0xFF271B62),
                Color(0xFF35184F),
              ],
            ),
            border: Border.all(color: NorieColors.cyan.withValues(alpha: .55)),
            boxShadow: [
              BoxShadow(
                color: NorieColors.cyan.withValues(alpha: .16),
                blurRadius: 34,
                spreadRadius: 2,
              ),
              BoxShadow(
                color: NorieColors.magenta.withValues(alpha: .12),
                blurRadius: 44,
                spreadRadius: 3,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              if (widget.correctAnswer)
                NorieMascotView(controller: _mascot, size: 110)
              else if (widget.credits > 0)
                const NorieCreditCoin(size: 78)
              else
                const Icon(Icons.star_rounded,
                    size: 68, color: NorieColors.orange),
              const SizedBox(height: 10),
              Text(
                widget.title,
                textAlign: TextAlign.center,
                style:
                    const TextStyle(fontSize: 23, fontWeight: FontWeight.w900),
              ),
              const SizedBox(height: 9),
              if (widget.credits > 0)
                Text(
                  '+${widget.credits} Norie Credits',
                  style: const TextStyle(
                    color: NorieColors.cyan,
                    fontSize: 18,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              if (widget.xp > 0) ...[
                const SizedBox(height: 4),
                Text(
                  '+${widget.xp} XP',
                  style: const TextStyle(
                    color: NorieColors.orange,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ],
              const SizedBox(height: 12),
              if (widget.credits > 0 || widget.xp > 0)
                const Text(
                  'Added to your rewards.',
                  style:
                      TextStyle(color: NorieColors.textSecondary, fontSize: 10),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
