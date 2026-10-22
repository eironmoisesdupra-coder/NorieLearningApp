import 'dart:async';
import 'package:flutter/material.dart';
import '../../../core/audio/norie_audio_manager.dart';
import '../../../core/mascot/norie_mascot_controller.dart';
import '../data/discovery_store.dart';
import '../domain/discovery_mission.dart';
import 'discovery_dialogue.dart';
import 'discovery_experiment.dart';
import 'discovery_room.dart';

/// Optional ungraded investigation. It does not complete or reward a course.
class DiscoveryScreen extends StatefulWidget {
  const DiscoveryScreen({this.store, super.key});
  final DiscoveryStore? store;
  @override
  State<DiscoveryScreen> createState() => _DiscoveryScreenState();
}

class _DiscoveryScreenState extends State<DiscoveryScreen>
    with WidgetsBindingObserver {
  late final DiscoveryStore _store = widget.store ?? DiscoveryStore();
  final _norie = NorieMascotController();
  late bool Function() _ownerGuard;
  bool _list = false, _skip = false, _silent = true, _foreground = true;
  String? _message, _feedback;
  DiscoveryStage _previousStage = DiscoveryStage.inspect;
  bool? _hypothesis, _application;
  DiscoveryEvidence? _evidence;

  static const _observations = {
    DiscoveryClue.openContainer:
        'The container is open to the air and its water level is lower than the mark. An exposed surface lets liquid water enter the air as vapor.',
    DiscoveryClue.dryTable:
        'No visible puddle is on the tabletop. This supports investigating another route, but a dry table alone cannot prove that no spill or leak happened.',
    DiscoveryClue.warmWindow:
        'This window area is warmer. That suggests a testable idea, rather than proving why water was lost.',
  };
  bool get _active =>
      _foreground && (ModalRoute.of(context)?.isCurrent ?? true);
  bool get _enabled =>
      _active &&
      _store.ready &&
      !_store.busy &&
      (_store.error == null || _store.temporary);

  VoidCallback? _bound(VoidCallback? action) {
    if (action == null) return null;
    final guard = _ownerGuard;
    return () {
      if (mounted && guard() && _active) action();
    };
  }

  ValueChanged<T> _boundValue<T>(ValueChanged<T> action) {
    final guard = _ownerGuard;
    return (value) {
      if (mounted && guard() && _active) action(value);
    };
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _ownerGuard = _store.captureOwnerGuard();
    _store.addListener(_changed);
    unawaited(_store.initialize());
  }

  void _changed() {
    if (!mounted) return;
    if (!_ownerGuard() ||
        (_store.state.stage == DiscoveryStage.inspect &&
            _previousStage != DiscoveryStage.inspect)) {
      _ownerGuard = _store.captureOwnerGuard();
      _message = null;
      _feedback = null;
      _hypothesis = null;
      _application = null;
      _evidence = null;
      _norie.idle();
    }
    _previousStage = _store.state.stage;
    setState(() {});
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    setState(() => _foreground = state == AppLifecycleState.resumed);
    if (!_foreground) _norie.idle();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _store.removeListener(_changed);
    if (widget.store == null) _store.dispose();
    _norie.dispose();
    super.dispose();
  }

  Future<void> _act(Future<bool> Function() action, String message,
      {String? incorrect}) async {
    if (!_enabled) return;
    final guard = _store.captureOwnerGuard();
    final accepted = await action();
    if (!mounted || !guard() || !_active) return;
    if (_store.error != null && !_store.temporary) return;
    if (accepted) {
      setState(() => _message = message);
      if (_store.state.complete) {
        _norie.celebrate();
      } else {
        _norie.idea();
      }
      if (!_silent) unawaited(NorieAudioManager.instance.playUiSelect());
    } else if (incorrect != null) {
      // Feedback on a guided explanation is assistance, not an independent
      // mastery result. The transfer task has no answer-revealing hint.
      if (_store.state.stage.index < DiscoveryStage.apply.index) {
        await _store.requestHint();
      }
      if (!mounted || !guard() || !_active) return;
      setState(() {
        _message = incorrect;
        _feedback = incorrect;
      });
      _norie.think();
    }
  }

  Future<void> _showHint() async {
    if (!_enabled) return;
    final guard = _store.captureOwnerGuard();
    if (!_store.assisted) await _store.requestHint();
    if (!mounted ||
        !guard() ||
        !_active ||
        !_store.assisted ||
        (_store.error != null && !_store.temporary)) {
      return;
    }
    setState(() => _message =
        'Collect the three observations. Keep everything except temperature the same in the comparison. Which result would help test your idea?');
    _norie.think();
  }

  List<Widget> get _answerFeedback => _feedback == null
      ? []
      : [
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Semantics(
                  liveRegion: true,
                  child: Text(_feedback!,
                      key: const ValueKey('discovery-answer-feedback')))),
        ];

  Future<void> _inspect(DiscoveryProp prop) async {
    if (!_enabled) return;
    final clue = switch (prop) {
      DiscoveryProp.container => DiscoveryClue.openContainer,
      DiscoveryProp.table => DiscoveryClue.dryTable,
      DiscoveryProp.window => DiscoveryClue.warmWindow,
      _ => null,
    };
    if (clue != null) {
      if (_store.state.clues.contains(clue) ||
          _store.state.stage != DiscoveryStage.inspect) {
        setState(() => _message = _observations[clue]);
      } else {
        await _act(() => _store.inspect(clue), _observations[clue]!);
      }
    } else {
      setState(() => _message = prop == DiscoveryProp.bench
          ? 'The comparison bench keeps everything except temperature the same. Collect all three observations, then continue to the comparison.'
          : 'Your evidence notebook is below the room. Observations describe what you noticed; an explanation is an idea that must fit the evidence.');
    }
  }

  String get _stageMessage => switch (_store.state.stage) {
        DiscoveryStage.inspect =>
          'Something changed here. The water level is lower. Want to investigate? Inspect the room and record three observations.',
        DiscoveryStage.experiment =>
          'Let’s test the idea fairly. Compare warmer and cooler conditions while keeping the other variables the same.',
        DiscoveryStage.conclude =>
          'What explanation fits the observations and the controlled comparison? Choose both your hypothesis and supporting evidence.',
        DiscoveryStage.apply => _store.applicationAttempts == 0
            ? 'Now try a different situation on your own. No answer hint is shown for this application.'
            : 'This application has been attempted before. Practise the explanation; your earlier attempts stay recorded.',
        DiscoveryStage.complete => _store.temporary
            ? 'You completed this temporary investigation. These changes are not saved.'
            : 'You connected observations, a fair comparison and a new situation. Your case is recorded locally; this is not a course-mastery certificate.',
      };

  Widget _card(String title, List<Widget> children) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
            Text(title, style: Theme.of(context).textTheme.titleLarge),
            const SizedBox(height: 12),
            ...children,
          ])));
  Widget _choice<T>(String label, T choice) => RadioListTile<T>(
      title: Text(label),
      value: choice,
      enabled: _enabled,
      contentPadding: EdgeInsets.zero);
  Widget _selection<T>(
          T? selected, ValueChanged<T> select, List<Widget> choices) =>
      RadioGroup<T>(
          groupValue: selected,
          onChanged: _boundValue((value) {
            if (_enabled && value != null) {
              _feedback = null;
              select(value);
            }
          }),
          child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: choices));

  List<Widget> get _stageWidgets => switch (_store.state.stage) {
        DiscoveryStage.inspect => [
            FilledButton(
                onPressed: _bound(_enabled && _store.state.inspectedAll
                    ? () => _act(_store.continueMission,
                        'All three observations are recorded. Let’s test your idea.')
                    : null),
                child: const Text('Continue to comparison')),
          ],
        DiscoveryStage.experiment => [
            DiscoveryExperiment(
                warmTrial: _store.state.warmTrial,
                coolTrial: _store.state.coolTrial,
                enabled: _enabled,
                onRunTrial: _boundValue((warm) => _act(
                    () => _store.runTrial(warm: warm),
                    warm
                        ? 'Warmer trial recorded. Compare it with the cooler trial.'
                        : 'Cooler trial recorded. Compare it with the warmer trial.'))),
            const SizedBox(height: 12),
            FilledButton(
                onPressed: _bound(_enabled && _store.state.experimentsComplete
                    ? () => _act(_store.continueMission,
                        'Both trials are recorded. Use the comparison to support an explanation.')
                    : null),
                child: const Text('Explain what happened')),
          ],
        DiscoveryStage.conclude => [
            _card('Build an explanation', [
              const Text('Choose a hypothesis'),
              _selection<bool>(
                  _hypothesis, (v) => setState(() => _hypothesis = v), [
                _choice('Water evaporated into the air', true),
                _choice('Sunlight destroyed the water', false),
              ]),
              const Divider(),
              const Text('Which evidence supports your explanation?'),
              _selection<DiscoveryEvidence>(
                  _evidence, (v) => setState(() => _evidence = v), [
                _choice('The otherwise equal warm dish lost more water',
                    DiscoveryEvidence.controlledComparison),
                _choice('The dry tabletop alone proves there was no spill',
                    DiscoveryEvidence.dryTableAlone),
                _choice('A warm window alone proves where the water went',
                    DiscoveryEvidence.warmWindowAlone),
              ]),
              FilledButton(
                  onPressed: _bound(_enabled &&
                          _hypothesis != null &&
                          _evidence != null
                      ? () => _act(
                          () => _store.conclude(
                              evaporation: _hypothesis!, evidence: _evidence!),
                          'The controlled comparison supports evaporation. Liquid water becomes invisible water vapor; it is not destroyed.',
                          incorrect:
                              'That explanation does not explain all the evidence. No visible spill alone is not proof. Revisit the controlled comparison.')
                      : null),
                  child: const Text('Check explanation')),
              ..._answerFeedback,
            ])
          ],
        DiscoveryStage.apply => [
            _card(
                _store.applicationAttempts == 0
                    ? 'Apply it independently'
                    : 'Practise the application',
                [
                  const Text(
                      'Why can damp clothes dry even without boiling? Choose the explanation that fits.'),
                  _selection<bool>(
                      _application, (v) => setState(() => _application = v), [
                    _choice(
                        'Water slowly evaporates into surrounding air', true),
                    _choice('Water must boil before any can leave the clothes',
                        false),
                  ]),
                  FilledButton(
                      onPressed: _bound(_enabled && _application != null
                          ? () => _act(
                              () => _store.applyAnswer(correct: _application!),
                              'Water on damp clothes can evaporate without boiling. You applied the idea to another situation.',
                              incorrect:
                                  'That explanation does not fit the situation yet. Read the question again and consider your evidence. You can try again.')
                          : null),
                      child: const Text('Check application')),
                  ..._answerFeedback,
                  const Text(
                      'Your attempts are recorded separately. Case hints do not certify independent course mastery.'),
                ])
          ],
        DiscoveryStage.complete => [
            _card(
                _store.temporary
                    ? 'Case completed in this temporary session'
                    : 'Case recorded in your Discovery Journal',
                [
                  const Text(
                      'We inferred evaporation from observations and a controlled comparison. Water changed from liquid to vapor; it did not vanish.'),
                  Text(
                      'Case assistance: ${_store.assisted ? 'used' : 'not requested'}. Application attempts across replays: ${_store.applicationAttempts}.'),
                  const Text(
                      'No XP or credits awarded. This experimental journal records local activity, not verified course mastery.'),
                ])
          ],
      };

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Discovery Adventure')),
        body: SafeArea(
            child: Align(
                alignment: Alignment.topCenter,
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 850),
                  child: SingleChildScrollView(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Text('The Case of the Vanishing Water',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            const Text(
                                'Experimental • Ungraded • Suggested Grades 4–6 • About 5–8 minutes'),
                            const SizedBox(height: 8),
                            const Text(
                                'Investigate, compare, explain, then apply. Optional companion to evaporation study; it does not replace the Grade 5 Water Cycle lesson. Teacher review and learner testing are pending.'),
                            const SizedBox(height: 12),
                            DiscoveryDialogue(
                                controller: _norie,
                                message: _message ?? _stageMessage,
                                skipped: _skip,
                                onSkip: () => setState(() => _skip = !_skip)),
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Case sounds'),
                                subtitle: Text(_silent
                                    ? 'Muted. Global music follows your audio settings.'
                                    : 'Case interaction sounds enabled.'),
                                value: !_silent,
                                onChanged: (v) => setState(() => _silent = !v)),
                            if (_store.error != null)
                              _card('Save needs attention', [
                                Text(_store.error!),
                                if (!_store.temporary) ...[
                                  OutlinedButton(
                                      onPressed: _bound(_store.busy
                                          ? null
                                          : () => _store.retry()),
                                      child:
                                          const Text('Retry saving / loading')),
                                  OutlinedButton(
                                      onPressed: _bound(_store.busy
                                          ? null
                                          : _store.continueTemporarily),
                                      child: const Text(
                                          'Play temporarily without replacing saved data')),
                                ],
                              ]),
                            if (_store.temporary)
                              const Padding(
                                  padding: EdgeInsets.all(8),
                                  child: Text(
                                      'Temporary session: progress and journal changes are not saved. They will be lost when you close this case. Your previous saved file is unchanged.')),
                            if (!_store.ready && _store.error == null)
                              const LinearProgressIndicator(),
                            if (_store.ready) ...[
                              TextButton.icon(
                                  onPressed: _bound(_enabled
                                      ? () => setState(() => _list = !_list)
                                      : null),
                                  icon: Icon(
                                      _list ? Icons.grid_view : Icons.list_alt),
                                  label: Text(_list
                                      ? 'Use room view'
                                      : 'Use prop list')),
                              if (!_list)
                                DiscoveryRoom(
                                    enabled: _enabled,
                                    active: _active,
                                    onInspect: _boundValue(_inspect))
                              else
                                _card('Explore the laboratory', [
                                  for (final item in const {
                                    DiscoveryProp.container:
                                        'Inspect water container',
                                    DiscoveryProp.table: 'Inspect dry tabletop',
                                    DiscoveryProp.window: 'Inspect warm window',
                                    DiscoveryProp.bench:
                                        'Inspect experiment bench',
                                    DiscoveryProp.notebook:
                                        'Inspect evidence notebook',
                                  }.entries)
                                    Padding(
                                        padding:
                                            const EdgeInsets.only(bottom: 8),
                                        child: OutlinedButton.icon(
                                            onPressed: _bound(_enabled
                                                ? () => _inspect(item.key)
                                                : null),
                                            icon: const Icon(Icons.search),
                                            label: Text(item.value))),
                                ]),
                              const SizedBox(height: 12),
                              _card('Evidence notebook', [
                                Text(
                                    '${_store.state.clues.length} of 3 observations recorded'),
                                for (final clue in _store.state.clues)
                                  Padding(
                                      padding: const EdgeInsets.only(top: 8),
                                      child: Text(_observations[clue]!)),
                                const SizedBox(height: 8),
                                const Text(
                                    'Evidence is what you observe. A hypothesis is an explanation you test. A conceptual comparison supports an explanation; it does not rule out every possible cause in a real room.'),
                              ]),
                              const SizedBox(height: 12),
                              ..._stageWidgets,
                              if (_store.state.stage.index <
                                  DiscoveryStage.apply.index)
                                TextButton.icon(
                                    onPressed:
                                        _bound(_enabled ? _showHint : null),
                                    icon: const Icon(Icons.lightbulb_outline),
                                    label: const Text('Ask Norie for a hint')),
                              if (_store.journalEntry != null &&
                                  !_store.state.complete)
                                _card('Discovery Journal', [
                                  const Text(
                                      'A previous completion of this case is recorded locally. Replaying does not add another entry or award rewards.'),
                                ]),
                              TextButton(
                                  onPressed: _bound(_enabled
                                      ? () async {
                                          final guard =
                                              _store.captureOwnerGuard();
                                          final reset = await showDialog<bool>(
                                              context: context,
                                              builder: (context) => AlertDialog(
                                                      title: const Text(
                                                          'Restart this investigation?'),
                                                      content: const Text(
                                                          'Your current case steps will reset. An existing Discovery Journal entry stays. No rewards are changed.'),
                                                      actions: [
                                                        TextButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    false),
                                                            child: const Text(
                                                                'Keep investigating')),
                                                        FilledButton(
                                                            onPressed: () =>
                                                                Navigator.pop(
                                                                    context,
                                                                    true),
                                                            child: const Text(
                                                                'Restart case'))
                                                      ]));
                                          if (!mounted ||
                                              !guard() ||
                                              reset != true) {
                                            return;
                                          }
                                          await _act(_store.reset,
                                              'A fresh investigation is ready. Your earlier journal entry is kept.');
                                        }
                                      : null),
                                  child: const Text('Restart investigation')),
                            ],
                          ])),
                ))),
      );
}
