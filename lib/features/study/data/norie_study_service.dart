import 'dart:async';
import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/cloud/supabase_config.dart';
import '../domain/norie_study_models.dart';
import 'norie_study_offline_store.dart';

class NorieStudyService {
  NorieStudyService._();

  static final NorieStudyService instance = NorieStudyService._();

  static const _bucket = 'study-sources';
  static const _setProjection =
      'id,user_id,title,source_type,source_name,generation_mode,requested_count,status,topic_tag,ai_model,created_at,study_questions(id,position,kind,prompt,options,correct_values,explanation,source_excerpt,topic_tag,difficulty,ordered_items),study_attempts(xp_awarded)';

  SupabaseClient? get _client => NorieSupabase.client;
  bool _syncInProgress = false;
  NorieStudyOfflineStore get _offlineStore =>
      NorieStudyOfflineStore(_client?.auth.currentUser?.id ?? 'local');

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
      unawaited(_fetchStudySets(store));
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
      return store.listSets();
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
    if (attempts
        .any((row) => row is Map && (row['xp_awarded'] as num? ?? 0) > 0)) {
      await store.markRewarded(set.id);
    }
    await store.saveSet(set);
    return set;
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
  }) async {
    final client = _client;
    if (client == null || client.auth.currentUser == null) {
      throw StateError(
          'Connect to the internet and sign in to generate an AI quiz. Built-in quizzes work offline.');
    }

    final quota = await getAiQuota();
    if (quota != null && !quota.canGenerate) {
      throw StateError(
        'Daily AI generation limit reached. Your free allowance resets tomorrow.',
      );
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

  Future<void> deleteStudySet(NorieStudySet studySet) async {
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
