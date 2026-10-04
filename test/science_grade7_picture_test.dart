import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/presentation/science_grade7_picture.dart';

void main() {
  for (final picture in Grade7SciencePicture.descriptions.keys) {
    testWidgets('$picture labels fit 244px at 1.3 scale with semantics',
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
                  child: Grade7SciencePicture(picture: picture)),
            ),
          ),
        ));
        expect(tester.takeException(), isNull);
        expect(
            find.bySemanticsLabel(Grade7SciencePicture.descriptions[picture]!),
            findsOneWidget);
        final root = find.byKey(ValueKey('science-grade7-$picture'));
        final pictureRect = tester.getRect(root);
        for (final element in find
            .descendant(of: root, matching: find.byType(Text))
            .evaluate()) {
          final labelRect = tester.getRect(find.byElementPredicate(
              (candidate) => identical(candidate, element)));
          expect(labelRect.left, greaterThanOrEqualTo(pictureRect.left));
          expect(labelRect.right, lessThanOrEqualTo(pictureRect.right));
          expect(labelRect.top, greaterThanOrEqualTo(pictureRect.top));
          expect(labelRect.bottom, lessThanOrEqualTo(pictureRect.bottom));
        }
        expect(find.byType(CustomPaint), findsWidgets);
      } finally {
        semantics.dispose();
      }
    });

    testWidgets('$picture produces a separate 260px gallery', (tester) async {
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
                child: Grade7SciencePicture(picture: picture),
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
              File('build/science_grade7_${picture.substring(3)}_preview.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
        } finally {
          image.dispose();
        }
      });
    });
  }

  test('Grade 7 supports exactly five local diagram contracts', () {
    expect(Grade7SciencePicture.descriptions.keys.toSet(), {
      'g7-investigation',
      'g7-microscope',
      'g7-diffusion',
      'g7-motion',
      'g7-earth'
    });
    expect(Grade7SciencePicture.supports('g6-key'), isFalse);
    expect(Grade7SciencePicture.supports('g7-unknown'), isFalse);
  });
}
