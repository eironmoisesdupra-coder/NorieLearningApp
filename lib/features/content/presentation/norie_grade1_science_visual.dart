import 'package:flutter/material.dart';
import 'dart:math' as math;
import '../../../core/theme/norie_theme.dart';
import 'norie_grade1_materials_visual.dart';

/// Original local diagrams. Labels are Flutter text, so they remain readable
/// and accessible when the phone is narrow or the learner enlarges text.
class NorieGrade1ScienceVisual extends StatelessWidget {
  const NorieGrade1ScienceVisual(
      {required this.type, this.caption = '', super.key});
  final String type;
  final String caption;
  static const resourceTargets = <String, List<String>>{
    'Light': ['plant'],
    'Water': ['plant', 'animal'],
    'Air': ['plant', 'animal'],
    'Food': ['animal'],
    'Suitable place': ['plant', 'animal'],
  };

  /// Select from the named subject, never from explanatory caption words.
  static String iconKind(String type, String label) {
    final clean = label.toLowerCase().replaceAll(RegExp(r'[^a-z ]'), '').trim();
    if (clean.startsWith('flowering plant')) return 'flower';
    if (type == 'science-3-3' ||
        type == 'science-3-4' ||
        type == 'science-3-2') {
      for (final sense in ['sight', 'hearing', 'smell', 'taste', 'touch']) {
        if (clean.startsWith(sense)) return sense;
      }
    }
    if (type == 'science-2-4') {
      for (final animal in ['fish', 'bird', 'frog', 'dog']) {
        if (clean.startsWith(animal)) return animal;
      }
    }
    if (type == 'science-2-7') {
      if (clean.contains('new seeds')) return 'new seeds';
      if (clean.contains('seed')) return 'seed';
      if (clean.contains('sprout')) return 'sprout';
      if (clean.contains('egg')) return 'egg';
      if (clean.contains('adult')) return 'adult chicken';
      if (clean.contains('chick')) return 'chick';
      return 'plant';
    }
    for (final named in [
      'child',
      'cat',
      'sunflower',
      'bicycle',
      'teddy bear',
      'dog',
      'bird',
      'flower',
      'rock',
      'chair',
      'toy car',
      'pencil',
      'fish',
      'butterfly',
      'frog',
      'tree',
      'cactus',
      'grassland',
      'grass',
      'fern',
      'forest',
      'pond',
      'garden',
      'eyes',
      'ears',
      'nose',
      'tongue',
      'mouth',
      'skin',
      'legs',
      'hands',
      'sight',
      'hearing',
      'smell',
      'taste',
      'touch',
      'plants',
      'animals',
      'living',
      'nonliving'
    ]) {
      if (clean == named || clean.startsWith('$named ')) return named;
    }
    if (clean.contains('thunder') || clean.contains('storm')) return 'storm';
    if (clean.contains('rain') || clean.contains('water falling')) {
      return 'rain';
    }
    if (clean.contains('wind') || clean.contains('flags')) return 'wind';
    if (clean.contains('cloudy')) return 'cloudy';
    if (clean.contains('sun')) return 'sun';
    if (clean.contains('cool')) return 'cool';
    return 'living';
  }

  static const panelTypes = {
    'science-1-1',
    'science-1-sort',
    'science-2-1',
    'science-2-3',
    'science-2-4',
    'science-2-5',
    'science-2-6',
    'science-2-7',
    'science-2-sort',
    'science-3-3',
    'science-3-4',
    'science-3-jobs',
    'science-3-safety',
    'science-4-4',
    'science-4-clothing',
    'science-4-safety',
    'science-4-sort'
  };

