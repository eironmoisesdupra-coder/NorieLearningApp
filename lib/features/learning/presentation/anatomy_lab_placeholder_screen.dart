import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../domain/anatomy_models.dart';
import '../domain/anatomy_atlas_catalog.dart';
import 'anatomy_atlas_quiz_screen.dart';
import 'anatomy_animated_backdrop.dart';
import 'anatomy_quiz_screen.dart';
import 'anatomy_atlas_screen.dart';

class AnatomyLabPlaceholderScreen extends StatefulWidget {
  const AnatomyLabPlaceholderScreen({super.key});

  @override
  State<AnatomyLabPlaceholderScreen> createState() =>
      _AnatomyLabPlaceholderScreenState();
}

class _AnatomyLabPlaceholderScreenState
    extends State<AnatomyLabPlaceholderScreen> {
  AnatomyAtlasCatalog? _atlas;
  @override
  void initState() {
    super.initState();
    AnatomyAtlasCatalog.load().then((value) {
      if (mounted) setState(() => _atlas = value);
    }).catchError((Object _) { /* Viewer provides a retry for missing assets. */ });
  }
  final Set<AnatomySystemId> _selected = {
    AnatomySystemId.skeletal,
  };

  void _toggle(AnatomySystemId id) {
    setState(() {
      if (_selected.contains(id)) {
        if (_selected.length > 1) _selected.remove(id);
      } else {
        _selected.add(id);
      }
    });
  }

  void _preset(Set<AnatomySystemId> systems) {
    setState(() {
      _selected
        ..clear()
        ..addAll(systems);
    });
  }

  void _openViewer() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnatomyAtlasScreen(
          initialSystems: Set<AnatomySystemId>.from(_selected),
        ),
      ),
    );
  }

  Future<void> _openQuiz() async {
    try {
      final catalog = _atlas ?? await AnatomyAtlasCatalog.load();
      if (!mounted) return;
      Navigator.of(context).push(MaterialPageRoute<void>(builder: (_) => AnatomyAtlasQuizScreen(
        catalog: catalog, reference: 'male', systems: _selected.map((s) => s.name).toSet())));
    } on Object catch (_) {
      if (mounted) ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('The bundled atlas could not be opened. Try the viewer to retry.')));
    }
  }

  void _openFunctionPractice() {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => AnatomyQuizScreen(
          selectedSystems: Set<AnatomySystemId>.from(_selected),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final structures = _atlas?.search('male', _selected.map((s) => s.name).toSet(), '') ?? [];

    return Scaffold(
      body: Stack(
        children: [
          const Positioned.fill(child: AnatomyAnimatedBackdrop()),
          SafeArea(
            child: Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 820),
                child: ListView(
                  padding: const EdgeInsets.fromLTRB(18, 12, 18, 40),
                  children: [
                    _Header(onBack: () => Navigator.of(context).maybePop()),
                    const SizedBox(height: 16),
                    _Hero(
                      selectedCount: _selected.length,
                      structureCount: structures.length,
                      onExplore: _openViewer,
                      onQuiz: _openQuiz,
                    ),
                    TextButton.icon(onPressed: _openFunctionPractice, icon: const Icon(Icons.menu_book_outlined),
                      label: const Text('Function & description practice')),
                    const SizedBox(height: 22),
                    const Text(
                      'Quick Layer Presets',
                      style: TextStyle(
                        fontSize: 19,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    _PresetStrip(onPreset: _preset),
                    const SizedBox(height: 24),
                    Row(
                      children: [
                        const Expanded(
                          child: Text(
                            'Body Systems',
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ),
                        Text(
                          '${_selected.length} selected',
                          style: const TextStyle(
                            color: NorieColors.cyan,
                            fontSize: 10,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    const Text(
                      'Select multiple systems to study them together in one layered model.',
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 13),
                    LayoutBuilder(
                      builder: (context, constraints) {
                        final columns = constraints.maxWidth >= 650 ? 2 : 1;
                        const gap = 10.0;
                        final width = (constraints.maxWidth -
                                ((columns - 1) * gap)) /
                            columns;
                        return Wrap(
                          spacing: gap,
                          runSpacing: gap,
                          children: [
                            for (final system in AnatomyCatalog.systems)
                              SizedBox(
                                width: width,
                                child: _SystemCard(
                                  system: system,
                                  selected: _selected.contains(system.id),
                                  onTap: () => _toggle(system.id),
                                ),
                              ),
                          ],
                        );
                      },
                    ),
                    const SizedBox(height: 22),
                    _FeatureSummary(
                      onExplore: _openViewer,
                      onQuiz: _openQuiz,
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
            backgroundColor: NorieColors.surface.withValues(alpha: .82),
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
                'Norie Anatomy Lab',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Explore · Layer · Identify · Master',
                style: TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 10,
                ),
              ),
            ],
          ),
        ),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
          decoration: BoxDecoration(
            color: NorieColors.green.withValues(alpha: .12),
            borderRadius: BorderRadius.circular(99),
            border: Border.all(
              color: NorieColors.green.withValues(alpha: .38),
            ),
          ),
          child: const Text(
            'LIVE',
            style: TextStyle(
              color: NorieColors.green,
              fontSize: 8,
              letterSpacing: .9,
              fontWeight: FontWeight.w900,
            ),
          ),
        ),
      ],
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({
    required this.selectedCount,
    required this.structureCount,
    required this.onExplore,
    required this.onQuiz,
  });

  final int selectedCount;
  final int structureCount;
  final VoidCallback onExplore;
  final VoidCallback onQuiz;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(29),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF0C284A),
            Color(0xFF18245B),
            Color(0xFF391A59),
          ],
        ),
        border: Border.all(
          color: NorieColors.cyan.withValues(alpha: .42),
        ),
        boxShadow: [
          BoxShadow(
            color: NorieColors.cyan.withValues(alpha: .10),
            blurRadius: 30,
            offset: const Offset(0, 14),
          ),
        ],
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final compact = constraints.maxWidth < 560;
          final copy = Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'ANATOMY LAB 2.0',
                style: TextStyle(
                  color: NorieColors.cyan,
                  fontSize: 9,
                  letterSpacing: 1.6,
                  fontWeight: FontWeight.w900,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Study the body as a\nlayered interactive system.',
                style: TextStyle(
                  fontSize: 27,
                  height: 1.02,
                  fontWeight: FontWeight.w900,
                  letterSpacing: -.7,
                ),
              ),
              const SizedBox(height: 9),
              Text(
                '$selectedCount system layer(s) · $structureCount numbered structures ready to explore',
                style: const TextStyle(
                  color: Color(0xFFC8D7EC),
                  fontSize: 11,
                  height: 1.4,
                ),
              ),
              const SizedBox(height: 14),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                children: [
                  FilledButton.icon(
                    onPressed: onExplore,
                    icon: const Icon(Icons.view_in_ar_rounded),
                    label: const Text('Open 3D Viewer'),
                    style: FilledButton.styleFrom(
                      backgroundColor: NorieColors.cyan,
                      foregroundColor: NorieColors.background,
                    ),
                  ),
                  OutlinedButton.icon(
                    onPressed: onQuiz,
                    icon: const Icon(Icons.quiz_rounded),
                    label: const Text('Quiz Selected'),
                  ),
                ],
              ),
            ],
          );

          final visual = const _BodyOrb();

          if (compact) {
            return Column(
              children: [
                visual,
                const SizedBox(height: 18),
                copy,
              ],
            );
          }

          return Row(
            children: [
              Expanded(flex: 6, child: copy),
              const SizedBox(width: 16),
              const Expanded(flex: 4, child: _BodyOrb()),
            ],
          );
        },
      ),
    );
  }
}

