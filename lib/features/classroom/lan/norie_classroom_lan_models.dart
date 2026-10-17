import 'dart:convert';
import '../data/norie_classroom_codec.dart';
import '../domain/norie_classroom_models.dart';

const norieLanMaxBytes = 2 * 1024 * 1024;
const norieLanTimeout = Duration(seconds: 15);

enum NorieLanFailure {
  unreachable,
  unauthorized,
  unavailable,
  changed,
  oversized,
  throttled,
  busy,
  incompatible,
}

/// Typed public failure; transport details and join secrets never reach UI copy.
class NorieLanConnectionException extends StateError {
  NorieLanConnectionException(this.failure, {this.status})
      : super(switch (failure) {
          NorieLanFailure.unreachable =>
            'Cannot reach the classroom. Check the teacher address and Wi-Fi, then retry. Your saved work stays on this device.',
          NorieLanFailure.unauthorized =>
            'Check the classroom code with your teacher.',
          NorieLanFailure.unavailable =>
            'This assignment is no longer shared. Refresh the classroom.',
          NorieLanFailure.changed =>
            'The classroom session or saved work changed. Rejoin with the current code, or check the saved assignment.',
          NorieLanFailure.oversized => 'This classroom package is too large.',
          NorieLanFailure.throttled =>
            'Too many code attempts. Wait a minute, then try again.',
          NorieLanFailure.busy =>
            'The teacher is busy or disconnected. Retry shortly; your saved work is safe.',
          NorieLanFailure.incompatible =>
            'The classroom package could not be accepted. Check that both apps have the same content version.',
        });
  final NorieLanFailure failure;
  final int? status;
}

Uri norieLanEndpoint(String value) {
  if (value.length > 256) throw const FormatException('Invalid local address.');
  final u = Uri.tryParse(value);
  if (u == null ||
      u.scheme != 'http' ||
      u.userInfo.isNotEmpty ||
      !u.hasPort ||
      u.port < 1 ||
      u.port > 65535 ||
      (u.path.isNotEmpty && u.path != '/') ||
      u.hasQuery ||
      u.hasFragment) {
    throw const FormatException('Enter a private IPv4 HTTP address and port.');
  }
  final parts = u.host.split('.');
  if (parts.length != 4 ||
      parts.any((p) =>
          !RegExp(r'^(0|[1-9][0-9]{0,2})$').hasMatch(p) ||
          int.parse(p) > 255)) {
    throw const FormatException('Enter a private IPv4 address.');
  }
  final n = parts.map(int.parse).toList();
  if (!(n[0] == 10 ||
      n[0] == 127 ||
      (n[0] == 172 && n[1] >= 16 && n[1] <= 31) ||
      (n[0] == 192 && n[1] == 168))) {
    throw const FormatException('Only private local addresses are supported.');
  }
  return Uri(scheme: 'http', host: u.host, port: u.port);
}

class NorieLanJoinInfo {
  NorieLanJoinInfo(
      {required String endpoint, required this.joinCode, this.sessionId})
      : endpoint = norieLanEndpoint(endpoint).toString() {
    if (!RegExp(r'^[0-9]{6}$').hasMatch(joinCode) ||
        (sessionId != null &&
            (sessionId!.isEmpty || sessionId!.length > 128))) {
      throw const FormatException('Invalid classroom join information.');
    }
  }
  final String endpoint, joinCode;
  final String? sessionId;
  static NorieLanJoinInfo parse(String raw) {
    if (raw.length > 1024) throw const FormatException('Invalid classroom QR.');
    final u = Uri.tryParse(raw);
    if (u == null ||
        u.scheme != 'norie-classroom' ||
        u.host != 'join' ||
        u.path.isNotEmpty ||
        u.hasFragment ||
        u.userInfo.isNotEmpty ||
        u.queryParametersAll.length != 3 ||
        u.queryParametersAll.values.any((v) => v.length != 1) ||
        !u.queryParameters.keys
            .toSet()
            .containsAll({'endpoint', 'code', 'session'})) {
      throw const FormatException('Invalid classroom QR.');
    }
    return NorieLanJoinInfo(
        endpoint: u.queryParameters['endpoint']!,
        joinCode: u.queryParameters['code']!,
        sessionId: u.queryParameters['session']!);
  }
}

