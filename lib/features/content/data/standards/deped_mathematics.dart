import '../../domain/norie_content_models.dart';
import '../authored/authored_lesson_visual.dart';
import '../authored/core_math_unit.dart';
import 'mathematics_grade1.dart';
import 'mathematics_grade2.dart';
import 'mathematics_grade3.dart';
import 'mathematics_grade4.dart';
import 'mathematics_grade5.dart';
import 'mathematics_grade6.dart';
import 'mathematics_grade7.dart';
import 'mathematics_grade8.dart';
import 'mathematics_grade9.dart';
import 'mathematics_grade10.dart';

/// Original offline teaching paths, not a competency-by-competency certification.
///
/// G1/G4/G7 follow the verified MATATAG guide. Other grades use the explicitly
/// identified official August 2016 guide, NOT a claim of current MATATAG mapping.
/// Selected semantically matching existing CoreMathUnits retain their titles/IDs;
/// newly authored concepts receive their own IDs through the existing builder.
final Map<String, List<CoreMathUnit>> _units = {
  'g1': depedMath1,
  'g2': depedMath2,
  'g3': depedMath3,
  'g4': depedMath4,
  'g5': depedMath5,
  'g6': depedMath6,
  'g7': depedMath7,
  'g8': depedMath8,
  'g9': depedMath9,
  'g10': depedMath10,
};

final Map<String, List<NorieTopicContent>> depedMathematics = Map.unmodifiable({
  for (final entry in _units.entries)
    entry.key: buildCoreMathGrade(entry.key, entry.value),
});

final Map<String, AuthoredLessonVisual> depedMathematicsVisuals =
    Map.unmodifiable({
  for (final entry in _units.entries)
    ...coreMathVisuals(entry.key, entry.value),
});

const _matatag =
    'https://www.deped.gov.ph/wp-content/uploads/MATATAG-Mathematics-CG-Grades1-4-and-7.pdf';
const _legacy =
    'https://www.deped.gov.ph/wp-content/uploads/2019/01/Math-CG_with-tagged-math-equipment.pdf';
const _legacyLimit =
    'Official August 2016 K to 12 reference only. Current MATATAG competencies for this grade have not been verified here; rollout status does not establish a competency mapping.';