class _BodyOrb extends StatelessWidget {
  const _BodyOrb();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 190,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: RadialGradient(
          colors: [
            NorieColors.cyan.withValues(alpha: .22),
            NorieColors.violet.withValues(alpha: .12),
            Colors.transparent,
          ],
        ),
        border: Border.all(
          color: NorieColors.cyan.withValues(alpha: .23),
        ),
      ),
      child: const Stack(
        alignment: Alignment.center,
        children: [
          Icon(
            Icons.accessibility_new_rounded,
            size: 125,
            color: Color(0xFFE9FCFF),
          ),
          Positioned(
            top: 32,
            right: 42,
            child: _GlowDot(color: NorieColors.magenta),
          ),
          Positioned(
            bottom: 45,
            left: 35,
            child: _GlowDot(color: NorieColors.cyan),
          ),
          Positioned(
            bottom: 24,
            right: 53,
            child: _GlowDot(color: NorieColors.green),
          ),
        ],
      ),
    );
  }
}

class _GlowDot extends StatelessWidget {
  const _GlowDot({required this.color});
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

class _PresetStrip extends StatelessWidget {
  const _PresetStrip({required this.onPreset});

  final ValueChanged<Set<AnatomySystemId>> onPreset;

  @override
  Widget build(BuildContext context) {
    final presets = <(String, IconData, Set<AnatomySystemId>)>[
      (
        'Movement',
        Icons.directions_run_rounded,
        {
          AnatomySystemId.skeletal,
          AnatomySystemId.articular,
          AnatomySystemId.muscular,
        },
      ),
      (
        'Circulation',
        Icons.favorite_rounded,
        {
          AnatomySystemId.cardiovascular,
          AnatomySystemId.arterial,
          AnatomySystemId.venous,
        },
      ),
      (
        'Neuro',
        Icons.psychology_rounded,
        {
          AnatomySystemId.nervous,
          AnatomySystemId.sensory,
        },
      ),
      (
        'Internal',
        Icons.biotech_rounded,
        {
          AnatomySystemId.respiratory,
          AnatomySystemId.digestive,
          AnatomySystemId.urinary,
          AnatomySystemId.endocrine,
        },
      ),
    ];

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: presets.length,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final preset = presets[index];
          return ActionChip(
            avatar: Icon(preset.$2, size: 17, color: NorieColors.cyan),
            label: Text(preset.$1),
            onPressed: () => onPreset(preset.$3),
          );
        },
      ),
    );
  }
}

