import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import 'learning_results_screen.dart';

class AtomChallengeScreen extends StatefulWidget {
  const AtomChallengeScreen({
    required this.quizScore,
    super.key,
  });

  final int quizScore;

  @override
  State<AtomChallengeScreen> createState() => _AtomChallengeScreenState();
}

class _AtomChallengeScreenState extends State<AtomChallengeScreen> {
  static const _rounds = <_ChallengeRound>[
    _ChallengeRound(
      clue: 'I am positive and found in the nucleus.',
      correct: 'Proton',
    ),
    _ChallengeRound(
      clue: 'I have no charge and can change the isotope.',
      correct: 'Neutron',
    ),
    _ChallengeRound(
      clue: 'I am negative and occupy regions around the nucleus.',
      correct: 'Electron',
    ),
  ];

  int _round = 0;
  int _challengeScore = 0;
  String? _selected;
  bool _locked = false;

  void _choose(String choice) {
    if (_locked) return;

    setState(() {
      _selected = choice;
      _locked = true;
      if (choice == _rounds[_round].correct) {
        _challengeScore++;
      }
    });
  }

  void _next() {
    if (!_locked) return;

    if (_round == _rounds.length - 1) {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => LearningResultsScreen(
            quizScore: widget.quizScore,
            challengeScore: _challengeScore,
          ),
        ),
      );
      return;
    }

    setState(() {
      _round++;
      _selected = null;
      _locked = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final current = _rounds[_round];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Atom Builder Challenge'),
        automaticallyImplyLeading: false,
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 700),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
              children: [
                Container(
                  height: 220,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(28),
                    gradient: const RadialGradient(
                      colors: [
                        Color(0xFF244C9C),
                        Color(0xFF1B2862),
                        Color(0xFF0E1732),
                      ],
                    ),
                    border: Border.all(
                      color: NorieColors.cyan.withValues(alpha: .5),
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      Container(
                        width: 120,
                        height: 120,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(
                            color: NorieColors.cyan,
                            width: 2,
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: .8,
                        child: Container(
                          width: 175,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: NorieColors.violet,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      Transform.rotate(
                        angle: -.8,
                        child: Container(
                          width: 175,
                          height: 75,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(99),
                            border: Border.all(
                              color: NorieColors.magenta,
                              width: 2,
                            ),
                          ),
                        ),
                      ),
                      const Icon(
                        Icons.circle,
                        size: 45,
                        color: NorieColors.cyan,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Text(
                  'ROUND ${_round + 1} OF ${_rounds.length}',
                  style: const TextStyle(
                    fontSize: 11,
                    letterSpacing: 1.4,
                    color: NorieColors.violet,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 9),
                Text(
                  current.clue,
                  style: const TextStyle(
                    fontSize: 25,
                    fontWeight: FontWeight.w900,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 22),
                for (final choice in const ['Proton', 'Neutron', 'Electron'])
                  Padding(
                    padding: const EdgeInsets.only(bottom: 11),
                    child: _ChallengeChoice(
                      label: choice,
                      selected: _selected == choice,
                      locked: _locked,
                      correct: current.correct == choice,
                      onTap: () => _choose(choice),
                    ),
                  ),
                if (_locked) ...[
                  const SizedBox(height: 8),
                  Text(
                    _selected == current.correct
                        ? 'Correct! +25 challenge XP'
                        : 'The correct answer is ${current.correct}.',
                    style: TextStyle(
                      color: _selected == current.correct
                          ? NorieColors.green
                          : NorieColors.magenta,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ],
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _locked ? _next : null,
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.cyan,
                    foregroundColor: NorieColors.background,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: Text(
                    _round == _rounds.length - 1
                        ? 'View results'
                        : 'Next round',
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _ChallengeChoice extends StatelessWidget {
  const _ChallengeChoice({
    required this.label,
    required this.selected,
    required this.locked,
    required this.correct,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool locked;
  final bool correct;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    Color border = selected ? NorieColors.cyan : NorieColors.border;
    Color fill = NorieColors.surface;

    if (locked && correct) {
      border = NorieColors.green;
      fill = NorieColors.green.withValues(alpha: .10);
    } else if (locked && selected && !correct) {
      border = NorieColors.magenta;
      fill = NorieColors.magenta.withValues(alpha: .10);
    }

    return Material(
      color: fill,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        onTap: locked ? null : onTap,
        borderRadius: BorderRadius.circular(18),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 18, vertical: 17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(18),
            border: Border.all(color: border),
          ),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                  ),
                ),
              ),
              if (locked && correct)
                const Icon(
                  Icons.check_circle_rounded,
                  color: NorieColors.green,
                )
              else if (selected)
                Icon(
                  locked ? Icons.cancel_rounded : Icons.radio_button_checked,
                  color: locked ? NorieColors.magenta : NorieColors.cyan,
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _ChallengeRound {
  const _ChallengeRound({
    required this.clue,
    required this.correct,
  });

  final String clue;
  final String correct;
}