  static const labels = <String, List<String>>{
    ...NorieGrade1MaterialsVisual.labels,
    'science-1-1': [
      '🧒 Child · living',
      '🐕 Dog · living',
      '🐦 Bird · living',
      '🌻 Flower · living',
      '🪨 Rock · nonliving',
      '🪑 Chair · nonliving',
      '🚗 Toy car · nonliving',
      '✏️ Pencil · nonliving',
      'Living: needs resources, grows, responds, has a life cycle',
      'Nonliving: does not carry out life processes'
    ],
    'science-1-2': [
      '☀️ Light → plant',
      '💧 Water → plant and animal',
      '🌬️ Air → plant and animal',
      '🍎 Food → animal',
      '🏡 Suitable place → living things'
    ],
    'science-1-3': ['Seed', 'Sprout', 'Young plant', 'Mature plant'],
    'science-1-sort': [
      'Cat → living',
      'Sunflower → living',
      'Fish → living',
      'Rock → nonliving',
      'Bicycle → nonliving',
      'Teddy bear → nonliving'
    ],
    'science-2-1': [
      '🌻 Flowering plant',
      '🌳 Tree',
      '🌵 Cactus',
      '🌾 Grass',
      '🌿 Fern'
    ],
    'science-2-2': [
      'Flower → helps make seeds',
      'Leaf → captures light',
      'Stem → supports and moves materials',
      'Roots → absorb water and hold the plant'
    ],
    'science-2-3': ['🐕 Dog', '🐦 Bird', '🐟 Fish', '🦋 Butterfly', '🐸 Frog'],
    'science-2-4': [
      '🐟 Fish: fins → swimming',
      '🐦 Bird: wings → flying',
      '🐸 Frog: strong legs → jumping',
      '🐕 Dog: legs → walking and running'
    ],
    'science-2-5': [
      'PLANTS: usually rooted; use light to make food; roots, stems, leaves',
      'BOTH: living; need water and energy; grow, respond, have life cycles',
      'ANIMALS: eat food; usually move; parts for movement and sensing'
    ],
    'science-2-6': [
      '🌳 Forest → trees and birds',
      '💧 Pond → fish and water plants',
      '🌾 Grassland → grass and rabbits',
      '🌻 Garden → flowers and bees'
    ],
    'science-2-7': [
      'PLANT: Seed →',
      'PLANT: Sprout →',
      'PLANT: Plant →',
      'PLANT: New seeds ↺',
      'ANIMAL: Egg →',
      'ANIMAL: Chick →',
      'ANIMAL: Adult chicken'
    ],
    'science-2-sort': [
      'Sunflower → plant',
      'Tree → plant',
      'Cactus → plant',
      'Dog → animal',
      'Fish → animal',
      'Butterfly → animal'
    ],
    'science-3-1': [
      'Head',
      'Neck',
      'Shoulder',
      'Arm',
      'Hand',
      'Fingers',
      'Leg',
      'Knee',
      'Foot'
    ],
    'science-3-2': [
      '👀 Eyes → sight',
      '👂 Ears → hearing',
      '👃 Nose → smell',
      '👅 Tongue → taste',
      '✋ Skin → touch'
    ],
    'science-3-3': [
      '👀 Sight → red flower',
      '👂 Hearing → bell',
      '👃 Smell → orange',
      '👅 Taste → safe food',
      '✋ Touch → soft teddy bear'
    ],
    'science-3-4': [
      'Sight → eyes',
      'Hearing → ears',
      'Smell → nose',
      'Taste → tongue',
      'Touch → skin'
    ],
    'science-3-apple': [
      'Sight → red and round',
      'Touch → smooth and firm',
      'Smell → apple smell',
      'Taste → safe apple flavor',
      'Hearing → crunch'
    ],
    'science-3-jobs': [
      'Legs → walking and running',
      'Hands → holding and picking up',
      'Eyes → seeing',
      'Ears → hearing',
      'Nose → smelling',
      'Tongue → tasting',
      'Skin → sensing touch'
    ],
    'science-3-safety': [
      'Eyes → never stare at the Sun',
      'Ears → comfortable volume',
      'Nose → avoid unknown chemicals',
      'Mouth → only safe food',
      'Skin → avoid very hot objects'
    ],
    'science-4-1': ['Sun · mostly clear sky', 'Hat · water · shade'],
    'science-4-2': [
      'Rain cloud → falling water',
      'Umbrella · raincoat · puddles'
    ],
    'science-4-3': [
      'Moving air → waving flag',
      'Moving air → blowing leaves',
      'Moving air → swaying branches',
      'Moving air → flying kite'
    ],
    'science-4-4': ['Morning: sunny', 'Afternoon: cloudy', 'Evening: rainy'],
    'science-4-5': ['Hot', 'Warm', 'Cool', 'Cold'],
    'science-4-6': [
      'Thermometer → temperature',
      'Rain gauge → rainfall',
      'Wind vane → wind direction',
      'Anemometer → wind speed'
    ],
    'science-4-clothing': [
      'Sunny and hot → hat, light clothing, water',
      'Rainy → raincoat, umbrella, boots',
      'Cool → jacket and warm clothing'
    ],
    'science-4-safety': [
      'Sun → water and shade',
      'Rain → careful walking; avoid floods',
      'Thunder → safe indoor building',
      'Strong wind → avoid loose objects'
    ],
    'science-4-sort': [
      'Bright sky and Sun → sunny',
      'Water falling and umbrellas → rainy',
      'Flags and leaves moving → windy',
      'Thunder and lightning → stormy'
    ],
  };

  @override
  Widget build(BuildContext context) {
    if (NorieGrade1MaterialsVisual.labels.containsKey(type)) {
      return NorieGrade1MaterialsVisual(type: type, caption: caption);
    }
    final items = labels[type] ?? const <String>[];
    final panels = panelTypes.contains(type);
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
          color: const Color(0xff17253a),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: NorieColors.green.withValues(alpha: .5))),
      child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
        if (!panels)
          Semantics(
              label: _description,
              image: true,
              child: SizedBox(
                  height: type == 'science-3-1' ? 280 : 150,
                  child: CustomPaint(painter: _ScienceDrawing(type)))),
        const SizedBox(height: 10),
        if (panels)
          for (final item in items)
            Container(
              margin: const EdgeInsets.only(bottom: 10),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                  color: const Color(0xff263b54),
                  borderRadius: BorderRadius.circular(12)),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Semantics(
                        label: item,
                        image: true,
                        child: SizedBox(
                            height: 75,
                            child: CustomPaint(
                                painter: _PanelDrawing(iconKind(type, item))))),
                    const SizedBox(height: 8),
                    Text(item,
                        style: const TextStyle(
                            fontSize: 16, height: 1.45, color: Colors.white)),
                  ]),
            ),
        if (!panels)
          for (var i = 0; i < items.length; i++)
            Padding(
              padding: const EdgeInsets.only(bottom: 7),
              child:
                  Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
                Container(
                    width: 23,
                    height: 23,
                    alignment: Alignment.center,
                    decoration: const BoxDecoration(
                        color: Color(0xff295440), shape: BoxShape.circle),
                    child: Text('${i + 1}',
                        style: const TextStyle(
                            fontSize: 12, fontWeight: FontWeight.bold))),
                const SizedBox(width: 8),
                Expanded(
                    child: Text(items[i],
                        style: const TextStyle(fontSize: 15, height: 1.4))),
              ]),
            ),
        if (caption.isNotEmpty)
          Text(caption,
              style: const TextStyle(
                  fontSize: 15, height: 1.45, fontWeight: FontWeight.w600)),
      ]),
    );
  }

  String get _description => labels[type]?.join('. ') ?? 'Science diagram';
}

