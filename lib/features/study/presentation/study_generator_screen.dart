import 'dart:async';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

import '../../../core/mascot/norie_ai_generation_sequence.dart';
import '../../../core/mascot/norie_mascot_scope.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_study_service.dart';
import '../domain/norie_study_models.dart';
import 'study_set_screen.dart';

class StudyGeneratorScreen extends StatefulWidget {
  const StudyGeneratorScreen({
    super.key,
    this.initialQuestionCount = 10,
  });

  final int initialQuestionCount;

  @override
  State<StudyGeneratorScreen> createState() => _StudyGeneratorScreenState();
}

class _StudyGeneratorScreenState extends State<StudyGeneratorScreen> {
  final _titleController = TextEditingController();
  final _topicController = TextEditingController();
  final _notesController = TextEditingController();

  NorieStudyGenerationMode _mode = NorieStudyGenerationMode.mixed;
  late int _questionCount;
  bool _usingFile = false;
  bool _working = false;
  int _generationCaptionStep = 0;
  Timer? _generationCaptionTimer;

  PlatformFile? _pickedFile;
  Uint8List? _pickedBytes;
  String _mimeType = '';
  String _sourceType = 'notes';

  @override
  void initState() {
    super.initState();
    _questionCount = const [5, 10, 20, 40]
            .contains(widget.initialQuestionCount)
        ? widget.initialQuestionCount
        : 10;
  }

  @override
  void dispose() {
    _generationCaptionTimer?.cancel();
    _titleController.dispose();
    _topicController.dispose();
    _notesController.dispose();
    super.dispose();
  }

  Future<void> _pickSource() async {
    try {
      final file = await FilePicker.pickFile(
        type: FileType.custom,
        allowedExtensions: const [
          'pdf',
          'doc',
          'docx',
          'ppt',
          'pptx',
          'txt',
          'md',
          'png',
          'jpg',
          'jpeg',
          'webp',
        ],
      );
      if (file == null) return;

      final bytes = await file.readAsBytes();
      if (bytes.length > 10 * 1024 * 1024) {
        _show('Study source files are limited to 10 MB.');
        return;
      }

      final info = _fileType(file.name);
      if (info == null) {
        _show('That file type is not supported yet.');
        return;
      }

      setState(() {
        _pickedFile = file;
        _pickedBytes = bytes;
        _sourceType = info.$1;
        _mimeType = info.$2;
        _usingFile = true;
        if (_titleController.text.trim().isEmpty) {
          _titleController.text = file.name.split('.').first;
        }
      });
    } catch (_) {
      _show('Norie could not open the file picker.');
    }
  }

  Future<void> _generate() async {
    if (_working) return;

    final title = _titleController.text.trim();
    final topic = _topicController.text.trim();
    final notes = _notesController.text.trim();

    if (_usingFile) {
      if (_pickedFile == null || _pickedBytes == null) {
        _show('Choose a source file first.');
        return;
      }
    } else if (notes.length < 80) {
      _show('Paste at least a short paragraph of study material first.');
      return;
    }

    final mascotController = NorieMascotScope.maybeOf(context)?.controller;
    final mascotSequence = mascotController == null
        ? null
        : NorieAiGenerationSequence(mascotController);

    mascotSequence?.start();
    _generationCaptionTimer?.cancel();
    _generationCaptionStep = 0;
    _generationCaptionTimer = Timer.periodic(
      const Duration(milliseconds: 1400),
      (_) {
        if (!mounted || !_working) return;
        setState(() => _generationCaptionStep++);
      },
    );
    setState(() => _working = true);

    try {
      var sourcePath = '';
      var sourceName = '';

      if (_usingFile) {
        sourceName = _pickedFile!.name;
        sourcePath = await NorieStudyService.instance.uploadSource(
          bytes: _pickedBytes!,
          filename: sourceName,
          contentType: _mimeType,
        );
      }

      final set = await NorieStudyService.instance.generateFromSource(
        title: title.isEmpty ? 'Generated Study Set' : title,
        sourceType: _usingFile ? _sourceType : 'notes',
        mode: _mode,
        questionCount: _questionCount,
        sourceText: _usingFile ? '' : notes,
        sourcePath: sourcePath,
        sourceName: sourceName,
        mimeType: _mimeType,
        topicTag: topic,
      );

      if (!mounted) return;
      _generationCaptionTimer?.cancel();
      _generationCaptionTimer = null;
      mascotSequence?.success();
      setState(() => _working = false);

      await Navigator.of(context).pushReplacement(
        MaterialPageRoute<void>(
          builder: (_) => StudySetScreen(studySet: set),
        ),
      );
    } catch (error) {
      if (!mounted) return;
      _generationCaptionTimer?.cancel();
      _generationCaptionTimer = null;
      mascotSequence?.failure();
      setState(() => _working = false);
      _show(
        error.toString().replaceFirst('Bad state: ', ''),
      );
    }
  }