class _SystemCard extends StatelessWidget {
  const _SystemCard({
    required this.system,
    required this.selected,
    required this.onTap,
  });

  final AnatomySystem system;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected
          ? system.color.withValues(alpha: .12)
          : NorieColors.surface.withValues(alpha: .80),
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(
              color: selected
                  ? system.color
                  : system.color.withValues(alpha: .24),
              width: selected ? 1.6 : 1,
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: system.color.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(13),
                ),
                child: Icon(system.icon, color: system.color),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      system.label,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      system.subtitle,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 9.5,
                        height: 1.3,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${system.structures.length} foundation structures',
                      style: TextStyle(
                        color: system.color,
                        fontSize: 8,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                  ],
                ),
              ),
              AnimatedSwitcher(
                duration: const Duration(milliseconds: 160),
                child: selected
                    ? Icon(
                        Icons.check_circle_rounded,
                        key: const ValueKey('on'),
                        color: system.color,
                      )
                    : const Icon(
                        Icons.add_circle_outline_rounded,
                        key: ValueKey('off'),
                        color: NorieColors.textSecondary,
                      ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _FeatureSummary extends StatelessWidget {
  const _FeatureSummary({
    required this.onExplore,
    required this.onQuiz,
  });

  final VoidCallback onExplore;
  final VoidCallback onQuiz;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(17),
      decoration: BoxDecoration(
        color: NorieColors.surface.withValues(alpha: .78),
        borderRadius: BorderRadius.circular(21),
        border: Border.all(color: NorieColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Lab Tools',
            style: TextStyle(
              fontSize: 17,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 11),
          const Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _ToolPill(icon: Icons.threed_rotation_rounded, label: 'Rotate'),
              _ToolPill(icon: Icons.zoom_in_rounded, label: 'Zoom'),
              _ToolPill(icon: Icons.pan_tool_alt_rounded, label: 'Pan'),
              _ToolPill(icon: Icons.pin_drop_rounded, label: 'Number markers'),
              _ToolPill(icon: Icons.layers_rounded, label: 'Multi-layer'),
              _ToolPill(icon: Icons.tune_rounded, label: 'Viewer settings'),
              _ToolPill(icon: Icons.quiz_rounded, label: 'Identification quiz'),
              _ToolPill(icon: Icons.auto_awesome_rounded, label: 'Animated UI'),
            ],
          ),
          const SizedBox(height: 15),
          Row(
            children: [
              Expanded(
                child: FilledButton.icon(
                  onPressed: onExplore,
                  icon: const Icon(Icons.view_in_ar_rounded),
                  label: const Text('Explore'),
                ),
              ),
              const SizedBox(width: 9),
              Expanded(
                child: OutlinedButton.icon(
                  onPressed: onQuiz,
                  icon: const Icon(Icons.quiz_rounded),
                  label: const Text('Quiz'),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ToolPill extends StatelessWidget {
  const _ToolPill({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 6),
      decoration: BoxDecoration(
        color: NorieColors.cyan.withValues(alpha: .06),
        borderRadius: BorderRadius.circular(99),
        border: Border.all(
          color: NorieColors.cyan.withValues(alpha: .20),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: NorieColors.cyan),
          const SizedBox(width: 5),
          Text(
            label,
            style: const TextStyle(
              fontSize: 8.5,
              fontWeight: FontWeight.w800,
            ),
          ),
        ],
      ),
    );
  }
}
