import 'dart:async';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'package:fsrs/fsrs.dart' as fsrs;

import '../domain/norie_study_models.dart';
import '../../curriculum/domain/curriculum_fingerprint.dart';

/// Each account has its own private cache and durable upload queue.
class NorieStudyOfflineStore {
  NorieStudyOfflineStore(this.userId);

  final String userId;
  static final Map<String, Future<void>> _writes = {};
  static final Map<String, Future<void>> _rewardDrains = {};
  String get _key => 'norie.study.$userId.offline.v1';

  Future<Map<String, dynamic>> _read({bool strict = false}) async {
    final preferences = await SharedPreferences.getInstance();
    // Preference reloads for another learner can replace this shared cache
    // while a write is pending. Refresh the platform backend before using a deck.
    // Keep read failures outside the tolerant JSON recovery below.
    await preferences.reload();
    try {
      final value = jsonDecode(preferences.getString(_key) ?? '{}');
      if (value is Map) return Map<String, dynamic>.from(value);
      if (strict) throw const FormatException('Invalid study cache.');
    } catch (_) {
      if (strict) {
        throw StateError(
            'The saved study cache is unreadable. Back it up before recovery.');
      }
      // An invalid cache must not stop ordinary learning.
    }
    return {};
  }

  Future<T> _write<T>(T Function(Map<String, dynamic> state) change) {
    final result = Completer<T>();
    final previous = _writes[userId] ?? Future<void>.value();
    late final Future<void> queued;
    queued = previous.then((_) async {
      try {
        final state = await _read(strict: true);
        final value = change(state);
        final preferences = await SharedPreferences.getInstance();
        if (!await preferences.setString(_key, jsonEncode(state))) {
          throw StateError('Norie could not save this quiz on the device.');
        }
        result.complete(value);
      } catch (error, stack) {
        // Legacy preferences update their memory cache before disk confirms.
        // A failed write must not reopen as a successful save in this process.
        try {
          await (await SharedPreferences.getInstance()).reload();
        } catch (_) {
          // Keep the original storage failure; never report a successful save.
        }
        result.completeError(error, stack);
      }
    }).whenComplete(() {
      if (identical(_writes[userId], queued)) _writes.remove(userId);
    });
    _writes[userId] = queued;
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
        final value = studySet.toMap();
        final questions =
            studySet.questions.map((question) => question.toMap()).toList();
        final changes =
            Map<String, dynamic>.from(state['cardChanges'] as Map? ?? {});
        for (final change in changes.values
            .whereType<Map>()
            .toList()
            .where((change) => change['study_set_id'] == studySet.id)) {
          final remote =
              questions.where((question) => question['id'] == change['id']);
          if (change['synced'] == true &&
              (change['deleted'] == true
                  ? remote.isEmpty
                  : remote.isNotEmpty &&
                      jsonEncode(remote.first) ==
                          jsonEncode(change['question']))) {
            changes.remove(change['id']);
            continue;
          }
          questions.removeWhere((question) => question['id'] == change['id']);
          if (change['deleted'] != true) {
            questions.add(Map<String, dynamic>.from(change['question'] as Map));
          }
        }
        state['cardChanges'] = changes;
        questions.sort((first, second) =>
            (first['position'] as int).compareTo(second['position'] as int));
        value['questions'] = questions;
        sets[studySet.id] = value;
        state['sets'] = sets;
      });

  Future<void> editCard(NorieStudySet set, NorieStudyQuestion question,
          {bool deleted = false}) =>
      _write((state) {
        if (set.isNative) {
          throw StateError(
              'Native question keys are fixed to their checked template.');
        }
        final sets = Map<String, dynamic>.from(state['sets'] as Map? ?? {});
        final value =
            Map<String, dynamic>.from(sets[set.id] as Map? ?? set.toMap());
        final questions = List<dynamic>.from(value['questions'] as List? ?? []);
        questions.removeWhere((raw) => raw is Map && raw['id'] == question.id);
        if (!deleted) questions.add(question.toMap());
        if (questions.isEmpty) {
          throw StateError('Keep at least one card in a deck.');
        }
        questions.sort((first, second) =>
            (first['position'] as int).compareTo(second['position'] as int));
        value['questions'] = questions;
        sets[set.id] = value;
        state['sets'] = sets;
        final changes =
            Map<String, dynamic>.from(state['cardChanges'] as Map? ?? {});
        changes[question.id] = {
          'id': question.id,
          'study_set_id': set.id,
          'question': question.toMap(),
          'deleted': deleted,
          if (set.isNative) 'device_local': true,
          'revision': const Uuid().v4()
        };
        state['cardChanges'] = changes;
        final reviews =
            Map<String, dynamic>.from(state['reviews'] as Map? ?? {});
        final deckReviews =
            Map<String, dynamic>.from(reviews[set.id] as Map? ?? {});
        deckReviews.remove(question.id);
        reviews[set.id] = deckReviews;
        state['reviews'] = reviews;
      });

  Future<List<Map<String, dynamic>>> pendingCardChanges() async =>
      ((await _read())['cardChanges'] as Map? ?? {})
          .values
          .whereType<Map>()
          .where((value) =>
              value['synced'] != true && value['device_local'] != true)
          .map((value) => Map<String, dynamic>.from(value))
          .toList();

  Future<void> acknowledgeCardChange(String id, String revision) =>
      _write((state) {
        final changes =
            Map<String, dynamic>.from(state['cardChanges'] as Map? ?? {});
        if ((changes[id] as Map?)?['revision'] == revision) {
          changes[id]['synced'] = true;
        }
        state['cardChanges'] = changes;
      });

  Future<Map<String, dynamic>?> repositionCardChange(
          String id, String revision, int minimumPosition) =>
      _write((state) {
        final changes =
            Map<String, dynamic>.from(state['cardChanges'] as Map? ?? {});
        final current = changes[id] as Map?;
        if (current == null ||
            current['revision'] != revision ||
            current['deleted'] == true) {
          return null;
        }
        final sets = Map<String, dynamic>.from(state['sets'] as Map? ?? {});
        final set =
            Map<String, dynamic>.from(sets[current['study_set_id']] as Map);
        final questions = List<dynamic>.from(set['questions'] as List);
        var position = minimumPosition;
        for (final question in questions) {
          if (question['id'] != id &&
              (question['position'] as int) >= position) {
            position = (question['position'] as int) + 1;
          }
        }
        final question = {
          ...Map<String, dynamic>.from(current['question'] as Map),
          'position': position,
        };
        final updated = {
          ...Map<String, dynamic>.from(current),
          'question': question,
          'revision': const Uuid().v4(),
        };
        questions.removeWhere((raw) => raw['id'] == id);
        questions.add(question);
        questions.sort(
            (a, b) => (a['position'] as int).compareTo(b['position'] as int));
        set['questions'] = questions;
        sets[current['study_set_id']] = set;
        changes[id] = updated;
        state['sets'] = sets;
        state['cardChanges'] = changes;
        return updated;
      });

  Future<void> removeSet(String id) => _write((state) {
        final sets = Map<String, dynamic>.from(state['sets'] as Map? ?? {});
        sets.remove(id);
        final sessions =
            Map<String, dynamic>.from(state['quizSessions'] as Map? ?? {});
        sessions.remove(id);
        state['quizSessions'] = sessions;
        state['sets'] = sets;
        final attempts = List<dynamic>.from(state['attempts'] as List? ?? []);
        attempts.removeWhere(
            (attempt) => attempt is Map && attempt['study_set_id'] == id);
        state['attempts'] = attempts;
        final changes =
            Map<String, dynamic>.from(state['cardChanges'] as Map? ?? {});
        changes.removeWhere(
            (key, value) => value is Map && value['study_set_id'] == id);
        state['cardChanges'] = changes;
        final reviews =
            Map<String, dynamic>.from(state['reviews'] as Map? ?? {});
        reviews.remove(id);
        state['reviews'] = reviews;
      });

  Future<Set<String>> completedNativeIdentities() async {
    final state = await _read(strict: true);
    final rewarded = Set<String>.from(state['rewarded'] as List? ?? const []);
    final identities = <String>{};
    for (final raw in (state['sets'] as Map? ?? {}).values) {
      final set = _decodeSet(raw);
      if (set == null || !set.isNative || !rewarded.contains(set.id)) continue;
      final questions = set.generationMetadata['questions'];
      if (questions is! List) continue;
      for (final q in questions.whereType<Map>()) {
        if (q['identity'] is String) identities.add(q['identity'] as String);
      }
    }
    return Set.unmodifiable(identities);
  }

  String _sessionRevision(NorieStudySet set) =>
      curriculumFingerprint(set.questions.map((q) => q.toMap()).toList());

  Future<Map<String, dynamic>?> loadQuizSession(NorieStudySet set) async {
    final raw =
        ((await _read(strict: true))['quizSessions'] as Map? ?? {})[set.id];
    if (raw == null) return null;
    if (raw is! Map ||
        raw['revision'] != _sessionRevision(set) ||
        raw['snapshot'] is! Map) {
      throw const FormatException(
          'Saved quiz changed or is unreadable. Restart this quiz explicitly.');
    }
    return Map<String, dynamic>.from(raw['snapshot'] as Map);
  }

  Future<void> saveQuizSession(
      NorieStudySet set, Map<String, dynamic> snapshot) {
    if (set.ownerId != null && set.ownerId != userId) {
      throw StateError('Reopen this quiz in its owner account.');
    }
    final detached = jsonDecode(jsonEncode(snapshot));
    return _write((state) {
      final sessions =
          Map<String, dynamic>.from(state['quizSessions'] as Map? ?? {});
      sessions[set.id] = {
        'revision': _sessionRevision(set),
        'snapshot': detached
      };
      state['quizSessions'] = sessions;
    });
  }

  Future<void> clearQuizSession(String id) => _write((state) {
        final sessions =
            Map<String, dynamic>.from(state['quizSessions'] as Map? ?? {});
        sessions.remove(id);
        state['quizSessions'] = sessions;
      });

  Future<void> markRewarded(String id) => _write((state) {
        final rewarded = Set<String>.from(state['rewarded'] as List? ?? []);
        rewarded.add(id);
        state['rewarded'] = rewarded.toList();
      });

  Future<int> claimAnswerReward(String setId, NorieStudyAnswer answer) =>
      _write((state) {
        if (!answer.correct ||
            answer.question.kind == NorieStudyQuestionKind.flashcard) {
          return 0;
        }
        if (Set<String>.from(state['rewarded'] as List? ?? [])
            .contains(setId)) {
          return 0;
        }
        final ledger =
            Map<String, dynamic>.from(state['answerRewards'] as Map? ?? {});
        final rewarded = Set<String>.from(ledger[setId] as List? ?? []);
        if (rewarded.length >= 16 || !rewarded.add(answer.question.id)) {
          return 0;
        }
        ledger[setId] = rewarded.toList();
        state['answerRewards'] = ledger;
        _enqueueReward(state, 'card:$setId:${answer.question.id}', 5, 1);
        return 5;
      });

  Future<Map<String, fsrs.Card>> reviewCards(String setId) async {
    final state = await _read();
    final raw = (state['reviews'] as Map? ?? {})[setId] as Map? ?? {};
    return raw.map((key, value) => MapEntry(key.toString(),
        fsrs.Card.fromMap(Map<String, dynamic>.from(value as Map))));
  }

  Future<DateTime> reviewCard(
          String setId, String questionId, fsrs.Rating rating) =>
      _write((state) {
        final reviews =
            Map<String, dynamic>.from(state['reviews'] as Map? ?? {});
        final deck = Map<String, dynamic>.from(reviews[setId] as Map? ?? {});
        final raw = deck[questionId];
        final card = raw is Map
            ? fsrs.Card.fromMap(Map<String, dynamic>.from(raw))
            : fsrs.Card(cardId: DateTime.now().microsecondsSinceEpoch);
        final reviewed =
            fsrs.Scheduler(enableFuzzing: false).reviewCard(card, rating).card;
        deck[questionId] = reviewed.toMap();
        reviews[setId] = deck;
        state['reviews'] = reviews;
        return reviewed.due;
      });

  Future<NorieStudyAttemptResult> recordAttempt({
    required NorieStudySet studySet,
    required List<NorieStudyAnswer> answers,
  }) =>
      _write((state) {
        final scored = answers
            .where((answer) =>
                answer.question.kind != NorieStudyQuestionKind.flashcard)
            .toList();
        final total = scored.length;
        final correct = scored.where((answer) => answer.correct).length;
        final rewarded = Set<String>.from(state['rewarded'] as List? ?? []);
        final firstRewarded = total > 0 && rewarded.add(studySet.id);
        final paid =
            ((state['answerRewards'] as Map? ?? {})[studySet.id] as List? ?? [])
                    .length *
                5;
        final xpAwarded = firstRewarded
            ? ((20 + correct * 5).clamp(0, 100).toInt() - paid)
                .clamp(0, 100)
                .toInt()
            : 0;
        state['rewarded'] = rewarded.toList();
        if (xpAwarded > 0) {
          _enqueueReward(
              state, 'study-set:${studySet.id}:completion', xpAwarded, 0);
        }
        final attempts = List<dynamic>.from(state['attempts'] as List? ?? []);
        attempts.add({
          'id': const Uuid().v4(),
          'user_id': userId,
          if (studySet.isNative) 'device_local': true,
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
        .where((value) => value['device_local'] != true)
        .map((value) => Map<String, dynamic>.from(value))
        .toList();
  }

  static void _enqueueReward(
      Map<String, dynamic> state, String claim, int xp, int credits) {
    final outbox =
        Map<String, dynamic>.from(state['rewardOutbox'] as Map? ?? {});
    outbox[claim] = {'claim_key': claim, 'xp': xp, 'credits': credits};
    state['rewardOutbox'] = outbox;
  }

  /// Eligibility and this outbox commit together. A receipt leaves the outbox
  /// only after its economy envelope is durable; retrying that receipt is safe.
  Future<Map<String, int>> drainRewardOutbox({
    required bool Function() stillCurrent,
    required bool Function(String claim, int xp, int credits) award,
    required Future<void> Function() flushEconomy,
  }) {
    final result = Completer<Map<String, int>>();
    _rewardDrains[userId] =
        (_rewardDrains[userId] ?? Future<void>.value()).then((_) async {
      final granted = <String, int>{};
      try {
        if (!stillCurrent()) {
          result.complete(granted);
          return;
        }
        final state = await _read();
        if (!stillCurrent()) {
          result.complete(granted);
          return;
        }
        final outbox =
            Map<String, dynamic>.from(state['rewardOutbox'] as Map? ?? {});
        for (final entry in outbox.entries) {
          if (!stillCurrent()) break;
          final receipt = Map<String, dynamic>.from(entry.value as Map);
          if (receipt['claim_key'] != entry.key ||
              receipt['xp'] is! int ||
              receipt['credits'] is! int) {
            throw const FormatException('Invalid saved study reward.');
          }
          final didAward =
              award(entry.key, receipt['xp'] as int, receipt['credits'] as int);
          await flushEconomy();
          if (!stillCurrent()) break;
          await _write((latest) {
            if (!stillCurrent()) return;
            final pending =
                Map<String, dynamic>.from(latest['rewardOutbox'] as Map? ?? {});
            if (jsonEncode(pending[entry.key]) == jsonEncode(receipt)) {
              pending.remove(entry.key);
              latest['rewardOutbox'] = pending;
            }
          });
          if (!stillCurrent()) break;
          if (didAward) granted[entry.key] = receipt['xp'] as int;
        }
        result.complete(granted);
      } catch (error, stack) {
        result.completeError(error, stack);
      }
    });
    return result.future;
  }

  Future<void> acknowledgeAttempt(String id) => _write((state) {
        final attempts = List<dynamic>.from(state['attempts'] as List? ?? []);
        attempts
            .removeWhere((attempt) => attempt is Map && attempt['id'] == id);
        state['attempts'] = attempts;
      });
}
