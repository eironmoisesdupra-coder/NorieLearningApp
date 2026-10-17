import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/data/norie_classroom_store.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_models.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_lan_screen.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_runner_screen.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_lan_teacher_screen.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_lan_join_screen.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan_transport.dart';
import 'norie_classroom_store_test.dart' show assignment;

void main() {
  Future<void> phone(WidgetTester tester, Widget child) async {
    tester.view.physicalSize = const Size(320, 800);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    await tester.pumpWidget(MaterialApp(
        builder: (context, child) => MediaQuery(
            data: MediaQuery.of(context)
                .copyWith(textScaler: const TextScaler.linear(1.6)),
            child: child!),
        home: child));
    await tester.pumpAndSettle();
  }

  testWidgets(
      'LAN landing and manual join fit small phones without starting a host',
      (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await phone(tester, NorieClassroomLanScreen(store: store));
    await tester.scrollUntilVisible(find.text('Host a classroom'), 150,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Host a classroom'), findsOneWidget);
    await tester.scrollUntilVisible(find.text('Join a classroom'), 150,
        scrollable: find.byType(Scrollable).first);
    await tester
        .ensureVisible(find.widgetWithText(OutlinedButton, 'Join a classroom'));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Join a classroom'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
        find.text('Enter address and code manually'), 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Enter address and code manually'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Teacher address'), 150,
        scrollable: find.byType(Scrollable).first);
    expect(find.widgetWithText(TextField, 'Teacher address'), findsOneWidget);
    await tester.scrollUntilVisible(
        find.widgetWithText(TextField, 'Join code'), 150,
        scrollable: find.byType(Scrollable).first);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('teacher chooses assignments before sharing them',
      (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await store.importAssignment(assignment());
    await phone(tester, NorieClassroomLanScreen(store: store));
    await tester.scrollUntilVisible(find.text('Host a classroom'), 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Host a classroom'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(find.text('Start local classroom'), 150,
        scrollable: find.byType(Scrollable).first);
    expect(
        tester
            .widget<FilledButton>(
                find.widgetWithText(FilledButton, 'Start local classroom'))
            .onPressed,
        isNull);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'teacher QR comes before manual details and exposes honest counts',
      (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await store.importAssignment(assignment());
    await phone(tester,
        NorieClassroomLanTeacherScreen(store: store, host: _OpenHost()));
    expect(find.textContaining('Join code:'), findsOneWidget);
    expect(find.bySemanticsLabel(RegExp('Classroom join QR code')),
        findsOneWidget);
    expect(find.textContaining('Address:'), findsNothing);
    await tester.scrollUntilVisible(find.text('Active device links: 2'), 150,
        scrollable: find.byType(Scrollable).first);
    expect(find.text('Submitted aliases: 1'), findsOneWidget);
    await tester.scrollUntilVisible(
        find.text('Connection details (manual fallback)'), 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Connection details (manual fallback)'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Address:'), findsOneWidget);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets('bad code recovery retries only after the learner taps retry',
      (tester) async {
    final transport = _BadCode();
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await phone(
        tester,
        NorieClassroomLanJoinScreen(
            store: store,
            client: NorieClassroomLanClient(transport: transport)));
    await tester.scrollUntilVisible(
        find.text('Enter address and code manually'), 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Enter address and code manually'));
    await tester.pumpAndSettle();
    await tester.enterText(find.widgetWithText(TextField, 'Teacher address'),
        'http://127.0.0.1:1234');
    await tester.enterText(
        find.widgetWithText(TextField, 'Join code'), '123456');
    await tester.pumpAndSettle();
    final join = find.widgetWithText(FilledButton, 'Join classroom');
    await tester.scrollUntilVisible(join, 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(join);
    await tester.pumpAndSettle();
    expect(transport.requests, 1);
    expect(find.textContaining('current code'), findsOneWidget);
    await tester.pump(const Duration(seconds: 2));
    expect(transport.requests, 1);
    final retry = find.text('Retry last action');
    await tester.scrollUntilVisible(retry, 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(retry);
    await tester.pumpAndSettle();
    expect(transport.requests, 2);
    expect(store.submissions, isEmpty);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });

  testWidgets(
      'a failed LAN return keeps saved work and can retry the same submission',
      (tester) async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    final a = assignment();
    await store.importAssignment(a);
    var attempts = 0;
    final returnedIds = <String>[];
    await phone(
        tester,
        NorieClassroomRunnerScreen(
            assignment: a,
            store: store,
            returnSubmission: (submission) async {
              attempts++;
              returnedIds.add(submission.id);
              if (attempts == 1) throw StateError('Teacher unavailable');
            }));
    await tester.enterText(find.byType(TextField), 'Mina');
    await tester.scrollUntilVisible(find.text('Finish assignment'), 250,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.byType(OutlinedButton).first);
    await tester.pump();
    await tester.tap(find.text('Finish assignment'));
    await tester.pumpAndSettle();
    expect(store.submissions, hasLength(1));
    await tester.scrollUntilVisible(find.text('Return to teacher'), 150,
        scrollable: find.byType(Scrollable).first);
    await tester.tap(find.text('Return to teacher'));
    await tester.pumpAndSettle();
    expect(find.textContaining('Saved on this device'), findsOneWidget);
    expect(store.submissions, hasLength(1));
    await tester.tap(find.text('Return to teacher'));
    await tester.pumpAndSettle();
    expect(find.text('Received by teacher'), findsOneWidget);
    expect(returnedIds,
        [store.submissions.single.id, store.submissions.single.id]);
    expect(tester.takeException(), isNull);
    await tester.pumpWidget(const SizedBox());
  });
}

class _OpenHost extends NorieClassroomLanHost {
  NorieLanSessionInfo? info = NorieLanSessionInfo(
      sessionId: 'session',
      joinCode: '123456',
      host: '192.168.1.2',
      port: 1234,
      startedAt: DateTime.utc(2026, 10, 17));
  @override
  NorieLanSessionInfo? get session => info;
  @override
  int get activeLinks => 2;
  @override
  List<NorieLanPeer> get peers => [
        NorieLanPeer(
            alias: 'Mina', lastSeen: DateTime.utc(2026), submissions: 1)
      ];
  @override
  List<NorieClassroomAssignment> get sharedAssignments => [assignment()];
  @override
  Future<void> stop() async {
    info = null;
  }
}

class _BadCode implements NorieLanTransport {
  int requests = 0;
  @override
  bool get supported => true;
  @override
  Future<NorieLanResponse> request(
      {required String endpoint,
      required String joinCode,
      required String? sessionId,
      required String method,
      required String path,
      required String body}) async {
    requests++;
    return const NorieLanResponse(401, '{}');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
