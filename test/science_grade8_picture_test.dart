import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/presentation/science_grade8_picture.dart';

void main() {
  for (final picture in Grade8SciencePicture.descriptions.keys) {
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
                  child: Grade8SciencePicture(picture: picture)),
            ),
          ),
        ));
        expect(tester.takeException(), isNull);
        expect(
            find.bySemanticsLabel(Grade8SciencePicture.descriptions[picture]!),
            findsOneWidget);
        final root = find.byKey(ValueKey('science-grade8-$picture'));
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
        if (picture == 'g8-inheritance') {
          expect(find.byType(Table), findsOneWidget);
          expect(find.text('AA'), findsOneWidget);
          expect(find.text('Aa'), findsNWidgets(2));
          expect(find.text('aa'), findsOneWidget);
          expect(find.text('Purple'), findsNWidgets(3));
          expect(find.text('White'), findsOneWidget);
        } else {
          expect(find.byType(CustomPaint), findsWidgets);
        }
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
                child: Grade8SciencePicture(picture: picture),
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
              File('build/science_grade8_${picture.substring(3)}_preview.png');
          await file.parent.create(recursive: true);
          await file.writeAsBytes(bytes!.buffer.asUint8List());
        } finally {
          image.dispose();
        }
      });
    });
  }

  test('Grade 8 supports exactly five local diagram contracts', () {
    expect(Grade8SciencePicture.descriptions.keys.toSet(), {
      'g8-inheritance',
      'g8-reaction',
      'g8-work',
      'g8-wave',
      'g8-greenhouse'
    });
    expect(Grade8SciencePicture.supports('g7-motion'), isFalse);
    expect(Grade8SciencePicture.supports('g8-unknown'), isFalse);
  });
}
