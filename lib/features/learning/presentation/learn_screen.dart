import 'package:flutter/material.dart';

import '../../../core/assets/norie_assets.dart';
import '../../../core/theme/norie_theme.dart';
import '../../common/presentation/coming_soon_screen.dart';
import '../../navigation/presentation/norie_drawer.dart';
import '../../progress/presentation/progress_screen.dart';
import 'science_screen.dart';

class LearnScreen extends StatefulWidget {
  const LearnScreen({super.key});

  @override
  State<LearnScreen> createState() => _LearnScreenState();
}

class _LearnScreenState extends State<LearnScreen> {
  int _questionCount = 10;

  void _previewOnly(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: const NorieDrawer(selectedSection: NorieDrawerSection.learn),
      drawerEdgeDragWidth: 48,
      body: SafeArea(
        child: Center(
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: ListView(
              padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
              children: [
                Builder(
                  builder: (drawerContext) => _LearnHeader(
                    onMenuPressed: () =>
                        Scaffold.of(drawerContext).openDrawer(),
                  ),
                ),
                const SizedBox(height: 26),
                const Text(
                  'Explore Subjects',
                  style: TextStyle(
                    fontSize: 29,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.7,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Choose a learning area, then dive into focused topics and mastery paths.',
                  style: TextStyle(
                    color: NorieColors.textSecondary,
                    height: 1.45,
                  ),
                ),
                const SizedBox(height: 20),
                _SubjectTile(
                  title: 'Mathematics',
                  subtitle: 'Algebra · Geometry · Calculus · Statistics',
                  icon: Icons.calculate_rounded,
                  color: NorieColors.primary,
                  progress: .68,
                  onTap: () => _openUpcoming(
                    context,
                    'Mathematics',
                    'The Mathematics learning path is the next major subject expansion.',
                    Icons.calculate_rounded,
                  ),
                ),
                const SizedBox(height: 12),
                _SubjectTile(
                  title: 'Science',
                  subtitle: 'Chemistry · Biology · Physics · Earth Science',
                  icon: Icons.science_rounded,
                  color: NorieColors.green,
                  progress: .72,
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute<void>(
                        builder: (_) => const ScienceScreen(),
                      ),
                    );
                  },
                ),
                const SizedBox(height: 12),
                _SubjectTile(
                  title: 'English',
                  subtitle: 'Grammar · Vocabulary · Reading · Communication',
                  icon: Icons.menu_book_rounded,
                  color: NorieColors.orange,
                  progress: .45,
                  onTap: () => _openUpcoming(
                    context,
                    'English',
                    'The English proficiency path will include grammar, vocabulary, reading, and communication practice.',
                    Icons.menu_book_rounded,
                  ),
                ),
                const SizedBox(height: 28),
                _AiQaPreview(
                  selectedCount: _questionCount,
                  onCountSelected: (value) {
                    if (value == 100) {
                      _previewOnly(
                        '100 questions is a Premium-plan preview option.',
                      );
                      return;
                    }
                    setState(() => _questionCount = value);
                  },
                  onPreviewTap: _previewOnly,
                ),
              ],
            ),
          ),
        ),
      ),
      bottomNavigationBar: const _LearnBottomNavigation(),
    );
  }

  static void _openUpcoming(
    BuildContext context,
    String title,
    String subtitle,
    IconData icon,
  ) {
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ComingSoonScreen(
          title: title,
          subtitle: subtitle,
          icon: icon,
        ),
      ),
    );
  }
}

class _LearnHeader extends StatelessWidget {
  const _LearnHeader({required this.onMenuPressed});

  final VoidCallback onMenuPressed;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(
          onPressed: onMenuPressed,
          tooltip: 'Open menu',
          style: IconButton.styleFrom(
            backgroundColor: NorieColors.surface,
            side: const BorderSide(color: NorieColors.border),
          ),
          icon: const Icon(Icons.menu_rounded),
        ),
        const SizedBox(width: 10),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Learn',
                style: TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w900,
                ),
              ),
              Text(
                'Subjects · Practice · AI-based tools',
                style: TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 11,
                ),
              ),
            ],
          ),
        ),
        Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: NorieColors.surface,
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: NorieColors.border),
          ),
          child: const Icon(
            Icons.search_rounded,
            color: NorieColors.cyan,
          ),
        ),
      ],
    );
  }
}

