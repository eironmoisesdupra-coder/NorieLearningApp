import 'package:flutter/material.dart';
import '../../../core/mascot/norie_mascot_controller.dart';
import '../../../core/mascot/norie_mascot_view.dart';

class DiscoveryDialogue extends StatelessWidget {
  const DiscoveryDialogue(
      {required this.controller,
      required this.message,
      required this.skipped,
      required this.onSkip,
      super.key});
  final NorieMascotController controller;
  final String message;
  final bool skipped;
  final VoidCallback onSkip;

  @override
  Widget build(BuildContext context) => Card(
      child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(children: [
            Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
              // Expressions change with saved events. No idle animation loop is needed
              // for this small-room investigation, including when a route is covered.
              ExcludeSemantics(
                  child: NorieMascotView(
                      controller: controller, size: 76, reduceMotion: true)),
              Expanded(
                  child: Semantics(
                      liveRegion: true,
                      child: Text(skipped
                          ? 'Norie is here when you need help.'
                          : message))),
            ]),
            Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                    onPressed: onSkip,
                    child: Text(skipped ? 'Show dialogue' : 'Skip dialogue'))),
          ])));
}
