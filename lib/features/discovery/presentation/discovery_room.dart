import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/norie_theme.dart';

enum DiscoveryProp { container, table, window, bench, notebook }

/// An event-driven, fixed-camera room. No animation or polling runs while idle.
class DiscoveryRoom extends StatefulWidget {
  const DiscoveryRoom({
    required this.onInspect,
    this.enabled = true,
    this.active = true,
    super.key,
  });

  final ValueChanged<DiscoveryProp> onInspect;
  final bool enabled;
  final bool active;

  @override
  State<DiscoveryRoom> createState() => _DiscoveryRoomState();
}

class _DiscoveryRoomState extends State<DiscoveryRoom>
    with WidgetsBindingObserver {
  final _focus = FocusNode(debugLabel: 'Discovery room');
  var _column = 4;
  var _row = 5;
  var _foreground = true;

  static const _locations = {
    DiscoveryProp.container: Offset(2, 1),
    DiscoveryProp.table: Offset(4, 2),
    DiscoveryProp.window: Offset(7, 1),
    DiscoveryProp.bench: Offset(6, 5),
    DiscoveryProp.notebook: Offset(1, 4),
  };
  static const _names = {
    DiscoveryProp.container: 'water container',
    DiscoveryProp.table: 'dry tabletop',
    DiscoveryProp.window: 'warm window',
    DiscoveryProp.bench: 'experiment bench',
    DiscoveryProp.notebook: 'evidence notebook',
  };

  bool get _canInteract => widget.enabled && widget.active && _foreground;

  DiscoveryProp get _nearest {
    final position = Offset(_column.toDouble(), _row.toDouble());
    return DiscoveryProp.values.reduce((first, second) =>
        (_locations[first]! - position).distanceSquared <=
                (_locations[second]! - position).distanceSquared
            ? first
            : second);
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    final lifecycle = WidgetsBinding.instance.lifecycleState;
    _foreground = lifecycle == null || lifecycle == AppLifecycleState.resumed;
  }

  @override
  void didUpdateWidget(DiscoveryRoom oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!_canInteract) _focus.unfocus();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (!mounted) return;
    setState(() => _foreground = state == AppLifecycleState.resumed);
    if (!_foreground) _focus.unfocus();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    _focus.dispose();
    super.dispose();
  }

  void _move(int horizontal, int vertical) {
    if (!_canInteract) return;
    _focus.requestFocus();
    final column = (_column + horizontal).clamp(0, 8).toInt();
    final row = (_row + vertical).clamp(0, 6).toInt();
    if (column == _column && row == _row) return;
    setState(() {
      _column = column;
      _row = row;
    });
  }

  void _inspect(DiscoveryProp prop) {
    if (!_canInteract) return;
    _focus.requestFocus();
    widget.onInspect(prop);
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (!_canInteract || !_focus.hasFocus || event is KeyUpEvent) {
      return KeyEventResult.ignored;
    }
    final key = event.logicalKey;
    // Tab-focused buttons keep their standard Enter activation. The room's
    // nearest-object Enter shortcut applies when the room itself owns focus.
    if (key == LogicalKeyboardKey.enter && !_focus.hasPrimaryFocus) {
      return KeyEventResult.ignored;
    }
    if (key == LogicalKeyboardKey.arrowUp || key == LogicalKeyboardKey.keyW) {
      _move(0, -1);
    } else if (key == LogicalKeyboardKey.arrowDown ||
        key == LogicalKeyboardKey.keyS) {
      _move(0, 1);
    } else if (key == LogicalKeyboardKey.arrowLeft ||
        key == LogicalKeyboardKey.keyA) {
      _move(-1, 0);
    } else if (key == LogicalKeyboardKey.arrowRight ||
        key == LogicalKeyboardKey.keyD) {
      _move(1, 0);
    } else if (key == LogicalKeyboardKey.keyE ||
        key == LogicalKeyboardKey.enter) {
      // Repeating a held inspection key must not submit an answer twice.
      if (event is KeyDownEvent) _inspect(_nearest);
    } else {
      return KeyEventResult.ignored;
    }
    return KeyEventResult.handled;
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 720),
        child: Focus(
          focusNode: _focus,
          autofocus: _canInteract,
          canRequestFocus: _canInteract,
          onKeyEvent: _onKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Padding(
                padding: EdgeInsets.only(bottom: 8),
                child: Text(
                  'Explore the laboratory. Tap an object, or move the Explorer '
                  'and inspect the nearest object.',
                ),
              ),
              Semantics(
                label: 'Laboratory exploration room',
                explicitChildNodes: true,
                child: AspectRatio(
                  aspectRatio: 9 / 7,
                  child: LayoutBuilder(builder: (context, constraints) {
                    final size = constraints.biggest;
                    Offset center(Offset point) => Offset(
                          30 + point.dx / 8 * (size.width - 60),
                          30 + point.dy / 6 * (size.height - 60),
                        );
                    return DecoratedBox(
                      key: const ValueKey('discovery-room-scene'),
                      decoration: BoxDecoration(
                        color: NorieColors.surface,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(color: NorieColors.border, width: 2),
                      ),
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(18),
                        child: Stack(children: [
                          Positioned.fill(
                            child: ExcludeSemantics(
                              child: CustomPaint(
                                painter: _RoomPainter(
                                  explorer: center(Offset(
                                      _column.toDouble(), _row.toDouble())),
                                ),
                              ),
                            ),
                          ),
                          for (final prop in DiscoveryProp.values)
                            Positioned(
                              left: center(_locations[prop]!).dx - 26,
                              top: center(_locations[prop]!).dy - 26,
                              width: 52,
                              height: 52,
                              child: Semantics(
                                label: 'Inspect ${_names[prop]}',
                                button: true,
                                enabled: _canInteract,
                                onTap:
                                    _canInteract ? () => _inspect(prop) : null,
                                excludeSemantics: true,
                                child: Tooltip(
                                  message: 'Inspect ${_names[prop]}',
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _canInteract
                                          ? () => _inspect(prop)
                                          : null,
                                      borderRadius: BorderRadius.circular(10),
                                      child: CustomPaint(
                                          painter: _PropPainter(prop)),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                        ]),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 8),
              Semantics(
                container: true,
                label: 'Explorer position',
                value: 'Column ${_column + 1}, row ${_row + 1}',
                liveRegion: true,
                excludeSemantics: true,
                child: Text(
                    'Explorer: column ${_column + 1}, row ${_row + 1} of 9 × 7.'),
              ),
              Text('Nearest object: ${_names[_nearest]}.'),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                runSpacing: 8,
                alignment: WrapAlignment.center,
                children: [
                  _moveButton('Move up', Icons.arrow_upward, 0, -1),
                  _moveButton('Move down', Icons.arrow_downward, 0, 1),
                  _moveButton('Move left', Icons.arrow_back, -1, 0),
                  _moveButton('Move right', Icons.arrow_forward, 1, 0),
                ],
              ),
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: _canInteract ? () => _inspect(_nearest) : null,
                icon: const Icon(Icons.search),
                label: const Text('Inspect nearby prop'),
              ),
              const SizedBox(height: 8),
              const Text(
                'Keyboard: arrows or W A S D to move; E or Enter to inspect. '
                'Tab moves between controls.',
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _moveButton(String label, IconData icon, int dx, int dy) =>
      OutlinedButton.icon(
        onPressed: _canInteract ? () => _move(dx, dy) : null,
        icon: Icon(icon),
        label: Text(label),
      );
}

/// Original vector room and Explorer, deliberately separate from Norie.
class _RoomPainter extends CustomPainter {
  const _RoomPainter({required this.explorer});
  final Offset explorer;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint();
    canvas.drawRect(Offset.zero & size, paint..color = NorieColors.surface);
    canvas.drawRect(
      Rect.fromLTWH(0, size.height * .2, size.width, size.height * .8),
      paint..color = NorieColors.surfaceElevated,
    );
    paint
      ..color = NorieColors.border
      ..strokeWidth = 1;
    for (var column = 1; column < 9; column++) {
      final x = size.width * column / 9;
      canvas.drawLine(
          Offset(x, size.height * .2), Offset(x, size.height), paint);
    }
    for (var row = 1; row < 7; row++) {
      final y = size.height * (.2 + row * .8 / 7);
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
    // The cap, backpack, jacket and entire body are drawn together.
    canvas.save();
    canvas.translate(explorer.dx, explorer.dy);
    canvas.drawOval(
        const Rect.fromLTWH(-15, 16, 30, 9), paint..color = Colors.black26);
    paint
      ..color = const Color(0xFFEDB76C)
      ..strokeWidth = 6
      ..strokeCap = StrokeCap.round;
    canvas.drawLine(const Offset(-9, -4), const Offset(-13, 7), paint);
    canvas.drawLine(const Offset(9, -4), const Offset(13, 7), paint);
    paint.color = const Color(0xFF0B1228);
    canvas.drawLine(const Offset(-5, 8), const Offset(-6, 19), paint);
    canvas.drawLine(const Offset(5, 8), const Offset(6, 19), paint);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-12, -9, 24, 22), const Radius.circular(6)),
        paint..color = NorieColors.orange);
    canvas.drawRRect(
        RRect.fromRectAndRadius(
            const Rect.fromLTWH(-9, -9, 18, 21), const Radius.circular(5)),
        paint..color = NorieColors.cyan);
    canvas.drawCircle(
        const Offset(0, -16), 10, paint..color = const Color(0xFFF5CA92));
    canvas.drawArc(const Rect.fromLTWH(-11, -27, 22, 20), 3.14, 3.14, true,
        paint..color = NorieColors.orange);
    paint
      ..color = const Color(0xFF172440)
      ..strokeWidth = 2;
    canvas.drawCircle(const Offset(-3, -16), 1, paint);
    canvas.drawCircle(const Offset(3, -16), 1, paint);
    canvas.drawLine(const Offset(-2, -11), const Offset(2, -11), paint);
    canvas.restore();
  }

  @override
  bool shouldRepaint(_RoomPainter oldDelegate) =>
      oldDelegate.explorer != explorer;
}

class _PropPainter extends CustomPainter {
  const _PropPainter(this.prop);
  final DiscoveryProp prop;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(size.width / 52, size.height / 52);
    final paint = Paint();
    canvas.drawRRect(
      RRect.fromRectAndRadius(
          const Rect.fromLTWH(1, 1, 50, 50), const Radius.circular(10)),
      paint..color = const Color(0xFF243655),
    );
    switch (prop) {
      case DiscoveryProp.container:
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                const Rect.fromLTWH(13, 9, 26, 35), const Radius.circular(4)),
            paint..color = const Color(0xFFC4EFF7));
        canvas.drawRect(const Rect.fromLTWH(16, 27, 20, 14),
            paint..color = const Color(0xFF2EA8DC));
        canvas.drawOval(const Rect.fromLTWH(13, 7, 26, 8),
            paint..color = const Color(0xFF5D849A));
      case DiscoveryProp.table:
        paint
          ..color = const Color(0xFFB87D50)
          ..strokeWidth = 5;
        canvas.drawLine(const Offset(12, 25), const Offset(12, 43), paint);
        canvas.drawLine(const Offset(40, 25), const Offset(40, 43), paint);
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                const Rect.fromLTWH(6, 14, 40, 14), const Radius.circular(3)),
            paint..color = const Color(0xFFE6B780));
      case DiscoveryProp.window:
        canvas.drawRect(const Rect.fromLTWH(9, 7, 34, 37),
            paint..color = const Color(0xFFC4EFF7));
        canvas.drawCircle(
            const Offset(33, 17), 7, paint..color = const Color(0xFFFFD66B));
        paint
          ..color = const Color(0xFFF4E7C1)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 3;
        canvas.drawRect(const Rect.fromLTWH(9, 7, 34, 37), paint);
        canvas.drawLine(const Offset(26, 7), const Offset(26, 44), paint);
        canvas.drawLine(const Offset(9, 26), const Offset(43, 26), paint);
      case DiscoveryProp.bench:
        canvas.drawRect(const Rect.fromLTWH(6, 25, 40, 19),
            paint..color = const Color(0xFF7575AF));
        canvas.drawRect(const Rect.fromLTWH(5, 23, 42, 5),
            paint..color = const Color(0xFFCCCDEE));
        canvas.drawOval(const Rect.fromLTWH(9, 15, 15, 8),
            paint..color = const Color(0xFF88D7F2));
        canvas.drawOval(const Rect.fromLTWH(29, 15, 15, 8),
            paint..color = const Color(0xFFFFD488));
      case DiscoveryProp.notebook:
        canvas.drawRRect(
            RRect.fromRectAndRadius(
                const Rect.fromLTWH(10, 7, 32, 38), const Radius.circular(3)),
            paint..color = const Color(0xFFFFF2CF));
        canvas.drawRect(const Rect.fromLTWH(10, 7, 6, 38),
            paint..color = NorieColors.orange);
        paint
          ..color = const Color(0xFF5B5CE2)
          ..strokeWidth = 2;
        for (final y in [18.0, 25.0, 32.0]) {
          canvas.drawLine(Offset(21, y), Offset(35, y), paint);
        }
    }
    canvas.restore();
  }

  @override
  bool shouldRepaint(_PropPainter oldDelegate) => oldDelegate.prop != prop;
}
