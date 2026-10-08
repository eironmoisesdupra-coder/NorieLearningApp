import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/theme/norie_theme.dart';

/// Optional first-use guidance; the complete guide remains in the help button.
class NorieWelcomeCard extends StatefulWidget {
  const NorieWelcomeCard({required this.onLearnTap, super.key});
  final VoidCallback onLearnTap;
  static const dismissedKey = 'norie.welcome.dismissed.v1';

  @override
  State<NorieWelcomeCard> createState() => _NorieWelcomeCardState();
}

class _NorieWelcomeCardState extends State<NorieWelcomeCard> {
  bool _visible = false;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final prefs = await SharedPreferences.getInstance();
    if (mounted) {
      setState(() =>
          _visible = !(prefs.getBool(NorieWelcomeCard.dismissedKey) ?? false));
    }
  }

  Future<void> _dismiss() async {
    setState(() => _visible = false);
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(NorieWelcomeCard.dismissedKey, true);
  }

  @override
  Widget build(BuildContext context) {
    if (!_visible) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Card(
        color: NorieColors.surface,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Row(children: [
              const Expanded(
                  child: Text('Start in three steps',
                      style: TextStyle(
                          fontSize: 18, fontWeight: FontWeight.w800))),
              IconButton(
                  onPressed: _dismiss,
                  tooltip: 'Dismiss welcome',
                  icon: const Icon(Icons.close)),
            ]),
            const Text(
                '1. Choose a subject.\n2. Pick your grade.\n3. Open a lesson, then try its practice.',
                style: TextStyle(height: 1.6)),
            const SizedBox(height: 8),
            const Text(
                'Lessons work offline. Your reading place saves automatically. Use the guide button anytime for a full tour.',
                style:
                    TextStyle(color: NorieColors.textSecondary, height: 1.4)),
            const SizedBox(height: 12),
            TextButton.icon(
                onPressed: widget.onLearnTap,
                icon: const Icon(Icons.explore_outlined),
                label: const Text('Explore subjects')),
          ]),
        ),
      ),
    );
  }
}
