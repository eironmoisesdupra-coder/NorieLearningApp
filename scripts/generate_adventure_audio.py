"""Render original Norie instrumental compositions and space-interface effects.

Development only: numpy and imageio-ffmpeg. No samples, vocals, network calls,
reference recordings, or external generation service are used.
"""
import hashlib
import json
from pathlib import Path
import subprocess

import imageio_ffmpeg
import numpy as np


ROOT = Path(__file__).resolve().parents[1]
RATE = 44100
GENERATOR = 'scripts/generate_adventure_audio.py'
TRACKS = (
    ('norie_starbound', 'Starbound Adventure', 124, 62, 11),
    ('norie_bright_horizons', 'Bright Horizons', 120, 69, 23),
    ('norie_discovery_run', 'Discovery Run', 130, 67, 37),
    ('norie_cosmic_trail', 'Cosmic Trail', 116, 60, 41),
    ('norie_next_frontier', 'Next Frontier', 128, 64, 59),
)
SCALE = (0, 2, 4, 5, 7, 9, 11, 12, 14, 16)
MELODIES = (
    ((4, 1), (6, .5), (7, .5), (8, 1), (6, 1)),
    ((5, .5), (4, .5), (2, 1), (4, 1), (1, 1)),
    ((2, 1), (4, .5), (5, .5), (6, 1.5), (4, .5)),
    ((1, .5), (2, .5), (4, 1), (2, 1), (0, 1)),
    ((7, .75), (6, .25), (4, 1), (6, .5), (8, .5), (7, 1)),
    ((5, 1), (4, .5), (2, .5), (1, 1), (2, 1)),
    ((2, .5), (4, .5), (6, 1), (7, 1), (6, .5), (4, .5)),
    ((2, 1), (1, 1), (0, 2)),
)


def frequency(note):
    return 440 * 2 ** ((note - 69) / 12)


def tone(note, seconds, voice='pluck'):
    t = np.arange(round(seconds * RATE), dtype=np.float64) / RATE
    phase = 2 * np.pi * frequency(note) * t
    if voice == 'pad':
        wave = (np.sin(phase) + .28 * np.sin(phase * 1.003)
                + .16 * np.sin(phase * 2) + .07 * np.sin(phase * 3))
        envelope = np.minimum(t / .12, 1) * np.minimum((seconds - t) / .2, 1)
    elif voice == 'bass':
        wave = np.sin(phase) + .3 * np.sin(phase * 2) + .1 * np.sin(phase * 3)
        envelope = (1 - np.exp(-t / .004)) * np.exp(-t / .22)
    elif voice == 'lead':
        wave = (np.sin(phase + .3 * np.sin(phase * 2) * np.exp(-t * 5))
                + .22 * np.sin(phase * 2) + .09 * np.sin(phase * 3))
        envelope = (1 - np.exp(-t / .009)) * np.exp(-t / .48)
    else:
        wave = np.sin(phase + 1.3 * np.sin(phase * 2) * np.exp(-t * 12))
        envelope = (1 - np.exp(-t / .003)) * np.exp(-t / .13)
    envelope *= np.minimum(np.maximum(seconds - t, 0) / .025, 1)
    return (wave * envelope).astype(np.float32)


def add(bus, sound, start, gain, pan=0):
    offset = round(start * RATE)
    length = min(len(sound), len(bus) - offset)
    if offset < 0 or length <= 0:
        raise ValueError('Audio event outside composition')
    angle = (pan + 1) * np.pi / 4
    bus[offset:offset + length, 0] += sound[:length] * gain * np.cos(angle)
    bus[offset:offset + length, 1] += sound[:length] * gain * np.sin(angle)


