import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/theme/norie_theme.dart';

/// Eight original, offline diagrams for Materials Around Us. All instructional
/// labels use Flutter text and reflow independently of the painted artwork.
class NorieGrade1MaterialsVisual extends StatelessWidget {
  const NorieGrade1MaterialsVisual(
      {required this.type, this.caption = '', super.key});
  final String type;
  final String caption;

  static const labels = <String, List<String>>{
    'science-5-1': [
      'Chair → Wood',
      'Spoon → Metal',
      'Window → Glass',
      'Notebook page → Paper',
      'Shirt → Fabric',
      'Rubber ball → Rubber'
    ],
    'science-5-2': [
      'WOOD · Chair or pencil',
      'METAL · Spoon or key',
      'PLASTIC · Bottle or toy',
      'GLASS · Window or jar',
      'PAPER · Book or notebook',
      'FABRIC · Shirt or blanket',
      'RUBBER · Ball or tire'
    ],
    'science-5-3': [
      'HARD · Metal',
      'SOFT · Fabric',
      'SMOOTH · Glass',
      'ROUGH · Unfinished wood',
      'FLEXIBLE · Rubber',
      'WATERPROOF · Plastic',
      'ABSORBENT · Sponge or paper towel'
    ],
    'science-5-4': [
      'REDUCE · Use only what we need.',
      'REUSE · Use safe objects again.',
      'RECYCLE · Sort suitable materials for recycling.'
    ],
    'science-5-5': [
      'Transparent · Clear glass',
      'Light and view pass through',
      'Opaque · Wood',
      'Light and view are blocked'
    ],
    'science-5-6': [
      '1 · Metal frame',
      '2 · Rubber tires',
      '3 · Plastic pedal parts',
      '4 · Fabric or foam on the seat'
    ],
    'science-5-7': [
      'Umbrella → Waterproof',
      'Blanket → Soft',
      'Window → Transparent',
      'Bicycle tire → Flexible and grippy',
      'Spoon → Hard and strong'
    ],
    'science-5-8': [
      'Wooden table → Wood',
      'Metal spoon → Metal',
      'Glass window → Glass',
      'Paper notebook → Paper',
      'Cotton shirt → Fabric',
      'Rubber ball → Rubber'
    ],
  };

  static const _objects = [
    ('chair', 'Chair', 'Wood'),
    ('spoon', 'Spoon', 'Metal'),
    ('window', 'Window', 'Glass'),
    ('page', 'Notebook page', 'Paper'),
    ('shirt', 'Shirt', 'Fabric'),
    ('ball', 'Rubber ball', 'Rubber'),
  ];

