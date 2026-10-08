import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/account/norie_learner_identity.dart';

void main() {
  test(
      'an activity cannot be reassigned across A to B to A while token refresh remains valid',
      () {
    final identity = NorieLearnerIdentity();
    identity.update('a');
    final guard = identity.capture();
    identity.update('a');
    expect(guard(), true);
    identity.update('b');
    expect(guard(), false);
    identity.update('a');
    expect(guard(), false);
    final second = identity.capture();
    identity.update(null);
    expect(second(), false);
    expect(identity.capture()(), true);
  });
}