class _SubjectTile extends StatelessWidget {
  const _SubjectTile({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.progress,
    required this.onTap,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final double progress;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: NorieColors.surface,
      borderRadius: BorderRadius.circular(21),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(21),
        child: Container(
          padding: const EdgeInsets.all(17),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(21),
            border: Border.all(color: color.withValues(alpha: .42)),
          ),
          child: Row(
            children: [
              Container(
                width: 54,
                height: 54,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .14),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Icon(icon, color: color, size: 29),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 11,
                      ),
                    ),
                    const SizedBox(height: 9),
                    LinearProgressIndicator(
                      value: progress,
                      minHeight: 5,
                      borderRadius: BorderRadius.circular(99),
                      color: color,
                      backgroundColor: color.withValues(alpha: .13),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 10),
              const Icon(
                Icons.chevron_right_rounded,
                color: NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _AiQaPreview extends StatelessWidget {
  const _AiQaPreview({
    required this.selectedCount,
    required this.onCountSelected,
    required this.onPreviewTap,
  });

  final int selectedCount;
  final ValueChanged<int> onCountSelected;
  final ValueChanged<String> onPreviewTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(19),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(26),
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF141E47),
            Color(0xFF26194D),
            Color(0xFF35164B),
          ],
        ),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .58),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x285B5CE2),
            blurRadius: 26,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _PreviewPill(),
                    SizedBox(height: 10),
                    Text(
                      'AI-Based Q&A Generator',
                      style: TextStyle(
                        fontSize: 23,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    SizedBox(height: 6),
                    Text(
                      'Turn your study materials into organized practice questions.',
                      style: TextStyle(
                        color: NorieColors.textSecondary,
                        height: 1.4,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(width: 10),
              SizedBox(
                width: 100,
                height: 100,
                child: Image.asset(
                  NorieAssets.mascotStudying,
                  fit: BoxFit.contain,
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _SourceOption(
            number: '1',
            icon: Icons.notes_rounded,
            title: 'Paste Notes',
            subtitle: 'Paste notes, textbook content, or copied text.',
            color: NorieColors.violet,
            onTap: () => onPreviewTap(
              'Paste Notes is a sample placeholder. AI is not connected yet.',
            ),
          ),
          const SizedBox(height: 9),
          _SourceOption(
            number: '2',
            icon: Icons.upload_file_rounded,
            title: 'Upload Source',
            subtitle:
                'YouTube links, PowerPoint, DOCX, PDF, and other files.',
            color: NorieColors.cyan,
            onTap: () => onPreviewTap(
              'Upload Source is a sample placeholder. Files are not processed yet.',
            ),
          ),
          const SizedBox(height: 9),
          _SourceOption(
            number: '3',
            icon: Icons.image_rounded,
            title: 'Upload Images',
            subtitle: 'Photos of notes, textbook pages, diagrams, and more.',
            color: NorieColors.magenta,
            onTap: () => onPreviewTap(
              'Upload Images is a sample placeholder. Image analysis is not connected yet.',
            ),
          ),
          const SizedBox(height: 18),
          const Row(
            children: [
              Icon(
                Icons.tag_rounded,
                size: 19,
                color: NorieColors.cyan,
              ),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  '4. Number of Items / Questions',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w900,
                  ),
                ),
              ),
              Text(
                'Free max: 40',
                style: TextStyle(
                  color: NorieColors.textSecondary,
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              for (final value in const [5, 10, 20, 40])
                ChoiceChip(
                  label: Text('$value'),
                  selected: selectedCount == value,
                  onSelected: (_) => onCountSelected(value),
                ),
              ActionChip(
                avatar: const Icon(
                  Icons.workspace_premium_rounded,
                  size: 17,
                  color: NorieColors.orange,
                ),
                label: const Text('100 · Premium'),
                onPressed: () => onCountSelected(100),
              ),
            ],
          ),
          const SizedBox(height: 17),
          SizedBox(
            width: double.infinity,
            child: FilledButton.icon(
              onPressed: () => onPreviewTap(
                'Preview only — no AI is connected yet. Selected: $selectedCount questions.',
              ),
              icon: const Icon(Icons.auto_awesome_rounded),
              label: const Text('Generate Sample Q&A'),
              style: FilledButton.styleFrom(
                backgroundColor: NorieColors.violet,
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(vertical: 15),
              ),
            ),
          ),
          const SizedBox(height: 9),
          const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                Icons.info_outline_rounded,
                size: 14,
                color: NorieColors.textSecondary,
              ),
              SizedBox(width: 5),
              Text(
                'Preview only · no AI connected yet',
                style: TextStyle(
                  fontSize: 10,
                  color: NorieColors.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PreviewPill extends StatelessWidget {
  const _PreviewPill();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 9, vertical: 5),
      decoration: BoxDecoration(
        color: NorieColors.violet.withValues(alpha: .16),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(
          color: NorieColors.violet.withValues(alpha: .48),
        ),
      ),
      child: const Text(
        'AI-BASED · SAMPLE',
        style: TextStyle(
          fontSize: 9,
          letterSpacing: 1,
          color: NorieColors.violet,
          fontWeight: FontWeight.w900,
        ),
      ),
    );
  }
}

class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.number,
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final String number;
  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xCC101B36),
      borderRadius: BorderRadius.circular(17),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(17),
        child: Padding(
          padding: const EdgeInsets.all(13),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(
                  color: color.withValues(alpha: .13),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(icon, color: color, size: 21),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '$number. $title',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 10,
                        height: 1.35,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: NorieColors.textSecondary,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _LearnBottomNavigation extends StatelessWidget {
  const _LearnBottomNavigation();

  @override
  Widget build(BuildContext context) {
    return NavigationBar(
      selectedIndex: 1,
      onDestinationSelected: (index) {
        if (index == 1) return;
        if (index == 3) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute<void>(
              builder: (_) => const ProgressScreen(),
            ),
          );
          return;
        }

        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => ComingSoonScreen(
              title: switch (index) {
                0 => 'Home',
                2 => 'Challenge',
                4 => 'Profile',
                _ => 'Norie Learning',
              },
              subtitle: index == 0
                  ? 'Use the back button to return Home in this preview.'
                  : 'This navigation destination is still being built.',
              icon: switch (index) {
                0 => Icons.home_rounded,
                2 => Icons.emoji_events_rounded,
                4 => Icons.person_rounded,
                _ => Icons.auto_awesome_rounded,
              },
            ),
          ),
        );
      },
      destinations: const [
        NavigationDestination(icon: Icon(Icons.home_rounded), label: 'Home'),
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
    );
  }
}
