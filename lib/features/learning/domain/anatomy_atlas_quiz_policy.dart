import 'dart:math';
import 'anatomy_atlas_catalog.dart';
import 'anatomy_models.dart';

class AtlasQuizQuestion {
  const AtlasQuizQuestion(this.target, this.options);
  final AtlasStructure target;
  final List<String> options;

  String get hint {
    final name =
        target.name.toLowerCase().replaceFirst(RegExp(r'^(left|right)\s+'), '');
    for (final system in AnatomyCatalog.systems) {
      for (final structure in system.structures) {
        if (structure.name.toLowerCase() == name) {
          return '${structure.description} ${structure.function}';
        }
      }
    }
    return AnatomyCatalog.systems
        .where((system) => target.systems.contains(system.id.name))
        .map((system) => '${system.label}: ${system.subtitle}.')
        .join(' ');
  }
}

class AtlasQuizSession {
  static const questionCount = 20;
  AtlasQuizSession._(this.questions);
  final List<AtlasQuizQuestion> questions;
  int index = 0;
  int score = 0;
  bool finished = false;
  bool _rewarded = false;
  final _answered = <int>{};
  AtlasQuizQuestion get current => questions[index];
  bool get checked => _answered.contains(index);

  static List<AtlasStructure> eligibleStructures(
          AnatomyAtlasCatalog catalog, String reference, Set<String> systems) =>
      catalog.structures
          .where((structure) =>
              (reference == 'all' || structure.reference == reference) &&
              structure.systems.intersection(systems).isNotEmpty)
          .toList();

  factory AtlasQuizSession.generate(
      AnatomyAtlasCatalog catalog, String reference, Set<String> systems,
      {Random? random}) {
    final rng = random ?? Random();
    final eligible = eligibleStructures(catalog, reference, systems)
      ..shuffle(rng);
    final names = eligible.map((s) => s.name).toSet();
    if (eligible.isEmpty || names.length < 2) {
      throw StateError('Not enough modeled structures for a quiz.');
    }
    final questions = <AtlasQuizQuestion>[];
    final usedNames = <String>{};
    for (final target in eligible) {
      if (!usedNames.add(target.name)) continue;
      final alternatives = names.where((name) => name != target.name).toList()
        ..shuffle(rng);
      final options = [target.name, ...alternatives.take(3)]..shuffle(rng);
      questions.add(AtlasQuizQuestion(target, List.unmodifiable(options)));
      if (questions.length == questionCount) break;
    }
    return AtlasQuizSession._(List.unmodifiable(questions));
  }

  bool? answer(String option) {
    if (finished || checked || !current.options.contains(option)) return null;
    _answered.add(index);
    final correct = option == current.target.name;
    if (correct) score++;
    return correct;
  }

  bool next() {
    if (finished || !checked) return false;
    if (index + 1 < questions.length) {
      index++;
    } else {
      finished = true;
    }
    return true;
  }

  int? takeReward() {
    if (!finished || _rewarded) return null;
    _rewarded = true;
    return score * 10;
  }
}
