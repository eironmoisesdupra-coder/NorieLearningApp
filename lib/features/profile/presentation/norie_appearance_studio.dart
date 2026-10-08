import 'dart:math' as math;
import 'package:flutter/material.dart';
import '../../../core/assets/norie_assets.dart';
import '../../../core/account/norie_account_service.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/progression/norie_adventure_progress.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_profile_appearance_store.dart';
import '../domain/norie_profile_appearance.dart';
import '../../content/data/norie_foundation_curriculum.dart';

/// Changes remain an isolated draft until Save; back and Cancel discard them.
class NorieAppearanceStudio extends StatefulWidget {
  const NorieAppearanceStudio(
      {super.key,
      this.store,
      this.level,
      this.trophyIds,
      this.displayName = 'Norie Learner'});
  final NorieProfileAppearanceStore? store;
  final int? level;
  final Set<String>? trophyIds;
  final String displayName;
  @override
  State<NorieAppearanceStudio> createState() => _NorieAppearanceStudioState();
}

class _NorieAppearanceStudioState extends State<NorieAppearanceStudio> {
  late final NorieProfileAppearanceStore store;
  late NorieProfileAppearance draft;
  late List<NorieProfileAppearance> presets;
  late int revision;
  late final bool Function() _sessionCurrent;
  bool saving = false;
  String? message;
  int get level => widget.level ?? NorieProgression.instance.snapshot.level;
  int get ownedLevel => level > store.rankLevel ? level : store.rankLevel;
  Set<String> get trophies =>
      widget.trophyIds ?? NorieAdventureProgress.instance.trophyIds;
  @override
  void initState() {
    super.initState();
    store = widget.store ?? NorieProfileAppearanceStore.instance;
    draft = store.value;
    presets = List.of(store.presets);
    revision = store.revision;
    _sessionCurrent = NorieAccountService.instance.captureLearnerGuard();
  }

