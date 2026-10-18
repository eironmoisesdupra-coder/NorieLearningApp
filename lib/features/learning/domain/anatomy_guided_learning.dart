import 'anatomy_atlas_catalog.dart';

enum AnatomyStudyStep {
  discover,
  locate,
  understand,
  explore,
  practice,
  apply,
  review;

  String get label => name[0].toUpperCase() + name.substring(1);
}

enum AnatomyEditorialStatus { catalogMetadataOnly, pendingHumanReview }

/// A navigation/identification guide, not a medically reviewed anatomy lesson.
/// Model identity and classification come exclusively from the shipped catalog.
class AnatomyGuidedModule {
  const AnatomyGuidedModule(this.structure);

  static const contentVersion = 1;
  final AtlasStructure structure;
  String get source => structure.source;
  AnatomyEditorialStatus get editorialStatus =>
      AnatomyEditorialStatus.catalogMetadataOnly;

  // No new medical assertions have been approved for this feature. Future
  // authored content must pass editorial review before this returns content.
  String? get approvedExplanation => null;

  static List<AnatomyGuidedModule> representativePaths(
      AnatomyAtlasCatalog catalog) {
    final result = <AnatomyGuidedModule>[];
    for (final sample in const [
      ('Right femur', 'skeletal'),
      ('Trachea', 'respiratory'),
      ('Cavity of left ventricle', 'cardiovascular'),
    ]) {
      final matches = catalog.structures.where((part) =>
          part.reference == 'male' &&
          part.name == sample.$1 &&
          part.systems.contains(sample.$2));
      if (matches.isNotEmpty) result.add(AnatomyGuidedModule(matches.first));
    }
    return List.unmodifiable(result);
  }
}

/// Local activity evidence. Completion is a learner acknowledgement of the
/// seven steps; it never implies clinical/academic mastery or grants XP.
class AnatomyStudyProgress {
  AnatomyStudyProgress({
    required this.structureId,
    this.step = AnatomyStudyStep.discover,
    Set<AnatomyStudyStep> completedSteps = const {},
    Set<AnatomyStudyStep> skippedSteps = const {},
    this.identified = false,
    this.studied = false,
    this.answersRevealed = false,
    this.assistedAttempts = 0,
    this.independentAttempts = 0,
    this.independentCorrect = 0,
  })  : completedSteps = Set.unmodifiable(completedSteps),
        skippedSteps = Set.unmodifiable(skippedSteps);

  final String structureId;
  final AnatomyStudyStep step;
  final Set<AnatomyStudyStep> completedSteps, skippedSteps;
  final bool identified, studied;

  /// Hint/answer feedback exposes both name and system for this catalog entry.
  /// Later attempts are repeat practice, including after a reload.
  final bool answersRevealed;
  final int assistedAttempts, independentAttempts, independentCorrect;
  bool get completed =>
      skippedSteps.isEmpty &&
      completedSteps.length == AnatomyStudyStep.values.length;

  AnatomyStudyProgress copyWith({
    AnatomyStudyStep? step,
    Set<AnatomyStudyStep>? completedSteps,
    Set<AnatomyStudyStep>? skippedSteps,
    bool? identified,
    bool? studied,
    bool? answersRevealed,
    int? assistedAttempts,
    int? independentAttempts,
    int? independentCorrect,
  }) =>
      AnatomyStudyProgress(
        structureId: structureId,
        step: step ?? this.step,
        completedSteps: completedSteps ?? this.completedSteps,
        skippedSteps: skippedSteps ?? this.skippedSteps,
        identified: identified ?? this.identified,
        studied: studied ?? this.studied,
        answersRevealed: answersRevealed ?? this.answersRevealed,
        assistedAttempts: assistedAttempts ?? this.assistedAttempts,
        independentAttempts: independentAttempts ?? this.independentAttempts,
        independentCorrect: independentCorrect ?? this.independentCorrect,
      );

  Map<String, dynamic> toJson() => {
        'id': structureId,
        'step': step.index,
        'done': completedSteps.map((s) => s.index).toList(),
        'skipped': skippedSteps.map((s) => s.index).toList(),
        'identified': identified,
        'studied': studied,
        'answersRevealed': answersRevealed,
        'assisted': assistedAttempts,
        'attempts': independentAttempts,
        'correct': independentCorrect,
      };

  static AnatomyStudyProgress? restore(dynamic raw, Set<String> validIds) {
    if (raw is! Map<String, dynamic> || !validIds.contains(raw['id'])) {
      return null;
    }
    final step = raw['step'];
    if (step is! int || step < 0 || step >= AnatomyStudyStep.values.length) {
      return null;
    }
    Set<AnatomyStudyStep>? steps(dynamic value) {
      if (value is! List || value.length > AnatomyStudyStep.values.length) {
        return null;
      }
      if (value.any((i) => i is! int || i < 0 || i >= 7)) return null;
      return value.map((i) => AnatomyStudyStep.values[i as int]).toSet();
    }

    final done = steps(raw['done']);
    final skipped = steps(raw['skipped']);
    final counts = [raw['assisted'], raw['attempts'], raw['correct']];
    if (done == null ||
        skipped == null ||
        done.intersection(skipped).isNotEmpty ||
        raw['identified'] is! bool ||
        raw['studied'] is! bool ||
        (raw.containsKey('answersRevealed') &&
            raw['answersRevealed'] is! bool) ||
        counts.any((n) => n is! int || n < 0 || n > 1000000)) {
      return null;
    }
    if ((raw['correct'] as int) > (raw['attempts'] as int)) return null;
    return AnatomyStudyProgress(
      structureId: raw['id'] as String,
      step: AnatomyStudyStep.values[step],
      completedSteps: done,
      skippedSteps: skipped,
      identified: raw['identified'] as bool,
      studied: raw['studied'] as bool,
      // Existing v1 saves predate explicit provenance. Submitted checks already
      // exposed the answer, so conservatively restore them as revealed.
      answersRevealed: raw['answersRevealed'] == true ||
          (raw['assisted'] as int) > 0 ||
          (raw['attempts'] as int) > 0,
      assistedAttempts: raw['assisted'] as int,
      independentAttempts: raw['attempts'] as int,
      independentCorrect: raw['correct'] as int,
    );
  }
}
