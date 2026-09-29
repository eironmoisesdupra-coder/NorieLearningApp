import 'dart:typed_data';

import 'package:supabase_flutter/supabase_flutter.dart';

import '../../../core/progression/norie_progression.dart';
import '../../../core/cloud/supabase_config.dart';
import '../domain/norie_study_models.dart';

class NorieStudyService {
  NorieStudyService._();

  static final NorieStudyService instance = NorieStudyService._();

  static const _bucket = 'study-sources';

  SupabaseClient? get _client => NorieSupabase.client;

  Future<NorieAiQuota?> getAiQuota() async {
    final client = _client;
    if (client == null || client.auth.currentUser == null) return null;

    try {
      final raw = await client.rpc('get_my_ai_quota');
      if (raw is Map) {
        return NorieAiQuota.fromMap(Map<String, dynamic>.from(raw));
      }
    } catch (_) {
      // Quota display is advisory on the client; enforcement remains server-side.
    }
    return null;
  }

  Future<List<NorieStudySet>> listStudySets() async {
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return const [];

    try {
      final rows = await client
          .from('study_sets')
          .select(
            'id,title,source_type,source_name,generation_mode,requested_count,status,topic_tag,ai_model,created_at',
          )
          .eq('user_id', user.id)
          .order('created_at', ascending: false);

      final sets = <NorieStudySet>[];
      for (final raw in rows) {
        final map = Map<String, dynamic>.from(raw);
        final countRows = await client
            .from('study_questions')
            .select('id')
            .eq('study_set_id', map['id']);
        final placeholders = <NorieStudyQuestion>[
          for (var i = 0; i < countRows.length; i++)
            NorieStudyQuestion(
              id: 'placeholder-$i',
              position: i,
              kind: NorieStudyQuestionKind.singleSelect,
              prompt: '',
              options: const [],
              correctValues: const [],
              explanation: '',
              sourceExcerpt: '',
              difficulty: 'foundation',
            ),
        ];
        sets.add(NorieStudySet.fromMap(map, questions: placeholders));
      }
      return sets;
    } catch (_) {
      return const [];
    }
  }

  Future<NorieStudySet?> getStudySet(String id) async {
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return null;

    try {
      final setRow = await client
          .from('study_sets')
          .select(
            'id,title,source_type,source_name,generation_mode,requested_count,status,topic_tag,ai_model,created_at',
          )
          .eq('id', id)
          .eq('user_id', user.id)
          .maybeSingle();

      if (setRow == null) return null;

      final questionRows = await client
          .from('study_questions')
          .select(
            'id,position,kind,prompt,options,correct_values,explanation,source_excerpt,topic_tag,difficulty,ordered_items',
          )
          .eq('study_set_id', id)
          .order('position');

      final questions = [
        for (final raw in questionRows)
          NorieStudyQuestion.fromMap(
            Map<String, dynamic>.from(raw),
          ),
      ];

      return NorieStudySet.fromMap(
        Map<String, dynamic>.from(setRow),
        questions: questions,
      );
    } catch (_) {
      return null;
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
      throw StateError('Sign in before uploading study material.');
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

    await client.storage.from(_bucket).uploadBinary(
          path,
          bytes,
          fileOptions: FileOptions(
            contentType: contentType,
            upsert: false,
          ),
        );

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
      throw StateError('Sign in before generating a study set.');
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
            'title': title.trim().isEmpty
                ? 'Generated Study Set'
                : title.trim(),
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
      );

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
        'Norie could not generate this study set right now.',
      );
    }
  }

  Future<String> askSource({
    required String studySetId,
    required String question,
  }) async {
    final client = _client;
    if (client == null || client.auth.currentUser == null) {
      throw StateError('Sign in before using source Q&A.');
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
      );
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
      throw StateError('Norie could not answer from this source right now.');
    }
  }

  Future<NorieStudyAttemptResult> recordAttempt({
    required NorieStudySet studySet,
    required List<NorieStudyAnswer> answers,
  }) async {
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null) {
      throw StateError('Sign in before saving a study attempt.');
    }

    final total = answers.length;
    final correct = answers.where((answer) => answer.correct).length;

    final existing = await client
        .from('study_attempts')
        .select('id,xp_awarded')
        .eq('user_id', user.id)
        .eq('study_set_id', studySet.id)
        .gt('xp_awarded', 0)
        .limit(1);

    final firstRewarded = existing.isEmpty;
    final xpAwarded = firstRewarded
        ? (20 + (correct * 5)).clamp(0, 100).toInt()
        : 0;

    final answerMap = <String, dynamic>{
      for (final answer in answers)
        answer.question.id: {
          'response': answer.response,
          'correct': answer.correct,
        },
    };

    await client.from('study_attempts').insert({
      'user_id': user.id,
      'study_set_id': studySet.id,
      'correct_count': correct,
      'total_count': total,
      'answers': answerMap,
      'xp_awarded': xpAwarded,
    });

    NorieProgression.instance.recordGeneratedStudyAttempt(
      correct: correct,
      total: total,
      xpAwarded: xpAwarded,
      topic: studySet.topicTag ?? studySet.title,
    );

    return NorieStudyAttemptResult(
      correct: correct,
      total: total,
      xpAwarded: xpAwarded,
      firstRewardedCompletion: firstRewarded,
    );
  }

  Future<void> deleteStudySet(NorieStudySet studySet) async {
    final client = _client;
    final user = client?.auth.currentUser;
    if (client == null || user == null) return;

    final setRow = await client
        .from('study_sets')
        .select('source_path')
        .eq('id', studySet.id)
        .eq('user_id', user.id)
        .maybeSingle();

    final path = setRow?['source_path']?.toString();
    await client
        .from('study_sets')
        .delete()
        .eq('id', studySet.id)
        .eq('user_id', user.id);

    if (path != null && path.isNotEmpty) {
      try {
        await client.storage.from(_bucket).remove([path]);
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
      'source_too_long' =>
        'The pasted source is too long for this generator.',
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
