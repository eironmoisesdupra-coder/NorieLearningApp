import '../../domain/norie_content_models.dart';
import '../authored/advanced_english.dart';
import '../authored/advanced_mathematics.dart';
import '../authored/authored_lesson_visual.dart';
import '../authored/core_english_curriculum.dart';
import '../authored/core_mathematics_curriculum.dart';
import '../science/science_curriculum.dart';
import '../science/science_expansion.dart';
import 'ched_english.dart';
import 'ched_mathematics.dart';
import 'ched_science.dart';
import 'standards_lesson.dart';

/// Core bridges and separately identified STEM/academic extensions.
/// Course-level references do not establish exhaustive competency coverage.
abstract final class DepedSeniorHigh {
  static const _coreNames = {
    'Mathematics': 'General Mathematics',
    'Science': 'General Science',
    'English': 'Effective Communication',
  };
  static const _bridges = {
    'Mathematics': chedMathematicsLessons,
    'Science': chedScienceLessons,
    'English': chedEnglishLessons,
  };

  static final Map<String, Map<String, List<NorieTopicContent>>> topics = {
    for (final subject in _coreNames.keys)
      subject: {
        for (final grade in ['g11', 'g12'])
          grade: _buildPath(subject, grade),
      },
  };

  static final Map<String, AuthoredLessonVisual> visuals = {
    for (final entry in _bridges.entries)
      for (final grade in ['g11', 'g12'])
        for (var i = 0; i < entry.value.length; i++)
          entry.value[i].visualId(entry.key, grade, i + 1):
              entry.value[i].visual,
  };

  static List<String> sourcesFor(String grade) => [
        'DepEd Order No. 017, s. 2026, paragraph 7: Grade 11 nationwide SSHS in SY 2026-2027; Grade 12 outside pilot schools retains the 2016 curriculum until SY 2027-2028.\n'
            'https://www.deped.gov.ph/wp-content/uploads/DO_s2026_017r.pdf',
        'DO 017 Table 1 identifies Grade 11 core subjects and GE alignment; Annex A, printed pages 25-26, identifies STEM elective courses. The core bridges and subject extensions below are separate, not a claim that calculus is a compulsory General Mathematics topic.',
        if (grade == 'g11')
          'General Mathematics, General Science, and Effective Communication broad descriptions were reviewed in the April 2025 consultation packet. This is a DRAFT description, not a final quarterly competency guide.\n'
              'https://www.deped.gov.ph/2025/04/09/deped-urges-stakeholders-to-join-public-consultation-for-strengthened-shs-curriculum/',
        if (grade == 'g12')
          'The default transition label is for non-pilot Grade 12 learners. The review and extension lessons are not a verified timetable or an exhaustive map of the 2016 SHS core and STEM curriculum.',
        'Final quarter-by-quarter SSHS core guides and detailed legacy Grade 12 mappings remain unverified. Course-level alignment does not certify complete standards coverage.',
      ];

  static List<NorieTopicContent> _buildPath(String subject, String grade) {
    final bridge = buildStandardsCourse(
      subject: subject,
      grade: grade,
      course: grade == 'g11'
          ? '${_coreNames[subject]} | core bridge'
          : 'SHS cross-subject application and review',
      lessons: _bridges[subject]!,
    );
    final extensions = switch (subject) {
      'Mathematics' => [
          ...CoreMathematicsCurriculum.grades[grade]!,
          advancedMathematics[grade]!,
        ],
      'Science' => [
          ...ScienceCurriculum.grades[grade]!,
          ScienceExpansion.lessons[grade]!,
        ],
      'English' => [
          ...CoreEnglishCurriculum.grades[grade]!,
          advancedEnglish[grade]!,
        ],
      _ => throw ArgumentError.value(subject, 'subject'),
    };
    final all = [...bridge, ...extensions];
    return List.unmodifiable([
      for (var i = 0; i < all.length; i++)
        _sequence(
          all[i],
          i + 1,
          i == 0 ? null : all[i - 1].id,
          i < bridge.length
              ? all[i].subtitle
              : subject == 'English'
                  ? 'Academic communication extension'
                  : 'STEM subject extension',
        ),
    ]);
  }

  static NorieTopicContent _sequence(
    NorieTopicContent original,
    int order,
    String? prerequisite,
    String course,
  ) =>
      NorieTopicContent(
        id: original.id,
        subject: original.subject,
        category: original.category,
        title: original.title,
        subtitle: course == original.subtitle
            ? course
            : '$course | ${original.subtitle}',
        order: order,
        accent: original.accent,
        lesson: original.lesson,
        quiz: original.quiz,
        challenge: original.challenge,
        available: original.available,
        prerequisiteTopicId: prerequisite,
        gradeLevel: original.gradeLevel,
        visualType: original.visualType,
      );
}