  @override
  Widget build(BuildContext context) => Container(
        width: double.infinity,
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xff17253a),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: NorieColors.green.withValues(alpha: .5)),
        ),
        child:
            Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
          ..._diagram(),
          if (caption.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(top: 12),
              child: _label(caption),
            ),
        ]),
      );

  List<Widget> _diagram() => switch (type) {
        'science-5-1' => [
            _label('OBJECT → MATERIAL', bold: true),
            for (final object in _objects)
              _ObjectMaterialRow(object.$1, object.$2, object.$3),
          ],
        'science-5-2' => [
            LayoutBuilder(builder: (context, constraints) {
              // A single column at narrow widths or enlarged text keeps labels readable.
              final twoColumns = constraints.maxWidth >= 380 &&
                  MediaQuery.textScalerOf(context).scale(16) <= 20;
              final width = twoColumns
                  ? (constraints.maxWidth - 12) / 2
                  : constraints.maxWidth;
              const cards = [
                ('chair', 'WOOD', 'Chair or pencil'),
                ('spoon', 'METAL', 'Spoon or key'),
                ('bottle', 'PLASTIC', 'Bottle or toy'),
                ('window', 'GLASS', 'Window or jar'),
                ('book', 'PAPER', 'Book or notebook'),
                ('shirt', 'FABRIC', 'Shirt or blanket'),
                ('ball', 'RUBBER', 'Ball or tire'),
              ];
              return Wrap(spacing: 12, runSpacing: 12, children: [
                for (final card in cards)
                  SizedBox(
                      width: width,
                      child: _panel([
                        _art(card.$1, card.$3, height: 92),
                        _label(card.$2, bold: true),
                        _label(card.$3),
                      ])),
              ]);
            })
          ],
        'science-5-3' => [
            _label('Compare these examples', bold: true),
            _label(
                'Different forms of a material can have different properties.'),
            for (final row in const [
              ('spoon', 'HARD', 'Metal spoon'),
              ('blanket', 'SOFT', 'Soft fabric'),
              ('window', 'SMOOTH', 'Glass window'),
              ('wood', 'ROUGH', 'Unfinished wood'),
              ('band', 'FLEXIBLE', 'Rubber band'),
              ('bottle-water', 'WATERPROOF', 'Waterproof plastic bottle'),
              ('sponge', 'ABSORBENT', 'Sponge or paper towel'),
            ])
              _panel([
                _art(row.$1, '${row.$3}: ${row.$2.toLowerCase()}', height: 90),
                _label(row.$2, bold: true),
                _label(row.$3),
              ]),
          ],
        'science-5-4' => [
            _panel([
              _label('REDUCE', bold: true),
              _art('reduce',
                  'Use one sheet for this drawing instead of taking a whole stack.'),
              _label('Use only what we need.'),
              _label('Take one sheet for your drawing.')
            ]),
            _panel([
              _label('REUSE', bold: true),
              _art('reuse', 'A clean safe jar is used again to store pencils.'),
              _label('Use safe objects again.'),
              _label('A clean safe jar can hold pencils.')
            ]),
            _panel([
              _label('RECYCLE', bold: true),
              _art('recycle',
                  'Used paper is sorted, processed, and made into a new notebook.'),
              _label('Sort suitable materials for recycling.'),
              _label('Used paper → sort and process → new paper'),
              _label('Follow local instructions and adult guidance.')
            ]),
          ],
        'science-5-5' => [
            _panel([
              _label('TRANSPARENT · Clear glass', bold: true),
              _art('transparent',
                  'Yellow light rays pass through clear glass. A tree can be seen through it.',
                  height: 145),
              _label('Light and view pass through. 👀')
            ]),
            _panel([
              _label('OPAQUE · Wood', bold: true),
              _art('opaque',
                  'Yellow light rays stop at the wooden panel. The panel hides the tree.',
                  height: 145),
              _label('Light and view are blocked.')
            ]),
          ],
        'science-5-6' => [
            _label('One bicycle, many materials', bold: true),
            _art('bicycle',
                'Bicycle with numbered pointers: one metal frame, two rubber tires, three plastic pedal parts, four fabric or foam seat.',
                height: 220),
            for (final label in labels['science-5-6']!)
              Padding(
                  padding: const EdgeInsets.only(bottom: 8),
                  child: _label(label, bold: true)),
            _label(
                'A bicycle may use these materials. Each part has a different job.'),
          ],
        'science-5-7' => [
            for (final row in const [
              ('umbrella', 'Umbrella', 'Waterproof', 'Keeps rain away'),
              ('blanket', 'Blanket', 'Soft', 'Feels comfortable'),
              (
                'transparent',
                'Window',
                'Transparent',
                'Lets light and our view through'
              ),
              (
                'tire',
                'Bicycle tire',
                'Flexible and grippy',
                'Bends and grips the road'
              ),
              ('spoon', 'Spoon', 'Hard and strong', 'Holds food'),
            ])
              _panel([
                _label(row.$2, bold: true),
                _art(row.$1, '${row.$2}: ${row.$3.toLowerCase()}', height: 100),
                _label(
                    'Useful ${row.$3.contains(' and ') ? 'properties' : 'property'} → ${row.$3}',
                    bold: true),
                _label(row.$4),
              ]),
          ],
        'science-5-8' => [const _MaterialsSorting()],
        _ => [],
      };
}

Widget _label(String text, {bool bold = false}) => Text(text,
    style: TextStyle(
        color: Colors.white,
        fontSize: 16,
        height: 1.45,
        fontWeight: bold ? FontWeight.w700 : FontWeight.w400));

Widget _panel(List<Widget> children) => Container(
      margin: const EdgeInsets.only(top: 10),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
          color: const Color(0xff263b54),
          borderRadius: BorderRadius.circular(12)),
      child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch, children: children),
    );

