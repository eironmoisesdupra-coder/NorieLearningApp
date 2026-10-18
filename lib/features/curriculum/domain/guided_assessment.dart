enum PracticeEvidenceKind { assisted, independent, retention }

enum GuidedAssessmentFormat { choice, multiSelect, text, numeric, ordering }

class GuidedPracticeAttempt {
  const GuidedPracticeAttempt(
      this.questionId, this.correct, this.kind, this.at);
  final String questionId;
  final bool correct;
  final PracticeEvidenceKind kind;
  final DateTime at;
}

/// Rehearsal evidence only. No reward, mastery or retention authority lives here.
class GuidedPracticeSession {
  final Set<String> _helped = {};
  final List<GuidedPracticeAttempt> _attempts = [];
  List<GuidedPracticeAttempt> get attempts => List.unmodifiable(_attempts);
  int get independentCorrect => _attempts
      .where((a) => a.correct && a.kind == PracticeEvidenceKind.independent)
      .length;
  void revealHelp(String questionId) => _helped.add(questionId);
  bool usedHelp(String questionId) => _helped.contains(questionId);
  void record(String questionId, {required bool correct}) =>
      _attempts.add(GuidedPracticeAttempt(
          questionId,
          correct,
          _helped.contains(questionId)
              ? PracticeEvidenceKind.assisted
              : PracticeEvidenceKind.independent,
          DateTime.now().toUtc()));
}

class GuidedAssessmentItem {
  const GuidedAssessmentItem.numeric(
      {required this.id,
      required this.prompt,
      required double answer,
      required String this.unit,
      this.tolerance = 0})
      : format = GuidedAssessmentFormat.numeric,
        numericAnswer = answer,
        options = const [],
        answers = const {},
        accepted = const [],
        ordered = const [];
  GuidedAssessmentItem.selection(
      {required this.id,
      required this.prompt,
      required List<String> options,
      required Set<int> answers})
      : format = answers.length == 1
            ? GuidedAssessmentFormat.choice
            : GuidedAssessmentFormat.multiSelect,
        options = List.unmodifiable(options),
        answers = Set.unmodifiable(answers),
        accepted = const [],
        ordered = const [],
        numericAnswer = null,
        unit = null,
        tolerance = 0;
  GuidedAssessmentItem.text(
      {required this.id, required this.prompt, required List<String> accepted})
      : format = GuidedAssessmentFormat.text,
        accepted = List.unmodifiable(accepted),
        options = const [],
        answers = const {},
        ordered = const [],
        numericAnswer = null,
        unit = null,
        tolerance = 0;
  GuidedAssessmentItem.ordering(
      {required this.id, required this.prompt, required List<String> items})
      : format = GuidedAssessmentFormat.ordering,
        ordered = List.unmodifiable(items),
        options = const [],
        answers = const {},
        accepted = const [],
        numericAnswer = null,
        unit = null,
        tolerance = 0;
  factory GuidedAssessmentItem.fromJson(Map<String, dynamic> json) {
    try {
      if (json['id'] is! String ||
          (json['id'] as String).trim().isEmpty ||
          json['prompt'] is! String ||
          (json['prompt'] as String).trim().isEmpty) {
        throw const FormatException('Assessment ID and prompt are required.');
      }
      final id = json['id'] as String, prompt = json['prompt'] as String;
      final format = json['format'];
      final GuidedAssessmentItem item;
      switch (format) {
        case 'numeric':
          if (json['answer'] is! num ||
              json['unit'] is! String ||
              (json['tolerance'] != null && json['tolerance'] is! num)) {
            throw const FormatException(
                'Numeric assessment needs a number and explicit unit.');
          }
          item = GuidedAssessmentItem.numeric(
              id: id,
              prompt: prompt,
              answer: (json['answer'] as num).toDouble(),
              unit: json['unit'] as String,
              tolerance: (json['tolerance'] as num?)?.toDouble() ?? 0);
        case 'choice':
        case 'multiSelect':
          final rawAnswers = json['answers'] as List;
          if (rawAnswers.any((a) => a is! int) ||
              rawAnswers.toSet().length != rawAnswers.length) {
            throw const FormatException(
                'Selection keys must be distinct integer indices.');
          }
          item = GuidedAssessmentItem.selection(
              id: id,
              prompt: prompt,
              options: List<String>.from(json['options'] as List),
              answers: rawAnswers.cast<int>().toSet());
          if ((format == 'choice' && item.answers.length != 1) ||
              (format == 'multiSelect' && item.answers.length < 2)) {
            throw const FormatException(
                'Answer count does not match selection format.');
          }
        case 'text':
          item = GuidedAssessmentItem.text(
              id: id,
              prompt: prompt,
              accepted: List<String>.from(json['accepted'] as List));
        case 'ordering':
          item = GuidedAssessmentItem.ordering(
              id: id,
              prompt: prompt,
              items: List<String>.from(json['items'] as List));
        default:
          throw const FormatException(
              'Unsupported authored assessment format.');
      }
      if (!item.isValid) {
        throw const FormatException('Invalid authored assessment answer key.');
      }
      return item;
    } on FormatException {
      rethrow;
    } catch (_) {
      throw const FormatException('Malformed authored assessment.');
    }
  }
  final String id;
  final String prompt;
  final GuidedAssessmentFormat format;
  final List<String> options;
  final Set<int> answers;
  final List<String> accepted;
  final List<String> ordered;
  final double? numericAnswer;
  final String? unit;
  final double tolerance;
  bool get isValid => switch (format) {
        GuidedAssessmentFormat.numeric => numericAnswer != null &&
            numericAnswer!.isFinite &&
            unit != null &&
            unit!.trim().isNotEmpty &&
            tolerance.isFinite &&
            tolerance >= 0,
        GuidedAssessmentFormat.choice ||
        GuidedAssessmentFormat.multiSelect =>
          options.length >= 2 &&
              options.toSet().length == options.length &&
              options.every((v) => v.trim().isNotEmpty) &&
              answers.isNotEmpty &&
              answers.every((i) => i >= 0 && i < options.length),
        GuidedAssessmentFormat.text =>
          accepted.isNotEmpty && accepted.every((v) => v.trim().isNotEmpty),
        GuidedAssessmentFormat.ordering => ordered.length >= 2 &&
            ordered.toSet().length == ordered.length &&
            ordered.every((v) => v.trim().isNotEmpty),
      };
  bool checkSelection(Set<int> selected) =>
      isValid &&
      (format == GuidedAssessmentFormat.choice ||
          format == GuidedAssessmentFormat.multiSelect) &&
      selected.length == answers.length &&
      answers.containsAll(selected);
  bool checkNumeric(String text, String submittedUnit) {
    final value = double.tryParse(text.trim());
    return isValid &&
        format == GuidedAssessmentFormat.numeric &&
        value != null &&
        value.isFinite &&
        submittedUnit.trim() == unit &&
        (value - numericAnswer!).abs() <= tolerance;
  }

  bool checkText(String value) =>
      isValid &&
      format == GuidedAssessmentFormat.text &&
      accepted.any((answer) =>
          answer.trim().toLowerCase() == value.trim().toLowerCase());
  bool checkOrder(List<String> values) =>
      isValid &&
      format == GuidedAssessmentFormat.ordering &&
      values.length == ordered.length &&
      List.generate(values.length, (i) => values[i] == ordered[i])
          .every((same) => same);
}
