import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/cloud/supabase_config.dart';
import '../domain/norie_content_models.dart';
import 'norie_content_catalog.dart';

abstract interface class NorieContentRepository {
  Future<List<NorieSubjectContent>> getSubjects();
  Future<List<NorieTopicContent>> getTopicsForCategory(String categoryId);
  Future<NorieTopicContent?> getTopic(String id);
}

class NorieContentRepositoryService {
  NorieContentRepositoryService._();

  static final NorieContentRepository instance =
      CloudFirstNorieContentRepository();
}

class CloudFirstNorieContentRepository
    implements NorieContentRepository {
  CloudFirstNorieContentRepository();

  static const _topicCachePrefix = 'norie.content.topic.';
  static const _categoryCachePrefix = 'norie.content.category.';

  @override
  Future<List<NorieSubjectContent>> getSubjects() async {
    final client = NorieSupabase.client;
    if (client == null || client.auth.currentSession == null) {
      return NorieContentCatalog.subjects;
    }

    try {
      final subjectRows = await client
          .from('content_subjects')
          .select('id,title,description,sort_order')
          .eq('is_published', true)
          .order('sort_order');
      final categoryRows = await client
          .from('content_categories')
          .select('id,subject_id,title,description,sort_order')
          .eq('is_published', true)
          .order('sort_order');

      final subjects = <NorieSubjectContent>[];
      for (final rawSubject in subjectRows) {
        final subject = Map<String, dynamic>.from(rawSubject);
        final categories = <NorieCategoryContent>[];

        for (final rawCategory in categoryRows) {
          final category = Map<String, dynamic>.from(rawCategory);
          if (category['subject_id'] != subject['id']) continue;

          final topics = await getTopicsForCategory(
            category['id'].toString(),
          );
          categories.add(
            NorieCategoryContent(
              id: category['id'].toString(),
              title: category['title'].toString(),
              description: category['description']?.toString() ?? '',
              topics: topics,
            ),
          );
        }

        subjects.add(
          NorieSubjectContent(
            id: subject['id'].toString(),
            title: subject['title'].toString(),
            description: subject['description']?.toString() ?? '',
            categories: categories,
          ),
        );
      }

      return subjects.isEmpty
          ? NorieContentCatalog.subjects
          : subjects;
    } catch (_) {
      return NorieContentCatalog.subjects;
    }
  }

  @override
  Future<List<NorieTopicContent>> getTopicsForCategory(
    String categoryId,
  ) async {
    final client = NorieSupabase.client;
    final prefs = await SharedPreferences.getInstance();
    final cacheKey = '$_categoryCachePrefix$categoryId';

    if (client != null && client.auth.currentSession != null) {
      try {
        final rows = await client
            .from('content_topics')
            .select('payload')
            .eq('category_id', categoryId)
            .eq('is_published', true)
            .order('sort_order');

        final topics = <NorieTopicContent>[
          for (final raw in rows)
            if (_parseTopic(raw['payload']) case final topic?)
              topic,
        ]..sort((a, b) => a.order.compareTo(b.order));

        if (topics.isNotEmpty) {
          await prefs.setString(
            cacheKey,
            jsonEncode(topics.map((item) => item.toJson()).toList()),
          );
          for (final topic in topics) {
            await _cacheTopic(prefs, topic);
          }
          return topics;
        }
      } catch (_) {
        // Cached or bundled content is used below.
      }
    }

    final cached = _readTopicList(prefs.getString(cacheKey));
    if (cached.isNotEmpty) return cached;

    final fallback = NorieContentCatalog.topicsForCategory(categoryId)
        .where((topic) => topic.available)
        .toList()
      ..sort((a, b) => a.order.compareTo(b.order));
    return fallback;
  }

  @override
  Future<NorieTopicContent?> getTopic(String id) async {
    final client = NorieSupabase.client;
    final prefs = await SharedPreferences.getInstance();

    if (client != null && client.auth.currentSession != null) {
      try {
        final row = await client
            .from('content_topics')
            .select('payload')
            .eq('id', id)
            .eq('is_published', true)
            .maybeSingle();

        final topic = _parseTopic(row?['payload']);
        if (topic != null) {
          await _cacheTopic(prefs, topic);
          return topic;
        }
      } catch (_) {
        // Cached or bundled content is used below.
      }
    }

    final cached = _parseTopic(
      _decodeJson(prefs.getString('$_topicCachePrefix$id')),
    );
    return cached ?? NorieContentCatalog.topicById(id);
  }

  static NorieTopicContent? _parseTopic(Object? raw) {
    if (raw is! Map) return null;

    try {
      final topic = NorieTopicContent.fromJson(
        Map<String, dynamic>.from(raw),
      );

      if (!_isPlayable(topic)) return null;
      return topic;
    } catch (_) {
      return null;
    }
  }

  static bool _isPlayable(NorieTopicContent topic) {
    if (!topic.available ||
        topic.id.trim().isEmpty ||
        topic.title.trim().isEmpty ||
        topic.lesson.heading.trim().isEmpty ||
        topic.quiz.questions.isEmpty ||
        topic.challenge.rounds.isEmpty) {
      return false;
    }

    return topic.quiz.questions.every(
          (question) => question.hasValidAnswer,
        ) &&
        topic.challenge.rounds.every(
          (round) => round.hasValidAnswer,
        );
  }

  static Future<void> _cacheTopic(
    SharedPreferences prefs,
    NorieTopicContent topic,
  ) =>
      prefs.setString(
        '$_topicCachePrefix${topic.id}',
        jsonEncode(topic.toJson()),
      );

  static List<NorieTopicContent> _readTopicList(String? raw) {
    final decoded = _decodeJson(raw);
    if (decoded is! List) return <NorieTopicContent>[];

    return [
      for (final item in decoded)
        if (_parseTopic(item) case final topic?) topic,
    ]..sort((a, b) => a.order.compareTo(b.order));
  }

  static Object? _decodeJson(String? raw) {
    if (raw == null || raw.isEmpty) return null;
    try {
      return jsonDecode(raw);
    } catch (_) {
      return null;
    }
  }
}

class BundledNorieContentRepository
    implements NorieContentRepository {
  const BundledNorieContentRepository();

  @override
  Future<List<NorieSubjectContent>> getSubjects() async =>
      NorieContentCatalog.subjects;

  @override
  Future<List<NorieTopicContent>> getTopicsForCategory(
    String categoryId,
  ) async =>
      NorieContentCatalog.topicsForCategory(categoryId);

  @override
  Future<NorieTopicContent?> getTopic(String id) async =>
      NorieContentCatalog.topicById(id);
}
