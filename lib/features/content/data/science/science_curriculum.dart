import '../../domain/norie_content_models.dart';
import 'science_figure.dart';
import 'grade_2_science.dart';
import 'grade_3_science.dart';
import 'grade_4_science.dart';
import 'grade_5_science.dart';
import 'grade_6_science.dart';
import 'grade_7_science.dart';
import 'grade_8_science.dart';
import 'grade_9_science.dart';
import 'grade_10_science.dart';
import 'grade_11_science.dart';
import 'grade_12_science.dart';
import 'college_science.dart';

/// Authored grade packs only. Grade 1 retains its approved standalone content.
abstract final class ScienceCurriculum {
  static final Map<String, List<NorieTopicContent>> grades = {
    'g2': grade2ScienceTopics,
    'g3': grade3ScienceTopics,
    'g4': grade4ScienceTopics,
    'g5': grade5ScienceTopics,
    'g6': grade6ScienceTopics,
    'g7': grade7ScienceTopics,
    'g8': grade8ScienceTopics,
    'g9': grade9ScienceTopics,
    'g10': grade10ScienceTopics,
    'g11': grade11ScienceTopics,
    'g12': grade12ScienceTopics,
    'college': collegeScienceTopics,
  };
  static final Map<String, ScienceFigure> figures = {
    ...grade2ScienceFigures,
    ...grade3ScienceFigures,
    ...grade4ScienceFigures,
    ...grade5ScienceFigures,
    ...grade6ScienceFigures,
    ...grade7ScienceFigures,
    ...grade8ScienceFigures,
    ...grade9ScienceFigures,
    ...grade10ScienceFigures,
    ...grade11ScienceFigures,
    ...grade12ScienceFigures,
    ...collegeScienceFigures,
  };
}
