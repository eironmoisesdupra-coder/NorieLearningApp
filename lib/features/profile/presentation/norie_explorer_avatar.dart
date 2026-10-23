import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../domain/norie_explorer_appearance.dart';

/// Each state is a complete, original vector drawing. Frames switch discretely;
/// there are no limb pivots, interpolated poses, or network/artwork dependencies.
enum NorieExplorerPose {
  idle,
  curious,
  blink,
  waveOut,
  waveIn,
  ready,
  rise,
  waveMid,
  settle
}

class NorieExplorerAvatar extends StatefulWidget {
  const NorieExplorerAvatar({super.key, required this.appearance});
  final NorieExplorerAppearance appearance;
  @override
  State<NorieExplorerAvatar> createState() => _NorieExplorerAvatarState();
}

class _NorieExplorerAvatarState extends State<NorieExplorerAvatar>
    with WidgetsBindingObserver {
  Timer? _timer;
  bool _reduced = false, _visible = true, _active = true, _greeted = false;
  int _beat = 0, _wave = -1;
  static const _waveSequence = [
    NorieExplorerPose.ready,
    NorieExplorerPose.rise,
    NorieExplorerPose.waveOut,
    NorieExplorerPose.waveMid,
    NorieExplorerPose.waveIn,
    NorieExplorerPose.waveMid,
    NorieExplorerPose.waveOut,
    NorieExplorerPose.waveMid,
    NorieExplorerPose.waveIn,
    NorieExplorerPose.settle,
    NorieExplorerPose.idle,
  ];
  NorieExplorerPose _pose = NorieExplorerPose.idle;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _active = WidgetsBinding.instance.lifecycleState == null ||
        WidgetsBinding.instance.lifecycleState == AppLifecycleState.resumed;
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final reduced = MediaQuery.disableAnimationsOf(context) ||
        MediaQuery.accessibleNavigationOf(context);
    if (reduced && !_reduced) {
      _pose = NorieExplorerPose.idle;
      _wave = -1;
    }
    _reduced = reduced;
    _visible = TickerMode.valuesOf(context).enabled;
    _syncClock();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    _active = state == AppLifecycleState.resumed;
    _syncClock();
  }

  void _syncClock() {
    _timer?.cancel();
    _timer = null;
    if (_reduced || !_visible || !_active) return;
    _timer = Timer.periodic(const Duration(milliseconds: 100), (_) {
      NorieExplorerPose next;
      if (_wave >= 0) {
        _wave++;
        next = _waveSequence[_wave.clamp(0, _waveSequence.length - 1)];
        if (_wave >= _waveSequence.length - 1) {
          _wave = -1;
          _beat = 0;
        }
      } else {
        _beat = (_beat + 1) % 48;
        next = _beat == 30
            ? NorieExplorerPose.blink
            : _beat >= 16 && _beat <= 19
                ? NorieExplorerPose.curious
                : NorieExplorerPose.idle;
      }
      if (next != _pose) setState(() => _pose = next);
    });
  }

  void _hello() {
    setState(() {
      _greeted = true;
      _wave = _reduced ? -1 : 0;
      _pose = _reduced ? NorieExplorerPose.waveOut : _waveSequence.first;
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      Column(mainAxisSize: MainAxisSize.min, children: [
        const Text('Your Explorer',
            style: TextStyle(fontWeight: FontWeight.w800)),
        const SizedBox(height: 4),
        Semantics(
          label: 'Your Explorer. Wave hello',
          button: true,
          onTap: _hello,
          child: FocusableActionDetector(
            mouseCursor: SystemMouseCursors.click,
            shortcuts: const {
              SingleActivator(LogicalKeyboardKey.enter): ActivateIntent(),
              SingleActivator(LogicalKeyboardKey.space): ActivateIntent(),
            },
            actions: {
              ActivateIntent: CallbackAction<ActivateIntent>(onInvoke: (_) {
                _hello();
                return null;
              })
            },
            child: GestureDetector(
              excludeFromSemantics: true,
              onTap: _hello,
              child: SizedBox(
                  width: 158,
                  height: 211,
                  child: RepaintBoundary(
                      child: NorieExplorerIllustration(
                          key: ValueKey('explorer-frame-${_pose.name}'),
                          appearance: widget.appearance,
                          pose: _pose))),
            ),
          ),
        ),
        Text(_greeted ? 'Hello, Explorer!' : 'Tap or press Enter to wave',
            textAlign: TextAlign.center, style: const TextStyle(fontSize: 12)),
      ]);
}

/// Static complete-frame renderer, also useful in offline previews.
class NorieExplorerIllustration extends StatelessWidget {
  const NorieExplorerIllustration(
      {super.key, required this.appearance, required this.pose});
  final NorieExplorerAppearance appearance;
  final NorieExplorerPose pose;
  @override
  Widget build(BuildContext context) =>
      CustomPaint(painter: _ExplorerPainter(appearance, pose));
}

// Every entry explicitly describes the complete outline, hands, head, expression,
// trousers and shoes of one pose. Shared details (buttons/hair/accessories) are
// inked onto that drawing; none are rotated, rigged or tweened between frames.
class _Frame {
  const _Frame(this.coat, this.hands, this.head, this.legs, this.shoes,
      this.smile, this.eyeY);
  final String coat, hands, head, legs, shoes, smile;
  final double eyeY;
}

const _frames = {
  NorieExplorerPose.idle: _Frame(
      'M 65 104 Q 52 106 47 124 L 43 149 Q 48 155 57 151 L 64 131 L 63 165 Q 89 175 116 164 L 114 131 L 123 150 Q 131 153 137 146 L 128 121 Q 122 106 108 104 Z',
      'M 44 147 Q 38 150 40 158 Q 43 164 48 160 L 52 155 L 56 151 Z M 124 148 L 128 159 Q 134 165 139 158 Q 143 153 136 146 Z',
      'M 61 51 Q 61 31 88 30 Q 119 29 120 55 L 119 78 Q 116 98 91 102 Q 66 99 61 80 Z',
      'M 65 162 L 66 200 Q 73 205 83 201 L 89 180 L 97 202 Q 106 205 114 200 L 115 162 Z',
      'M 65 197 L 82 198 L 82 214 Q 73 220 55 217 Q 53 207 65 205 Z M 97 198 L 113 197 L 114 206 Q 128 210 124 219 Q 106 222 97 215 Z',
      'M 81 81 Q 90 90 101 80',
      66),
  NorieExplorerPose.curious: _Frame(
      'M 65 103 Q 52 104 47 122 L 41 147 Q 47 153 56 150 L 64 130 L 62 164 Q 87 176 116 163 L 114 129 L 122 147 Q 131 151 136 143 L 128 118 Q 122 104 108 103 Z',
      'M 42 145 Q 35 149 39 157 Q 44 163 50 156 L 56 150 Z M 123 145 L 127 156 Q 134 162 139 154 L 136 143 Z',
      'M 61 49 Q 63 29 89 29 Q 120 29 120 53 L 119 77 Q 115 98 91 100 Q 67 97 61 78 Z',
      'M 64 162 L 65 200 Q 74 205 83 201 L 89 180 L 99 202 Q 108 205 115 199 L 115 161 Z',
      'M 65 197 L 82 198 L 82 214 Q 73 220 55 217 Q 53 207 65 205 Z M 99 198 L 114 197 L 115 206 Q 129 209 125 218 Q 107 222 99 215 Z',
      'M 82 80 Q 92 88 101 78',
      64),
  NorieExplorerPose.blink: _Frame(
      'M 65 105 Q 53 107 48 125 L 44 150 Q 50 155 58 151 L 65 132 L 63 166 Q 89 175 116 165 L 113 132 L 123 150 Q 132 153 137 146 L 128 123 Q 123 107 108 105 Z',
      'M 45 148 Q 38 152 41 159 Q 45 164 50 160 L 57 151 Z M 124 148 L 129 160 Q 135 164 139 157 Q 141 152 136 146 Z',
      'M 61 53 Q 61 32 88 32 Q 119 31 120 57 L 119 80 Q 115 100 91 103 Q 67 101 61 82 Z',
      'M 65 164 L 66 200 Q 73 205 83 201 L 89 181 L 97 202 Q 106 205 114 200 L 115 164 Z',
      'M 65 197 L 82 198 L 82 214 Q 73 220 55 217 Q 53 207 65 205 Z M 97 198 L 113 197 L 114 206 Q 128 210 124 219 Q 106 222 97 215 Z',
      'M 81 83 Q 90 91 101 82',
      68),
  NorieExplorerPose.waveOut: _Frame(
      'M 65 104 Q 52 106 46 124 L 42 150 Q 49 155 57 150 L 65 130 L 64 165 Q 90 174 116 163 L 114 124 Q 129 119 139 100 L 148 78 L 135 70 L 124 91 Q 117 103 108 103 Z',
      'M 43 147 Q 36 152 40 160 Q 46 165 52 157 L 57 151 Z M 135 74 L 133 61 Q 129 53 133 51 Q 138 50 140 60 L 141 45 Q 143 40 147 44 L 148 58 L 151 45 Q 154 41 157 46 L 154 60 L 160 51 Q 165 49 165 55 L 159 69 Q 155 78 146 81 Z',
      'M 60 49 Q 62 29 89 29 Q 120 30 121 54 L 119 78 Q 115 99 90 101 Q 65 98 60 78 Z',
      'M 65 162 L 63 200 Q 73 205 82 200 L 89 181 L 101 201 Q 109 205 117 198 L 115 161 Z',
      'M 63 197 L 81 197 L 81 214 Q 71 220 53 216 Q 52 208 63 205 Z M 101 198 L 116 195 L 119 205 Q 133 207 130 216 Q 113 222 102 215 Z',
      'M 80 79 Q 91 98 103 78 Q 92 83 80 79 Z',
      65),
  NorieExplorerPose.waveIn: _Frame(
      'M 65 103 Q 52 106 47 124 L 43 149 Q 49 154 57 150 L 65 130 L 63 164 Q 90 174 116 163 L 113 124 Q 126 122 131 103 L 134 79 L 119 76 L 116 95 Q 114 102 107 102 Z',
      'M 44 147 Q 37 152 41 160 Q 46 164 51 157 L 57 151 Z M 120 79 L 113 67 Q 108 61 112 58 Q 116 56 121 65 L 117 50 Q 118 44 122 47 L 127 61 L 126 46 Q 129 40 132 46 L 133 61 L 137 50 Q 141 46 143 51 L 139 70 Q 137 79 130 82 Z',
      'M 61 50 Q 62 30 89 30 Q 120 31 120 55 L 119 78 Q 115 99 91 101 Q 66 99 61 79 Z',
      'M 65 162 L 65 200 Q 74 205 83 200 L 90 180 L 99 202 Q 109 205 116 199 L 115 161 Z',
      'M 65 197 L 82 197 L 82 214 Q 73 220 55 217 Q 53 207 65 205 Z M 99 198 L 115 196 L 116 205 Q 131 209 127 218 Q 110 222 99 215 Z',
      'M 81 79 Q 92 97 103 78 Q 92 84 81 79 Z',
      65),
  NorieExplorerPose.ready: _Frame(
      'M 65 106 Q 53 108 48 125 L 44 148 Q 50 155 58 150 L 65 133 L 64 166 Q 91 176 117 164 L 115 135 L 121 143 Q 130 147 136 140 L 128 122 Q 122 107 108 106 Z',
      'M 45 147 Q 39 151 42 159 Q 46 164 51 158 L 58 151 Z M 123 140 L 125 149 Q 130 155 136 151 Q 143 145 135 139 Z',
      'M 61 53 Q 61 32 88 32 Q 119 31 120 57 L 119 80 Q 115 100 91 103 Q 67 101 61 82 Z',
      'M 65 164 L 64 201 Q 73 206 82 201 L 89 182 L 99 202 Q 108 206 116 199 L 116 163 Z',
      'M 64 198 L 81 198 L 81 214 Q 72 220 54 217 Q 52 208 64 206 Z M 99 199 L 115 197 L 116 206 Q 130 210 127 219 Q 109 222 99 215 Z',
      'M 82 83 Q 91 91 101 81',
      68),
  NorieExplorerPose.rise: _Frame(
      'M 65 104 Q 52 106 47 124 L 43 149 Q 49 155 57 151 L 65 131 L 64 165 Q 90 175 116 163 L 113 127 Q 128 131 143 116 L 151 102 L 138 94 L 129 106 Q 120 108 108 104 Z',
      'M 44 147 Q 37 152 41 160 Q 46 165 52 157 L 57 151 Z M 138 98 L 136 87 Q 133 81 137 79 Q 141 77 143 87 L 145 75 Q 149 72 151 77 L 150 90 L 155 79 Q 159 77 160 82 L 155 94 L 161 88 Q 166 88 164 94 L 156 103 Q 151 110 145 107 Z',
      'M 61 50 Q 62 30 89 30 Q 120 30 120 55 L 119 78 Q 115 99 91 101 Q 66 99 61 79 Z',
      'M 65 162 L 64 200 Q 73 205 83 201 L 89 181 L 100 202 Q 109 205 116 198 L 115 161 Z',
      'M 64 197 L 82 198 L 82 214 Q 72 220 54 217 Q 52 207 64 205 Z M 100 198 L 115 196 L 117 205 Q 131 209 128 218 Q 110 222 100 215 Z',
      'M 81 80 Q 91 92 102 79',
      65),
  NorieExplorerPose.waveMid: _Frame(
      'M 65 103 Q 52 105 46 123 L 42 149 Q 49 155 57 150 L 65 130 L 64 164 Q 90 174 116 163 L 114 125 Q 129 121 136 102 L 142 79 L 128 73 L 120 94 Q 117 102 108 103 Z',
      'M 43 147 Q 36 152 40 160 Q 46 165 52 157 L 57 151 Z M 128 77 L 123 63 Q 119 56 123 54 Q 127 52 131 63 L 129 47 Q 131 42 135 46 L 138 61 L 140 45 Q 143 41 146 46 L 145 62 L 150 50 Q 154 47 156 53 L 150 70 Q 148 80 139 83 Z',
      'M 60 50 Q 62 29 89 29 Q 120 30 121 55 L 119 78 Q 115 99 90 101 Q 65 98 60 79 Z',
      'M 65 162 L 64 200 Q 73 205 82 200 L 90 180 L 100 202 Q 109 206 117 198 L 115 161 Z',
      'M 64 197 L 81 197 L 81 214 Q 72 220 54 216 Q 52 208 64 205 Z M 100 198 L 116 195 L 118 205 Q 132 207 129 217 Q 112 222 101 215 Z',
      'M 80 79 Q 92 98 103 78 Q 92 84 80 79 Z',
      65),
  NorieExplorerPose.settle: _Frame(
      'M 65 104 Q 52 106 47 124 L 43 149 Q 49 155 57 150 L 65 130 L 64 165 Q 90 175 116 163 L 114 132 Q 130 141 143 130 L 147 118 L 133 113 L 129 121 Q 118 117 108 104 Z',
      'M 44 147 Q 37 152 41 160 Q 46 164 52 157 L 57 151 Z M 134 116 L 132 107 Q 130 102 134 101 Q 138 101 139 109 L 143 104 Q 147 101 150 105 L 153 114 Q 153 122 145 126 Z',
      'M 61 51 Q 61 31 88 30 Q 119 29 120 55 L 119 78 Q 116 98 91 102 Q 66 99 61 80 Z',
      'M 65 163 L 66 200 Q 74 205 83 201 L 89 181 L 99 202 Q 107 205 115 199 L 115 162 Z',
      'M 66 197 L 82 198 L 82 214 Q 73 220 55 217 Q 53 207 66 205 Z M 99 198 L 114 197 L 115 206 Q 129 210 125 219 Q 108 222 99 215 Z',
      'M 81 81 Q 91 91 102 80',
      66),
};

// Deliberately tiny path vocabulary for original bundled drawings, not an SVG
// loader. No files, network, async resources or third-party assets are involved.
Path _path(String data) {
  final tokens = RegExp(r'[MLQCZ]|-?\d+(?:\.\d+)?')
      .allMatches(data)
      .map((m) => m[0]!)
      .toList();
  final result = Path();
  var i = 0;
  double n() => double.parse(tokens[i++]);
  while (i < tokens.length) {
    switch (tokens[i++]) {
      case 'M':
        result.moveTo(n(), n());
      case 'L':
        result.lineTo(n(), n());
      case 'Q':
        result.quadraticBezierTo(n(), n(), n(), n());
      case 'C':
        result.cubicTo(n(), n(), n(), n(), n(), n());
      case 'Z':
        result.close();
    }
  }
  return result;
}

class _ExplorerPainter extends CustomPainter {
  const _ExplorerPainter(this.look, this.pose);
  final NorieExplorerAppearance look;
  final NorieExplorerPose pose;
  static const ink = Color(0xFF273653);
  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 180, size.height / 240);
    final f = _frames[pose]!;
    final skin = switch (look.skin) {
      'light' => const Color(0xFFF9D5B5),
      'brown' => const Color(0xFFBA7952),
      'deep' => const Color(0xFF855039),
      _ => const Color(0xFFE8AF7A)
    };
    final coat = switch (look.outfit) {
      'sky' => const Color(0xFF69CFE0),
      'berry' => const Color(0xFFC495E3),
      _ => const Color(0xFFFFCA68)
    };
    const hair = Color(0xFF3A2941);
    void draw(String d, Color color, {double width = 2.3}) {
      final path = _path(d);
      canvas.drawPath(path, Paint()..color = color);
      canvas.drawPath(
          path,
          Paint()
            ..color = ink
            ..style = PaintingStyle.stroke
            ..strokeWidth = width
            ..strokeCap = StrokeCap.round
            ..strokeJoin = StrokeJoin.round);
    }

    void line(String d, Color color, double width) => canvas.drawPath(
        _path(d),
        Paint()
          ..color = color
          ..style = PaintingStyle.stroke
          ..strokeWidth = width
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round);
    canvas.drawOval(const Rect.fromLTWH(42, 218, 96, 11),
        Paint()..color = const Color(0xFF65DBEF).withValues(alpha: .13));
    // Each frame redraws its complete lower and upper silhouette.
    draw(f.legs, const Color(0xFF415878));
    line('M 73 184 L 72 195 M 106 184 L 108 195', const Color(0xFF647B99), 3);
    draw(f.shoes, const Color(0xFFF4F0E8));
    line('M 56 214 Q 68 217 80 212 M 101 213 Q 113 218 125 214', coat, 3);
    draw(f.hands, skin);
    draw(f.coat, coat);
    // A contrasting shirt and hand-inked jacket/hoodie/overall details.
    draw('M 76 105 L 90 111 L 104 105 L 99 130 L 80 130 Z',
        const Color(0xFFF8F2DF),
        width: 1.7);
    if (look.outfit == 'berry') {
      draw(
          'M 72 119 L 78 119 L 80 136 L 101 136 L 104 118 L 110 118 L 111 163 Q 90 170 68 163 Z',
          const Color(0xFF9A73C3),
          width: 1.7);
      draw('M 81 142 L 100 142 L 100 153 Q 90 159 81 153 Z', coat, width: 1.4);
    } else {
      line('M 89 130 L 89 163', ink, 1.5);
      if (look.outfit == 'sky') {
        line(
            'M 73 107 Q 68 119 80 125 M 105 107 Q 112 118 100 125 M 75 146 Q 89 141 105 146 L 102 157 L 78 157 Z',
            ink,
            1.5);
      } else {
        draw('M 69 138 L 81 138 L 81 150 Q 74 154 69 150 Z',
            const Color(0xFFEBA948),
            width: 1.3);
        for (final y in [134.0, 146.0, 158.0]) {
          canvas.drawCircle(Offset(93, y), 1.5, Paint()..color = ink);
        }
      }
    }
    draw('M 80 97 L 80 106 Q 90 115 101 105 L 101 96 Z', skin, width: 1.8);
    if (look.hair == 'bob') {
      draw(
          'M 59 46 Q 50 57 54 98 Q 68 109 83 101 L 105 102 Q 126 107 126 92 L 124 47 Z',
          hair);
    }
    draw(f.head, skin);
    // Ears are details in the complete frame, with no articulated transforms.
    draw('M 62 64 Q 53 59 55 73 Q 57 81 63 77 Z', skin, width: 1.6);
    draw('M 119 64 Q 127 60 125 73 Q 124 79 119 77 Z', skin, width: 1.6);
    final hairPath = switch (look.hair) {
      'curls' =>
        'M 61 66 Q 52 59 58 50 Q 51 40 63 36 Q 61 24 75 27 Q 83 17 93 25 Q 106 18 113 30 Q 128 29 125 44 Q 133 54 120 65 L 113 49 Q 103 56 96 46 Q 85 54 77 46 L 66 59 Z',
      'bob' =>
        'M 60 69 Q 54 48 63 36 Q 76 21 101 28 Q 125 31 123 65 L 115 61 L 109 44 Q 93 56 68 51 L 67 69 Z',
      _ =>
        'M 60 68 Q 52 48 64 36 L 60 30 L 77 31 Q 86 19 107 26 L 105 33 Q 125 32 123 58 L 116 67 L 111 46 Q 95 59 71 50 L 67 66 Z',
    };
    draw(hairPath, hair);
    line(
        look.hair == 'curls'
            ? 'M 66 39 Q 72 32 78 38 M 88 32 Q 95 27 101 34 M 109 39 Q 116 36 119 43'
            : 'M 68 42 Q 83 31 98 35',
        const Color(0xFF65516B),
        3);
    final y = f.eyeY;
    line(
        'M 72 ${y - 9} Q 77 ${y - 12} 82 ${y - 9} M 98 ${y - 9} Q 104 ${y - 12} 108 ${y - 9}',
        hair,
        2.4);
    if (pose == NorieExplorerPose.blink) {
      line('M 73 $y Q 78 ${y + 4} 83 $y M 98 $y Q 103 ${y + 4} 108 $y', ink,
          2.8);
    } else {
      for (final x in [78.0, 103.0]) {
        canvas.drawOval(
            Rect.fromCenter(center: Offset(x, y), width: 6, height: 9),
            Paint()..color = ink);
        canvas.drawCircle(
            Offset(x + 1, y - 2), 1.2, Paint()..color = Colors.white);
      }
    }
    canvas.drawOval(Rect.fromLTWH(67, y + 8, 12, 6),
        Paint()..color = const Color(0xFFD96B6C).withValues(alpha: .36));
    canvas.drawOval(Rect.fromLTWH(103, y + 8, 12, 6),
        Paint()..color = const Color(0xFFD96B6C).withValues(alpha: .36));
    line('M 90 ${y + 3} L 88 ${y + 9} L 92 ${y + 9}',
        ink.withValues(alpha: .55), 1.4);
    if (pose == NorieExplorerPose.waveOut ||
        pose == NorieExplorerPose.waveIn ||
        pose == NorieExplorerPose.waveMid) {
      draw(f.smile, const Color(0xFF753E4E), width: 1.8);
      line('M 86 86 Q 92 88 97 85', const Color(0xFFF4A1A9), 2);
    } else {
      line(f.smile, ink, 2.3);
    }
    if (look.accessory == 'glasses') {
      line(
          'M 67 ${y - 5} L 86 ${y - 5} L 86 ${y + 6} Q 76 ${y + 12} 69 ${y + 5} Z M 95 ${y - 5} L 114 ${y - 5} L 112 ${y + 6} Q 102 ${y + 12} 95 ${y + 5} Z M 86 $y Q 90 ${y - 3} 95 $y',
          const Color(0xFF326979),
          2.2);
    } else if (look.accessory == 'satchel') {
      line('M 106 109 L 72 153', const Color(0xFF86604C), 6);
      draw('M 59 147 L 81 148 L 84 173 Q 72 182 57 173 Z',
          const Color(0xFFB58152),
          width: 2);
      draw('M 58 148 L 82 148 L 80 158 Q 69 164 59 157 Z',
          const Color(0xFFDAAA70),
          width: 1.5);
      canvas.drawCircle(
          const Offset(71, 158), 2, Paint()..color = const Color(0xFFFFE5A0));
    } else if (look.accessory == 'star') {
      draw(
          'M 107 127 L 110 133 L 117 134 L 112 139 L 113 145 L 107 142 L 101 145 L 102 139 L 97 134 L 104 133 Z',
          const Color(0xFFFFED9F),
          width: 1.4);
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_ExplorerPainter oldDelegate) =>
      pose != oldDelegate.pose ||
      look.skin != oldDelegate.look.skin ||
      look.hair != oldDelegate.look.hair ||
      look.outfit != oldDelegate.look.outfit ||
      look.accessory != oldDelegate.look.accessory;
}
