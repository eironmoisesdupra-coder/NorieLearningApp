import '../../domain/norie_content_models.dart';
import 'primary_science_expansion.dart';
import 'secondary_science_expansion.dart';
import 'advanced_science_expansion.dart';
import 'science_figure.dart';

/// New units are separate from the original five-lesson cohort so historical
/// content and completion receipts retain a stable migration boundary.
abstract final class ScienceExpansion {
  static final Map<String, NorieTopicContent> lessons = {
    ...primaryScienceExpansion,
    ...secondaryScienceExpansion,
    ...advancedScienceExpansion,
  };
  static const Map<String, ScienceFigure> figures = {
    ...primaryExpansionFigures,
    ...secondaryExpansionFigures,
    ...advancedExpansionFigures,
  };
}
