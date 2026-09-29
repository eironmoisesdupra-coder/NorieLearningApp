import 'dart:math' as math;
import 'dart:typed_data';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/services.dart';

abstract final class NorieRewardSound {
  static Uint8List? _coinBytes;

  static Future<void> playCoin() async {
    await HapticFeedback.lightImpact();
    final player = AudioPlayer();

    try {
      _coinBytes ??= _buildCoinChime();
      await player.play(
        BytesSource(_coinBytes!, mimeType: 'audio/wav'),
        volume: .34,
      );
      player.onPlayerComplete.first.then((_) => player.dispose());
    } catch (_) {
      await player.dispose();
      await SystemSound.play(SystemSoundType.click);
    }
  }

  static Uint8List _buildCoinChime() {
    const sampleRate = 44100;
    const durationSeconds = .28;
    final sampleCount = (sampleRate * durationSeconds).round();
    final pcmBytes = sampleCount * 2;
    final data = ByteData(44 + pcmBytes);

    void writeAscii(int offset, String value) {
      for (var index = 0; index < value.length; index++) {
        data.setUint8(offset + index, value.codeUnitAt(index));
      }
    }

    writeAscii(0, 'RIFF');
    data.setUint32(4, 36 + pcmBytes, Endian.little);
    writeAscii(8, 'WAVE');
    writeAscii(12, 'fmt ');
    data.setUint32(16, 16, Endian.little);
    data.setUint16(20, 1, Endian.little);
    data.setUint16(22, 1, Endian.little);
    data.setUint32(24, sampleRate, Endian.little);
    data.setUint32(28, sampleRate * 2, Endian.little);
    data.setUint16(32, 2, Endian.little);
    data.setUint16(34, 16, Endian.little);
    writeAscii(36, 'data');
    data.setUint32(40, pcmBytes, Endian.little);

    for (var index = 0; index < sampleCount; index++) {
      final time = index / sampleRate;
      final envelope = math.exp(-12 * time);
      final first = math.sin(2 * math.pi * 880 * time);
      final secondStart = math.max(0.0, time - .055);
      final second = time < .055
          ? 0.0
          : math.sin(2 * math.pi * 1320 * secondStart) *
              math.exp(-15 * secondStart);
      final shimmer = math.sin(2 * math.pi * 1760 * time) * .12;
      final mixed = ((first * .62) + (second * .58) + shimmer) * envelope;
      final sample = (mixed.clamp(-1.0, 1.0) * 32767).round();
      data.setInt16(44 + (index * 2), sample, Endian.little);
    }

    return data.buffer.asUint8List();
  }
}
