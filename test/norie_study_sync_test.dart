import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:norie_learning/features/study/data/norie_study_offline_store.dart';
import 'package:norie_learning/features/study/data/norie_study_service.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';

import 'norie_study_cache_test.dart' show fixture;

Future<SupabaseClient> clientFor(MockClient transport) async {
  final client = SupabaseClient('https://study.test', 'test-key',
      httpClient: transport,
      authOptions: const AuthClientOptions(autoRefreshToken: false));
  final payload = base64Url
      .encode(utf8.encode(jsonEncode({
        'sub': 'alice',
        'exp': DateTime.now().millisecondsSinceEpoch ~/ 1000 + 3600,
      })))
      .replaceAll('=', '');
  await client.auth.setInitialSession(jsonEncode({
    'access_token': 'e30.$payload.signature',
    'refresh_token': 'test-refresh',
    'token_type': 'bearer',
    'expires_in': 3600,
    'user': {
      'id': 'alice',
      'app_metadata': {},
      'user_metadata': {},
      'aud': 'authenticated',
      'created_at': '2026-01-01T00:00:00Z'
    },
  }));
  addTearDown(client.dispose);
  return client;
}

void main() {
  setUp(() => SharedPreferences.setMockInitialValues({}));

  test('collision retry cannot overwrite a newer edit or another learner',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final set = fixture();
    await store.editCard(set, set.questions.single);
    final old = (await store.pendingCardChanges()).single;
    await store.editCard(
        set,
        NorieStudyQuestion.fromMap({
          ...set.questions.single.toMap(),
          'prompt': 'Newer wording',
        }));
    expect(
        await store.repositionCardChange(
            old['id'] as String, old['revision'] as String, 10),
        isNull);
    expect(
        (await store.getSet(set.id))!.questions.single.prompt, 'Newer wording');
    expect(
        await NorieStudyOfflineStore('bob').repositionCardChange(
            old['id'] as String, old['revision'] as String, 10),
        isNull);
    expect(await NorieStudyOfflineStore('bob').listSets(), isEmpty);
  });

  test('position collision retries retained edit and still uploads attempts',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final set = fixture();
    await store.editCard(set, set.questions.single);
    await store.recordAttempt(studySet: set, answers: const []);
    final positions = <int>[];
    var attempts = 0;
    final client = await clientFor(MockClient((request) async {
      if (request.url.path.endsWith('study_attempts')) {
        attempts++;
        return http.Response('', 201);
      }
      if (request.method == 'GET') {
        return http.Response('[{"position":8}]', 200,
            headers: {'content-type': 'application/json'});
      }
      positions.add(jsonDecode(request.body)['position'] as int);
      if (positions.length == 1) {
        return http.Response(
            jsonEncode({'code': '23505', 'message': 'position conflict'}), 409);
      }
      return http.Response('', 201);
    }));
    await NorieStudyService.forTesting(client).syncPendingAttempts();
    expect(positions, [1, 9]);
    expect(attempts, 1);
    expect(await store.pendingCardChanges(), isEmpty);
    expect((await store.getSet(set.id))!.questions.single.position, 9);
  });

  test('failed card remains queued without blocking another card or attempt',
      () async {
    final store = NorieStudyOfflineStore('alice');
    final set = fixture();
    await store.editCard(set, set.questions.single);
    await store.editCard(
        set,
        NorieStudyQuestion.fromMap({
          ...set.questions.single.toMap(),
          'id': 'second',
          'position': 2,
        }));
    await store.recordAttempt(studySet: set, answers: const []);
    var attempts = 0;
    final client = await clientFor(MockClient((request) async {
      if (request.url.path.endsWith('study_attempts')) {
        attempts++;
      } else if (jsonDecode(request.body)['id'] == 'bone-q1') {
        return http.Response(
            jsonEncode({'code': '23503', 'message': 'removed deck'}), 409);
      }
      return http.Response('', 201);
    }));
    await NorieStudyService.forTesting(client).syncPendingAttempts();
    expect(attempts, 1);
    expect((await store.pendingCardChanges()).single['id'], 'bone-q1');
  });

  test('zero remaining cloud XP still restores completed reward eligibility',
      () async {
    final set = fixture();
    final client = await clientFor(MockClient((request) async => http.Response(
        jsonEncode([
          {
            ...set.toMap(),
            'user_id': 'alice',
            'study_questions': set.questions.map((q) => q.toMap()).toList(),
            'study_attempts': [
              {'xp_awarded': 0, 'total_count': 1}
            ],
          }
        ]),
        200,
        headers: {'content-type': 'application/json'})));
    final loaded =
        await NorieStudyService.forTesting(client).listStudySets(refresh: true);
    final store = NorieStudyOfflineStore('alice');
    final answer = NorieStudyAnswer(
        question: set.questions.single,
        response: 'Skull, Femur',
        correct: true);
    expect(await store.claimAnswerReward(set.id, answer), 0);
    final completion =
        await store.recordAttempt(studySet: loaded.single, answers: [answer]);
    expect(completion.xpAwarded, 0);
    expect(completion.firstRewardedCompletion, isFalse);
  });
}