def percussion(kind, rng):
    seconds = {'kick': .36, 'snare': .19, 'hat': .07, 'open': .24}[kind]
    t = np.arange(round(seconds * RATE)) / RATE
    noise = rng.normal(0, .35, len(t))
    high = noise - np.roll(noise, 1)
    if kind == 'kick':
        phase = 2 * np.pi * (47 * t + 6 * (1 - np.exp(-t * 36)))
        wave = np.sin(phase) * np.exp(-t * 15) + high * np.exp(-t * 150) * .12
    elif kind == 'snare':
        wave = (high * .52 + .22 * np.sin(2 * np.pi * 185 * t)) * np.exp(-t * 24)
    else:
        wave = high * np.exp(-t * (65 if kind == 'hat' else 20))
    wave *= np.minimum(t / .001, 1) * np.minimum((seconds - t) / .01, 1)
    return wave.astype(np.float32)


def ambience(bus, beat):
    dry = bus.copy()
    for delay, gain in ((beat * .75, .16), (beat * 1.5, .08), (.047, .07), (.083, .05)):
        shift = round(delay * RATE)
        bus[shift:, 0] += dry[:-shift, 1] * gain
        bus[shift:, 1] += dry[:-shift, 0] * gain
    return bus


def master(samples, rms_target, peak_limit, fade_in, fade_out):
    samples -= samples.mean(axis=0)
    rms = float(np.sqrt(np.mean(samples ** 2)))
    peak = float(np.max(np.abs(samples)))
    if not np.isfinite(samples).all() or rms < .0001:
        raise ValueError('Invalid or silent audio')
    samples *= min(rms_target / rms, peak_limit / peak)
    first = min(round(fade_in * RATE), len(samples))
    last = min(round(fade_out * RATE), len(samples))
    samples[:first] *= np.linspace(0, 1, first)[:, None]
    samples[-last:] *= np.linspace(1, 0, last)[:, None]
    return samples


