import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';

class AnatomyLabPlaceholderScreen extends StatelessWidget {
  const AnatomyLabPlaceholderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: _AnatomyBackdrop()),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 760),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(20, 16, 20, 40),
                  children: [
                    Row(
                      children: [
                        IconButton(
                          onPressed: () => Navigator.of(context).maybePop(),
                          tooltip: 'Back',
                          style: IconButton.styleFrom(
                            backgroundColor:
                                NorieColors.surface.withValues(alpha: .88),
                            side: BorderSide(
                              color:
                                  NorieColors.cyan.withValues(alpha: .22),
                            ),
                          ),
                          icon: const Icon(Icons.arrow_back_rounded),
                        ),
                        const SizedBox(width: 10),
                        const Expanded(
                          child: Text(
                            '3D Anatomy Lab',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        const _StatusBadge(),
                      ],
                    ),
                    const SizedBox(height: 22),
                    const _Hero(),
                    const SizedBox(height: 22),
                    const Text(
                      'What is being built',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 12),
                    const _FeatureGrid(),
                    const SizedBox(height: 22),
                    const _LearningFlow(),
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

class _AnatomyBackdrop extends StatelessWidget {
  const _AnatomyBackdrop();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: const BoxDecoration(
        color: NorieColors.background,
        gradient: RadialGradient(
          center: Alignment(.7, -.65),
          radius: 1.15,
          colors: [
            Color(0x3347E9FF),
            Color(0x22167BFF),
            Color(0x00101B36),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: NorieColors.cyan.withValues(alpha: .10),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: NorieColors.cyan.withValues(alpha: .38),
        ),
      ),
      child: const Text(
        'PREVIEW',
        style: TextStyle(
          fontSize: 9,
          letterSpacing: 1.1,
          fontWeight: FontWeight.w900,
          color: NorieColors.cyan,
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(30),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C2548),
            Color(0xFF132454),
            Color(0xFF311A58),
          ],
        ),
        border: Border.all(
          color: NorieColors.cyan.withValues(alpha: .45),
        ),
        boxShadow: [
          BoxShadow(
            color: NorieColors.cyan.withValues(alpha: .12),
            blurRadius: 34,
            offset: const Offset(0, 16),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 520;

          final visual = const _AnatomyOrb();
          final copy = const _HeroCopy();

          if (compact) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(child: visual),
                const SizedBox(height: 22),
                copy,
              ],
            );
          }

          return const Row(
            children: [
              Expanded(flex: 5, child: _HeroCopy()),
              SizedBox(width: 24),
              Expanded(flex: 4, child: _AnatomyOrb()),
            ],
          );
        },
      ),
    );
  }
}

class _HeroCopy extends StatelessWidget {
  const _HeroCopy();

  @override
  Widget build(BuildContext context) {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'EXPLORE THE BODY',
          style: TextStyle(
            fontSize: 10,
            letterSpacing: 1.8,
            color: Color(0xFF8CF5FF),
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Learn anatomy by\nexploring it.',
          style: TextStyle(
            fontSize: 31,
            height: .98,
            letterSpacing: -1,
            fontWeight: FontWeight.w900,
          ),
        ),
        SizedBox(height: 12),
        Text(
          'Norie Anatomy Lab will combine lessons, interactive 3D exploration, identification practice, challenges, XP, and mastery tracking.',
          style: TextStyle(
            color: Color(0xFFC3D0E8),
            height: 1.5,
            fontSize: 12,
          ),
        ),
        SizedBox(height: 16),
        Row(
          children: [
            _MiniPill(
              icon: Icons.view_in_ar_rounded,
              label: 'Interactive 3D',
            ),
            SizedBox(width: 8),
            _MiniPill(
              icon: Icons.psychology_alt_rounded,
              label: 'Mastery',
            ),
          ],
        ),
      ],
    );
  }
}

