import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'package:uuid/uuid.dart';
import 'norie_classroom_lan_models.dart';
import 'norie_classroom_lan_protocol.dart';
import 'norie_classroom_lan_transport.dart';

NorieLanTransport createTransport() => _IoTransport();
Future<String> _read(Stream<List<int>> stream) async {
  final out = BytesBuilder(copy: false);
  await for (final chunk in stream.timeout(norieLanTimeout)) {
    if (out.length + chunk.length > norieLanMaxBytes) {
      throw const FormatException('Message too large.');
    }
    out.add(chunk);
  }
  return utf8.decode(out.takeBytes());
}

class _IoTransport implements NorieLanTransport {
  HttpServer? _server;
  NorieLanSessionInfo? _session;
  NorieLanProtocolHandler? _handler;
  int _pending = 0;
  int _generation = 0;
  final Map<String, ({DateTime until, int count})> _authFailures = {};

  int? _checkCode(HttpRequest request, String? code, String expected) {
    final now = DateTime.now();
    _authFailures.removeWhere((_, value) => !value.until.isAfter(now));
    final peer = request.connectionInfo?.remoteAddress.address ?? '';
    final previous = _authFailures[peer];
    if (previous != null && previous.count >= 12) return 429;
    if (code == expected) return null;
    if (previous == null && _authFailures.length >= 64) return 429;
    _authFailures[peer] = (
      until: previous?.until ?? now.add(const Duration(minutes: 1)),
      count: (previous?.count ?? 0) + 1
    );
    return 401;
  }

  @override
  bool get supported =>
      Platform.isAndroid ||
      Platform.isWindows ||
      Platform.isLinux ||
      Platform.isMacOS;
  @override
  Future<NorieLanSessionInfo> start() async {
    await stop();
    final server = await HttpServer.bind(InternetAddress.anyIPv4, 0);
    _server = server;
    server.idleTimeout = norieLanTimeout;
    final addresses = <String>[];
    for (final interface
        in await NetworkInterface.list(type: InternetAddressType.IPv4)) {
      for (final address in interface.addresses) {
        try {
          norieLanEndpoint('http://${address.address}:${server.port}');
          addresses.add(address.address);
        } on FormatException {
          // Do not advertise public or nonstandard interfaces.
        }
      }
    }
    _session = NorieLanSessionInfo(
        sessionId: const Uuid().v4(),
        joinCode: (100000 + Random.secure().nextInt(900000)).toString(),
        host: addresses.firstOrNull ?? '127.0.0.1',
        port: server.port,
        startedAt: DateTime.now().toUtc(),
        addresses: List.unmodifiable(addresses));
    server.listen((request) {
      unawaited(_receive(request));
    });
    return _session!;
  }

  @override
  Future<void> serve(NorieLanProtocolHandler handler) async {
    _handler = handler;
  }

  Future<void> _receive(HttpRequest request) async {
    final session = _session, handler = _handler;
    final generation = _generation;
    String? singleHeader(String name) {
      final values = request.headers[name];
      return values?.length == 1 ? values!.single : null;
    }

    final authStatus = session != null && request.headers['origin'] == null
        ? _checkCode(
            request, singleHeader('x-norie-join-code'), session.joinCode)
        : null;
    NorieLanResponse response;
    if (session == null || handler == null) {
      response = NorieLanProtocolHandler.error(503);
      // Reserve the complete 2 MiB allowance before reading any request body.
      // Four readers cap raw buffered request bytes at 8 MiB; decoded strings,
      // JSON objects and other runtime allocations require additional memory.
    } else if (_pending >= 4) {
      response = NorieLanProtocolHandler.error(503);
    } else if (request.headers['origin'] != null ||
        authStatus != null ||
        (request.uri.path != '/v1/hello' &&
            singleHeader('x-norie-session-id') != session.sessionId) ||
        (request.headers['x-norie-session-id'] != null &&
            singleHeader('x-norie-session-id') != session.sessionId)) {
      _pending++;
      try {
        await _read(request).timeout(norieLanTimeout);
      } catch (_) {
        // A rejected client cannot keep a request body open indefinitely.
      } finally {
        if (generation == _generation) _pending--;
      }
      response = NorieLanProtocolHandler.error(authStatus ?? 401);
    } else {
      _pending++;
      try {
        if (request.contentLength > norieLanMaxBytes) {
          response = NorieLanProtocolHandler.error(413);
        } else {
          final body = await _read(request).timeout(norieLanTimeout);
          response = await handler
              .handle(request.method, request.uri.toString(), body)
              .timeout(norieLanTimeout);
        }
      } on FormatException {
        response = NorieLanProtocolHandler.error(413);
      } catch (_) {
        response = NorieLanProtocolHandler.error(503);
      } finally {
        if (generation == _generation) _pending--;
      }
    }
    try {
      request.response.statusCode = response.status;
      request.response.headers.contentType = ContentType.json;
      request.response.headers.set('Cache-Control', 'no-store');
      request.response.headers.set('X-Content-Type-Options', 'nosniff');
      request.response.write(response.body);
      await request.response.close();
    } catch (_) {
      // Oversized streaming bodies and disconnected clients may close early.
    }
  }

  @override
  Future<void> refresh() async {}
  @override
  Future<void> stop() async {
    final server = _server;
    _server = null;
    _session = null;
    _handler = null;
    _generation++;
    _pending = 0;
    _authFailures.clear();
    await server?.close(force: true);
  }

  @override
  Future<NorieLanResponse> request(
      {required String endpoint,
      required String joinCode,
      required String? sessionId,
      required String method,
      required String path,
      required String body}) async {
    final base = norieLanEndpoint(endpoint);
    if (utf8.encode(body).length > norieLanMaxBytes) {
      throw const FormatException('Message too large.');
    }
    final client = HttpClient()
      ..connectionTimeout = norieLanTimeout
      ..findProxy = ((_) => 'DIRECT');
    try {
      return await (() async {
        final request = await client.openUrl(method, base.replace(path: path));
        request.followRedirects = false;
        request.headers.set('x-norie-join-code', joinCode);
        if (sessionId != null) {
          request.headers.set('x-norie-session-id', sessionId);
        }
        if (body.isNotEmpty) {
          request.headers.contentType = ContentType.json;
          request.add(utf8.encode(body));
        }
        final response = await request.close();
        if (response.contentLength > norieLanMaxBytes) {
          throw const FormatException('Message too large.');
        }
        return NorieLanResponse(response.statusCode, await _read(response));
      })()
          .timeout(norieLanTimeout);
    } finally {
      client.close(force: true);
    }
  }
}
