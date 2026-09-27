import 'package:flutter/material.dart';

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
    _index = widget.initialIndex.clamp(0, 4);
  }

  void _selectTab(int index) {
    final safeIndex = index.clamp(0, 4);
    if (_index == safeIndex) return;
    setState(() => _index = safeIndex);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
      bottomNavigationBar: NavigationBar(
        selectedIndex: _index,
        onDestinationSelected: _selectTab,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_rounded),
            label: 'Home',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_rounded),
            label: 'Learn',
          ),
          NavigationDestination(
            icon: Icon(Icons.emoji_events_rounded),
            label: 'Challenge',
          ),
          NavigationDestination(
            icon: Icon(Icons.bar_chart_rounded),
            label: 'Progress',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_rounded),
            label: 'Profile',
          ),
        ],
      ),
    );
  }
}
