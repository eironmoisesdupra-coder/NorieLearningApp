import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'primary_mathematics.dart';
import 'secondary_mathematics.dart';
import 'advanced_mathematics.dart';
import 'primary_english.dart';
import 'secondary_english.dart';
import 'advanced_english.dart';
import 'grade1_math_visuals.dart';
import 'core_english_curriculum.dart';
import 'core_mathematics_curriculum.dart';

abstract final class AuthoredSubjectCurriculum {
  static final Map<String, NorieTopicContent> mathematics = {
    ...primaryMathematics,
    ...secondaryMathematics,
    ...advancedMathematics,
  };
  static final Map<String, NorieTopicContent> english = {
    ...primaryEnglish,
    ...secondaryEnglish,
    ...advancedEnglish,
  };
  static final Map<String, AuthoredLessonVisual> visuals = {
    ...CoreMathematicsCurriculum.visuals,
    ...CoreEnglishCurriculum.figures,
    ...grade1MathVisuals,
    ...primaryMathVisuals,
    ...secondaryMathVisuals,
    ...advancedMathVisuals,
    ...primaryEnglishVisuals,
    ...secondaryEnglishVisuals,
    ...advancedEnglishVisuals,
  };
  static NorieTopicContent? lesson(String subject, String grade) =>
      switch (subject.toLowerCase()) {
        'mathematics' => mathematics[grade],
        'english' => english[grade],
        _ => null,
      };
}
