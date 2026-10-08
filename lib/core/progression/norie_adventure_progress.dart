import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../quiz/quiz_result_summary.dart';

class NorieLessonEvidence {
  const NorieLessonEvidence(
      {this.firstPassedAt,
      this.retainedAt,
      this.lastAttemptAt,
      this.bestPercent = 0,
      this.lastPercent = 0,
      this.missedQuestionIds = const [],
      this.priorityConcepts = const []});
  final DateTime? firstPassedAt, retainedAt, lastAttemptAt;
  final int bestPercent, lastPercent;
  final List<String> missedQuestionIds, priorityConcepts;
  Map<String, dynamic> toJson() => {
        'first_passed_at': firstPassedAt?.toIso8601String(),
        'retained_at': retainedAt?.toIso8601String(),
        'last_attempt_at': lastAttemptAt?.toIso8601String(),
        'best_percent': bestPercent,
        'last_percent': lastPercent,
        'missed_question_ids': missedQuestionIds,
        'priority_concepts': priorityConcepts,
      };
  static NorieLessonEvidence fromJson(Map<String, dynamic> value) =>
      NorieLessonEvidence(
        firstPassedAt: DateTime.tryParse(value['first_passed_at'] ?? ''),
        retainedAt: DateTime.tryParse(value['retained_at'] ?? ''),
        lastAttemptAt: DateTime.tryParse(value['last_attempt_at'] ?? ''),
        bestPercent: value['best_percent'],
        lastPercent: value['last_percent'],
        missedQuestionIds: List<String>.from(value['missed_question_ids']),
        priorityConcepts: List<String>.from(value['priority_concepts']),
      );
}

/// Local learning evidence, separate from XP and server-verified league scores.
/// Imports replace all in-memory fields synchronously inside the account guard.
class NorieAdventureProgress extends ChangeNotifier {
  static final instance = NorieAdventureProgress();
  static const _key = 'norie.adventure.v1';
  static const independentThreshold = 80;
  static const reviewDelay = Duration(hours: 24);
  final Map<String, NorieLessonEvidence> _evidence = {};
  final Map<String, String> _trophies = {};
  final Set<String> _receipts = {};
  Future<void> _writes = Future.value();
  int _ownershipRevision = 0;
  int get ownershipRevision => _ownershipRevision;
  Set<String> get trophyIds => Set.unmodifiable(_trophies.keys);
  NorieLessonEvidence? evidenceFor(String topicId) => _evidence[topicId];
  int starCount(String topicId, {required bool completed}) {
    final item = evidenceFor(topicId);
    return (completed ? 1 : 0) +
        (item?.firstPassedAt != null ? 1 : 0) +
        (item?.retainedAt != null ? 1 : 0);
  }

  bool isReviewDue(String topicId, {DateTime? at}) {
    final item = evidenceFor(topicId);
    return item?.firstPassedAt != null &&
        item?.retainedAt == null &&
        !(at ?? DateTime.now())
            .toUtc()
            .isBefore(item!.firstPassedAt!.add(reviewDelay));
  }

  Future<void> load() async {
    final owner = _ownershipRevision;
    final prefs = await SharedPreferences.getInstance();
    if (owner != _ownershipRevision) return;
    final raw = prefs.getString(_key);
    Map<String, dynamic> value = emptyState;
    if (raw != null) {
      try {
        value = validateState(jsonDecode(raw));
      } catch (_) {
        /* Preserve other learning state when this optional slice is damaged. */
      }
    }
    applyValidatedState(value, persist: false);
  }

  static Map<String, dynamic> get emptyState => {
        'version': 1,
        'evidence': <String, dynamic>{},
        'trophies': <String, String>{},
        'receipts': <String>[]
      };
  Map<String, dynamic> exportState() => {
        'version': 1,
        'evidence': _evidence.map((k, v) => MapEntry(k, v.toJson())),
        'trophies': Map<String, String>.of(_trophies),
        'receipts': _receipts.toList()..sort()
      };

