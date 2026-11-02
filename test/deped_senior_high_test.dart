import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/data/standards/deped_senior_high.dart';

void main() {
  test('SHS publication separates core applications from subject extensions', () {
    for (final entry in DepedSeniorHigh.topics.entries) {
      for (final grade in entry.value.entries) {
        expect(grade.value, hasLength(12),
            reason: '${entry.key}/${grade.key}');
        expect(
          NorieFoundationCurriculum.topicsFor(entry.key, grade.key),
          orderedEquals(grade.value),
        );
        for (var i = 0; i < grade.value.length; i++) {
          final topic = grade.value[i];
          expect(topic.gradeLevel, grade.key);
          expect(topic.order, i + 1);
          expect(topic.prerequisiteTopicId,
              i == 0 ? null : grade.value[i - 1].id);
          if (i >= 6) expect(topic.subtitle, contains('extension'));
        }
      }
    }
  });

  test('sources distinguish final policy, draft descriptions and mapping gaps',
      () {
    final g11 = DepedSeniorHigh.sourcesFor('g11').join('\n');
    final g12 = DepedSeniorHigh.sourcesFor('g12').join('\n');
    expect(g11, contains('DRAFT'));
    expect(g11, contains('not a final quarterly competency guide'));
    expect(g12, contains('non-pilot'));
    expect(g12, contains('remain unverified'));
  });
}