Widget _art(String kind, String description, {double height = 110}) =>
    Semantics(
      image: true,
      label: description,
      child: SizedBox(
          height: height, child: CustomPaint(painter: _MaterialsDrawing(kind))),
    );

class _ObjectMaterialRow extends StatelessWidget {
  const _ObjectMaterialRow(this.kind, this.object, this.material);
  final String kind, object, material;
  @override
  Widget build(BuildContext context) => _panel([
        _art(kind, '$object made from $material', height: 75),
        _label('$object → $material', bold: true),
      ]);
}

class _MaterialsSorting extends StatefulWidget {
  const _MaterialsSorting();
  @override
  State<_MaterialsSorting> createState() => _MaterialsSortingState();
}

class _MaterialsSortingState extends State<_MaterialsSorting> {
  static const _items = [
    ('table', 'Wooden table', 'Wood'),
    ('spoon', 'Metal spoon', 'Metal'),
    ('window', 'Glass window', 'Glass'),
    ('book', 'Paper notebook', 'Paper'),
    ('shirt', 'Cotton shirt', 'Fabric'),
    ('ball', 'Rubber ball', 'Rubber'),
  ];
  static const _choices = [
    'Wood',
    'Metal',
    'Plastic',
    'Glass',
    'Paper',
    'Fabric',
    'Rubber'
  ];
  int _index = 0;
  String? _selected;
  bool _revealed = false;
  bool _complete = false;
  bool get _solved => _revealed || _selected == _items[_index].$3;

  @override
  Widget build(BuildContext context) {
    final item = _items[_index];
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      _label('Match the object to its material', bold: true),
      if (_complete) ...[
        _label('You sorted all six objects! 🎉'),
        for (final sorted in _items) _label('${sorted.$2} → ${sorted.$3}'),
        const SizedBox(height: 12),
        OutlinedButton(
            onPressed: () => setState(() {
                  _index = 0;
                  _selected = null;
                  _revealed = false;
                  _complete = false;
                }),
            child: const Text('Sort again')),
      ] else ...[
        _label('Object ${_index + 1} of ${_items.length}'),
        _art(item.$1, item.$2, height: 125),
        _label(item.$2, bold: true),
        const SizedBox(height: 12),
        Wrap(spacing: 8, runSpacing: 8, children: [
          for (final choice in _choices)
            ChoiceChip(
              label: Text(choice),
              selected: _selected == choice,
              onSelected:
                  _solved ? null : (_) => setState(() => _selected = choice),
            ),
        ]),
        if (_selected != null || _revealed)
          Padding(
            padding: const EdgeInsets.only(top: 12),
            child: Semantics(
                liveRegion: true,
                child: _label(
                  _solved
                      ? '${item.$2} → ${item.$3}. ${_revealed ? 'Look at the material and try the next object.' : 'Good match!'}'
                      : '$itemNameHint Try another material.',
                )),
          ),
        const SizedBox(height: 10),
        if (!_solved)
          OutlinedButton(
              onPressed: () => setState(() => _revealed = true),
              child: const Text('Reveal material')),
        if (_solved)
          FilledButton(
              onPressed: () => setState(() {
                    if (_index == _items.length - 1) {
                      _complete = true;
                    } else {
                      _index++;
                      _selected = null;
                      _revealed = false;
                    }
                  }),
              child: Text(_index == _items.length - 1
                  ? 'Finish sorting'
                  : 'Next object')),
      ],
    ]);
  }

  String get itemNameHint => switch (_items[_index].$1) {
        'shirt' => 'Cotton can be made into a material for clothing.',
        'spoon' => 'Think about what this hard spoon is made from.',
        'window' => 'Think about this clear window.',
        'book' => 'Think about the pages you write on.',
        'ball' => 'Think about the material in this bouncy ball.',
        _ => 'Think about the material in this wooden table.',
      };
}

