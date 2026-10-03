import 'dart:io';
import 'dart:ui' as ui;
import 'package:flutter/rendering.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/presentation/science_grade4_picture.dart';

void main() {
  for (final picture in Grade4SciencePicture.descriptions.keys) {
    testWidgets('$picture is accessible and fits a small phone at 1.3 scale',
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
                  child: Grade4SciencePicture(picture: picture))),
        )));
        expect(tester.takeException(), isNull);
        expect(
            find.bySemanticsLabel(Grade4SciencePicture.descriptions[picture]!),
            findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
        expect(Grade4SciencePicture.supports(picture), isTrue);
      } finally {
        semantics.dispose();
      }
    });
  }

  test('picture support rejects IDs outside this module', () {
    expect(Grade4SciencePicture.supports('plant-parts'), isFalse);
    expect(Grade4SciencePicture.supports('g4-unknown'), isFalse);
  });

  testWidgets('Grade 4 pictures produce an inspectable small-phone gallery',
      (tester) async {
    tester.view.physicalSize = const Size(260, 3000);
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
                Grade4SciencePicture(picture: 'g4-body'),
                SizedBox(height: 24),
                Grade4SciencePicture(picture: 'g4-rock'),
                SizedBox(height: 24),
                Grade4SciencePicture(picture: 'g4-moon'),
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
        final file = File('build/science_grade4_picture_preview.png');
        await file.parent.create(recursive: true);
        await file.writeAsBytes(bytes!.buffer.asUint8List());
      } finally {
        image.dispose();
      }
    });
  });
}
