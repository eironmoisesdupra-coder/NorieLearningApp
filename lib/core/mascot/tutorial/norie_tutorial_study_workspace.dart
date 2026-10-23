import 'package:flutter/material.dart';

import '../../theme/norie_theme.dart';
import 'norie_tutorial_models.dart';
import 'norie_tutorial_overlay.dart';

/// A deliberately in-memory demonstration, with no study service or store.
/// Touring the library must not depend on a learner's cloud account or decks.
class NorieTutorialStudyWorkspace extends StatefulWidget {
  const NorieTutorialStudyWorkspace({required this.step, super.key});

  final NorieTutorialStep step;

  @override
  State<NorieTutorialStudyWorkspace> createState() =>
      _NorieTutorialStudyWorkspaceState();
}

class _NorieTutorialStudyWorkspaceState
    extends State<NorieTutorialStudyWorkspace> {
  bool _revealed = false;
  bool _deleted = false;
  bool _dueOnly = false;
  String _query = '';
  String? _feedback;

  static const _source =
      'Evaporation is the change from liquid water to water vapour. '
      'Warmth can speed up evaporation. Water can evaporate without boiling.';

  @override
  Widget build(BuildContext context) {
    final step = widget.step;
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: const Text('Practice space'),
      ),
      body: Align(
        alignment: Alignment.topLeft,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 760),
          child: ListView(
            padding: const EdgeInsets.fromLTRB(20, 8, 20, 360),
            children: [
              const Text('OFFLINE TUTORIAL SAMPLE',
                  style: TextStyle(
                      color: NorieColors.cyan,
                      fontWeight: FontWeight.w900,
                      letterSpacing: 1.2,
                      fontSize: 12)),
              const SizedBox(height: 6),
              const Text(
                  'Try the controls. Nothing here changes your saved study sets, review schedule, XP, or credits.',
                  style: TextStyle(color: NorieColors.textSecondary)),
              const SizedBox(height: 14),
              NorieTutorialTarget(
                id: 'tutorial.sample.${step.id}',
                child: Card(
                  key: ValueKey('tutorial-sample-${step.id}'),
                  color: NorieColors.surface,
                  child: Padding(
                    padding: const EdgeInsets.all(18),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(children: [
                          const Icon(Icons.style_rounded,
                              color: NorieColors.cyan),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Text(
                                step.id.startsWith('qa-')
                                    ? 'Ask with evidence'
                                    : 'Water detectives • sample deck',
                                style: const TextStyle(
                                    fontSize: 19, fontWeight: FontWeight.w900)),
                          ),
                        ]),
                        const SizedBox(height: 12),
                        ..._controls(step.id),
                        if (_feedback != null) ...[
                          const SizedBox(height: 12),
                          Semantics(
                            liveRegion: true,
                            child: Text(_feedback!,
                                style: const TextStyle(
                                    color: NorieColors.cyan,
                                    fontWeight: FontWeight.w700)),
                          ),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Widget> _controls(String id) => switch (id) {
        'library-find' => [
            TextField(
              decoration: const InputDecoration(
                  labelText: 'Search sample decks',
                  prefixIcon: Icon(Icons.search_rounded)),
              onChanged: (value) =>
                  setState(() => _query = value.trim().toLowerCase()),
            ),
            CheckboxListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Due now'),
              value: _dueOnly,
              onChanged: (value) => setState(() => _dueOnly = value ?? false),
            ),
            if ('water detectives evaporation'.contains(_query))
              Text(_dueOnly
                  ? 'Water detectives • 1 sample card due'
                  : 'Water detectives • 2 sample cards • 1 due')
            else
              const Text('No matching sample decks. Try “water”.'),
          ],
        'library-edit' => [
            const Text('A useful card asks one clear question.'),
            const SizedBox(height: 8),
            TextFormField(
              initialValue: 'What happens during evaporation?',
              decoration: const InputDecoration(labelText: 'Sample prompt'),
            ),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => setState(() => _feedback =
                  'Sample correction applied here only. Your real cards are unchanged.'),
              icon: const Icon(Icons.check_rounded),
              label: const Text('Apply sample correction'),
            ),
          ],
        'library-delete' => [
            Text(_deleted
                ? 'The sample card is hidden. Your real decks are untouched.'
                : 'Sample card: What is evaporation?'),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => setState(() => _deleted = !_deleted),
              icon: Icon(
                  _deleted ? Icons.undo_rounded : Icons.delete_outline_rounded),
              label: Text(_deleted ? 'Reset sample' : 'Remove sample card'),
            ),
            const Text(
                'Real deck deletion asks for confirmation and has no undo. This demonstration can be reset.'),
          ],
        'review-due' => [
            const Text('Choose what you want to review.'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              ChoiceChip(
                label: const Text('Due review'),
                selected: _dueOnly,
                onSelected: (_) => setState(() => _dueOnly = true),
              ),
              ChoiceChip(
                label: const Text('Browse cards'),
                selected: !_dueOnly,
                onSelected: (_) => setState(() => _dueOnly = false),
              ),
            ]),
            Text(_dueOnly
                ? '1 sample card needs review now.'
                : 'Browse both sample cards without a scored quiz.'),
          ],
        'review-reveal' => [
            const Text('What happens during evaporation?'),
            const SizedBox(height: 8),
            if (_revealed)
              const Text('Water changes from liquid to water vapour.')
            else
              FilledButton.icon(
                onPressed: () => setState(() => _revealed = true),
                icon: const Icon(Icons.visibility_outlined),
                label: const Text('Reveal sample answer'),
              ),
          ],
        'review-rate' => [
            const Text('How easily did you recall the sample answer?'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              for (final rating in ['Again', 'Hard', 'Got it'])
                OutlinedButton(
                    onPressed: () => setState(() => _feedback =
                        '$rating selected for this example. Your real review schedule is unchanged.'),
                    child: Text(rating)),
            ]),
          ],
        'qa-source' => [
            const Text('SAMPLE SOURCE',
                style: TextStyle(fontWeight: FontWeight.w800)),
            const Text(_source),
            const SizedBox(height: 8),
            FilledButton.icon(
              onPressed: () => setState(() => _revealed = true),
              icon: const Icon(Icons.question_answer_outlined),
              label: const Text('Ask sample question'),
            ),
            if (_revealed) ...[
              const Text('Example response • no AI request',
                  style: TextStyle(color: NorieColors.cyan)),
              const Text(
                  'Why does the warm dish lose more water? The source says: “Warmth can speed up evaporation.”'),
            ],
          ],
        'qa-limits' => [
            const Text('Does this source explain how clouds form?'),
            const Text(_source),
            const SizedBox(height: 8),
            OutlinedButton.icon(
              onPressed: () => setState(() => _feedback =
                  'This source does not explain cloud formation. Use a source about condensation rather than guessing.'),
              icon: const Icon(Icons.fact_check_outlined),
              label: const Text('Check sample evidence'),
            ),
          ],
        _ => [
            const Text('App directions or a source question?'),
            const SizedBox(height: 8),
            Wrap(spacing: 8, runSpacing: 8, children: [
              ActionChip(
                avatar: const Icon(Icons.explore_outlined),
                label: const Text('Where are my lessons?'),
                onPressed: () => setState(() => _feedback =
                    'App help: open Learn, choose a subject, then select a grade or topic.'),
              ),
              ActionChip(
                avatar: const Icon(Icons.menu_book_outlined),
                label: const Text('Why does water evaporate?'),
                onPressed: () => setState(() => _feedback =
                    'Study question: use a lesson or open a saved source so you can check the evidence.'),
              ),
            ]),
          ],
      };
}
