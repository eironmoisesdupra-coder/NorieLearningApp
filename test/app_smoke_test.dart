import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/app/norie_app.dart';

void main() {
  testWidgets('Norie Learning home screen loads', (tester) async {
    await tester.pumpWidget(const NorieApp());
    await tester.pumpAndSettle();

    expect(find.text('Norie Learning'), findsOneWidget);
    expect(find.text('Keep going!'), findsOneWidget);
    expect(find.text('Explore Subjects'), findsOneWidget);
  });
}
