"""Normalize authorized source SFX from build/audio-originals into bundled MP3s.

Development-only dependencies: numpy, imageio-ffmpeg. No network requests.
"""
import hashlib
import json
from pathlib import Path
import subprocess

import imageio_ffmpeg
import numpy as np


def main():
    root = Path(__file__).resolve().parents[1]
    source = root / 'build/audio-originals'
    output = root / 'assets/audio/sfx'
    output.mkdir(parents=True, exist_ok=True)
    ffmpeg = imageio_ffmpeg.get_ffmpeg_exe()
    report = []
    for path in sorted(source.glob('*.mp3')):
        decoded = subprocess.check_output([
            ffmpeg, '-v', 'error', '-i', str(path), '-f', 'f32le',
            '-ac', '2', '-ar', '44100', 'pipe:1'])
        samples = np.frombuffer(decoded, dtype='<f4').reshape(-1, 2).copy()
        active = np.flatnonzero(np.max(np.abs(samples), axis=1) > .003)
        if not len(active):
            raise ValueError(f'Silent generated sound: {path}')
        # Keep attack and reverberation while avoiding audible start latency.
        samples = samples[max(0, active[0] - 220):min(len(samples), active[-1] + 1764)]
        rms = float(np.sqrt(np.mean(samples ** 2)))
        peak = float(np.max(np.abs(samples)))
        samples *= min(.10 / rms, .70 / peak)
        fade_in, fade_out = min(88, len(samples)), min(441, len(samples))
        samples[:fade_in] *= np.linspace(0, 1, fade_in)[:, None]
        samples[-fade_out:] *= np.linspace(1, 0, fade_out)[:, None]
        target = output / path.name
        subprocess.run([
            ffmpeg, '-y', '-v', 'error', '-f', 'f32le', '-ac', '2',
            '-ar', '44100', '-i', 'pipe:0', '-codec:a', 'libmp3lame',
            '-b:a', '128k', '-map_metadata', '-1', str(target)
        ], input=samples.astype('<f4').tobytes(), check=True)
        report.append(dict(file=path.name, seconds=round(len(samples)/44100, 3),
                           bytes=target.stat().st_size,
                           sha256=hashlib.sha256(target.read_bytes()).hexdigest()))
    (root / 'assets/audio/sfx-manifest.json').write_text(
        json.dumps(report, indent=2) + '\n', encoding='utf-8')
    print(json.dumps(report, indent=2))


if __name__ == '__main__':
    main()
