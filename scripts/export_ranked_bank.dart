// Run from repository root: dart run scripts/export_ranked_bank.dart
// This imports authored content, never a client upload. Deploy the generated
// manifest alongside the Edge Function after reviewing curriculum changes.
import 'dart:convert';
import 'dart:io';
import 'package:norie_learning/features/content/data/norie_foundation_curriculum.dart';

void main() {
  final lessons = <Map<String, dynamic>>[];
  for (final subject in ['Science', 'Mathematics', 'English']) {
    for (final grade in NorieFoundationCurriculum.gradeLevels) {
      for (final topic
          in NorieFoundationCurriculum.topicsFor(subject, grade.id)) {
        final questions = topic.quiz.questions;
        if (!NorieFoundationCurriculum.isAuthored(topic) ||
            questions.length < 5 ||
            questions.any((q) => !q.hasValidAnswer)) {
          throw StateError('Invalid ranked question bank: ${topic.id}');
        }
        lessons.add({
          'id': topic.id,
          'title': topic.title,
          'subject': subject.toLowerCase(),
          'grade': grade.id,
          'questions': questions
              .map((q) => {
                    'id': q.id,
                    'prompt': q.prompt,
                    'options': q.options,
                    'correctIndex': q.correctIndex,
                    'conceptId': q.conceptId,
                  })
              .toList(),
        });
      }
    }
  }
  // Stable content-derived version. This is a content identity, not a signature;
  // authenticity comes from the reviewed server deployment and HMAC nonce.
  final canonical = jsonEncode(lessons);
  var hash = 0x811c9dc5;
  for (final byte in utf8.encode(canonical)) {
    hash = ((hash ^ byte) * 0x01000193) & 0xffffffff;
  }
  final output = File('supabase/functions/verified-leagues/ranked-bank.json');
  output.parent.createSync(recursive: true);
  output.writeAsStringSync('${const JsonEncoder.withIndent('  ').convert({
        'version': 'authored-${hash.toRadixString(16)}',
        'lessons': lessons,
      })}\n');
  stdout.writeln(
      '${lessons.length} authored subject lessons exported to ${output.path}.');
}
