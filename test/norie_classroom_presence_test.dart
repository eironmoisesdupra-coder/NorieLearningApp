import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/data/norie_classroom_store.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan.dart';
import 'norie_classroom_store_test.dart' as fixtures;

void main() {
  test('anonymous session links expire, leave, and never create submissions',
      () async {
    var now = DateTime.utc(2026, 10, 17);
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    await store.importAssignment(fixtures.assignment());
    final session = NorieLanSessionInfo(
        sessionId: 'session',
        joinCode: '123456',
        host: '127.0.0.1',
        port: 1234,
        startedAt: now);
    final handler = NorieLanProtocolHandler(
        store: store,
        session: session,
        assignments: store.assignments,
        stillCurrent: () => true,
        changed: () {},
        clock: () => now);
    Future<int> presence(String token, bool active,
            {String sessionId = 'session'}) async =>
        (await handler.handle(
                'POST',
                '/v1/presence',
                NorieLanEnvelope(
                        type: 'presence',
                        sessionId: sessionId,
                        payload: {'connection_id': token, 'active': active})
                    .encode()))
            .status;
    const one = '11111111-1111-4111-8111-111111111111';
    const two = '22222222-2222-4222-8222-222222222222';
    expect(await presence(one, true), 200);
    expect(await presence(one, true), 200);
    expect(handler.activeLinks, 1);
    expect(await presence(two, true, sessionId: 'wrong'), 400);
    expect(handler.activeLinks, 1);
    now = now.add(const Duration(seconds: 30));
    expect(await presence(two, true), 200);
    now = now.add(const Duration(seconds: 31));
    expect(handler.activeLinks, 1);
    expect(await presence(two, false), 200);
    expect(handler.activeLinks, 0);
    expect(await presence('account@example.com', true), 400);
    expect(store.submissions, isEmpty);
    expect(handler.peers, isEmpty);
    final hello = await handler.handle('GET', '/v1/hello', '');
    expect(jsonDecode(hello.body)['payload']['capabilities'],
        contains('presence'));
  });

  test('anonymous presence has a bounded capacity without persisted identities',
      () async {
    final now = DateTime.utc(2026, 10, 17);
    final store =
        NorieClassroomStore(read: () async => null, write: (_) async => true);
    final handler = NorieLanProtocolHandler(
        store: store,
        session: NorieLanSessionInfo(
            sessionId: 'session',
            joinCode: '123456',
            host: '127.0.0.1',
            port: 1234,
            startedAt: now),
        assignments: [],
        stillCurrent: () => true,
        changed: () {},
        clock: () => now);
    for (var i = 0; i < 200; i++) {
      await handler.handle(
          'POST',
          '/v1/presence',
          NorieLanEnvelope(type: 'presence', sessionId: 'session', payload: {
            'connection_id':
                '${i.toRadixString(16).padLeft(8, '0')}-1111-4111-8111-111111111111',
            'active': true
          }).encode());
    }
    expect(handler.activeLinks, 128);
    expect(store.exportState()['submissions'], isEmpty);
  });
}