  void change(NorieProfileAppearance value) => setState(() {
        draft = value;
        message = null;
      });
  Future<void> save() async {
    setState(() {
      saving = true;
      message = null;
    });
    try {
      final saved = await store.save(draft,
          expectedRevision: revision,
          level: level,
          trophyIds: trophies,
          presets: presets,
          stillCurrent: _sessionCurrent);
      if (!mounted) return;
      if (saved) {
        Navigator.of(context).pop();
        return;
      }
      setState(() {
        message =
            'Your learner profile changed, or an item is no longer eligible. Close and reopen the studio before saving.';
      });
    } catch (_) {
      if (!mounted) return;
      // A failed local write remains retryable with the current draft revision.
      if (store.revision == revision + 1) revision = store.revision;
      setState(() {
        message = 'Could not save on this device. Please try Save again.';
      });
    }
    if (mounted) {
      setState(() {
        saving = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final current = NorieAppearanceCatalog.bundleForLevel(ownedLevel);
    return Scaffold(
      appBar: AppBar(title: const Text('Appearance studio')),
      body: Center(
          child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 760),
              child: ListView(padding: const EdgeInsets.all(16), children: [
                const Text('MAKE IT YOURS',
                    style: TextStyle(
                        color: NorieColors.cyan,
                        letterSpacing: 2,
                        fontSize: 12,
                        fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text('A little more you.',
                    style:
                        TextStyle(fontSize: 27, fontWeight: FontWeight.w900)),
                const SizedBox(height: 8),
                const Text(
                    'Preview your look below. Cosmetics are permanent rewards; they never change lesson access, XP or league points.'),
                const SizedBox(height: 16),
                NorieAppearancePreview(
                    value: draft,
                    displayName: widget.displayName,
                    subtitle: 'Preview · ${current.title}',
                    trophyLabels: draft.showcase.map(trophyLabel).toList()),
                const SizedBox(height: 20),
                _section('Bundled avatars',
                    'Original Norie symbols, ready offline. Photo upload is not available in this release.'),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final entry in NorieAppearanceCatalog.avatars.entries)
                    _choice(
                        entry.value,
                        draft.avatarId == entry.key,
                        NorieAppearanceCatalog.avatarLevel(entry.key),
                        () => change(draft.copyWith(avatarId: entry.key)),
                        icon: avatarIcon(entry.key))
                ]),
                _section('Profile frame',
                    'Each rank brings a new frame. Owned frames stay in your collection.'),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final b in NorieAppearanceCatalog.bundles)
                    _choice(b.title, draft.frameId == b.id, b.level,
                        () => change(draft.copyWith(frameId: b.id)),
                        icon: Icons.filter_frames_rounded)
                ]),
                _section('Theme & accent',
                    'Choose a palette, then edit its accent using one of three readable colors.'),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final b in NorieAppearanceCatalog.bundles)
                    _choice(
                        b.title,
                        draft.paletteId == b.id,
                        b.level,
                        () => change(
                            draft.copyWith(paletteId: b.id, accentIndex: 0)),
                        icon: Icons.palette_outlined)
                ]),
                const SizedBox(height: 12),
                Wrap(spacing: 12, runSpacing: 8, children: [
                  for (var i = 0; i < 3; i++)
                    ChoiceChip(
                        label: Text('Accent ${i + 1}'),
                        avatar: CircleAvatar(
                            backgroundColor:
                                NorieAppearanceCatalog.bundle(draft.paletteId)
                                    .colors[i],
                            radius: 9),
                        selected: draft.accentIndex == i,
                        onSelected: saving
                            ? null
                            : (_) => change(draft.copyWith(accentIndex: i)))
                ]),
                _section('Norie pose',
                    'Full-body artwork keeps Norie looking like Norie.'),
                Wrap(spacing: 8, runSpacing: 8, children: [
                  for (final entry in NorieAppearanceCatalog.poses.entries)
                    _choice(
                        entry.value,
                        draft.poseId == entry.key,
                        NorieAppearanceCatalog.poseLevel(entry.key),
                        () => change(draft.copyWith(poseId: entry.key)),
                        icon: Icons.auto_awesome_outlined)
                ]),
                _section('Achievement showcase',
                    'Select up to ${current.showcaseCapacity} earned trophies. Only these selected awards appear in your display preview; learning difficulties and full history stay private.'),
                if (trophies.isEmpty)
                  const Text(
                      'Complete a subject grade path to earn your first permanent trophy.')
                else
                  Wrap(spacing: 8, runSpacing: 8, children: [
                    for (final id in trophies)
                      FilterChip(
                          label: Text(trophyLabel(id)),
                          avatar:
                              const Icon(Icons.emoji_events_outlined, size: 18),
                          selected: draft.showcase.contains(id),
                          onSelected: saving
                              ? null
                              : (selected) {
                                  final selectedIds =
                                      List<String>.of(draft.showcase);
                                  if (selected) {
                                    if (selectedIds.length >=
                                        current.showcaseCapacity) {
                                      setState(() {
                                        message =
                                            'Your ${current.title} showcase holds ${current.showcaseCapacity} trophies. Deselect one to choose another.';
                                      });
                                      return;
                                    }
                                    selectedIds.add(id);
                                  } else {
                                    selectedIds.remove(id);
                                  }
                                  change(draft.copyWith(showcase: selectedIds));
                                })
                  ]),
                _section('Saved looks',
                    '${presets.length}/${current.presetCapacity} personal presets. Presets are saved together with your appearance.'),
                for (var i = 0; i < presets.length; i++)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 8),
                      child: Wrap(
                          spacing: 8,
                          runSpacing: 8,
                          crossAxisAlignment: WrapCrossAlignment.center,
                          children: [
                            OutlinedButton.icon(
                                onPressed:
                                    saving ? null : () => change(presets[i]),
                                icon: const Icon(Icons.bookmark_outline),
                                label: Text('Use look ${i + 1}')),
                            IconButton(
                                tooltip: 'Delete look ${i + 1}',
                                onPressed: saving
                                    ? null
                                    : () => setState(() {
                                          presets.removeAt(i);
                                        }),
                                icon: const Icon(Icons.delete_outline))
                          ])),
                Align(
                    alignment: Alignment.centerLeft,
                    child: OutlinedButton.icon(
                        onPressed:
                            saving || presets.length >= current.presetCapacity
                                ? null
                                : () => setState(() {
                                      presets.add(draft);
                                    }),
                        icon: const Icon(Icons.add),
                        label: const Text('Keep this look as a preset'))),
                _section('Rank collection',
                    'All benefits are permanent cosmetics. Future bundles can be inspected below.'),
                for (final b in NorieAppearanceCatalog.bundles)
                  Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: Card(
                          child: Padding(
                              padding: const EdgeInsets.all(14),
                              child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Wrap(
                                        spacing: 8,
                                        runSpacing: 4,
                                        crossAxisAlignment:
                                            WrapCrossAlignment.center,
                                        children: [
                                          Icon(
                                              b.level <= ownedLevel
                                                  ? Icons.check_circle_outline
                                                  : Icons.lock_outline,
                                              color: b.colors.first),
                                          Text('${b.title} · Level ${b.level}',
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.w900)),
                                          Text(b.level <= ownedLevel
                                              ? 'Owned · permanent'
                                              : 'Locked · reach level ${b.level}')
                                        ]),
                                    const SizedBox(height: 8),
                                    Text(
                                        '${NorieAppearanceCatalog.avatars[b.avatar]} avatar · ${b.title} frame & palette · ${NorieAppearanceCatalog.poses[b.pose]} pose'),
                                    const SizedBox(height: 6),
                                    Text(
                                        '${b.showcaseCapacity} showcase slots · ${b.presetCapacity} saved looks'),
                                    const SizedBox(height: 8),
                                    OutlinedButton(
                                        onPressed: () => showModalBottomSheet<
                                                void>(
                                            context: context,
                                            isScrollControlled: true,
                                            builder: (_) => SafeArea(
                                                child: SingleChildScrollView(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            20),
                                                    child: Column(
                                                        mainAxisSize:
                                                            MainAxisSize.min,
                                                        children: [
                                                          Text(
                                                              '${b.title} reward preview',
                                                              style: const TextStyle(
                                                                  fontSize: 20,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w900)),
                                                          const SizedBox(
                                                              height: 12),
                                                          NorieAppearancePreview(
                                                              value: NorieProfileAppearance(
                                                                  avatarId:
                                                                      b.avatar,
                                                                  frameId: b.id,
                                                                  paletteId:
                                                                      b.id,
                                                                  poseId:
                                                                      b.pose),
                                                              displayName: widget
                                                                  .displayName,
                                                              subtitle:
                                                                  'Unlocks at level ${b.level}'),
                                                          const SizedBox(
                                                              height: 12),
                                                          const Text(
                                                              'Preview only. Keep learning to unlock this permanent cosmetic bundle.'),
                                                          TextButton(
                                                              onPressed: () =>
                                                                  Navigator.pop(
                                                                      context),
                                                              child: const Text(
                                                                  'Close preview'))
                                                        ])))),
                                        child: const Text('Preview bundle'))
                                  ])))),
                if (message != null)
                  Padding(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      child: Semantics(
                          liveRegion: true,
                          child: Text(message!,
                              style:
                                  const TextStyle(color: NorieColors.orange)))),
                const SizedBox(height: 10),
                Wrap(spacing: 10, runSpacing: 10, children: [
                  FilledButton.icon(
                      onPressed: saving ? null : save,
                      icon: const Icon(Icons.check),
                      label: Text(saving ? 'Saving…' : 'Save appearance')),
                  OutlinedButton(
                      onPressed: saving ? null : () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  TextButton(
                      onPressed: saving
                          ? null
                          : () => setState(() {
                                draft = const NorieProfileAppearance();
                                presets = [];
                                message =
                                    'Default look previewed. Save to apply, or Cancel to keep your current look.';
                              }),
                      child: const Text('Reset preview'))
                ]),
                const SizedBox(height: 12),
                const Text(
                    'Saved on this device first. Signed-in account backup handles sync; cross-device changes are available after sync succeeds.',
                    style: TextStyle(
                        color: NorieColors.textSecondary, fontSize: 12)),
                const SizedBox(height: 30),
              ]))),
    );
  }

  Widget _section(String title, String help) => Padding(
      padding: const EdgeInsets.only(top: 22, bottom: 10),
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text(title,
            style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w900)),
        const SizedBox(height: 5),
        Text(help,
            style:
                const TextStyle(color: NorieColors.textSecondary, height: 1.4))
      ]));
  Widget _choice(
      String label, bool selected, int requiredLevel, VoidCallback select,
      {required IconData icon}) {
    final owned = requiredLevel <= ownedLevel;
    return ChoiceChip(
        label: Text(owned ? label : '$label · Level $requiredLevel'),
        avatar: Icon(owned ? icon : Icons.lock_outline, size: 18),
        selected: selected,
        onSelected: saving || !owned ? null : (_) => select());
  }
}

