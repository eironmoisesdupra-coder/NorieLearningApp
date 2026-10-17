import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:uuid/uuid.dart';
import '../../../core/account/norie_account_service.dart';
import '../../../core/progression/norie_adventure_progress.dart';
import '../data/norie_classroom_store.dart';
import '../data/norie_classroom_codec.dart';
import '../domain/norie_classroom_models.dart';
import 'norie_classroom_lan_models.dart';
import 'norie_classroom_lan_protocol.dart';
import 'norie_classroom_lan_transport.dart';
import 'norie_classroom_lan_transport_stub.dart'
    if (dart.library.io) 'norie_classroom_lan_transport_io.dart'
    if (dart.library.js_interop) 'norie_classroom_lan_transport_web.dart'
    as platform;
export 'norie_classroom_lan_models.dart';
export 'norie_classroom_lan_protocol.dart';

class NorieClassroomLanHost extends ChangeNotifier {
  NorieClassroomLanHost(
      {NorieClassroomStore? store, bool Function()? stillCurrent})
      : _store = store ?? NorieClassroomStore.instance,
        _providedGuard = stillCurrent {
    NorieAccountService.instance.addListener(_ownershipChanged);
    NorieAdventureProgress.instance.addListener(_ownershipChanged);
  }
  final NorieClassroomStore _store;
  final bool Function()? _providedGuard;
  final NorieLanTransport _transport = platform.createTransport();
  NorieLanSessionInfo? _session;
  NorieLanProtocolHandler? _handler;
  List<NorieClassroomAssignment> _sharedAssignments = const [];
  bool Function()? _captured;
  int _ownership = 0, _generation = 0;
  bool _disposed = false;
  Timer? _timer;
  bool get supported => _transport.supported;
  NorieLanSessionInfo? get session => _session;
  List<NorieLanPeer> get peers => _handler?.peers ?? const [];
  int get activeLinks => _handler?.activeLinks ?? 0;
  List<NorieClassroomAssignment> get sharedAssignments => _sharedAssignments;
  bool _current() =>
      !_disposed &&
      (_providedGuard?.call() ?? true) &&
      (_captured?.call() ?? false) &&
      _ownership == NorieAdventureProgress.instance.ownershipRevision;
  void _ownershipChanged() {
    if (_session != null && !_current()) unawaited(stop());
  }

  Future<NorieLanSessionInfo> start(
      {required List<NorieClassroomAssignment> assignments}) async {
    await stop();
    if (_disposed) throw StateError('Classroom is closed.');
    if (assignments.isEmpty ||
        assignments.length > 200 ||
        assignments.map((a) => a.id).toSet().length != assignments.length) {
      throw const FormatException('Select assignments to share.');
    }
    _captured = NorieAccountService.instance.captureLearnerGuard();
    _ownership = NorieAdventureProgress.instance.ownershipRevision;
    final generation = _generation;
    if (!_current()) throw StateError('Classroom ownership changed.');
    final frozen = [
      for (final a in assignments)
        NorieClassroomCodec.decodeAssignment(
            NorieClassroomCodec.encodeAssignment(a))
    ];
    for (final a in frozen) {
      final saved = _store.assignments.where((v) => v.id == a.id).firstOrNull;
      if (saved == null ||
          NorieClassroomCodec.encodeAssignment(saved) !=
              NorieClassroomCodec.encodeAssignment(a)) {
        throw const FormatException('Save the assignment before sharing.');
      }
    }
    final session = await _transport.start();
    if (!_current() || generation != _generation) {
      await _transport.stop();
      throw StateError('Classroom ownership changed.');
    }
    _session = session;
    _sharedAssignments = List.unmodifiable(frozen);
    _handler = NorieLanProtocolHandler(
        store: _store,
        session: session,
        assignments: frozen,
        stillCurrent: () =>
            generation == _generation && _session != null && _current(),
        changed: _notify);
    await _transport.serve(_handler!);
    _timer = Timer.periodic(const Duration(milliseconds: 500), (_) {
      unawaited(refresh());
    });
    _notify();
    return session;
  }

  void _notify() {
    if (!_disposed) notifyListeners();
  }

  Future<void> refresh() async {
    final generation = _generation;
    _ownershipChanged();
    if (_session != null) {
      try {
        await _transport.refresh();
      } catch (_) {
        if (generation == _generation) await stop();
      }
    }
    _notify();
  }

  Future<void> stop() async {
    _generation++;
    _timer?.cancel();
    _timer = null;
    _session = null;
    _handler = null;
    _sharedAssignments = const [];
    try {
      await _transport.stop();
    } catch (_) {
      // Closing/reloading the Electron window can invalidate its bridge.
      // Native and Electron process lifecycle also close their listeners.
    }
    _notify();
  }

  @override
  void dispose() {
    _disposed = true;
    NorieAccountService.instance.removeListener(_ownershipChanged);
    NorieAdventureProgress.instance.removeListener(_ownershipChanged);
    unawaited(stop());
    super.dispose();
  }
}

