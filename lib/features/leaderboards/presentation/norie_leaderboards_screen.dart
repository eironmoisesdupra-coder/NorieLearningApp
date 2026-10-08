import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/account/norie_account_service.dart';
import '../../../core/account/norie_demo_access_service.dart';
import '../../../core/progression/norie_progression.dart';
import '../../../core/quiz/quiz_result_history.dart';
import '../../../core/theme/norie_theme.dart';
import '../data/norie_league_cache.dart';
import '../data/norie_league_service.dart';
import '../domain/norie_league_models.dart';
import 'norie_ranked_attempt_screen.dart';

class NorieLeaderboardsScreen extends StatefulWidget {
  const NorieLeaderboardsScreen({super.key});
  @override
  State<NorieLeaderboardsScreen> createState() =>
      _NorieLeaderboardsScreenState();
}

class _NorieLeaderboardsScreenState extends State<NorieLeaderboardsScreen> {
  final _service = NorieLeagueService();
  final _cache = NorieLeagueCache();
  List<NorieLeagueSnapshot> _boards = [];
  NorieLeagueBadgeShelf? _shelf;
  List<Map<String, dynamic>> _bests = [];
  int _tab = 0;
  int _generation = 0;
  bool _busy = false, _cached = true;
  String? _message;
  String get _owner => NorieAccountService.instance.user?.id ?? 'guest';
  @override
  void initState() {
    super.initState();
    NorieAccountService.instance.addListener(_accountChanged);
    _load();
  }

  @override
  void dispose() {
    NorieAccountService.instance.removeListener(_accountChanged);
    super.dispose();
  }

  void _accountChanged() {
    // Immediately hide the old account's rows before any asynchronous read.
    setState(() {
      _boards = [];
      _shelf = null;
      _bests = [];
      _message = null;
      _busy = false;
      _generation++;
    });
    _load();
  }

  Future<void> _load() async {
    final owner = _owner;
    final generation = _generation;
    final boards = await _cache.read(owner);
    final shelf = await _cache.readBadges(owner);
    final prefs = await SharedPreferences.getInstance();
    final bestByKey = <String, Map<String, dynamic>>{};
    try {
      final rows = jsonDecode(prefs.getString(QuizResultHistory.storageKeyFor(
              owner == 'guest' ? null : owner)) ??
          '[]') as List;
      for (final row in rows.whereType<Map>()) {
        if (row['key'] is! String || row['percentage'] is! num) continue;
        final key = row['key'] as String;
        if (bestByKey[key] == null ||
            (row['percentage'] as num) >
                (bestByKey[key]!['percentage'] as num)) {
          var title =
              row['title'] is String && (row['title'] as String).isNotEmpty
                  ? row['title'] as String
                  : 'Practice';
          try {
            final identity = jsonDecode(key);
            if (identity is List &&
                identity.isNotEmpty &&
                identity.first is String) {
              final source = identity.first as String;
              if (title == 'Practice' &&
                  !source.contains(':') &&
                  source.length < 100) {
                title = source;
              }
            }
          } catch (_) {/* Older history keys retain a neutral label. */}
          bestByKey[key] = {'title': title, 'percentage': row['percentage']};
        }
      }
    } catch (_) {/* Local history is optional. */}
    if (!mounted || owner != _owner || generation != _generation) return;
    setState(() {
      _boards = boards;
      _shelf = shelf;
      _bests = bestByKey.values.toList();
      _cached = true;
    });
    await _refresh();
  }