  void _show(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  static (String, String)? _fileType(String name) {
    final lower = name.toLowerCase();
    if (lower.endsWith('.pdf')) {
      return ('pdf', 'application/pdf');
    }
    if (lower.endsWith('.docx')) {
      return (
        'docx',
        'application/vnd.openxmlformats-officedocument.wordprocessingml.document',
      );
    }
    if (lower.endsWith('.doc')) {
      return ('docx', 'application/msword');
    }
    if (lower.endsWith('.pptx')) {
      return (
        'pptx',
        'application/vnd.openxmlformats-officedocument.presentationml.presentation',
      );
    }
    if (lower.endsWith('.ppt')) {
      return ('pptx', 'application/vnd.ms-powerpoint');
    }
    if (lower.endsWith('.txt')) {
      return ('text', 'text/plain');
    }
    if (lower.endsWith('.md')) {
      return ('text', 'text/markdown');
    }
    if (lower.endsWith('.png')) {
      return ('image', 'image/png');
    }
    if (lower.endsWith('.webp')) {
      return ('image', 'image/webp');
    }
    if (lower.endsWith('.jpg') || lower.endsWith('.jpeg')) {
      return ('image', 'image/jpeg');
    }
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Create Study Set'),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 720),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 36),
              children: [
                const _GeneratorHero(),
                const SizedBox(height: 10),
                const Text(
                  'AI quiz generation needs internet and a signed-in account. After generation, saved quizzes can be studied offline.',
                  style: TextStyle(color: NorieColors.textSecondary, fontSize: 12),
                ),
                const SizedBox(height: 20),
                TextField(
                  controller: _titleController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Study set title',
                    prefixIcon: Icon(Icons.title_rounded),
                  ),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _topicController,
                  textInputAction: TextInputAction.next,
                  decoration: const InputDecoration(
                    labelText: 'Topic tag (optional)',
                    hintText: 'e.g. Chemistry · Acids & Bases',
                    prefixIcon: Icon(Icons.sell_outlined),
                  ),
                ),
                const SizedBox(height: 22),
                SegmentedButton<bool>(
                  segments: const [
                    ButtonSegment(
                      value: false,
                      icon: Icon(Icons.notes_rounded),
                      label: Text('Paste Notes'),
                    ),
                    ButtonSegment(
                      value: true,
                      icon: Icon(Icons.upload_file_rounded),
                      label: Text('Upload'),
                    ),
                  ],
                  selected: {_usingFile},
                  onSelectionChanged: _working
                      ? null
                      : (selection) {
                          setState(() => _usingFile = selection.first);
                        },
                ),
                const SizedBox(height: 14),
                if (!_usingFile)
                  TextField(
                    controller: _notesController,
                    minLines: 8,
                    maxLines: 18,
                    decoration: const InputDecoration(
                      alignLabelWithHint: true,
                      labelText: 'Source material',
                      hintText:
                          'Paste your notes, reviewer, or textbook excerpt here...',
                    ),
                  )
                else
                  _FileSourceCard(
                    fileName: _pickedFile?.name,
                    onPick: _working ? null : _pickSource,
                  ),
                const SizedBox(height: 22),
                const Text(
                  'Practice mode',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                DropdownButtonFormField<NorieStudyGenerationMode>(
                  initialValue: _mode,
                  items: [
                    for (final mode in NorieStudyGenerationMode.values)
                      DropdownMenuItem(
                        value: mode,
                        child: Text(mode.label),
                      ),
                  ],
                  onChanged: _working
                      ? null
                      : (value) {
                          if (value != null) setState(() => _mode = value);
                        },
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.quiz_rounded),
                  ),
                ),
                const SizedBox(height: 18),
                const Text(
                  'Number of items',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w900,
                  ),
                ),
                const SizedBox(height: 10),
                Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (final count in const [5, 10, 20, 40])
                      ChoiceChip(
                        label: Text('$count'),
                        selected: _questionCount == count,
                        onSelected: _working
                            ? null
                            : (_) {
                                setState(() => _questionCount = count);
                              },
                      ),
                    const ActionChip(
                      avatar: Icon(
                        Icons.workspace_premium_rounded,
                        size: 17,
                        color: NorieColors.orange,
                      ),
                      label: Text('100 · Premium'),
                      onPressed: null,
                    ),
                  ],
                ),
                const SizedBox(height: 22),
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: NorieColors.cyan.withValues(alpha: .07),
                    borderRadius: BorderRadius.circular(17),
                    border: Border.all(
                      color: NorieColors.cyan.withValues(alpha: .28),
                    ),
                  ),
                  child: const Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Icon(
                        Icons.fact_check_outlined,
                        color: NorieColors.cyan,
                        size: 20,
                      ),
                      SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Generated answers are constrained to your source material. Each item keeps a source excerpt for review.',
                          style: TextStyle(
                            color: NorieColors.textSecondary,
                            fontSize: 11,
                            height: 1.4,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                if (_working) ...[
                  const SizedBox(height: 20),
                  _NorieGenerationPanel(
                    caption: NorieAiGenerationSequence.captionForStep(
                      _generationCaptionStep,
                    ),
                  ),
                ],
                const SizedBox(height: 20),
                FilledButton.icon(
                  onPressed: _working ? null : _generate,
                  icon: _working
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : const Icon(Icons.auto_awesome_rounded),
                  label: Text(
                    _working ? 'Generating…' : 'Generate Study Set',
                  ),
                  style: FilledButton.styleFrom(
                    backgroundColor: NorieColors.violet,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 17),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _GeneratorHero extends StatelessWidget {
  const _GeneratorHero();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(22),
        border: Border.all(color: NorieColors.border),
      ),
      child: const Row(
        children: [
          Icon(
            Icons.auto_awesome_rounded,
            color: NorieColors.violet,
            size: 35,
          ),
          SizedBox(width: 14),
          Expanded(
            child: Text(
              'Build practice from notes, PDF, Word, PowerPoint, text files, or images of study material.',
              style: TextStyle(
                fontWeight: FontWeight.w800,
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _FileSourceCard extends StatelessWidget {
  const _FileSourceCard({
    required this.fileName,
    required this.onPick,
  });

  final String? fileName;
  final VoidCallback? onPick;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: NorieColors.border),
      ),
      child: Column(
        children: [
          Icon(
            fileName == null
                ? Icons.cloud_upload_outlined
                : Icons.description_rounded,
            color: NorieColors.cyan,
            size: 42,
          ),
          const SizedBox(height: 10),
          Text(
            fileName ?? 'Choose a study source',
            textAlign: TextAlign.center,
            style: const TextStyle(
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 5),
          const Text(
            'PDF · DOC/DOCX · PPT/PPTX · TXT/MD · PNG/JPG/WEBP · max 10 MB',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: NorieColors.textSecondary,
              fontSize: 10,
            ),
          ),
          const SizedBox(height: 12),
          OutlinedButton.icon(
            onPressed: onPick,
            icon: const Icon(Icons.folder_open_rounded),
            label: Text(fileName == null ? 'Choose File' : 'Change File'),
          ),
        ],
      ),
    );
  }
}


class _NorieGenerationPanel extends StatelessWidget {
  const _NorieGenerationPanel({required this.caption});

  final String caption;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      liveRegion: true,
      label: 'Norie is preparing your study set. $caption',
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: NorieColors.violet.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(
            color: NorieColors.violet.withValues(alpha: .38),
          ),
        ),
        child: Row(
          children: [
            const SizedBox(
              width: 22,
              height: 22,
              child: CircularProgressIndicator(
                strokeWidth: 2.5,
                color: NorieColors.cyan,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Norie is working on it',
                    style: TextStyle(fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    caption,
                    style: const TextStyle(
                      color: NorieColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
