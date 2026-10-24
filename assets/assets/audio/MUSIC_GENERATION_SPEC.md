# NorieLearning original soundtrack generation specification

Status: awaiting a music-generation-capable account. Runway music generation was attempted on 2026-10-02 and returned paid_plan_required. No music task was created, no subscription was purchased, and no production music binary is claimed.

## Shared direction

Create five coherent original instrumental tracks for a cozy futuristic educational game. Use warm soft synths, understated electronic percussion, relaxed chords, and a light cosmic atmosphere. No vocals, aggressive bass, distracting lead melodies, or imitation of an existing composition. Target 60 to 120 seconds per track; 44.1 or 48 kHz stereo; compact MP3 at 96 to 128 kbps, verified in Android audioplayers, Flutter Web, and the Windows package.

## Track prompts

1. **Norie Orbit** (`music/norie_orbit.mp3`, about 90 seconds): Original seamless looping futuristic lo-fi educational game main-menu instrumental. Warm analog synth pads, soft electronic drums, gentle sparkling arpeggio, subtle cosmic atmosphere, optimistic curiosity. Relaxing, no vocals, no dramatic ending, no silence at the loop boundary.
2. **Starlight Study** (`music/starlight_study.mp3`, about 90 seconds): Original calm seamless lo-fi study instrumental. Warm soft keys, gentle synth pad, very light percussion, peaceful space ambience, focused and non-distracting. No vocals; loopable ending matching the opening harmony and beat.
3. **Pixel Discovery** (`music/pixel_discovery.mp3`, 75 to 100 seconds): Original playful educational game instrumental. Soft electronic groove, light plucky synth, warm chords, curious discovery feeling, futuristic but friendly. Understated melody, no vocals, seamless loop.
4. **Cosmic Focus** (`music/cosmic_focus.mp3`, 90 to 120 seconds): Original ambient focus soundtrack for studying. Slow evolving synth pads, faint rhythmic pulse, airy cosmic texture, minimal melody and percussion. Calm concentration, no vocals, seamless loop.
5. **Night Classroom** (`music/night_classroom.mp3`, about 90 seconds): Original dreamy night-study instrumental. Gentle electric piano and soft synth atmosphere, understated beat, warm educational-game mood, peaceful and slightly futuristic. No vocals, seamless loop with no fade-out or final chord.

## Acceptance and integration

Record the provider, generation date, task identifier, prompt, source hash, edits, and applicable usage terms in ATTRIBUTION.md or a linked manifest. Listen to every track, inspect the beginning/end and at least three repeated boundaries, remove accidental silence, and avoid clicks, audible padding, or terminal cadences. MP3 encoder padding must be assessed on actual players; use loop-compatible edits or a validated alternative codec if needed.

Normalize perceived loudness consistently (initial target around -20 LUFS, true peak at or below -3 dBTP), leaving headroom for feedback sounds. Listen at the app's default 30% music and 70% SFX settings. Keep track transitions around 2.5 seconds, never immediately repeat a track, and do not change the user's configured volume when context ducking changes.

Register the real files in the shared asset catalog and available playlist; pubspec and the offline web cache must include every file. Verify rotation, crossfades, mute, volume changes during a transition, user-gesture unlock, background/resume, lesson/quiz attenuation, reward ducking, and no extra players after navigation. Do not decode all five tracks at once.

Completion requires actual Android and Web playback plus analysis, tests, and relevant builds. Until the binaries pass these checks, expose unavailable-music status honestly and retain working SFX without runtime remote requests.
