import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/account/norie_account_service.dart';
import '../data/norie_league_service.dart';

/// A distinct server-issued assessment. Normal offline practice never silently
/// becomes a ranked attempt. Retry stores the original proof, never client XP.
class NorieRankedAttemptScreen extends StatefulWidget {
  const NorieRankedAttemptScreen(
      {super.key, required this.cohortId, required this.owner});
  final String cohortId, owner;
  @override
  State<NorieRankedAttemptScreen> createState() =>
      _NorieRankedAttemptScreenState();
}

class _NorieRankedAttemptScreenState extends State<NorieRankedAttemptScreen> {
  final _service = NorieLeagueService();
  List<Map<String, dynamic>> _lessons = [], _questions = [];
  final Map<String, int> _answers = {};
  Map<String, dynamic>? _proof;
  bool _busy = false;
  String? _message;
  String get _pendingKey =>
      'norie.league.pending.v1:${jsonEncode(widget.owner)}:${widget.cohortId}';
  bool get _ownsSession =>
      NorieAccountService.instance.user?.id == widget.owner;
  @override
  void initState() {
    super.initState();
    NorieAccountService.instance.addListener(_accountChanged);
    _load();
  }

  void _accountChanged() {
    if (!_ownsSession && mounted) {
      setState(() {
        _questions = [];
        _lessons = [];
        _proof = null;
        _message = null;
        _answers.clear();
      });
    }
  }

  @override
  void dispose() {
    NorieAccountService.instance.removeListener(_accountChanged);
    super.dispose();
  }

