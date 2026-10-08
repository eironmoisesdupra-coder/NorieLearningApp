import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/features/content/application/norie_activity_engine.dart';

void main() {
  test(
      'typed mathematical answers preserve signs, decimal points and fraction bars',
      () {
    expect(norieAnswerMatches('-3', '3'), false);
    expect(norieAnswerMatches('1/2', '1.2'), false);
    expect(norieAnswerMatches('−3', '-3'), true);
    expect(norieAnswerMatches(' 20 J ', '20 j'), true);
    expect(norieAnswerMatches(' Photosynthesis! ', 'photosynthesis'), true);
  });
}
