import '../data/curriculum_registry.dart';
import 'curriculum_revision.dart';

enum CurriculumPathNodeKind {
  unit,
  chapter,
  lesson,
  boss,
  review,
  destination,
  variant
}

class CurriculumPathNode {
  CurriculumPathNode(
      {required this.id,
      required this.kind,
      this.reference,
      List<String> prerequisites = const []})
      : prerequisites = List.unmodifiable(prerequisites);
  final String id;
  final CurriculumPathNodeKind kind;
  final CurriculumReference? reference;
  final List<String> prerequisites;
  Map<String, dynamic> toJson() => {
        'id': id,
        'kind': kind.name,
        'reference': reference?.toJson(),
        'prerequisites': prerequisites
      };
  factory CurriculumPathNode.fromJson(Map<String, dynamic> json) =>
      CurriculumPathNode(
          id: json['id'] as String,
          kind: CurriculumPathNodeKind.values.byName(json['kind'] as String),
          reference: json['reference'] == null
              ? null
              : CurriculumReference.fromJson(
                  Map<String, dynamic>.from(json['reference'] as Map)),
          prerequisites:
              List<String>.from(json['prerequisites'] as List? ?? []));
}

class CurriculumPath {
  CurriculumPath(
      {required this.id,
      required this.title,
      required List<CurriculumPathNode> nodes})
      : nodes = List.unmodifiable(nodes);
  final String id;
  final String title;
  final List<CurriculumPathNode> nodes;
  List<String> validate(CurriculumRegistry registry) {
    final issues = <String>[];
    if (id.trim().isEmpty ||
        title.trim().isEmpty ||
        nodes.isEmpty ||
        nodes.length > 256) {
      issues.add('A path needs an ID, title and 1?256 nodes.');
    }
    final seenNodes = <String>{}, seenTopics = <String>{};
    for (final node in nodes) {
      if (node.id.trim().isEmpty || !seenNodes.add(node.id)) {
        issues.add('Node IDs must be nonempty and unique.');
      }
      for (final dependency in node.prerequisites) {
        if (dependency == node.id || !seenNodes.contains(dependency)) {
          issues.add(
              '${node.id}: prerequisite $dependency must precede this node.');
        }
      }
      final reference = node.reference;
      if (reference == null) {
        if ([
          CurriculumPathNodeKind.lesson,
          CurriculumPathNodeKind.boss,
          CurriculumPathNodeKind.review,
          CurriculumPathNodeKind.variant
        ].contains(node.kind)) {
          issues.add('${node.id}: pin a vetted lesson revision.');
        }
        continue;
      }
      final revision = registry.resolve(reference);
      if (revision == null || !revision.isVettedForPath) {
        issues.add('${node.id}: revision is missing, changed or unvetted.');
        continue;
      }
      final prerequisite = revision.topic.prerequisiteTopicId;
      if (prerequisite != null && !seenTopics.contains(prerequisite)) {
        issues.add(
            '${node.id}: include prerequisite $prerequisite earlier in the path.');
      }
      seenTopics.add(revision.id);
    }
    return List.unmodifiable(issues);
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'title': title,
        'nodes': nodes.map((n) => n.toJson()).toList()
      };
  factory CurriculumPath.fromJson(Map<String, dynamic> json) => CurriculumPath(
      id: json['id'] as String,
      title: json['title'] as String,
      nodes: (json['nodes'] as List)
          .map((n) =>
              CurriculumPathNode.fromJson(Map<String, dynamic>.from(n as Map)))
          .toList());
}
