import 'package:flutter/material.dart';
import '../domain/norie_explorer_appearance.dart';

/// Edits an isolated studio draft; its owner handles Save, Cancel and presets.
class NorieExplorerEditor extends StatelessWidget {
  const NorieExplorerEditor(
      {super.key,
      required this.value,
      required this.onChanged,
      this.enabled = true});
  final NorieExplorerAppearance value;
  final ValueChanged<NorieExplorerAppearance> onChanged;
  final bool enabled;
  @override
  Widget build(BuildContext context) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        const Text('Your Explorer',
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800)),
        const SizedBox(height: 6),
        const Text(
            'Your own learner character, alongside Norie. All Explorer choices are available offline and saved with your look.'),
        const SizedBox(height: 12),
        _choices('Skin tone', NorieExplorerAppearance.skins, value.skin,
            (id) => onChanged(value.copyWith(skin: id)),
            skin: true),
        _choices('Hair', NorieExplorerAppearance.hairs, value.hair,
            (id) => onChanged(value.copyWith(hair: id))),
        _choices('Outfit', NorieExplorerAppearance.outfits, value.outfit,
            (id) => onChanged(value.copyWith(outfit: id))),
        _choices('Accessory', NorieExplorerAppearance.accessories,
            value.accessory, (id) => onChanged(value.copyWith(accessory: id))),
      ]);
  Widget _choices(String title, Map<String, String> entries, String selected,
          ValueChanged<String> change,
          {bool skin = false}) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 14),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final entry in entries.entries)
              ChoiceChip(
                key: ValueKey('explorer-${title.toLowerCase()}-${entry.key}'),
                label: Text(entry.value),
                avatar: skin
                    ? CircleAvatar(
                        radius: 8,
                        backgroundColor: switch (entry.key) {
                          'light' => const Color(0xFFF9D5B5),
                          'brown' => const Color(0xFFBA7952),
                          'deep' => const Color(0xFF855039),
                          _ => const Color(0xFFE8AF7A),
                        })
                    : null,
                selected: selected == entry.key,
                onSelected: enabled ? (_) => change(entry.key) : null,
              ),
          ]),
        ]),
      );
}
