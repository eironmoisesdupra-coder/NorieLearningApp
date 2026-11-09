import 'dart:convert';
import '../../curriculum/domain/curriculum_fingerprint.dart';
import 'package:uuid/uuid.dart';
import 'anatomy_atlas_catalog.dart';
import 'anatomy_atlas_quiz_policy.dart';
import 'anatomy_hint_geometry.dart';
import 'anatomy_models.dart';

class AtlasQuizRequest {
  AtlasQuizRequest(
      {required this.reference,
      required Set<String> systems,
      this.requestedCount = 20,
      this.difficulty = AtlasQuizDifficulty.standard,
      Set<AtlasQuestionKind> kinds = const {AtlasQuestionKind.identify}})
      : systems = Set.unmodifiable(systems),
        kinds = Set.unmodifiable(kinds);
  final String reference;
  final Set<String> systems;
  final int requestedCount;
  final AtlasQuizDifficulty difficulty;
  final Set<AtlasQuestionKind> kinds;
  Map<String, dynamic> toJson() => {
        'reference': reference,
        'systems': systems.toList()..sort(),
        'count': requestedCount,
        'difficulty': difficulty.name,
        'kinds': kinds.map((e) => e.name).toList()..sort()
      };
  bool matches(AtlasQuizRequest other) =>
      jsonEncode(toJson()) == jsonEncode(other.toJson());
  factory AtlasQuizRequest.restore(Map<String, dynamic> value) {
    try {
      final systems = List<String>.from(value['systems'] as List);
      final kinds = List<String>.from(value['kinds'] as List);
      if (value.length != 5 ||
          value['reference'] is! String ||
          ![5, 10, 20].contains(value['count']) ||
          systems.isEmpty ||
          systems.length != systems.toSet().length ||
          !anatomyHintSystems.containsAll(systems) ||
          kinds.isEmpty ||
          kinds.length != kinds.toSet().length) {
        throw const FormatException();
      }
      return AtlasQuizRequest(
          reference: value['reference'] as String,
          systems: systems.toSet(),
          requestedCount: value['count'] as int,
          difficulty:
              AtlasQuizDifficulty.values.byName(value['difficulty'] as String),
          kinds: kinds.map(AtlasQuestionKind.values.byName).toSet());
    } on Object {
      throw const FormatException('Invalid saved Atlas settings.');
    }
  }
}

String _binding(AnatomyAtlasCatalog catalog, AtlasStructure target) =>
    curriculumFingerprint({
      'id': target.id,
      'name': target.name,
      'reference': target.reference,
      'asset': target.asset,
      'source': target.source,
      'ontology': target.ontology,
      'systems': target.systems.toList()..sort(),
      'geometry': catalog.hintGeometry?.parts[target.id]?.identity.toJson(),
    });

class AtlasPendingAnswer {
  const AtlasPendingAnswer(this.index, this.lineage, this.receipt);
  final int index;
  final String lineage, receipt;
  Map<String, dynamic> toJson() =>
      {'index': index, 'lineage': lineage, 'receipt': receipt};
}

class AtlasSavedRound {
  AtlasSavedRound._(this._data, this.request);
  final Map<String, dynamic> _data;
  final AtlasQuizRequest request;
  static final uuid = RegExp(
      r'^[0-9a-f]{8}-[0-9a-f]{4}-4[0-9a-f]{3}-[89ab][0-9a-f]{3}-[0-9a-f]{12}$');
  String get attemptId => _data['attemptId'] as String;
  String get epoch => _data['epoch'] as String;
  int get revision => _data['revision'] as int;
  bool get rewardAck => _data['rewardAck'] as bool;
  bool get finished => _data['finished'] as bool;
  AtlasPendingAnswer? get pending {
    final raw = _data['pending'] as Map?;
    return raw == null
        ? null
        : AtlasPendingAnswer(raw['index'] as int, raw['lineage'] as String,
            raw['receipt'] as String);
  }

  Map<String, dynamic> toJson() =>
      jsonDecode(jsonEncode(_data)) as Map<String, dynamic>;

  factory AtlasSavedRound.create(
      AnatomyAtlasCatalog catalog, AtlasQuizRequest request, String epoch) {
    final quiz = AtlasQuizSession.generate(
        catalog, request.reference, request.systems,
        requestedCount: request.requestedCount,
        difficulty: request.difficulty,
        kinds: request.kinds);
    return AtlasSavedRound.restore(catalog, {
      'schema': 1,
      'attemptId': const Uuid().v4(),
      'epoch': epoch,
      'revision': 0,
      'request': request.toJson(),
      'index': 0,
      'finished': false,
      'responses': quiz.responses,
      'rewardAck': false,
      'pending': null,
      'questions': quiz.questions
          .map((q) => {
                'id': q.target.id,
                'kind': q.kind.name,
                'binding': _binding(catalog, q.target),
                'options': q.options
              })
          .toList()
    });
  }