  static Map<String, dynamic> mergePermanent(
      Map<String, dynamic> primary, Map<String, dynamic> secondary) {
    final a = validateState(primary), b = validateState(secondary);
    final evidence = Map<String, dynamic>.from(a['evidence']);
    for (final entry in (b['evidence'] as Map).entries) {
      final older =
          NorieLessonEvidence.fromJson(Map<String, dynamic>.from(entry.value));
      final existing = evidence[entry.key];
      if (existing == null) {
        evidence[entry.key as String] = older.toJson();
        continue;
      }
      final newer =
          NorieLessonEvidence.fromJson(Map<String, dynamic>.from(existing));
      final recent = older.lastAttemptAt != null &&
              (newer.lastAttemptAt == null ||
                  older.lastAttemptAt!.isAfter(newer.lastAttemptAt!))
          ? older
          : newer;
      final first = newer.firstPassedAt == null
          ? older.firstPassedAt
          : older.firstPassedAt == null
              ? newer.firstPassedAt
              : older.firstPassedAt!.isBefore(newer.firstPassedAt!)
                  ? older.firstPassedAt
                  : newer.firstPassedAt;
      final retained = newer.retainedAt ?? older.retainedAt;
      evidence[entry.key as String] = NorieLessonEvidence(
              firstPassedAt: first,
              retainedAt: retained,
              lastAttemptAt: recent.lastAttemptAt,
              bestPercent: newer.bestPercent > older.bestPercent
                  ? newer.bestPercent
                  : older.bestPercent,
              lastPercent: recent.lastPercent,
              missedQuestionIds: recent.missedQuestionIds,
              priorityConcepts: recent.priorityConcepts)
          .toJson();
    }
    return validateState({
      'version': 1,
      'evidence': evidence,
      'trophies': {...b['trophies'] as Map, ...a['trophies'] as Map},
      'receipts': {
        ...List<String>.from(a['receipts']),
        ...List<String>.from(b['receipts'])
      }.take(10000).toList()
        ..sort()
    });
  }

  static Map<String, dynamic> validateState(Object? raw) {
    if (raw is! Map ||
        raw['version'] != 1 ||
        raw.keys.any((k) => !const {
              'version',
              'evidence',
              'trophies',
              'receipts'
            }.contains(k))) {
      throw const FormatException('Invalid adventure state.');
    }
    final evidence = raw['evidence'],
        trophies = raw['trophies'],
        receipts = raw['receipts'];
    if (evidence is! Map ||
        evidence.length > 10000 ||
        trophies is! Map ||
        trophies.length > 10000) {
      throw const FormatException('Invalid adventure records.');
    }
    List<String> strings(Object? list, int limit) {
      if (list is! List ||
          list.length > limit ||
          list.any((v) => v is! String || v.isEmpty || v.length > 512)) {
        throw const FormatException('Invalid adventure list.');
      }
      return List<String>.from(list);
    }

    final normalized = <String, dynamic>{};
    for (final entry in evidence.entries) {
      final id = entry.key, value = entry.value;
      if (id is! String ||
          id.isEmpty ||
          id.length > 512 ||
          value is! Map ||
          value.keys.any((k) => !const {
                'first_passed_at',
                'retained_at',
                'last_attempt_at',
                'best_percent',
                'last_percent',
                'missed_question_ids',
                'priority_concepts'
              }.contains(k))) {
        throw const FormatException('Invalid lesson evidence.');
      }
      final dates = <String, DateTime?>{};
      for (final key in ['first_passed_at', 'retained_at', 'last_attempt_at']) {
        final date = value[key];
        if (date != null &&
            (date is! String || DateTime.tryParse(date) == null)) {
          throw const FormatException('Invalid evidence date.');
        }
        dates[key] = date == null ? null : DateTime.parse(date).toUtc();
      }
      final first = dates['first_passed_at'], retained = dates['retained_at'];
      if (retained != null &&
          (first == null || retained.isBefore(first.add(reviewDelay)))) {
        throw const FormatException('Invalid delayed review evidence.');
      }
      for (final key in ['best_percent', 'last_percent']) {
        if (value[key] is! int || value[key] < 0 || value[key] > 100) {
          throw const FormatException('Invalid practice percentage.');
        }
      }
      normalized[id] = NorieLessonEvidence(
              firstPassedAt: first,
              retainedAt: retained,
              lastAttemptAt: dates['last_attempt_at'],
              bestPercent: value['best_percent'],
              lastPercent: value['last_percent'],
              missedQuestionIds: strings(value['missed_question_ids'], 1000),
              priorityConcepts: strings(value['priority_concepts'], 2))
          .toJson();
    }
    final normalizedTrophies = <String, String>{};
    for (final entry in trophies.entries) {
      if (entry.key is! String ||
          (entry.key as String).isEmpty ||
          (entry.key as String).length > 512 ||
          entry.value is! String ||
          DateTime.tryParse(entry.value) == null) {
        throw const FormatException('Invalid permanent reward receipt.');
      }
      normalizedTrophies[entry.key as String] = entry.value as String;
    }
    return {
      'version': 1,
      'evidence': normalized,
      'trophies': normalizedTrophies,
      'receipts': strings(receipts, 10000)
    };
  }

