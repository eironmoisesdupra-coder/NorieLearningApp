class NorieClassroomAssignment {
  const NorieClassroomAssignment(
      {required this.id,
      required this.title,
      required this.subject,
      required this.gradeId,
      required this.topicIds,
      required this.questionIds,
      required this.createdAt,
      this.maxAttempts = 1,
      this.allowHints = false,
      this.teacherNote = '',
      this.catalogSignature = ''});
  final String id, title, subject, gradeId, teacherNote, catalogSignature;
  final List<String> topicIds, questionIds;
  final DateTime createdAt;
  final int maxAttempts;
  final bool allowHints;
  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'subject': subject,
        'grade_id': gradeId,
        'topic_ids': topicIds,
        'question_ids': questionIds,
        'created_at': createdAt.toUtc().toIso8601String(),
        'max_attempts': maxAttempts,
        'allow_hints': allowHints,
        'teacher_note': teacherNote,
        'catalog_signature': catalogSignature
      };
  static NorieClassroomAssignment fromJson(Object? raw) {
    final m = classroomMap(raw);
    final attempts = m['max_attempts'];
    final hints = m['allow_hints'];
    if (attempts is! int || attempts < 1 || attempts > 20 || hints is! bool) {
      throw const FormatException('Invalid classroom policy.');
    }
    return NorieClassroomAssignment(
        id: classroomString(m['id'], 128),
        title: classroomString(m['title'], 160),
        subject: classroomString(m['subject'], 64),
        gradeId: classroomString(m['grade_id'], 32),
        topicIds: _ids(m['topic_ids'], 40),
        questionIds: _ids(m['question_ids'], 100),
        createdAt: _date(m['created_at']),
        maxAttempts: attempts,
        allowHints: hints,
        teacherNote: classroomString(m['teacher_note'], 2000, empty: true),
        catalogSignature:
            classroomString(m['catalog_signature'] ?? '', 16, empty: true));
  }
}

class NorieClassroomSubmission {
  const NorieClassroomSubmission(
      {required this.id,
      required this.assignmentId,
      required this.learnerAlias,
      required this.correct,
      required this.total,
      required this.responses,
      required this.completedAt,
      required this.attemptNumber});
  final String id, assignmentId, learnerAlias;
  final int correct, total, attemptNumber;
  final Map<String, int> responses;
  final DateTime completedAt;
  Map<String, dynamic> toJson() => {
        'id': id,
        'assignment_id': assignmentId,
        'learner_alias': learnerAlias,
        'correct': correct,
        'total': total,
        'attempt_number': attemptNumber,
        'responses': responses,
        'completed_at': completedAt.toUtc().toIso8601String()
      };
  static NorieClassroomSubmission fromJson(Object? raw) {
    final m = classroomMap(raw);
    final correct = m['correct'],
        total = m['total'],
        attempt = m['attempt_number'];
    final responses = classroomMap(m['responses']);
    if (correct is! int ||
        total is! int ||
        total < 1 ||
        total > 100 ||
        correct < 0 ||
        correct > total ||
        attempt is! int ||
        attempt < 1 ||
        attempt > 20 ||
        responses.length != total) {
      throw const FormatException('Invalid classroom result.');
    }
    final mapped = <String, int>{};
    for (final e in responses.entries) {
      classroomString(e.key, 512);
      if (e.value is! int || e.value < 0 || e.value > 20) {
        throw const FormatException('Invalid classroom response.');
      }
      mapped[e.key] = e.value as int;
    }
    return NorieClassroomSubmission(
        id: classroomString(m['id'], 128),
        assignmentId: classroomString(m['assignment_id'], 128),
        learnerAlias: classroomString(m['learner_alias'], 80),
        correct: correct,
        total: total,
        responses: Map.unmodifiable(mapped),
        completedAt: _date(m['completed_at']),
        attemptNumber: attempt);
  }
}

Map<String, dynamic> classroomMap(Object? raw) {
  if (raw is! Map || raw.keys.any((k) => k is! String)) {
    throw const FormatException('Expected a classroom object.');
  }
  return Map<String, dynamic>.from(raw);
}

String classroomString(Object? value, int max, {bool empty = false}) {
  if (value is! String ||
      value.length > max ||
      (!empty && value.trim().isEmpty) ||
      value.contains(RegExp(r'[\x00-\x08\x0B\x0C\x0E-\x1F]'))) {
    throw const FormatException('Invalid classroom text.');
  }
  return value.trim();
}

List<String> _ids(Object? raw, int max) {
  if (raw is! List || raw.isEmpty || raw.length > max) {
    throw const FormatException('Invalid classroom selection.');
  }
  final ids = raw.map((v) => classroomString(v, 512)).toList();
  if (ids.toSet().length != ids.length) {
    throw const FormatException('Duplicate classroom selection.');
  }
  return List.unmodifiable(ids);
}

DateTime _date(Object? raw) {
  if (raw is! String || raw.length > 40) {
    throw const FormatException('Invalid classroom date.');
  }
  final at = DateTime.tryParse(raw);
  if (at == null || at.year < 2000 || at.year > 2200) {
    throw const FormatException('Invalid classroom date.');
  }
  return at.toUtc();
}
