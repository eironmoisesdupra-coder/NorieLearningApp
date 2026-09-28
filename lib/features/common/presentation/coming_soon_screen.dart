import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';

class ComingSoonScreen extends StatelessWidget {
  const ComingSoonScreen({
    required this.title,
    required this.subtitle,
    required this.icon,
    super.key,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(title),
        backgroundColor: Colors.transparent,
      ),
      body: SafeArea(
        top: false,
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 560),
            child: Padding(
              padding: const EdgeInsets.all(24),
              child: Container(
                width: double.infinity,
                padding: const EdgeInsets.all(28),
                decoration: BoxDecoration(
                  color: NorieColors.surface,
                  borderRadius: BorderRadius.circular(26),
                  border: Border.all(color: NorieColors.border),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 82,
                      height: 82,
                      decoration: BoxDecoration(
                        color: NorieColors.primary.withValues(alpha: .14),
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: NorieColors.primary.withValues(alpha: .55),
                        ),
                      ),
                      child: Icon(
                        icon,
                        size: 42,
                        color: NorieColors.cyan,
                      ),
                    ),
                    const SizedBox(height: 22),
                    Text(
                      title,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 27,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Text(
                      subtitle,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 22),
                    FilledButton.icon(
                      onPressed: () => Navigator.of(context).pop(),
                      icon: const Icon(Icons.arrow_back_rounded),
                      label: const Text('Back'),
                      style: FilledButton.styleFrom(
                        backgroundColor: NorieColors.cyan,
                        foregroundColor: NorieColors.background,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
