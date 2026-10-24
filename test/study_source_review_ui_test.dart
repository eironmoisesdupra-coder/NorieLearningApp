import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shared_preferences_platform_interface/shared_preferences_platform_interface.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/study/presentation/study_source_accuracy_screen.dart';
import 'package:norie_learning/features/study/presentation/study_set_screen.dart';
import 'package:norie_learning/features/study/presentation/study_quiz_screen.dart';
import 'norie_study_cache_test.dart' show fixture;

class _SourceDisk extends InMemorySharedPreferencesStore {
  _SourceDisk() : super.empty();
  bool full = false;
  @override
  Future<bool> setValue(String type, String key, Object value) async {
    if (full) return false;
    return super.setValue(type, key, value);
  }
}

Future<void> _settle(WidgetTester tester) async {
  for (var i = 0; i < 15; i++) {
    await tester.pump(const Duration(milliseconds: 50));
    await tester
        .runAsync(() => Future<void>.delayed(const Duration(milliseconds: 5)));
  }
  await tester.pump(const Duration(milliseconds: 350));
}

Future<void> _tap(WidgetTester tester, String text) async {
  await tester.scrollUntilVisible(find.text(text), 200,
      scrollable: find.byType(Scrollable).first);
  await tester.ensureVisible(find.text(text));
  await tester.pumpAndSettle();
  await tester.tap(find.text(text));
  await _settle(tester);
}

void main() {
  late _SourceDisk disk;
  setUp(() {
    SharedPreferences.setMockInitialValues({});
    disk = _SourceDisk();
    SharedPreferencesStorePlatform.instance = disk;
  });
  testWidgets(
      'a flagged source card remains flagged after closing and reopening review',
      (tester) async {
    for (var open = 0; open < 2; open++) {
      await tester.pumpWidget(
          MaterialApp(home: StudySourceAccuracyScreen(studySet: fixture())));
      await _settle(tester);
      if (open == 0) await _tap(tester, 'Flag for correction');
      expect(find.textContaining('Flagged:'), findsOneWidget);
      await tester.pumpWidget(const SizedBox.shrink());
      await tester.pumpAndSettle();
    }
  });
  testWidgets(
      'failed source-review storage cannot check a card or enable practice',
      (tester) async {
    await tester.pumpWidget(
        MaterialApp(home: StudySourceAccuracyScreen(studySet: fixture())));
    await _settle(tester);
    disk.full = true;
    expect(
        tester
            .widget<CheckboxListTile>(find.byType(CheckboxListTile))
            .onChanged,
        isNotNull);
    await tester.scrollUntilVisible(find.byType(Checkbox), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.ensureVisible(find.byType(Checkbox));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Checkbox));
    await _settle(tester);
    expect(tester.widget<CheckboxListTile>(find.byType(CheckboxListTile)).value,
        isFalse);
    expect(find.textContaining('Could not save'), findsWidgets);
    expect(
        (await disk.getAll())['flutter.norie.study.local.offline.v1'], isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
  testWidgets(
      'flashcard-only decks have an independent source-comparison entry',
      (tester) async {
    final original = fixture();
    final q = NorieStudyQuestion.fromMap(
        {...original.questions.single.toMap(), 'kind': 'flashcard'});
    final set = NorieStudySet.fromMap(
        {...original.toMap(), 'generation_mode': 'flashcards'},
        questions: [q]);
    await tester.pumpWidget(MaterialApp(home: StudySetScreen(studySet: set)));
    await _settle(tester);
    await _tap(tester, 'Compare answers with source');
    expect(find.text('Source Accuracy Review'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
  testWidgets('native practice bypasses learner source comparison',
      (tester) async {
    final set = NorieStudySet.fromMap({
      ...fixture().toMap(),
      'source_type': 'native',
      'user_id': 'local'
    }, questions: const [
      NorieStudyQuestion(
          id: 'native-five',
          position: 0,
          kind: NorieStudyQuestionKind.identification,
          prompt: 'Calculate: 2 + 3.',
          options: [],
          correctValues: ['5'],
          explanation: '2 + 3 = 5.',
          sourceExcerpt: 'Synthetic fixture',
          difficulty: 'foundation')
    ]);
    await tester.pumpWidget(MaterialApp(home: StudySetScreen(studySet: set)));
    await _settle(tester);
    await _tap(tester, 'Start Practice');
    expect(find.byType(StudyQuizScreen), findsOneWidget);
    expect(find.byType(StudySourceAccuracyScreen), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });

  testWidgets(
      'missing source remains uncheckable on a narrow screen with large text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final original = fixture();
    final q = NorieStudyQuestion.fromMap(
        {...original.questions.single.toMap(), 'source_excerpt': ''});
    final set = NorieStudySet.fromMap(original.toMap(), questions: [q]);
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(
                textScaler: TextScaler.linear(2), disableAnimations: true),
            child: StudySourceAccuracyScreen(studySet: set))));
    await _settle(tester);
    await tester.scrollUntilVisible(find.byType(CheckboxListTile), 200,
        scrollable: find.byType(Scrollable).first);
    expect(
        tester
            .widget<CheckboxListTile>(find.byType(CheckboxListTile))
            .onChanged,
        isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
  testWidgets('empty source review renders without indexing a missing question',
      (tester) async {
    await tester.pumpWidget(MaterialApp(
        home: StudySourceAccuracyScreen(
            studySet: NorieStudySet.fromMap(fixture().toMap()))));
    await _settle(tester);
    expect(tester.takeException(), isNull);
    expect(find.text('No cards to compare.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await tester.pumpAndSettle();
  });
}
