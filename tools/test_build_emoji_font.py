"""Offline regression checks: python -m unittest discover -s tools.

Install fonttools first. The full subset check needs the pinned font cached by
tools/build_emoji_font.py; it skips explicitly when that source is unavailable.
"""
import contextlib
import io
from pathlib import Path
import shutil
import tempfile
import unittest
from unittest.mock import patch

from fontTools.ttLib import TTFont

import build_emoji_font


class EmojiSubsetTest(unittest.TestCase):
    def test_invalid_unicode_escapes_are_not_font_codepoints(self):
        text = r"\u{110000}\uD800 x\uDC00\u{DFFF}\u0000"
        self.assertEqual(build_emoji_font.unicode_codepoints(text), set())

    def test_dart_escaped_emoji_survive_the_offline_subset(self):
        cache = build_emoji_font.ROOT / "build/font-source/NotoEmoji-variable.ttf"
        if not cache.exists():
            self.skipTest("Pinned font source absent; run tools/build_emoji_font.py to cache it")
        with tempfile.TemporaryDirectory() as directory:
            root = Path(directory)
            for relative in ("lib", "test/fixtures/grade1_science",
                             "build/font-source", "assets/fonts"):
                (root / relative).mkdir(parents=True)
            shutil.copyfile(
                cache,
                root / "build/font-source/NotoEmoji-variable.ttf",
            )
            # Exercise the source-to-font pipeline, including the result text
            # that failed offline, BMP escapes, and UTF-16 surrogate pairs.
            (root / "lib/result.dart").write_text(
                "const literal = '\U0001f331';\n"
                r"const result = 'All right! \u{1F31F}';" "\n"
                r"const bmp = '\u2B50';" "\n"
                r"const pair = '\uD83C\uDF89';" "\n"
                r"const invalid = '\u{110000}\uD800\uDC00\uDC00';",
                encoding="utf-8",
            )
            (root / "test/fixtures/grade1_science/lesson.txt").write_text(
                "\U0001f33b", encoding="utf-8"
            )
            with patch.object(build_emoji_font, "ROOT", root):
                with contextlib.redirect_stdout(io.StringIO()):
                    build_emoji_font.main()
            with TTFont(root / "assets/fonts/NorieEmoji.ttf") as font:
                cmap = font.getBestCmap()
                for codepoint in (0x1F331, 0x1F31F, 0x2B50, 0x1F389, 0x1F33B):
                    with self.subTest(codepoint=hex(codepoint)):
                        self.assertIn(codepoint, cmap)
                self.assertFalse(any(cp < 0x80 for cp in cmap))
                self.assertIn("GSUB", font)
                self.assertTrue(any(record.nameID == 13 for record in font["name"].names))


if __name__ == "__main__":
    unittest.main()
