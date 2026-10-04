import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/presentation/science_grade5_picture.dart';

void main() {
  for (final picture in Grade5SciencePicture.descriptions.keys) {
    testWidgets('$picture fits 244px at 1.3 text scale with semantics',
        (tester) async {
      tester.view.physicalSize = const Size(244, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(MaterialApp(
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: Scaffold(
                body: SingleChildScrollView(
              child: Grade5SciencePicture(picture: picture),
            )),
          ),
        ));
        expect(tester.takeException(), isNull);
        expect(
            find.bySemanticsLabel(Grade5SciencePicture.descriptions[picture]!),
            findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
        expect(Grade5SciencePicture.supports(picture), isTrue);
        if (picture == 'g5-food-web') {
          for (final organism in [
            'Grass',
            'Rabbit',
            'Grasshopper',
            'Frog',
            'Hawk'
          ]) {
            expect(find.text(organism), findsOneWidget);
          }
        }
      } finally {
        semantics.dispose();
      }
    });
  }

  test('Grade 5 picture support rejects unrelated IDs', () {
    expect(Grade5SciencePicture.supports('g4-body'), isFalse);
    expect(Grade5SciencePicture.supports('g5-unknown'), isFalse);
  });

  testWidgets('Grade 5 models produce an inspectable small-phone gallery',
      (tester) async {
    tester.view.physicalSize = const Size(260, 5000);
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
            data: MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Grade5SciencePicture(picture: 'g5-cells'),
                SizedBox(height: 24),
                Grade5SciencePicture(picture: 'g5-food-web'),
                SizedBox(height: 24),
                Grade5SciencePicture(picture: 'g5-lever'),
                SizedBox(height: 24),
                Grade5SciencePicture(picture: 'g5-water-paths'),
              ],
            ),
          ),
        ),
      )),
    ));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      try {
        final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
        final file = File('build/science_grade5_picture_preview.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
      } finally {
        image.dispose();
      }
    });
  });
}
