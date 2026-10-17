import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:norie_learning/core/progression/norie_progression.dart';
import 'package:norie_learning/core/release/norie_app_progress_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _SavePicker extends FilePickerPlatform {
  int saves = 0;
  @override
  Future<Uri?> saveFile({
    required String fileName,
    required Uint8List bytes,
    required String mimeType,
    String? dialogTitle,
    String? initialDirectory,
    Function(FilePickerStatus)? onFileSaving,
    WindowsOptions windowsOptions = const WindowsOptions(),
    LinuxOptions linuxOptions = const LinuxOptions(),
    WebOptions webOptions = const WebOptions(),
  }) async {
    saves++;
    return Uri.file('C:/backup.json');
  }
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  testWidgets(
      'export refuses a partial snapshot when saved feature data needs recovery',
      (tester) async {
    final picker = _SavePicker();
    final previousPicker = FilePickerPlatform.instance;
    FilePickerPlatform.instance = picker;
    final progress = NorieProgression.instance;
    addTearDown(() => FilePickerPlatform.instance = previousPicker);
    SharedPreferences.setMockInitialValues(
        {'norie.seasonal.v1.guest': '{damaged'});
    await tester.runAsync(progress.load);
    await tester.pumpWidget(const MaterialApp(home: NorieAppProgressScreen()));
    final export = find.text('Export progress backup');
    await tester.scrollUntilVisible(export, 300);
    await tester.tap(export);
    for (var i = 0; i < 30; i++) {
      await tester.pump(const Duration(milliseconds: 100));
      await tester.runAsync(
          () => Future<void>.delayed(const Duration(milliseconds: 10)));
      if (find.textContaining('Could not finish.').evaluate().isNotEmpty) break;
    }
    await tester.pump();
    expect(picker.saves, 0,
        reason:
            'An incomplete feature placeholder must never be exported as a safe backup.');
    expect(find.textContaining('Could not finish.'), findsOneWidget);
    expect(
        (await SharedPreferences.getInstance())
            .getString('norie.seasonal.v1.guest'),
        '{damaged');
  });
}
