import 'package:flutter/material.dart';

import 'app/norie_app.dart';
import 'core/progression/norie_progression.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NorieProgression.instance.load();
  runApp(const NorieApp());
}
