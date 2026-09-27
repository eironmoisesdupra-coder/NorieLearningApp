import '../domain/norie_content_models.dart';
import 'norie_content_catalog.dart';

abstract interface class NorieContentRepository {
  Future<List<NorieSubjectContent>> getSubjects();
  Future<NorieTopicContent?> getTopic(String id);
}

class BundledNorieContentRepository implements NorieContentRepository {
  const BundledNorieContentRepository();

  @override
  Future<List<NorieSubjectContent>> getSubjects() async =>
      NorieContentCatalog.subjects;

  @override
  Future<NorieTopicContent?> getTopic(String id) async =>
      NorieContentCatalog.topicById(id);
}