  AtlasQuizSession session(AnatomyAtlasCatalog catalog,
      {bool Function()? stillCurrent}) {
    final byId = {for (final target in catalog.structures) target.id: target};
    final questions = (_data['questions'] as List)
        .map((raw) => AtlasQuizQuestion(
            byId[raw['id']]!, List<String>.unmodifiable(raw['options'] as List),
            kind: AtlasQuestionKind.values.byName(raw['kind'] as String)))
        .toList();
    return AtlasQuizSession.restore(questions,
        requestedCount: request.requestedCount,
        difficulty: request.difficulty,
        index: _data['index'] as int,
        finished: finished,
        responses: List<String?>.from(_data['responses'] as List),
        stillCurrent: stillCurrent);
  }

  String answerReceipt(int index) => curriculumFingerprint([
        attemptId,
        index,
        (_data['questions'] as List)[index],
        (_data['responses'] as List)[index],
      ]);

  AtlasSavedRound replace(AnatomyAtlasCatalog catalog, AtlasQuizSession quiz,
          {AtlasPendingAnswer? pending, bool? rewardAck}) =>
      AtlasSavedRound.restore(catalog, {
        ..._data,
        'index': quiz.index,
        'finished': quiz.finished,
        'responses': quiz.responses,
        'pending': pending?.toJson(),
        'rewardAck': rewardAck ?? this.rewardAck,
      });
  AtlasSavedRound atRevision(AnatomyAtlasCatalog catalog, int revision) =>
      AtlasSavedRound.restore(catalog, {..._data, 'revision': revision});

  factory AtlasSavedRound.restore(
      AnatomyAtlasCatalog catalog, Map<String, dynamic> raw) {
    try {
      if (raw.length != 11 ||
          raw['schema'] != 1 ||
          raw['attemptId'] is! String ||
          !uuid.hasMatch(raw['attemptId'] as String) ||
          raw['epoch'] is! String ||
          !(raw['epoch'] == 'initial' ||
              uuid.hasMatch(raw['epoch'] as String)) ||
          raw['revision'] is! int ||
          (raw['revision'] as int) < 0 ||
          raw['finished'] is! bool ||
          raw['rewardAck'] is! bool ||
          raw['rewardAck'] == true && raw['finished'] != true) {
        throw const FormatException();
      }
      final request = AtlasQuizRequest.restore(
          Map<String, dynamic>.from(raw['request'] as Map));
      final eligible = AtlasQuizSession.eligibleStructures(
          catalog, request.reference, request.systems,
          kinds: request.kinds);
      final byId = {for (final target in eligible) target.id: target};
      final poolNames = eligible.map((s) => s.name).toSet();
      final rows = raw['questions'] as List;
      final count = poolNames.length < request.requestedCount
          ? poolNames.length
          : request.requestedCount;
      if (rows.isEmpty || rows.length != count) throw const FormatException();
      final ids = <String>{}, names = <String>{};
      for (final row in rows) {
        final target = byId[row['id']];
        if (target == null ||
            !ids.add(target.id) ||
            !names.add(target.name) ||
            row['binding'] != _binding(catalog, target) ||
            row.length != 4) {
          throw const FormatException();
        }
        final kind = AtlasQuestionKind.values.byName(row['kind'] as String);
        final options = List<String>.from(row['options'] as List);
        if (!request.kinds.contains(kind) ||
            options.length < 2 ||
            options.length > 6 ||
            options.toSet().length != options.length ||
            options.any((s) => s.trim().isEmpty)) {
          throw const FormatException();
        }
        final q = AtlasQuizQuestion(target, options, kind: kind);
        final pool = kind == AtlasQuestionKind.identify
            ? poolNames
            : AnatomyCatalog.systems.map((s) => s.label).toSet();
        final wanted = switch (request.difficulty) {
          AtlasQuizDifficulty.guided => 2,
          AtlasQuizDifficulty.standard => 4,
          AtlasQuizDifficulty.challenge => 6
        };
        if (!pool.containsAll(options) ||
            options.length != (pool.length < wanted ? pool.length : wanted)) {
          throw const FormatException();
        }
        if (!options.contains(q.answer)) throw const FormatException();
      }
      final round = AtlasSavedRound._(
          jsonDecode(jsonEncode(raw)) as Map<String, dynamic>, request);
      final quiz = round.session(catalog);
      if (raw['pending'] != null) {
        final pending = raw['pending'] as Map;
        if (pending.length != 3 ||
            pending['index'] != quiz.index ||
            !quiz.checked ||
            quiz.finished ||
            pending['lineage'] is! String ||
            !uuid.hasMatch(pending['lineage'] as String) ||
            pending['receipt'] != round.answerReceipt(quiz.index)) {
          throw const FormatException();
        }
      }
      return round;
    } on Object {
      throw const FormatException(
          'Saved Atlas round is incompatible or damaged; original data is preserved.');
    }
  }
}
