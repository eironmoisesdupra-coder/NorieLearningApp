import 'dart:async';
import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/data/norie_content_catalog.dart';
import 'package:norie_learning/features/content/data/norie_content_repository.dart';
import 'package:norie_learning/features/content/domain/norie_content_models.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UnavailableCloud implements NorieContentRepository {
  final ready = Completer<void>();
  @override
  Future<List<NorieSubjectContent>> getSubjects() async {
    await ready.future;
    return [];
  }

  @override
  Future<List<NorieTopicContent>> getTopicsForCategory(String id) async {
    await ready.future;
    return [];
  }

  @override
  Future<NorieTopicContent?> getTopic(String id) async {
    await ready.future;
    return null;
  }
}

void main() {
  test('bundled Chemistry opens while the cloud never responds', () async {
    SharedPreferences.setMockInitialValues({});
    final cloud = UnavailableCloud();
    final repository = LocalFirstNorieContentRepository(remote: cloud);
    try {
      final topics = await repository
          .getTopicsForCategory('chemistry')
          .timeout(const Duration(milliseconds: 200));
      expect(topics, hasLength(4));
      final topic = await repository
          .getTopic('science.chemistry.atomic-structure')
          .timeout(const Duration(milliseconds: 200));
      expect(topic!.title, 'Atomic Structure');
      expect(topic.quiz.questions, hasLength(20));
    } finally {
      cloud.ready.complete();
      await Future<void>.delayed(Duration.zero);
    }
  });

  test('downloaded lessons remain readable without waiting for the cloud',
      () async {
    final map = NorieContentCatalog.atomicStructure.toJson();
    map['title'] = 'Downloaded atomic lesson';
    SharedPreferences.setMockInitialValues({
      'norie.content.topic.science.chemistry.atomic-structure': jsonEncode(map),
    });
    final cloud = UnavailableCloud();
    try {
      final topic = await LocalFirstNorieContentRepository(remote: cloud)
          .getTopic('science.chemistry.atomic-structure')
          .timeout(const Duration(milliseconds: 200));
      expect(topic!.title, 'Downloaded atomic lesson');
    } finally {
      cloud.ready.complete();
      await Future<void>.delayed(Duration.zero);
    }
  });
}
