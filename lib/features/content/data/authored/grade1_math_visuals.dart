import 'authored_lesson_visual.dart';

const grade1MathVisuals = <String, AuthoredLessonVisual>{
  'g1-counting-counters': AuthoredLessonVisual(
      title: 'Count eight counters once',
      labels: ['● ● ● ●', '● ● ● ●', '1, 2, 3, 4, 5, 6, 7, 8'],
      details: [
        'The first row has four counters.',
        'The second row has four more.',
        'The last number gives the total of eight counters.'
      ],
      note:
          'Each dot represents one object; moving or recounting does not change the total.'),
  'g1-counting-number-line': AuthoredLessonVisual(
      title: 'Neighbors on a number line',
      labels: ['40 → 41 → 42 → 43 → 44', 'Before 42: 41', 'After 42: 43'],
      details: [
        'Every arrow moves one number forward.',
        'One backward step gives one less.',
        'One forward step gives one more.'
      ],
      note:
          'Equal one-number intervals model number order, not the physical size of objects.'),
  'g1-place-value-blocks': AuthoredLessonVisual(
      title: 'Three tens and four ones',
      labels: ['10 + 10 + 10 = 30', '1 + 1 + 1 + 1 = 4', '30 + 4 = 34'],
      details: [
        'Each group of ten is one ten.',
        'Four ungrouped objects are four ones.',
        'Combine the tens value and ones value.'
      ],
      note: 'Three tens do not mean three single objects.',
      ordered: true),
  'g1-addition-groups': AuthoredLessonVisual(
      title: 'Join three and two',
      labels: [
        'First group: ● ● ●',
        'Second group: ● ●',
        'Together: ● ● ● ● ●'
      ],
      details: [
        'Count three objects.',
        'Count two more objects.',
        'All five objects form the joined group: 3 + 2 = 5.'
      ],
      note: 'Each dot represents one; addition joins the two group counts.',
      ordered: true),
  'g1-addition-number-line': AuthoredLessonVisual(
      title: 'Count on three from six',
      labels: ['6 → 7 → 8 → 9', 'Three steps: 7, 8, 9'],
      details: [
        'Start at six before making any jump.',
        'The third landing is nine, so 6 + 3 = 9.'
      ],
      note: 'Do not count the starting six as the first added step.'),
  'g1-subtraction-take-away': AuthoredLessonVisual(
      title: 'Take two away from seven',
      labels: ['Start: ● ● ● ● ● ● ●', 'Remove: × ×', 'Remain: ● ● ● ● ●'],
      details: [
        'The original group has seven objects.',
        'Cross out two of the original seven.',
        'Five are left, so 7 − 2 = 5.'
      ],
      note:
          'The two removed counters belong to the starting seven; they are not an additional group.',
      ordered: true),
  'g1-subtraction-number-line': AuthoredLessonVisual(
      title: 'Count back three from nine',
      labels: ['9 → 8 → 7 → 6', 'Three backward steps: 8, 7, 6'],
      details: [
        'Each listed arrow decreases the number by one.',
        'After three backward steps the number is six.'
      ],
      note:
          'This sequence lists backward counting in reading order; on a conventional increasing number line the movement goes left.'),
  'g1-shapes-basic': AuthoredLessonVisual(
      title: 'Name shapes by properties',
      labels: ['△ Triangle', '□ Square', '▭ Rectangle', '○ Circle'],
      details: [
        'Three straight sides and three corners.',
        'Four equal straight sides and four square corners.',
        'Four straight sides and four square corners; a square is a special rectangle.',
        'Round boundary with no straight sides or corners.'
      ],
      note:
          'The symbol sketches illustrate the named properties. Color and turning do not determine the name.'),
  'g1-shapes-pattern': AuthoredLessonVisual(
      title: 'A repeating circle-square unit',
      labels: ['○ □   ○ □   ○ □', 'Repeating unit: ○ □', 'Next: ○ then □'],
      details: [
        'The same pair repeats three times.',
        'The shortest repeating group contains two shapes.',
        'Continue the pair in the same order.'
      ],
      note:
          'A repeating pattern uses the whole unit, not a guess from one last shape.'),
};
