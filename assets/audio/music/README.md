# NorieLearning soundtrack

The active soundtrack is five **original, instrumental synth-adventure**
compositions: bright major-key harmonies, melodic plucks, warm pads, rhythmic bass,
and soft electronic drums. No vocals, sampled recordings, reference songs, or
artist imitation are used. The original synthetic audio is dedicated under
[CC0 1.0](https://creativecommons.org/publicdomain/zero/1.0/).

| File | Title | Tempo |
| --- | --- | --- |
| norie_starbound.mp3 | Starbound Adventure | 124 BPM |
| norie_bright_horizons.mp3 | Bright Horizons | 120 BPM |
| norie_discovery_run.mp3 | Discovery Run | 130 BPM |
| norie_cosmic_trail.mp3 | Cosmic Trail | 116 BPM |
| norie_next_frontier.mp3 | Next Frontier | 128 BPM |

Each track has a 48-bar arrangement with an introduction, melodic sections,
breakdown, return, and outro (about 90-101 seconds). The checked-in MP3s are the
production build inputs; exact hashes, sizes, tempos and composition seeds are
recorded in [the manifest](../music-manifest.json).

Playback starts after a user gesture at a random position in this list, then
cycles through all five tracks with 2.5-second crossfades. Music/SFX settings,
quiet lesson volume, and foreground pause/resume behavior are unchanged. Playback
requires no account, remote stream, or subscription. Flutter and published web
offline caches bundle all active tracks.

## Building and rendering

`python scripts/fetch_music_assets.py` now verifies the bundled originals without
network requests. Missing or modified bytes fail the build; the verifier never
silently substitutes another recording.

To re-render the compositions and all twelve space-interface effects, use
`python scripts/generate_adventure_audio.py` with NumPy and imageio-ffmpeg installed.
Review the output, then commit the MP3s and regenerated manifests together.
Different encoder versions can change MP3 hashes; ordinary builds verify existing
files and do not render them. The generator is deterministic at the PCM/score
level and contains all melodies, orchestration, tempos, seeds, and effect recipes.

## Retained credits for the previous soundtrack

Music by **The Cynic Project / cynicmusic.com / pixelsphere.org**, originally
written for Pixelsphere. These were third-party recordings, not generated Norie
originals. The artist's five OpenGameArt pages explicitly list **CC0 1.0**
(verified 2026-10-03). Credit is preserved here even though CC0 does not require
attribution. No endorsement by the artist is implied.

License: https://creativecommons.org/publicdomain/zero/1.0/
Legal text: https://creativecommons.org/publicdomain/zero/1.0/legalcode
Artist: https://opengameart.org/users/cynicmusic

| Previous file | Original title | Source |
| --- | --- | --- |
| synthwave_4k.mp3 | Synthwave 4k | https://opengameart.org/content/calm-ambient-1-synthwave-4k |
| vaporware.mp3 | Vaporware | https://opengameart.org/content/calm-piano-1-vaporware |
| lifewave_2k.mp3 | Lifewave 2k | https://opengameart.org/content/calm-ambient-3-lifewave-2k |
| synthwave_15k.mp3 | Synthwave 15k | https://opengameart.org/content/calm-ambient-2-synthwave-15k |
| synthwave_421k.mp3 | Synthwave 421k | https://opengameart.org/content/calm-relax-1-synthwave-421k |

Those recordings are no longer in the active playlist. Their attribution and
license links remain here for older builds; no endorsement is implied.

`../MUSIC_GENERATION_SPEC.md` is a historical specification for a possible future
original soundtrack, not the provenance of these recordings.
