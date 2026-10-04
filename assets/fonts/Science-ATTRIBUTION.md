# Offline Science text and symbols

Original fonts by the Noto Project Authors, licensed under SIL Open Font License 1.1.
Official text project: https://github.com/notofonts/latin-greek-cyrillic
Official math project: https://github.com/notofonts/math

Official Google Fonts distribution pinned to revision `8b0a1d0f5983c89bc2b93f1b5fb55f9e252744b5`.

Derived, renamed subsets: Norie Science Text (Noto Sans, width 100, weight 400)
and Norie Science Symbols (Noto Sans Math, regular weight 400).
The text subset includes ordinary letters/numerals, Greek, accented text and punctuation.
The symbols subset supplies missing arrows, inequalities and mathematical operators;
its cmap contains no ASCII letters, punctuation or digits. Neither subset claims emoji pictographs.
Font sizes and the Norie theme remain unchanged. The app loads these local assets without network access.

## NorieScienceText

Source: https://raw.githubusercontent.com/google/fonts/8b0a1d0f5983c89bc2b93f1b5fb55f9e252744b5/ofl/notosans/NotoSans%5Bwdth,wght%5D.ttf
Upstream SHA-256: `bfb7bb691513f12e734dc346c03a03f784912432d7e3fa8e56efcf906fe86b3d`
License: [notosans-Science-OFL.txt](notosans-Science-OFL.txt)
Bundled subset: 203,508 bytes; SHA-256 `38c41ed6451a5e79c6521f10873b29d68bf98f98bcb81903cb64497960b2026e`.

## NorieScienceSymbols

Source: https://raw.githubusercontent.com/google/fonts/8b0a1d0f5983c89bc2b93f1b5fb55f9e252744b5/ofl/notosansmath/NotoSansMath-Regular.ttf
Upstream SHA-256: `3f495fe933c06786e4d5f6d86b8ee70b6753a68ee3b9d87528726de0f6e2c47d`
License: [notosansmath-Science-OFL.txt](notosansmath-Science-OFL.txt)
Bundled subset: 353,900 bytes; SHA-256 `01a87e790b6d40da2f7c90a50c3cbcede3b3c34819730c837e9214a472524044`.

Rebuild: install `fonttools==4.60.1`, then run `python tools/build_science_text_font.py`.
The script verifies pinned font/license checksums and derives paths from the repository location.
Run `python tools/build_science_text_font.py --check` for glyph, ordinary-numeral and license validation without downloads.
Subsets cover current Dart text plus planned Latin/Greek, superscript/subscript, arrow and math ranges;
regenerate and review coverage when adding another script or unusual notation.
