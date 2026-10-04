import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/app/norie_app.dart';
import 'package:norie_learning/features/navigation/presentation/main_shell.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  testWidgets('signed-out learners can open lessons without cloud access',
      (tester) async {
    SharedPreferences.setMockInitialValues({
      'norie.tutorial.complete.v2.complete': true,
      'norie.tutorial.home.v1.complete': true,
      'norie.tutorial.learn.v1.complete': true,
      'norie.tutorial.challenge.v1.complete': true,
    });
    await tester.pumpWidget(const NorieApp());

    expect(find.text('Norie Learning'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pump(const Duration(milliseconds: 600));

    expect(find.byType(MainShell), findsOneWidget);
    expect(find.text('Norie Account'), findsNothing);
    await tester.tap(find.text('Learn').last);
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Mathematics'), findsWidgets);
    await tester.tap(find.text('Mathematics').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Grade 1').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    await tester.tap(find.text('Counting to 100').first);
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 600));
    expect(find.text('Counting to 100'), findsWidgets);
    expect(find.text('Norie Account'), findsNothing);
    await tester.pumpWidget(const SizedBox.shrink());
  });
}
