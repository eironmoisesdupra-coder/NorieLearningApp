import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'grade_2_science.dart';

/// Authored grade packs only. Grade 1 retains its approved standalone content.
abstract final class ScienceCurriculum {
  static final Map<String, List<NorieTopicContent>> grades = {
    'g2': grade2ScienceTopics,
  };
  static final Map<String, ScienceFigure> figures = {
    ...grade2ScienceFigures,
  };
}