  void applyValidatedState(Map<String, dynamic> state, {bool persist = true}) {
    final normalized = validateState(state);
    _ownershipRevision++;
    _evidence
      ..clear()
      ..addAll((normalized['evidence'] as Map).map((k, v) => MapEntry(
          k as String,
          NorieLessonEvidence.fromJson(Map<String, dynamic>.from(v as Map)))));
    _trophies
      ..clear()
      ..addAll(Map<String, String>.from(normalized['trophies']));
    _receipts
      ..clear()
      ..addAll(List<String>.from(normalized['receipts']));
    notifyListeners();
    if (persist) _scheduleSave();
  }

  Future<void> reset() async {
    applyValidatedState(emptyState);
    await flush();
  }

  Future<void> replaceState(Map<String, dynamic> state) async {
    applyValidatedState(state);
    await flush();
  }

  Future<bool> recordAttempt(
      {required String topicId,
      required String attemptId,
      required List<QuizAnswerRecord> answers,
      DateTime? at,
      bool delayedReview = false,
      int? expectedRevision}) async {
    if (expectedRevision != null && expectedRevision != _ownershipRevision) {
      return false;
    }
    final receipt = '$topicId:$attemptId';
    if (_receipts.contains(receipt)) {
      _scheduleSave();
      await flush();
      return expectedRevision == null || expectedRevision == _ownershipRevision;
    }
    if (answers.isEmpty) return false;
    if (answers.length > 1000 || topicId.isEmpty || receipt.length > 512) {
      return false;
    }
    final now = (at ?? DateTime.now()).toUtc();
    final previous = _evidence[topicId] ?? const NorieLessonEvidence();
    final independent = answers.length >= 5 &&
        answers.map((a) => a.questionId).toSet().length == answers.length &&
        answers.every((a) => !a.selfRated && !a.unanswered);
    final percent = (answers.where((a) => a.correct && !a.unanswered).length /
            answers.length *
            100)
        .round();
    final chronological = previous.lastAttemptAt == null ||
        !now.isBefore(previous.lastAttemptAt!);
    final passed = independent &&
        answers.where((a) => a.correct && !a.unanswered).length * 100 >=
            answers.length * independentThreshold &&
        chronological;
    final first = previous.firstPassedAt ?? (passed ? now : null);
    final retained = previous.retainedAt ??
        (passed &&
                delayedReview &&
                previous.firstPassedAt != null &&
                !now.isBefore(previous.firstPassedAt!.add(reviewDelay))
            ? now
            : null);
    final mistakes = answers.where((a) => !a.correct || a.unanswered).toList();
    final conceptCounts = <String, int>{};
    for (final a in mistakes) {
      final label = a.conceptLabel;
      if (label != null && label.isNotEmpty) {
        conceptCounts[label] = (conceptCounts[label] ?? 0) + 1;
      }
    }
    final concepts = conceptCounts.keys.toList()
      ..sort((a, b) => conceptCounts[b]!.compareTo(conceptCounts[a]!));
    _receipts.add(receipt);
    // Retain a bounded receipt set without evicting permanent milestone IDs.
    if (_receipts.length > 10000) _receipts.remove(_receipts.first);
    _evidence[topicId] = NorieLessonEvidence(
        firstPassedAt: first,
        retainedAt: retained,
        lastAttemptAt: chronological ? now : previous.lastAttemptAt,
        bestPercent: passed || independent
            ? (percent > previous.bestPercent ? percent : previous.bestPercent)
            : previous.bestPercent,
        lastPercent: percent,
        missedQuestionIds: mistakes.map((a) => a.questionId).toSet().toList(),
        priorityConcepts: concepts.take(2).toList());
    if (independent &&
        chronological &&
        previous.lastAttemptAt != null &&
        percent >= previous.lastPercent + 20) {
      _trophies.putIfAbsent(
          'improvement:$topicId', () => now.toIso8601String());
    }
    if (retained != null) {
      _trophies.putIfAbsent(
          'mastery:$topicId', () => retained.toIso8601String());
    }
    if (passed && topicId.startsWith('chapter:')) {
      _trophies.putIfAbsent(topicId, () => now.toIso8601String());
    }
    notifyListeners();
    _scheduleSave();
    await flush();
    return expectedRevision == null || expectedRevision == _ownershipRevision;
  }

