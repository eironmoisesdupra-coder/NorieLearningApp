import 'dart:convert';
import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/diagnostics/norie_diagnostics.dart';
import 'package:norie_learning/core/diagnostics/norie_diagnostics_screen.dart';

void main() {
  test('malicious disk payloads are rejected before any export or overwrite',
      () async {
    final now = DateTime.utc(2026, 10, 17);
    final entry = {
      'at': now.toIso8601String(),
      'category': 'state',
      'source': 'flutter',
      'route': 'home'
    };
    final mutations = <Map<String, dynamic>>[
      {...entry, 'message': 'secret@example.com'},
      {...entry, 'category': 'secret@example.com'},
      {...entry, 'source': 'bearer token'},
      {...entry, 'route': '/notes?uid=secret'},
      {...entry, 'at': 'https://secret'},
      {...entry, 'at': DateTime.utc(2099).toIso8601String()},
    ];
    for (final bad in mutations) {
      var writes = 0;
      final store = NorieDiagnosticsStore(
          clock: () => now,
          read: () async => jsonEncode({
                'schema': 1,
                'enabled': true,
                'retentionDays': 14,
                'entries': [entry, bad]
              }),
          write: (_) async {
            writes++;
          });
      await store.load();
      expect(store.entries, isEmpty);
      expect(store.storageProblem, isNotNull);
      expect(store.exportJson(), isNot(contains('secret')));
      await store.flush();
      expect(writes, 0);
      store.dispose();
    }
  });
  test('read failures and startup capture do not block startup', () async {
    final store = NorieDiagnosticsStore(
        read: () async => throw StateError('secret'),
        write: (_) async => fail('must not replace unreadable history'));
    store.capture(StateError('startup secret'),
        source: DiagnosticSource.startup);
    await store.load();
    expect(store.entries.single.source, DiagnosticSource.startup);
    expect(store.storageProblem, isNotNull);
    await store.flush();
    store.dispose();
  });
  test('queued write failures never escape and newer capture survives restart',
      () async {
    final started = Completer<void>();
    final release = Completer<void>();
    String? disk;
    var writes = 0;
    final store = NorieDiagnosticsStore(
        read: () async => null,
        write: (value) async {
          writes++;
          if (writes == 1) {
            started.complete();
            await release.future;
            throw StateError('secret');
          }
          disk = value;
        });
    await store.load();
    store.capture(StateError('a'));
    await started.future;
    store.capture(const FormatException('b'));
    release.complete();
    await store.flush();
    final restarted =
        NorieDiagnosticsStore(read: () async => disk, write: (_) async {});
    await restarted.load();
    expect(restarted.entries, hasLength(2));
    store.dispose();
    restarted.dispose();
  });
  test('global handlers chain original callbacks and platform handled result',
      () async {
    final store =
        NorieDiagnosticsStore(read: () async => null, write: (_) async {});
    await store.load();
    final originalFlutter = FlutterError.onError;
    final originalPlatform = PlatformDispatcher.instance.onError;
    var presentations = 0;
    FlutterError.onError = (_) {
      presentations++;
    };
    PlatformDispatcher.instance.onError = (error, stack) => true;
    final previousFlutter = FlutterError.onError;
    final previousPlatform = PlatformDispatcher.instance.onError;
    final handlers = NorieDiagnosticsHandlers.install(store);
    try {
      FlutterError.onError!(FlutterErrorDetails(
          exception: StateError('secret'), library: 'secret notes'));
      expect(presentations, 1);
      expect(
          PlatformDispatcher.instance.onError!(
              StateError('secret'), StackTrace.current),
          isTrue);
      expect(store.entries.map((e) => e.source).toSet(),
          {DiagnosticSource.flutter, DiagnosticSource.platform});
      handlers.uninstall();
      expect(FlutterError.onError, same(previousFlutter));
      expect(PlatformDispatcher.instance.onError, same(previousPlatform));
    } finally {
      FlutterError.onError = originalFlutter;
      PlatformDispatcher.instance.onError = originalPlatform;
      store.dispose();
    }
  });
  test('disabled preference survives restart and clear removes history',
      () async {
    String? disk;
    NorieDiagnosticsStore make() => NorieDiagnosticsStore(
        read: () async => disk,
        write: (value) async {
          disk = value;
        });
    final store = make();
    await store.load();
    store.capture(StateError('secret'));
    await store.setEnabled(false);
    final restarted = make();
    await restarted.load();
    expect(restarted.enabled, isFalse);
    restarted.capture(Exception('secret'));
    expect(restarted.entries, hasLength(1));
    await restarted.clear();
    expect(restarted.entries, isEmpty);
    expect(jsonDecode(disk!)['entries'], isEmpty);
    store.dispose();
    restarted.dispose();
  });
  test('capture exports only allowlisted facts across restart', () async {
    String? disk;
    final now = DateTime.utc(2026, 10, 17);
    NorieDiagnosticsStore make() => NorieDiagnosticsStore(
        read: () async => disk,
        write: (v) async {
          disk = v;
        },
        clock: () => now);
    final store = make();
    await store.load();
    store.setRoute('/notes?token=secret@example.com');
    store.capture(StateError('answer secret@example.com bearer abc'),
        stack: StackTrace.fromString('uid notes https://secret'),
        source: DiagnosticSource.flutter);
    await store.flush();
    final restarted = make();
    await restarted.load();
    expect(restarted.entries, hasLength(1));
    final exported = restarted.exportJson();
    for (final secret in [
      'secret',
      'bearer',
      'https',
      'notes',
      'uid',
      'answer'
    ]) {
      expect(exported, isNot(contains(secret)));
    }
    expect(jsonDecode(exported)['entries'][0]['route'], 'other');
  });
  test('bad disk is isolated until explicit clear', () async {
    String? disk = '{"entries":[{"email":"secret"}]}';
    var writes = 0;
    final store = NorieDiagnosticsStore(
        read: () async => disk,
        write: (v) async {
          writes++;
          disk = v;
        });
    await store.load();
    expect(store.storageProblem, isNotNull);
    store.capture(Exception('secret'));
    await store.flush();
    expect(writes, 0);
    await store.clear();
    expect(writes, 1);
    expect(store.storageProblem, isNull);
  });
  test('failed queue write is observable and retryable', () async {
    var fail = true;
    String? disk;
    final store = NorieDiagnosticsStore(
        read: () async => null,
        write: (v) async {
          if (fail) throw StateError('secret');
          disk = v;
        });
    await store.load();
    store.capture(Exception('secret'));
    await store.flush();
    expect(store.storageProblem, isNotNull);
    fail = false;
    await store.flush();
    expect(store.storageProblem, isNull);
    expect(jsonDecode(disk!)['entries'], hasLength(1));
  });
  test('dedupe rate limit retention and disable bound capture', () async {
    var now = DateTime.utc(2026, 10, 17);
    final store = NorieDiagnosticsStore(
        read: () async => null, write: (_) async {}, clock: () => now);
    await store.load();
    for (var i = 0; i < 1000; i++) {
      store.capture(Exception('secret $i'));
    }
    expect(store.entries, hasLength(1));
    for (var i = 0; i < 120; i++) {
      now = now.add(const Duration(minutes: 2));
      store.capture(Exception('secret'));
    }
    expect(store.entries, hasLength(100));
    now = now.add(const Duration(days: 15));
    expect(jsonDecode(store.exportJson())['entries'], isEmpty);
    await store.setEnabled(false);
    store.capture(Exception('secret'));
    expect(store.entries, isEmpty);
  });
  testWidgets('diagnostics controls fit 320px at 160 percent text',
      (tester) async {
    tester.view.physicalSize = const Size(320, 640);
    tester.view.devicePixelRatio = 1;
    addTearDown(tester.view.resetPhysicalSize);
    addTearDown(tester.view.resetDevicePixelRatio);
    final store =
        NorieDiagnosticsStore(read: () async => null, write: (_) async {});
    await store.load();
    await tester.pumpWidget(MaterialApp(
        home: MediaQuery(
            data: const MediaQueryData(textScaler: TextScaler.linear(1.6)),
            child: NorieDiagnosticsScreen(store: store))));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
    expect(find.text('Local diagnostics'), findsOneWidget);
    await tester.scrollUntilVisible(find.byType(SwitchListTile), 200);
    await tester.ensureVisible(find.byType(Switch));
    await tester.pumpAndSettle();
    await tester.tap(find.byType(Switch));
    await tester.pumpAndSettle();
    expect(store.enabled, isFalse);
  });
}
