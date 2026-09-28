import 'package:flutter/material.dart';

import '../../../core/theme/norie_theme.dart';
import '../../challenge/presentation/challenge_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../learning/presentation/learn_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../progress/presentation/progress_screen.dart';

class MainShell extends StatefulWidget {
  const MainShell({
    super.key,
    this.initialIndex = 0,
  });

  final int initialIndex;

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _index;

  @override
  void initState() {
    super.initState();
    _index = widget.initialIndex.clamp(0, 4).toInt();
  }

  void _selectTab(int index) {
    final safeIndex = index.clamp(0, 4).toInt();
    if (_index == safeIndex) return;
    setState(() => _index = safeIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBody: true,
      body: IndexedStack(
        index: _index,
        children: [
          HomeScreen(
            embedded: true,
            onTabSelected: _selectTab,
          ),
          LearnScreen(
            embedded: true,
            onTabSelected: _selectTab,
          ),
          ChallengeScreen(onTabSelected: _selectTab),
          ProgressScreen(
            embedded: true,
            onTabSelected: _selectTab,
          ),
          ProfileScreen(
            embedded: true,
            onTabSelected: _selectTab,
          ),
        ],
      ),
      bottomNavigationBar: _NorieDock(
        selectedIndex: _index,
        onSelected: _selectTab,
      ),
    );
  }
}

class _NorieDock extends StatelessWidget {
  const _NorieDock({
    required this.selectedIndex,
    required this.onSelected,
  });

  final int selectedIndex;
  final ValueChanged<int> onSelected;

  static const _items = [
    (Icons.home_rounded, 'Home'),
    (Icons.menu_book_rounded, 'Learn'),
    (Icons.emoji_events_rounded, 'Challenge'),
    (Icons.bar_chart_rounded, 'Progress'),
    (Icons.person_rounded, 'Profile'),
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      minimum: const EdgeInsets.fromLTRB(12, 0, 12, 10),
      child: Center(
        heightFactor: 1,
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 620),
          child: Container(
            height: 70,
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: const Color(0xF20D1730),
              borderRadius: BorderRadius.circular(24),
              border: Border.all(
                color: Colors.white.withValues(alpha: .08),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: .28),
                  blurRadius: 28,
                  offset: const Offset(0, 12),
                ),
                BoxShadow(
                  color: NorieColors.primary.withValues(alpha: .08),
                  blurRadius: 25,
                ),
              ],
            ),
            child: Row(
              children: [
                for (var index = 0; index < _items.length; index++)
                  Expanded(
                    child: _DockItem(
                      icon: _items[index].$1,
                      label: _items[index].$2,
                      selected: selectedIndex == index,
                      onTap: () => onSelected(index),
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

class _DockItem extends StatelessWidget {
  const _DockItem({
    required this.icon,
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: label,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 220),
            curve: Curves.easeOutCubic,
            padding: const EdgeInsets.symmetric(horizontal: 5),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(18),
              gradient: selected
                  ? LinearGradient(
                      colors: [
                        NorieColors.primary.withValues(alpha: .36),
                        NorieColors.violet.withValues(alpha: .22),
                      ],
                    )
                  : null,
              border: selected
                  ? Border.all(
                      color: NorieColors.cyan.withValues(alpha: .18),
                    )
                  : null,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Icon(
                  icon,
                  size: selected ? 24 : 22,
                  color: selected
                      ? NorieColors.cyan
                      : NorieColors.textSecondary,
                ),
                const SizedBox(height: 3),
                Text(
                  label,
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  style: TextStyle(
                    fontSize: 8.5,
                    fontWeight:
                        selected ? FontWeight.w900 : FontWeight.w700,
                    color: selected
                        ? NorieColors.textPrimary
                        : NorieColors.textSecondary,
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
