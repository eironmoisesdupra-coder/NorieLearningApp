import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_deped_curriculum_basis.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  test('all published school levels have an explicit rollout label', () {
    for (final grade in NorieFoundationCurriculum.gradeLevels) {
      expect(
        NorieDepedCurriculumBasis.rolloutForGrade(grade.id),
        isNotEmpty,
        reason: grade.id,
      );
    }
  });

  test('Grade 2 is included in the verified 2025-2026 cohort', () {
    expect(
      NorieDepedCurriculumBasis.rolloutForGrade('g2'),
      contains('SY 2025-2026'),
    );
  });

  test('labels distinguish MATATAG, strengthened SHS, and college references',
      () {
    expect(
      NorieDepedCurriculumBasis.rolloutForGrade('g6'),
      contains('SY 2026-2027'),
    );
    expect(
      NorieDepedCurriculumBasis.rolloutForGrade('g11'),
      contains('Strengthened Senior High School'),
    );
    expect(
      NorieDepedCurriculumBasis.rolloutForGrade('college'),
      contains('CHED CMO No. 20'),
    );
    expect(
      NorieDepedCurriculumBasis.rolloutForGrade('g12'),
      contains('outside pilot schools'),
    );
    expect(NorieDepedCurriculumBasis.mappingNotice, contains('not a complete'));
  });
}
