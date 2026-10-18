import 'package:flutter/material.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_atlas_quiz_policy.dart';
import '../domain/anatomy_models.dart';
import 'anatomy_atlas_quiz_screen.dart';

class AnatomyAtlasQuizSetupScreen extends StatefulWidget {
  const AnatomyAtlasQuizSetupScreen({
    required this.catalog,
    required this.reference,
    required this.systems,
    super.key,
  });

  final AnatomyAtlasCatalog catalog;
  final String reference;
  final Set<String> systems;

  @override
  State<AnatomyAtlasQuizSetupScreen> createState() =>
      _AnatomyAtlasQuizSetupScreenState();
}

class _AnatomyAtlasQuizSetupScreenState
    extends State<AnatomyAtlasQuizSetupScreen> {
  late String _reference = widget.reference;
  late Set<String> _systems = {...widget.systems};
  int _requestedCount = AtlasQuizSession.questionCount;
  AtlasQuizDifficulty _difficulty = AtlasQuizDifficulty.standard;
  final _kinds = <AtlasQuestionKind>{AtlasQuestionKind.identify};

  int _count(Set<String> systems) =>
      AtlasQuizSession.eligibleStructures(widget.catalog, _reference, systems,
              kinds: _kinds)
          .map((structure) => structure.name)
          .toSet()
          .length;

  bool get _canStartShort =>
      _kinds.isNotEmpty &&
      _count(_systems) >= (_kinds.contains(AtlasQuestionKind.identify) ? 2 : 1);

  void _start() {
    final audio = NorieAudioManager.instance;
    audio.unlock();
    audio.playChallengeStart();
    Navigator.push(
      context,
      MaterialPageRoute<void>(
        builder: (_) => AnatomyAtlasQuizScreen(
          catalog: widget.catalog,
          reference: _reference,
          systems: {..._systems},
          requestedCount: _requestedCount,
          difficulty: _difficulty,
          kinds: {..._kinds},
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final available = _count(_systems);
    final audio = NorieAudioManager.instance;
    return Scaffold(
      appBar: AppBar(title: const Text('Atlas quiz setup')),
      body: SafeArea(
        child: Column(children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16),
              children: [
                Text('Choose your anatomy challenge',
                    style: Theme.of(context).textTheme.titleLarge),
                const SizedBox(height: 16),
                DropdownButtonFormField<String>(
                  key: ValueKey(_reference),
                  initialValue: _reference,
                  isExpanded: true,
                  decoration: const InputDecoration(labelText: 'Reference'),
                  items: [
                    const DropdownMenuItem(
                        value: 'all', child: Text('All available references')),
                    for (final reference in widget.catalog.references)
                      DropdownMenuItem(
                          value: reference.id,
                          child: Text(reference.label,
                              overflow: TextOverflow.ellipsis)),
                  ],
                  onChanged: (value) {
                    if (value != null) setState(() => _reference = value);
                  },
                ),
                const SizedBox(height: 12),
                Wrap(spacing: 8, children: [
                  TextButton.icon(
                    icon: const Icon(Icons.select_all),
                    label: const Text('Every part'),
                    onPressed: () => setState(() {
                      _reference = 'all';
                      _systems = AnatomyCatalog.systems
                          .map((system) => system.id.name)
                          .toSet();
                    }),
                  ),
                  TextButton.icon(
                    icon: const Icon(Icons.deselect),
                    label: const Text('Clear selection'),
                    onPressed: () => setState(() => _systems = {}),
                  ),
                ]),
                for (final system in AnatomyCatalog.systems)
                  CheckboxListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: Icon(system.icon, color: system.color),
                    title: Text(system.label),
                    subtitle:
                        Text('${_count({system.id.name})} distinct parts'),
                    value: _systems.contains(system.id.name),
                    onChanged: _count({system.id.name}) == 0
                        ? null
                        : (selected) => setState(() {
                              selected == true
                                  ? _systems.add(system.id.name)
                                  : _systems.remove(system.id.name);
                            }),
                  ),
                const SizedBox(height: 16),
                Text('Number of questions',
                    style: Theme.of(context).textTheme.titleMedium),
                Wrap(spacing: 8, children: [
                  for (final count in [5, 10, 20])
                    ChoiceChip(
                      label: Text('$count questions'),
                      selected: _requestedCount == count,
                      onSelected: (_) =>
                          setState(() => _requestedCount = count),
                    ),
                ]),
                const SizedBox(height: 12),
                Text('Difficulty',
                    style: Theme.of(context).textTheme.titleMedium),
                Wrap(spacing: 8, children: [
                  for (final entry in const {
                    AtlasQuizDifficulty.guided: 'Guided',
                    AtlasQuizDifficulty.standard: 'Standard',
                    AtlasQuizDifficulty.challenge: 'Challenge',
                  }.entries)
                    ChoiceChip(
                      label: Text(entry.value),
                      selected: _difficulty == entry.key,
                      onSelected: (_) =>
                          setState(() => _difficulty = entry.key),
                    ),
                ]),
                Text(switch (_difficulty) {
                  AtlasQuizDifficulty.guided =>
                    'Two answer choices and hints shown automatically.',
                  AtlasQuizDifficulty.standard =>
                    'Up to four answer choices. Open a hint when needed.',
                  AtlasQuizDifficulty.challenge =>
                    'Up to six answer choices. Try answering before opening a hint.',
                }),
                const SizedBox(height: 12),
                Text('Question types',
                    style: Theme.of(context).textTheme.titleMedium),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('Identify structures'),
                  value: _kinds.contains(AtlasQuestionKind.identify),
                  onChanged: (selected) => setState(() {
                    selected == true
                        ? _kinds.add(AtlasQuestionKind.identify)
                        : _kinds.remove(AtlasQuestionKind.identify);
                  }),
                ),
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  title: const Text('System membership'),
                  subtitle: const Text(
                      'Use atlas catalog groups. Parts listed under several systems are identified instead, or excluded in system-only quizzes.'),
                  value: _kinds.contains(AtlasQuestionKind.system),
                  onChanged: (selected) => setState(() {
                    selected == true
                        ? _kinds.add(AtlasQuestionKind.system)
                        : _kinds.remove(AtlasQuestionKind.system);
                  }),
                ),
                if (_kinds.isEmpty)
                  const Text('Choose at least one question type.'),
                if (available < _requestedCount) ...[
                  Text(
                      'Only $available distinct parts are available for these settings. '
                      'Select more systems or references, or choose a shorter quiz. '
                      'Parts will not repeat.'),
                  if (_canStartShort)
                    OutlinedButton.icon(
                      onPressed: _start,
                      icon: const Icon(Icons.play_arrow),
                      label: Text('Start shorter $available-question quiz'),
                    ),
                ],
                ListenableBuilder(
                  listenable: audio,
                  builder: (context, _) => SwitchListTile(
                    contentPadding: EdgeInsets.zero,
                    secondary: const Icon(Icons.music_note),
                    title: const Text('Background music'),
                    value: audio.musicEnabled,
                    onChanged: (enabled) async {
                      await audio.unlock();
                      await audio.setMusicEnabled(enabled);
                    },
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(mainAxisSize: MainAxisSize.min, children: [
              Text('$available distinct parts selected'),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: Text('Start $_requestedCount-question quiz'),
                  onPressed: _kinds.isEmpty || available < _requestedCount
                      ? null
                      : _start,
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
