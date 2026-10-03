import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/science/grade_3_science.dart';
import 'package:norie_learning/features/content/presentation/science_figure_view.dart';
import 'package:norie_learning/features/content/presentation/science_picture.dart';

void main() {
  testWidgets('Grade 3 anatomy and force models retain labels at 244px',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    try {
      const models = {
        'sci-g3-1-anatomy': [
          '1 · Roots: anchor and absorb water',
          '2 · Stem: support and transport',
          '3 · Leaves: make food using light',
          '4 · Flower: helps produce seeds',
          '5 · Fruit: pod containing seeds'
        ],
        'sci-g3-4-forces': [
          '1 · Equal opposite forces: balanced',
          '2 · Stronger right force: unbalanced'
        ],
      };
      for (final entry in models.entries) {
        final figure = grade3ScienceFigures[entry.key]!;
        figure.validate();
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
                  width: 244,
                  child: MediaQuery(
                      data: const MediaQueryData(
                          textScaler: TextScaler.linear(1.3)),
                      child: ScienceFigureView(figure: figure)))),
        ))));
        for (final label in entry.value) {
          expect(find.text(label), findsOneWidget, reason: entry.key);
        }
        expect(
            find.bySemanticsLabel(
                SciencePicture.descriptionFor(figure.picture)),
            findsOneWidget);
        expect(tester.takeException(), isNull, reason: entry.key);
      }
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('force arrows show equality and a stronger rightward force',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
            body: RepaintBoundary(
                key: boundaryKey,
                child: const SciencePicture(picture: 'forces')))));
    await tester.pump();
    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage();
      try {
        final data = await image.toByteData(format: ui.ImageByteFormat.rawRgba);
        final pixels = data!.buffer.asUint8List();
        List<int> pixel(int x, int y) => pixels.sublist(
            (y * image.width + x) * 4, (y * image.width + x) * 4 + 4);
        const arrow = [255, 215, 108, 255];
        // Equal opposing arrows on the top row extend to x70 and x250.
        expect(pixel(80, 64), arrow);
        expect(pixel(240, 64), arrow);
        // The lower left arrow stops at x108; the right extends to x270.
        expect(pixel(118, 159), arrow);
        expect(pixel(250, 159), arrow);
        expect(pixel(80, 159), isNot(arrow));
      } finally {
        image.dispose();
      }
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets('Grade 3 pictures produce an inspectable small-phone gallery',
      (tester) async {
    tester.view.physicalSize = const Size(260, 2000);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
            body: RepaintBoundary(
                key: boundaryKey,
                child: const Padding(
                    padding: EdgeInsets.all(8),
                    child: MediaQuery(
                        data:
                            MediaQueryData(textScaler: TextScaler.linear(1.3)),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              SciencePicture(picture: 'plant-parts'),
                              SizedBox(height: 24),
                              SciencePicture(picture: 'forces'),
                            ])))))));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      try {
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('build/science_grade3_picture_preview.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
      } finally {
        image.dispose();
      }
    });
  });
}
