/// Verified implementation phase for the current Philippine school year.
///
/// These labels describe DepEd's rollout schedule, not a claim that every
/// Norie lesson has been mapped to an official grade/quarter competency.
abstract final class NorieDepedCurriculumBasis {
  static String rolloutForGrade(String gradeId) => switch (gradeId) {
        'g1' || 'g4' || 'g7' =>
          'MATATAG K-10 rollout cohort: began SY 2024-2025',
        'g2' || 'g3' || 'g5' || 'g8' =>
          'MATATAG K-10 rollout cohort: began SY 2025-2026',
        'g6' || 'g9' || 'g10' =>
          'MATATAG K-10 rollout cohort: begins SY 2026-2027',
        'g11' =>
          'Strengthened Senior High School: Grade 11 nationwide from SY 2026-2027',
        'g12' =>
          'SY 2026-2027: 2016 K to 12 SHS outside pilot schools; strengthened Grade 12 nationwide from SY 2027-2028',
        'college' =>
          'College general education: CHED CMO No. 20, s. 2013 is a reference; course mapping is pending',
        _ => 'DepEd rollout status has not been verified for this level',
      };

  static const mappingNotice =
      'Norie lesson paths are not a complete curriculum. Grade/quarter competency mapping to official guides is still being verified.';
}
