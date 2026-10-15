import 'package:flutter/material.dart';

import '../data/norie_accessibility_settings.dart';

class NorieAccessibilityScreen extends StatefulWidget {
  const NorieAccessibilityScreen({this.store, super.key});

  final NorieAccessibilitySettings? store;

  @override
  State<NorieAccessibilityScreen> createState() =>
      _NorieAccessibilityScreenState();
}

class _NorieAccessibilityScreenState extends State<NorieAccessibilityScreen> {
  NorieAccessibilitySettings get store =>
      widget.store ?? NorieAccessibilitySettings.instance;
  NorieAccessibilityProfile draft = const NorieAccessibilityProfile();
  bool loading = true;
  bool saving = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    await store.load();
    if (!mounted) return;
    setState(() {
      draft = store.value;
      loading = false;
    });
  }

  Future<void> _save() async {
    setState(() => saving = true);
    try {
      await store.save(draft);
      if (mounted) Navigator.of(context).pop();
    } catch (_) {
      if (!mounted) return;
      setState(() => saving = false);
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
        content: Text('Could not save accessibility settings. Try again.'),
      ));
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(title: const Text('Accessibility')),
        body: loading
            ? const Center(child: CircularProgressIndicator())
            : Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 720),
                  child: ListView(
                    padding: const EdgeInsets.all(20),
                    children: [
                      const Text('Make Norie easier to use.',
                          style: TextStyle(
                              fontSize: 27, fontWeight: FontWeight.w900)),
                      const SizedBox(height: 8),
                      const Text(
                          'Settings are shared on this device. They never reduce XP, mastery, lesson access, or league fairness.'),
                      const SizedBox(height: 22),
                      Text('Text size · ${(draft.textScale * 100).round()}%',
                          style: const TextStyle(fontWeight: FontWeight.w900)),
                      const Text(
                          'Multiplies your device text size. System accessibility preferences stay enabled.'),
                      Slider(
                        min: .9,
                        max: 1.6,
                        divisions: 7,
                        value: draft.textScale,
                        label: '${(draft.textScale * 100).round()}%',
                        onChanged: saving
                            ? null
                            : (v) => setState(
                                () => draft = draft.copyWith(textScale: v)),
                      ),
                      Text(
                          'Sample lesson: Water changes from liquid to gas when it evaporates.',
                          textScaler: _PreviewTextScaler(
                              MediaQuery.textScalerOf(context),
                              draft.textScale / store.value.textScale),
                          style: TextStyle(
                              fontWeight: draft.boldText
                                  ? FontWeight.bold
                                  : FontWeight.normal)),
                      const SizedBox(height: 12),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: draft.boldText,
                        onChanged: saving
                            ? null
                            : (v) => setState(
                                () => draft = draft.copyWith(boldText: v)),
                        title: const Text('Bolder text'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: draft.reducedMotion,
                        onChanged: saving
                            ? null
                            : (v) => setState(
                                () => draft = draft.copyWith(reducedMotion: v)),
                        title: const Text('Reduced motion'),
                        subtitle: const Text(
                            'Limit animation and animated transitions.'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: draft.readingFocus,
                        onChanged: saving
                            ? null
                            : (v) => setState(
                                () => draft = draft.copyWith(readingFocus: v)),
                        title: const Text('Reading focus'),
                        subtitle: const Text(
                            'Hide background decoration and floating mascot reactions. Help and tutorials remain available.'),
                      ),
                      SwitchListTile(
                        contentPadding: EdgeInsets.zero,
                        value: draft.highContrast,
                        onChanged: saving
                            ? null
                            : (v) => setState(
                                () => draft = draft.copyWith(highContrast: v)),
                        title: const Text('High contrast'),
                        subtitle: const Text(
                            'Brighter text, control colors, and borders.'),
                      ),
                      const SizedBox(height: 18),
                      FilledButton.icon(
                        onPressed: saving ? null : _save,
                        icon: const Icon(Icons.save_rounded),
                        label: Text(
                            saving ? 'Saving…' : 'Save accessibility settings'),
                      ),
                      TextButton(
                        onPressed: saving
                            ? null
                            : () => setState(() =>
                                draft = const NorieAccessibilityProfile()),
                        child: const Text('Reset changes to defaults'),
                      ),
                    ],
                  ),
                ),
              ),
      );
}

class _PreviewTextScaler extends TextScaler {
  const _PreviewTextScaler(this.current, this.ratio);
  final TextScaler current;
  final double ratio;
  @override
  double scale(double fontSize) => current.scale(fontSize) * ratio;
  @override
  double get textScaleFactor => scale(14) / 14;
}
