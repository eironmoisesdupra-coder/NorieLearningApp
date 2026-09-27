import 'dart:async';

import 'package:flutter/material.dart';

import 'app/norie_app.dart';
import 'core/account/norie_account_service.dart';
import 'core/cloud/norie_cloud_sync.dart';
import 'core/cloud/supabase_config.dart';
import 'core/progression/norie_progression.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await NorieProgression.instance.load();

  final cloudReady = await NorieSupabase.initialize();
  if (cloudReady) {
    await NorieAccountService.instance.initialize();
  }

  unawaited(NorieCloudSync.instance.initialize());

  runApp(const NorieApp());
}
