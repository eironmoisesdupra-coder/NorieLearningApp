import 'dart:convert';
import '../data/norie_classroom_codec.dart';
import '../data/norie_classroom_store.dart';
import '../domain/norie_classroom_models.dart';
import 'norie_classroom_lan_models.dart';

class NorieLanProtocolHandler {
  NorieLanProtocolHandler(
      {required this.store,
      required this.session,
      required List<NorieClassroomAssignment> assignments,
      required this.stillCurrent,
      required this.changed,
      DateTime Function()? clock})
      : _clock = clock ?? DateTime.now,
        packages = Map.unmodifiable({
          for (final a in assignments)
            a.id: NorieClassroomCodec.encodeAssignment(a)
        });
  final NorieClassroomStore store;
  final NorieLanSessionInfo session;
  final bool Function() stillCurrent;
  final void Function() changed;
  final Map<String, String> packages;
  final Map<String, NorieLanPeer> _peers = {};
  final DateTime Function() _clock;
  final Map<String, DateTime> _links = {};
  void _expireLinks() => _links.removeWhere(
      (_, seen) => _clock().difference(seen) >= const Duration(seconds: 60));
  int get activeLinks {
    _expireLinks();
    return _links.length;
  }

  List<NorieLanPeer> get peers => List.unmodifiable(_peers.values);
  void _guard() {
    if (!stillCurrent()) throw StateError('Classroom ownership changed.');
  }

  Future<NorieLanResponse> handle(
      String method, String path, String body) async {
    try {
      _guard();
      if (utf8.encode(body).length > norieLanMaxBytes || path.length > 1024) {
        return error(413);
      }
      NorieLanResponse reply(String type, Map<String, dynamic> payload) =>
          NorieLanResponse(
              200,
              NorieLanEnvelope(
                      type: type,
                      sessionId: session.sessionId,
                      payload: payload)
                  .encode());
      if (method == 'GET' && path == '/v1/hello') {
        return reply('hello', {
          ...session.toJson(),
          'capabilities': ['presence']
        });
      }
      if (method == 'POST' && path == '/v1/presence') {
        final envelope = NorieLanEnvelope.decode(body,
            expectedType: 'presence', expectedSessionId: session.sessionId);
        final token = envelope.payload['connection_id'];
        final active = envelope.payload['active'];
        if (token is! String ||
            !RegExp(r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$')
                .hasMatch(token) ||
            active is! bool) {
          return error(400);
        }
        _expireLinks();
        if (active) {
          if (!_links.containsKey(token) && _links.length >= 128) {
            return error(503);
          }
          _links[token] = _clock();
        } else {
          _links.remove(token);
        }
        changed();
        return reply('presence_ack', {'active': active});
      }
      if (method == 'GET' && path == '/v1/assignments') {
        return reply('assignment_list', {
          'assignments': [
            for (final package in packages.values)
              (() {
                final a = NorieClassroomCodec.decodeAssignment(package);
                return NorieLanAssignmentSummary(
                        id: a.id,
                        title: a.title,
                        subject: a.subject,
                        gradeId: a.gradeId,
                        questionCount: a.questionIds.length)
                    .toJson();
              })()
          ]
        });
      }
      if (method == 'GET' && path.startsWith('/v1/assignments/')) {
        final id =
            Uri.decodeComponent(path.substring('/v1/assignments/'.length));
        final package = packages[id];
        if (package == null) return error(404);
        return reply('assignment', {'package': package});
      }
      if (method == 'POST' && path == '/v1/submissions') {
        final envelope = NorieLanEnvelope.decode(body,
            expectedType: 'submission', expectedSessionId: session.sessionId);
        final package = envelope.payload['package'];
        if (package is! String) return error(400);
        final submission = NorieClassroomCodec.decodeSubmission(package);
        final frozen = packages[submission.assignmentId];
        if (frozen == null) return error(409);
        final current = store.assignments
            .where((a) => a.id == submission.assignmentId)
            .firstOrNull;
        if (current == null ||
            NorieClassroomCodec.encodeAssignment(current) != frozen) {
          return error(409);
        }
        final accepted = await store.recordSubmission(submission,
            stillCurrent: stillCurrent);
        _guard();
        final key = submission.learnerAlias.toLowerCase();
        _peers[key] = NorieLanPeer(
            alias: submission.learnerAlias,
            lastSeen: DateTime.now().toUtc(),
            submissions: store.submissions
                .where((s) =>
                    packages.containsKey(s.assignmentId) &&
                    s.learnerAlias.toLowerCase() == key)
                .length);
        changed();
        return reply(
            'ack', {'submission_id': submission.id, 'accepted': accepted});
      }
      return error(404);
    } on FormatException {
      return error(400);
    } on StateError {
      return error(409);
    } catch (_) {
      return error(503);
    }
  }

  static NorieLanResponse error(int status) => NorieLanResponse(
      status,
      jsonEncode({
        'error': switch (status) {
          401 => 'Classroom code or session is invalid.',
          429 => 'Too many classroom join attempts. Try again later.',
          413 => 'Classroom message is too large.',
          404 => 'Classroom item unavailable.',
          409 => 'Classroom state changed. Reconnect or retry.',
          _ => 'Classroom request could not be completed.'
        }
      }));
}