/// Paints only artwork. Labels above and below remain accessible Flutter text.
class _MaterialsDrawing extends CustomPainter {
  const _MaterialsDrawing(this.kind);
  final String kind;
  static const _wood = Color(0xffd5a56e);
  static const _metal = Color(0xffc4d9eb);
  static const _blue = Color(0xff8bd7ff);
  static const _green = Color(0xff83dfae);
  static const _pink = Color(0xffedacc8);
  static const _yellow = Color(0xffffd36e);

  @override
  void paint(Canvas canvas, Size size) {
    final scale = math.min(size.width / 280, size.height / 160);
    canvas.save();
    canvas.translate(
        (size.width - 280 * scale) / 2, (size.height - 160 * scale) / 2);
    canvas.scale(scale);
    switch (kind) {
      case 'chair':
        _chair(canvas);
        break;
      case 'table':
        _table(canvas);
        break;
      case 'spoon':
        _spoon(canvas);
        break;
      case 'window':
        _window(canvas);
        break;
      case 'page':
        _page(canvas);
        break;
      case 'book':
        _book(canvas);
        break;
      case 'shirt':
        _shirt(canvas);
        break;
      case 'ball':
        _ball(canvas);
        break;
      case 'bottle':
        _bottle(canvas);
        break;
      case 'bottle-water':
        _bottle(canvas);
        for (final x in [89.0, 191.0]) {
          _drop(canvas, x, 65);
          _arrow(canvas, x, 91, x - 10, 116, _blue);
        }
        break;
      case 'wood':
        _woodBlock(canvas);
        break;
      case 'band':
        _band(canvas);
        break;
      case 'blanket':
        _blanket(canvas);
        break;
      case 'sponge':
        _sponge(canvas);
        break;
      case 'umbrella':
        _umbrella(canvas);
        break;
      case 'tire':
        _tire(canvas);
        break;
      case 'transparent':
        _lightPanel(canvas, transparent: true);
        break;
      case 'opaque':
        _lightPanel(canvas, transparent: false);
        break;
      case 'bicycle':
        _bicycle(canvas);
        break;
      case 'reduce':
        _reduce(canvas);
        break;
      case 'reuse':
        _reuse(canvas);
        break;
      case 'recycle':
        _recycle(canvas);
        break;
    }
    canvas.restore();
  }

  void _line(Canvas c, double x, double y, double a, double b, Color color,
          [double width = 5]) =>
      c.drawLine(
          Offset(x, y),
          Offset(a, b),
          Paint()
            ..color = color
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round);
  void _box(Canvas c, Rect r, Color color,
          {bool outline = false, double radius = 6}) =>
      c.drawRRect(
          RRect.fromRectAndRadius(r, Radius.circular(radius)),
          Paint()
            ..color = color
            ..style = outline ? PaintingStyle.stroke : PaintingStyle.fill
            ..strokeWidth = 4);
  void _arrow(Canvas c, double x, double y, double a, double b, Color color) {
    _line(c, x, y, a, b, color, 3);
    final angle = math.atan2(b - y, a - x);
    for (final turn in [-.6, .6]) {
      _line(c, a, b, a - 10 * math.cos(angle + turn),
          b - 10 * math.sin(angle + turn), color, 3);
    }
  }

  void _chair(Canvas c) {
    _box(c, const Rect.fromLTWH(99, 16, 70, 65), _wood);
    for (final x in [116.0, 140.0, 155.0]) {
      _line(c, x, 29, x, 68, const Color(0xffa77442), 2);
    }
    _box(c, const Rect.fromLTWH(89, 83, 100, 14), _wood);
    _line(c, 101, 95, 98, 144, _wood, 9);
    _line(c, 175, 95, 181, 144, _wood, 9);
    _line(c, 104, 78, 104, 87, _wood, 8);
    _line(c, 164, 78, 164, 87, _wood, 8);
  }

  void _table(Canvas c) {
    _box(c, const Rect.fromLTWH(48, 50, 184, 21), _wood);
    _line(c, 63, 69, 63, 139, _wood, 12);
    _line(c, 215, 69, 215, 139, _wood, 12);
    _line(c, 83, 58, 181, 58, const Color(0xffa77442), 2);
  }

