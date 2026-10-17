# NorieLearning soundtrack

Music by **The Cynic Project / cynicmusic.com / pixelsphere.org**, originally
written for Pixelsphere. These are third-party recordings, not generated Norie
originals. The artist's five OpenGameArt pages explicitly list **CC0 1.0**
(verified 2026-10-03). Credit is preserved here even though CC0 does not require
attribution. No endorsement by the artist is implied.

License: https://creativecommons.org/publicdomain/zero/1.0/
Legal text: https://creativecommons.org/publicdomain/zero/1.0/legalcode
Artist: https://opengameart.org/users/cynicmusic

| Bundled file | Original title | Source |
| --- | --- | --- |
| synthwave_4k.mp3 | Synthwave 4k | https://opengameart.org/content/calm-ambient-1-synthwave-4k |
| vaporware.mp3 | Vaporware | https://opengameart.org/content/calm-piano-1-vaporware |
| lifewave_2k.mp3 | Lifewave 2k | https://opengameart.org/content/calm-ambient-3-lifewave-2k |
| synthwave_15k.mp3 | Synthwave 15k | https://opengameart.org/content/calm-ambient-2-synthwave-15k |
| synthwave_421k.mp3 | Synthwave 421k | https://opengameart.org/content/calm-relax-1-synthwave-421k |

The MP3 recordings are unmodified; only filenames are simplified. Download URLs,
byte sizes, and SHA-256 hashes are recorded in `../music-manifest.json`.

Playback starts after a user gesture at a random position in this list, then
cycles through all five tracks before repeating, with 2.5-second crossfades.
Settings control Music and SFX independently. Quiet Music During Lessons reduces
reading volume; leaving the foreground pauses playback without restarting it.
No remote stream, account, subscription, or external audio service is required.

Flutter bundles this directory. Published web builds include it in the offline
cache; a first online cache download is required. The local AI development
preview deliberately disables service-worker installation.

`../MUSIC_GENERATION_SPEC.md` is a historical specification for a possible future
original soundtrack, not the provenance of these recordings.

## Building from source

Before running Flutter tests or packaging the app, run:

```sh
python scripts/fetch_music_assets.py
```

Run this from the repository root. The script downloads only the recordings
listed in [the manifest](../music-manifest.json), checks their exact byte sizes
and SHA-256 hashes, and verifies existing files before reusing them. MP3 files are
build inputs excluded from Git; CI fetches them for Android, Windows, and web.
Downloading happens during build preparation only. Packaged playback stays local.
