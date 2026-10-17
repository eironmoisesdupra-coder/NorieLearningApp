import 'dart:async';
import 'dart:convert';
import 'dart:js_interop';
import 'norie_classroom_lan_models.dart';
import 'norie_classroom_lan_protocol.dart';
import 'norie_classroom_lan_transport.dart';

@JS('window.norieClassroomLan')
external _Bridge? get _bridge;
@JS()
extension type _Bridge(JSObject _) implements JSObject {
  external JSPromise<JSString> invoke(JSString action, JSString data);
}
NorieLanTransport createTransport() => _WebTransport();

class _WebTransport implements NorieLanTransport {
  bool _polling = false;
  int _generation = 0;
  NorieLanProtocolHandler? _handler;
  @override
  bool get supported => _bridge != null;
  Future<Map<String, dynamic>> _invoke(
      String action, Map<String, dynamic> data) async {
    final bridge = _bridge;
    if (bridge == null) {
      throw UnsupportedError(
          'Install the Windows or Android app to use local Wi-Fi Classroom.');
    }
    final raw = (await bridge
            .invoke(action.toJS, jsonEncode(data).toJS)
            .toDart
            .timeout(norieLanTimeout))
        .toDart;
    // Poll batches can contain several individually bounded requests.
    if (raw.length > norieLanMaxBytes * 33) {
      throw const FormatException('Invalid local bridge response.');
    }
    return Map<String, dynamic>.from(jsonDecode(raw) as Map);
  }

  @override
  Future<NorieLanSessionInfo> start() async {
    await stop();
    return NorieLanSessionInfo.fromJson(await _invoke('start', {}));
  }

  @override
  Future<void> serve(NorieLanProtocolHandler handler) async {
    _handler = handler;
  }

  @override
  Future<void> refresh() async {
    if (_polling || _handler == null) return;
    _polling = true;
    final generation = _generation;
    try {
      final result = await _invoke('poll', {});
      // A response from a stopped session cannot act on its replacement.
      if (generation != _generation || _handler == null) return;
      final session = result['session'];
      if (session is! Map ||
          session['session_id'] != _handler!.session.sessionId) {
        throw StateError('Classroom host stopped.');
      }
      final requests = result['requests'];
      if (requests is! List || requests.length > 32) {
        throw const FormatException('Invalid bridge request batch.');
      }
      for (final raw in requests) {
        if (generation != _generation || _handler == null) return;
        final request = Map<String, dynamic>.from(raw as Map);
        final response = await _handler!.handle(request['method'] as String,
            request['path'] as String, request['body'] as String);
        if (generation != _generation) return;
        await _invoke('respond', {
          'request_id': request['request_id'],
          'status': response.status,
          'body': response.body
        });
      }
    } catch (_) {
      if (generation != _generation) return;
      await stop();
      rethrow;
    } finally {
      _polling = false;
    }
  }

  @override
  Future<void> stop() async {
    _generation++;
    _handler = null;
    if (supported) await _invoke('stop', {});
  }

  @override
  Future<NorieLanResponse> request(
      {required String endpoint,
      required String joinCode,
      required String? sessionId,
      required String method,
      required String path,
      required String body}) async {
    norieLanEndpoint(endpoint);
    final out = await _invoke('request', {
      'endpoint': endpoint,
      'join_code': joinCode,
      'session_id': sessionId,
      'method': method,
      'path': path,
      'body': body
    });
    return NorieLanResponse(out['status'] as int, out['body'] as String);
  }
}