/// Page numbers are the printed PDF pages (also the PDF's 1-based page index).
/// Each entry remains readable without fetching a source during a lesson.
const Map<String, List<String>> depedMathematicsSources = {
  'g1': [
    '$_matatag — Grade 1, Q1, p.21: 2D shapes, whole numbers to 100, ordinals to tenth, addition to 20.',
    '$_matatag — Grade 1, Q2, p.22: non-standard length, tens and ones, skip counting, addition to 100 without regrouping.',
    '$_matatag — Grade 1, Q3, p.23: unscaled pictographs, subtraction, equivalent number sentences, repeating patterns.',
    '$_matatag — Grade 1, Q4, p.24: halves and quarters, peso money to 100, turns, clocks and calendars.',
  ],
  'g2': [
    '$_legacy — Grade 2, Q1, pp.31–42: whole numbers to 1000, ordinals to twentieth, peso money, addition.',
    '$_legacy — Grade 2, Q2, pp.42–50: subtraction and multiplication with whole numbers and money.',
    '$_legacy — Grade 2, Q3, pp.50–58: division, unit fractions, lines, surfaces, shapes and patterns.',
    '$_legacy — Grade 2, Q4, pp.58–66: time, length, mass, capacity, tile area, tables, pictographs and simple likelihood.',
    _legacyLimit,
  ],
  'g3': [
    '$_legacy — Grade 3, Q1, pp.67–75: whole numbers to 10000, ordinals to hundredth, money, addition and subtraction.',
    '$_legacy — Grade 3, Q2, pp.76–83: multiplication and division, including whole-number money problems.',
    '$_legacy — Grade 3, Q3, pp.84–90: fractions, lines, symmetry, patterns and number sentences.',
    '$_legacy — Grade 3, Q4, pp.90–96: measurement conversions, area, graphs and likelihood experiments.',
    _legacyLimit,
  ],
  'g4': [
    '$_matatag — Grade 4, Q1, p.25: angles, triangles and quadrilaterals, perimeter, numbers and addition/subtraction to one million.',
    '$_matatag — Grade 4, Q2, pp.26–27: multiplication/division and MDAS, measure/time conversions, similar fractions and mixed numbers.',
    '$_matatag — Grade 4, Q3, p.28: dissimilar/equivalent fractions, factors/multiples, fraction operations, symmetry and reflection.',
    '$_matatag — Grade 4, Q4, p.29: tables and single line graphs, patterns/equalities, decimal representation and rounding.',
  ],
  'g5': [
    '$_legacy — Grade 5, Q1, pp.133–145: numbers to ten million, divisibility, factors/multiples, order of operations and fractions.',
    '$_legacy — Grade 5, Q2, pp.146–160: decimal place value through ten-thousandths, decimal operations, ratio and proportion.',
    '$_legacy — Grade 5, Q3, pp.160–167: percent, polygons, circles and solid figures.',
    '$_legacy — Grade 5, Q4, pp.168–174: circle area, cube/prism volume, Celsius temperature, line graphs and experimental probability.',
    _legacyLimit,
  ],
  'g6': [
    '$_legacy — Grade 6, Q1, pp.175–190: four operations on fractions and decimals with multistep problems.',
    '$_legacy — Grade 6, Q2, pp.190–196: ratio/proportion, percent, exponents, order of operations and integers.',
    '$_legacy — Grade 6, Q3, pp.196–200: solid figures, nets, patterns/algebra and surface area.',
    '$_legacy — Grade 6, Q4, pp.200–205: solid volumes, water/electric meter readings, pie graphs and probability.',
    _legacyLimit,
  ],
  'g7': [
    '$_matatag — Grade 7, Q1, p.30: polygons and angles, percentage applications, financial planning, rates and rational numbers.',
    '$_matatag — Grade 7, Q2, p.31: roots/irrationals, unit conversion, cylinders and pyramids, sets and real-number subsets.',
    '$_matatag — Grade 7, Q3, p.32: sampling, frequency tables, graph interpretation, integers and GEMDAS.',
    '$_matatag — Grade 7, Q4, p.33: equations/bar models, expressions, formula rearrangement, experimental outcomes and scientific notation.',
  ],
  'g8': [
    '$_legacy — Grade 8, Q1, pp.219–225: polynomial factoring, rational algebraic expressions, linear equations and systems.',
    '$_legacy — Grade 8, Q2, pp.225–228: two-variable inequalities and systems, linear functions, mathematical reasoning.',
    '$_legacy — Grade 8, Q3, pp.228–229: axiomatic geometry and triangle congruence.',
    '$_legacy — Grade 8, Q4, pp.229–230: triangle inequalities, parallel/perpendicular lines and simple probability.',
    _legacyLimit,
  ],
  'g9': [
    '$_legacy — Grade 9, Q1, pp.231–237: quadratic equations/inequalities/functions and rational algebraic equations.',
    '$_legacy — Grade 9, Q2, pp.237–241: direct/inverse/joint/combined variation, rational exponents and radicals.',
    '$_legacy — Grade 9, Q3, pp.241–244: parallelograms, triangle midsegments, trapezoids/kites, similarity and right triangles.',
    '$_legacy — Grade 9, Q4, pp.245–246: trigonometric ratios, special angles, elevation/depression, sine and cosine laws.',
    _legacyLimit,
  ],
  'g10': [
    '$_legacy — Grade 10, Q1, pp.246–250: arithmetic/geometric sequences and series, polynomial division, remainder/factor/rational-root theorems.',
    '$_legacy — Grade 10, Q2, pp.250–251: polynomial functions, circles/chords/arcs/tangents/secants and coordinate geometry.',
    '$_legacy — Grade 10, Q3, pp.251–252: permutations, combinations and probability.',
    '$_legacy — Grade 10, Q4, pp.252–253: quartiles, deciles, percentiles and a statistical investigation.',
    _legacyLimit,
  ],
};

/// Editorial limitations are deliberately separate from source authority.
const Map<String, List<String>> depedMathematicsCoverageNotes = {
  'all': [
    'Main quarterly domains are represented, but these paths are not full code-by-code competency coverage or a complete school-year course.',
    'Models are offline labelled mathematical displays, not interactive manipulatives or physical drawing/measurement assessments.',
    'Each unit contains eight practice and three independent mastery questions; selected existing, semantically matching CoreMathUnits are reused.',
  ],
  'g1': [
    'Oral/picture-only assessment, physical shape composition, and calendar use need additional teacher-led practice.'
  ],
  'g2': [
    'Ordinal-to-twentieth and centavo-money coverage is not exhaustive. Current MATATAG grade mapping remains unverified.'
  ],
  'g3': [
    'Long multiplication/division algorithms and scaled chart construction need further units. Current MATATAG grade mapping remains unverified.'
  ],
  'g4': [
    'Glide reflection, protractor drawing and long division at the largest prescribed ranges need more practice.'
  ],
  'g5': [
    'Decimal place value through ten-thousandths and extended long-division practice are not fully assessed. Current MATATAG grade mapping remains unverified.'
  ],
  'g6': [
    'Inverse/partitive proportion, commercial percent applications and all solid surface-area variants need further units. Current MATATAG grade mapping remains unverified.'
  ],
  'g7': [
    'Financial planning, commissions, sales tax and simple-interest applications are not exhaustively assessed. An inherited equation unit includes inequality extension work.'
  ],
  'g8': [
    'Formal two-column proofs and all nonlinear rational-expression cases are not exhaustive. Current MATATAG grade mapping remains unverified.'
  ],
  'g9': [
    'All radical-equation cases and ambiguous SSA solution counts need additional practice. Current MATATAG grade mapping remains unverified.'
  ],
  'g10': [
    'Compound-event probability, repeated/circular permutations and independent learner research are not exhaustively assessed. Current MATATAG grade mapping remains unverified.'
  ],
};
