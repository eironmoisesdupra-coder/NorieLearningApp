/// An offline labeled model: ordered stages or paired examples. Every label has
/// a meaning; diagrams use actual equations and passage evidence.
class AuthoredLessonVisual {
  const AuthoredLessonVisual(
      {required this.title,
      required this.labels,
      required this.details,
      required this.note,
      this.ordered = false});
  final String title;
  final List<String> labels;
  final List<String> details;
  final String note;
  final bool ordered;
  void validate() {
    if (labels.isEmpty ||
        labels.length != details.length ||
        labels.any((label) => label.trim().isEmpty) ||
        details.any((detail) => detail.trim().isEmpty)) {
      throw ArgumentError('Each diagram label needs an explanation.');
    }
  }
}
