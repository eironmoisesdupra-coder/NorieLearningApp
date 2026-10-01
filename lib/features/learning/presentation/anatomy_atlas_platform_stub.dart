import 'package:flutter/material.dart';
import 'anatomy_atlas_controller.dart';

class AnatomyAtlasPlatform extends StatelessWidget {
  const AnatomyAtlasPlatform(
      {required this.controller, required this.onMessage, super.key});
  final AnatomyAtlasController controller;
  final ValueChanged<Map<String, dynamic>> onMessage;
  @override
  Widget build(BuildContext context) => const Center(
      child: Text('3D atlas requires a supported browser or Android.'));
}
