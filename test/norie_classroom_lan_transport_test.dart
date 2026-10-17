import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/classroom/data/norie_classroom_store.dart';
import 'package:norie_learning/features/classroom/domain/norie_classroom_models.dart';
import 'package:norie_learning/features/classroom/lan/norie_classroom_lan.dart';
import 'package:norie_learning/core/sync/norie_economy_store.dart';
import 'package:norie_learning/core/progression/norie_adventure_progress.dart';
import 'norie_classroom_store_test.dart' as fixtures;

void main() {
  Future<(NorieClassroomStore, NorieClassroomLanHost, NorieClassroomLanClient)>
      setup(
          {Future<bool> Function(String)? write,
          bool Function()? guard}) async {
    final store = NorieClassroomStore(
        read: () async => null, write: write ?? (_) async => true);
    await store.importAssignment(fixtures.assignment());
    final host = NorieClassroomLanHost(store: store, stillCurrent: guard);
    addTearDown(host.dispose);
    final session = await host.start(assignments: store.assignments);
    final client = NorieClassroomLanClient();
    addTearDown(client.dispose);
    await client.connect('http://127.0.0.1:${session.port}', session.joinCode,
        expectedSessionId: session.sessionId);
    return (store, host, client);
  }

  test(
      'actual HTTP selected list download durable recomputed ACK retry conflict and stop',
      () async {
    final economy = jsonEncode(NorieEconomyStore.instance.exportState());
    final progress = jsonEncode(NorieAdventureProgress.instance.exportState());
    final (store, host, client) = await setup();
    expect(host.activeLinks, 1);
    expect((await client.fetchAssignments()).single.title, 'Living things');
    expect((await client.downloadAssignment('a')).id, 'a');
    final ack = await client.submit(fixtures.submission());
    expect(ack.accepted, isTrue);
    expect(store.submissions.single.correct, 1);
    expect((await client.submit(fixtures.submission())).accepted, isFalse);
    await expectLater(
        client.submit(fixtures.submission(
            response: store.submissions.single.responses.values.single ^ 1)),
        throwsA(anything));
    expect(store.submissions.length, 1);
    expect(host.peers.single.alias, 'Mina');
    expect(jsonEncode(NorieEconomyStore.instance.exportState()), economy);
    expect(jsonEncode(NorieAdventureProgress.instance.exportState()), progress);
    await host.stop();
    expect(host.session, isNull);
    await expectLater(client.fetchAssignments(), throwsA(anything));
  });
  test(
      'two anonymous device links leave independently without saving identities',
      () async {
    final (store, host, first) = await setup();
    final second = NorieClassroomLanClient();
    addTearDown(second.dispose);
    await second.connect(
        'http://127.0.0.1:${host.session!.port}', host.session!.joinCode);
    expect(host.activeLinks, 2);
    second.disconnect();
    for (var i = 0; i < 50 && host.activeLinks != 1; i++) {
      await Future<void>.delayed(const Duration(milliseconds: 10));
    }
    expect(host.activeLinks, 1);
    expect(store.submissions, isEmpty);
    expect(host.peers, isEmpty);
    await first.refreshPresence();
    expect(host.activeLinks, 1);
  });
  test('ACK waits for disk and failed disk can retry without duplicates',
      () async {
    final gate = Completer<void>(), started = Completer<void>();
    var writes = 0, fail = true;
    final (store, host, client) = await setup(write: (value) async {
      if (++writes == 2) {
        started.complete();
        await gate.future;
        return !fail;
      }
      return true;
    });
    var acknowledged = false;
    final pending = client.submit(fixtures.submission()).then((v) {
      acknowledged = true;
      return v;
    });
    final rejected = expectLater(pending, throwsStateError);
    await started.future;
    expect(acknowledged, isFalse);
    expect(store.submissions, isEmpty);
    gate.complete();
    await rejected;
    fail = false;
    expect((await client.submit(fixtures.submission())).accepted, isTrue);
    expect(store.submissions.length, 1);
  });
  test(
      'encoded IDs download and only explicitly selected frozen assignments share',
      () async {
    final (store, host, client) = await setup();
    final selected = NorieClassroomAssignment.fromJson(
        {...fixtures.assignment().toJson(), 'id': 'room/a ?'});
    await store.importAssignment(selected);
    final session = await host.start(assignments: [selected]);
    await client.connect('http://127.0.0.1:${session.port}', session.joinCode);
    expect((await client.fetchAssignments()).single.id, selected.id);
    expect((await client.downloadAssignment(selected.id)).id, selected.id);
    await expectLater(client.downloadAssignment('a'), throwsStateError);
    await expectLater(client.submit(fixtures.submission()), throwsStateError);
    final joined = NorieLanJoinInfo.parse(session.joinUri().toString());
    expect(joined.sessionId, session.sessionId);
  });
  test('ownership revision notification stops host immediately', () async {
    final (_, host, _) = await setup();
    NorieAdventureProgress.instance
        .applyValidatedState(NorieAdventureProgress.emptyState, persist: false);
    expect(host.session, isNull);
  });
  test('ownership changes during disk write cannot ACK or keep submission',
      () async {
    var current = true, writes = 0;
    final gate = Completer<void>(), started = Completer<void>();
    final (store, host, client) = await setup(
        guard: () => current,
        write: (value) async {
          if (++writes == 2) {
            started.complete();
            await gate.future;
          }
          return true;
        });
    final pending = client.submit(fixtures.submission());
    final rejected = expectLater(pending, throwsA(anything));
    await started.future;
    current = false;
    gate.complete();
    await rejected;
    expect(store.submissions, isEmpty);
    await host.refresh();
    expect(host.session, isNull);
  });
  test(
      'wrong code origin cross session duplicate JSON and streaming bound rejected',
      () async {
    final (_, host, client) = await setup();
    expect((await client.fetchAssignments()).single.id, 'a');
    final session = host.session!;
    final http = HttpClient()
      ..findProxy = ((_) => 'DIRECT')
      ..connectionTimeout = norieLanTimeout;
    addTearDown(() => http.close(force: true));
    Future<int> send(
        {String? code, String? id, String? origin, String body = ''}) async {
      final request = await http.postUrl(
          Uri.parse('http://127.0.0.1:${session.port}/v1/submissions'));
      request.headers.set('x-norie-join-code', code ?? session.joinCode);
      request.headers.set('x-norie-session-id', id ?? session.sessionId);
      if (origin != null) request.headers.set('origin', origin);
      request.add(utf8.encode(body));
      final response = await request.close();
      await response.drain<void>();
      return response.statusCode;
    }

    expect(await send(code: '000000'), 401);
    expect(await send(id: 'old'), 401);
    expect(await send(origin: 'https://example.com'), 401);
    expect(await send(body: '{"type":"submission","type":"submission"}'), 400);
    // Cancelling an oversized chunked request may close the native socket.
    try {
      expect(await send(body: 'x' * (norieLanMaxBytes + 1)), 413);
    } on HttpException {
      expect(host.peers, isEmpty);
    }
    await expectLater(
        NorieClassroomLanClient()
            .connect('http://127.0.0.1:${session.port}', '000000'),
        throwsStateError);
  });
  test('native authentication limits thirteen failures and restart resets them',
      () async {
    final (store, host, client) = await setup();
    final http = HttpClient()..findProxy = ((_) => 'DIRECT');
    addTearDown(() => http.close(force: true));
    Future<int> hello(String code) async {
      final request = await http
          .getUrl(Uri.parse('http://127.0.0.1:${host.session!.port}/v1/hello'));
      request.headers.set('x-norie-join-code', code);
      final response = await request.close();
      await response.drain<void>();
      return response.statusCode;
    }

    for (var i = 0; i < 12; i++) {
      expect(await hello('000000'), 401);
    }
    expect(await hello('000000'), 429);
    await expectLater(
        client.connect(
            'http://127.0.0.1:${host.session!.port}', host.session!.joinCode),
        throwsA(isA<StateError>().having(
            (error) => error.message, 'guidance', contains('Wait a minute'))));
    await host.stop();
    final session = await host.start(assignments: store.assignments);
    expect(await hello('000000'), 401);
    await client.connect('http://127.0.0.1:${session.port}', session.joinCode);
    expect((await client.fetchAssignments()).single.id, 'a');
  });
  test(
      'native four incomplete readers reserve slots fifth is busy and stop releases all',
      () async {
    final (store, host, client) = await setup();
    final session = host.session!;
    final sockets = <Socket>[];
    final closed = <Future<void>>[];
    addTearDown(() {
      for (final socket in sockets) {
        socket.destroy();
      }
    });
    for (var i = 0; i < 4; i++) {
      final socket =
          await Socket.connect(InternetAddress.loopbackIPv4, session.port);
      sockets.add(socket);
      final done = Completer<void>();
      socket.listen((_) {}, onError: (Object error) {
        if (!done.isCompleted) done.complete();
      }, onDone: () {
        if (!done.isCompleted) done.complete();
      });
      closed.add(done.future);
      socket.write(
          'POST /v1/submissions HTTP/1.1\r\nHost: 127.0.0.1\r\nx-norie-join-code: ${session.joinCode}\r\nx-norie-session-id: ${session.sessionId}\r\nTransfer-Encoding: chunked\r\n\r\n1\r\n{\r\n');
      await socket.flush();
    }
    final http = HttpClient()..findProxy = ((_) => 'DIRECT');
    addTearDown(() => http.close(force: true));
    // Real HTTP round trips give all four earlier socket writes a processing
    // barrier without sleeping or depending on private transport counters.
    int? status;
    for (var attempt = 0; attempt < 10 && status != 503; attempt++) {
      final request = await http
          .getUrl(Uri.parse('http://127.0.0.1:${session.port}/v1/hello'));
      request.headers.set('x-norie-join-code', session.joinCode);
      final response = await request.close();
      status = response.statusCode;
      await response.drain<void>();
    }
    expect(status, 503);
    await host.stop();
    await Future.wait(closed).timeout(const Duration(seconds: 2));
    expect(store.submissions, isEmpty);
    final next = await host.start(assignments: store.assignments);
    await client.connect('http://127.0.0.1:${next.port}', next.joinCode);
    expect((await client.fetchAssignments()).single.id, 'a');
  });
}
