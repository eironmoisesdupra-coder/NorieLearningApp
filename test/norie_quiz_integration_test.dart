import 'package:norie_learning/features/study/domain/norie_study_models.dart';
import 'package:norie_learning/features/study/presentation/study_results_screen.dart';
import 'package:norie_learning/features/content/application/norie_quiz_adapter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/features/content/application/norie_activity_engine.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/presentation/norie_activity_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_learning_results_screen.dart';
import 'package:norie_learning/features/content/presentation/norie_quiz_screen.dart';

NorieTopicContent shortTopic({String? grade}) {
  final json = NorieContentCatalog.atomicStructure.toJson();
  json['id'] = 'outro-integration';
  json['grade_level'] = grade;
  json['quiz'] = const NorieQuizContent(questions: [
    NorieQuestionContent(
        id: 'p',
        prompt: 'Which particle is positive?',
        options: ['Proton', 'Electron'],
        correctIndex: 0,
        explanation: 'Protons carry positive charge.',
        conceptId: 'charge',
        conceptLabel: 'Particle charge')
  ]).toJson();
  return NorieTopicContent.fromJson(json);
}

Widget app(Widget child) => MaterialApp(
    builder: (context, child) => MediaQuery(
        data: MediaQuery.of(context).copyWith(disableAnimations: true),
        child: child!),
    home: child);

Future<void> flush(WidgetTester tester) async {
  for (var i = 0; i < 6; i++) {
    await tester.pump(const Duration(milliseconds: 100));
  }
}

