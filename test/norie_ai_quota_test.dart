import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/study/domain/norie_study_models.dart';

void main() {
  test('AI quota parses server payload and exposes availability', () {
    final quota = NorieAiQuota.fromMap({
      'plan': 'free',
      'usage_date': '2026-09-28',
      'generation_used': 2,
      'generation_limit': 3,
      'generation_remaining': 1,
      'qa_used': 4,
      'qa_limit': 15,
      'qa_remaining': 11,
    });

    expect(quota.plan, 'free');
    expect(quota.generationRemaining, 1);
    expect(quota.canGenerate, isTrue);
    expect(quota.qaRemaining, 11);
    expect(quota.canAskNorie, isTrue);
  });

  test('AI quota reports exhausted generation allowance', () {
    final quota = NorieAiQuota.fromMap({
      'generation_used': 3,
      'generation_limit': 3,
      'generation_remaining': 0,
      'qa_used': 15,
      'qa_limit': 15,
      'qa_remaining': 0,
    });

    expect(quota.canGenerate, isFalse);
    expect(quota.canAskNorie, isFalse);
  });
}
