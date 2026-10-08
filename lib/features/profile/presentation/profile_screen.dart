import 'package:flutter/material.dart';

import '../../../core/account/norie_account_service.dart';
import '../../../core/mascot/tutorial/norie_tutorial_models.dart';
import '../../../core/mascot/tutorial/norie_tutorial_overlay.dart';
import '../../../core/cloud/norie_cloud_sync.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/progression/norie_adventure_progress.dart';
import '../data/norie_profile_appearance_store.dart';
import 'norie_appearance_studio.dart';
import '../../../core/theme/norie_theme.dart';
import '../../../core/widgets/norie_ambient_backdrop.dart';
import '../../commerce/presentation/norie_shop_placeholder_screen.dart';
import '../../commerce/presentation/subscription_placeholder_screen.dart';
import '../../content/data/norie_foundation_curriculum.dart';
import '../../account/presentation/account_screen.dart';
import '../../navigation/presentation/norie_drawer.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({
    super.key,
    this.embedded = false,
    this.onTabSelected,
  });

  final bool embedded;
  final ValueChanged<int>? onTabSelected;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NorieDrawer(
        selectedSection: NorieDrawerSection.profile,
        onTabSelected: onTabSelected,
      ),
      drawerEdgeDragWidth: 48,
      appBar: embedded
          ? null
          : AppBar(
              title: const Text('Profile'),
              actions: const [
                NorieTutorialReplayButton(
                    definition: NorieTutorialCatalog.profile)
              ],
              backgroundColor: Colors.transparent,
            ),
      body: Stack(
        children: [
          const Positioned.fill(
            child: NorieAmbientBackdrop(
              primary: NorieColors.cyan,
              secondary: NorieColors.violet,
            ),
          ),
          SafeArea(
            child: AnimatedBuilder(
              animation: Listenable.merge([
                NorieAccountService.instance,
                NorieProfileAppearanceStore.instance,
                NorieAdventureProgress.instance
              ]),
              builder: (context, _) {
                return AnimatedBuilder(
                  animation: NorieProgression.instance,
                  builder: (context, _) {
                    final progression = NorieProgression.instance;
                    final account = NorieAccountService.instance;
                    final snapshot = progression.snapshot;
                    final accuracy = (progression.quizAccuracy * 100).round();

                    return Center(
                      child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 760),
                        child: ListView(
                          padding: const EdgeInsets.fromLTRB(20, 16, 20, 110),
                          children: [
                            if (embedded)
                              Builder(
                                builder: (drawerContext) => Row(
                                  children: [
                                    IconButton(
                                      onPressed: () =>
                                          Scaffold.of(drawerContext)
                                              .openDrawer(),
                                      tooltip: 'Open menu',
                                      style: IconButton.styleFrom(
                                        backgroundColor: NorieColors.surface,
                                        side: const BorderSide(
                                            color: NorieColors.border),
                                      ),
                                      icon: const Icon(Icons.menu_rounded),
                                    ),
                                    const SizedBox(width: 10),
                                    const Text(
                                      'Profile',
                                      style: TextStyle(
                                        fontSize: 21,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                    const Spacer(),
                                    const NorieTutorialReplayButton(
                                        definition:
                                            NorieTutorialCatalog.profile),
                                  ],
                                ),
                              ),
                            if (embedded) const SizedBox(height: 22),
                            _AccountSummaryCard(account: account),
                            const SizedBox(height: 14),
                            _CommercePreviewRow(
                              onMembershipTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const SubscriptionPlaceholderScreen(),
                                  ),
                                );
                              },
                              onShopTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        const NorieShopPlaceholderScreen(),
                                  ),
                                );
                              },
                            ),
                            const SizedBox(height: 14),
                            NorieAppearancePreview(
                              value: NorieProfileAppearanceStore.instance.value,
                              displayName:
                                  account.displayName?.isNotEmpty == true
                                      ? account.displayName!
                                      : 'Norie Learner',
                              subtitle:
                                  'Level ${snapshot.level} ? ${snapshot.title}',
                              trophyLabels: NorieProfileAppearanceStore
                                  .instance.value.showcase
                                  .where(NorieAdventureProgress
                                      .instance.trophyIds.contains)
                                  .map(trophyLabel)
                                  .toList(),
                            ),
                            const SizedBox(height: 10),
                            Align(
                              alignment: Alignment.centerLeft,
                              child: OutlinedButton.icon(
                                onPressed: () => Navigator.of(context).push(
                                    MaterialPageRoute<void>(
                                        builder: (_) => NorieAppearanceStudio(
                                            displayName: account.displayName
                                                        ?.isNotEmpty ==
                                                    true
                                                ? account.displayName!
                                                : 'Norie Learner'))),
                                icon: const Icon(Icons.palette_outlined),
                                label: const Text(
                                    'Edit appearance & rank collection'),
                              ),
                            ),
                            const SizedBox(height: 18),
                            GridView.count(
                              shrinkWrap: true,
                              physics: const NeverScrollableScrollPhysics(),
                              crossAxisCount:
                                  MediaQuery.sizeOf(context).width >= 600
                                      ? 4
                                      : 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10,
                              childAspectRatio: 1.45,
                              children: [
                                _StatCard(
                                  label: 'Total XP',
                                  value: '${snapshot.totalXp}',
                                  icon: Icons.star_rounded,
                                  color: NorieColors.orange,
                                ),
                                _StatCard(
                                  label: 'Streak',
                                  value: '${progression.currentStreak} days',
                                  icon: Icons.local_fire_department_rounded,
                                  color: NorieColors.magenta,
                                ),
                                _StatCard(
                                  label: 'Lessons',
                                  value: '${progression.completedLessons}',
                                  icon: Icons.menu_book_rounded,
                                  color: NorieColors.cyan,
                                ),
                                _StatCard(
                                  label: 'Accuracy',
                                  value: progression.questionsAnswered == 0
                                      ? '—'
                                      : '$accuracy%',
                                  icon: Icons.analytics_rounded,
                                  color: NorieColors.green,
                                ),
                              ],
                            ),
                            const SizedBox(height: 24),
                            const Text(
                              'Learning activity',
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 12),
                            _ActivityCard(
                              icon: Icons.track_changes_rounded,
                              title: 'Focused sessions',
                              value: '${progression.studySessions}',
                            ),
                            const SizedBox(height: 10),
                            _ActivityCard(
                              icon: Icons.emoji_events_rounded,
                              title: 'Challenge sessions',
                              value: '${progression.challengeSessions}',
                              subtitle:
                                  'Speed best: ${progression.speedBestScore}/10 · Weekly: ${progression.weeklyChallengeDays}/${NorieChallengeRules.weeklyGoalDays}',
                            ),
                            const SizedBox(height: 10),
                            _ActivityCard(
                              icon: Icons.psychology_alt_rounded,
                              title: 'Topic mastery',
                              value:
                                  '${progression.masteredTopicCount}/${progression.topicMastery.length}',
                              subtitle:
                                  '${progression.weakTopics.length} weak topics detected',
                            ),
                            const SizedBox(height: 10),
                            _ActivityCard(
                              icon: Icons.explore_rounded,
                              title: 'Subjects explored',
                              value: '${progression.exploredSubjects.length}',
                              subtitle: progression.exploredSubjects.isEmpty
                                  ? 'Open subjects from Learn to build this list.'
                                  : progression.exploredSubjects.join(' · '),
                            ),
                            const SizedBox(height: 24),
                            _ScienceTrophyShelf(progression: progression),
                            const SizedBox(height: 18),
                            const Text('Permanent reward collection',
                                style: TextStyle(
                                    fontSize: 20, fontWeight: FontWeight.w900)),
                            const SizedBox(height: 8),
                            if (NorieAdventureProgress
                                .instance.trophyIds.isEmpty)
                              const Text(
                                  'Complete a subject grade journey to earn your first trophy.',
                                  style: TextStyle(
                                      color: NorieColors.textSecondary))
                            else
                              Wrap(spacing: 8, runSpacing: 8, children: [
                                for (final id in NorieAdventureProgress
                                    .instance.trophyIds)
                                  Chip(
                                      avatar: const Icon(
                                          Icons.emoji_events_rounded,
                                          color: NorieColors.orange,
                                          size: 18),
                                      label: Text(trophyLabel(id))),
                              ]),
                            const SizedBox(height: 24),
                            Row(
                              children: [
                                const Expanded(
                                  child: Text(
                                    'Achievements',
                                    style: TextStyle(
                                      fontSize: 20,
                                      fontWeight: FontWeight.w900,
                                    ),
                                  ),
                                ),
                                Text(
                                  '${progression.unlockedAchievementCount} / ${progression.achievements.length}',
                                  style: const TextStyle(
                                    color: NorieColors.cyan,
                                    fontSize: 12,
                                    fontWeight: FontWeight.w900,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 12),
                            for (final achievement in progression.achievements)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 9),
                                child: _AchievementStatus(
                                  achievement: achievement,
                                ),
                              ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class _ScienceTrophyShelf extends StatelessWidget {
  const _ScienceTrophyShelf({required this.progression});

  final NorieProgression progression;

  @override
  Widget build(BuildContext context) {
    final grades = NorieFoundationCurriculum.gradeLevels;
    final completedGrades = grades.where((grade) {
      final topics = NorieFoundationCurriculum.topicsFor('Science', grade.id);
      return NorieAdventureProgress.instance.trophyIds
              .contains('grade:science.${grade.id}') ||
          topics.isNotEmpty &&
              topics.every((topic) => progression.isTopicCompleted(topic.id));
    }).toSet();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Expanded(
              child: Text(
                'Science journey trophies',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w900),
              ),
            ),
            Text(
              '${completedGrades.length}/${grades.length}',
              style: const TextStyle(
                color: NorieColors.cyan,
                fontSize: 12,
                fontWeight: FontWeight.w900,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        const Text(
          'Earned Science grade trophies are permanent. Expanding a path never removes the trophy for its original lessons, and trophies do not award duplicate XP.',
          style: TextStyle(
            color: NorieColors.textSecondary,
            fontSize: 10,
            height: 1.35,
          ),
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 102,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            itemCount: grades.length,
            separatorBuilder: (_, __) => const SizedBox(width: 9),
            itemBuilder: (context, index) {
              final grade = grades[index];
              final topics =
                  NorieFoundationCurriculum.topicsFor('Science', grade.id);
              final completed = topics
                  .where((topic) => progression.isTopicCompleted(topic.id))
                  .length;
              final earned = completedGrades.contains(grade);
              return Semantics(
                label: earned
                    ? '${grade.label} Science Complete trophy earned'
                    : '${grade.label} Science trophy, $completed of ${topics.length} lessons complete',
                child: Container(
                  width: 94,
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: earned
                        ? NorieColors.cyan.withValues(alpha: .10)
                        : NorieColors.surface,
                    borderRadius: BorderRadius.circular(18),
                    border: Border.all(
                      color: earned
                          ? NorieColors.cyan.withValues(alpha: .55)
                          : NorieColors.border,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        earned
                            ? Icons.emoji_events_rounded
                            : Icons.emoji_events_outlined,
                        color: earned
                            ? NorieColors.orange
                            : NorieColors.textSecondary,
                        size: 30,
                      ),
                      const SizedBox(height: 6),
                      Text(
                        grade.shortLabel,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                      Text(
                        earned ? 'Complete' : '$completed/${topics.length}',
                        style: TextStyle(
                          color: earned
                              ? NorieColors.green
                              : NorieColors.textSecondary,
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class _CommercePreviewRow extends StatelessWidget {
  const _CommercePreviewRow({
    required this.onMembershipTap,
    required this.onShopTap,
  });

  final VoidCallback onMembershipTap;
  final VoidCallback onShopTap;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final compact = constraints.maxWidth < 520;
        final membership = _CommerceTile(
          icon: Icons.workspace_premium_rounded,
          title: 'Membership',
          subtitle: 'Free · Plus · Pro preview',
          accent: NorieColors.violet,
          onTap: onMembershipTap,
        );
        final shop = _CommerceTile(
          icon: Icons.storefront_rounded,
          title: 'Norie Shop',
          subtitle: 'Credits · boosts · themes',
          accent: NorieColors.orange,
          onTap: onShopTap,
        );

        if (compact) {
          return Column(
            children: [
              membership,
              const SizedBox(height: 10),
              shop,
            ],
          );
        }

        return Row(
          children: [
            Expanded(child: membership),
            const SizedBox(width: 10),
            Expanded(child: shop),
          ],
        );
      },
    );
  }
}

class _CommerceTile extends StatelessWidget {
  const _CommerceTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.accent,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color accent;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(20),
        child: Ink(
          padding: const EdgeInsets.all(15),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                accent.withValues(alpha: .13),
                NorieColors.surface.withValues(alpha: .92),
              ],
            ),
            border: Border.all(color: accent.withValues(alpha: .27)),
          ),
          child: Row(
            children: [
              Container(
                width: 45,
                height: 45,
                decoration: BoxDecoration(
                  color: accent.withValues(alpha: .12),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(icon, color: accent),
              ),
              const SizedBox(width: 11),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      subtitle,
                      style: const TextStyle(
                        color: NorieColors.textSecondary,
                        fontSize: 9.5,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(
                Icons.chevron_right_rounded,
                color: accent,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });

  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(19),
        border: Border.all(color: color.withValues(alpha: .35)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, color: color, size: 21),
          const SizedBox(height: 8),
          Text(
            value,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w900,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              color: NorieColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}

class _ActivityCard extends StatelessWidget {
  const _ActivityCard({
    required this.icon,
    required this.title,
    required this.value,
    this.subtitle,
  });

  final IconData icon;
  final String title;
  final String value;
  final String? subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: NorieColors.surface,
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: NorieColors.border),
      ),
      child: Row(
        children: [
          const SizedBox(width: 2),
          Icon(icon, color: NorieColors.violet),
          const SizedBox(width: 13),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(fontWeight: FontWeight.w800),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 3),
                  Text(
                    subtitle!,
                    style: const TextStyle(
                      color: NorieColors.textSecondary,
                      fontSize: 10,
                    ),
                  ),
                ],
              ],
            ),
          ),
          Text(
            value,
            style: const TextStyle(
              color: NorieColors.cyan,
              fontWeight: FontWeight.w900,
            ),
          ),
        ],
      ),
    );
  }
}

class _AchievementStatus extends StatelessWidget {
  const _AchievementStatus({required this.achievement});

  final NorieAchievement achievement;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: achievement.unlocked
            ? NorieColors.green.withValues(alpha: .07)
            : NorieColors.surface,
        borderRadius: BorderRadius.circular(17),
        border: Border.all(
          color: achievement.unlocked
              ? NorieColors.green.withValues(alpha: .45)
              : NorieColors.border,
        ),
      ),
      child: Row(
        children: [
          Icon(
            achievement.unlocked
                ? Icons.check_circle_rounded
                : Icons.lock_outline_rounded,
            color: achievement.unlocked
                ? NorieColors.green
                : NorieColors.textSecondary,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  achievement.title,
                  style: const TextStyle(fontWeight: FontWeight.w900),
                ),
                const SizedBox(height: 3),
                Text(
                  achievement.unlocked ? 'Unlocked' : achievement.progressLabel,
                  style: const TextStyle(
                    color: NorieColors.textSecondary,
                    fontSize: 10,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _AccountSummaryCard extends StatelessWidget {
  const _AccountSummaryCard({required this.account});

  final NorieAccountService account;

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: NorieCloudSync.instance,
      builder: (context, _) {
        final sync = NorieCloudSync.instance;
        final signedIn = account.isSignedIn;
        final status = signedIn
            ? switch (sync.status) {
                NorieCloudSyncStatus.syncing => 'Synchronizing…',
                NorieCloudSyncStatus.pending => 'Waiting to synchronize',
                NorieCloudSyncStatus.synced => 'Cloud synchronized',
                NorieCloudSyncStatus.error => 'Sync needs attention',
                _ => 'Cloud account connected',
              }
            : account.isCloudConfigured
                ? 'Sign in to sync across devices'
                : 'Local-only build';

        final statusColor = signedIn
            ? switch (sync.status) {
                NorieCloudSyncStatus.synced => NorieColors.green,
                NorieCloudSyncStatus.error => NorieColors.magenta,
                NorieCloudSyncStatus.syncing => NorieColors.orange,
                NorieCloudSyncStatus.pending => NorieColors.orange,
                _ => NorieColors.cyan,
              }
            : NorieColors.textSecondary;

        return Material(
          color: NorieColors.surface,
          borderRadius: BorderRadius.circular(19),
          child: InkWell(
            borderRadius: BorderRadius.circular(19),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => const AccountScreen(),
                ),
              );
            },
            child: Container(
              padding: const EdgeInsets.all(15),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(19),
                border: Border.all(color: NorieColors.border),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: statusColor.withValues(alpha: .10),
                      borderRadius: BorderRadius.circular(13),
                    ),
                    child: Icon(
                      signedIn
                          ? Icons.cloud_done_rounded
                          : Icons.cloud_outlined,
                      color: statusColor,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          signedIn
                              ? account.email ?? 'Norie Account'
                              : 'Norie Account',
                          style: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 13,
                          ),
                        ),
                        const SizedBox(height: 3),
                        Text(
                          status,
                          style: TextStyle(
                            color: statusColor,
                            fontSize: 10,
                            fontWeight: FontWeight.w700,
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
      },
    );
  }
}
