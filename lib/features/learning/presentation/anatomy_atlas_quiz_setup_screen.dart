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

  int _count(Set<String> systems) =>
      AtlasQuizSession.eligibleStructures(widget.catalog, _reference, systems)
          .map((structure) => structure.name)
          .toSet()
          .length;

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
              if (available < AtlasQuizSession.questionCount)
                const Text(
                    'Select more systems or references to reach 20 distinct parts.',
                    textAlign: TextAlign.center),
              const SizedBox(height: 8),
              SizedBox(
                width: double.infinity,
                child: FilledButton.icon(
                  icon: const Icon(Icons.play_arrow),
                  label: const Text('Start 20-question quiz'),
                  onPressed: available < AtlasQuizSession.questionCount
                      ? null
                      : () {
                          audio.unlock();
                          audio.playChallengeStart();
                          Navigator.push(
                            context,
                            MaterialPageRoute<void>(
                              builder: (_) => AnatomyAtlasQuizScreen(
                                  catalog: widget.catalog,
                                  reference: _reference,
                                  systems: {..._systems}),
                            ),
                          );
                        },
                ),
              ),
            ]),
          ),
        ]),
      ),
    );
  }
}
