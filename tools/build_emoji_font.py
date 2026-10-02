"""Rebuild the offline emoji subset: python -m pip install fonttools.

Uses Google's pinned OFL-1.1 outline font, fixes its weight at 400, retains
shaping for emoji sequences, and includes the Unicode symbols used by bundled
Flutter UI and approved lesson fixtures. Regenerate when adding emoji content.
"""
from pathlib import Path
import hashlib
import urllib.request

from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont

ROOT = Path(__file__).resolve().parents[1]
REVISION = "b979dba422e445492b0eb9951ac52ee0b4d648c3"
SOURCE = f"https://raw.githubusercontent.com/google/fonts/{REVISION}/ofl/notoemoji/NotoEmoji%5Bwght%5D.ttf"
SHA256 = "de6c18832938afc99caf132b39d6a30a19bac7f2e812e28db2535b4608d27551"


def main():
    cache = ROOT / "build/font-source/NotoEmoji-variable.ttf"
    cache.parent.mkdir(parents=True, exist_ok=True)
    if not cache.exists():
        urllib.request.urlretrieve(SOURCE, cache)
    if hashlib.sha256(cache.read_bytes()).hexdigest() != SHA256:
        raise RuntimeError("Pinned upstream font checksum does not match")
    font = instantiateVariableFont(TTFont(cache), {"wght": 400}, inplace=False)
    texts = [p.read_text(encoding="utf-8") for p in (ROOT / "lib").rglob("*.dart")]
    texts += [p.read_text(encoding="utf-8") for p in (ROOT / "test/fixtures/grade1_science").glob("*.txt")]
    codepoints = {ord(c) for text in texts for c in text if ord(c) >= 0x2000}
    codepoints.update([0x200D, 0xFE0E, 0xFE0F, 0x20E3, 0x23, 0x2A, *range(0x30, 0x3A)])
    options = subset.Options()
    options.hinting = False
    options.layout_features = ["*"]
    options.name_IDs = [0, 1, 2, 3, 4, 5, 6, 13, 14, 16, 17]
    options.name_legacy = True
    options.name_languages = ["*"]
    sub = subset.Subsetter(options=options)
    sub.populate(unicodes=codepoints)
    sub.subset(font)
    # Keep keycap shaping glyphs/GSUB closures, but do not let the emoji fallback
    # claim ordinary ASCII digits or punctuation when the main family differs
    # between platforms. Those characters belong to the primary text font.
    for table in font["cmap"].tables:
        if table.isUnicode():
            table.cmap = {cp: glyph for cp, glyph in table.cmap.items() if cp >= 0x80}
    cmap = font.getBestCmap()
    assert not any(cp < 0x80 for cp in cmap), "Emoji fallback must not claim ASCII"
    lesson_emoji = {ord(c) for p in (ROOT / "test/fixtures/grade1_science").glob("*.txt")
                    for c in p.read_text(encoding="utf-8") if ord(c) >= 0x1F300}
    assert lesson_emoji <= cmap.keys(), "Approved lesson emoji glyph is missing"
    names = {1: "Norie Emoji", 2: "Regular", 3: "NorieEmoji-Regular-subset",
             4: "Norie Emoji Regular", 6: "NorieEmoji-Regular", 16: "Norie Emoji", 17: "Regular"}
    for record in font["name"].names:
        if record.nameID in names:
            record.string = names[record.nameID].encode(record.getEncoding())
    target = ROOT / "assets/fonts/NorieEmoji.ttf"
    font.recalcTimestamp = False
    font.save(target)
    print(f"{target}: {target.stat().st_size} bytes")
    print("SHA256:", hashlib.sha256(target.read_bytes()).hexdigest())


if __name__ == "__main__":
    main()
