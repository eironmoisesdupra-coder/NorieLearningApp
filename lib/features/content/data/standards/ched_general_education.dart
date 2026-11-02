import '../../domain/norie_content_models.dart';
import '../authored/authored_lesson_visual.dart';
import 'ched_english.dart';
import 'ched_mathematics.dart';
import 'ched_science.dart';
import 'standards_lesson.dart';

abstract final class ChedGeneralEducation {
  static const sources = [
    'DepEd Order No. 017, s. 2026, Table 1: core subjects aligned to the GE subjects in CHED CMO No. 020, s. 2013.\n'
        'https://www.deped.gov.ph/wp-content/uploads/DO_s2026_017r.pdf',
    'Course-title alignment is verified through the DepEd table. Direct CHED outcome text and state-university syllabi remain to be verified; these are original GE lessons, not an accredited complete university course.',
  ];

  static const courses = {
    'Mathematics': 'Mathematics in the Modern World',
    'Science': 'Science, Technology and Society',
    'English': 'Purposive Communication',
  };

  static const _lessons = {
    'Mathematics': chedMathematicsLessons,
    'Science': chedScienceLessons,
    'English': chedEnglishLessons,
  };

  static final Map<String, List<NorieTopicContent>> topics = {
    for (final entry in _lessons.entries)
      entry.key: buildStandardsCourse(
        subject: entry.key,
        grade: 'college',
        course: courses[entry.key]!,
        lessons: entry.value,
      ),
  };

  static final Map<String, AuthoredLessonVisual> visuals = {
    for (final entry in _lessons.entries)
      for (var i = 0; i < entry.value.length; i++)
        entry.value[i].visualId(entry.key, 'college', i + 1):
            entry.value[i].visual,
  };
}
