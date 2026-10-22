# Source preservation

The supplied files are preserved byte for byte. The two archived Dart filenames
end in `.dart.txt` so Flutter's repository-wide analyzer does not compile historical
prototype tests against the evolving production implementation. The original ZIP
is unchanged. Active source and tests live under the repository's `lib/` and `test/`.

This archive's original ROADMAP_STATUS.json describes the supplied WIP, not current
integration or deployment. Current work is tracked in
`docs/superpowers/plans/2026-10-22-discovery-adventure.md`.
