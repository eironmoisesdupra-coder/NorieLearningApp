# NorieLearning audio provenance

The twelve sound effects in sfx/ were generated specifically for NorieLearning using Runway sound-effect generation on 2026-10-02 from original text prompts, without reference songs, sampled copyrighted audio, or requests to imitate an existing composition. generation-provenance.json records each prompt and task ID. sfx-manifest.json records the distributed file hashes, sizes, and durations.

Source outputs were trimmed to remove unnecessary leading silence, normalized with headroom, given short boundary fades, and encoded as 44.1 kHz stereo MP3 at 128 kbps using scripts/prepare_audio_sfx.py. Mixing gains are separately controlled by the application's shared audio manager.

Usage status: Runway's published [commercial-use guidance](https://help.runwayml.com/hc/en-us/articles/21668707517587-Can-I-use-the-content-I-made-in-Runway-for-commercial-purposes) and [usage rights](https://help.runwayml.com/hc/en-us/articles/18927776141715-Usage-rights), checked on 2026-10-02, permit commercial use of generated content subject to their terms. This records provider permission and provenance; it does not assert exclusive copyright in generated outputs. No external song or sound library is included.

## Music status

No finished production music is included. The connected generator rejected the music request with paid_plan_required. MUSIC_GENERATION_SPEC.md documents the five intended original tracks and validation steps. The expected filenames are not evidence that those files exist; the production playlist remains empty until genuine tracks are generated, inspected, bundled, and registered.
