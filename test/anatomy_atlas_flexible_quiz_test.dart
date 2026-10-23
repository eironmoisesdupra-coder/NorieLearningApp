import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/account/norie_learner_identity.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_catalog.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_quiz_policy.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_setup_screen.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_screen.dart';

AnatomyAtlasCatalog fixture({int count = 24, bool ambiguous = false}) =>
    AnatomyAtlasCatalog.fromJson({
      'schemaVersion': 1,
      'references': [
        {'id': 'male', 'label': 'Male', 'description': ''}
      ],
      'structures': [
        for (var i = 0; i < count; i++)
          {
            'id': 's$i',
            'name': 'Structure $i',
            'reference': 'male',
            'systems': ambiguous && i == 0
                ? ['skeletal', 'muscular']
                : ambiguous && i == 1
                    ? ['unknown']
                    : ['skeletal'],
            'asset': 'bones',
            'source': 'test',
          }
      ]
    });

void main() {
  for (final count in [5, 10, 20]) {
    test('$count questions stay unique and award ten XP per correct answer',
        () {
      for (final difficulty in AtlasQuizDifficulty.values) {
        final quiz = AtlasQuizSession.generate(fixture(), 'male', {'skeletal'},
            requestedCount: count, difficulty: difficulty, random: Random(3));
        expect(quiz.questions, hasLength(count));
        expect(
            quiz.questions.map((q) => q.target.name).toSet(), hasLength(count));
        expect(
            quiz.questions.every((q) => q.kind == AtlasQuestionKind.identify),
            isTrue);
        while (!quiz.finished) {
          expect(quiz.answer(quiz.current.answer), isTrue);
          expect(quiz.answer(quiz.current.answer), isNull);
          quiz.next();
        }
        expect(quiz.takeReward(), count * 10);
        expect(quiz.takeReward(), isNull);
      }
    });
  }

  test('difficulty changes option support without changing the answer', () {
    for (final entry in {
      AtlasQuizDifficulty.guided: 2,
      AtlasQuizDifficulty.standard: 4,
      AtlasQuizDifficulty.challenge: 6,
    }.entries) {
      final quiz = AtlasQuizSession.generate(fixture(), 'male', {'skeletal'},
          requestedCount: 5, difficulty: entry.key, random: Random(1));
      expect(quiz.current.options, hasLength(entry.value));
      expect(quiz.current.answer, quiz.current.target.name);
      expect(quiz.current.explanation, contains(quiz.current.answer));
    }
  });

  test('low pools are explicit and never repeated to fill the request', () {
    final quiz = AtlasQuizSession.generate(
        fixture(count: 3), 'male', {'skeletal'},
        requestedCount: 10);
    expect(quiz.questions, hasLength(3));
    expect(quiz.isShortSession, isTrue);
    expect(quiz.requestedCount, 10);
    expect(
        () => AtlasQuizSession.generate(fixture(), 'male', {'skeletal'},
            requestedCount: 7),
        throwsArgumentError);
  });

  test('system answers use unambiguous membership and vetted distractors', () {
    final quiz = AtlasQuizSession.generate(
        fixture(ambiguous: true), 'male', {'skeletal', 'muscular', 'unknown'},
        requestedCount: 5,
        kinds: {AtlasQuestionKind.system},
        random: Random(2));
    for (final q in quiz.questions) {
      expect(q.target.id, isNot(anyOf('s0', 's1')));
      expect(q.kind, AtlasQuestionKind.system);
      expect(q.answer, 'Skeletal');
      expect(q.prompt, contains(q.target.name));
      expect(q.options, contains('Skeletal'));
      expect(q.options.toSet(), hasLength(q.options.length));
      expect(q.explanation, contains('catalog'));
      expect(q.hint, isNot(contains('Skeletal')));
      expect(quiz.answer(q.answer), isTrue);
      quiz.next();
    }
    expect(quiz.takeReward(), 50);
  });

  test('mixed sessions include both selected kinds without repeating names',
      () {
    final quiz = AtlasQuizSession.generate(fixture(), 'male', {'skeletal'},
        requestedCount: 10,
        kinds: {AtlasQuestionKind.identify, AtlasQuestionKind.system},
        random: Random(4));
    expect(quiz.questions.map((q) => q.kind).toSet(),
        {AtlasQuestionKind.identify, AtlasQuestionKind.system});
    expect(quiz.questions.map((q) => q.target.name).toSet(), hasLength(10));
    expect(
        () => AtlasQuizSession.generate(fixture(), 'male', {'skeletal'},
            kinds: {}),
        throwsArgumentError);
  });

  test('changing learner invalidates answers and unclaimed reward', () {
    final identity = NorieLearnerIdentity()..update('A');
    final quiz = AtlasQuizSession.generate(fixture(), 'male', {'skeletal'},
        requestedCount: 5, stillCurrent: identity.capture());
    while (!quiz.finished) {
      quiz.answer(quiz.current.answer);
      quiz.next();
    }
    identity.update('B');
    identity.update('A');
    expect(quiz.takeReward(), isNull);
    final active = AtlasQuizSession.generate(fixture(), 'male', {'skeletal'},
        stillCurrent: identity.capture());
    identity.update('B');
    expect(active.answer(active.current.answer), isNull);
  });

  testWidgets('small phone setup explicitly offers a short session',
      (tester) async {
    tester.view.physicalSize = const Size(320, 568);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context)
              .copyWith(textScaler: const TextScaler.linear(1.6)),
          child: child!),
      home: AnatomyAtlasQuizSetupScreen(
          catalog: fixture(count: 3),
          reference: 'male',
          systems: const {'skeletal'}),
    ));
    final shorter = find.text('Start shorter 3-question quiz');
    await tester.scrollUntilVisible(shorter, 300);
    await tester.tap(shorter);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.byType(AnatomyAtlasQuizScreen), findsOneWidget);
    expect(tester.getSize(find.byType(AnatomyAtlasModelView)).height,
        greaterThan(120));
    await tester.tap(find.byTooltip('Need a hint?'));
    await tester.pump();
    expect(tester.getSize(find.byType(AnatomyAtlasModelView)).height,
        greaterThan(120));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets('setup passes count difficulty and system-only choices to quiz',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: AnatomyAtlasQuizSetupScreen(
            catalog: fixture(),
            reference: 'male',
            systems: const {'skeletal'})));
    final setupScroll = find.byType(Scrollable).first;
    for (final label in [
      '5 questions',
      'Guided',
      'System membership',
      'Identify structures'
    ]) {
      await tester.scrollUntilVisible(find.text(label), 250,
          scrollable: setupScroll);
      await tester.tap(find.text(label));
      await tester.pump();
    }
    await tester.tap(find.text('Start 5-question quiz'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 400));
    expect(find.text('System · 1/5'), findsOneWidget);
    expect(find.byKey(const ValueKey('atlas-quiz-hint')), findsOneWidget);
    expect(find.byType(OutlinedButton), findsNWidgets(2));
    final viewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    viewer.onLoaded!(true);
    await tester.pump();
    await tester.ensureVisible(find.text('Skeletal'));
    await tester.tap(find.text('Skeletal'));
    await tester.pump();
    await tester.ensureVisible(find.text('Check answer'));
    await tester.tap(find.text('Check answer'));
    await tester.pump();
    expect(find.text('Correct: Skeletal'), findsOneWidget);
    expect(find.textContaining('The atlas catalog lists'), findsOneWidget);
    await tester.ensureVisible(find.text('Next structure'));
    await tester.tap(find.text('Next structure'));
    await tester.pump();
    final nextPrompt = find.textContaining('listed under in this atlas?');
    expect(nextPrompt, findsOneWidget);
    expect(tester.getBottomLeft(nextPrompt).dy, lessThan(600));
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  test('coarse name matches cannot authorize paid anatomical claims', () {
    for (final name in ['Mandible', 'Right mandible', 'Left mandible']) {
      for (final reference in ['male', 'female']) {
        final part = AtlasStructure.fromJson({
          'id': 'unapproved-$reference-$name',
          'name': name,
          'reference': reference,
          'systems': ['skeletal'],
          'asset': 'bones',
          'source': 'test',
        });
        expect(AtlasQuizQuestion(part, [name, 'Clavicle']).specificHint, isNull,
            reason:
                'A source name is not version-specific editorial approval.');
      }
    }
  });

  test('unmatched catalog part has no paid fact to charge for', () {
    final part = AtlasStructure.fromJson({
      'id': 'unreviewed-part',
      'name': 'Structure without authored facts',
      'reference': 'male',
      'systems': ['skeletal'],
      'asset': 'bones',
      'source': 'test',
    });
    expect(
        AtlasQuizQuestion(
          part,
          const ['Structure without authored facts', 'Other part'],
        ).specificHint,
        isNull);
  });
}