void main() {
  testWidgets('study details retain missed-item retry and source questions',
      (tester) async {
    final question = NorieStudyQuestion.fromMap({
      'id': 'q',
      'prompt': 'One plus one?',
      'kind': 'single_select',
      'options': ['2', '3'],
      'correct_values': ['2'],
      'explanation': 'Count one more.'
    });
    final studySet = NorieStudySet.fromMap(
        {'id': 'details-study', 'title': 'Numbers'},
        questions: [question]);
    await tester.pumpWidget(app(StudyResultsScreen(
        studySet: studySet,
        attemptId: 'study-details',
        answers: [
          NorieStudyAnswer(question: question, response: '3', correct: false)
        ],
        result: const NorieStudyAttemptResult(
            correct: 0,
            total: 1,
            xpAwarded: 0,
            firstRewardedCompletion: false))));
    await flush(tester);
    await tester.scrollUntilVisible(find.text('View details'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('View details'));
    await flush(tester);
    expect(find.byKey(const ValueKey('quiz-outro')), findsNothing);
    expect(find.byType(StudyResultsScreen), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Retry Missed Items'), 200,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Retry Missed Items'), findsOneWidget);
    await tester.scrollUntilVisible(
        find.text('Ask Norie About This Source'), 150,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Ask Norie About This Source'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await flush(tester);
  });
  testWidgets(
      'view details keeps completed curriculum route without new rewards',
      (tester) async {
    final topic = shortTopic();
    final before = NorieProgression.instance.snapshot.totalXp;
    await tester.pumpWidget(app(NorieLearningResultsScreen(
        topic: topic,
        quizScore: 1,
        challengeScore: 0,
        attemptId: 'details-regression')));
    await flush(tester);
    final awarded = NorieProgression.instance.snapshot.totalXp;
    expect(awarded, greaterThan(before));
    await tester.scrollUntilVisible(find.text('View details'), 200,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('View details'));
    await flush(tester);
    expect(find.byKey(const ValueKey('quiz-outro')), findsNothing);
    expect(find.byType(NorieLearningResultsScreen), findsOneWidget);
    expect(NorieProgression.instance.snapshot.totalXp, awarded);
    await tester.pumpWidget(const SizedBox.shrink());
    await flush(tester);
  });
  test('question history distinguishes ordered answers and option content', () {
    NorieQuestionContent question(List<String> order, List<String> options) =>
        NorieQuestionContent(
            id: 'same',
            prompt: 'Arrange',
            options: options,
            correctIndex: 0,
            explanation: 'Why',
            orderedItems: order);
    final original = question(['a', 'b'], ['yes', 'no']);
    expect(
        norieQuestionSignature(original, 'ordering'),
        isNot(norieQuestionSignature(
            question(['b', 'a'], ['yes', 'no']), 'ordering')));
    expect(
        norieQuestionSignature(original, 'ordering'),
        isNot(norieQuestionSignature(
            question(['a', 'b'], ['yes', 'maybe']), 'ordering')));
  });
  setUp(() => SharedPreferences.setMockInitialValues({}));

  testWidgets('empty curriculum quiz has a safe outro and awards no XP',
      (tester) async {
    final json = shortTopic().toJson();
    json['quiz'] = const NorieQuizContent(questions: []).toJson();
    final before = NorieProgression.instance.snapshot.totalXp;
    await tester.pumpWidget(
        app(NorieQuizScreen(topic: NorieTopicContent.fromJson(json))));
    await flush(tester);
    expect(find.byKey(const ValueKey('quiz-outro')), findsOneWidget);
    expect(find.text('Try Again'), findsNothing);
    expect(NorieProgression.instance.snapshot.totalXp, before);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
    await flush(tester);
  });

  testWidgets('mixed mode stays fixed while the same item rebuilds',
      (tester) async {
    final activity = NorieActivityScreen(
        topic: shortTopic(), requestedMode: NorieActivityMode.mixed);
    await tester.pumpWidget(MaterialApp(
        theme: ThemeData(brightness: Brightness.light), home: activity));
    String currentMode() =>
        (tester.widget<AppBar>(find.byType(AppBar)).title! as Text).data!;
    final initial = currentMode();
    for (var i = 0; i < 12; i++) {
      await tester.pumpWidget(MaterialApp(
          theme: ThemeData(
              brightness: i.isEven ? Brightness.dark : Brightness.light),
          home: activity));
      expect(currentMode(), initial);
    }
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'quiz outro retains submitted mistake before challenge without awarding XP',
      (tester) async {
    final before = NorieProgression.instance.snapshot.totalXp;
    await tester.pumpWidget(app(NorieQuizScreen(topic: shortTopic())));
    await tester.tap(find.text('Electron'));
    await tester.pump();
    await tester.tap(find.text('Check answer'));
    await tester.pump();
    await tester.tap(find.text('Continue to challenge'));
    await flush(tester);
    expect(find.byKey(const ValueKey('quiz-outro')), findsOneWidget);
    expect(NorieProgression.instance.snapshot.totalXp, before);
    await tester.tap(find.text('Review Mistakes'));
    await flush(tester);
    expect(find.text('Your answer: Electron'), findsOneWidget);
    expect(find.text('Correct answer: Proton'), findsOneWidget);
    expect(find.text('Why: Protons carry positive charge.'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
    await flush(tester);
  });

  testWidgets('young learner retry modes remain multiple choice',
      (tester) async {
    await tester.pumpWidget(app(NorieActivityScreen(
        topic: shortTopic(grade: 'g1'),
        requestedMode: NorieActivityMode.identification)));
    expect(find.byType(TextField), findsNothing);
    expect(find.text('Proton'), findsOneWidget);
    expect(find.text('Electron'), findsOneWidget);
    await tester.pumpWidget(const SizedBox.shrink());
  });

  testWidgets(
      'remounting one completed lesson attempt reuses its reward receipt',
      (tester) async {
    final topic = shortTopic();
    final before = NorieProgression.instance.snapshot.totalXp;
    Widget result() => app(NorieLearningResultsScreen(
        topic: topic,
        quizScore: 1,
        challengeScore: 0,
        attemptId: 'receipt-regression'));
    await tester.pumpWidget(result());
    await flush(tester);
    final after = NorieProgression.instance.snapshot.totalXp;
    expect(after, before + topic.quiz.xpPerCorrect + topic.lesson.completionXp);
    await tester.pumpWidget(const SizedBox.shrink());
    await flush(tester);
    await tester.pumpWidget(result());
    await flush(tester);
    expect(NorieProgression.instance.snapshot.totalXp, after);
    await tester.pumpWidget(const SizedBox.shrink());
    await flush(tester);
  });
}