String trophyLabel(String id) {
  final kind = id.split(':').first;
  final parts = id.split(':').skip(1).join(':').split('.');
  if (parts.length < 2 || parts.first.isEmpty) {
    return switch (kind) {
      'improvement' => 'Improvement badge',
      'mastery' => 'Retained mastery badge',
      'chapter' => 'Chapter challenge badge',
      _ => 'Earned trophy',
    };
  }
  final subject = parts.first;
  final gradeId = parts[1].split(':').first;
  final grade = gradeId == 'college'
      ? 'College'
      : gradeId.replaceFirst(RegExp(r'^g'), 'Grade ');
  final award = switch (kind) {
    'expanded' => 'Extended path',
    'improvement' => 'Improvement',
    'mastery' => 'Retained mastery',
    'path-mastery' => 'Whole-path mastery',
    'chapter' => 'Chapter challenge',
    _ => 'Original map complete',
  };
  final prefix = '$grade ${subject[0].toUpperCase()}${subject.substring(1)}';
  if ((kind == 'mastery' || kind == 'improvement') &&
      const ['science', 'mathematics', 'english'].contains(subject) &&
      NorieFoundationCurriculum.gradeLevels
          .any((grade) => grade.id == gradeId)) {
    final topicId = id.substring(id.indexOf(':') + 1);
    for (final topic in NorieFoundationCurriculum.topicsFor(subject, gradeId)) {
      if (topic.id == topicId) return '$prefix · ${topic.title} · $award';
    }
  }
  return '$prefix · $award';
}

