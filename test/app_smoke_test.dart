import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/app/norie_app.dart';

void main() {
  testWidgets('Norie private demo entry loads', (tester) async {
    await tester.pumpWidget(const NorieApp());

    expect(find.text('Norie Learning'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 2000));
    await tester.pumpAndSettle();

    expect(find.text('Norie Account'), findsOneWidget);
    expect(find.text('Sign In'), findsWidgets);
  });
}
