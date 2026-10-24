import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/content/data/authored/core_english_curriculum.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:norie_learning/features/content/presentation/norie_lesson_screen.dart';

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));
  for (final row in [
    ('g1', 2, 'english.g1.nouns', 'dog and ball'),
    ('g7', 0, 'english.g7.sentence-variety', 'Although the path was muddy'),
    (
      'g11',
      2,
      'english.g11.source-evaluation',
      'cannot establish that every pupil'
    ),
  ]) {
    test('${row.$3} keeps rewards and supports independent delayed recall', () {
      final topic = CoreEnglishCurriculum.grades[row.$1]![row.$2];
      expect(topic.id, row.$3);
      expect(topic.lesson.completionXp, 50);
      expect(topic.quiz.questions.map((q) => q.id),
          List.generate(8, (i) => '${row.$3}.q.${i + 1}'));
      expect(topic.challenge.rounds.map((q) => q.id),
          List.generate(3, (i) => '${row.$3}.mastery.${i + 1}'));
      final sections = topic.lesson.sections;
      final transfer = sections
          .singleWhere((s) => s.title == 'Independent transfer — try first');
      final answer = sections
          .singleWhere((s) => s.title == 'Reveal: check your reasoning');
      final review = sections.singleWhere(
          (s) => s.title == 'Return tomorrow — recall without notes');
      expect(transfer.reveal, false);
      expect(answer.reveal, true);
      expect(answer.body, contains(row.$4));
      expect(review.reveal, false);
      expect(sections.indexOf(answer), greaterThan(sections.indexOf(transfer)));
      expect(
          NorieTopicContent.fromJson(topic.toJson())
              .lesson
              .sections
              .singleWhere((s) => s.title == answer.title)
              .reveal,
          true);
    });
  }

  testWidgets(
      'English reasoning stays hidden until a reachable enlarged-text reveal',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final topic = CoreEnglishCurriculum.grades['g7']!.first;
    await tester.pumpWidget(MaterialApp(
      builder: (context, child) => MediaQuery(
          data: MediaQuery.of(context).copyWith(
              textScaler: const TextScaler.linear(1.6),
              disableAnimations: true),
          child: child!),
      home: NorieLessonScreen(topic: topic),
    ));
    await tester.pumpAndSettle();
    final answer = find.textContaining('Although the path was muddy');
    expect(answer, findsNothing);
    final reveal = find.text('Reveal: check your reasoning');
    await tester.scrollUntilVisible(reveal, 240,
        scrollable: find.byType(Scrollable).first, maxScrolls: 100);
    await tester.ensureVisible(reveal);
    await tester.pumpAndSettle();
    final button = find.text('Reveal answer').last;
    await tester.ensureVisible(button);
    await tester.pumpAndSettle();
    await tester.tap(button.hitTestable());
    await tester.pumpAndSettle();
    expect(answer, findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