IconData avatarIcon(String id) => switch (id) {
      'comet' => Icons.auto_awesome_rounded,
      'leaf' => Icons.eco_rounded,
      'orbit' => Icons.public_rounded,
      'prism' => Icons.diamond_outlined,
      _ => Icons.face_rounded,
    };

class NorieAppearancePreview extends StatelessWidget {
  const NorieAppearancePreview(
      {super.key,
      required this.value,
      required this.displayName,
      required this.subtitle,
      this.trophyLabels = const []});
  final NorieProfileAppearance value;
  final String displayName, subtitle;
  final List<String> trophyLabels;
  @override
  Widget build(BuildContext context) {
    final color = NorieAppearanceCatalog.accent(value);
    final frame = NorieAppearanceCatalog.bundle(value.frameId);
    final poseAsset = switch (value.poseId) {
      'study' => NorieAssets.mascotStudying,
      'celebrate' => NorieAssets.mascotCelebrating,
      _ => NorieAssets.mascotBase,
    };
    return Container(
        padding: const EdgeInsets.all(18),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  color.withValues(alpha: .18),
                  const Color(0xFF171632),
                  frame.colors.last.withValues(alpha: .12)
                ]),
            border: Border.all(color: color.withValues(alpha: .6))),
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Wrap(
              spacing: 18,
              runSpacing: 12,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Semantics(
                    label:
                        '${NorieAppearanceCatalog.avatars[value.avatarId]} avatar, ${frame.title} frame',
                    child: Container(
                        width: 88,
                        height: 88,
                        padding: const EdgeInsets.all(5),
                        decoration: BoxDecoration(
                            shape: frame.level >= 15
                                ? BoxShape.rectangle
                                : BoxShape.circle,
                            borderRadius: frame.level >= 15
                                ? BorderRadius.circular(
                                    frame.level >= 50 ? 16 : 28)
                                : null,
                            border: Border.all(
                                color: frame.colors.first,
                                width: frame.level >= 30 ? 4 : 2),
                            boxShadow: [
                              BoxShadow(
                                  color: color.withValues(alpha: .16),
                                  blurRadius: 20)
                            ],
                            color: const Color(0xFF121B35)),
                        child: value.avatarId == 'norie'
                            ? Image.asset(NorieAssets.mascotBase,
                                fit: BoxFit.contain)
                            : CustomPaint(
                                painter: _NorieSymbolPainter(
                                    value.avatarId, color)))),
                Semantics(
                    label:
                        'Norie ${NorieAppearanceCatalog.poses[value.poseId]} pose',
                    child: Image.asset(poseAsset,
                        width: 96, height: 110, fit: BoxFit.contain)),
              ]),
          const SizedBox(height: 12),
          Text(displayName,
              style: TextStyle(
                  color: color, fontSize: 23, fontWeight: FontWeight.w900)),
          const SizedBox(height: 4),
          Text(subtitle,
              style: const TextStyle(color: NorieColors.textSecondary)),
          if (trophyLabels.isNotEmpty) ...[
            const SizedBox(height: 12),
            Wrap(spacing: 6, runSpacing: 6, children: [
              for (final label in trophyLabels)
                Chip(
                    avatar: Icon(Icons.emoji_events_outlined,
                        size: 18, color: color),
                    label: Text(label))
            ]),
          ],
        ]));
  }
}

