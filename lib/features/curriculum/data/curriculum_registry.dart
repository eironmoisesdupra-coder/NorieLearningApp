import '../../content/data/norie_content_catalog.dart';
import '../../content/data/norie_foundation_curriculum.dart';
import '../../content/domain/norie_content_models.dart';
import '../domain/curriculum_revision.dart';

/// Read-only snapshot of existing locally authored routes. Drafts cannot be
/// inserted here. This does not replace the runtime repository or progress IDs.
class CurriculumRegistry {
  CurriculumRegistry._(Iterable<NorieTopicContent> topics)
      : revisions = List.unmodifiable(
            topics.map((t) => CurriculumRevision.existing(t.toJson())));
  static CurriculumRegistry? _bundled;
  factory CurriculumRegistry.bundled() =>
      _bundled ??= CurriculumRegistry._(_existingTopics());
  final List<CurriculumRevision> revisions;
  static Iterable<NorieTopicContent> _existingTopics() sync* {
    final seen = <String>{};
    for (final subject in NorieFoundationCurriculum.supportedSubjects) {
      for (final grade
          in NorieFoundationCurriculum.availableGradeLevels(subject)) {
        for (final topic
            in NorieFoundationCurriculum.topicsFor(subject, grade.id)) {
          if (topic.available &&
              NorieFoundationCurriculum.isAuthored(topic) &&
              seen.add(topic.id)) {
            yield topic;
          }
        }
      }
    }
    for (final subject in NorieContentCatalog.subjects) {
      for (final category in subject.categories) {
        for (final topic in category.topics) {
          if (topic.available && seen.add(topic.id)) yield topic;
        }
      }
    }
  }

  late final Map<String, CurriculumRevision> _byId = {
    for (final revision in revisions) revision.id: revision
  };
  CurriculumRevision? resolve(CurriculumReference reference) {
    final revision = _byId[reference.id];
    return revision != null &&
            revision.revision == reference.revision &&
            revision.fingerprint == reference.fingerprint
        ? revision
        : null;
  }

  List<CurriculumRevision> search(String text,
      {String? subject, String? grade}) {
    final query = text.trim().toLowerCase();
    return revisions.where((revision) {
      final topic = revision.topic;
      return (subject == null || topic.subject == subject) &&
          (grade == null || topic.gradeLevel == grade) &&
          [topic.id, topic.title, topic.subject, topic.gradeLevel ?? '']
              .join(' ')
              .toLowerCase()
              .contains(query);
    }).toList(growable: false);
  }
}