class NorieClassroomLanClient {
  NorieClassroomLanClient({NorieLanTransport? transport})
      : _transport = transport ?? platform.createTransport();
  final NorieLanTransport _transport;
  NorieLanSessionInfo? _session;
  String? _endpoint, _code;
  int _generation = 0;
  String? _connectionId;
  Timer? _heartbeat;
  bool _presenceInFlight = false;
  bool get supported => _transport.supported;
  NorieLanSessionInfo? get session => _session;
  Future<NorieLanEnvelope> _request(
      String method, String path, String body, String type,
      {String? expectedSessionId}) async {
    final generation = _generation;
    final NorieLanResponse response;
    try {
      response = await _transport.request(
          endpoint: _endpoint!,
          joinCode: _code!,
          sessionId: expectedSessionId ?? _session?.sessionId,
          method: method,
          path: path,
          body: body);
    } on UnsupportedError {
      rethrow;
    } catch (_) {
      throw NorieLanConnectionException(NorieLanFailure.unreachable);
    }
    if (generation != _generation) {
      throw StateError('Classroom connection changed.');
    }
    if (response.status != 200) {
      throw NorieLanConnectionException(
          switch (response.status) {
            401 || 403 => NorieLanFailure.unauthorized,
            404 => NorieLanFailure.unavailable,
            409 => NorieLanFailure.changed,
            413 => NorieLanFailure.oversized,
            429 => NorieLanFailure.throttled,
            503 || 504 => NorieLanFailure.busy,
            _ => NorieLanFailure.incompatible,
          },
          status: response.status);
    }
    return NorieLanEnvelope.decode(response.body,
        expectedSessionId: expectedSessionId ?? _session?.sessionId,
        expectedType: type);
  }

  Future<NorieLanSessionInfo> connect(String endpoint, String joinCode,
      {String? expectedSessionId}) async {
    final join = NorieLanJoinInfo(
        endpoint: endpoint, joinCode: joinCode, sessionId: expectedSessionId);
    disconnect();
    _generation++;
    final connectionGeneration = _generation;
    _session = null;
    _endpoint = join.endpoint;
    _code = join.joinCode;
    final reply = await _request('GET', '/v1/hello', '', 'hello',
        expectedSessionId: expectedSessionId);
    final session = NorieLanSessionInfo.fromJson(reply.payload);
    if (session.sessionId != reply.sessionId || session.joinCode != joinCode) {
      throw const FormatException('Classroom session changed.');
    }
    final capabilities = reply.payload['capabilities'];
    if (capabilities != null &&
        (capabilities is! List ||
            capabilities.length > 8 ||
            capabilities
                .any((value) => value is! String || value.length > 32))) {
      throw const FormatException('Invalid classroom capabilities.');
    }
    _session = session;
    if (capabilities is List && capabilities.contains('presence')) {
      _connectionId = const Uuid().v4();
      await refreshPresence();
      if (connectionGeneration != _generation) {
        throw StateError('Classroom connection changed.');
      }
      _heartbeat = Timer.periodic(const Duration(seconds: 20), (_) {
        unawaited(refreshPresence());
      });
    }
    return session;
  }

  /// Anonymous device link only; never a learner identity or attendance record.
  Future<void> refreshPresence() async {
    if (_session == null || _connectionId == null || _presenceInFlight) return;
    final generation = _generation;
    _presenceInFlight = true;
    try {
      await _request(
          'POST',
          '/v1/presence',
          NorieLanEnvelope(
                  type: 'presence',
                  sessionId: _session!.sessionId,
                  payload: {'connection_id': _connectionId, 'active': true})
              .encode(),
          'presence_ack');
    } catch (_) {
      // Keep saved practice usable through interruptions. Link counts expire.
    } finally {
      if (generation == _generation) _presenceInFlight = false;
    }
  }

  void _check() {
    if (_session == null) throw StateError('Join a classroom first.');
  }

  Future<List<NorieLanAssignmentSummary>> fetchAssignments() async {
    _check();
    final response =
        await _request('GET', '/v1/assignments', '', 'assignment_list');
    final list = response.payload['assignments'];
    if (list is! List || list.length > 200) {
      throw const FormatException('Invalid classroom list.');
    }
    final result = list.map(NorieLanAssignmentSummary.fromJson).toList();
    if (result.map((a) => a.id).toSet().length != result.length) {
      throw const FormatException('Duplicate classroom assignment.');
    }
    return List.unmodifiable(result);
  }

  Future<NorieClassroomAssignment> downloadAssignment(String id) async {
    _check();
    classroomString(id, 128);
    final response = await _request(
        'GET', '/v1/assignments/${Uri.encodeComponent(id)}', '', 'assignment');
    final package = response.payload['package'];
    if (package is! String) {
      throw const FormatException('Invalid classroom package.');
    }
    final assignment = NorieClassroomCodec.decodeAssignment(package);
    if (assignment.id != id) {
      throw const FormatException('Classroom assignment changed.');
    }
    return assignment;
  }

  Future<NorieLanSubmissionAck> submit(
      NorieClassroomSubmission submission) async {
    _check();
    final response = await _request(
        'POST',
        '/v1/submissions',
        NorieLanEnvelope(
            type: 'submission',
            sessionId: _session!.sessionId,
            payload: {
              'package': NorieClassroomCodec.encodeSubmission(submission)
            }).encode(),
        'ack');
    if (response.payload['submission_id'] != submission.id ||
        response.payload['accepted'] is! bool) {
      throw const FormatException('Invalid classroom acknowledgement.');
    }
    return NorieLanSubmissionAck(
        submissionId: submission.id,
        accepted: response.payload['accepted'] as bool);
  }

  void disconnect() {
    _heartbeat?.cancel();
    _heartbeat = null;
    if (_session != null && _connectionId != null) {
      // Best effort leave; missed leaves expire after 60 seconds on the host.
      unawaited(_transport
          .request(
              endpoint: _endpoint!,
              joinCode: _code!,
              sessionId: _session!.sessionId,
              method: 'POST',
              path: '/v1/presence',
              body: NorieLanEnvelope(
                  type: 'presence',
                  sessionId: _session!.sessionId,
                  payload: {
                    'connection_id': _connectionId,
                    'active': false
                  }).encode())
          .then<void>((_) {}, onError: (Object _, StackTrace __) {}));
    }
    _generation++;
    _connectionId = null;
    _presenceInFlight = false;
    _session = null;
    _endpoint = null;
    _code = null;
  }

  void dispose() {
    disconnect();
  }
}