  Future<void> _load() async {
    setState(() => _busy = true);
    try {
      final prefs = await SharedPreferences.getInstance();
      final pending = prefs.getString(_pendingKey);
      if (pending != null) {
        final saved = Map<String, dynamic>.from(jsonDecode(pending) as Map);
        if (DateTime.parse(saved['expires_at'] as String)
            .isAfter(DateTime.now().toUtc())) {
          if (mounted && _ownsSession) {
            setState(() {
              _proof = saved;
              _message =
                  'An earlier submission is pending. Retry its original server proof before starting another attempt.';
            });
          }
          return;
        }
        await prefs.remove(_pendingKey);
      }
      final result =
          await _service.call('lessons', {'cohort_id': widget.cohortId});
      if (mounted && _ownsSession) {
        setState(() => _lessons = (result['lessons'] as List)
            .map((r) => Map<String, dynamic>.from(r as Map))
            .toList());
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message =
            'Server practice is unavailable. Continue normal lessons offline.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _start(String lessonId) async {
    if (!_ownsSession) return;
    setState(() {
      _busy = true;
      _message = null;
    });
    try {
      final result = await _service
          .call('open', {'cohort_id': widget.cohortId, 'lesson_id': lessonId});
      if (mounted && _ownsSession) {
        setState(() {
          _proof = result;
          _questions = (result['questions'] as List)
              .map((r) => Map<String, dynamic>.from(r as Map))
              .toList();
        });
      }
    } catch (_) {
      if (mounted) {
        setState(() => _message =
            'No server attempt was issued. Try again while connected.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  Future<void> _submit() async {
    if (!_ownsSession || _proof == null) return;
    // Capture before the first await: account notifications can clear the live
    // proof/answer map while preferences or a network request is pending.
    final proof = Map<String, dynamic>.from(_proof!);
    final owner = widget.owner;
    final pendingKey = _pendingKey;
    final rawAnswers = _questions.isEmpty ? proof['answers'] : _answers;
    final payload = {
      ...proof,
      'answers': rawAnswers is Map
          ? Map<String, dynamic>.from(rawAnswers)
          : <String, dynamic>{}
    };
    setState(() => _busy = true);
    SharedPreferences? prefs;
    var savedPending = false;
    try {
      prefs = await SharedPreferences.getInstance();
      if (!mounted || !_ownsSession || widget.owner != owner) return;
      // Persist before calling the server: an interrupted response can be retried
      // idempotently until the original issued attempt expires.
      if (!await prefs.setString(pendingKey, jsonEncode(payload))) {
        await prefs.reload();
        throw StateError('Could not save the pending league proof.');
      }
      savedPending = true;
      if (!mounted || !_ownsSession || widget.owner != owner) return;
      final result = await _service.call('finish', {
        'attempt_id': payload['attempt_id'],
        'nonce': payload['nonce'],
        'answers': payload['answers']
      });
      await prefs.remove(pendingKey);
      if (mounted && _ownsSession) {
        setState(() {
          _questions = [];
          _proof = null;
          _lessons = [];
          _message =
              '${result['correct']} / ${result['total']} correct. ${result['points']} verified points awarded. ${result['reason']}';
        });
      }
    } on NorieLeagueException catch (error) {
      if (error.terminalAttempt) {
        await prefs?.remove(pendingKey);
        if (mounted && _ownsSession) {
          setState(() {
            _proof = null;
            _questions = [];
            _lessons = [];
            _message =
                'This attempt could not receive league credit (${error.code.replaceAll('_', ' ')}). Your normal lesson progress is preserved. Close this screen and start a fresh server practice when eligible.';
          });
        }
      } else if (mounted && _ownsSession) {
        setState(() => _message =
            'Submission remains provisional. Retry while connected before ${payload['expires_at']}.');
      }
    } catch (_) {
      if (mounted && _ownsSession) {
        setState(() => _message = savedPending
            ? 'Submission is provisional. Retry while connected before ${payload['expires_at']}. Expired or season-closed attempts receive no credit.'
            : 'Could not save this attempt on your device. Nothing was submitted to the league. Keep this screen open and try again.');
      }
    } finally {
      if (mounted) setState(() => _busy = false);
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Verified private practice')),
      body: SafeArea(
          child: ListView(padding: const EdgeInsets.all(16), children: [
        const Text(
            'Five authored questions. Answer independently. The server checks answers; local XP and practice scores are never submitted.'),
        if (!_ownsSession)
          const Text(
              'The account changed. Close this assessment and reopen it for the current learner.'),
        if (_busy)
          const Padding(
              padding: EdgeInsets.all(16), child: LinearProgressIndicator()),
        if (_message != null)
          Padding(
              padding: const EdgeInsets.symmetric(vertical: 16),
              child: Text(_message!)),
        if (_proof == null && _ownsSession)
          for (final lesson in _lessons)
            ListTile(
                title: Text(lesson['title'] as String),
                trailing: const Icon(Icons.play_arrow),
                onTap: _busy ? null : () => _start(lesson['id'] as String)),
        if (_ownsSession)
          for (final question in _questions)
            Card(
                child: Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(question['prompt'] as String,
                              style: Theme.of(context).textTheme.titleMedium),
                          const SizedBox(height: 8),
                          for (final option
                              in (question['options'] as List).asMap().entries)
                            Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 4),
                                child: SizedBox(
                                    width: double.infinity,
                                    child: OutlinedButton(
                                        onPressed: _busy
                                            ? null
                                            : () => setState(() =>
                                                _answers[question['id'] as String] =
                                                    option.key),
                                        style: _answers[question['id']] ==
                                                option.key
                                            ? OutlinedButton.styleFrom(
                                                backgroundColor:
                                                    Theme.of(context)
                                                        .colorScheme
                                                        .primaryContainer)
                                            : null,
                                        child: Text(option.value as String)))),
                        ]))),
        if (_proof != null && _ownsSession)
          FilledButton(
              onPressed: _busy ||
                      (_questions.isNotEmpty &&
                          _answers.length != _questions.length)
                  ? null
                  : _submit,
              child: Text(_questions.isEmpty
                  ? 'Retry pending submission'
                  : 'Submit for verification')),
      ])));
}
