import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:async';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/features/learning/data/anatomy_atlas_quiz_store.dart';
import 'package:norie_learning/features/learning/domain/anatomy_atlas_quiz_snapshot.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_model_view.dart';
import 'package:norie_learning/features/learning/presentation/anatomy_atlas_quiz_screen.dart';
import 'anatomy_atlas_flexible_quiz_test.dart' as fixtures;

class InterruptedDisk extends InMemorySharedPreferencesStore {
  InterruptedDisk() : super.empty();
  bool failMastery = false, failAcknowledgement = false;
  bool holdNextAnswer = false;
  Completer<void>? heldAnswer;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (failMastery && key == 'flutter.norie.topicMastery') {
      failMastery = false;
      return false;
    }
    if (holdNextAnswer &&
        key.contains('norie.atlasQuiz.round.') &&
        jsonDecode(value as String)['round']['pending'] != null) {
      holdNextAnswer = false;
      heldAnswer = Completer<void>();
      await heldAnswer!.future;
    }
    if (failAcknowledgement && key.contains('norie.atlasQuiz.round.')) {
      final round = jsonDecode(value as String)['round'];
      if (round['pending'] == null &&
          (round['responses'] as List).any((r) => r != null)) {
        failAcknowledgement = false;
        return false;
      }
    }
    return super.setValue(type, key, value);
  }
}

Future<void> drain(WidgetTester tester) async {
  for (var i = 0; i < 12; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 2)));
  }
}

