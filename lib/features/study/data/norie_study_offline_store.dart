import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

import '../domain/norie_study_models.dart';

/// Each account has its own private cache and durable upload queue.
class NorieStudyOfflineStore {
  NorieStudyOfflineStore(this.userId);

  final String userId;
  static final Map<String, Future<void>> _writes = {};
  String get _key => 'norie.study.$userId.offline.v1';

  Future<Map<String, dynamic>> _read() async {
    final preferences = await SharedPreferences.getInstance();
    try {
      final value = jsonDecode(preferences.getString(_key) ?? '{}');
      if (value is Map) return Map<String, dynamic>.from(value);
    } catch (_) {
      // An invalid cache must not stop ordinary learning.
    }
    return {};
  }

  Future<T> _write<T>(T Function(Map<String, dynamic> state) change) {
    final result = Completer<T>();
    _writes[userId] = (_writes[userId] ?? Future<void>.value()).then((_) async {
      try {
        final state = await _read();
        final value = change(state);
        final preferences = await SharedPreferences.getInstance();
        if (!await preferences.setString(_key, jsonEncode(state))) {
          throw StateError('Norie could not save this quiz on the device.');
        }
        result.complete(value);
      } catch (error, stack) {
        result.completeError(error, stack);
      }
    });
    return result.future;
  }

  NorieStudySet? _decodeSet(Object? raw) {
    try {
      if (raw is! Map) return null;
      final map = Map<String, dynamic>.from(raw);
      final questions = (map['questions'] as List? ?? [])
          .map((question) => NorieStudyQuestion.fromMap(
                Map<String, dynamic>.from(question as Map),
              ))
          .toList();
      if (questions.isEmpty) return null;
      map['user_id'] = userId;
      return NorieStudySet.fromMap(map, questions: questions);
    } catch (_) {
      return null;
    }
  }

  Future<List<NorieStudySet>> listSets() async {
    final state = await _read();
    final sets = (state['sets'] as Map? ?? {})
        .values
        .map(_decodeSet)
        .whereType<NorieStudySet>()
        .toList();
    sets.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    return sets;
  }

  Future<NorieStudySet?> getSet(String id) async {
    final state = await _read();
    return _decodeSet((state['sets'] as Map? ?? {})[id]);
  }

  Future<void> saveSet(NorieStudySet studySet) => _write((state) {
        if (studySet.questions.isEmpty) return;
        final sets = Map<String, dynamic>.from(state['sets'] as Map? ?? {});
        sets[studySet.id] = studySet.toMap();
        state['sets'] = sets;
      });

  Future<void> removeSet(String id) => _write((state) {
        final sets = Map<String, dynamic>.from(state['sets'] as Map? ?? {});
        sets.remove(id);
        state['sets'] = sets;
        final attempts = List<dynamic>.from(state['attempts'] as List? ?? []);
        attempts.removeWhere(
            (attempt) => attempt is Map && attempt['study_set_id'] == id);
        state['attempts'] = attempts;
      });

  Future<void> markRewarded(String id) => _write((state) {
        final rewarded = Set<String>.from(state['rewarded'] as List? ?? []);
        rewarded.add(id);
        state['rewarded'] = rewarded.toList();
      });

  Future<NorieStudyAttemptResult> recordAttempt({
    required NorieStudySet studySet,
    required List<NorieStudyAnswer> answers,
  }) =>
      _write((state) {
        final total = answers.length;
        final correct = answers.where((answer) => answer.correct).length;
        final rewarded = Set<String>.from(state['rewarded'] as List? ?? []);
        final firstRewarded = total > 0 && rewarded.add(studySet.id);
        final xpAwarded =
            firstRewarded ? (20 + correct * 5).clamp(0, 100).toInt() : 0;
        state['rewarded'] = rewarded.toList();
        final attempts = List<dynamic>.from(state['attempts'] as List? ?? []);
        attempts.add({
          'id': const Uuid().v4(),
          'user_id': userId,
          'study_set_id': studySet.id,
          'correct_count': correct,
          'total_count': total,
          'xp_awarded': xpAwarded,
          'completed_at': DateTime.now().toUtc().toIso8601String(),
          'answers': {
            for (final answer in answers)
              answer.question.id: {
                'response': answer.response,
                'correct': answer.correct,
              }
          },
        });
        state['attempts'] = attempts;
        return NorieStudyAttemptResult(
          correct: correct,
          total: total,
          xpAwarded: xpAwarded,
          firstRewardedCompletion: firstRewarded,
        );
      });

  Future<List<Map<String, dynamic>>> pendingAttempts() async {
    final state = await _read();
    return (state['attempts'] as List? ?? [])
        .whereType<Map>()
        .map((value) => Map<String, dynamic>.from(value))
        .toList();
  }

  Future<void> acknowledgeAttempt(String id) => _write((state) {
        final attempts = List<dynamic>.from(state['attempts'] as List? ?? []);
        attempts
            .removeWhere((attempt) => attempt is Map && attempt['id'] == id);
        state['attempts'] = attempts;
      });
}
