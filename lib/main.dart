import 'dart:async';

import 'package:flutter/material.dart';

import 'app/norie_app.dart';
import 'core/account/norie_account_service.dart';
import 'core/account/norie_demo_access_service.dart';
import 'core/cloud/norie_cloud_sync.dart';
import 'core/cloud/supabase_config.dart';
import 'core/progression/norie_progression.dart';
import 'features/study/data/norie_study_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NorieProgression.instance.load();

  // Lessons and local progress must be available before any network work.
  runApp(const NorieApp());
  unawaited(_initializeCloud());
}

Future<void> _initializeCloud() async {
  try {
    final cloudReady = await NorieSupabase.initialize();
    if (cloudReady) {
      await NorieAccountService.instance.initialize();
      NorieAccountService.instance.addListener(() {
        unawaited(NorieStudyService.instance.syncPendingAttempts());
      });
      unawaited(NorieStudyService.instance.syncPendingAttempts());
      await NorieDemoAccessService.instance.initialize();
      await NorieCloudSync.instance.initialize();
    }
  } catch (_) {
    // Cloud recovery is optional. Local learning keeps running if it fails.
  }
}