void main() {
  for (final alreadyCommitted in [false, true]) {
    testWidgets(
        'pending answer reconciles once after interruption (mastery committed=$alreadyCommitted)',
        (tester) async {
      SharedPreferences.setMockInitialValues(
          {'norie.totalXp': 0, 'norie.credits': 0});
      final progress = NorieProgression.instance;
      await tester.runAsync(() async {
        progress.resetAsyncQueuesForTesting();
        await progress.load();
      });
      final catalog = fixtures.fixture();
      final store = AtlasQuizStore(owner: null);
      var round = await store.start(
          catalog,
          AtlasQuizRequest(
              reference: 'male',
              systems: const {'skeletal'},
              requestedCount: 5));
      final quiz = round.session(catalog);
      quiz.answer(quiz.current.answer);
      final lineage = (await tester.runAsync(() =>
          progress.prepareAtlasMastery('Skeletal', stillCurrent: () => true)))!;
      final answered = round.replace(catalog, quiz);
      final pending = AtlasPendingAnswer(0, lineage, answered.answerReceipt(0));
      round = await store.save(
          catalog, answered.replace(catalog, quiz, pending: pending));
      if (alreadyCommitted) {
        await tester.runAsync(() => progress.recordAtlasMastery(
            topic: 'Skeletal',
            lineage: lineage,
            receipt: pending.receipt,
            correct: true,
            stillCurrent: () => true));
      }
      Widget screen() => MaterialApp(
          home: AnatomyAtlasQuizScreen(
              catalog: catalog,
              reference: 'male',
              systems: const {'skeletal'},
              requestedCount: 5));
      for (var open = 0; open < 2; open++) {
        await tester.pumpWidget(screen());
        await drain(tester);
        expect(find.text('Correct: ${quiz.current.answer}'), findsOneWidget);
        expect(
            progress
                .masteryFor(category: 'Anatomy', topic: 'Skeletal')!
                .attempts,
            1);
        expect((await store.read(catalog))!.pending, isNull);
        await tester.pumpWidget(const SizedBox.shrink());
        await drain(tester);
        await tester.runAsync(progress.load);
      }
    });
  }

  for (final count in [5, 10, 20]) {
    testWidgets('completed $count-question outbox reopens without duplicate XP',
        (tester) async {
      SharedPreferences.setMockInitialValues(
          {'norie.totalXp': 0, 'norie.credits': 0});
      final progress = NorieProgression.instance;
      await tester.runAsync(() async {
        progress.resetAsyncQueuesForTesting();
        await progress.load();
      });
      final catalog = fixtures.fixture();
      final store = AtlasQuizStore(owner: null);
      var round = await store.start(
          catalog,
          AtlasQuizRequest(
              reference: 'male',
              systems: const {'skeletal'},
              requestedCount: count));
      final quiz = round.session(catalog);
      final lineage = (await tester.runAsync(() =>
          progress.prepareAtlasMastery('Skeletal', stillCurrent: () => true)))!;
      while (!quiz.finished) {
        quiz.answer(quiz.current.answer);
        final answered = round.replace(catalog, quiz);
        await tester.runAsync(() => progress.recordAtlasMastery(
            topic: 'Skeletal',
            lineage: lineage,
            receipt: answered.answerReceipt(quiz.index),
            correct: true,
            stillCurrent: () => true));
        quiz.next();
      }
      round = await store.save(catalog, round.replace(catalog, quiz));
      // Simulate power loss after the economy commit, before reward acknowledgement.
      await tester.runAsync(() async {
        progress.addXp(count * 10,
            claimKey: 'anatomy-atlas:${round.attemptId}');
        await progress.flushPendingSaves(retry: true);
      });
      for (var open = 0; open < 2; open++) {
        await tester.pumpWidget(MaterialApp(
            home: AnatomyAtlasQuizScreen(
                catalog: catalog,
                reference: 'male',
                systems: const {'skeletal'},
                requestedCount: count)));
        await drain(tester);
        expect(find.text('Atlas quiz complete'), findsOneWidget);
        expect(progress.totalXp, count * 10);
        expect(
            progress
                .masteryFor(category: 'Anatomy', topic: 'Skeletal')!
                .attempts,
            count);
        expect((await store.read(catalog))!.rewardAck, isTrue);
        await tester.pumpWidget(const SizedBox.shrink());
        await drain(tester);
        await tester.runAsync(progress.load);
      }
    });
  }

  testWidgets('reload after failed preparation cannot strand a ready model',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final disk = InterruptedDisk();
    SharedPreferencesStorePlatform.instance = disk;
    final progress = NorieProgression.instance;
    await tester.runAsync(() async {
      progress.resetAsyncQueuesForTesting();
      await progress.load();
    });
    final catalog = fixtures.fixture();
    await tester.pumpWidget(MaterialApp(
        home: AnatomyAtlasQuizScreen(
            catalog: catalog,
            reference: 'male',
            systems: const {'skeletal'},
            requestedCount: 5)));
    await drain(tester);
    final original = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    original.onLoaded!(true);
    await tester.pump();
    final answer =
        catalog.structures.singleWhere((s) => s.id == original.target).name;
    await tester.ensureVisible(find.text(answer));
    await tester.tap(find.text(answer));
    await tester.pump();
    disk.failMastery = true;
    await tester.ensureVisible(find.text('Check answer'));
    await tester.tap(find.text('Check answer'));
    await drain(tester);
    await tester.ensureVisible(find.text('Reload saved round'));
    await tester.tap(find.text('Reload saved round'));
    await drain(tester);
    final replacement = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    if (replacement.key == original.key) {
      expect(
          tester
              .widget<OutlinedButton>(find.byType(OutlinedButton).first)
              .onPressed,
          isNotNull);
    } else {
      original.onLoaded!(true);
      await tester.pump();
      expect(
          tester
              .widget<OutlinedButton>(find.byType(OutlinedButton).first)
              .onPressed,
          isNull);
      replacement.onLoaded!(true);
      await tester.pump();
      expect(
          tester
              .widget<OutlinedButton>(find.byType(OutlinedButton).first)
              .onPressed,
          isNotNull);
    }
    await tester.pumpWidget(const SizedBox.shrink());
    await drain(tester);
  });

  testWidgets('failed answer acknowledgement reopens without replaying mastery',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {'norie.totalXp': 0, 'norie.credits': 0});
    final disk = InterruptedDisk();
    SharedPreferencesStorePlatform.instance = disk;
    final progress = NorieProgression.instance;
    await tester.runAsync(() async {
      progress.resetAsyncQueuesForTesting();
      await progress.load();
    });
    final catalog = fixtures.fixture();
    Widget screen() => MaterialApp(
        home: AnatomyAtlasQuizScreen(
            catalog: catalog,
            reference: 'male',
            systems: const {'skeletal'},
            requestedCount: 5));
    await tester.pumpWidget(screen());
    await drain(tester);
    final viewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    viewer.onLoaded!(true);
    await tester.pump();
    final answer =
        catalog.structures.singleWhere((s) => s.id == viewer.target).name;
    await tester.ensureVisible(find.text(answer));
    await tester.tap(find.text(answer));
    await tester.pump();
    disk.failAcknowledgement = true;
    await tester.ensureVisible(find.text('Check answer'));
    await tester.tap(find.text('Check answer'));
    await drain(tester);
    expect(find.text('Retry saving'), findsOneWidget);
    expect(
        progress.masteryFor(category: 'Anatomy', topic: 'Skeletal')!.attempts,
        1);
    final store = AtlasQuizStore(owner: null);
    expect((await store.read(catalog))!.pending, isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await drain(tester);
    await tester.runAsync(progress.load);
    await tester.pumpWidget(screen());
    await drain(tester);
    expect(find.text('Correct: $answer'), findsOneWidget);
    expect(
        progress.masteryFor(category: 'Anatomy', topic: 'Skeletal')!.attempts,
        1);
    expect((await store.read(catalog))!.pending, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await drain(tester);
  });

  testWidgets(
      'same-owner progress replacement retires active grading callbacks',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {'norie.totalXp': 0, 'norie.credits': 0});
    final progress = NorieProgression.instance;
    await tester.runAsync(() async {
      progress.resetAsyncQueuesForTesting();
      await progress.load();
    });
    final catalog = fixtures.fixture();
    await tester.pumpWidget(MaterialApp(
        home: AnatomyAtlasQuizScreen(
            catalog: catalog,
            reference: 'male',
            systems: const {'skeletal'},
            requestedCount: 5)));
    await drain(tester);
    final viewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    viewer.onLoaded!(true);
    await tester.pump();
    final state = progress.exportCloudState();
    var replaced = false;
    final replacement = progress.importCloudState(state).then((value) {
      replaced = value;
    });
    await drain(tester);
    expect(replaced, isTrue);
    await replacement;
    viewer.onLoaded!(true);
    await tester.pump();
    expect(find.textContaining('saved progress was replaced'), findsOneWidget);
    expect(find.text('Check answer'), findsNothing);
    expect(
        (await AtlasQuizStore(owner: null).read(catalog))!
            .session(catalog)
            .score,
        0);
    await tester.pumpWidget(const SizedBox.shrink());
    await drain(tester);
  });

  testWidgets(
      'leaving during an answer write retains recovery without duplicate taps or disposed updates',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {'norie.totalXp': 0, 'norie.credits': 0});
    final disk = InterruptedDisk();
    SharedPreferencesStorePlatform.instance = disk;
    final progress = NorieProgression.instance;
    await tester.runAsync(() async {
      progress.resetAsyncQueuesForTesting();
      await progress.load();
    });
    final catalog = fixtures.fixture();
    Widget screen() => MaterialApp(
        home: AnatomyAtlasQuizScreen(
            catalog: catalog,
            reference: 'male',
            systems: const {'skeletal'},
            requestedCount: 5));
    await tester.pumpWidget(screen());
    await drain(tester);
    final viewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    viewer.onLoaded!(true);
    await tester.pump();
    final answer =
        catalog.structures.singleWhere((s) => s.id == viewer.target).name;
    await tester.ensureVisible(find.text(answer));
    await tester.tap(find.text(answer));
    await tester.pump();
    disk.holdNextAnswer = true;
    await tester.ensureVisible(find.text('Check answer'));
    await tester.tap(find.text('Check answer'));
    await tester.tap(find.text('Check answer'));
    await drain(tester);
    expect(disk.heldAnswer, isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
    disk.heldAnswer!.complete();
    await drain(tester);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(screen());
    await drain(tester);
    expect(find.text('Correct: $answer'), findsOneWidget);
    expect(
        progress.masteryFor(category: 'Anatomy', topic: 'Skeletal')!.attempts,
        1);
    expect(progress.totalXp, 0);
    expect(progress.credits, 0);
    expect((await AtlasQuizStore(owner: null).read(catalog))!.pending, isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await drain(tester);
  });
  testWidgets('unfinished five-question Atlas round resumes after recreation',
      (tester) async {
    SharedPreferences.setMockInitialValues(
        {'norie.totalXp': 0, 'norie.credits': 0});
    final progress = NorieProgression.instance;
    await tester.runAsync(() async {
      progress.resetAsyncQueuesForTesting();
      await progress.load();
    });
    final catalog = fixtures.fixture();
    Widget screen() => MaterialApp(
        home: AnatomyAtlasQuizScreen(
            catalog: catalog,
            reference: 'male',
            systems: const {'skeletal'},
            requestedCount: 5));
    await tester.pumpWidget(screen());
    await drain(tester);
    final viewer = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView));
    viewer.onLoaded!(true);
    await tester.pump();
    final answer =
        catalog.structures.singleWhere((s) => s.id == viewer.target).name;
    await tester.ensureVisible(find.text(answer));
    await tester.tap(find.text(answer));
    await tester.pump();
    await tester.ensureVisible(find.text('Check answer'));
    await tester.tap(find.text('Check answer'));
    await drain(tester);
    await tester.ensureVisible(find.text('Next structure'));
    await tester.tap(find.text('Next structure'));
    await drain(tester);
    expect(find.text('Identify · 2/5'), findsOneWidget);
    final nextId = tester
        .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
        .target;
    final attempts =
        progress.masteryFor(category: 'Anatomy', topic: 'Skeletal')!.attempts;
    expect(attempts, 1);
    await tester.pumpWidget(const SizedBox.shrink());
    await drain(tester);
    await tester.pumpWidget(screen());
    await drain(tester);
    expect(find.text('Identify · 2/5'), findsOneWidget);
    expect(
        tester
            .widget<AnatomyAtlasModelView>(find.byType(AnatomyAtlasModelView))
            .target,
        nextId);
    expect(
        progress.masteryFor(category: 'Anatomy', topic: 'Skeletal')?.attempts,
        attempts);
    expect(progress.totalXp, 0);
    await tester.pumpWidget(const SizedBox.shrink());
    await drain(tester);
  });
}
