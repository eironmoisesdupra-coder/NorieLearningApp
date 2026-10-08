import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'core_english_lesson_builder.dart';
import 'core_english_primary.dart';
import 'core_english_secondary.dart';
import 'core_english_advanced.dart';

abstract final class CoreEnglishCurriculum {
  static const lessons = [
    ...coreEnglishPrimary,
    ...coreEnglishSecondary,
    ...coreEnglishAdvanced
  ];
  static final Map<String, List<NorieTopicContent>> grades =
      buildCoreEnglish(lessons);
  static final Map<String, AuthoredLessonVisual> figures = {
    for (final lesson in lessons) lesson.figureKey: lesson.figure,
  };
}
