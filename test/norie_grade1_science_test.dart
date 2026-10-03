import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/presentation/norie_grade1_science_visual.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_practice_mode_screen.dart';

void main() {
  test('materials completes the same Grade 1 progression with approved scope',
      () {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').last;
    expect(topic.id, 'science.g1.materials-around-us');
    expect(topic.prerequisiteTopicId, 'science.g1.weather');
    expect(topic.order, 5);
    expect(topic.gradeLevel, 'g1');
    expect(topic.title, 'Materials Around Us 🪵🧱');
    expect(topic.lesson.introduction, contains('20–25 minutes'));
    final titles = topic.lesson.sections.map((s) => s.title).toList();
    for (var section = 1; section <= 21; section++) {
      expect(
          titles.any((title) => title.startsWith('SECTION $section —')), isTrue,
          reason: 'Missing approved section $section');
    }
    expect(
        topic.lesson.sections
            .where((s) => s.visualType != null)
            .map((s) => s.visualType)
            .toSet(),
        {for (var i = 1; i <= 8; i++) 'science-5-$i'});
    final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
    expect(questions.map((q) => q.id).toSet(), hasLength(23));
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
    for (final question in questions) {
      expect(question.options.toSet(), hasLength(4));
      expect(question.explanation, isNotEmpty);
    }
  });

  testWidgets('materials practice offers only multiple choice', (tester) async {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').last;
    await tester
        .pumpWidget(MaterialApp(home: NoriePracticeModeScreen(topic: topic)));
    expect(find.text('Multiple Choice'), findsOneWidget);
    expect(find.text('Identification'), findsNothing);
    expect(find.text('Fill in the Blank'), findsNothing);
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets(
      'material sorting supports correction, reveal, completion and retry',
      (tester) async {
    await tester.pumpWidget(const MaterialApp(
        home: Scaffold(
      body: SingleChildScrollView(
          child: NorieGrade1ScienceVisual(type: 'science-5-8')),
    )));
    expect(find.text('Wooden table'), findsOneWidget);
    await tester.tap(find.widgetWithText(ChoiceChip, 'Glass'));
    await tester.pump();
    expect(find.textContaining('Try another material.'), findsOneWidget);
    expect(find.text('Next object'), findsNothing);
    await tester.tap(find.text('Reveal material'));
    await tester.pump();
    expect(find.textContaining('Wooden table → Wood.'), findsOneWidget);
    await tester.tap(find.text('Next object'));
    await tester.pump();
    for (final material in ['Metal', 'Glass', 'Paper', 'Fabric', 'Rubber']) {
      await tester.tap(find.widgetWithText(ChoiceChip, material));
      await tester.pump();
      expect(find.textContaining('Good match!'), findsOneWidget);
      await tester.tap(
          find.text(material == 'Rubber' ? 'Finish sorting' : 'Next object'));
      await tester.pump();
    }
    expect(find.text('You sorted all six objects! 🎉'), findsOneWidget);
    await tester.tap(find.text('Sort again'));
    await tester.pump();
    expect(find.text('Object 1 of 6'), findsOneWidget);
    expect(find.text('Reveal material'), findsOneWidget);
    expect(find.textContaining('Good match!'), findsNothing);
  });

  testWidgets(
      'materials visuals fit inside a narrow lesson card with larger text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 740);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (var visual = 1; visual <= 8; visual++) {
      await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.3)),
          child: child!,
        ),
        home: Scaffold(
            body: SingleChildScrollView(
                child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 38),
          child: NorieGrade1ScienceVisual(type: 'science-5-$visual'),
        ))),
      ));
      await tester.pump();
      expect(tester.takeException(), isNull,
          reason: 'materials visual $visual');
    }
  });

  testWidgets(
      'materials quick check reveals its explanation after learner action',
      (tester) async {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').last;
    final json = topic.toJson();
    final lesson = Map<String, dynamic>.from(json['lesson'] as Map);
    lesson['sections'] = topic.lesson.sections
        .where((s) => s.reveal)
        .map((s) => s.toJson())
        .toList();
    json['lesson'] = lesson;
    await tester.pumpWidget(MaterialApp(
        home: NorieLessonScreen(topic: NorieTopicContent.fromJson(json))));
    final prompt = find.text('1. WHAT MATERIAL IS A METAL SPOON MADE FROM?');
    await tester.scrollUntilVisible(prompt, 200,
        scrollable: find.byType(Scrollable).first);
    expect(prompt, findsOneWidget);
    const answer =
        'Answer:\nMetal 🔩\n\nWhy?\nMetal is hard and strong, making it useful for many utensils.';
    expect(find.text(answer), findsNothing);
    await tester.tap(find.text('Reveal answer').first);
    await tester.pumpAndSettle();
    expect(find.text(answer), findsOneWidget);
  });

  test(
      'illustrations match named subjects and resource arrows teach correct needs',
      () {
    const kinds = {
      '🪑 Chair · nonliving': 'chair',
      '✏️ Pencil · nonliving': 'pencil',
      '🚗 Toy car · nonliving': 'toy car',
      '🌵 Cactus': 'cactus',
      '🐸 Frog: strong legs → jumping': 'frog',
      '🐕 Dog: legs → walking and running': 'dog',
    };
    for (final entry in kinds.entries) {
      final type = entry.key.contains('legs') ? 'science-2-4' : 'science-1-1';
      expect(NorieGrade1ScienceVisual.iconKind(type, entry.key), entry.value);
    }
    expect(
        NorieGrade1ScienceVisual.iconKind(
            'science-3-3', '👀 Sight → red flower'),
        'sight');
    expect(NorieGrade1ScienceVisual.resourceTargets['Food'], ['animal']);
    expect(NorieGrade1ScienceVisual.resourceTargets['Light'], ['plant']);
    expect(
        NorieGrade1ScienceVisual.resourceTargets['Water'], ['plant', 'animal']);
    expect(
        NorieGrade1ScienceVisual.resourceTargets['Air'], ['plant', 'animal']);
  });
  test('every approved learner sentence survives and all diagrams are offline',
      () {
    final topics = NorieFoundationCurriculum.topicsFor('Science', 'g1');
    for (var index = 0; index < 5; index++) {
      final source = File('test/fixtures/grade1_science/lesson${index + 1}.txt')
          .readAsStringSync()
          .replaceAll('\r\n', '\n');
      final start = source.indexOf(
          '==================================================\nLEARNING GOALS');
      final end = source.indexOf(
          '==================================================\nVISUAL IMPLEMENTATION REQUIREMENTS');
      final parts =
          source.substring(start, end).split(RegExp(r'=+\n([^\n]+)\n=+\n'));
      // Split without discarding titles using regex matches.
      final content = source.substring(start, end);
      final headings =
          RegExp(r'=+\n([^\n]+)\n=+\n').allMatches(content).toList();
      final topic = topics[index];
      final rendered = topic.lesson.sections
          .where((s) => s.body != null)
          .map((s) => '${s.title}\n${s.body}')
          .join('\n');
      expect(parts, isNotEmpty);
      for (var h = 0; h < headings.length; h++) {
        final match = headings[h];
        if (match.group(1)!.startsWith('VISUAL')) continue;
        final body = content.substring(match.end,
            h + 1 < headings.length ? headings[h + 1].start : content.length);
        for (final line in body
            .split('\n')
            .map((l) => l.trim())
            .where((l) => l.isNotEmpty && !RegExp(r'^-+$').hasMatch(l))) {
          expect(rendered, contains(line), reason: '${topic.id}: $line');
        }
      }
      final visuals = topic.lesson.sections.where((s) => s.visualType != null);
      expect(visuals.length, [4, 8, 7, 9, 8][index]);
      for (final section in visuals) {
        expect(NorieGrade1ScienceVisual.labels.containsKey(section.visualType),
            isTrue);
      }
      final restored = NorieTopicContent.fromJson(topic.toJson());
      expect(restored.lesson.sections.map((s) => s.body),
          topic.lesson.sections.map((s) => s.body));
    }
  });

  testWidgets('all five lessons and labeled diagrams fit a 320px phone',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    for (final topic in NorieFoundationCurriculum.topicsFor('Science', 'g1')) {
      await tester
          .pumpWidget(MaterialApp(home: NorieLessonScreen(topic: topic)));
      await tester.pump();
      expect(tester.takeException(), isNull);
      for (final section
          in topic.lesson.sections.where((s) => s.visualType != null)) {
        await tester.pumpWidget(MaterialApp(
            home: Scaffold(
                body: SingleChildScrollView(
                    child: NorieGrade1ScienceVisual(
                        type: section.visualType!,
                        caption: section.visualCaption ?? '')))));
        await tester.pump();
        expect(tester.takeException(), isNull, reason: section.visualType);
      }
    }
  });

  test('approved Grade 1 science contains real lesson prose and independent MC',
      () {
    final topics = NorieFoundationCurriculum.topicsFor('Science', 'g1');
    for (final topic in topics) {
      expect(topic.lesson.sections.length, greaterThan(15));
      expect(topic.lesson.sections.map((s) => s.title),
          isNot(contains('Understand')));
      expect(topic.quiz.questions, hasLength(20));
      expect(topic.challenge.rounds, hasLength(3));
      final questions = [...topic.quiz.questions, ...topic.challenge.rounds];
      expect(questions.map((q) => q.prompt).toSet(), hasLength(23));
      for (final q in questions) {
        expect(q.hasValidAnswer, isTrue);
        expect(q.options, hasLength(4));
        expect(q.conceptId, isNotNull);
        expect(q.conceptLabel, isNotNull);
      }
    }
  });

  testWidgets('quick check shows its prompt before each answer is revealed',
      (tester) async {
    final topic = NorieFoundationCurriculum.topicsFor('Science', 'g1').first;
    final json = topic.toJson();
    final lesson = Map<String, dynamic>.from(json['lesson'] as Map);
    lesson['sections'] = topic.lesson.sections
        .where((s) => s.reveal)
        .map((s) => s.toJson())
        .toList();
    json['lesson'] = lesson;
    await tester.pumpWidget(MaterialApp(
        home: NorieLessonScreen(topic: NorieTopicContent.fromJson(json))));
    final prompt = find.text('1. DOG 🐕\nLiving or nonliving?');
    await tester.scrollUntilVisible(prompt, 200,
        scrollable: find.byType(Scrollable).first);
    expect(prompt, findsOneWidget);
    const answer =
        'Answer:\nLiving\n\nWhy?\nIt grows, needs resources, responds, and has a life cycle.';
    expect(find.text(answer), findsNothing);
    await tester.tap(find.text('Reveal answer').first);
    await tester.pumpAndSettle();
    expect(find.text(answer), findsOneWidget);
  });
}
