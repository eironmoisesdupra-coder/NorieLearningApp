import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/mascot/norie_mascot_controller.dart';
import '../../../core/mascot/norie_mascot_scope.dart';
import '../data/anatomy_study_store.dart';
import '../domain/anatomy_atlas_catalog.dart';
import '../domain/anatomy_guided_learning.dart';
import 'anatomy_atlas_controller.dart';
import 'anatomy_atlas_model_view.dart';

/// Seven-step, offline catalog identification guides. No medical explanations
/// or mastery awards are implied by completing these navigation activities.
class AnatomyGuidedLearningScreen extends StatefulWidget {
  const AnatomyGuidedLearningScreen({
    required this.catalog,
    this.initialStructureId,
    this.store,
    super.key,
  });

  final AnatomyAtlasCatalog catalog;
  final String? initialStructureId;
  final AnatomyStudyStore? store;

  @override
  State<AnatomyGuidedLearningScreen> createState() =>
      _AnatomyGuidedLearningScreenState();
}

class _AnatomyGuidedLearningScreenState
    extends State<AnatomyGuidedLearningScreen> with WidgetsBindingObserver {
  final _controller = AnatomyAtlasController();
  late final AnatomyStudyStore _store;
  bool _showChoices = false;
  bool _helpUsed = false;
  bool _answered = false;
  bool _modelLoaded = false;
  Object _modelSession = Object();
  String? _modelConfiguration;
  String? _activity, _feedback, _explored;
  NorieMascotController? _hintController;
  String? _ownedHint;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _store = widget.store ?? AnatomyStudyStore(catalog: widget.catalog);
    _store.addListener(_studyChanged);
    unawaited(_open());
  }

  Future<void> _open() async {
    final initialization = _store.initialize();
    final ownerIsCurrent = _store.captureOwnerGuard();
    await initialization;
    if (!mounted || !ownerIsCurrent()) return;
    final initial = widget.initialStructureId;
    // An explicit Explorer target takes priority over the last selected guide.
    // select preserves any saved step/evidence belonging to that target.
    if (initial != null) _store.select(initial);
    _studyChanged();
  }

  void _studyChanged() {
    if (!mounted) return;
    final current = _store.current;
    final activity =
        current == null ? null : '${current.structureId}:${current.step.name}';
    final checking = current?.step == AnatomyStudyStep.practice ||
        current?.step == AnatomyStudyStep.apply;
    final configuration =
        current == null ? null : '${current.structureId}:$checking';
    if (_activity != activity || !_store.ready) _clearOwnedHint();
    setState(() {
      if (_modelConfiguration != configuration || !_store.ready) {
        _modelLoaded = false;
        _modelConfiguration = configuration;
      }
      if (!_store.ready) _modelSession = Object();
      if (_activity != activity || !_store.ready) {
        _activity = activity;
        _helpUsed = current?.answersRevealed ?? false;
        _answered = false;
        _feedback = null;
        _explored = null;
      }
    });
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state != AppLifecycleState.resumed) unawaited(_store.flush());
  }

  @override
  void dispose() {
    _clearOwnedHint();
    WidgetsBinding.instance.removeObserver(this);
    _store.removeListener(_studyChanged);
    if (widget.store == null) {
      // Keep the owned store alive until its last mutation reaches storage.
      unawaited(_store.flush().whenComplete(_store.dispose));
    }
    _controller.dispose();
    super.dispose();
  }

  AtlasStructure? get _structure {
    final id = _store.current?.structureId;
    for (final structure in widget.catalog.structures) {
      if (structure.id == id) return structure;
    }
    return null;
  }

  String _referenceLabel(String id) => widget.catalog.references
      .firstWhere((reference) => reference.id == id)
      .label;

  void _choose(AtlasStructure structure) {
    _store.select(structure.id);
    _setGuideVisible(true);
  }

  void _setGuideVisible(bool visible) {
    _clearOwnedHint();
    setState(() {
      _showChoices = !visible;
      _modelLoaded = false;
      _modelSession = Object();
    });
  }

  void _clearOwnedHint() {
    if (_ownedHint != null && _hintController?.speech == _ownedHint) {
      _hintController?.stopSpeaking();
    }
    _ownedHint = null;
    _hintController = null;
  }

  void _help(AtlasStructure structure) {
    final text = '${structure.name}. Catalog systems: '
        '${structure.systems.join(', ')}. Compare the highlighted part with '
        'its name. Later checks on this entry count as assisted practice.';
    setState(() => _helpUsed = true);
    _store.recordAnswerReveal();
    _hintController = NorieMascotScope.maybeOf(context)?.controller;
    _ownedHint = text;
    _hintController?.speak(text);
  }

  void _answer(bool correct) {
    if (_answered || !_modelLoaded) return;
    final assisted = _helpUsed || (_store.current?.answersRevealed ?? true);
    setState(() {
      _answered = true;
      _feedback = correct
          ? (assisted
              ? 'Correct. Saved as assisted or repeat practice.'
              : 'Correct. Saved as an independent check.')
          : (assisted
              ? 'Keep comparing. Saved as assisted or repeat practice.'
              : 'Keep comparing. Saved as an independent attempt.');
    });
    _store.recordCheck(correct: correct, assisted: assisted);
  }

  Widget _choices() {
    final modules = AnatomyGuidedModule.representativePaths(widget.catalog);
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text('Choose a catalog guide',
          style: Theme.of(context).textTheme.titleLarge),
      const SizedBox(height: 8),
      const Text('Learn a model name and its listed system. These guides use '
          'published catalog metadata. Medical explanations await human review.'),
      if (_store.current != null) ...[
        const SizedBox(height: 12),
        FilledButton(
            onPressed: () => _setGuideVisible(true),
            child: const Text('Resume current guide')),
      ],
      for (final module in modules)
        Card(
            child: ListTile(
          title: Text(module.structure.name),
          subtitle: Text('${module.structure.systems.join(', ')} · '
              '${_referenceLabel(module.structure.reference)}'),
          trailing: const Icon(Icons.chevron_right),
          onTap: () => _choose(module.structure),
        )),
      if (modules.isEmpty)
        const Padding(
            padding: EdgeInsets.all(16),
            child: Text('No sample guides are available in this catalog. '
                'Select a structure in the explorer to start its metadata guide.')),
    ]);
  }

  Widget _metadata(AtlasStructure structure) => Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(structure.name, style: Theme.of(context).textTheme.titleLarge),
          Text('Catalog systems: ${structure.systems.join(', ')}'),
          Text('Model reference: ${_referenceLabel(structure.reference)}'),
          Text('Source: ${structure.source}'),
          if (structure.ontology.isNotEmpty)
            Text('Source identifier: ${structure.ontology}'),
        ],
      );

  Widget _check(AtlasStructure structure, {required bool apply}) {
    final candidates = widget.catalog.structures
        .where((part) =>
            part.reference == structure.reference && part.id != structure.id)
        .toList()
      ..sort((a, b) {
        final aSame = a.systems.intersection(structure.systems).isNotEmpty;
        final bSame = b.systems.intersection(structure.systems).isNotEmpty;
        return aSame == bSame ? a.name.compareTo(b.name) : (aSame ? -1 : 1);
      });
    final options = [structure, ...candidates.take(3)]
      ..sort((a, b) => a.name.compareTo(b.name));
    final systems = widget.catalog.structures
        .where((part) => part.reference == structure.reference)
        .expand((part) => part.systems)
        .toSet()
        .toList()
      ..sort();
    final available = apply ? systems.length > 1 : options.length > 1;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Text(apply
          ? 'Which system is listed for this highlighted part?'
          : 'What is the highlighted part called?'),
      const SizedBox(height: 8),
      const Text('The first answer before revealing help can record an '
          'independent check. Once help or feedback reveals this entry, later '
          'checks are assisted or repeat practice. This checks catalog recall, '
          'not medical knowledge.'),
      if (!_modelLoaded)
        const Text('Answers unlock when the highlighted model is ready. '
            'If it is unavailable, skip this step and return later.'),
      if (!available)
        const Text('Independent check unavailable: this reference needs more '
            'comparison entries.'),
      if (available && apply)
        for (final system in systems)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton(
                  key: ValueKey('system-$system'),
                  onPressed: _answered || !_modelLoaded
                      ? null
                      : () => _answer(structure.systems.contains(system)),
                  child: Text(system))),
      if (available && !apply)
        for (final option in options)
          Padding(
              padding: const EdgeInsets.only(top: 8),
              child: OutlinedButton(
                  key: ValueKey('answer-${option.id}'),
                  onPressed: _answered || !_modelLoaded
                      ? null
                      : () => _answer(option.id == structure.id),
                  child: Text(option.name))),
      const SizedBox(height: 8),
      TextButton.icon(
          onPressed: _answered ? null : () => _help(structure),
          icon: const Icon(Icons.lightbulb_outline),
          label: const Text('Show help')),
      if (_helpUsed)
        Text('Answer reference: ${structure.name} · '
            '${structure.systems.join(', ')}. This attempt is assisted practice.'),
      if (_feedback != null)
        Semantics(liveRegion: true, child: Text(_feedback!)),
      if (_answered) _metadata(structure),
    ]);
  }

  Widget _stepBody(AtlasStructure structure, AnatomyStudyProgress progress) {
    switch (progress.step) {
      case AnatomyStudyStep.discover:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _metadata(structure),
          const SizedBox(height: 12),
          const Text(
              'Your goals: find this entry in the model, recall its name, '
              'and recall a system listed in the catalog. You can skip a step '
              'and return later; skipped steps stay unfinished.'),
        ]);
      case AnatomyStudyStep.locate:
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                  'Find ${structure.name} in this reference. Tap the highlighted '
                  'part. You can rotate and zoom the model.'),
              OutlinedButton.icon(
                  onPressed: () =>
                      _controller.send('focus', {'id': structure.id}),
                  icon: const Icon(Icons.center_focus_strong),
                  label: const Text('Focus this part')),
              Text(progress.identified
                  ? 'Identified with the guide.'
                  : 'Identification has not been recorded.'),
              if (_feedback != null) Text(_feedback!),
            ]);
      case AnatomyStudyStep.understand:
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _metadata(structure),
              const SizedBox(height: 12),
              const Text(
                  'Description unavailable. Location and function teaching '
                  'is pending human review. This card teaches the source name and '
                  'system classification only.'),
              TextButton(
                  onPressed: _store.recordStudy,
                  child: Text(progress.studied
                      ? 'Catalog card studied'
                      : 'I studied this catalog card')),
              const Text(
                  'Studied is a reading acknowledgement, not proof of learning.'),
            ]);
      case AnatomyStudyStep.explore:
        return Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text('Explore ${structure.systems.join(', ')} in the '
                  '${_referenceLabel(structure.reference)} reference. Tap other '
                  'parts to compare their catalog names.'),
              if (_explored != null) Text('Selected catalog entry: $_explored'),
              OutlinedButton(
                  onPressed: () =>
                      _controller.send('focus', {'id': structure.id}),
                  child: const Text('Return to this part')),
              const Text('Model position is a visual reference. No additional '
                  'location or function claims are made by this guide.'),
            ]);
      case AnatomyStudyStep.practice:
        return _check(structure, apply: false);
      case AnatomyStudyStep.apply:
        return _check(structure, apply: true);
      case AnatomyStudyStep.review:
        return Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          _metadata(structure),
          const SizedBox(height: 12),
          Text(progress.completed
              ? 'Guide completed: all seven steps marked done.'
              : 'Unfinished: ${progress.completedSteps.length} of 7 steps '
                  'marked done. Return to any skipped or unfinished step.'),
          Text(
              'Identified with guide: ${progress.identified ? 'yes' : 'not yet'}'),
          Text('Catalog card studied: ${progress.studied ? 'yes' : 'not yet'}'),
          Text('Assisted or repeat attempts: ${progress.assistedAttempts}'),
          Text('Independent checks: ${progress.independentCorrect} correct '
              'of ${progress.independentAttempts} attempts'),
          const Text('Completion and reading do not establish mastery. These '
              'checks cover catalog recall only; no XP or academic mastery '
              'is awarded. Retained recall has not been assessed.'),
        ]);
    }
  }

  Widget _guide(AtlasStructure structure, AnatomyStudyProgress progress) {
    final checking = progress.step == AnatomyStudyStep.practice ||
        progress.step == AnatomyStudyStep.apply;
    final ownerIsCurrent = _store.captureOwnerGuard();
    final configuration = '${structure.id}:$checking';
    final modelSession = _modelSession;
    bool currentModel() =>
        mounted &&
        ownerIsCurrent() &&
        !_showChoices &&
        identical(_modelSession, modelSession) &&
        _store.current?.structureId == structure.id &&
        _modelConfiguration == configuration;
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Wrap(spacing: 6, runSpacing: 4, children: [
        for (final step in AnatomyStudyStep.values)
          ChoiceChip(
            label: Text('${step.index + 1}. ${step.label}'
                '${progress.skippedSteps.contains(step) ? ' (skipped)' : ''}'),
            selected: step == progress.step,
            onSelected: (_) => _store.goToStep(step),
          ),
      ]),
      const SizedBox(height: 12),
      Semantics(
          header: true,
          child: Text(progress.step.label,
              style: Theme.of(context).textTheme.headlineSmall)),
      const SizedBox(height: 12),
      SizedBox(
          height: 230,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: AnatomyAtlasModelView(
              key: ValueKey((modelSession, structure.id, checking)),
              controller: _controller,
              reference: structure.reference,
              systems: structure.systems,
              target: structure.id,
              quiz: checking,
              onLoaded: (loaded) {
                if (currentModel()) setState(() => _modelLoaded = loaded);
              },
              onSelected: (id) {
                if (!currentModel() || _store.current?.step != progress.step) {
                  return;
                }
                final matches = widget.catalog.structures.where((part) =>
                    part.id == id && part.reference == structure.reference);
                if (matches.isEmpty) return;
                if (progress.step == AnatomyStudyStep.locate) {
                  if (id == structure.id) {
                    _store.recordIdentification();
                  } else {
                    setState(() =>
                        _feedback = 'That entry is ${matches.first.name}. '
                            'Keep looking for ${structure.name}.');
                  }
                }
                if (progress.step == AnatomyStudyStep.explore) {
                  setState(() => _explored = matches.first.name);
                }
              },
            ),
          )),
      const SizedBox(height: 16),
      _stepBody(structure, progress),
      const SizedBox(height: 16),
      FilledButton(
          onPressed: _store.completeStep,
          child: Text(progress.step == AnatomyStudyStep.review
              ? 'Mark review done'
              : 'Mark step done and continue')),
      TextButton(
          onPressed: _store.skipStep, child: const Text('Skip this step')),
      TextButton(
          onPressed: () => _setGuideVisible(false),
          child: const Text('Choose another guide')),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    final structure = _structure;
    final progress = _store.current;
    return Scaffold(
      appBar: AppBar(title: const Text('Guided anatomy')),
      body: SafeArea(
          child: !_store.ready
              ? const Center(child: CircularProgressIndicator())
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      if (_store.saveError != null) ...[
                        Text(_store.saveError!),
                        TextButton(
                            onPressed: () => unawaited(_store.flush()),
                            child: const Text('Retry saving')),
                      ],
                      if (_showChoices || structure == null || progress == null)
                        _choices()
                      else
                        _guide(structure, progress),
                    ],
                  ),
                )),
    );
  }
}
