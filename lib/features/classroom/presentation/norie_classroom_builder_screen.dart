import 'norie_classroom_identity_guard.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../../content/data/norie_foundation_curriculum.dart';
import '../data/norie_classroom_store.dart';
import '../domain/norie_classroom_models.dart';
import '../domain/norie_classroom_resolver.dart';
import 'norie_classroom_question_context.dart';

class NorieClassroomBuilderScreen extends StatefulWidget {
  const NorieClassroomBuilderScreen({this.store, super.key});
  final NorieClassroomStore? store;
  @override
  State<NorieClassroomBuilderScreen> createState() => _BuilderState();
}

class _BuilderState extends State<NorieClassroomBuilderScreen>
    with NorieClassroomIdentityGuard<NorieClassroomBuilderScreen> {
  final title = TextEditingController(), note = TextEditingController();
  String subject = 'Science', grade = 'g1';
  final selected = <String>{};
  int attempts = 1;
  bool hints = false, busy = false;
  String? error;
  @override
  void dispose() {
    title.dispose();
    note.dispose();
    super.dispose();
  }

  Future<void> save() async {
    if (!current) return;
    setState(() => busy = true);
    try {
      final topics = NorieClassroomResolver.topicsFor(subject, grade)
          .where((t) => [...t.quiz.questions, ...t.challenge.rounds]
              .any((q) => selected.contains(q.id)))
          .toList();
      final a = NorieClassroomAssignment(
          id: 'assignment-${const Uuid().v4()}',
          title: title.text.trim(),
          subject: subject,
          gradeId: grade,
          topicIds: topics.map((t) => t.id).toList(),
          questionIds: selected.toList(),
          createdAt: DateTime.now().toUtc(),
          maxAttempts: attempts,
          allowHints: hints,
          teacherNote: note.text.trim());
      await (widget.store ?? NorieClassroomStore.instance)
          .importAssignment(a, stillCurrent: () => current);
      if (mounted && current) Navigator.pop(context, true);
    } catch (e) {
      if (mounted && current) setState(() => error = e.toString());
    } finally {
      if (mounted) setState(() => busy = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!current) {
      return const Scaffold(
          body: Center(child: Text('Learner changed. Reopen Classroom.')));
    }
    final topics = NorieClassroomResolver.topicsFor(subject, grade);
    return Scaffold(
        appBar: AppBar(title: const Text('Build assignment')),
        body: ListView(padding: const EdgeInsets.all(16), children: [
          const Text(
              'Choose authored lessons and questions. Classroom practice awards no XP or league points.'),
          TextField(
              controller: title,
              onChanged: (_) => setState(() {}),
              maxLength: 160,
              decoration: const InputDecoration(labelText: 'Assignment title')),
          TextField(
              controller: note,
              maxLength: 2000,
              maxLines: 3,
              decoration: const InputDecoration(labelText: 'Teacher note')),
          DropdownButtonFormField<String>(
              initialValue: subject,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Subject'),
              items: [
                for (final s in NorieFoundationCurriculum.supportedSubjects)
                  DropdownMenuItem(value: s, child: Text(s))
              ],
              onChanged: busy
                  ? null
                  : (v) => setState(() {
                        subject = v!;
                        grade = NorieFoundationCurriculum.availableGradeLevels(
                                subject)
                            .first
                            .id;
                        selected.clear();
                      })),
          DropdownButtonFormField<String>(
              key: ValueKey(subject),
              initialValue: grade,
              isExpanded: true,
              decoration: const InputDecoration(labelText: 'Grade'),
              items: [
                for (final g
                    in NorieFoundationCurriculum.availableGradeLevels(subject))
                  DropdownMenuItem(value: g.id, child: Text(g.label))
              ],
              onChanged: busy
                  ? null
                  : (v) => setState(() {
                        grade = v!;
                        selected.clear();
                      })),
          DropdownButtonFormField<int>(
              initialValue: attempts,
              decoration: const InputDecoration(
                  labelText: 'Maximum attempts per alias'),
              items: [
                for (var i = 1; i <= 20; i++)
                  DropdownMenuItem(value: i, child: Text('$i'))
              ],
              onChanged: busy ? null : (v) => setState(() => attempts = v!)),
          SwitchListTile(
              contentPadding: EdgeInsets.zero,
              title: const Text('Allow explanation hints'),
              subtitle: const Text(
                  'Learners can reveal an explanation before answering.'),
              value: hints,
              onChanged: busy ? null : (v) => setState(() => hints = v)),
          Text('${selected.length}/100 questions selected'),
          if (topics.isEmpty)
            const Text('No authored lessons are available at this grade yet.'),
          for (final t in topics)
            ExpansionTile(
                title: Text(t.title),
                subtitle: Text('${t.quiz.questions.length} lesson questions'),
                children: [
                  NorieClassroomQuestionContext(topic: t),
                  for (final q in {
                    ...{
                      for (final q in [
                        ...t.quiz.questions,
                        ...t.challenge.rounds
                      ])
                        q.id: q
                    }
                  }.values.where((q) => q.hasValidAnswer))
                    CheckboxListTile(
                        controlAffinity: ListTileControlAffinity.leading,
                        title: Text(q.prompt),
                        value: selected.contains(q.id),
                        onChanged: busy
                            ? null
                            : (v) => setState(() {
                                  if (v == true) {
                                    if (selected.length < 100) {
                                      selected.add(q.id);
                                    }
                                  } else {
                                    selected.remove(q.id);
                                  }
                                })),
                ]),
          if (error != null)
            Text(error!,
                style: TextStyle(color: Theme.of(context).colorScheme.error)),
          FilledButton(
              onPressed: busy || selected.isEmpty || title.text.trim().isEmpty
                  ? null
                  : save,
              child: Text(busy ? 'Saving...' : 'Save assignment')),
        ]));
  }
}
