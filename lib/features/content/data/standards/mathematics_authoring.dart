import '../authored/core_math_unit.dart';

/// Compact assembly of original, explicitly authored teaching and answer rows.
/// The bank format is the same as CoreMathUnit; no questions are synthesized.
CoreMathUnit mathUnit({
  required String title,
  required List<String> aims,
  required String idea,
  required Map<String, String> model,
  required String worked,
  required String tryIt,
  required String check,
  required String avoid,
  required String remember,
  required String bank,
}) =>
    CoreMathUnit(
      title: title,
      objectives: aims,
      focus: idea.split('. ').first,
      explanation: idea,
      model: model,
      worked: worked,
      guided: tryIt,
      solution: check,
      mistakes: avoid,
      recap: remember,
      questions: bank
          .trim()
          .split('\n')
          .map((row) => row.trim())
          .where((row) => row.isNotEmpty)
          .toList(growable: false),
    );