class NorieLanSessionInfo {
  const NorieLanSessionInfo(
      {required this.sessionId,
      required this.joinCode,
      required this.host,
      required this.port,
      required this.startedAt,
      this.addresses = const []});
  final String sessionId, joinCode, host;
  final int port;
  final DateTime startedAt;
  final List<String> addresses;
  String get endpoint => 'http://$host:$port';
  Uri joinUri({String? endpointOverride}) =>
      Uri(scheme: 'norie-classroom', host: 'join', queryParameters: {
        'endpoint': norieLanEndpoint(endpointOverride ?? endpoint).toString(),
        'code': joinCode,
        'session': sessionId
      });
  Map<String, dynamic> toJson() => {
        'session_id': sessionId,
        'join_code': joinCode,
        'host': host,
        'port': port,
        'started_at': startedAt.toUtc().toIso8601String(),
        'addresses': addresses
      };
  static NorieLanSessionInfo fromJson(Object? raw) {
    final m = classroomMap(raw);
    final host = classroomString(m['host'], 64), port = m['port'];
    if (port is! int) throw const FormatException('Invalid classroom session.');
    final id = classroomString(m['session_id'], 128),
        code = classroomString(m['join_code'], 6);
    NorieLanJoinInfo(
        endpoint: 'http://$host:$port', joinCode: code, sessionId: id);
    final at = DateTime.tryParse(
        m['started_at'] is String ? m['started_at'] as String : '');
    if (at == null) throw const FormatException('Invalid classroom session.');
    return NorieLanSessionInfo(
        sessionId: id,
        joinCode: code,
        host: host,
        port: port,
        startedAt: at,
        addresses: List.unmodifiable((m['addresses'] as List? ?? [])
            .map((e) => norieLanEndpoint('http://$e:$port').host)));
  }
}

class NorieLanAssignmentSummary {
  const NorieLanAssignmentSummary(
      {required this.id,
      required this.title,
      required this.subject,
      required this.gradeId,
      required this.questionCount});
  final String id, title, subject, gradeId;
  final int questionCount;
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'grade_id': gradeId,
        'question_count': questionCount
      };
  static NorieLanAssignmentSummary fromJson(Object? raw) {
    final m = classroomMap(raw), n = m['question_count'];
    if (n is! int || n < 1 || n > 100) {
      throw const FormatException('Invalid classroom summary.');
    }
    return NorieLanAssignmentSummary(
        id: classroomString(m['id'], 128),
        title: classroomString(m['title'], 160),
        subject: classroomString(m['subject'], 64),
        gradeId: classroomString(m['grade_id'], 32),
        questionCount: n);
  }
}

class NorieLanSubmissionAck {
  const NorieLanSubmissionAck(
      {required this.submissionId, required this.accepted});
  final String submissionId;
  final bool accepted;
}

class NorieLanPeer {
  const NorieLanPeer(
      {required this.alias, required this.lastSeen, required this.submissions});
  final String alias;
  final DateTime lastSeen;
  final int submissions;
}

class NorieLanEnvelope {
  const NorieLanEnvelope(
      {required this.type, required this.sessionId, required this.payload});
  final String type, sessionId;
  final Map<String, dynamic> payload;
  Map<String, dynamic> toJson() => {
        'protocol': 'norie-classroom-lan',
        'version': 1,
        'type': type,
        'session_id': sessionId,
        'payload': payload
      };
  String encode() => jsonEncode(toJson());
  static NorieLanEnvelope decode(String text,
      {String? expectedSessionId, String? expectedType}) {
    NorieClassroomCodec.checkBoundedJson(text);
    final m = classroomMap(jsonDecode(text));
    if (m['protocol'] != 'norie-classroom-lan' ||
        m['version'] != 1 ||
        !const {
          'hello',
          'assignment_list',
          'assignment',
          'submission',
          'ack',
          'presence',
          'presence_ack'
        }.contains(m['type'])) {
      throw const FormatException('Unsupported LAN classroom message.');
    }
    final id = classroomString(m['session_id'], 128),
        type = m['type'] as String;
    if ((expectedSessionId != null && id != expectedSessionId) ||
        (expectedType != null && type != expectedType)) {
      throw const FormatException('Classroom session or message changed.');
    }
    return NorieLanEnvelope(
        type: type, sessionId: id, payload: classroomMap(m['payload']));
  }
}

class NorieLanResponse {
  const NorieLanResponse(this.status, this.body);
  final int status;
  final String body;
}
