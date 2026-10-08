import '../../domain/norie_content_models.dart';
import 'authored_lesson_visual.dart';
import 'core_math_unit.dart';
import 'grade2_mathematics_core.dart';
import 'grade3_mathematics_core.dart';
import 'grade4_mathematics_core.dart';
import 'grade5_mathematics_core.dart';
import 'grade6_mathematics_core.dart';
import 'grade7_mathematics_core.dart';
import 'grade8_mathematics_core.dart';
import 'grade9_mathematics_core.dart';
import 'grade10_mathematics_core.dart';
import 'grade11_mathematics_core.dart';
import 'grade12_mathematics_core.dart';
import 'college_mathematics_core.dart';

/// Authored replacements for the historical G2–College five-lesson cohorts.
/// Titles, IDs, order, prerequisites and the fifty-XP completion policy stay
/// stable; every pack carries its own real mathematical teaching and checks.
abstract final class CoreMathematicsCurriculum {
  static final Map<String, List<NorieTopicContent>> grades = {
    'g2': buildCoreMathGrade('g2', grade2MathUnits),
    'g3': buildCoreMathGrade('g3', grade3MathUnits),
    'g4': buildCoreMathGrade('g4', grade4MathUnits),
    'g5': buildCoreMathGrade('g5', grade5MathUnits),
    'g6': buildCoreMathGrade('g6', grade6MathUnits),
    'g7': buildCoreMathGrade('g7', grade7MathUnits),
    'g8': buildCoreMathGrade('g8', grade8MathUnits),
    'g9': buildCoreMathGrade('g9', grade9MathUnits),
    'g10': buildCoreMathGrade('g10', grade10MathUnits),
    'g11': buildCoreMathGrade('g11', grade11MathUnits),
    'g12': buildCoreMathGrade('g12', grade12MathUnits),
    'college': buildCoreMathGrade('college', collegeMathUnits),
  };
  static final Map<String, AuthoredLessonVisual> visuals = {
    ...coreMathVisuals('g2', grade2MathUnits),
    ...coreMathVisuals('g3', grade3MathUnits),
    ...coreMathVisuals('g4', grade4MathUnits),
    ...coreMathVisuals('g5', grade5MathUnits),
    ...coreMathVisuals('g6', grade6MathUnits),
    ...coreMathVisuals('g7', grade7MathUnits),
    ...coreMathVisuals('g8', grade8MathUnits),
    ...coreMathVisuals('g9', grade9MathUnits),
    ...coreMathVisuals('g10', grade10MathUnits),
    ...coreMathVisuals('g11', grade11MathUnits),
    ...coreMathVisuals('g12', grade12MathUnits),
    ...coreMathVisuals('college', collegeMathUnits),
  };
}