  Future<void> _refresh() async {
    final owner = _owner;
    final generation = ++_generation;
    if (owner == 'guest' || !_service.configured) {
      setState(() => _message =
          'Private leagues need a configured server and an approved account. Your personal bests work offline.');
      return;
    }
    if (!NorieDemoAccessService.instance.isAllowed) {
      setState(() => _message =
          'Private demo approval is required. League participation also needs an administrator-approved invitation.');
      return;
    }
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final boards = await _service.boards();
      final shelf = await _service.badges();
      if (!mounted || owner != _owner || generation != _generation) return;
      await _cache.write(owner, boards);
      await _cache.writeBadges(owner, shelf);
      if (!mounted || owner != _owner || generation != _generation) return;
      setState(() {
        _boards = boards;
        _shelf = shelf;
        _cached = false;
      });
    } catch (_) {
      if (mounted && owner == _owner && generation == _generation) {
        setState(() {
          _cached = true;
          _message =
              'Could not refresh private leagues. Any saved standings below show their last refresh time; they are not live. The league service may be offline or not deployed.';
        });
      }
    } finally {
      if (mounted && owner == _owner && generation == _generation) {
        setState(() => _busy = false);
      }
    }
  }

  Future<void> _action(String action, Map<String, dynamic> fields) async {
    final owner = _owner;
    setState(() => _busy = true);
    try {
      await _service.call(action, fields);
      if (!mounted || owner != _owner) return;
      if (action == 'leave' || action == 'delete_display') {
        await _cache.clear(owner);
        if (!mounted || owner != _owner) return;
        setState(() => _boards = []);
      }
      await _refresh();
      if (mounted && owner == _owner) {
        setState(() => _message = switch (action) {
              'join_request' =>
                'Invitation requested. Your class administrator must approve it before you can appear or compete.',
              'report' => 'Report sent privately to the league administrator.',
              'delete_display' =>
                'League display removed. Your learning progress stays on your device.',
              _ => 'Private league updated.',
            });
      }
    } catch (_) {
      if (mounted && owner == _owner) {
        setState(() => _message =
            'Request could not be confirmed. Connect with an approved account and try again; no membership or score is assumed.');
      }
    } finally {
      if (mounted && owner == _owner) setState(() => _busy = false);
    }
  }

  Future<void> _join() async {
    final controller = TextEditingController();
    final code = await showDialog<String>(
        context: context,
        builder: (context) => AlertDialog(
                title: const Text('Request a private invitation'),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  const Text(
                      'Use a code shared by your class administrator. Approval is required; no public search is available.'),
                  TextField(
                      controller: controller,
                      maxLength: 64,
                      decoration:
                          const InputDecoration(labelText: 'Invitation code')),
                ]),
                actions: [
                  TextButton(
                      onPressed: () => Navigator.pop(context),
                      child: const Text('Cancel')),
                  FilledButton(
                      onPressed: () =>
                          Navigator.pop(context, controller.text.trim()),
                      child: const Text('Request'))
                ]));
    controller.dispose();
    if (code != null && code.isNotEmpty) {
      await _action('join_request', {'code': code});
    }
  }

  Future<void> _practice(NorieLeagueSnapshot board) async {
    final owner = _owner;
    await Navigator.of(context).push(MaterialPageRoute<void>(
        builder: (_) =>
            NorieRankedAttemptScreen(cohortId: board.cohortId, owner: owner)));
    if (mounted && owner == _owner) await _refresh();
  }

  Widget _card(String title, String text, {Widget? actions}) => Card(
      child: Padding(
          padding: const EdgeInsets.all(16),
          child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
            Text(title, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Text(text),
            if (actions != null) ...[const SizedBox(height: 12), actions],
          ])));
  Widget _board(NorieLeagueSnapshot board) {
    final ended = DateTime.now().toUtc().isAfter(board.seasonEnd);
    final remaining = board.seasonEnd.difference(DateTime.now().toUtc());
    final nearby = nearbyLeagueRows(board.rows);
    final myRows = board.rows.where((row) => row.isMe);
    final myPoints = myRows.isEmpty ? 0 : myRows.first.points;
    final tier = NorieLeagueTier.forPoints(myPoints);
    return Card(
        child: Padding(
            padding: const EdgeInsets.all(16),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Text(board.title, style: Theme.of(context).textTheme.titleLarge),
              Text(
                  '${board.subject.toUpperCase()} · ${board.grade.toUpperCase()} · Invite only'),
              const SizedBox(height: 8),
              Text(
                  '${_cached ? 'Saved standings' : 'Refreshed'}: ${board.fetchedAt.toLocal().toString().split('.').first}'),
              Text(ended
                  ? 'Season completed. Permanent learning rewards are preserved.'
                  : '${remaining.inDays} days ${remaining.inHours.remainder(24)} hours remaining'),
              const Divider(),
              if (board.optedIn) ...[
                Text('${tier.title} League · $myPoints verified points'),
                const SizedBox(height: 8),
                LinearProgressIndicator(
                    value: tier.nextFloor == null
                        ? 1
                        : ((myPoints - tier.floor) /
                                (tier.nextFloor! - tier.floor))
                            .clamp(0.0, 1.0)),
                Text(tier.nextFloor == null
                    ? 'Master emblem earned. Current cohort milestones complete.'
                    : '${tier.nextFloor! - myPoints} points to the next league emblem'),
                const Text(
                    'League tiers are separate from account ranks. Earned emblems are permanent cosmetic displays.'),
                const SizedBox(height: 12),
              ],
              if (!board.optedIn)
                const Text(
                    'You are unranked. Opt in to display your assigned nickname to this private group.'),
              if (board.rows.isEmpty)
                const Text(
                    'No verified results yet. Nobody is added as an illustrative competitor.'),
              for (final row in nearby)
                ListTile(
                    contentPadding: EdgeInsets.zero,
                    leading: CircleAvatar(
                        backgroundColor: NorieColors.surfaceElevated,
                        child: Text('${leagueRank(board.rows, row)}')),
                    title: Text('${row.nickname}${row.isMe ? ' (you)' : ''}'),
                    subtitle: Text(
                        '${row.points} verified seasonal points${row.badgeTitle == null ? '' : '\n${row.badgeTitle}'}'),
                    trailing: row.isMe
                        ? null
                        : IconButton(
                            tooltip: 'Report display',
                            icon: const Icon(Icons.flag_outlined),
                            onPressed: _busy
                                ? null
                                : () => _action('report', {
                                      'cohort_id': board.cohortId,
                                      'member_id': row.memberId
                                    }))),
              const SizedBox(height: 8),
              const Text(
                  'Nearby positions shown. Equal points share a rank. These points never change lifetime XP. League emblems provide cosmetic recognition without speed bonuses or academic advantages.'),
              const SizedBox(height: 12),
              Wrap(spacing: 8, runSpacing: 8, children: [
                FilledButton(
                    onPressed: _busy || ended || _cached || !board.optedIn
                        ? null
                        : () => _practice(board),
                    child: const Text('Start verified practice')),
                OutlinedButton(
                    onPressed: _busy
                        ? null
                        : () => _action('opt_in', {
                              'cohort_id': board.cohortId,
                              'enabled': !board.optedIn
                            }),
                    child: Text(board.optedIn
                        ? 'Hide my display'
                        : 'Opt in privately')),
                TextButton(
                    onPressed: _busy
                        ? null
                        : () => _action('leave', {'cohort_id': board.cohortId}),
                    child: const Text('Leave group')),
              ]),
            ])));
  }

  @override
  Widget build(BuildContext context) {
    final achievements = NorieProgression.instance.achievements;
    return Scaffold(
        appBar: AppBar(title: const Text('Leagues & personal bests'), actions: [
          IconButton(
              onPressed: _busy ? null : _refresh,
              tooltip: 'Refresh standings',
              icon: const Icon(Icons.refresh))
        ]),
        body: SafeArea(
            child: ListView(padding: const EdgeInsets.all(16), children: [
          _card('Your learning, your choice',
              'Competition is optional and private. All lessons, XP and permanent rewards remain available without joining.'),
          const SizedBox(height: 12),
          Wrap(spacing: 8, runSpacing: 8, children: [
            for (final entry in const [
              'My League',
              'Subject Rankings',
              'Friends / Class',
              'Hall of Achievements'
            ].asMap().entries)
              ChoiceChip(
                  label: Text(entry.value),
                  selected: _tab == entry.key,
                  onSelected: (_) => setState(() => _tab = entry.key)),
          ]),
          if (_busy)
            const Padding(
                padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
          if (_message != null)
            Padding(
                padding: const EdgeInsets.symmetric(vertical: 12),
                child: Text(_message!)),
          if (_tab == 0) ...[
            _card('Private personal bests',
                'Saved on this device for the current learner. Practice percentages are local results, separate from verified league points.'),
            if (_bests.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'Complete practice to record your first personal best.')),
            for (final best in _bests)
              ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: Text(best['title'] as String),
                  subtitle: const Text('Private practice best'),
                  trailing: Text(
                      '${(best['percentage'] as num).toStringAsFixed(0)}%')),
            for (final board in _boards) _board(board),
          ],
          if (_tab == 1) ...[
            _card('Comparable subject groups',
                'Each board compares one subject and grade within one private season. Science, Mathematics and English each have six authored lesson opportunities per grade/course. Points are compared within that subject group; there is no mixed-subject ranking.'),
            if (_boards.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'No approved subject groups yet. Request an invitation in Friends / Class.')),
            for (final board in _boards) _board(board),
            _card('How verified points work',
                'A server-issued practice contains five authored questions. At least 80% earns 10 points, once per lesson per season, capped at 200 points. Answers are checked by the server. Attempts expire after 30 minutes or at season close. Offline lesson results remain private; late credit is never promised.'),
          ],
          if (_tab == 2) ...[
            _card('Friends and class invitations',
                'Only administrator-approved accounts can join a private group. Invitation requests do not grant access. An adult or guardian approval recorded by the administrator is required.',
                actions: FilledButton.icon(
                    onPressed:
                        _busy || _owner == 'guest' || !_service.configured
                            ? null
                            : _join,
                    icon: const Icon(Icons.mail_outline),
                    label: const Text('Request invitation'))),
            for (final board in _boards) _board(board),
            if (_owner != 'guest')
              TextButton(
                  onPressed: _busy || !_service.configured
                      ? null
                      : () => _action('delete_display', {}),
                  child: const Text('Delete all my league displays')),
          ],
          if (_tab == 3) ...[
            _card('Verified league emblems',
                'Earn Explorer on your first verified pass, then Pathfinder at 20 points, Scholar at 30, Specialist at 40 and Master at 60. These thresholds fit the six eligible lessons in each current subject-grade cohort. Earned emblems stay yours across seasons and can decorate your private league display.'),
            if (_shelf != null)
              Text(
                  'Emblem shelf last refreshed: ${_shelf!.fetchedAt.toLocal().toString().split('.').first}'),
            if (_shelf == null || _shelf!.badges.isEmpty)
              const Padding(
                  padding: EdgeInsets.all(16),
                  child: Text(
                      'No verified league emblems yet. Personal learning achievements below are available without competition.')),
            for (final badge in _shelf?.badges ?? <NorieLeagueBadge>[])
              Card(
                  child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(children: [
                              const Icon(Icons.workspace_premium_outlined),
                              const SizedBox(width: 8),
                              Expanded(child: Text(badge.title))
                            ]),
                            Text(
                                'Verified ${badge.earnedAt.toLocal().toString().split(' ').first} · Permanent cosmetic'),
                            Wrap(spacing: 8, runSpacing: 8, children: [
                              for (final board in _boards)
                                OutlinedButton(
                                    onPressed: _busy || _cached
                                        ? null
                                        : () => _action('equip_badge', {
                                              'cohort_id': board.cohortId,
                                              'badge_id': badge.id
                                            }),
                                    child: Text('Wear in ${board.title}'))
                            ]),
                          ]))),
            _card('Your permanent achievements',
                'This shelf uses your existing learning achievements. Season transitions do not remove them. It is private and available offline.'),
            for (final achievement in achievements)
              ListTile(
                  leading: Icon(achievement.unlocked
                      ? Icons.emoji_events
                      : Icons.lock_outline),
                  title: Text(achievement.title),
                  subtitle: Text(
                      '${achievement.description}\n${achievement.progressLabel}')),
          ],
        ])));
  }
}
