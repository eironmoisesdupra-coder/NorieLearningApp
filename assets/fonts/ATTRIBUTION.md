# Noto Emoji

Noto Emoji by the Noto Project Authors is bundled as an offline emoji fallback.
The font is distributed under the SIL Open Font License, version 1.1; see
[NotoEmoji-OFL.txt](NotoEmoji-OFL.txt) for the complete license and copyright.

Official project: https://github.com/googlefonts/noto-emoji

Official Google Fonts distribution, pinned revision:
https://github.com/google/fonts/tree/b979dba422e445492b0eb9951ac52ee0b4d648c3/ofl/notoemoji

Downloaded file:
https://raw.githubusercontent.com/google/fonts/b979dba422e445492b0eb9951ac52ee0b4d648c3/ofl/notoemoji/NotoEmoji%5Bwght%5D.ttf

The upstream variable TrueType font is instantiated at weight 400 and subset
to the Unicode symbols used by the Flutter UI and approved lesson fixtures.
The generator includes literal symbols, Dart braced and four-digit Unicode
escapes, and valid escaped UTF-16 surrogate pairs; invalid scalar values are skipped.
The derived font has been renamed **Norie Emoji** (`NorieEmoji.ttf`). Its
monochrome outline glyphs use the app text color and require no network or
operating-system emoji font. Copyright and OFL notices remain in the font.

Upstream SHA-256:
`de6c18832938afc99caf132b39d6a30a19bac7f2e812e28db2535b4608d27551`

Ordinary ASCII cmap mappings are removed from the fallback; digit and keycap
shaping glyphs remain available to the font's shaping tables. This keeps normal
numbers and punctuation in the app's primary text font.

Bundled subset: 107,588 bytes. SHA-256:
`c03848cb6dd6a41d3666f2df90287eacaa45c0beeee91bef11baebac113ce8db`.
Rebuild using `tools/build_emoji_font.py` with
Python and `fonttools`; the script downloads and verifies the pinned source.
Regenerate the subset when adding emoji content.