class _PanelDrawing extends CustomPainter {
  const _PanelDrawing(this.label);
  final String label;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 200, size.height / 90);
    final text = label.toLowerCase();
    final ink = Paint()..color = const Color(0xff85dca0);
    final stroke = Paint()
      ..color = const Color(0xff85dca0)
      ..strokeWidth = 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;
    void line(double x, double y, double a, double b) =>
        canvas.drawLine(Offset(x, y), Offset(a, b), stroke);
    void plant(double x,
        {bool tree = false, bool cactus = false, bool flower = false}) {
      line(x, 79, x, 25);
      if (cactus) {
        line(x, 49, x - 18, 49);
        line(x - 18, 49, x - 18, 32);
        line(x, 59, x + 18, 59);
        line(x + 18, 59, x + 18, 40);
      } else if (tree) {
        canvas.drawCircle(Offset(x, 26), 23, ink);
        canvas.drawCircle(Offset(x - 16, 37), 17, ink);
        canvas.drawCircle(Offset(x + 16, 37), 17, ink);
      } else {
        canvas.drawOval(
            Rect.fromCenter(center: Offset(x - 12, 47), width: 25, height: 14),
            ink);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(x + 12, 61), width: 25, height: 14),
            ink);
        if (flower) {
          canvas.drawCircle(
              Offset(x, 22), 15, Paint()..color = const Color(0xffffcb67));
        }
      }
    }

    if (text.contains('seed')) {
      canvas.drawOval(const Rect.fromLTWH(72, 26, 56, 35),
          Paint()..color = const Color(0xffbf9169));
      if (text.contains('new seeds')) {
        for (var i = 0; i < 3; i++) {
          canvas.drawOval(Rect.fromLTWH(45 + i * 40.0, 66, 20, 13),
              Paint()..color = const Color(0xffbf9169));
        }
      }
    } else if (text.contains('egg')) {
      canvas.drawOval(const Rect.fromLTWH(77, 11, 46, 68),
          Paint()..color = const Color(0xfff4e2c1));
    } else if (text.contains('chick')) {
      ink.color = text.contains('adult')
          ? const Color(0xfff4e2c1)
          : const Color(0xffffcd67);
      canvas.drawOval(const Rect.fromLTWH(64, 32, 71, 45), ink);
      canvas.drawCircle(const Offset(137, 28), 19, ink);
      canvas.drawPath(
          Path()
            ..moveTo(151, 21)
            ..lineTo(174, 28)
            ..lineTo(151, 36)
            ..close(),
          Paint()..color = const Color(0xfff4ab67));
      line(90, 75, 87, 86);
      line(115, 75, 119, 86);
    } else if (text.contains('pond')) {
      canvas.drawOval(const Rect.fromLTWH(10, 30, 180, 50),
          Paint()..color = const Color(0xff6aafe2));
      canvas.drawOval(const Rect.fromLTWH(64, 46, 43, 20),
          Paint()..color = const Color(0xffffbd75));
      canvas.drawPath(
          Path()
            ..moveTo(105, 56)
            ..lineTo(123, 42)
            ..lineTo(123, 70)
            ..close(),
          Paint()..color = const Color(0xffffbd75));
      plant(160);
    } else if (text.contains('forest') ||
        text.contains('garden') ||
        text.contains('grassland')) {
      canvas.drawRect(const Rect.fromLTWH(0, 75, 200, 15),
          Paint()..color = const Color(0xff496647));
      for (final x in [35.0, 100.0, 165.0]) {
        plant(x,
            tree: text.contains('forest'), flower: text.contains('garden'));
      }
      if (text.contains('grassland')) {
        for (var i = 0; i < 10; i++) {
          line(i * 19.0, 80, i * 19.0 + 8, 65);
        }
      }
    } else if (text.contains('plants') ||
        text.contains('plant') ||
        text.contains('flower') ||
        text.contains('fern') ||
        text.contains('sprout') ||
        text.contains('cactus') ||
        text.contains('tree') ||
        text.contains('grass')) {
      if (text.contains('sort') || text.contains('plants:')) {
        plant(40, flower: true);
        plant(100, tree: true);
        plant(160, cactus: true);
      } else {
        plant(100,
            tree: text.contains('tree'),
            cactus: text.contains('cactus'),
            flower: text.contains('flower'));
      }
    } else if (text == 'bicycle') {
      canvas.drawCircle(const Offset(55, 60), 22, stroke);
      canvas.drawCircle(const Offset(150, 60), 22, stroke);
      line(55, 60, 95, 60);
      line(95, 60, 70, 25);
      line(70, 25, 55, 60);
      line(70, 25, 130, 25);
      line(130, 25, 95, 60);
      line(130, 25, 150, 60);
      line(130, 25, 140, 10);
    } else if (text == 'teddy bear') {
      ink.color = const Color(0xffcfad90);
      canvas.drawCircle(const Offset(80, 15), 12, ink);
      canvas.drawCircle(const Offset(120, 15), 12, ink);
      canvas.drawCircle(const Offset(100, 32), 25, ink);
      canvas.drawOval(const Rect.fromLTWH(73, 48, 54, 35), ink);
      canvas.drawCircle(const Offset(91, 29), 3, Paint()..color = Colors.white);
      canvas.drawCircle(
          const Offset(109, 29), 3, Paint()..color = Colors.white);
    } else if (text == 'cat') {
      ink.color = const Color(0xffefbd8d);
      canvas.drawOval(const Rect.fromLTWH(55, 36, 74, 32), ink);
      canvas.drawCircle(const Offset(139, 32), 17, ink);
      canvas.drawPath(
          Path()
            ..moveTo(125, 23)
            ..lineTo(124, 8)
            ..lineTo(139, 18)
            ..lineTo(151, 8)
            ..lineTo(153, 24)
            ..close(),
          ink);
      line(61, 64, 61, 83);
      line(120, 64, 120, 83);
      canvas.drawArc(
          const Rect.fromLTWH(27, 17, 33, 43), 0, 4.8, false, stroke);
    } else if (text == 'toy car') {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(44, 34, 113, 34), const Radius.circular(9)),
          Paint()..color = const Color(0xff83bff4));
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(71, 13, 60, 30), const Radius.circular(8)),
          Paint()..color = const Color(0xff83bff4));
      for (final x in [69.0, 133.0]) {
        canvas.drawCircle(
            Offset(x, 70), 12, Paint()..color = const Color(0xffb9c8db));
      }
    } else if (text == 'frog') {
      canvas.drawOval(const Rect.fromLTWH(65, 30, 70, 45), ink);
      canvas.drawCircle(const Offset(80, 29), 12, ink);
      canvas.drawCircle(const Offset(122, 29), 12, ink);
      for (final x in [80.0, 122.0]) {
        canvas.drawCircle(Offset(x, 26), 5, Paint()..color = Colors.white);
      }
      line(71, 58, 46, 75);
      line(46, 75, 76, 81);
      line(128, 58, 153, 75);
      line(153, 75, 126, 81);
    } else if (text.contains('fish') || text.contains('fins')) {
      ink.color = const Color(0xff83bff4);
      canvas.drawOval(const Rect.fromLTWH(50, 25, 85, 45), ink);
      canvas.drawPath(
          Path()
            ..moveTo(131, 48)
            ..lineTo(166, 20)
            ..lineTo(166, 75)
            ..close(),
          ink);
      canvas.drawCircle(const Offset(70, 42), 4, Paint()..color = Colors.white);
      canvas.drawPath(
          Path()
            ..moveTo(88, 24)
            ..lineTo(110, 7)
            ..lineTo(116, 28)
            ..close(),
          ink);
    } else if (text.contains('butterfly')) {
      ink.color = const Color(0xffd09cf0);
      for (final x in [78.0, 121.0]) {
        canvas.drawOval(
            Rect.fromCenter(center: Offset(x, 29), width: 39, height: 44), ink);
        canvas.drawOval(
            Rect.fromCenter(center: Offset(x, 60), width: 31, height: 33), ink);
      }
      line(100, 14, 100, 77);
    } else if (text.contains('bird') || text.contains('wings')) {
      ink.color = const Color(0xfff4c977);
      canvas.drawOval(const Rect.fromLTWH(58, 32, 72, 35), ink);
      canvas.drawCircle(const Offset(133, 29), 14, ink);
      canvas.drawPath(
          Path()
            ..moveTo(145, 25)
            ..lineTo(169, 33)
            ..lineTo(145, 37)
            ..close(),
          ink);
      line(89, 60, 86, 80);
      line(109, 60, 114, 80);
      canvas.drawArc(
          const Rect.fromLTWH(65, 18, 56, 49), 0, 3.14, false, stroke);
    } else if (text.contains('eyes') || text.contains('sight')) {
      canvas.drawOval(const Rect.fromLTWH(49, 25, 102, 42), stroke);
      canvas.drawCircle(const Offset(100, 46), 15, ink);
      canvas.drawCircle(
          const Offset(100, 46), 7, Paint()..color = const Color(0xff263b54));
    } else if (text.contains('ears') || text.contains('hearing')) {
      canvas.drawArc(
          const Rect.fromLTWH(80, 8, 45, 68), -1.5, 5.1, false, stroke);
      line(107, 29, 92, 45);
      line(92, 45, 102, 57);
    } else if (text.contains('nose') || text.contains('smell')) {
      canvas.drawPath(
          Path()
            ..moveTo(100, 12)
            ..lineTo(77, 62)
            ..quadraticBezierTo(102, 80, 122, 61),
          stroke);
    } else if (text.contains('tongue') ||
        text.contains('mouth') ||
        text.contains('taste')) {
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(80, 16, 40, 63), const Radius.circular(19)),
          Paint()..color = const Color(0xffef9bb1));
      line(100, 33, 100, 66);
    } else if (text.contains('hand') ||
        text.contains('skin') ||
        text.contains('touch')) {
      ink.color = const Color(0xffffcdad);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(77, 42, 45, 39), const Radius.circular(10)),
          ink);
      for (var i = 0; i < 4; i++) {
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(77 + i * 12.0, 8 + i % 2 * 8, 9, 44),
                const Radius.circular(4)),
            ink);
      }
    } else if (text.contains('rain') ||
        text.contains('cloud') ||
        text.contains('storm') ||
        text.contains('thunder')) {
      ink.color = const Color(0xffc5d4e5);
      for (var i = 0; i < 3; i++) {
        canvas.drawCircle(Offset(76 + i * 25.0, 29 + i % 2 * 8), 22, ink);
      }
      if (!text.contains('cloudy')) {
        for (var i = 0; i < 4; i++) {
          line(67 + i * 24.0, 61, 59 + i * 24.0, 81);
        }
      }
      if (text.contains('thunder') || text.contains('storm')) {
        canvas.drawPath(
            Path()
              ..moveTo(108, 43)
              ..lineTo(96, 64)
              ..lineTo(111, 60)
              ..lineTo(99, 85),
            Paint()
              ..color = const Color(0xffffcd67)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 6);
      }
    } else if (text.contains('sun') || text.contains('hot')) {
      canvas.drawCircle(
          const Offset(100, 43), 25, Paint()..color = const Color(0xffffcd67));
      stroke.color = const Color(0xffffcd67);
      line(100, 4, 100, 11);
      line(100, 75, 100, 85);
      line(59, 43, 66, 43);
      line(134, 43, 142, 43);
    } else if (text.contains('wind') || text.contains('flag')) {
      line(45, 81, 45, 8);
      canvas.drawPath(
          Path()
            ..moveTo(45, 12)
            ..quadraticBezierTo(78, 0, 95, 24)
            ..quadraticBezierTo(75, 42, 45, 29)
            ..close(),
          Paint()..color = const Color(0xffffa6ad));
      line(116, 32, 172, 32);
      line(124, 52, 183, 52);
      line(169, 27, 174, 32);
      line(169, 37, 174, 32);
    } else if (text.contains('rock') || text.contains('nonliving')) {
      canvas.drawPath(
          Path()
            ..moveTo(63, 75)
            ..lineTo(49, 48)
            ..lineTo(77, 21)
            ..lineTo(126, 26)
            ..lineTo(151, 65)
            ..lineTo(132, 77)
            ..close(),
          Paint()..color = const Color(0xffa7b3c6));
    } else if (text.contains('chair')) {
      line(70, 12, 70, 75);
      line(129, 40, 129, 75);
      line(70, 40, 129, 40);
      line(70, 12, 108, 12);
      line(108, 12, 108, 40);
    } else if (text.contains('pencil')) {
      canvas.drawRect(const Rect.fromLTWH(40, 34, 120, 17),
          Paint()..color = const Color(0xffffcd67));
      canvas.drawPath(
          Path()
            ..moveTo(160, 34)
            ..lineTo(181, 42)
            ..lineTo(160, 51)
            ..close(),
          Paint()..color = const Color(0xffffcdad));
    } else if (text.contains('legs') || text.contains('child')) {
      canvas.drawCircle(
          const Offset(100, 13), 10, Paint()..color = const Color(0xffffcdad));
      canvas.drawRect(const Rect.fromLTWH(89, 25, 22, 28),
          Paint()..color = const Color(0xff83bff4));
      line(91, 51, 77, 80);
      line(109, 51, 123, 80);
      line(87, 29, 67, 47);
      line(113, 29, 133, 47);
    } else {
      ink.color = const Color(0xffefbd8d);
      canvas.drawOval(const Rect.fromLTWH(53, 33, 78, 35), ink);
      canvas.drawCircle(const Offset(139, 30), 19, ink);
      line(61, 65, 61, 83);
      line(121, 65, 121, 83);
      line(55, 43, 39, 25);
      canvas.drawCircle(
          const Offset(145, 25), 3, Paint()..color = Colors.white);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _PanelDrawing oldDelegate) =>
      oldDelegate.label != label;
}

