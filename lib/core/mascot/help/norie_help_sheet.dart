import 'package:flutter/material.dart';

import '../../theme/norie_theme.dart';
import '../norie_app_context.dart';
import '../norie_mascot_controller.dart';
import '../voice/norie_voice_controller.dart';
import 'norie_help_models.dart';
import 'norie_help_service.dart';

class NorieHelpSheet extends StatefulWidget {
  const NorieHelpSheet({
    required this.contextSnapshot,
    required this.controller,
    required this.voiceController,
    required this.onClose,
    required this.onAction,
    super.key,
  });

  final NorieContextSnapshot contextSnapshot;
  final NorieMascotController controller;
  final NorieVoiceController voiceController;
  final VoidCallback onClose;
  final ValueChanged<NorieHelpDestination> onAction;

  @override
  State<NorieHelpSheet> createState() => _NorieHelpSheetState();
}

class _NorieHelpSheetState extends State<NorieHelpSheet> {
  final TextEditingController _textController = TextEditingController();
  NorieHelpResponse? _response;
  bool _working = false;
  late bool _voiceEnabled;

  @override
  void initState() {
    super.initState();
    _voiceEnabled = widget.voiceController.enabled;
    widget.controller.searching();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  Future<void> _ask() async {
    if (_working) return;
    final text = _textController.text;

    setState(() => _working = true);
    widget.controller.think();

    try {
      final response = await NorieHelpService.instance.answer(
        NorieHelpRequest(
          text: text,
          context: widget.contextSnapshot,
        ),
      );
      if (!mounted) return;
      setState(() {
        _working = false;
        _response = response;
      });
      widget.controller.speak(response.text);
    } catch (_) {
      if (!mounted) return;
      const response = NorieHelpResponse(
        kind: NorieHelpResponseKind.unavailable,
        text:
            'I could not answer that right now. You can still use the app normally or try one of the help topics below.',
      );
      setState(() {
        _working = false;
        _response = response;
      });
      widget.controller.nervous();
    }
  }

  void _close() {
    widget.controller.stopSpeaking();
    widget.voiceController.stop();
    widget.onClose();
  }

  Future<void> _setVoiceEnabled(bool enabled) async {
    await widget.voiceController.setEnabled(enabled);
    if (!mounted) return;
    setState(() => _voiceEnabled = enabled);
  }

  @override
  Widget build(BuildContext context) {
    final response = _response;

    return Material(
      color: Colors.black.withValues(alpha: .50),
      child: SafeArea(
        child: Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                behavior: HitTestBehavior.opaque,
                onTap: _close,
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 640),
                child: Container(
                  margin: const EdgeInsets.all(14),
                  padding: const EdgeInsets.fromLTRB(18, 16, 18, 18),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0D1832),
                    borderRadius: BorderRadius.circular(26),
                    border: Border.all(
                      color: NorieColors.cyan.withValues(alpha: .35),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: .35),
                        blurRadius: 30,
                        offset: const Offset(0, 12),
                      ),
                    ],
                  ),
                  child: SingleChildScrollView(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Ask Norie',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                  SizedBox(height: 2),
                                  Text(
                                    'App help + context-aware study guidance',
                                    style: TextStyle(
                                      color: NorieColors.textSecondary,
                                      fontSize: 10,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Tooltip(
                              message: _voiceEnabled
                                  ? 'Turn tutorial/help voice off'
                                  : 'Turn tutorial/help voice on',
                              child: FilterChip(
                                selected: _voiceEnabled,
                                onSelected: _setVoiceEnabled,
                                avatar: Icon(
                                  _voiceEnabled
                                      ? Icons.volume_up_rounded
                                      : Icons.volume_off_rounded,
                                  size: 16,
                                ),
                                label: const Text('Voice'),
                              ),
                            ),
                            const SizedBox(width: 6),
                            IconButton(
                              onPressed: _close,
                              tooltip: 'Close Norie help',
                              icon: const Icon(Icons.close_rounded),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        TextField(
                          controller: _textController,
                          enabled: !_working,
                          textInputAction: TextInputAction.send,
                          onSubmitted: (_) => _ask(),
                          decoration: InputDecoration(
                            hintText: 'Ask about this screen or Norie Learning…',
                            prefixIcon: const Icon(Icons.search_rounded),
                            suffixIcon: IconButton(
                              onPressed: _working ? null : _ask,
                              tooltip: 'Ask Norie',
                              icon: _working
                                  ? const SizedBox(
                                      width: 18,
                                      height: 18,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    )
                                  : const Icon(Icons.arrow_upward_rounded),
                            ),
                          ),
                        ),
                        if (response != null) ...[
                          const SizedBox(height: 14),
                          Container(
                            width: double.infinity,
                            padding: const EdgeInsets.all(14),
                            decoration: BoxDecoration(
                              color: NorieColors.cyan.withValues(alpha: .07),
                              borderRadius: BorderRadius.circular(16),
                              border: Border.all(
                                color:
                                    NorieColors.cyan.withValues(alpha: .22),
                              ),
                            ),
                            child: Text(
                              response.text,
                              style: const TextStyle(
                                color: NorieColors.textSecondary,
                                height: 1.45,
                              ),
                            ),
                          ),
                          if (response.quickActions.isNotEmpty) ...[
                            const SizedBox(height: 10),
                            Wrap(
                              spacing: 8,
                              runSpacing: 8,
                              children: [
                                for (final action in response.quickActions)
                                  ActionChip(
                                    avatar: const Icon(
                                      Icons.auto_awesome_rounded,
                                      size: 16,
                                    ),
                                    label: Text(action.label),
                                    onPressed: () =>
                                        widget.onAction(action.destination),
                                  ),
                              ],
                            ),
                          ],
                        ],
                        const SizedBox(height: 10),
                        const Text(
                          'Try: “How do Credits work?”, “What can I do here?”, or “Replay the tutorial.”',
                          style: TextStyle(
                            color: NorieColors.textSecondary,
                            fontSize: 9.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
