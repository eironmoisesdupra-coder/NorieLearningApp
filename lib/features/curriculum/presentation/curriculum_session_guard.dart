import 'package:flutter/material.dart';
import '../../../core/account/norie_account_service.dart';

/// A generation guard remains invalid after A -> B -> A account switches.
mixin CurriculumSessionGuard<T extends StatefulWidget> on State<T> {
  late final bool Function() _sameLearner;
  bool get curriculumSessionCurrent => mounted && _sameLearner();
  @override
  void initState() {
    super.initState();
    _sameLearner = NorieAccountService.instance.captureLearnerGuard();
    NorieAccountService.instance.addListener(_identityChanged);
  }

  void _identityChanged() {
    if (mounted && !_sameLearner()) setState(() {});
  }

  void requireCurrentCurriculumSession() {
    if (!curriculumSessionCurrent) {
      throw const FormatException(
          'Learner changed. Close and reopen this screen.');
    }
  }

  Widget get changedCurriculumSession => Scaffold(
      appBar: AppBar(title: const Text('Learner changed')),
      body: const SafeArea(
          child: Center(
              child: Padding(
                  padding: EdgeInsets.all(24),
                  child: Text(
                      'Close this screen and reopen it for the current learner. Your existing drafts remain with their owner.')))));
  @override
  void dispose() {
    NorieAccountService.instance.removeListener(_identityChanged);
    super.dispose();
  }
}
