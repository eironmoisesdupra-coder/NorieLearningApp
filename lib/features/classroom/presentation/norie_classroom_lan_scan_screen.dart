import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import '../lan/norie_classroom_lan_models.dart';

/// Android only. MobileScanner owns its camera lifecycle and disposal.
class NorieClassroomLanScanScreen extends StatefulWidget {
  const NorieClassroomLanScanScreen({super.key});
  @override
  State<NorieClassroomLanScanScreen> createState() => _ScanState();
}

class _ScanState extends State<NorieClassroomLanScanScreen> {
  bool finished = false;
  String? error;
  void detect(BarcodeCapture capture) {
    if (finished || !mounted) return;
    for (final barcode in capture.barcodes) {
      final value = barcode.rawValue;
      if (value == null) continue;
      try {
        NorieLanJoinInfo.parse(value);
        finished = true;
        Navigator.of(context).pop(value);
        return;
      } on FormatException {
        setState(() => error = 'Scan the classroom QR shown by your teacher.');
      }
    }
  }

  @override
  Widget build(BuildContext context) => Scaffold(
      appBar: AppBar(title: const Text('Scan teacher QR')),
      body: Column(children: [
        const Padding(
            padding: EdgeInsets.all(16),
            child: Text(
                'Point the camera at the QR on your teacher device. You can also go back and enter the address and code.')),
        Expanded(
            child: MobileScanner(
                onDetect: detect,
                errorBuilder: (_, __) => const Center(
                    child: Padding(
                        padding: EdgeInsets.all(16),
                        child: Text(
                            'Camera unavailable. Use the teacher address and code instead.'))))),
        if (error != null)
          Padding(padding: const EdgeInsets.all(16), child: Text(error!)),
      ]));
}
