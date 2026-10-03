import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/presentation/science_grade6_picture.dart';

void main() {
  for (final picture in Grade6SciencePicture.descriptions.keys) {
    testWidgets('$picture fits 244px at 1.3 scale with accessible description',
        (tester) async {
      tester.view.physicalSize = const Size(244, 900);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final semantics = tester.ensureSemantics();
      try {
        await tester.pumpWidget(MaterialApp(
          theme: ThemeData.dark(),
          home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
            child: Scaffold(
                backgroundColor: const Color(0xff101b36),
                body: SingleChildScrollView(
                    child: Grade6SciencePicture(picture: picture))),
          ),
        ));
        expect(tester.takeException(), isNull);
        expect(
            find.bySemanticsLabel(Grade6SciencePicture.descriptions[picture]!),
            findsOneWidget);
        expect(find.byType(CustomPaint), findsWidgets);
        if (picture == 'g6-key') {
          final diagramRect = tester.getRect(
              find.byKey(const ValueKey('science-g6-identification-key')));
          for (final animal in ['Pigeon', 'Frog', 'Ant', 'Earthworm']) {
            expect(find.text(animal), findsOneWidget);
            final labelRect = tester.getRect(find.text(animal));
            expect(labelRect.left, greaterThanOrEqualTo(diagramRect.left));
            expect(labelRect.right, lessThanOrEqualTo(diagramRect.right));
            expect(labelRect.top, greaterThanOrEqualTo(diagramRect.top));
            expect(labelRect.bottom, lessThanOrEqualTo(diagramRect.bottom));
          }
          final captionRect = tester.getRect(find.text(
              'Use only for pigeon, frog, ant and earthworm. Start at step 1; follow one branch, not both.'));
          expect(captionRect.top, greaterThanOrEqualTo(diagramRect.bottom));
        }
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('$picture produces an inspectable 260px gallery',
        (tester) async {
      tester.view.physicalSize = const Size(260, 2000);
      tester.view.devicePixelRatio = 1;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);
      final boundaryKey = GlobalKey();
      await tester.pumpWidget(MaterialApp(
        theme: ThemeData.dark(),
        home: Scaffold(
          backgroundColor: const Color(0xff101b36),
          body: SingleChildScrollView(
              child: RepaintBoundary(
            key: boundaryKey,
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: MediaQuery(
                data: const MediaQueryData(textScaler: TextScaler.linear(1.3)),
                child: Grade6SciencePicture(picture: picture),
              ),
            ),
          )),
        ),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull);
      await tester.runAsync(() async {
        final boundary = boundaryKey.currentContext!.findRenderObject()!
            as RenderRepaintBoundary;
        final image = await boundary.toImage(pixelRatio: 2);
        try {
          final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
          final file =
              File('build/science_grade6_${picture.substring(3)}_preview.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
        } finally {
          image.dispose();
        }
      });
    });
  }

  test('Grade 6 support contains exactly its five authored IDs', () {
    expect(Grade6SciencePicture.descriptions.keys.toSet(),
        {'g6-key', 'g6-circuit', 'g6-branches', 'g6-plates', 'g6-solar'});
    expect(Grade6SciencePicture.supports('g5-cells'), isFalse);
    expect(Grade6SciencePicture.supports('g6-unknown'), isFalse);
  });
}
