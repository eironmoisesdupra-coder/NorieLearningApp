import 'dart:math';
import 'anatomy_atlas_catalog.dart';
import 'anatomy_models.dart';
import 'anatomy_hint_library.dart';

enum AtlasQuizDifficulty { guided, standard, challenge }

enum AtlasQuestionKind { identify, system }

class AtlasQuizQuestion {
  const AtlasQuizQuestion(this.target, this.options,
      {this.kind = AtlasQuestionKind.identify});
  final AtlasStructure target;
  final List<String> options;
  final AtlasQuestionKind kind;

  String get answer => kind == AtlasQuestionKind.identify
      ? target.name
      : _singleSystem(target)!.label;

  String get prompt => kind == AtlasQuestionKind.identify
      ? 'Which anatomical structure is shown?'
      : 'Which system is ${target.name} listed under in this atlas?';

  String get explanation => kind == AtlasQuestionKind.identify
      ? 'This is ${target.name}. $hint'
      : 'The atlas catalog lists ${target.name} under $answer. '
          'This is its catalog grouping; structures can work with other systems.';

  // A multi-system structure has no single, unambiguous system answer.
  static AnatomySystem? _singleSystem(AtlasStructure structure) {
    if (structure.systems.length != 1) return null;
    return AnatomyCatalog.systems
        .where((system) => structure.systems.contains(system.id.name))
        .firstOrNull;
  }

  /// Paid clues are intentionally unavailable. Coarse lesson names and client
  /// JSON are not authority for exact, version-specific anatomical claims.
  /// Activation requires an independently approved keyed fact bank AND a durable
  /// idempotent credit transaction; neither is configured in this release.
  String? get specificHint => null;

  String get hint {
    if (kind == AtlasQuestionKind.system) {
      return 'Recall the system categories used when browsing the atlas. '
          'Choose the catalog group for the named structure.';
    }
    return AnatomyHintLibrary.generalGuidance;
  }
}

class AtlasQuizSession {
  static const questionCount = 20;
  AtlasQuizSession._(
      this.questions, this.requestedCount, this.difficulty, this._stillCurrent);
  final List<AtlasQuizQuestion> questions;
  final int requestedCount;
  final AtlasQuizDifficulty difficulty;
  final bool Function()? _stillCurrent;
  bool get isShortSession => questions.length < requestedCount;
  int index = 0;
  int score = 0;
  bool finished = false;
  bool _rewarded = false;
  final _answered = <int>{};
  AtlasQuizQuestion get current => questions[index];
  bool get checked => _answered.contains(index);

  static List<AtlasStructure> eligibleStructures(
          AnatomyAtlasCatalog catalog, String reference, Set<String> systems,
          {Set<AtlasQuestionKind> kinds = const {
            AtlasQuestionKind.identify
          }}) =>
      catalog.structures
          .where((structure) =>
              (reference == 'all' || structure.reference == reference) &&
              structure.systems.intersection(systems).isNotEmpty &&
              (kinds.contains(AtlasQuestionKind.identify) ||
                  (kinds.contains(AtlasQuestionKind.system) &&
                      AtlasQuizQuestion._singleSystem(structure) != null)))
          .toList();

  factory AtlasQuizSession.generate(
      AnatomyAtlasCatalog catalog, String reference, Set<String> systems,
      {Random? random,
      int requestedCount = questionCount,
      AtlasQuizDifficulty difficulty = AtlasQuizDifficulty.standard,
      Set<AtlasQuestionKind> kinds = const {AtlasQuestionKind.identify},
      bool Function()? stillCurrent}) {
    if (![5, 10, 20].contains(requestedCount)) {
      throw ArgumentError.value(
          requestedCount, 'requestedCount', 'Use 5, 10 or 20');
    }
    if (kinds.isEmpty) {
      throw ArgumentError('Choose at least one question kind.');
    }
    final rng = random ?? Random();
    final eligible =
        eligibleStructures(catalog, reference, systems, kinds: kinds)
          ..shuffle(rng);
    final names = eligible.map((s) => s.name).toSet();
    if (eligible.isEmpty ||
        (kinds.contains(AtlasQuestionKind.identify) && names.length < 2)) {
      throw StateError('Not enough modeled structures for a quiz.');
    }
    final questions = <AtlasQuizQuestion>[];
    final usedNames = <String>{};
    final optionCount = switch (difficulty) {
      AtlasQuizDifficulty.guided => 2,
      AtlasQuizDifficulty.standard => 4,
      AtlasQuizDifficulty.challenge => 6,
    };
    var systemQuestions = 0;
    for (final target in eligible) {
      if (!usedNames.add(target.name)) continue;
      final system = AtlasQuizQuestion._singleSystem(target);
      final kind = kinds.contains(AtlasQuestionKind.system) &&
              system != null &&
              (!kinds.contains(AtlasQuestionKind.identify) ||
                  systemQuestions <= questions.length ~/ 2)
          ? AtlasQuestionKind.system
          : AtlasQuestionKind.identify;
      if (kind == AtlasQuestionKind.system) systemQuestions++;
      final answer =
          kind == AtlasQuestionKind.system ? system!.label : target.name;
      final pool = kind == AtlasQuestionKind.system
          ? AnatomyCatalog.systems.map((system) => system.label).toSet()
          : names;
      final alternatives = pool.where((name) => name != answer).toList()
        ..shuffle(rng);
      final options = [answer, ...alternatives.take(optionCount - 1)]
        ..shuffle(rng);
      questions.add(
          AtlasQuizQuestion(target, List.unmodifiable(options), kind: kind));
      if (questions.length == requestedCount) break;
    }
    return AtlasQuizSession._(
        List.unmodifiable(questions), requestedCount, difficulty, stillCurrent);
  }

  bool? answer(String option) {
    if (_stillCurrent?.call() == false ||
        finished ||
        checked ||
        !current.options.contains(option)) {
      return null;
    }
    _answered.add(index);
    final correct = option == current.answer;
    if (correct) score++;
    return correct;
  }

  bool next() {
    if (_stillCurrent?.call() == false || finished || !checked) return false;
    if (index + 1 < questions.length) {
      index++;
    } else {
      finished = true;
    }
    return true;
  }

  int? takeReward() {
    if (_stillCurrent?.call() == false || !finished || _rewarded) return null;
    _rewarded = true;
    return score * 10;
  }
}