  void _spoon(Canvas c) {
    c.drawOval(const Rect.fromLTWH(104, 12, 71, 58), Paint()..color = _metal);
    c.drawOval(const Rect.fromLTWH(113, 21, 51, 34),
        Paint()..color = const Color(0xff8099ae));
    _box(c, const Rect.fromLTWH(132, 58, 16, 88), _metal, radius: 8);
    _line(c, 140, 83, 140, 128, Colors.white.withValues(alpha: .5), 3);
  }

  void _window(Canvas c) {
    _box(
        c, const Rect.fromLTWH(65, 15, 150, 130), _blue.withValues(alpha: .25));
    _box(c, const Rect.fromLTWH(65, 15, 150, 130), _wood, outline: true);
    _line(c, 140, 17, 140, 144, _wood, 5);
    _line(c, 67, 80, 213, 80, _wood, 5);
    _line(c, 81, 52, 105, 28, Colors.white, 3);
    _line(c, 166, 126, 192, 100, Colors.white, 3);
  }

  void _page(Canvas c) {
    _box(c, const Rect.fromLTWH(86, 10, 111, 140), const Color(0xfff0f2e9));
    _line(c, 108, 17, 108, 141, _pink, 2);
    for (var i = 0; i < 6; i++) {
      _line(c, 114, 38 + i * 18, 181, 38 + i * 18, const Color(0xff87a4bb), 2);
    }
  }

  void _book(Canvas c) {
    _box(c, const Rect.fromLTWH(71, 23, 132, 120), _green);
    _box(c, const Rect.fromLTWH(84, 15, 128, 117), const Color(0xfff0f2e9));
    _box(c, const Rect.fromLTWH(71, 14, 125, 115), const Color(0xff779cdb));
    _line(c, 84, 16, 84, 126, const Color(0xff456ca6), 4);
    _box(c, const Rect.fromLTWH(107, 39, 63, 39), const Color(0xfff0f2e9));
    _line(c, 117, 53, 157, 53, const Color(0xff779cdb), 3);
  }

