import 'package:flutter/material.dart';

import '../../../core/progression/norie_adventure_progress.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_foundation_curriculum.dart';
import '../domain/norie_educational_collectible.dart';
import 'norie_lesson_screen.dart';
import 'norie_boss_missions_screen.dart';

class NorieCollectiblesScreen extends StatefulWidget {
  const NorieCollectiblesScreen({super.key});

  @override
  State<NorieCollectiblesScreen> createState() =>
      _NorieCollectiblesScreenState();
}

class _NorieCollectiblesScreenState extends State<NorieCollectiblesScreen> {
  String? _subject;
  bool _earnedOnly = false;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Knowledge cards')),
        body: AnimatedBuilder(
          animation: NorieAdventureProgress.instance,
          builder: (context, _) {
            final trophies = NorieAdventureProgress.instance.trophyIds;
            final catalogue = NorieEducationalCollectible.catalogue;
            final earnedCount =
                catalogue.where((card) => card.isEarned(trophies)).length;
            final cards = catalogue
                .where((card) =>
                    (_subject == null || card.subject == _subject) &&
                    (!_earnedOnly || card.isEarned(trophies)))
                .toList();
            return Center(
                child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(padding: const EdgeInsets.all(16), children: [
                Text(
                    '$earnedCount / ${catalogue.length} knowledge cards earned',
                    style: const TextStyle(
                        fontSize: 20, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text(
                    'Study real lesson concepts offline. Preview any card, and earn it by preparing for and passing its Boss Mission.',
                    style: TextStyle(
                        color: NorieColors.textSecondary, height: 1.4)),
                const SizedBox(height: 16),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  ChoiceChip(
                      label: const Text('All subjects'),
                      selected: _subject == null,
                      onSelected: (_) => setState(() => _subject = null)),
                  for (final subject
                      in NorieFoundationCurriculum.supportedSubjects)
                    ChoiceChip(
                        label: Text(subject),
                        selected: _subject == subject,
                        onSelected: (_) => setState(() => _subject = subject)),
                ]),
                const SizedBox(height: 8),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  ChoiceChip(
                      label: const Text('All cards'),
                      selected: !_earnedOnly,
                      onSelected: (_) => setState(() => _earnedOnly = false)),
                  ChoiceChip(
                      label: const Text('Earned only'),
                      selected: _earnedOnly,
                      onSelected: (_) => setState(() => _earnedOnly = true)),
                ]),
                const SizedBox(height: 16),
                if (cards.isEmpty)
                  const Text('No earned cards in this selection yet.'),
                for (final card in cards)
                  Card(
                      child: InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) =>
                                NorieCollectibleDetailScreen(card: card))),
                    child: Padding(
                        padding: const EdgeInsets.all(16),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Icon(
                                  card.isEarned(trophies)
                                      ? Icons.auto_stories_rounded
                                      : Icons.lock_outline,
                                  color: card.isEarned(trophies)
                                      ? NorieColors.cyan
                                      : NorieColors.textSecondary),
                              const SizedBox(height: 8),
                              Text(card.title,
                                  style: const TextStyle(
                                      fontWeight: FontWeight.w900)),
                              const SizedBox(height: 6),
                              Text(card.conceptTitle),
                              const SizedBox(height: 8),
                              Text(
                                  card.isEarned(trophies)
                                      ? 'Earned · Open study card'
                                      : 'Locked · Preview study card',
                                  style: const TextStyle(
                                      color: NorieColors.textSecondary)),
                            ])),
                  )),
              ]),
            ));
          },
        ),
      );
}

class NorieCollectibleDetailScreen extends StatelessWidget {
  const NorieCollectibleDetailScreen({super.key, required this.card});
  final NorieEducationalCollectible card;

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Study card')),
        body: AnimatedBuilder(
          animation: NorieAdventureProgress.instance,
          builder: (context, _) => Center(
              child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(padding: const EdgeInsets.all(20), children: [
              Text(card.title,
                  style: const TextStyle(
                      fontSize: 23, fontWeight: FontWeight.w900)),
              const SizedBox(height: 12),
              Text(
                  card.isEarned(NorieAdventureProgress.instance.trophyIds)
                      ? 'Earned knowledge card'
                      : 'Locked preview',
                  style: const TextStyle(
                      color: NorieColors.cyan, fontWeight: FontWeight.w800)),
              const SizedBox(height: 8),
              Text(card.requirement, style: const TextStyle(height: 1.5)),
              const SizedBox(height: 12),
              FilledButton.icon(
                  onPressed: () => Navigator.of(context).push(
                      MaterialPageRoute<void>(
                          builder: (_) => NorieBossMissionsScreen(
                              subject: card.subject, gradeId: card.gradeId))),
                  icon: const Icon(Icons.flag_outlined),
                  label: const Text('Prepare Boss Mission')),
              if (card.isEarned(NorieAdventureProgress.instance.trophyIds)) ...[
                const SizedBox(height: 12),
                const Text(
                    'Showcase your earned card from Profile → Edit appearance & rank collection.',
                    style: TextStyle(
                        height: 1.5, color: NorieColors.textSecondary)),
              ],
              const SizedBox(height: 24),
              for (final source in card.sources) ...[
                Text(NorieEducationalCollectible.conceptHeading(source),
                    style: const TextStyle(
                        fontSize: 19, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                Text(NorieEducationalCollectible.conceptBody(source),
                    style: const TextStyle(height: 1.6)),
                const SizedBox(height: 12),
                OutlinedButton.icon(
                    onPressed: () => Navigator.of(context).push(
                        MaterialPageRoute<void>(
                            builder: (_) => NorieLessonScreen(topic: source))),
                    icon: const Icon(Icons.menu_book_outlined),
                    label: Text('Study lesson: ${source.title}')),
                const SizedBox(height: 24),
              ],
              const Text('Recap',
                  style: TextStyle(fontSize: 19, fontWeight: FontWeight.w900)),
              const SizedBox(height: 8),
              for (final source in card.sources)
                Padding(
                    padding: const EdgeInsets.only(bottom: 8),
                    child: Text(
                        '${source.title}: ${NorieEducationalCollectible.conceptHeading(source)}',
                        style: const TextStyle(height: 1.5))),
            ]),
          )),
        ),
      );
}