/// Original code-native avatar artwork, bundled with the app and usable offline.
class _NorieSymbolPainter extends CustomPainter {
  const _NorieSymbolPainter(this.symbol, this.color);
  final String symbol;
  final Color color;
  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = math.min(size.width, size.height) * .36;
    final paint = Paint()..color = color;
    canvas.drawCircle(
        center, radius * 1.25, Paint()..color = color.withValues(alpha: .09));
    if (symbol == 'leaf') {
      final leaf = Path()
        ..moveTo(center.dx - radius * .7, center.dy + radius * .7)
        ..cubicTo(
            center.dx - radius,
            center.dy - radius,
            center.dx + radius * .4,
            center.dy - radius,
            center.dx + radius,
            center.dy - radius)
        ..cubicTo(
            center.dx + radius,
            center.dy + radius * .6,
            center.dx,
            center.dy + radius,
            center.dx - radius * .7,
            center.dy + radius * .7);
      canvas.drawPath(leaf, paint);
      canvas.drawLine(
          center + Offset(-radius * .65, radius * .8),
          center + Offset(radius * .55, -radius * .55),
          Paint()
            ..color = const Color(0xFF13283A)
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round);
    } else if (symbol == 'orbit') {
      canvas.save();
      canvas.translate(center.dx, center.dy);
      canvas.rotate(-.5);
      canvas.drawOval(
          Rect.fromCenter(
              center: Offset.zero, width: radius * 2.5, height: radius * 1.2),
          Paint()
            ..color = color
            ..style = PaintingStyle.stroke
            ..strokeWidth = 3);
      canvas.drawCircle(Offset.zero, radius * .65, paint);
      canvas.drawCircle(Offset(radius, -radius * .35), radius * .16,
          Paint()..color = Colors.white);
      canvas.restore();
    } else if (symbol == 'prism') {
      final top = center + Offset(0, -radius),
          left = center + Offset(-radius, 0),
          bottom = center + Offset(0, radius),
          right = center + Offset(radius, 0);
      canvas.drawPath(
          Path()
            ..moveTo(top.dx, top.dy)
            ..lineTo(left.dx, left.dy)
            ..lineTo(bottom.dx, bottom.dy)
            ..lineTo(right.dx, right.dy)
            ..close(),
          paint);
      canvas.drawPath(
          Path()
            ..moveTo(top.dx, top.dy)
            ..lineTo(center.dx, center.dy)
            ..lineTo(right.dx, right.dy)
            ..close(),
          Paint()..color = Colors.white.withValues(alpha: .35));
      canvas.drawPath(
          Path()
            ..moveTo(left.dx, left.dy)
            ..lineTo(center.dx, center.dy)
            ..lineTo(bottom.dx, bottom.dy)
            ..close(),
          Paint()..color = const Color(0xFF111E42).withValues(alpha: .25));
    } else {
      final star = Path();
      for (var i = 0; i < 8; i++) {
        final angle = i * math.pi / 4 - math.pi / 2;
        final r = i.isEven ? radius : radius * .32;
        final point = center + Offset(math.cos(angle) * r, math.sin(angle) * r);
        if (i == 0) {
          star.moveTo(point.dx, point.dy);
        } else {
          star.lineTo(point.dx, point.dy);
        }
      }
      canvas.drawPath(star..close(), paint);
      canvas.drawCircle(center + Offset(radius * .85, -radius * .75),
          radius * .13, Paint()..color = Colors.white);
      canvas.drawLine(
          center + Offset(-radius * .7, radius * .8),
          center + Offset(-radius * 1.2, radius * 1.1),
          Paint()
            ..color = color.withValues(alpha: .5)
            ..strokeWidth = 3
            ..strokeCap = StrokeCap.round);
    }
  }

  @override
  bool shouldRepaint(_NorieSymbolPainter oldDelegate) =>
      symbol != oldDelegate.symbol || color != oldDelegate.color;
}