  void _shirt(Canvas c) {
    final p = Path()
      ..moveTo(103, 21)
      ..lineTo(72, 34)
      ..lineTo(45, 70)
      ..lineTo(78, 87)
      ..lineTo(94, 69)
      ..lineTo(94, 143)
      ..lineTo(187, 143)
      ..lineTo(187, 69)
      ..lineTo(203, 87)
      ..lineTo(235, 70)
      ..lineTo(208, 34)
      ..lineTo(177, 21)
      ..quadraticBezierTo(140, 53, 103, 21)
      ..close();
    c.drawPath(p, Paint()..color = _pink);
    c.drawPath(
        p,
        Paint()
          ..color = const Color(0xffbf6a97)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    _line(c, 110, 132, 173, 132, const Color(0xffbf6a97), 2);
    _line(c, 102, 62, 102, 122, Colors.white.withValues(alpha: .4), 2);
  }

  void _ball(Canvas c) {
    c.drawCircle(
        const Offset(140, 80), 62, Paint()..color = const Color(0xffed9872));
    final clip = Path()..addOval(const Rect.fromLTWH(78, 18, 124, 124));
    c.save();
    c.clipPath(clip);
    _line(c, 78, 80, 202, 80, const Color(0xff915939), 4);
    c.drawOval(
        const Rect.fromLTWH(108, 18, 64, 124),
        Paint()
          ..color = const Color(0xff915939)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 4);
    c.restore();
    c.drawOval(const Rect.fromLTWH(107, 30, 25, 13),
        Paint()..color = Colors.white.withValues(alpha: .4));
  }

  void _bottle(Canvas c) {
    final p = Path()
      ..moveTo(118, 34)
      ..lineTo(118, 49)
      ..quadraticBezierTo(98, 56, 98, 78)
      ..lineTo(98, 136)
      ..quadraticBezierTo(98, 149, 111, 149)
      ..lineTo(169, 149)
      ..quadraticBezierTo(182, 149, 182, 136)
      ..lineTo(182, 78)
      ..quadraticBezierTo(182, 56, 162, 49)
      ..lineTo(162, 34)
      ..close();
    c.drawPath(p, Paint()..color = _blue);
    _box(c, const Rect.fromLTWH(113, 13, 54, 23), _green);
    _box(c, const Rect.fromLTWH(99, 88, 82, 31), const Color(0xffeff4de));
    _line(c, 109, 66, 109, 80, Colors.white, 4);
  }

  void _woodBlock(Canvas c) {
    final p = Path()
      ..moveTo(54, 53)
      ..lineTo(71, 43)
      ..lineTo(92, 50)
      ..lineTo(115, 40)
      ..lineTo(137, 48)
      ..lineTo(160, 38)
      ..lineTo(185, 48)
      ..lineTo(218, 42)
      ..lineTo(231, 110)
      ..lineTo(51, 110)
      ..close();
    c.drawPath(p, Paint()..color = _wood);
    for (var i = 0; i < 3; i++) {
      c.drawPath(
          Path()
            ..moveTo(62, 64 + i * 15)
            ..quadraticBezierTo(122, 53 + i * 15, 214, 64 + i * 15),
          Paint()
            ..color = const Color(0xffa77442)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
    }
    _arrow(c, 76, 17, 121, 31, _yellow);
    _arrow(c, 181, 15, 159, 28, _yellow);
  }

  void _band(Canvas c) {
    c.drawOval(
        const Rect.fromLTWH(45, 51, 90, 64),
        Paint()
          ..color = _pink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8);
    _arrow(c, 140, 84, 165, 84, _yellow);
    c.drawOval(
        const Rect.fromLTWH(178, 36, 52, 104),
        Paint()
          ..color = _pink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 8);
    _arrow(c, 246, 77, 246, 36, _blue);
    _arrow(c, 246, 101, 246, 141, _blue);
  }

  void _blanket(Canvas c) {
    final p = Path()
      ..moveTo(55, 43)
      ..quadraticBezierTo(91, 26, 128, 46)
      ..quadraticBezierTo(171, 66, 220, 43)
      ..lineTo(218, 126)
      ..quadraticBezierTo(172, 145, 126, 125)
      ..quadraticBezierTo(82, 108, 55, 129)
      ..close();
    c.drawPath(p, Paint()..color = _pink);
    for (var i = 0; i < 4; i++) {
      c.drawPath(
          Path()
            ..moveTo(56, 61 + i * 18)
            ..quadraticBezierTo(91, 44 + i * 18, 128, 64 + i * 18)
            ..quadraticBezierTo(171, 84 + i * 18, 218, 61 + i * 18),
          Paint()
            ..color = const Color(0xffbf6a97)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
    }
    for (var i = 0; i < 8; i++) {
      _line(c, 65 + i * 20, 130, 65 + i * 20, 138, _pink, 3);
    }
  }

  void _drop(Canvas c, double x, double y) {
    c.drawPath(
        Path()
          ..moveTo(x, y - 13)
          ..quadraticBezierTo(x - 18, y + 6, x, y + 11)
          ..quadraticBezierTo(x + 18, y + 6, x, y - 13)
          ..close(),
        Paint()..color = _blue);
  }

  void _sponge(Canvas c) {
    _box(c, const Rect.fromLTWH(67, 89, 149, 47), _yellow);
    for (var i = 0; i < 12; i++) {
      c.drawCircle(Offset(80 + (i % 6) * 24, 103 + (i ~/ 6) * 19), 3,
          Paint()..color = const Color(0xffb88635));
    }
    for (final x in [90.0, 140.0, 190.0]) {
      _drop(c, x, 28);
      _arrow(c, x, 46, x, 87, _blue);
    }
    _box(c, const Rect.fromLTWH(67, 122, 149, 14), _blue.withValues(alpha: .4));
  }

  void _umbrella(Canvas c) {
    for (final x in [47.0, 83.0, 119.0, 165.0, 207.0, 244.0]) {
      _drop(c, x, 17);
    }
    c.drawPath(
        Path()
          ..moveTo(47, 91)
          ..quadraticBezierTo(140, -4, 233, 91)
          ..quadraticBezierTo(211, 73, 187, 91)
          ..quadraticBezierTo(164, 73, 140, 91)
          ..quadraticBezierTo(115, 73, 93, 91)
          ..quadraticBezierTo(69, 73, 47, 91)
          ..close(),
        Paint()..color = _pink);
    _line(c, 140, 77, 140, 135, _metal, 5);
    c.drawArc(
        const Rect.fromLTWH(118, 126, 22, 25),
        0,
        math.pi,
        false,
        Paint()
          ..color = _metal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 5);
    _arrow(c, 52, 80, 29, 104, _blue);
    _arrow(c, 228, 80, 251, 104, _blue);
  }

  void _tire(Canvas c) {
    c.drawCircle(
        const Offset(141, 76),
        57,
        Paint()
          ..color = const Color(0xff182330)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 18);
    c.drawCircle(
        const Offset(141, 76),
        44,
        Paint()
          ..color = _metal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    for (var i = 0; i < 16; i++) {
      final angle = i * math.pi / 8;
      _line(c, 141 + 52 * math.cos(angle), 76 + 52 * math.sin(angle),
          141 + 62 * math.cos(angle), 76 + 62 * math.sin(angle), _metal, 2);
    }
    _line(c, 65, 143, 218, 143, _wood, 5);
    for (final x in [112.0, 140.0, 169.0]) {
      _arrow(c, x, 155, x, 142, _green);
    }
  }

  void _tree(Canvas c, double x, double y) {
    _line(c, x, y + 21, x, y + 47, _wood, 7);
    c.drawCircle(Offset(x, y), 20, Paint()..color = _green);
    c.drawCircle(Offset(x - 13, y + 15), 16, Paint()..color = _green);
    c.drawCircle(Offset(x + 13, y + 15), 16, Paint()..color = _green);
  }

  void _lightPanel(Canvas c, {required bool transparent}) {
    // The same tree is clearly visible through the glass and covered by wood.
    _tree(c, 162, 68);
    c.drawCircle(const Offset(34, 38), 15, Paint()..color = _yellow);
    _box(c, const Rect.fromLTWH(112, 18, 93, 125),
        transparent ? _blue.withValues(alpha: .16) : _wood);
    _box(c, const Rect.fromLTWH(112, 18, 93, 125),
        transparent ? _blue : const Color(0xffa77442),
        outline: true);
    if (transparent) {
      for (final y in [47.0, 84.0, 122.0]) {
        _arrow(c, 48, y, 254, y, _yellow);
      }
      _line(c, 123, 36, 141, 25, Colors.white, 2);
    } else {
      for (final y in [47.0, 84.0, 122.0]) {
        _arrow(c, 48, y, 108, y, _yellow);
        _line(c, 108, y - 8, 108, y + 8, _pink, 3);
      }
      for (var i = 0; i < 5; i++) {
        _line(
            c, 124, 35 + i * 21, 192, 43 + i * 21, const Color(0xffa77442), 2);
      }
    }
    // An eye on the far side shows the viewpoint used for the comparison.
    c.drawOval(
        const Rect.fromLTWH(231, 65, 39, 23),
        Paint()
          ..color = _metal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    c.drawCircle(const Offset(251, 76), 6, Paint()..color = _blue);
  }

  void _marker(
      Canvas c, int n, double x, double y, double targetX, double targetY) {
    _line(c, x, y, targetX, targetY, Colors.white, 1.5);
    c.drawCircle(Offset(targetX, targetY), 3, Paint()..color = _yellow);
    c.drawCircle(Offset(x, y), 11, Paint()..color = const Color(0xff295440));
    final label = TextPainter(
        text: TextSpan(
            text: '$n',
            style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.bold)),
        textDirection: TextDirection.ltr)
      ..layout();
    label.paint(c, Offset(x - label.width / 2, y - label.height / 2));
  }

  void _bicycle(Canvas c) {
    for (final x in [57.0, 221.0]) {
      c.drawCircle(
          Offset(x, 105),
          38,
          Paint()
            ..color = const Color(0xff111b2a)
            ..style = PaintingStyle.stroke
            ..strokeWidth = 10);
      c.drawCircle(
          Offset(x, 105),
          33,
          Paint()
            ..color = _metal
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2);
      for (var i = 0; i < 8; i++) {
        final a = i * math.pi / 4;
        _line(
            c, x, 105, x + 31 * math.cos(a), 105 + 31 * math.sin(a), _metal, 1);
      }
    }
    // Two triangles form the frame; the front fork leads to the front hub.
    for (final edge in const [
      (57.0, 105.0, 98.0, 52.0),
      (98.0, 52.0, 128.0, 105.0),
      (128.0, 105.0, 57.0, 105.0),
      (98.0, 52.0, 188.0, 49.0),
      (188.0, 49.0, 128.0, 105.0),
      (188.0, 49.0, 221.0, 105.0)
    ]) {
      _line(c, edge.$1, edge.$2, edge.$3, edge.$4, _blue, 5);
    }
    _line(c, 98, 52, 92, 37, _metal, 4);
    _box(c, const Rect.fromLTWH(75, 29, 41, 12), _pink);
    _line(c, 188, 49, 181, 25, _metal, 4);
    _line(c, 181, 25, 205, 20, _metal, 4);
    c.drawCircle(
        const Offset(128, 105),
        11,
        Paint()
          ..color = _metal
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    _line(c, 128, 105, 146, 118, _metal, 3);
    _box(c, const Rect.fromLTWH(139, 115, 22, 8), _green, radius: 2);
    _marker(c, 1, 144, 32, 144, 50.5);
    _marker(c, 2, 31, 149, 40, 135);
    _marker(c, 3, 178, 143, 150, 119);
    _marker(c, 4, 54, 21, 86, 34);
  }

  void _reduce(Canvas c) {
    for (var i = 0; i < 4; i++) {
      _box(c, Rect.fromLTWH(26 + i * 5, 39 - i * 5, 64, 90),
          const Color(0xff8396aa));
    }
    _arrow(c, 105, 82, 148, 82, _green);
    _box(c, const Rect.fromLTWH(175, 24, 73, 111), const Color(0xfff0f2e9));
    c.drawCircle(const Offset(211, 58), 14, Paint()..color = _yellow);
    _line(c, 209, 77, 191, 100, _green, 3);
    _line(c, 209, 77, 230, 102, _green, 3);
    _line(c, 182, 117, 240, 117, _green, 3);
  }

  void _jar(Canvas c, double x) {
    _box(c, Rect.fromLTWH(x, 50, 62, 92), _blue.withValues(alpha: .2));
    _box(c, Rect.fromLTWH(x, 50, 62, 92), _blue, outline: true);
    _box(c, Rect.fromLTWH(x - 3, 43, 68, 12), _metal);
  }

  void _reuse(Canvas c) {
    _jar(c, 40);
    _arrow(c, 119, 83, 153, 83, _green);
    for (var i = 0; i < 3; i++) {
      _line(c, 184 + i * 15, 119, 174 + i * 16, 26, _yellow, 7);
      c.drawPath(
          Path()
            ..moveTo(171 + i * 16, 25)
            ..lineTo(174 + i * 16, 15)
            ..lineTo(178 + i * 16, 25)
            ..close(),
          Paint()..color = _wood);
    }
    _jar(c, 171);
  }

  void _recycle(Canvas c) {
    for (var i = 0; i < 3; i++) {
      _box(c, Rect.fromLTWH(14 + i * 5, 48 - i * 5, 48, 65),
          const Color(0xfff0f2e9));
    }
    _arrow(c, 78, 80, 104, 80, _green);
    _box(c, const Rect.fromLTWH(115, 56, 50, 72), _green);
    _box(c, const Rect.fromLTWH(110, 48, 60, 9), _metal);
    _arrow(c, 180, 80, 203, 80, _green);
    _box(c, const Rect.fromLTWH(217, 47, 54, 76), const Color(0xff779cdb));
    _line(c, 224, 49, 224, 120, _metal, 3);
    _box(c, const Rect.fromLTWH(232, 61, 28, 22), const Color(0xfff0f2e9));
    // Circular arrows represent processing used material into useful material.
    c.drawArc(
        const Rect.fromLTWH(119, 70, 40, 38),
        -.5,
        4.9,
        false,
        Paint()
          ..color = const Color(0xff295440)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3);
    _arrow(c, 143, 74, 153, 78, const Color(0xff295440));
  }

  @override
  bool shouldRepaint(covariant _MaterialsDrawing oldDelegate) =>
      oldDelegate.kind != kind;
}
