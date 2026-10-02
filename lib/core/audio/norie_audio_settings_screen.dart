import 'dart:async';
import 'package:flutter/material.dart';
import 'norie_audio_manager.dart';

class NorieAudioSettingsScreen extends StatefulWidget {
  const NorieAudioSettingsScreen({super.key, this.manager});
  final NorieAudioManager? manager;
  @override
  State<NorieAudioSettingsScreen> createState() =>
      _NorieAudioSettingsScreenState();
}

class _NorieAudioSettingsScreenState extends State<NorieAudioSettingsScreen> {
  late final NorieAudioManager _audio =
      widget.manager ?? NorieAudioManager.instance;
  @override
  void initState() {
    super.initState();
    unawaited(_audio.load());
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        appBar: AppBar(
            title: const Text('Settings'),
            leading: BackButton(onPressed: () {
              unawaited(_audio.playUiBack());
              Navigator.of(context).maybePop();
            })),
        body: SafeArea(
            child: Center(
                child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 620),
                    child: ListenableBuilder(
                      listenable: _audio,
                      builder: (context, _) => ListView(
                          padding: const EdgeInsets.all(16),
                          children: [
                            Text('Audio',
                                style:
                                    Theme.of(context).textTheme.headlineSmall),
                            const SizedBox(height: 8),
                            const Text(
                                'Sound supports the visuals. Your preferences are saved on this device.'),
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Background Music'),
                                subtitle: Text(_audio.musicStatus),
                                value: _audio.musicEnabled,
                                onChanged: (v) {
                                  unawaited(_audio.setMusicEnabled(v));
                                  unawaited(_audio.playUiTap());
                                }),
                            _volume(
                                'Music Volume',
                                _audio.musicVolume,
                                _audio.musicEnabled
                                    ? _audio.setMusicVolume
                                    : null),
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Sound Effects'),
                                value: _audio.sfxEnabled,
                                onChanged: (v) async {
                                  await _audio.setSfxEnabled(v);
                                  await _audio.playUiTap();
                                }),
                            _volume('SFX Volume', _audio.sfxVolume,
                                _audio.sfxEnabled ? _audio.setSfxVolume : null,
                                preview: true),
                            SwitchListTile(
                                contentPadding: EdgeInsets.zero,
                                title: const Text('Quiet Music During Lessons'),
                                subtitle: const Text(
                                    'Reduce music to half volume while reading.'),
                                value: _audio.quietLessons,
                                onChanged: (v) {
                                  unawaited(_audio.setQuietLessons(v));
                                  unawaited(_audio.playUiTap());
                                }),
                            const SizedBox(height: 16),
                            OutlinedButton.icon(
                                onPressed: _audio.sfxEnabled
                                    ? () async {
                                        await _audio.unlock();
                                        await _audio.playCorrect();
                                      }
                                    : null,
                                icon: const Icon(Icons.volume_up_rounded),
                                label: const Text('Test Sound')),
                          ]),
                    )))),
      );
  Widget _volume(
          String label, double value, Future<void> Function(double)? onChanged,
          {bool preview = false}) =>
      Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('$label: ${(value * 100).round()}%'),
        Slider(
            value: value,
            divisions: 100,
            label: '${(value * 100).round()}%',
            semanticFormatterCallback: (v) => '${(v * 100).round()} percent',
            onChanged:
                onChanged == null ? null : (v) => unawaited(onChanged(v)),
            onChangeEnd: preview && onChanged != null
                ? (_) => unawaited(_audio.playQuizSelect())
                : null),
      ]);
}