  /// Old five-lesson completion remains a permanent trophy after expansion.
  void registerGradeCompletions(
      {required String subject,
      required String gradeId,
      required List<String> originalTopicIds,
      required List<String> currentTopicIds,
      required Set<String> completedTopicIds}) {
    final now = DateTime.now().toUtc().toIso8601String();
    var changed = false;
    void award(String id) {
      if (!_trophies.containsKey(id)) {
        _trophies[id] = now;
        changed = true;
      }
    }

    final key = '${subject.toLowerCase()}.$gradeId';
    if (currentTopicIds.isNotEmpty &&
        currentTopicIds.every((id) =>
            completedTopicIds.contains(id) &&
            _evidence[id]?.retainedAt != null)) {
      award('path-mastery:$key');
    }
    if (originalTopicIds.isNotEmpty &&
        originalTopicIds.every(completedTopicIds.contains)) {
      award('grade:$key');
    }
    if (currentTopicIds.length > originalTopicIds.length &&
        currentTopicIds.every(completedTopicIds.contains)) {
      // Actual content IDs identify expansion receipts, independent of list length.
      final added = currentTopicIds
          .where((id) => !originalTopicIds.contains(id))
          .toList()
        ..sort();
      var fingerprint = 2166136261;
      for (final byte in utf8.encode(added.join('|'))) {
        fingerprint = ((fingerprint ^ byte) * 16777619) & 0xffffffff;
      }
      award('expanded:$key:${fingerprint.toRadixString(16)}');
    }
    if (changed) {
      notifyListeners();
      _scheduleSave();
    }
  }

  void _scheduleSave() {
    final revision = _ownershipRevision;
    final json = jsonEncode(exportState());
    _writes = _writes.catchError((Object _) {}).then((_) async {
      final prefs = await SharedPreferences.getInstance();
      if (revision != _ownershipRevision) return;
      if (!await prefs.setString(_key, json)) {
        throw StateError('Could not save learning evidence.');
      }
    });
    // Background milestones may have no caller awaiting this write. Explicit
    // flush still receives the failure and can retry before showing a reward.
    unawaited(_writes.catchError((Object _) {}));
  }

  Future<void> flush({bool retry = false}) {
    if (retry) _scheduleSave();
    return _writes;
  }

  @visibleForTesting
  void resetAsyncQueuesForTesting() {
    _writes = Future<void>.value();
  }
}
