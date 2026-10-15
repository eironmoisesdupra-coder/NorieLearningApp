import '../data/norie_foundation_curriculum.dart';
import 'norie_boss_mission.dart';
import 'norie_content_models.dart';

/// A source-linked study card. Ownership lives solely in permanent boss receipts.
class NorieEducationalCollectible {
  NorieEducationalCollectible._(this.mission);

  final NorieBossMission mission;
  String get id => mission.id;
  String get subject => mission.subject;
  String get gradeId => mission.gradeId;
  List<NorieTopicContent> get sources => mission.topics;
  String get gradeLabel => NorieFoundationCurriculum.gradeLevels
      .firstWhere((grade) => grade.id == gradeId)
      .label;
  String get title =>
      '$subject · $gradeLabel · Chapter ${mission.chapterNumber}';
  String get conceptTitle => conceptHeading(sources.first);
  static String conceptHeading(NorieTopicContent topic) =>
      topic.lesson.keyConceptTitle.trim().isNotEmpty
          ? topic.lesson.keyConceptTitle
          : topic.title;

  static String conceptBody(NorieTopicContent topic) {
    if (topic.lesson.keyConceptBody.trim().isNotEmpty) {
      return topic.lesson.keyConceptBody;
    }
    final recap = topic.lesson.sections.where((section) =>
        RegExp(r'recap|remember|summary', caseSensitive: false)
            .hasMatch(section.title));
    final sections = recap.isNotEmpty ? recap : topic.lesson.sections;
    return [
      topic.lesson.introduction,
      for (final section in sections) ...[
        if (section.body != null) section.body!,
        ...section.points,
      ],
    ].where((text) => text.trim().isNotEmpty).join('\n\n');
  }

  String get studyText => sources
      .map((topic) => '${conceptHeading(topic)}\n${conceptBody(topic)}')
      .join('\n\n');
  String get requirement =>
      'Complete all ${sources.length} chapter lessons, then score at least 80% on the chapter Boss Mission to earn this permanent knowledge card.';
  bool isEarned(Set<String> trophyIds) => trophyIds.contains(id);

  static final List<NorieEducationalCollectible> catalogue = List.unmodifiable([
    for (final subject in NorieFoundationCurriculum.supportedSubjects)
      for (final grade
          in NorieFoundationCurriculum.availableGradeLevels(subject))
        for (final mission in NorieBossMission.forPath(subject, grade.id))
          NorieEducationalCollectible._(mission),
  ]);
}
