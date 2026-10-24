import '../../curriculum/presentation/curriculum_session_guard.dart';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../data/quiz_generation/native_quiz_provider.dart';
import '../domain/norie_study_models.dart';
import '../domain/quiz_generation/quiz_generation.dart';
import 'study_set_screen.dart';

class NativeQuizGeneratorScreen extends StatefulWidget {
  const NativeQuizGeneratorScreen({super.key});
  @override
  State<NativeQuizGeneratorScreen> createState() =>
      _NativeQuizGeneratorScreenState();
}

class _NativeQuizGeneratorScreenState extends State<NativeQuizGeneratorScreen>
    with CurriculumSessionGuard<NativeQuizGeneratorScreen> {
  String _topic = 'linear-equations';
  int _count = 10;
  final int _seed = Random.secure().nextInt(0x7fffffff);
  NorieStudyGenerationMode _format = NorieStudyGenerationMode.multipleChoice;
  bool _working = false;
  bool _loadingHistory = true;
  bool _historyReady = false;
  bool _repeat = false;
  Set<String> _completed = const {};
  String? _error;
  QuizGenerationCancellation? _cancellation;
  QuizGenerationRequest get _request => QuizGenerationRequest(
      subject: 'Mathematics',
      grade: NativeQuizProvider.topics[_topic]!.$1,
      topic: _topic,
      questionCount: _count,
      questionType: _format,
      seed: _seed,
      excludedQuestionIds: _completed,
      allowRepeatPractice: _repeat);
  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  Future<void> _loadHistory() async {
    try {
      final history =
          await NorieStudyService.instance.completedNativeIdentities();
      if (!mounted || !curriculumSessionCurrent) return;
      setState(() {
        _completed = history;
        _historyReady = true;
        _error = null;
      });
    } catch (_) {
      if (mounted) {
        setState(() => _error =
            'Could not read saved practice history. Your data has been kept.');
      }
    } finally {
      if (mounted) setState(() => _loadingHistory = false);
    }
  }

  @override
  void dispose() {
    _cancellation?.cancel();
    super.dispose();
  }

  Future<void> _generate() async {
    if (_working || !_historyReady) return;
    final token = QuizGenerationCancellation();
    _cancellation = token;
    setState(() {
      _working = true;
      _error = null;
    });
    try {
      final set = await NorieStudyService.instance
          .generateNative(_request, cancellation: token);
      if (!mounted) return;
      token.check();
      requireCurrentCurriculumSession();
      await Navigator.of(context).pushReplacement(MaterialPageRoute<void>(
          builder: (_) => StudySetScreen(studySet: set)));
    } catch (error) {
      if (mounted) {
        setState(() {
          _error = error is QuizGenerationFailure
              ? error.toString()
              : 'Could not save this quiz. Check device storage and try again.';
        });
      }
    } finally {
      if (mounted) setState(() => _working = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    if (!curriculumSessionCurrent) return changedCurriculumSession;
    final count = NativeQuizProvider().coverage(_request).availableCount;
    return Scaffold(
        appBar: AppBar(title: const Text('Native Quiz Engine')),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 720),
                    child:
                        ListView(padding: const EdgeInsets.all(20), children: [
                      const Text(
                          'Available offline · No AI allowance or Credits required',
                          style: TextStyle(
                              color: NorieColors.cyan,
                              fontWeight: FontWeight.bold)),
                      const SizedBox(height: 12),
                      const Text('Mathematics',
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 8),
                      const Text(
                          'Practice bounded exercises with exact answer checks. Each quiz keeps its method references. This is computational checking, not independent editorial certification.'),
                      const SizedBox(height: 20),
                      DropdownButtonFormField<String>(
                          initialValue: _topic,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Topic and academic level'),
                          items: [
                            for (final entry
                                in NativeQuizProvider.topics.entries)
                              DropdownMenuItem(
                                  value: entry.key,
                                  child: Text(
                                      '${entry.value.$1.toUpperCase()} · ${entry.value.$2}'))
                          ],
                          onChanged: _working
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() => _topic = value);
                                  }
                                }),
                      const SizedBox(height: 16),
                      const Text('Difficulty: Foundation · Language: English'),
                      const SizedBox(height: 16),
                      DropdownButtonFormField<NorieStudyGenerationMode>(
                          initialValue: _format,
                          isExpanded: true,
                          decoration: const InputDecoration(
                              labelText: 'Question format'),
                          items: [
                            for (final mode in [
                              NorieStudyGenerationMode.multipleChoice,
                              NorieStudyGenerationMode.identification
                            ])
                              DropdownMenuItem(
                                  value: mode, child: Text(mode.label))
                          ],
                          onChanged: _working
                              ? null
                              : (value) {
                                  if (value != null) {
                                    setState(() => _format = value);
                                  }
                                }),
                      const SizedBox(height: 20),
                      const Text('Number of questions'),
                      Wrap(spacing: 8, runSpacing: 8, children: [
                        for (final n in [5, 10, 20, 40])
                          ChoiceChip(
                              label: Text('$n'),
                              selected: _count == n,
                              onSelected: _working
                                  ? null
                                  : (_) => setState(() => _count = n))
                      ]),
                      const SizedBox(height: 12),
                      Text(
                          '$count distinct exercises available for these settings. No duplicate questions within a quiz. Completed exercises are excluded unless you allow repeat practice.'),
                      const SizedBox(height: 16),
                      if (_loadingHistory)
                        const LinearProgressIndicator(
                            semanticsLabel: 'Loading practice history'),
                      if (!_historyReady && !_loadingHistory)
                        TextButton(
                            onPressed: _loadHistory,
                            child: const Text('Retry saved history')),
                      CheckboxListTile(
                          contentPadding: EdgeInsets.zero,
                          title: const Text(
                              'Allow previously completed exercises'),
                          value: _repeat,
                          onChanged: _working
                              ? null
                              : (value) =>
                                  setState(() => _repeat = value ?? false)),
                      if (_historyReady && count < _count)
                        Text(
                            'Only $count new exercises are available. Choose a smaller count or allow previously completed exercises.'),
                      const Text(
                          'Source-specific notes and uploads use the existing AI generator. Native processing of documents, other subjects and advanced topics is not available yet.'),
                      if (_error != null) ...[
                        const SizedBox(height: 16),
                        Semantics(
                            liveRegion: true,
                            child: Text(_error!,
                                style:
                                    const TextStyle(color: NorieColors.orange)))
                      ],
                      const SizedBox(height: 24),
                      FilledButton.icon(
                          onPressed:
                              _working || !_historyReady || count < _count
                                  ? null
                                  : _generate,
                          icon: _working
                              ? const SizedBox(
                                  width: 18,
                                  height: 18,
                                  child:
                                      CircularProgressIndicator(strokeWidth: 2))
                              : const Icon(Icons.offline_bolt_outlined),
                          label: Text(_working
                              ? 'Generating…'
                              : 'Generate Native Quiz')),
                      if (_working)
                        TextButton(
                            onPressed: () => _cancellation?.cancel(),
                            child: const Text('Cancel')),
                    ])))));
  }
}
