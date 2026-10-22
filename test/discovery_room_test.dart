import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/discovery/presentation/discovery_room.dart';

void main() {
  void roomTest(
    String description,
    Future<void> Function(WidgetTester) body,
  ) {
    testWidgets(description, (tester) async {
      final semantics = tester.ensureSemantics();
      try {
        await body(tester);
      } finally {
        semantics.dispose();
      }
    });
  }

  Future<void> mount(
    WidgetTester tester,
    ValueChanged<DiscoveryProp> onInspect, {
    bool enabled = true,
    bool active = true,
    double textScale = 1,
    bool outsideInput = false,
  }) =>
      tester.pumpWidget(MaterialApp(
        home: Scaffold(
          body: MediaQuery(
            data: MediaQueryData(textScaler: TextScaler.linear(textScale)),
            child: SingleChildScrollView(
              child: Column(children: [
                DiscoveryRoom(
                  key: const ValueKey('room'),
                  onInspect: onInspect,
                  enabled: enabled,
                  active: active,
                ),
                if (outsideInput) const TextField(),
              ]),
            ),
          ),
        ),
      ));

  Future<String> position(WidgetTester tester) async {
    final positionNode = find.byWidgetPredicate((widget) =>
        widget is Semantics && widget.properties.label == 'Explorer position');
    await tester.ensureVisible(positionNode);
    await tester.pump();
    final data = tester.getSemantics(positionNode).getSemanticsData();
    expect(data.label, 'Explorer position');
    return data.value;
  }

  Future<void> tapControl(WidgetTester tester, String label) async {
    final control = find.bySemanticsLabel(label);
    await tester.ensureVisible(control);
    await tester.tap(control);
    await tester.pump();
  }

  roomTest('each semantic scene prop inspects its own learning object',
      (tester) async {
    final inspected = <DiscoveryProp>[];
    await mount(tester, inspected.add);

    const cases = {
      'Inspect water container': DiscoveryProp.container,
      'Inspect dry tabletop': DiscoveryProp.table,
      'Inspect warm window': DiscoveryProp.window,
      'Inspect experiment bench': DiscoveryProp.bench,
      'Inspect evidence notebook': DiscoveryProp.notebook,
    };
    for (final entry in cases.entries) {
      await tapControl(tester, entry.key);
      expect(inspected.last, entry.value);
    }
    expect(inspected, cases.values.toList());
  });

  roomTest('touch and keyboard move and inspect the same nearest prop',
      (tester) async {
    final inspected = <DiscoveryProp>[];
    await mount(tester, inspected.add);

    await tapControl(tester, 'Move up');
    await tapControl(tester, 'Move left');
    await tapControl(tester, 'Move left');
    final touchPosition = await position(tester);
    await tapControl(tester, 'Inspect nearby prop');
    expect(inspected, [DiscoveryProp.notebook]);

    // Return to the same start without reconstructing the expected result
    // from a production helper.
    await tapControl(tester, 'Move right');
    await tapControl(tester, 'Move right');
    await tapControl(tester, 'Move down');
    expect(await position(tester), 'Column 5, row 6');
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyA);
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowLeft);
    await tester.pump();
    expect(await position(tester), touchPosition);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
    await tester.pump();
    expect(inspected, [DiscoveryProp.notebook, DiscoveryProp.notebook]);
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    expect(inspected.last, DiscoveryProp.notebook);
    expect(inspected.length, 3);
  });

  roomTest('movement stops at room walls and never continues while idle',
      (tester) async {
    await mount(tester, (_) {});
    for (var step = 0; step < 12; step++) {
      await tapControl(tester, 'Move left');
      await tapControl(tester, 'Move up');
    }
    expect(await position(tester), 'Column 1, row 1');
    for (var step = 0; step < 12; step++) {
      await tester.sendKeyEvent(LogicalKeyboardKey.keyD);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyS);
    }
    await tester.pumpAndSettle();
    expect(await position(tester), 'Column 9, row 7');
    expect(tester.binding.transientCallbackCount, 0);
    await tester.pump(const Duration(seconds: 20));
    expect(await position(tester), 'Column 9, row 7');
    expect(tester.binding.transientCallbackCount, 0);
  });

  for (final flag in ['inactive', 'disabled']) {
    roomTest('$flag room rejects touch and keyboard input', (tester) async {
      final inspected = <DiscoveryProp>[];
      await mount(tester, inspected.add);
      final initial = await position(tester);
      await mount(tester, inspected.add,
          active: flag != 'inactive', enabled: flag != 'disabled');
      await tapControl(tester, 'Move right');
      await tapControl(tester, 'Inspect warm window');
      await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
      await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
      await tester.pump();
      expect(await position(tester), initial);
      expect(inspected, isEmpty);

      await mount(tester, inspected.add);
      await tester.pump(const Duration(seconds: 2));
      expect(await position(tester), initial);
      expect(inspected, isEmpty);
    });
  }

  roomTest('focus leaving the room prevents stray movement or inspection',
      (tester) async {
    final inspected = <DiscoveryProp>[];
    await mount(tester, inspected.add, outsideInput: true);
    await tapControl(tester, 'Move right');
    final before = await position(tester);
    await tester.ensureVisible(find.byType(TextField));
    await tester.tap(find.byType(TextField));
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyE);
    await tester.pump(const Duration(seconds: 1));
    expect(await position(tester), before);
    expect(inspected, isEmpty);
  });

  roomTest('all controls remain reachable at 320px and 160 percent text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final inspected = <DiscoveryProp>[];
    await mount(tester, inspected.add, textScale: 1.6);
    for (final label in ['Move up', 'Move down', 'Move left', 'Move right']) {
      await tapControl(tester, label);
      expect(tester.takeException(), isNull);
    }
    await tapControl(tester, 'Inspect nearby prop');
    expect(inspected, hasLength(1));
    await tapControl(tester, 'Inspect warm window');
    expect(inspected.last, DiscoveryProp.window);
    expect(tester.takeException(), isNull);
  });

  roomTest('Enter activates the focused touch control instead of inspecting',
      (tester) async {
    final inspected = <DiscoveryProp>[];
    await mount(tester, inspected.add);
    final moveUp = find.text('Move up');
    await tester.ensureVisible(moveUp);
    Focus.of(tester.element(moveUp)).requestFocus();
    await tester.pump();
    await tester.sendKeyEvent(LogicalKeyboardKey.enter);
    await tester.pump();
    expect(await position(tester), 'Column 5, row 5');
    expect(inspected, isEmpty);
  });

  roomTest('scene keeps a bounded width on large displays', (tester) async {
    tester.view.physicalSize = const Size(1800, 1200);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await mount(tester, (_) {});
    expect(
      tester.getSize(find.byKey(const ValueKey('discovery-room-scene'))).width,
      lessThanOrEqualTo(720),
    );
    expect(tester.takeException(), isNull);
  });
}
