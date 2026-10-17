import 'dart:async';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/data/norie_classroom_store.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_models.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_resolver.dart';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

NorieClassroomAssignment assignment({int attempts = 2}) {
  final t = NorieFoundationCurriculum.topicsFor('Science', 'g1').first;
  return NorieClassroomAssignment(
      id: 'a',
      title: 'Living things',
      subject: 'Science',
      gradeId: 'g1',
      topicIds: [t.id],
      questionIds: [t.quiz.questions.first.id],
      createdAt: DateTime.utc(2026),
      maxAttempts: attempts);
}

NorieClassroomSubmission submission(
    {String id = 's', int attempt = 1, int? response}) {
  final a = assignment();
  final q = NorieClassroomResolver.questionsFor(a).first;
  return NorieClassroomSubmission(
      id: id,
      assignmentId: a.id,
      learnerAlias: 'Mina',
      correct: 0,
      total: 1,
      responses: {q.id: response ?? q.correctIndex},
      completedAt: DateTime.utc(2026),
      attemptNumber: attempt);
}

void main() {
  test('late stale write restores disk and survives restart', () async {
    String? disk;
    var current = true;
    final started = Completer<void>(), release = Completer<void>();
    var writes = 0;
    final store = NorieClassroomStore(
        read: () async => disk,
        write: (value) async {
          if (++writes == 1) {
            started.complete();
            await release.future;
          }
          disk = value;
          return true;
        });
    final pending =
        store.importAssignment(assignment(), stillCurrent: () => current);
    await started.future;
    final rejected = expectLater(pending, throwsStateError);
    current = false;
    release.complete();
    await rejected;
    expect(store.assignments, isEmpty);
    final restarted =
        NorieClassroomStore(read: () async => disk, write: (_) async => true);
    await restarted.load();
    expect(restarted.assignments, isEmpty);
    expect(writes, 2);
  });
  test('owner apply clears immediately and older writes cannot restore it',
      () async {
    String? disk;
    final started = Completer<void>(), release = Completer<void>();
    var writes = 0;
    final store = NorieClassroomStore(
        read: () async => disk,
        write: (value) async {
          if (++writes == 2) {
            started.complete();
            await release.future;
          }
          disk = value;
          return true;
        });
    await store.importAssignment(assignment());
    final pending = store.recordSubmission(submission());
    await started.future;
    final rejected = expectLater(pending, throwsStateError);
    store.applyValidatedState(NorieClassroomStore.emptyState);
    expect(store.assignments, isEmpty);
    release.complete();
    await rejected;
    await store.flush();
    final restarted =
        NorieClassroomStore(read: () async => disk, write: (_) async => true);
    await restarted.load();
    expect(restarted.assignments, isEmpty);
    expect(restarted.submissions, isEmpty);
  });
  test('merge is deterministic and rejects conflicting IDs', () async {
    final a = assignment();
    final b = NorieClassroomAssignment.fromJson({...a.toJson(), 'id': 'b'});
    final left = {
      'version': 1,
      'assignments': [a.toJson()],
      'submissions': []
    };
    final right = {
      'version': 1,
      'assignments': [b.toJson()],
      'submissions': []
    };
    expect(NorieClassroomStore.merge(left, right),
        NorieClassroomStore.merge(right, left));
    expect(
        () => NorieClassroomStore.merge(left, {
              'version': 1,
              'assignments': [
                {...a.toJson(), 'title': 'Conflict'}
              ],
              'submissions': []
            }),
        throwsFormatException);
  });
  test('failed durable writes never publish memory or notifications', () async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => false);
    var notices = 0;
    store.addListener(() => notices++);
    await expectLater(store.importAssignment(assignment()), throwsStateError);
    expect(store.assignments, isEmpty);
    expect(notices, 0);
  });
  test(
      'recomputes imported scores, deduplicates and rejects conflicts and limits',
      () async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await store.importAssignment(assignment(attempts: 1));
    expect(await store.recordSubmission(submission()), isTrue);
    expect(store.submissions.single.correct, 1);
    expect(await store.recordSubmission(submission()), isFalse);
    await expectLater(store.recordSubmission(submission(id: 'conflict')),
        throwsFormatException);
    await expectLater(
        store.recordSubmission(submission(id: 'limit', attempt: 2)),
        throwsFormatException);
    await expectLater(
        store.recordSubmission(submission(id: 'invalid', response: 99)),
        throwsFormatException);
  });
  test(
      'queued operations bind to guard and persistence reload preserves results',
      () async {
    String? persisted;
    final gate = Completer<void>();
    var current = true;
    final store = NorieClassroomStore(
        read: () async => persisted,
        write: (v) async {
          await gate.future;
          persisted = v;
          return true;
        });
    final first = store.importAssignment(assignment());
    final second =
        store.recordSubmission(submission(), stillCurrent: () => current);
    current = false;
    gate.complete();
    await first;
    await expectLater(second, throwsStateError);
    final reload = NorieClassroomStore(
        read: () async => persisted, write: (_) async => true);
    await reload.load();
    expect(reload.assignments.single.id, 'a');
    expect(reload.submissions, isEmpty);
  });
  test('state validation is atomic and rejects dangling submissions', () async {
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await store.importAssignment(assignment());
    final state = store.exportState();
    state['assignments'] = [];
    state['submissions'] = [submission().toJson()];
    expect(
        () => NorieClassroomStore.validatedState(state), throwsFormatException);
    expect(store.assignments.single.id, 'a');
  });
}