class _ScienceDrawing extends CustomPainter {
  const _ScienceDrawing(this.type);
  final String type;
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 300, size.height / 170);
    final stroke = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..color = const Color(0xff76dfa2);
    final fill = Paint()..color = const Color(0xff76dfa2);
    void line(double x, double y, double a, double b) =>
        canvas.drawLine(Offset(x, y), Offset(a, b), stroke);
    void text(String label, double x, double y, {Color color = Colors.white}) {
      final tp = TextPainter(
          text: TextSpan(
              text: label,
              style: TextStyle(
                  color: color, fontSize: 12, fontWeight: FontWeight.w700)),
          textDirection: TextDirection.ltr)
        ..layout(maxWidth: 110);
      tp.paint(canvas, Offset(x, y));
    }

    void plant(double x, double y, double h, {bool flower = true}) {
      line(x, y, x, y - h);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(x - 12, y - h * .55), width: 25, height: 13),
          fill);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset(x + 12, y - h * .75), width: 25, height: 13),
          fill);
      if (flower) {
        canvas.drawCircle(
            Offset(x, y - h - 5), 12, Paint()..color = const Color(0xffffcd5a));
        canvas.drawCircle(
            Offset(x, y - h - 5), 5, Paint()..color = const Color(0xff9e603b));
      }
      stroke.color = const Color(0xffbd956c);
      line(x, y, x - 10, y + 15);
      line(x, y, x + 10, y + 15);
      stroke.color = const Color(0xff76dfa2);
    }

    void arrow(double x, double y, double a, double b) {
      line(x, y, a, b);
      final angle = math.atan2(b - y, a - x);
      for (final side in [-.5, .5]) {
        line(a, b, a - 8 * math.cos(angle + side),
            b - 8 * math.sin(angle + side));
      }
    }

    if (type == 'science-1-2') {
      plant(118, 113, 39);
      fill.color = const Color(0xffefbd8d);
      canvas.drawOval(const Rect.fromLTWH(149, 85, 52, 25), fill);
      canvas.drawCircle(const Offset(199, 81), 12, fill);
      stroke.color = const Color(0xffefbd8d);
      line(157, 108, 157, 121);
      line(188, 108, 188, 121);
      canvas.drawCircle(
          const Offset(42, 28), 13, Paint()..color = const Color(0xffffcd67));
      canvas.drawPath(
          Path()
            ..moveTo(253, 12)
            ..quadraticBezierTo(234, 36, 252, 43)
            ..quadraticBezierTo(269, 36, 253, 12)
            ..close(),
          Paint()..color = const Color(0xff80bdf4));
      canvas.drawCircle(
          const Offset(220, 154), 12, Paint()..color = const Color(0xfff48072));
      canvas.drawPath(
          Path()
            ..moveTo(245, 142)
            ..lineTo(245, 115)
            ..lineTo(265, 98)
            ..lineTo(285, 115)
            ..lineTo(285, 142)
            ..close(),
          Paint()..color = const Color(0xffce9bed));
      stroke.color = const Color(0xff8bcafa);
      stroke.strokeWidth = 2;
      line(125, 20, 174, 20);
      line(124, 30, 182, 30);
      line(124, 40, 165, 40);
      const sources = {
        'Light': Offset(54, 39),
        'Water': Offset(239, 42),
        'Air': Offset(151, 46),
        'Food': Offset(210, 145),
        'Suitable place': Offset(245, 130)
      };
      const destinations = {
        'plant': Offset(118, 85),
        'animal': Offset(190, 100)
      };
      for (final resource in NorieGrade1ScienceVisual.resourceTargets.entries) {
        final source = sources[resource.key]!;
        for (final target in resource.value) {
          final destination = destinations[target]!;
          arrow(source.dx, source.dy, destination.dx, destination.dy);
        }
      }
      canvas.restore();
      return;
    }
    if (type == 'science-3-apple') {
      fill.color = const Color(0xfff47e72);
      canvas.drawCircle(const Offset(145, 83), 38, fill);
      canvas.drawCircle(const Offset(174, 83), 38, fill);
      stroke.color = const Color(0xffa77d5c);
      line(160, 50, 165, 25);
      fill.color = const Color(0xff76dfa2);
      canvas.drawOval(const Rect.fromLTWH(164, 24, 30, 13), fill);
      text('Red · round', 5, 24);
      text('Smooth · firm', 5, 102);
      text('Apple smell', 212, 24);
      text('Safe flavor', 212, 102);
      text('Crunch', 131, 143);
      stroke.strokeWidth = 1.4;
      stroke.color = Colors.white;
      line(78, 38, 128, 63);
      line(80, 114, 124, 105);
      line(211, 37, 190, 63);
      line(211, 114, 194, 105);
      canvas.restore();
      return;
    }
    final cardTypes = {
      'science-1-1',
      'science-1-2',
      'science-1-sort',
      'science-2-1',
      'science-2-3',
      'science-2-4',
      'science-2-5',
      'science-2-6',
      'science-2-sort',
      'science-3-3',
      'science-3-4',
      'science-3-jobs',
      'science-3-safety',
      'science-4-4',
      'science-4-clothing',
      'science-4-safety',
      'science-4-sort'
    };
    if (cardTypes.contains(type)) {
      final entries = NorieGrade1ScienceVisual.labels[type]!;
      final visible = entries.take(type == 'science-1-1' ? 8 : 6).toList();
      final columns = visible.length <= 3 ? visible.length : 2;
      final rows = (visible.length / columns).ceil();
      final w = 290 / columns;
      final h = 160 / rows;
      for (var i = 0; i < visible.length; i++) {
        final x = 5.0 + (i % columns) * w;
        final y = 5.0 + (i ~/ columns) * h;
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                Rect.fromLTWH(x, y, w - 7, h - 7), const Radius.circular(8)),
            Paint()
              ..color = [
                const Color(0xff295440),
                const Color(0xff344f79),
                const Color(0xff574573)
              ][i % 3]);
        final tp = TextPainter(
            text: TextSpan(
                text: visible[i],
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 11,
                    fontWeight: FontWeight.w700)),
            textDirection: TextDirection.ltr)
          ..layout(maxWidth: w - 22);
        tp.paint(canvas, Offset(x + 7, y + 7));
      }
      canvas.restore();
      return;
    }
    if (type == 'science-3-1') {
      fill.color = const Color(0xffffcdad);
      canvas.drawCircle(const Offset(145, 24), 15, fill);
      stroke.color = const Color(0xffffcdad);
      line(145, 40, 145, 46);
      fill.color = const Color(0xff64b9f1);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(125, 46, 40, 55), const Radius.circular(10)),
          fill);
      line(125, 52, 112, 82);
      line(112, 82, 104, 95);
      line(165, 52, 178, 82);
      line(178, 82, 186, 95);
      stroke.color = const Color(0xff99a8ff);
      line(136, 102, 132, 142);
      line(154, 102, 158, 142);
      line(132, 142, 122, 151);
      line(158, 142, 169, 151);
      stroke.strokeWidth = 1.2;
      stroke.color = Colors.white;
      const names = [
        'Head',
        'Neck',
        'Shoulder',
        'Arm',
        'Hand',
        'Fingers',
        'Leg',
        'Knee',
        'Foot'
      ];
      const anchors = [
        Offset(145, 20),
        Offset(145, 41),
        Offset(125, 49),
        Offset(116, 70),
        Offset(105, 92),
        Offset(102, 96),
        Offset(155, 115),
        Offset(158, 133),
        Offset(166, 150)
      ];
      for (var i = 0; i < names.length; i++) {
        final left = i < 5;
        final y = 8.0 + (left ? i : i - 5) * 29;
        text(names[i], left ? 2 : 210, y);
        line(left ? 65 : 208, y + 7, anchors[i].dx, anchors[i].dy);
      }
    } else if (type == 'science-2-2') {
      line(35, 125, 265, 125);
      plant(150, 125, 85);
      stroke.strokeWidth = 1.3;
      stroke.color = Colors.white;
      text('Flower', 210, 17);
      line(205, 27, 160, 34);
      text('Leaf', 5, 53);
      line(46, 62, 133, 78);
      text('Stem', 210, 83);
      line(206, 91, 151, 99);
      text('Roots', 5, 141);
      line(49, 149, 143, 139);
    } else if (type == 'science-1-3' || type == 'science-2-7') {
      for (var i = 0; i < 4; i++) {
        final x = 35.0 + i * 75;
        if (i == 0) {
          canvas.drawOval(
              Rect.fromCenter(center: Offset(x, 115), width: 15, height: 9),
              Paint()..color = const Color(0xffbd956c));
        } else {
          plant(x, 125, 20.0 + i * 18, flower: i == 3);
        }
        if (i < 3) arrow(x + 19, 70, x + 49, 70);
        text(['Seed', 'Sprout', 'Young', 'Mature'][i], x - 19, 148);
      }
    } else if (type.startsWith('science-3')) {
      final parts = ['Eye', 'Ear', 'Nose', 'Tongue', 'Skin'];
      for (var i = 0; i < 5; i++) {
        final x = 30.0 + i * 59;
        stroke.color = const Color(0xff8bcafa);
        fill.color = const Color(0xffffcdad);
        if (i == 0) {
          canvas.drawOval(
              Rect.fromCenter(center: Offset(x, 68), width: 43, height: 23),
              stroke);
          canvas.drawCircle(
              Offset(x, 68), 7, Paint()..color = const Color(0xff76dfa2));
        } else if (i == 1) {
          canvas.drawArc(
              Rect.fromCenter(center: Offset(x, 66), width: 29, height: 43),
              -1.5,
              4.9,
              false,
              stroke);
          line(x + 3, 57, x - 5, 67);
          line(x - 5, 67, x, 76);
        } else if (i == 2) {
          final path = Path()
            ..moveTo(x, 45)
            ..lineTo(x - 13, 75)
            ..quadraticBezierTo(x, 86, x + 12, 74);
          canvas.drawPath(path, stroke);
        } else if (i == 3) {
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromCenter(center: Offset(x, 67), width: 27, height: 40),
                  const Radius.circular(13)),
              Paint()..color = const Color(0xfff296a9));
          line(x, 62, x, 82);
        } else {
          canvas.drawRRect(
              RRect.fromRectAndRadius(
                  Rect.fromLTWH(x - 14, 63, 28, 26), const Radius.circular(7)),
              fill);
          for (var f = 0; f < 4; f++) {
            canvas.drawRRect(
                RRect.fromRectAndRadius(
                    Rect.fromLTWH(x - 14 + f * 8, 40 + f % 2 * 5, 6, 30),
                    const Radius.circular(3)),
                fill);
          }
        }
        text(parts[i], x - 19, 108);
      }
      text('Information → brain', 80, 143);
    } else if (type == 'science-4-6') {
      fill.color = const Color(0xfffa8b76);
      canvas.drawCircle(const Offset(35, 100), 12, fill);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(31, 35, 8, 68), const Radius.circular(4)),
          fill);
      stroke.color = const Color(0xff8bcafa);
      canvas.drawRect(const Rect.fromLTWH(85, 45, 35, 65), stroke);
      line(86, 85, 118, 85);
      for (var i = 0; i < 3; i++) {
        line(96, 18 + i * 8, 94, 24 + i * 8);
      }
      line(177, 110, 177, 47);
      arrow(150, 45, 206, 45);
      line(250, 110, 250, 50);
      line(250, 50, 228, 33);
      line(250, 50, 276, 35);
      line(250, 50, 250, 77);
      for (final p in [
        const Offset(228, 33),
        const Offset(276, 35),
        const Offset(250, 77)
      ]) {
        canvas.drawCircle(p, 9, stroke);
      }
      text('Temperature', 4, 133);
      text('Rain', 87, 133);
      text('Direction', 151, 133);
      text('Speed', 233, 133);
    } else if (type == 'science-4-3') {
      stroke.color = const Color(0xffc9d5e5);
      line(30, 151, 30, 22);
      canvas.drawPath(
          Path()
            ..moveTo(30, 25)
            ..quadraticBezierTo(57, 11, 87, 35)
            ..quadraticBezierTo(61, 54, 30, 45)
            ..close(),
          Paint()..color = const Color(0xfff3a1ac));
      stroke.color = const Color(0xff9d7858);
      line(122, 152, 131, 80);
      line(131, 99, 151, 79);
      fill.color = const Color(0xff79d7a3);
      canvas.drawCircle(const Offset(139, 60), 29, fill);
      canvas.drawOval(const Rect.fromLTWH(100, 29, 61, 40), fill);
      for (final point in [
        const Offset(74, 92),
        const Offset(173, 112),
        const Offset(210, 136)
      ]) {
        canvas.drawOval(
            Rect.fromCenter(center: point, width: 21, height: 9), fill);
      }
      canvas.drawPath(
          Path()
            ..moveTo(226, 27)
            ..lineTo(250, 56)
            ..lineTo(226, 80)
            ..lineTo(204, 56)
            ..close(),
          Paint()..color = const Color(0xff96b8f1));
      stroke.color = const Color(0xff96b8f1);
      stroke.strokeWidth = 1.5;
      canvas.drawPath(
          Path()
            ..moveTo(226, 80)
            ..quadraticBezierTo(204, 111, 235, 151),
          stroke);
      stroke.color = const Color(0xffc9d5e5);
      stroke.strokeWidth = 3;
      arrow(40, 111, 90, 111);
      arrow(168, 31, 193, 31);
      arrow(159, 146, 196, 146);
    } else if (type == 'science-4-5') {
      fill.color = const Color(0xfff18c7d);
      canvas.drawCircle(const Offset(100, 142), 17, fill);
      canvas.drawRRect(
          RRect.fromRectAndRadius(
              const Rect.fromLTWH(94, 15, 12, 125), const Radius.circular(5)),
          fill);
      for (var i = 0; i < 4; i++) {
        final y = 25.0 + i * 33;
        stroke.color = [
          const Color(0xfff18c7d),
          const Color(0xffffcd67),
          const Color(0xff83c9bd),
          const Color(0xff83bff4)
        ][i];
        line(119, y, 157, y);
        text(['Hot', 'Warm', 'Cool', 'Cold'][i], 171, y - 8,
            color: stroke.color);
      }
    } else if (type.startsWith('science-4')) {
      final rainy = type == 'science-4-2' ||
          type == 'science-4-safety' ||
          type == 'science-4-sort';
      canvas.drawCircle(
          const Offset(63, 40), 23, Paint()..color = const Color(0xffffd66e));
      for (var i = 0; i < 3; i++) {
        canvas.drawOval(Rect.fromLTWH(140.0 + i * 24, 25 + i % 2 * 8, 65, 35),
            Paint()..color = const Color(0xffc5d4e5));
      }
      if (rainy) {
        stroke.color = const Color(0xff69bdfb);
        for (var i = 0; i < 6; i++) {
          line(155.0 + i * 16, 75, 148.0 + i * 16, 95);
        }
        canvas.drawOval(const Rect.fromLTWH(160, 145, 80, 10),
            Paint()..color = const Color(0xff69bdfb));
        canvas.drawArc(const Rect.fromLTWH(110, 78, 60, 45), 3.14, 3.14, true,
            Paint()..color = const Color(0xfff4abef));
        line(140, 99, 140, 135);
      }
      if (type == 'science-4-1') {
        canvas.drawCircle(const Offset(170, 95), 12,
            Paint()..color = const Color(0xffffcdad));
        canvas.drawRect(const Rect.fromLTWH(155, 80, 30, 6),
            Paint()..color = const Color(0xffffd66e));
        canvas.drawRect(const Rect.fromLTWH(161, 72, 18, 9),
            Paint()..color = const Color(0xffffd66e));
        canvas.drawRRect(
            RRect.fromRectAndRadius(const Rect.fromLTWH(157, 107, 26, 25),
                const Radius.circular(5)),
            Paint()..color = const Color(0xff8bcafa));
        stroke.color = const Color(0xffffcdad);
        line(162, 132, 162, 150);
        line(178, 132, 178, 150);
        canvas.drawRRect(
            RRect.fromRectAndRadius(const Rect.fromLTWH(216, 112, 13, 30),
                const Radius.circular(4)),
            Paint()..color = const Color(0xff8bcafa));
        text('Water', 209, 148);
      }
      stroke.color = const Color(0xff76dfa2);
      plant(50, 140, 45, flower: false);
      if (type == 'science-4-3') {
        arrow(95, 110, 150, 110);
        arrow(175, 120, 230, 120);
        text('Moving air →', 105, 137);
      }
      if (type == 'science-4-5') {
        fill.color = const Color(0xffff846f);
        canvas.drawCircle(const Offset(150, 130), 16, fill);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                const Rect.fromLTWH(144, 55, 12, 77), const Radius.circular(6)),
            fill);
        text('Hot ↑', 170, 60);
        text('Cold ↓', 170, 120);
      }
      text(rainy ? 'Rain → water' : 'Sun → sunlight', 8, 8);
    } else {
      plant(70, 132, 65);
      fill.color = const Color(0xffefb780);
      canvas.drawOval(const Rect.fromLTWH(170, 87, 65, 35), fill);
      canvas.drawCircle(const Offset(237, 86), 18, fill);
      stroke.color = const Color(0xffefb780);
      line(180, 116, 180, 139);
      line(220, 116, 220, 139);
      line(170, 100, 156, 82);
      text('Plant', 45, 148);
      text('Animal', 184, 148);
      stroke.color = const Color(0xff76dfa2);
      arrow(110, 45, 154, 45);
      text('Resources / jobs', 84, 13);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ScienceDrawing oldDelegate) =>
      oldDelegate.type != type;
}
