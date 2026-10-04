import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/science/science_figure.dart';
import 'package:norie_learning/features/content/data/science/science_lesson_builder.dart';
import 'package:norie_learning/features/content/presentation/science_figure_view.dart';
import 'package:norie_learning/features/content/presentation/science_picture.dart';

void main() {
  testWidgets('shadow on the wall follows rays through both edges of the card',
      (tester) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final boundaryKey = GlobalKey();
    await tester.pumpWidget(MaterialApp(
        home: Scaffold(
      body: RepaintBoundary(
          key: boundaryKey, child: const SciencePicture(picture: 'shadow')),
    )));
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
        // Source (78,112), card x=155 from y=84 to143, wall x=292.
        // Similar triangles put the shadow at y=34.18 through198.16.
        expect(pixel(300, 40), [41, 48, 58, 255]);
        expect(pixel(300, 190), [41, 48, 58, 255]);
        expect(pixel(300, 28), [229, 215, 175, 255]);
        expect(pixel(300, 208), [229, 215, 175, 255]);
      } finally {
        image.dispose();
      }
    });
    expect(tester.takeException(), isNull);
  });

  testWidgets(
      'pictorial diagrams keep meaningful labels and semantics at 244px',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final semantics = tester.ensureSemantics();
    try {
      const expectedLabels = {
        'butterfly': [
          '1 · Egg',
          '2 · Caterpillar',
          '3 · Pupa',
          '4 · Adult butterfly'
        ],
        'bean': [
          '1 · Seed',
          '2 · First root',
          '3 · Seedling',
          '4 · Plant with pods'
        ],
        'habitat': [
          '1 · Food: berries',
          '2 · Water: pond',
          '3 · Shelter: nest',
          '4 · Space: room to move'
        ],
        'shadow': [
          '1 · Torch gives light',
          '2 · Opaque card blocks light',
          '3 · Shadow on the wall'
        ],
        'daynight': [
          '1 · Sun gives light',
          '2 · Day: facing the Sun',
          '3 · Night: facing away',
          '4 · Earth rotates'
        ],
      };
      for (final entry in expectedLabels.entries) {
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: SingleChildScrollView(
          child: Center(
              child: SizedBox(
                  width: 244,
                  child: MediaQuery(
                    data: const MediaQueryData(
                        textScaler: TextScaler.linear(1.3)),
                    child: ScienceFigureView(
                        figure: ScienceFigure(
                            title: 'Model',
                            kind: 'comparison',
                            labels: const ['Observe'],
                            details: const ['Use the picture as evidence.'],
                            picture: entry.key)),
                  ))),
        ))));
        for (final label in entry.value) {
          expect(find.text(label), findsOneWidget, reason: entry.key);
        }
        expect(find.bySemanticsLabel(SciencePicture.descriptionFor(entry.key)),
            findsOneWidget);
        expect(tester.takeException(), isNull, reason: entry.key);
      }
    } finally {
      semantics.dispose();
    }
  });

  testWidgets('pictorial gallery produces an inspectable rendering',
      (tester) async {
    tester.view.physicalSize = const Size(260, 4000);
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
                        SciencePicture(picture: 'butterfly'),
                        SizedBox(height: 24),
                        SciencePicture(picture: 'bean'),
                        SizedBox(height: 24),
                        SciencePicture(picture: 'habitat'),
                        SizedBox(height: 24),
                        SciencePicture(picture: 'shadow'),
                        SizedBox(height: 24),
                        SciencePicture(picture: 'daynight'),
                      ]),
                ),
              )),
        )));
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.runAsync(() async {
      final boundary = boundaryKey.currentContext!.findRenderObject()!
          as RenderRepaintBoundary;
      final image = await boundary.toImage(pixelRatio: 2);
      final bytes = await image.toByteData(format: ui.ImageByteFormat.png);
      final file = File('build/science_picture_preview.png');
      await file.parent.create(recursive: true);
      await file.writeAsBytes(bytes!.buffer.asUint8List());
      image.dispose();
    });
  });

  test(
      'figure validation rejects incomplete and misleading quantitative models',
      () {
    const missingDetail = ScienceFigure(
        title: 'Incomplete comparison',
        kind: 'comparison',
        labels: ['Earth', 'Moon'],
        details: ['A planet']);
    const missingValue = ScienceFigure(
        title: 'Incomplete measurements',
        kind: 'bars',
        labels: ['Plant A', 'Plant B'],
        details: ['Height', 'Height'],
        values: [2],
        unit: 'cm');
    const negativeValue = ScienceFigure(
        title: 'Invalid height',
        kind: 'bars',
        labels: ['Plant A'],
        details: ['Height'],
        values: [-2],
        unit: 'cm');
    const missingState = ScienceFigure(
        title: 'States',
        kind: 'particles',
        labels: ['Solid', 'Liquid'],
        details: ['Fixed', 'Moving']);
    const reversedStates = ScienceFigure(
        title: 'States',
        kind: 'particles',
        labels: ['Gas', 'Liquid', 'Solid'],
        details: ['Apart', 'Close', 'Fixed']);
    expect(missingDetail.validate, throwsArgumentError);
    expect(missingValue.validate, throwsArgumentError);
    expect(negativeValue.validate, throwsArgumentError);
    expect(missingState.validate, throwsArgumentError);
    expect(reversedStates.validate, throwsArgumentError);
  });

  test('assembly rejects incomplete objectives and missing lesson guidance',
      () {
    void build(
        {List<String> objectives = const ['Explain', 'Compare', 'Predict'],
        String minutes = '25 minutes',
        String keyConcept = 'Earth rotates.'}) {
      scienceTopic(
          grade: 'g4',
          order: 5,
          title: 'Earth, Moon & Sun',
          subtitle: 'Sky',
          minutes: minutes,
          objectives: objectives,
          introduction: 'Observe the sky.',
          sections: [scienceSection('Explain', 'Earth rotates.')],
          keyConcept: keyConcept,
          questions: [
            for (var i = 0; i < 23; i++)
              ['Question $i', 'Correct $i', 'A', 'B', 'C', 'Reason', 'Rotation']
          ],
          prerequisiteTopicId: null);
    }

    expect(() => build(objectives: ['One', 'Two']), throwsArgumentError);
    expect(() => build(objectives: ['One', 'Two', '']), throwsArgumentError);
    expect(
        () => build(objectives: ['One', 'Two', 'Three', 'Four', 'Five', 'Six']),
        throwsArgumentError);
    expect(() => build(minutes: ' '), throwsArgumentError);
    expect(() => build(keyConcept: ''), throwsArgumentError);
  });

  test('assembly preserves identity and independent mastery with rotated keys',
      () {
    final topic = scienceTopic(
      grade: 'g4',
      order: 5,
      title: 'Earth, Moon & Sun',
      subtitle: 'Observe the sky',
      minutes: '25–30 minutes',
      objectives: [
        'Explain day and night',
        'Compare Earth and Moon',
        'Model an orbit'
      ],
      introduction: 'Why does daylight change?',
      sections: [
        scienceSection('Explain', 'Earth rotates.'),
        scienceVisual('sky', 'Earth turns.')
      ],
      keyConcept: 'Rotation causes day and night.',
      prerequisiteTopicId: 'science.g4.rocks-minerals',
      questions: [
        for (var i = 0; i < 23; i++)
          [
            'Question $i',
            'Correct $i',
            'Wrong A',
            'Wrong B',
            'Wrong C',
            'Explanation $i',
            'Rotation'
          ]
      ],
    );
    expect(topic.id, 'science.g4.earth-moon-sun');
    expect(topic.category, 'Grade 4');
    expect(topic.prerequisiteTopicId, 'science.g4.rocks-minerals');
    expect(topic.lesson.introduction, contains('25–30 minutes'));
    expect(topic.lesson.sections.first.points, hasLength(3));
    expect(topic.quiz.questions, hasLength(20));
    expect(topic.challenge.rounds, hasLength(3));
    expect(
        topic.quiz.questions.take(7).every((q) => q.difficulty == 'foundation'),
        isTrue);
    expect(
        topic.quiz.questions
            .skip(7)
            .take(7)
            .every((q) => q.difficulty == 'intermediate'),
        isTrue);
    expect(
        topic.quiz.questions.skip(14).every((q) => q.difficulty == 'advanced'),
        isTrue);
    final all = [...topic.quiz.questions, ...topic.challenge.rounds];
    expect(all.map((q) => q.id).toSet(), hasLength(23));
    for (var i = 0; i < all.length; i++) {
      expect(all[i].correctIndex, i % 4);
      expect(all[i].options[all[i].correctIndex], 'Correct $i');
      expect(all[i].explanation, 'Explanation $i');
    }
  });

  testWidgets(
      'all diagram types fit a 244px card with enlarged accessible text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 900);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final kind in [
      'process',
      'cycle',
      'comparison',
      'bars',
      'particles'
    ]) {
      await tester.pumpWidget(MaterialApp(
          home: Scaffold(
              body: SingleChildScrollView(
        child: Center(
            child: SizedBox(
                width: 244,
                child: MediaQuery(
                  data:
                      const MediaQueryData(textScaler: TextScaler.linear(1.3)),
                  child: ScienceFigureView(
                      figure: ScienceFigure(
                    title: 'A meaningful science model',
                    kind: kind,
                    labels: const ['Solid', 'Liquid', 'Gas'],
                    details: const [
                      'Particles vibrate near fixed positions.',
                      'Particles remain close and move past one another.',
                      'Particles move widely apart.'
                    ],
                    values: kind == 'bars' ? const [2, 4, 8] : const [],
                    unit: 'cm',
                    note: 'Models simplify the real system.',
                  )),
                ))),
      ))));
      await tester.pump();
      expect(tester.takeException(), isNull, reason: kind);
      expect(find.text('Solid'), findsOneWidget);
      expect(find.text('Particles move widely apart.'), findsOneWidget);
      if (kind == 'cycle') {
        expect(find.text('Returns to Solid'), findsOneWidget);
      }
    }
  });

  testWidgets(
      'bars use a common zero baseline and display measurements with units',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
            body: SizedBox(
                width: 244,
                child: ScienceFigureView(
                    figure: ScienceFigure(
                        title: 'Plant growth',
                        kind: 'bars',
                        labels: ['Week 1', 'Week 2'],
                        details: ['Measured height', 'Measured height'],
                        values: [2, 8],
                        unit: 'cm'))))));
    expect(find.text('2 cm'), findsOneWidget);
    expect(find.text('8 cm'), findsOneWidget);
    final short =
        tester.getSize(find.byKey(const ValueKey('science-bar-fill-0'))).width;
    final long =
        tester.getSize(find.byKey(const ValueKey('science-bar-fill-1'))).width;
    expect(short / long, closeTo(0.25, 0.001));
    expect(find.text('Scale: 0–8 cm'), findsOneWidget);
  });

  testWidgets(
      'particle arrangements expose their model meaning to assistive technology',
      (tester) async {
    final semantics = tester.ensureSemantics();
    try {
      await tester.pumpWidget(const MaterialApp(
          home: Scaffold(
              body: SingleChildScrollView(
                  child: ScienceFigureView(
        figure: ScienceFigure(
            title: 'Same particles, different states',
            kind: 'particles',
            labels: ['Solid', 'Liquid', 'Gas'],
            details: ['Fixed positions', 'Flowing', 'Widely spaced']),
      )))));
      expect(
          find.bySemanticsLabel(
              'Solid particle model: closely packed in ordered rows.'),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(
              'Liquid particle model: close together with an irregular arrangement.'),
          findsOneWidget);
      expect(
          find.bySemanticsLabel(
              'Gas particle model: widely spaced throughout the container.'),
          findsOneWidget);
      expect(tester.takeException(), isNull);
    } finally {
      semantics.dispose();
    }
  });
}
