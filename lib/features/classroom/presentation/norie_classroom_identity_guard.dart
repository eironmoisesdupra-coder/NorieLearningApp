import 'package:flutter/material.dart';
import '../../../core/account/norie_account_service.dart';
import '../../../core/progression/norie_adventure_progress.dart';

/// Hide an open classroom route immediately when its learner scope changes.
mixin NorieClassroomIdentityGuard<T extends StatefulWidget> on State<T> {
  final _learnerGuard = NorieAccountService.instance.captureLearnerGuard();
  final _ownership = NorieAdventureProgress.instance.ownershipRevision;
  bool get current =>
      _learnerGuard() &&
      _ownership == NorieAdventureProgress.instance.ownershipRevision;
  void _changed() {
    if (mounted && !current) setState(() {});
  }

  @override
  void initState() {
    super.initState();
    NorieAccountService.instance.addListener(_changed);
    NorieAdventureProgress.instance.addListener(_changed);
  }

  @override
  void dispose() {
    NorieAccountService.instance.removeListener(_changed);
    NorieAdventureProgress.instance.removeListener(_changed);
    super.dispose();
  }
}
