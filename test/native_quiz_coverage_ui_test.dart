import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:norie_learning/features/study/data/quiz_generation/native_quiz_provider.dart';
import 'package:norie_learning/features/study/presentation/native_quiz_generator_screen.dart';
import 'hybrid_quiz_generation_test.dart' show request;
import 'norie_study_cache_test.dart' show fixture;

void main() {
  testWidgets(
      'exhausted coverage requires explicit consent before repeat practice',
      (tester) async {
    final identities = NativeQuizProvider()
        .candidates(request())
        .map((q) => {'identity': q.identity})
        .toList();
    SharedPreferences.setMockInitialValues({
      'norie.study.local.offline.v1': jsonEncode({
        'sets': {
          'history': {
            ...fixture().toMap(),
            'id': 'history',
            'source_type': 'native',
            'generation_metadata': {'questions': identities}
          }
        },
        'rewarded': ['history']
      })
    });
    await tester
        .pumpWidget(const MaterialApp(home: NativeQuizGeneratorScreen()));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Generate Native Quiz'), 300);
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Generate Native Quiz'))
            .onPressed,
        isNull);
    final repeat = find.text('Allow previously completed exercises');
    await tester.scrollUntilVisible(repeat, -250);
    await tester.pumpAndSettle();
    await tester.tap(repeat);
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Generate Native Quiz'), 250);
    await tester.pumpAndSettle();
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Generate Native Quiz'))
            .onPressed,
        isNotNull);
  });
}
