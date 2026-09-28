import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../domain/norie_study_models.dart';
import 'study_generator_screen.dart';
import 'study_set_screen.dart';

class StudyHubScreen extends StatefulWidget {
  const StudyHubScreen({super.key});

  @override
  State<StudyHubScreen> createState() => _StudyHubScreenState();
}

class _StudyHubScreenState extends State<StudyHubScreen> {
  late Future<List<NorieStudySet>> _setsFuture;

  @override
  void initState() {
    super.initState();
    _reload();
  }

  void _reload() {
    _setsFuture = NorieStudyService.instance.listStudySets();
  }

  Future<void> _openGenerator() async {
    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => const StudyGeneratorScreen(),
      ),
    );
    if (mounted) setState(_reload);
  }

  Future<void> _openSet(NorieStudySet summary) async {
    final set = await NorieStudyService.instance.getStudySet(summary.id);
    if (!mounted) return;

    if (set == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('This study set could not be loaded.')),
      );
      return;
    }

    await Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => StudySetScreen(studySet: set),
      ),
    );
    if (mounted) setState(_reload);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Study Lab'),
        backgroundColor: Colors.transparent,
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _openGenerator,
        icon: const Icon(Icons.auto_awesome_rounded),
        label: const Text('New Study Set'),
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: FutureBuilder<List<NorieStudySet>>(
              future: _setsFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                final sets = snapshot.data ?? const <NorieStudySet>[];
                if (sets.isEmpty) {
                  return _EmptyStudyLab(onCreate: _openGenerator);
                }

                return RefreshIndicator(
                  onRefresh: () async {
                    setState(_reload);
                    await _setsFuture;
                  },
                  child: ListView(
                    physics: const AlwaysScrollableScrollPhysics(),
                    padding: const EdgeInsets.fromLTRB(20, 12, 20, 110),
                    children: [
                      const _StudyLabHero(),
                      const SizedBox(height: 24),
                      const Text(
                        'Saved study sets',
                        style: TextStyle(
                          fontSize: 21,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      const SizedBox(height: 12),
                      for (final set in sets)
                        Padding(
                          padding: const EdgeInsets.only(bottom: 10),
                          child: _StudySetTile(
                            studySet: set,
                            onTap: () => _openSet(set),
                          ),
                        ),
                    ],
                  ),
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _StudyLabHero extends StatelessWidget {
  const _StudyLabHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          colors: [
            Color(0xFF172554),
            Color(0xFF312E81),
            Color(0xFF581C87),
          ],
        ),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .55),
        ),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.psychology_alt_rounded,
            color: NorieColors.cyan,
            size: 36,
          ),
          SizedBox(height: 13),
          Text(
            'Turn your own material into practice.',
            style: TextStyle(
              fontSize: 25,
              fontWeight: FontWeight.w900,
            ),
          ),
          SizedBox(height: 7),
          Text(
            'Paste notes or upload supported documents and images. Norie keeps generated questions grounded in the source and saves your study history.',
            style: TextStyle(
              color: NorieColors.textSecondary,
              height: 1.45,
            ),
          ),
        ],
      ),
    );
  }
}

class _StudySetTile extends StatelessWidget {
  const _StudySetTile({
    required this.studySet,
    required this.onTap,
  });

  final NorieStudySet studySet;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ready = studySet.status == 'ready';

    return Material(
      color: NorieColors.surface,
      borderRadius: BorderRadius.circular(19),
      child: InkWell(
        onTap: ready ? onTap : null,
        borderRadius: BorderRadius.circular(19),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(19),
            border: Border.all(color: NorieColors.border),
          ),
          child: Row(
            children: [
              Container(
                width: 48,
                height: 48,
                decoration: BoxDecoration(
                  color: NorieColors.violet.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(15),
                ),
                child: Icon(
                  studySet.sourceType == 'image'
                      ? Icons.image_rounded
                      : studySet.sourceType == 'notes'
                          ? Icons.notes_rounded
                          : Icons.description_rounded,
                  color: NorieColors.violet,
                ),
              ),
              const SizedBox(width: 13),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      studySet.title,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontSize: 15,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      ready
                          ? '${studySet.itemCount} items · ${studySet.mode.label}'
                          : studySet.status.toUpperCase(),
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 10,
                      ),
                    ),
                    if (studySet.topicTag?.isNotEmpty == true) ...[
                      const SizedBox(height: 4),
                      Text(
                        studySet.topicTag!,
                        style: const TextStyle(
                          color: NorieColors.cyan,
                          fontSize: 10,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
              Icon(
                ready
                    ? Icons.chevron_right_rounded
                    : Icons.hourglass_top_rounded,
                color: NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyStudyLab extends StatelessWidget {
  const _EmptyStudyLab({required this.onCreate});

  final VoidCallback onCreate;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.auto_awesome_rounded,
              color: NorieColors.violet,
              size: 56,
            ),
            const SizedBox(height: 16),
            const Text(
              'No study sets yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w900,
              ),
            ),
            const SizedBox(height: 7),
            const Text(
              'Create your first set from notes, a document, or an image.',
              textAlign: TextAlign.center,
              style: TextStyle(
                color: NorieColors.textSecondary,
              ),
            ),
            const SizedBox(height: 18),
            FilledButton.icon(
              onPressed: onCreate,
              icon: const Icon(Icons.add_rounded),
              label: const Text('Create Study Set'),
            ),
          ],
        ),
      ),
    );
  }
}