class _MiniPill extends StatelessWidget {
  const _MiniPill({
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
        color: Colors.white.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(color: Colors.white.withValues(alpha: .10)),
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

class _AnatomyOrb extends StatelessWidget {
  const _AnatomyOrb();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        width: 210,
        height: 210,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          gradient: const RadialGradient(
            colors: [
              Color(0x3348F5FF),
              Color(0x222B6BFF),
              Color(0x111A1B4D),
              Color(0x00101B36),
            ],
          ),
          border: Border.all(
            color: NorieColors.cyan.withValues(alpha: .22),
          ),
        ),
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 142,
              height: 142,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: NorieColors.background.withValues(alpha: .35),
                border: Border.all(
                  color: NorieColors.violet.withValues(alpha: .28),
                ),
              ),
            ),
            const Icon(
              Icons.accessibility_new_rounded,
              size: 116,
              color: Color(0xFFE7FBFF),
            ),
            const Positioned(
              top: 31,
              right: 29,
              child: _OrbNode(color: NorieColors.magenta),
            ),
            const Positioned(
              left: 28,
              bottom: 49,
              child: _OrbNode(color: NorieColors.cyan),
            ),
            const Positioned(
              right: 47,
              bottom: 25,
              child: _OrbNode(color: NorieColors.violet),
            ),
          ],
        ),
      ),
    );
  }
}

class _OrbNode extends StatelessWidget {
  const _OrbNode({required this.color});

  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 9,
      height: 9,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: color,
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: .75),
            blurRadius: 12,
          ),
        ],
      ),
    );
  }
}

class _FeatureGrid extends StatelessWidget {
  const _FeatureGrid();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final columns = constraints.maxWidth >= 560 ? 2 : 1;
        const gap = 10.0;
        final width =
            (constraints.maxWidth - ((columns - 1) * gap)) / columns;

        const features = [
          (
            Icons.accessibility_new_rounded,
            'Human Anatomy',
            'Body systems, organs, bones, muscles, and structures.',
            NorieColors.cyan,
          ),
          (
            Icons.pets_rounded,
            'Animal Anatomy',
            'Compare structures and systems across selected animals.',
            NorieColors.green,
          ),
          (
            Icons.view_in_ar_rounded,
            '3D Explore',
            'Rotate, isolate, zoom, and inspect labeled structures.',
            NorieColors.violet,
          ),
          (
            Icons.quiz_rounded,
            'Identify Mode',
            'Tap structures, answer challenges, and build mastery.',
            NorieColors.magenta,
          ),
        ];

        return Wrap(
          spacing: gap,
          runSpacing: gap,
          children: [
            for (final feature in features)
              SizedBox(
                width: width,
                child: _FeatureCard(
                  icon: feature.$1,
                  title: feature.$2,
                  subtitle: feature.$3,
                  color: feature.$4,
                ),
              ),
          ],
        );
      },
    );
  }
}

class _FeatureCard extends StatelessWidget {
  const _FeatureCard({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NorieColors.surface.withValues(alpha: .88),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: color.withValues(alpha: .24)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 46,
            height: 46,
            decoration: BoxDecoration(
              color: color.withValues(alpha: .12),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon, color: color),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: const TextStyle(
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.lock_clock_rounded,
                      size: 16,
                      color: NorieColors.textSecondary,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Text(
                  subtitle,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 11,
                    height: 1.35,
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

class _LearningFlow extends StatelessWidget {
  const _LearningFlow();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: NorieColors.border),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Planned learning loop',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 14),
          _FlowStep(number: '01', label: 'Learn the concept'),
          _FlowConnector(),
          _FlowStep(number: '02', label: 'Explore the 3D model'),
          _FlowConnector(),
          _FlowStep(number: '03', label: 'Identify structures'),
          _FlowConnector(),
          _FlowStep(number: '04', label: 'Challenge · XP · Mastery'),
        ],
      ),
    );
  }
}

class _FlowStep extends StatelessWidget {
  const _FlowStep({
    required this.number,
    required this.label,
  });

  final String number;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 35,
          height: 35,
          alignment: Alignment.center,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(11),
            gradient: const LinearGradient(
              colors: [NorieColors.primary, NorieColors.violet],
            ),
          ),
          child: Text(
            number,
            style: const TextStyle(
              fontSize: 9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Text(
          label,
          style: const TextStyle(fontWeight: FontWeight.w800),
        ),
      ],
    );
  }
}

class _FlowConnector extends StatelessWidget {
  const _FlowConnector();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.only(left: 17),
      child: SizedBox(
        height: 14,
        child: VerticalDivider(
          width: 1,
          thickness: 1,
          color: NorieColors.border,
        ),
      ),
    );
  }
}
