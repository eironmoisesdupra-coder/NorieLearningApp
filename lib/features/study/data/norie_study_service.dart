import 'dart:async';

import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:fsrs/fsrs.dart' as fsrs;
import 'package:http/http.dart' as http;
import 'package:flutter/foundation.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/cloud/supabase_config.dart';
import '../domain/norie_study_models.dart';
import 'norie_study_offline_store.dart';
import 'norie_local_job_client.dart';

class NorieStudyService {
  NorieStudyService._() : _clientOverride = null;

  @visibleForTesting
  NorieStudyService.forTesting(SupabaseClient client)
      : _clientOverride = client;

  final SupabaseClient? _clientOverride;

  static final NorieStudyService instance = NorieStudyService._();
  static const localEnabled = bool.fromEnvironment('NORIE_LOCAL_AI');
  static const localUrl = String.fromEnvironment('NORIE_LOCAL_AI_URL',
      defaultValue: 'http://127.0.0.1:8752');
  static bool supportsLocalMode(NorieStudyGenerationMode mode) => const [
        NorieStudyGenerationMode.multipleChoice,
        NorieStudyGenerationMode.identification,
        NorieStudyGenerationMode.flashcards,
        NorieStudyGenerationMode.mixed,
      ].contains(mode);

  static const _bucket = 'study-sources';
  static const _setProjection =
      'id,user_id,title,source_type,source_name,generation_mode,requested_count,status,topic_tag,ai_model,created_at,study_questions(id,position,kind,prompt,options,correct_values,explanation,source_excerpt,topic_tag,difficulty,ordered_items),study_attempts(xp_awarded,total_count)';

  SupabaseClient? get _client =>
      _clientOverride ?? (localEnabled ? null : NorieSupabase.client);

  final _localJobs = NorieLocalJobClient(base: Uri.parse(localUrl));

  Future<Map<String, dynamic>> _localPost(
      String path, Map<String, dynamic> payload,
      {void Function(Map<String, dynamic>)? onProgress}) {
    return _localJobs.run(path == '/api/ask' ? 'ask' : 'generate', payload,
        onProgress: onProgress);
  }

  bool _syncInProgress = false;
  NorieStudyOfflineStore get _offlineStore =>
      NorieStudyOfflineStore(_client?.auth.currentUser?.id ?? 'local');

  NorieStudyOfflineStore _storeFor(NorieStudySet studySet) {
    final store = _offlineStore;
    if (studySet.ownerId != null && studySet.ownerId != store.userId) {
      throw StateError('Sign in to the account that owns this deck.');
    }
    return store;
  }

  Future<Map<String, fsrs.Card>> reviewCards(NorieStudySet studySet) =>
      _storeFor(studySet).reviewCards(studySet.id);

  Future<DateTime> reviewCard(
          NorieStudySet studySet, String questionId, fsrs.Rating rating) =>
      _storeFor(studySet).reviewCard(studySet.id, questionId, rating);

  Future<int> rewardAnswer(
      NorieStudySet studySet, NorieStudyAnswer answer) async {
    final xp = await _storeFor(studySet).claimAnswerReward(studySet.id, answer);
    if (xp > 0) {
      NorieProgression.instance.addXp(xp);
      NorieProgression.instance.addCredits(1);
    }
    return xp;
  }

  Future<NorieStudySet> editCard(
      NorieStudySet studySet, NorieStudyQuestion question,
      {bool deleted = false}) async {
    final store = _storeFor(studySet);
    await store.editCard(studySet, question, deleted: deleted);
    unawaited(syncPendingAttempts());
    return (await store.getSet(studySet.id))!;
  }

  Future<NorieAiQuota?> getAiQuota() async {
    final client = _client;
    if (client == null || client.auth.currentUser == null) return null;

    try {
      final raw = await client
          .rpc('get_my_ai_quota')
          .timeout(const Duration(seconds: 5));
      if (raw is Map) {
        return NorieAiQuota.fromMap(Map<String, dynamic>.from(raw));
      }
    } catch (_) {
      // Quota display is advisory on the client; enforcement remains server-side.
    }
    return null;
  }

  Future<List<NorieStudySet>> listStudySets({bool refresh = false}) async {
    final store = _offlineStore;
    final cached = await store.listSets();
    unawaited(syncPendingAttempts());
    if (cached.isNotEmpty && !refresh) {
      unawaited(
          _fetchStudySets(store).then<void>((_) {}, onError: (Object _) {}));
      return cached;
    }
    return _fetchStudySets(store);
  }

  Future<List<NorieStudySet>> _fetchStudySets(
      NorieStudyOfflineStore store) async {
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null || user.id != store.userId) {
      return store.listSets();
    }

