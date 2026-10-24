import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/study/presentation/study_quiz_screen.dart';

class _DelayedAnswerDisk extends InMemorySharedPreferencesStore {
  _DelayedAnswerDisk() : super.empty();
  bool delayAnswer = false;
  Completer<void>? pending;

  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (delayAnswer && key == 'flutter.norie.study.local.offline.v1') {
      delayAnswer = false;
      pending = Completer<void>();
      await pending!.future;
    }
    return super.setValue(type, key, value);
  }
}

Future<void> _drain(WidgetTester tester) async {
  for (var i = 0; i < 20; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
  }
}

void main() {
  testWidgets(
      'leaving a pending native answer preserves recovery without disposed updates or duplicate XP',
      (tester) async {
    SharedPreferences.setMockInitialValues({});
    final disk = _DelayedAnswerDisk();
    SharedPreferencesStorePlatform.instance = disk;
    NorieProgression.instance.resetAsyncQueuesForTesting();
    await NorieProgression.instance.load();
    final set = NorieStudySet(
        id: 'native-leave-during-save',
        title: 'Native recovery fixture',
        sourceType: 'native',
        sourceName: 'Synthetic fixture',
        mode: NorieStudyGenerationMode.identification,
        requestedCount: 1,
        status: 'ready',
        createdAt: DateTime.utc(2026),
        ownerId: 'local',
        questions: const [
          NorieStudyQuestion(
              id: 'five',
              position: 0,
              kind: NorieStudyQuestionKind.identification,
              prompt: 'Calculate: 2 + 3.',
              options: [],
              correctValues: ['5'],
              explanation: '2 + 3 = 5.',
              sourceExcerpt: 'Synthetic fixture',
              difficulty: 'foundation')
        ]);
    await tester.pumpWidget(MaterialApp(home: StudyQuizScreen(studySet: set)));
    await _drain(tester);
    await tester.enterText(find.byType(TextField), '5');
    tester.testTextInput.hide();
    await tester.pump();
    await tester.ensureVisible(find.text('Check Answer'));
    disk.delayAnswer = true;
    await tester.tap(find.text('Check Answer'));
    await _drain(tester);
    expect(disk.pending, isNotNull);
    await tester.pumpWidget(const SizedBox.shrink());
    disk.pending!.complete();
    await _drain(tester);
    expect(tester.takeException(), isNull);
    expect(NorieProgression.instance.totalXp, 0);
    final raw = jsonDecode((await disk
        .getAll())['flutter.norie.study.local.offline.v1']! as String);
    expect(raw['quizSessions'][set.id]['snapshot']['responses'], ['5']);
    for (var reopen = 0; reopen < 2; reopen++) {
      await (await SharedPreferences.getInstance()).reload();
      await tester
          .pumpWidget(MaterialApp(home: StudyQuizScreen(studySet: set)));
      await _drain(tester);
      expect(NorieProgression.instance.totalXp, 5);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });
}
