import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../discovery/data/discovery_store.dart';
import '../../discovery/domain/discovery_mission.dart';
import '../../discovery/presentation/discovery_screen.dart';
import '../domain/subject_adventures.dart';

class SubjectAdventureHub extends StatefulWidget {
  const SubjectAdventureHub({
    required this.adventure,
    required this.accent,
    super.key,
  });

  final SubjectAdventure adventure;
  final Color accent;

  @override
  State<SubjectAdventureHub> createState() => _SubjectAdventureHubState();
}

class _SubjectAdventureHubState extends State<SubjectAdventureHub> {
  DiscoveryStore? _discovery;

  @override
  void initState() {
    super.initState();
    // The only published case is Science's existing ungraded pilot.
    if (widget.adventure.playable && widget.adventure.subject == 'Science') {
      _readProgress();
    }
  }

  void _readProgress() {
    _discovery?.removeListener(_changed);
    _discovery?.dispose();
    _discovery = DiscoveryStore()..addListener(_changed);
    unawaited(_discovery!.initialize());
  }

  Future<void> _openInvestigation() async {
    // The case owns its session, including temporary recovery progress.
    await Navigator.of(context).push(MaterialPageRoute<void>(
      builder: (_) => const DiscoveryScreen(),
    ));
    if (mounted) _readProgress();
  }

  void _changed() {
    if (mounted) setState(() {});
  }

  @override
  void dispose() {
    _discovery?.removeListener(_changed);
    _discovery?.dispose();
    super.dispose();
  }

  String get _progress {
    final store = _discovery!;
    if (store.error != null) {
      return 'Progress unavailable · open case for recovery';
    }
    if (!store.ready) return 'Reading local progress…';
    if (store.state.complete) {
      return 'Case complete · saved in Discovery Journal';
    }
    if (store.state.stage == DiscoveryStage.inspect &&
        store.state.clues.isEmpty) {
      return 'Not started';
    }
    return 'In progress · ${store.state.stage.index}/4 investigation steps complete';
  }

  @override
  Widget build(BuildContext context) {
    final adventure = widget.adventure;
    final playable = _discovery != null;
    return Scaffold(
      appBar: AppBar(title: Text('${adventure.subject} Adventure')),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 36),
              children: [
                Icon(playable ? Icons.science_rounded : Icons.explore_rounded,
                    color: widget.accent, size: 64),
                const SizedBox(height: 20),
                Text(adventure.title,
                    style: const TextStyle(
                        fontSize: 28, fontWeight: FontWeight.w900)),
                const SizedBox(height: 12),
                Text(
                  playable
                      ? 'Experimental · ungraded · works offline'
                      : 'Planned preview · not playable',
                  style: TextStyle(
                      color: widget.accent, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 16),
                Text(adventure.description,
                    style: const TextStyle(height: 1.5)),
                const SizedBox(height: 20),
                Text(playable ? 'Concepts in this case' : 'Planned concepts',
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.w800)),
                const SizedBox(height: 10),
                for (final concept in adventure.concepts)
                  Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text('• $concept'),
                  ),
                const SizedBox(height: 12),
                Text(
                  playable
                      ? 'Recommended for Grades 4–6, pending teacher review. This single pilot explores evaporation; it does not cover a whole grade or replace Classic Lessons.'
                      : 'This adventure has no published missions or grade coverage yet. These concepts describe the plan, not lessons taught here. Use Classic Lessons for available offline learning.',
                  style: const TextStyle(
                      color: NorieColors.textSecondary, height: 1.5),
                ),
                if (playable) ...[
                  const SizedBox(height: 20),
                  Text(_progress,
                      style: const TextStyle(fontWeight: FontWeight.w700)),
                  const SizedBox(height: 12),
                  const Text(
                    'Progress saves locally; completed cases enter your Discovery Journal. This activity does not award XP, credits, or course mastery.',
                    style: TextStyle(
                        color: NorieColors.textSecondary, height: 1.5),
                  ),
                  const SizedBox(height: 20),
                  FilledButton.icon(
                    onPressed: _openInvestigation,
                    icon: const Icon(Icons.explore_rounded),
                    label: const Text('Open investigation'),
                  ),
                ],
                const SizedBox(height: 12),
                OutlinedButton.icon(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.menu_book_rounded),
                  label: const Text('Back to Classic Lessons'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