    try {
      final rows = await client
          .from('study_sets')
          .select(_setProjection)
          .eq('user_id', user.id)
          .order('created_at', ascending: false)
          .timeout(const Duration(seconds: 8));

      final sets = <NorieStudySet>[];
      for (final raw in rows) {
        final set =
            await _cacheRemoteSet(Map<String, dynamic>.from(raw), store);
        if (set.questions.isNotEmpty) sets.add(set);
      }
      final remoteIds = rows.map((row) => row['id'].toString()).toSet();
      for (final cached in await store.listSets()) {
        if (!remoteIds.contains(cached.id)) await store.removeSet(cached.id);
      }
      return sets;
    } catch (_) {
      final cached = await store.listSets();
      if (cached.isNotEmpty) return cached;
      throw StateError(
          'Your study library could not be loaded. Check your connection or try again later.');
    }
  }

  Future<NorieStudySet> _cacheRemoteSet(
      Map<String, dynamic> map, NorieStudyOfflineStore store) async {
    final questions = (map['study_questions'] as List? ?? [])
        .map((row) => NorieStudyQuestion.fromMap(
              Map<String, dynamic>.from(row as Map),
            ))
        .toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    final set = NorieStudySet.fromMap(map, questions: questions);
    final attempts = map['study_attempts'] as List? ?? [];
    if (attempts.any((row) =>
        row is Map &&
        ((row['xp_awarded'] as num? ?? 0) > 0 ||
            (row['total_count'] as num? ?? 0) > 0))) {
      await store.markRewarded(set.id);
    }
    await store.saveSet(set);
    return (await store.getSet(set.id)) ?? set;
  }

  Future<NorieStudySet?> getStudySet(String id) async {
    final store = _offlineStore;
    final cached = await store.getSet(id);
    if (cached != null) {
      unawaited(_fetchStudySet(id, store));
      return cached;
    }
    return _fetchStudySet(id, store);
  }

  Future<NorieStudySet?> _fetchStudySet(
      String id, NorieStudyOfflineStore store) async {
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null || user.id != store.userId) {
      return store.getSet(id);
    }

    try {
      final setRow = await client
          .from('study_sets')
          .select(_setProjection)
          .eq('id', id)
          .eq('user_id', user.id)
          .maybeSingle()
          .timeout(const Duration(seconds: 8));

      if (setRow == null) {
        await store.removeSet(id);
        return null;
      }

      return await _cacheRemoteSet(Map<String, dynamic>.from(setRow), store);
    } catch (_) {
      return store.getSet(id);
    }
  }

  Future<String> uploadSource({
    required Uint8List bytes,
    required String filename,
    required String contentType,
  }) async {
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null) {
      throw StateError(
          'Connect to the internet and sign in to upload AI study material.');
    }
    if (bytes.isEmpty) {
      throw StateError('The selected file is empty.');
    }
    if (bytes.length > 10 * 1024 * 1024) {
      throw StateError('Study source files are limited to 10 MB.');
    }

    final safeName = filename
        .replaceAll(RegExp(r'[^A-Za-z0-9._-]'), '_')
        .replaceAll(RegExp(r'_+'), '_');
    final path =
        '${user.id}/${DateTime.now().microsecondsSinceEpoch}_$safeName';

    try {
      await client.storage
          .from(_bucket)
          .uploadBinary(
            path,
            bytes,
            fileOptions: FileOptions(
              contentType: contentType,
              upsert: false,
            ),
          )
          .timeout(const Duration(seconds: 30));
    } catch (_) {
      throw StateError(
          'Uploading AI study material needs an internet connection. Try again when connected.');
    }

    return path;
  }

  Future<NorieStudySet> generateFromSource({
    required String title,
    required String sourceType,
    required NorieStudyGenerationMode mode,
    required int questionCount,
    String sourceText = '',
    String sourcePath = '',
    String sourceName = '',
    String mimeType = '',
    String topicTag = '',
    void Function(Map<String, dynamic>)? onLocalProgress,
  }) async {
    if (localEnabled) {
      final data = await _localPost(
          '/api/generate',
          {
            'title': title,
            'source_type': sourceType,
            'source_text': sourceText,
            'mode': mode.wireValue,
            'question_count': questionCount,
            'topic_tag': topicTag,
          },
          onProgress: onLocalProgress);
      final questions = (data['questions'] as List)
          .map((raw) =>
              NorieStudyQuestion.fromMap(Map<String, dynamic>.from(raw as Map)))
          .toList();
      final set = NorieStudySet.fromMap(data, questions: questions);
      await _offlineStore.saveSet(set);
      return set;
    }
    final client = _client;
    if (client == null || client.auth.currentUser == null) {
      throw StateError(
          'Connect to the internet and sign in to generate an AI quiz. Built-in quizzes work offline.');
    }

    try {
      final response = await client.functions.invoke(
        'norie-ai-gateway',
        body: {
          'action': 'generate_study_set',
          'payload': {
            'title':
                title.trim().isEmpty ? 'Generated Study Set' : title.trim(),
            'source_type': sourceType,
            'source_text': sourceText,
            'source_path': sourcePath,
            'source_name': sourceName,
            'mime_type': mimeType,
            'mode': mode.wireValue,
            'question_count': questionCount,
            'topic_tag': topicTag.trim(),
          },
        },
      ).timeout(const Duration(seconds: 90));

      final data = response.data;
      if (data is! Map) {
        throw StateError('Norie received an invalid AI response.');
      }

      final error = data['error']?.toString();
      if (error != null && error.isNotEmpty) {
        throw StateError(_friendlyAiError(error, data['message']?.toString()));
      }

      final id = data['study_set_id']?.toString();
      if (id == null || id.isEmpty) {
        throw StateError('Norie could not create the study set.');
      }

      final set = await getStudySet(id);
      if (set == null) {
        throw StateError('The generated study set could not be loaded.');
      }
      return set;
    } on FunctionException catch (error) {
      final details = error.details;
      if (details is Map) {
        throw StateError(_friendlyAiError(
          details['error']?.toString() ?? 'generation_failed',
          details['message']?.toString(),
        ));
      }
      throw StateError(
          'The AI service returned an error (${error.status}). Try again later.');
    } on TimeoutException {
      throw StateError(
          'Generation is taking longer than expected. Check your saved study sets before retrying.');
    } catch (error) {
      final message = error.toString();
      if (message.contains('ai_not_configured')) {
        throw StateError(
          'The Norie AI provider is not configured on the server yet.',
        );
      }
      if (error is StateError) rethrow;
      throw StateError(
        'Norie could not generate this AI quiz. Check your internet connection and try again.',
      );
    }
  }

  Future<String> askSource({
    required String studySetId,
    required String question,
  }) async {
    if (localEnabled) {
      final data = await _localPost(
          '/api/ask', {'study_set_id': studySetId, 'question': question});
      return data['answer'] as String;
    }
    final client = _client;
    if (client == null || client.auth.currentUser == null) {
      throw StateError('Connect to the internet and sign in to use Ask Norie.');
    }

    final quota = await getAiQuota();
    if (quota != null && !quota.canAskNorie) {
      throw StateError(
        'Daily Ask Norie limit reached. Your allowance resets tomorrow.',
      );
    }

    try {
      final response = await client.functions.invoke(
        'norie-ai-gateway',
        body: {
          'action': 'study_qa',
          'payload': {
            'study_set_id': studySetId,
            'question': question.trim(),
          },
        },
      ).timeout(const Duration(seconds: 45));
      final data = response.data;
      if (data is Map && data['answer'] != null) {
        return data['answer'].toString();
      }
      final error = data is Map ? data['error']?.toString() : null;
      if (error == 'ai_not_configured') {
        throw StateError(
          'The Norie AI provider is not configured on the server yet.',
        );
      }
      throw StateError('Norie could not answer from this source.');
    } catch (error) {
      if (error is StateError) rethrow;
      throw StateError(
          'Ask Norie needs an internet connection. Check your connection and try again.');
    }
  }

  Future<NorieStudyAttemptResult> recordAttempt({
    required NorieStudySet studySet,
    required List<NorieStudyAnswer> answers,
  }) async {
    final store = _offlineStore;
    if (studySet.ownerId != null && studySet.ownerId != store.userId) {
      throw StateError(
          'Sign back in to the account that owns this saved quiz to save your results.');
    }
    final result = await store.recordAttempt(
      studySet: studySet,
      answers: answers,
    );

    NorieProgression.instance.recordGeneratedStudyAttempt(
      correct: result.correct,
      total: result.total,
      xpAwarded: result.xpAwarded,
      topic: studySet.topicTag ?? studySet.title,
    );

    unawaited(syncPendingAttempts());
    return result;
  }

  Future<void> syncPendingAttempts() async {
    if (_syncInProgress) return;
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return;
    final store = NorieStudyOfflineStore(user.id);
    _syncInProgress = true;
    try {
      for (final change in await store.pendingCardChanges()) {
        if (client.auth.currentUser?.id != user.id) return;
        try {
          if (change['deleted'] == true) {
            await client
                .from('study_questions')
                .delete()
                .eq('id', change['id'])
                .eq('study_set_id', change['study_set_id'])
                .timeout(const Duration(seconds: 8));
          } else {
            await _syncCardChange(client, user.id, store, change);
            continue;
          }
          await store.acknowledgeCardChange(
              change['id'] as String, change['revision'] as String);
        } catch (_) {
          // Retain this edit, but do not block unrelated edits or results.
        }
      }
      for (final attempt in await store.pendingAttempts()) {
        if (client.auth.currentUser?.id != user.id) return;
        // Stable IDs make retries safe even if a response is lost after insert.
        try {
          await client
              .from('study_attempts')
              .upsert(
                attempt,
                onConflict: 'id',
                ignoreDuplicates: true,
              )
              .timeout(const Duration(seconds: 8));
        } on PostgrestException catch (error) {
          // A quiz removed on another device cannot accept new attempts.
          // Acknowledge this permanent failure so later results can upload.
          if (error.code != '23503') rethrow;
        }
        await store.acknowledgeAttempt(attempt['id'] as String);
      }
    } catch (_) {
      // Preserve the queue and local results for the next online visit.
    } finally {
      _syncInProgress = false;
    }
  }

  Future<void> _syncCardChange(SupabaseClient client, String ownerId,
      NorieStudyOfflineStore store, Map<String, dynamic> original) async {
    var change = original;
    for (var attempt = 0; attempt < 2; attempt++) {
      if (client.auth.currentUser?.id != ownerId) return;
      try {
        await client.from('study_questions').upsert({
          ...Map<String, dynamic>.from(change['question'] as Map),
          'study_set_id': change['study_set_id'],
        }).timeout(const Duration(seconds: 8));
        await store.acknowledgeCardChange(
            change['id'] as String, change['revision'] as String);
        return;
      } on PostgrestException catch (error) {
        if (error.code != '23505' || attempt != 0) rethrow;
        final rows = await client
            .from('study_questions')
            .select('position')
            .eq('study_set_id', change['study_set_id'])
            .order('position', ascending: false)
            .limit(1)
            .timeout(const Duration(seconds: 8));
        if (client.auth.currentUser?.id != ownerId) return;
        final next =
            rows.isEmpty ? 0 : (rows.first['position'] as num).toInt() + 1;
        final updated = await store.repositionCardChange(
            change['id'] as String, change['revision'] as String, next);
        if (updated == null) return;
        change = updated;
      }
    }
  }

  Future<void> deleteStudySet(NorieStudySet studySet) async {
    if (localEnabled) {
      final response = await http
          .delete(Uri.parse('$localUrl/api/sets/${studySet.id}'))
          .timeout(const Duration(seconds: 10));
      if (response.statusCode != 200) {
        throw StateError('Could not delete the local source.');
      }
      await _offlineStore.removeSet(studySet.id);
      return;
    }
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null) {
      throw StateError(
          'Connect to the internet and sign in to delete this study set.');
    }

    final setRow = await client
        .from('study_sets')
        .select('source_path')
        .eq('id', studySet.id)
        .eq('user_id', user.id)
        .maybeSingle()
        .timeout(const Duration(seconds: 8));

    final path = setRow?['source_path']?.toString();
    await client
        .from('study_sets')
        .delete()
        .eq('id', studySet.id)
        .eq('user_id', user.id)
        .timeout(const Duration(seconds: 8));
    await NorieStudyOfflineStore(user.id).removeSet(studySet.id);

    if (path != null && path.isNotEmpty) {
      try {
        await client.storage
            .from(_bucket)
            .remove([path]).timeout(const Duration(seconds: 8));
      } catch (_) {
        // The database record is already deleted; storage cleanup is best effort.
      }
    }
  }

  static String _friendlyAiError(String code, String? message) {
    if (message != null && message.trim().isNotEmpty) return message.trim();

    return switch (code) {
      'ai_not_configured' =>
        'The Norie AI provider is not configured on the server yet.',
      'source_too_short' =>
        'Add more source material before generating questions.',
      'source_too_long' => 'The pasted source is too long for this generator.',
      'no_supported_questions' =>
        'The source did not contain enough supported material for a study set.',
      'source_download_failed' =>
        'Norie could not read the uploaded source file.',
      'daily_ai_limit_reached' =>
        'Daily AI generation limit reached. Your free allowance resets tomorrow.',
      'daily_qa_limit_reached' =>
        'Daily Ask Norie limit reached. Your allowance resets tomorrow.',
      'quota_check_failed' =>
        'Norie could not check your AI allowance right now.',
      _ => 'Norie could not generate this study set right now.',
    };
  }
}
