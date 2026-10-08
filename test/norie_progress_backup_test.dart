import 'dart:convert';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progress_backup.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';

void main() {
  final state = NorieProgression.instance.exportCloudState();
  test('versioned learning backup roundtrips without credentials', () {
    final text = NorieProgressBackup.encode(state, owner: 'learner-a');
    expect(NorieProgressBackup.decode(text, currentOwner: 'learner-a'), state);
    expect(text, isNot(contains('access_token')));
  });
  test('restore rejects another account and malformed or future backups', () {
    final text = NorieProgressBackup.encode(state, owner: 'learner-a');
    expect(() => NorieProgressBackup.decode(text, currentOwner: 'learner-b'),
        throwsFormatException);
    expect(() => NorieProgressBackup.decode(text), throwsFormatException);
    expect(() => NorieProgressBackup.decode('{'), throwsFormatException);
    final doc = jsonDecode(text) as Map<String, dynamic>;
    doc['version'] = 999;
    expect(
        () => NorieProgressBackup.decode(jsonEncode(doc),
            currentOwner: 'learner-a'),
        throwsFormatException);
  });
  test('invalid rewards and mastery are rejected before import', () {
    for (final value in [-1, '100', double.infinity]) {
      expect(() => NorieProgressBackup.encode({...state, 'total_xp': value}),
          throwsFormatException);
    }
    expect(
        () => NorieProgressBackup.encode({
              ...state,
              'topic_mastery': {
                'x': {'correct': 5, 'attempts': 1}
              }
            }),
        throwsFormatException);
    expect(
        () => NorieProgressBackup.encode({
              ...state,
              'credit_transactions': ['broken']
            }),
        throwsFormatException);
  });
  test('unknown fields and incomplete snapshots cannot be restored silently',
      () {
    expect(
        () => NorieProgressBackup.encode({...state, 'access_token': 'secret'}),
        throwsFormatException);
    expect(() => NorieProgressBackup.encode({'total_xp': 5}),
        throwsFormatException);
  });
  test('nested reward and mastery records reject unexpected fields', () {
    final transaction = <String, dynamic>{
      'id': 'test-reward',
      'amount': 10,
      'reason': 'Test reward',
      'created_at': '2026-10-08T00:00:00Z',
    };
    expect(
        () => NorieProgressBackup.encode({
              ...state,
              'credit_transactions': [
                {...transaction, 'access_token': 'secret'}
              ],
            }),
        throwsFormatException);

    expect(
        () => NorieProgressBackup.encode({
              ...state,
              'topic_mastery': {
                'science.test': {
                  'category': 'Science',
                  'topic': 'Test',
                  'correct': 1,
                  'attempts': 1,
                  'unexpected': true,
                }
              },
            }),
        throwsFormatException);
  });
}
