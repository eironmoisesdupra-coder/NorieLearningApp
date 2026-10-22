/// Standalone, deterministic mission model. No XP, credits, or account writes.
/// Integrate through the existing learner-owner storage boundary only after QA.
enum DiscoveryStage { inspect, experiment, conclude, apply, complete }

enum DiscoveryClue { dryTable, openContainer, warmWindow }

enum DiscoveryEvidence { controlledComparison, dryTableAlone, warmWindowAlone }

class DiscoveryMissionState {
  DiscoveryMissionState({
    this.stage = DiscoveryStage.inspect,
    Set<DiscoveryClue> clues = const {},
    this.warmTrial = false,
    this.coolTrial = false,
    this.conclusionCorrect = false,
    this.appliedCorrect = false,
    this.evidence,
  }) : clues = Set.unmodifiable(clues) {
    final minimumClues = stage.index >= DiscoveryStage.experiment.index;
    final minimumTrials = stage.index >= DiscoveryStage.conclude.index;
    final minimumConclusion = stage.index >= DiscoveryStage.apply.index;
    if ((minimumClues && !inspectedAll) ||
        (minimumTrials && !experimentsComplete) ||
        (minimumConclusion && !conclusionCorrect) ||
        (stage == DiscoveryStage.complete && !appliedCorrect) ||
        (stage == DiscoveryStage.inspect && (warmTrial || coolTrial)) ||
        (stage.index < DiscoveryStage.apply.index && conclusionCorrect) ||
        (stage != DiscoveryStage.complete && appliedCorrect) ||
        (conclusionCorrect !=
            (evidence == DiscoveryEvidence.controlledComparison)) ||
        (!conclusionCorrect && evidence != null)) {
      throw const FormatException('Impossible mission progress');
    }
  }

  final DiscoveryStage stage;
  final Set<DiscoveryClue> clues;
  final bool warmTrial, coolTrial, conclusionCorrect, appliedCorrect;
  final DiscoveryEvidence? evidence;
  bool get inspectedAll => clues.length == DiscoveryClue.values.length;
  bool get experimentsComplete => warmTrial && coolTrial;
  bool get complete => stage == DiscoveryStage.complete;

  DiscoveryMissionState copyWith(
          {DiscoveryStage? stage,
          Set<DiscoveryClue>? clues,
          bool? warmTrial,
          bool? coolTrial,
          bool? conclusionCorrect,
          bool? appliedCorrect,
          DiscoveryEvidence? evidence}) =>
      DiscoveryMissionState(
        stage: stage ?? this.stage,
        clues: Set.unmodifiable(clues ?? this.clues),
        warmTrial: warmTrial ?? this.warmTrial,
        coolTrial: coolTrial ?? this.coolTrial,
        conclusionCorrect: conclusionCorrect ?? this.conclusionCorrect,
        appliedCorrect: appliedCorrect ?? this.appliedCorrect,
        evidence: evidence ?? this.evidence,
      );

  DiscoveryMissionState inspect(DiscoveryClue clue) {
    if (stage != DiscoveryStage.inspect) return this;
    return copyWith(clues: {...clues, clue});
  }

  DiscoveryMissionState continueFromClues() =>
      stage == DiscoveryStage.inspect && inspectedAll
          ? copyWith(stage: DiscoveryStage.experiment)
          : this;
  DiscoveryMissionState runTrial({required bool warm}) {
    if (stage != DiscoveryStage.experiment) return this;
    return warm ? copyWith(warmTrial: true) : copyWith(coolTrial: true);
  }

  DiscoveryMissionState continueFromExperiment() =>
      stage == DiscoveryStage.experiment && experimentsComplete
          ? copyWith(stage: DiscoveryStage.conclude)
          : this;
  DiscoveryMissionState submitConclusion(
          {required bool evaporation, DiscoveryEvidence? evidence}) =>
      stage == DiscoveryStage.conclude &&
              evaporation &&
              evidence == DiscoveryEvidence.controlledComparison
          ? copyWith(
              conclusionCorrect: true,
              stage: DiscoveryStage.apply,
              evidence: evidence)
          : this;
  DiscoveryMissionState submitApplication({required bool correct}) =>
      stage == DiscoveryStage.apply && correct && conclusionCorrect
          ? copyWith(appliedCorrect: true, stage: DiscoveryStage.complete)
          : this;

  Map<String, dynamic> toJson() => {
        'schema': 1,
        'stage': stage.name,
        'clues': clues.map((e) => e.name).toList()..sort(),
        'warmTrial': warmTrial,
        'coolTrial': coolTrial,
        'conclusionCorrect': conclusionCorrect,
        'appliedCorrect': appliedCorrect,
        'evidence': evidence?.name,
      };

  static DiscoveryMissionState fromJson(Object? raw) {
    const keys = {
      'schema',
      'stage',
      'clues',
      'warmTrial',
      'coolTrial',
      'conclusionCorrect',
      'appliedCorrect',
      'evidence'
    };
    if (raw is! Map ||
        raw.length != keys.length ||
        raw.keys.any((key) => !keys.contains(key)) ||
        raw['schema'] is! int ||
        raw['schema'] != 1 ||
        raw['clues'] is! List ||
        raw['stage'] is! String ||
        raw['warmTrial'] is! bool ||
        raw['coolTrial'] is! bool ||
        raw['conclusionCorrect'] is! bool ||
        raw['appliedCorrect'] is! bool) {
      throw const FormatException('Invalid mission save');
    }
    final evidenceName = raw['evidence'];
    final evidence = DiscoveryEvidence.values
        .where((e) => e.name == evidenceName)
        .firstOrNull;
    if (evidenceName != null && evidence == null) {
      throw const FormatException('Unknown mission evidence');
    }
    final names = (raw['clues'] as List);
    if (names.any((e) => e is! String) ||
        names.toSet().length != names.length ||
        names.any((e) => !DiscoveryClue.values.any((v) => v.name == e))) {
      throw const FormatException('Invalid clue inventory');
    }
    final stage =
        DiscoveryStage.values.where((e) => e.name == raw['stage']).firstOrNull;
    if (stage == null) throw const FormatException('Invalid mission stage');
    final clues = names
        .map((e) => DiscoveryClue.values.firstWhere((v) => v.name == e))
        .toSet();
    final s = DiscoveryMissionState(
        stage: stage,
        clues: clues,
        warmTrial: raw['warmTrial'] as bool,
        coolTrial: raw['coolTrial'] as bool,
        conclusionCorrect: raw['conclusionCorrect'] as bool,
        appliedCorrect: raw['appliedCorrect'] as bool,
        evidence: evidence);
    if (stage.index >= DiscoveryStage.experiment.index && !s.inspectedAll ||
        stage.index >= DiscoveryStage.conclude.index &&
            !s.experimentsComplete ||
        stage.index >= DiscoveryStage.apply.index && !s.conclusionCorrect ||
        stage == DiscoveryStage.complete && !s.appliedCorrect) {
      throw const FormatException('Impossible mission progress');
    }
    return s;
  }
}
