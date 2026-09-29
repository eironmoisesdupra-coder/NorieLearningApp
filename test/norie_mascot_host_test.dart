import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/app/norie_app.dart';
import 'package:norie_learning/core/mascot/norie_app_context.dart';
import 'package:norie_learning/core/mascot/norie_mascot_host.dart';
import 'package:norie_learning/core/mascot/norie_mascot_scope.dart';
import 'package:norie_learning/features/navigation/presentation/main_shell.dart';

void main() {
  testWidgets('NorieApp installs exactly one app-root mascot host',
      (tester) async {
    await tester.pumpWidget(const NorieApp());

    expect(find.byType(NorieMascotHost), findsOneWidget);
  });

  testWidgets('pushed routes resolve the same mascot controller',
      (tester) async {
    Object? firstController;
    Object? secondController;

    await tester.pumpWidget(
      MaterialApp(
        builder: (context, child) => NorieMascotHost(
          child: child ?? const SizedBox.shrink(),
        ),
        home: Builder(
          builder: (context) {
            firstController = NorieMascotScope.of(context).controller;
            return Scaffold(
              body: TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute<void>(
                      builder: (routeContext) {
                        secondController =
                            NorieMascotScope.of(routeContext).controller;
                        return const Scaffold(body: Text('Second route'));
                      },
                    ),
                  );
                },
                child: const Text('Push'),
              ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.text('Push'));
    await tester.pumpAndSettle();

    expect(firstController, isNotNull);
    expect(identical(firstController, secondController), isTrue);
  });

  testWidgets('changing main tabs updates context without replacing controller',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NorieMascotHost(
          child: const MainShell(),
        ),
      ),
    );
    await tester.pump();

    final mainContext = tester.element(find.byType(MainShell));
    final before = NorieMascotScope.of(mainContext);
    final controller = before.controller;

    expect(before.contextSnapshot.area, NorieAppArea.home);

    await tester.tap(find.text('Learn').last);
    await tester.pumpAndSettle();

    final after = NorieMascotScope.of(
      tester.element(find.byType(MainShell)),
    );

    expect(after.contextSnapshot.area, NorieAppArea.learn);
    expect(identical(controller, after.controller), isTrue);
  });

  testWidgets('hiding mascot never removes the underlying main shell',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NorieMascotHost(
          child: const MainShell(),
        ),
      ),
    );

    final context = tester.element(find.byType(MainShell));
    NorieMascotScope.of(context).controller.hide();
    await tester.pump();

    expect(find.byType(IndexedStack), findsOneWidget);
    expect(find.byType(MainShell), findsOneWidget);
  });

  testWidgets('app lifecycle pauses and resumes mascot ticker safely',
      (tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: NorieMascotHost(
          child: const Scaffold(body: SizedBox.expand()),
        ),
      ),
    );

    final hostContext = tester.element(find.byType(Scaffold));
    final scope = NorieMascotScope.of(hostContext);
    scope.controller.think();
    await tester.pump();

    TickerMode ticker() => tester.widget<TickerMode>(
          find.byKey(const ValueKey('norie-mascot-ticker-mode')),
        );

    expect(ticker().enabled, isTrue);

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.paused);
    await tester.pump();

    expect(ticker().enabled, isFalse);
    expect(scope.controller.state.name, 'thinking');

    tester.binding.handleAppLifecycleStateChanged(AppLifecycleState.resumed);
    await tester.pump();

    expect(ticker().enabled, isTrue);
    expect(scope.controller.state.name, 'thinking');
  });
}
