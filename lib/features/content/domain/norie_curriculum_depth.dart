/// Curriculum-depth rules for NorieLearning subject/grade journeys.
///
/// Production paths may vary by subject and grade. The policy deliberately
/// prevents the UI from assuming a fixed mission count while also rejecting
/// tiny placeholder paths and accidentally oversized maps.
abstract final class NorieCurriculumDepth {
  static const int minimumLessons = 6;
  static const int maximumLessons = 20;

  static bool isSupported(int count) =>
      count >= minimumLessons && count <= maximumLessons;

  static void validate({
    required String subject,
    required String gradeId,
    required int count,
  }) {
    if (isSupported(count)) return;
    throw StateError(
      '$subject/$gradeId exposes $count lessons; production journeys must '
      'contain $minimumLessons-$maximumLessons authored lessons.',
    );
  }

  /// Suggested long-term curriculum depth. This is a planning target, not a
  /// promise that unpublished content already exists.
  static int targetFor(String subject, String gradeId) {
    final normalized = subject.toLowerCase();
    if (gradeId == 'college') {
      return switch (normalized) {
        'science' => 18,
        'mathematics' => 16,
        'english' => 12,
        _ => 10,
      };
    }
    final gradeNumber = int.tryParse(gradeId.replaceFirst('g', '')) ?? 1;
    final target = switch (normalized) {
      'science' => 7 + (gradeNumber ~/ 2),
      'mathematics' => 7 + (gradeNumber ~/ 2),
      'english' => 7 + ((gradeNumber - 1) ~/ 3),
      'filipino' => 8 + ((gradeNumber - 1) ~/ 3),
      'araling panlipunan' => 7 + ((gradeNumber - 1) ~/ 3),
      _ => minimumLessons,
    };
    return target.clamp(minimumLessons, maximumLessons);
  }
}
