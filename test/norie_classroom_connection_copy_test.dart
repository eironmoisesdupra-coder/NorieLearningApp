import 'package:flutter_test/flutter_test.dart';
import 'dart:async';
import 'dart:convert';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_connection_copy.dart';
import 'package:norie_learning/features/classroom/presentation/norie_classroom_lan_messages.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan_transport.dart';

void main() {
  test('connection recovery is actionable without asserting an unknown cause',
      () {
    for (final issue in NorieClassroomConnectionIssue.values) {
      expect(NorieClassroomConnectionCopy.message(issue).trim(), isNotEmpty);
    }
    expect(
        norieClassroomLanMessage(
            NorieLanConnectionException(NorieLanFailure.unreachable)),
        contains('same trusted Wi-Fi'));
    expect(
        norieClassroomLanMessage(NorieLanConnectionException(
            NorieLanFailure.unauthorized,
            status: 401)),
        contains('current code'));
    expect(
        norieClassroomLanMessage(NorieLanConnectionException(
            NorieLanFailure.throttled,
            status: 429)),
        contains('Wait a minute'));
    expect(
        norieClassroomLanMessage(
            NorieLanConnectionException(NorieLanFailure.busy, status: 503)),
        contains('saved work'));
    expect(norieClassroomLanMessage(StateError('Learner changed.')),
        'Learner changed.');
    expect(norieClassroomLanMessage(Exception('private address or raw error')),
        isNot(contains('private address or raw error')));
  });
  test('actual client exposes typed status while preserving compatibility',
      () async {
    for (final entry in {
      401: NorieLanFailure.unauthorized,
      409: NorieLanFailure.changed,
      429: NorieLanFailure.throttled,
      503: NorieLanFailure.busy,
    }.entries) {
      final client = NorieClassroomLanClient(transport: _Response(entry.key));
      await expectLater(
          client.connect('http://127.0.0.1:1234', '123456'),
          throwsA(isA<NorieLanConnectionException>()
              .having((e) => e.status, 'status', entry.key)
              .having((e) => e.failure, 'failure', entry.value)));
      client.dispose();
    }
  });
  test('malformed peer capabilities never retain a joined session', () async {
    final client =
        NorieClassroomLanClient(transport: _Peer(capabilities: 'presence'));
    addTearDown(client.dispose);
    await expectLater(client.connect('http://127.0.0.1:1234', '123456'),
        throwsFormatException);
    expect(client.session, isNull);
  });
  test('older peer works without presence and disconnect cancels late connect',
      () async {
    final old = _Peer();
    final oldClient = NorieClassroomLanClient(transport: old);
    await oldClient.connect('http://127.0.0.1:1234', '123456');
    expect(old.requests, 1);
    oldClient.dispose();
    final newer = _Peer(capabilities: ['presence'], deferPresence: true);
    final client = NorieClassroomLanClient(transport: newer);
    addTearDown(client.dispose);
    final connected = client.connect('http://127.0.0.1:1234', '123456');
    final rejected = expectLater(connected, throwsStateError);
    await newer.presenceStarted.future;
    client.disconnect();
    newer.releasePresence.complete();
    await rejected;
    expect(client.session, isNull);
  });
}

class _Peer implements NorieLanTransport {
  _Peer({this.capabilities, this.deferPresence = false});
  final Object? capabilities;
  final bool deferPresence;
  final presenceStarted = Completer<void>(),
      releasePresence = Completer<void>();
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
    if (path == '/v1/hello') {
      return NorieLanResponse(
          200,
          NorieLanEnvelope(type: 'hello', sessionId: 'session', payload: {
            ...NorieLanSessionInfo(
                    sessionId: 'session',
                    joinCode: '123456',
                    host: '127.0.0.1',
                    port: 1234,
                    startedAt: DateTime.utc(2026))
                .toJson(),
            if (capabilities != null) 'capabilities': capabilities,
          }).encode());
    }
    final active = jsonDecode(body)['payload']['active'] as bool;
    if (deferPresence && active) {
      presenceStarted.complete();
      await releasePresence.future;
    }
    return NorieLanResponse(
        200,
        NorieLanEnvelope(
            type: 'presence_ack',
            sessionId: 'session',
            payload: {'active': active}).encode());
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class _Response implements NorieLanTransport {
  _Response(this.status);
  final int status;
  @override
  bool get supported => true;
  @override
  Future<NorieLanResponse> request(
          {required String endpoint,
          required String joinCode,
          required String? sessionId,
          required String method,
          required String path,
          required String body}) async =>
      NorieLanResponse(status, '{}');
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
