# NorieLearning audio provenance

## Current adventure soundtrack and space-interface effects

Five original instrumental compositions and twelve original synthesized effects
are rendered by `scripts/generate_adventure_audio.py`. The script contains the
scores and sound-design recipes, using oscillators and seeded synthetic noise
only. No third-party recordings, voices, external generators, or samples are
used. This synthetic audio is dedicated under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/);
[legal text](https://creativecommons.org/publicdomain/zero/1.0/legalcode).
This provenance does not assert exclusive copyright in generated output.

The current `music-manifest.json` and `sfx-manifest.json` record the exact MP3
hashes, sizes, durations, and generator. Music is stereo 44.1 kHz at 160 kbps;
effects are stereo 44.1 kHz at 128 kbps. Both have normalized headroom and
boundary fades. Frequent button cues are short paired tones with softened
attacks; confirmation cues rise, Back descends, and an incorrect answer uses a
gentle descending cue rather than an alarm. Mixing gains, mute preferences,
lesson quieting and reward ducking remain controlled by the shared manager.

## Historical Runway effects (retained provenance)

The previous twelve effects were generated specifically for NorieLearning using
Runway sound-effect generation on 2026-10-02 from original text prompts, without
reference songs or sampled audio. `generation-provenance.json` retains those
original prompts and task IDs. It describes the previous recordings, not the
current synthesized replacements. `scripts/prepare_audio_sfx.py` remains the
historical trim/normalization tool.

Usage status: Runway's published [commercial-use guidance](https://help.runwayml.com/hc/en-us/articles/21668707517587-Can-I-use-the-content-I-made-in-Runway-for-commercial-purposes) and [usage rights](https://help.runwayml.com/hc/en-us/articles/18927776141715-Usage-rights), checked on 2026-10-02, permit commercial use of generated content subject to their terms. This records provider permission and provenance; it does not assert exclusive copyright in generated outputs. No external song or sound library is included.

## Music status

The original adventure tracks are bundled and active. See
[music credits](music/README.md) for the current track list and retained
attribution/license links for the previous Cynic Project soundtrack.
`MUSIC_GENERATION_SPEC.md` is a historical proposal, not current provenance.