def music(bpm, key, seed):
    rng = np.random.default_rng(seed)
    beat = 60 / bpm
    bars = 48
    bus = np.zeros((round((bars * 4 * beat + 1.5) * RATE), 2), dtype=np.float32)
    drums = {kind: percussion(kind, rng) for kind in ('kick', 'snare', 'hat', 'open')}
    # Major add9/major7 voicings: hopeful tonic, dominant, relative minor, subdominant.
    chords = ((0, 4, 7, 14), (7, 11, 14, 21), (9, 12, 16, 19), (5, 9, 12, 19))
    for bar in range(bars):
        start = bar * 4 * beat
        chord = chords[(bar // 2 + seed % 4) % 4]
        breakdown = 20 <= bar < 24
        full = 4 <= bar < 40 and not breakdown
        energy = .75 if bar < 4 or bar >= 40 else 1
        for i, interval in enumerate(chord):
            add(bus, tone(key + interval, 4 * beat + .2, 'pad'),
                start, .045 * energy, (i - 1.5) / 2)
        for step in range(8):
            time = start + step * beat / 2
            interval = chord[(step + bar % 2 + seed % 3) % 4]
            add(bus, tone(key + 12 + interval, beat * .7), time,
                .065 * energy, -.45 if step % 2 else .45)
            if not breakdown:
                add(bus, tone(key - 12 + chord[0], beat * .7, 'bass'),
                    time, .2 if step % 2 == 0 else .13)
        if not breakdown:
            for pulse in range(4):
                time = start + pulse * beat
                add(bus, drums['kick'], time, .38 * energy)
                if pulse % 2 and bar >= 2:
                    add(bus, drums['snare'], time, .19 * energy, .06)
                if full:
                    add(bus, drums['open'], time + beat / 2, .05, -.25)
            for step in range(8):
                add(bus, drums['hat'], start + step * beat / 2,
                    .055 if step % 2 else .035, .3)
        if full or 40 <= bar < 44:
            cursor = 0
            phrase = MELODIES[(bar + seed) % 8]
            for degree, beats in phrase:
                note = key + 12 + SCALE[degree]
                add(bus, tone(note, beats * beat * .9, 'lead'),
                    start + cursor * beat, .14 if bar < 32 else .12, .08)
                cursor += beats
        if full and bar % 4 == 3:
            for step in range(4):
                add(bus, drums['snare'], start + (3 + step / 4) * beat,
                    .045 + step * .012, -.1 + step * .06)
    return master(ambience(bus, beat), .14, .78, .025, 2.7)


SFX = {
    'ui_tap': ((83, 0, .065), (95, .022, .07)),
    'ui_select': ((81, 0, .09), (88, .055, .1)),
    'ui_open': ((76, 0, .12), (83, .06, .12), (88, .12, .15)),
    'ui_back': ((88, 0, .09), (81, .055, .12)),
    'quiz_select': ((86, 0, .07), (93, .045, .1)),
    'correct': ((76, 0, .16), (80, .1, .16), (83, .2, .22), (88, .32, .25)),
    'wrong': ((69, 0, .13), (67, .1, .2)),
    'challenge_start': ((62, 0, .2), (69, .14, .2), (74, .28, .2), (78, .42, .3)),
    'complete': ((74, 0, .18), (78, .12, .18), (81, .24, .24), (86, .4, .32)),
    'achievement': ((74, 0, .2), (81, .14, .2), (86, .28, .28), (90, .44, .36)),
    'level_up': ((76, 0, .17), (80, .11, .17), (83, .22, .2), (88, .36, .34)),
    'perfect': ((74, 0, .2), (78, .12, .2), (81, .24, .22),
                (86, .38, .28), (90, .54, .4), (93, .72, .4)),
}


def effect(name, notes):
    seconds = max(start + length for _, start, length in notes) + .1
    bus = np.zeros((round(seconds * RATE), 2), dtype=np.float32)
    for i, (note, start, length) in enumerate(notes):
        add(bus, tone(note, length), start, .55, (i % 3 - 1) * .16)
        if name not in ('ui_tap', 'quiz_select'):
            add(bus, tone(note - 12, length, 'lead'), start, .12)
    return master(ambience(bus, .045), .13, .65, .002, .025)


def encode(samples, path, bitrate):
    path.parent.mkdir(parents=True, exist_ok=True)
    subprocess.run([
        imageio_ffmpeg.get_ffmpeg_exe(), '-y', '-v', 'error',
        '-f', 'f32le', '-ar', str(RATE), '-ac', '2', '-i', 'pipe:0',
        '-codec:a', 'libmp3lame', '-b:a', bitrate, '-map_metadata', '-1', str(path),
    ], input=samples.astype('<f4').tobytes(), check=True)
    return {
        'file': path.name,
        'seconds': round(len(samples) / RATE, 3),
        'bytes': path.stat().st_size,
        'sha256': hashlib.sha256(path.read_bytes()).hexdigest(),
        'generator': GENERATOR,
    }


def main():
    tracks = []
    for name, title, bpm, key, seed in TRACKS:
        entry = encode(music(bpm, key, seed), ROOT / 'assets/audio/music' / f'{name}.mp3', '160k')
        entry.update(title=title, bpm=bpm, keyMidi=key, bars=48, seed=seed)
        tracks.append(entry)
        print(f'Rendered {title}: {entry["seconds"]}s', flush=True)
    (ROOT / 'assets/audio/music-manifest.json').write_text(json.dumps({
        'origin': 'original-synthesis',
        'artist': 'NorieLearning original procedural compositions',
        'license': 'CC0-1.0',
        'licenseUrl': 'https://creativecommons.org/publicdomain/zero/1.0/',
        'description': 'Original major-key instrumental synth adventure; no samples or vocals.',
        'tracks': tracks,
    }, indent=2) + '\n', encoding='utf-8')
    effects = []
    for name, notes in SFX.items():
        entry = encode(effect(name, notes), ROOT / 'assets/audio/sfx' / f'{name}.mp3', '128k')
        entry['recipe'] = name
        effects.append(entry)
    (ROOT / 'assets/audio/sfx-manifest.json').write_text(
        json.dumps(effects, indent=2) + '\n', encoding='utf-8')


if __name__ == '__main__':
    main()
