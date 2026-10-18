import 'curriculum_session_guard.dart';
import 'package:flutter/material.dart';
import '../data/curriculum_registry.dart';
import '../domain/curriculum_revision.dart';
import 'norie_curriculum_studio_screen.dart';
import 'norie_curriculum_packs_screen.dart';
import 'norie_guided_learning_screen.dart';

class NorieCurriculumLibraryScreen extends StatefulWidget {
  const NorieCurriculumLibraryScreen({required this.ownerId, super.key});
  final String ownerId;
  @override
  State<NorieCurriculumLibraryScreen> createState() =>
      _NorieCurriculumLibraryScreenState();
}

class _NorieCurriculumLibraryScreenState
    extends State<NorieCurriculumLibraryScreen>
    with CurriculumSessionGuard<NorieCurriculumLibraryScreen> {
  late final CurriculumRegistry _registry = CurriculumRegistry.bundled();
  String _query = '';
  String? _subject;
  String? _grade;
  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    final items = _registry.search(_query, subject: _subject, grade: _grade);
    return Scaffold(
      appBar: AppBar(title: const Text('Curriculum Library'), actions: [
        IconButton(
            tooltip: 'Content packs',
            icon: const Icon(Icons.inventory_2_outlined),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) =>
                    NorieCurriculumPacksScreen(ownerId: widget.ownerId)))),
        IconButton(
            tooltip: 'Local studio',
            icon: const Icon(Icons.edit_note),
            onPressed: () => Navigator.of(context).push(MaterialPageRoute<void>(
                builder: (_) =>
                    NorieCurriculumStudioScreen(ownerId: widget.ownerId))))
      ]),
      body: SafeArea(
          child: Center(
              child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 900),
                  child: CustomScrollView(slivers: [
                    SliverToBoxAdapter(
                        child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                                crossAxisAlignment: CrossAxisAlignment.stretch,
                                children: [
                                  const Text('Existing offline lessons',
                                      style: TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 20)),
                                  const SizedBox(height: 6),
                                  const Text(
                                      'Browse the existing curriculum and rehearse with guidance. Local drafts stay in Studio.'),
                                  const SizedBox(height: 12),
                                  TextField(
                                      key: const Key('curriculum-search'),
                                      decoration: const InputDecoration(
                                          labelText:
                                              'Search lessons, IDs or subjects',
                                          prefixIcon: Icon(Icons.search)),
                                      onChanged: (value) =>
                                          setState(() => _query = value)),
                                  const SizedBox(height: 8),
                                  Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.stretch,
                                      children: [
                                        DropdownButton<String>(
                                            isExpanded: true,
                                            itemHeight: null,
                                            hint: const Text('All subjects'),
                                            value: _subject,
                                            items: [
                                              const DropdownMenuItem<String>(
                                                  value: null,
                                                  child: Text('All subjects')),
                                              ...[
                                                'Mathematics',
                                                'Science',
                                                'English',
                                                'Filipino',
                                                'Araling Panlipunan'
                                              ].map((s) => DropdownMenuItem(
                                                  value: s, child: Text(s)))
                                            ],
                                            onChanged: (value) => setState(
                                                () => _subject = value)),
                                        DropdownButton<String>(
                                            isExpanded: true,
                                            itemHeight: null,
                                            hint: const Text('All grades'),
                                            value: _grade,
                                            items: [
                                              const DropdownMenuItem<String>(
                                                  value: null,
                                                  child: Text('All grades')),
                                              ...[
                                                for (var i = 1; i <= 12; i++)
                                                  'g$i',
                                                'college'
                                              ].map((g) => DropdownMenuItem(
                                                  value: g,
                                                  child: Text(g == 'college'
                                                      ? 'College'
                                                      : 'Grade ${g.substring(1)}')))
                                            ],
                                            onChanged: (value) =>
                                                setState(() => _grade = value)),
                                      ]),
                                  Text(
                                      '${items.length} existing lessons · offline'),
                                ]))),
                    if (items.isEmpty)
                      const SliverFillRemaining(
                          hasScrollBody: false,
                          child: Center(
                              child: Text('No lessons match this search.')))
                    else
                      SliverList(
                          delegate: SliverChildBuilderDelegate(
                              (context, index) => _tile(items[index]),
                              childCount: items.length)),
                  ])))),
    );
  }

  Widget _tile(CurriculumRevision revision) {
    final topic = revision.topic;
    return ListTile(
        key: ValueKey('curriculum-topic-${topic.id}'),
        isThreeLine: true,
        title: Text(topic.title),
        subtitle: Text(
            '${topic.subject} · ${topic.gradeLevel ?? topic.category} · bundled r${revision.revision}\n${topic.id}'),
        trailing: const Icon(Icons.chevron_right),
        onTap: () => Navigator.of(context).push(MaterialPageRoute<void>(
            builder: (_) => NorieGuidedLearningScreen(topic: topic))));
  }
}
