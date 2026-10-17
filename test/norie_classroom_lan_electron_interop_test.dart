import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/data/norie_classroom_store.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_models.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_resolver.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan.dart';

void main() {
  final connectionFile = Platform.environment['NORIE_LAN_CONNECTION_FILE'];
  test(
      'native Dart learner exchanges durable results with packaged Electron teacher',
      () async {
    final info = jsonDecode(await File(connectionFile!).readAsString()) as Map;
    final endpoint = info['endpoint'] as String;
    final code = info['join_code'] as String;
    final session = info['session_id'] as String;
    final badClient = NorieClassroomLanClient();
    addTearDown(badClient.dispose);
    await expectLater(
        badClient.connect(endpoint, code == '111111' ? '222222' : '111111'),
        throwsStateError);
    final client = NorieClassroomLanClient();
    addTearDown(client.dispose);
    await client.connect(endpoint, code, expectedSessionId: session);
    final summaries = await client.fetchAssignments();
    expect(summaries, hasLength(1));
    final assignment = await client.downloadAssignment(summaries.single.id);
    expect(assignment.title, 'LAN discovery practice');
    String? disk;
    final store = NorieClassroomStore(
        read: () async => disk,
        write: (value) async {
          disk = value;
          return true;
        });
    await store.importAssignment(assignment);
    final questions = NorieClassroomResolver.questionsFor(assignment);
    final submission = NorieClassroomSubmission(
        id: 'native-interop-saved-result',
        assignmentId: assignment.id,
        learnerAlias: 'LAN Mina',
        correct: 0,
        total: questions.length,
        responses: {for (final q in questions) q.id: q.correctIndex},
        completedAt: DateTime.now().toUtc(),
        attemptNumber: 1);
    await store.recordSubmission(submission);
    expect((await client.submit(submission)).accepted, isTrue);
    expect((await client.submit(submission)).accepted, isFalse);
    client.disconnect();
    final restartedStore =
        NorieClassroomStore(read: () async => disk, write: (_) async => true);
    await restartedStore.load();
    final reconnected = NorieClassroomLanClient();
    addTearDown(reconnected.dispose);
    await reconnected.connect(endpoint, code, expectedSessionId: session);
    expect(
        (await reconnected.submit(restartedStore.submissions.single)).accepted,
        isFalse);
    expect(restartedStore.submissions, hasLength(1));
    expect(restartedStore.submissions.single.correct, questions.length);
  },
      skip: connectionFile == null
          ? 'Run through desktop/test/classroom-lan-app.cjs with packaged app.'
          : false,
      timeout: const Timeout(Duration(minutes: 2)));
}
