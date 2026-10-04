"""Build licensed offline text/science font subsets from pinned official fonts.

Setup: python -m pip install fonttools==4.60.1
Run: python tools/build_science_text_font.py
Verify bundled artifacts only: python tools/build_science_text_font.py --check

Sources are downloaded only during a rebuild, never by the application. Font,
license and fonttools versions are pinned; repository paths derive from this
script. Ordinary ASCII belongs to the text font, never to the symbols fallback.
"""
from __future__ import annotations

import argparse
import hashlib
from pathlib import Path
import urllib.request

import fontTools
from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib.instancer import instantiateVariableFont

ROOT = Path(__file__).resolve().parents[1]
REVISION = "8b0a1d0f5983c89bc2b93f1b5fb55f9e252744b5"
FONTTOOLS_VERSION = "4.60.1"
SOURCES = (
    ("notosans", "NotoSans%5Bwdth,wght%5D.ttf",
     "bfb7bb691513f12e734dc346c03a03f784912432d7e3fa8e56efcf906fe86b3d",
     "cee9892f9f0cc8fe882c9e9537ee6a89621d86ee7ceaf70b02e2b2b1c25c061a",
     "NorieScienceText", "Norie Science Text"),
    ("notosansmath", "NotoSansMath-Regular.ttf",
     "3f495fe933c06786e4d5f6d86b8ee70b6753a68ee3b9d87528726de0f6e2c47d",
     "403a95275b469061b7d4371c328e0ada3bc7d63328abe2e88aad5cd243b2fe21",
     "NorieScienceSymbols", "Norie Science Symbols"),
)
REQUIRED = set(range(0x20, 0x7F)) | {
    0x2192, 0x2190, 0x2194, 0x0394, 0x03BB, 0x03BC, 0x03A9,
    0x00B1, 0x00D7, 0x00F7, 0x2264, 0x2265, 0x00B0, 0x00B2, 0x00B3,
    0x1D62,  # Latin subscript i in indexed ecological proportions.
}


def sha256(path: Path) -> str:
    return hashlib.sha256(path.read_bytes()).hexdigest()


def source(folder: str, filename: str) -> str:
    return f"https://raw.githubusercontent.com/google/fonts/{REVISION}/ofl/{folder}/{filename}"


def verified_download(url: str, destination: Path, checksum: str) -> Path:
    if not destination.exists():
        with urllib.request.urlopen(url, timeout=60) as response:
            content = response.read()
        if hashlib.sha256(content).hexdigest() != checksum:
            raise RuntimeError(f"Pinned download checksum does not match: {url}")
        destination.parent.mkdir(parents=True, exist_ok=True)
        destination.write_bytes(content)
    if sha256(destination) != checksum:
        raise RuntimeError(f"Pinned cache checksum does not match: {destination}")
    return destination


def desired_codepoints() -> set[int]:
    # Include common Latin, accented text, Greek, superscripts/subscripts,
    # punctuation, mathematical operators and directional scientific arrows.
    # Emoji pictographs, emoji variation selectors and joiners are excluded.
    ranges = ((0x20, 0x7F), (0xA0, 0x300), (0x370, 0x400),
              (0x1E00, 0x2000), (0x2000, 0x2060), (0x2070, 0x2100),
              (0x2100, 0x2400), (0x27C0, 0x2800), (0x2900, 0x2B00))
    desired = {cp for start, end in ranges for cp in range(start, end)}
    # Cyrillic or other non-emoji text already present in the app is retained
    # when supported by the upstream text font. No decorative emoji block.
    for path in sorted((ROOT / "lib").rglob("*.dart")):
        desired.update(ord(char) for char in path.read_text(encoding="utf-8")
                       if ord(char) < 0x2000)
    desired.difference_update({0x200C, 0x200D, 0xFE0E, 0xFE0F})
    return desired | REQUIRED


def rename(font: TTFont, family: str, postscript: str) -> None:
    names = {1: family, 2: "Regular", 3: f"{postscript}-Regular-subset",
             4: f"{family} Regular", 6: f"{postscript}-Regular",
             16: family, 17: "Regular"}
    # Preserve all copyright, licensing and source attribution records.
    for record in font["name"].names:
        if record.nameID in names:
            record.string = names[record.nameID].encode(record.getEncoding())


def verify_artifacts() -> None:
    text = TTFont(ROOT / "assets/fonts/NorieScienceText.ttf")
    symbols = TTFont(ROOT / "assets/fonts/NorieScienceSymbols.ttf")
    text_cmap = text.getBestCmap()
    symbol_cmap = symbols.getBestCmap()
    missing = REQUIRED - (text_cmap.keys() | symbol_cmap.keys())
    if missing:
        raise RuntimeError("Missing scientific/text glyphs: " +
                           ", ".join(f"U+{cp:04X}" for cp in sorted(missing)))
    if set(range(0x20, 0x7F)) - text_cmap.keys():
        raise RuntimeError("Text font must cover printable ASCII")
    if any(cp < 0x80 for cp in symbol_cmap):
        raise RuntimeError("Symbols font must not claim ordinary ASCII or digits")
    for cmap in (text_cmap, symbol_cmap):
        if any(cp >= 0x1F000 or cp in (0xFE0E, 0xFE0F, 0x200D) for cp in cmap):
            raise RuntimeError("Science fonts must not claim emoji pictographs/sequences")
    if text["OS/2"].usWeightClass != 400 or symbols["OS/2"].usWeightClass != 400:
        raise RuntimeError("Both subsets must be regular weight 400")
    for folder, _, _, license_sha, _, _ in SOURCES:
        path = ROOT / "assets/fonts" / f"{folder}-Science-OFL.txt"
        if sha256(path) != license_sha:
            raise RuntimeError(f"Bundled license checksum mismatch: {path}")
    print(f"Coverage PASS: {len(REQUIRED)} required printable ASCII/science codepoints")
    print("Science symbols:", " ".join(f"U+{cp:04X}" for cp in sorted(REQUIRED) if cp >= 0x80))
    print("Ordinary digits: text font only; symbols subset contains no ASCII")
    print("Emoji pictographs/sequences: absent from both science font cmaps")
    for identifier in ("NorieScienceText", "NorieScienceSymbols"):
        path = ROOT / "assets/fonts" / f"{identifier}.ttf"
        print(f"{path.name}: {path.stat().st_size} bytes; SHA256 {sha256(path)}")


def main() -> None:
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument("--check", action="store_true", help="Verify bundled font coverage and licenses without downloading")
    args = parser.parse_args()
    if args.check:
        verify_artifacts()
        return
    if fontTools.__version__ != FONTTOOLS_VERSION:
        raise RuntimeError(f"Reproducible rebuild requires fonttools=={FONTTOOLS_VERSION}")
    cache = ROOT / "build/font-source"
    output = ROOT / "assets/fonts"
    output.mkdir(parents=True, exist_ok=True)
    desired = desired_codepoints()
    covered: set[int] = set()
    artifacts = []
    for folder, filename, font_sha, license_sha, identifier, family in SOURCES:
        upstream = verified_download(source(folder, filename), cache / f"{folder}.ttf", font_sha)
        license_path = verified_download(source(folder, "OFL.txt"), cache / f"{folder}-OFL.txt", license_sha)
        font = TTFont(upstream, recalcTimestamp=False)
        if "fvar" in font:
            font = instantiateVariableFont(font, {"wght": 400, "wdth": 100}, inplace=False)
        available = font.getBestCmap().keys()
        selected = desired & available
        if identifier == "NorieScienceSymbols":
            selected.difference_update(covered | set(range(0x80)))
        options = subset.Options()
        options.hinting = True
        options.layout_features = ["*"]
        options.name_IDs = [0, 1, 2, 3, 4, 5, 6, 13, 14, 16, 17]
        options.name_legacy = True
        options.name_languages = ["*"]
        sub = subset.Subsetter(options=options)
        sub.populate(unicodes=selected)
        sub.subset(font)
        rename(font, family, identifier)
        font.recalcTimestamp = False
        target = output / f"{identifier}.ttf"
        font.save(target, reorderTables=True)
        (output / f"{folder}-Science-OFL.txt").write_bytes(license_path.read_bytes())
        covered.update(font.getBestCmap())
        artifacts.append((folder, filename, font_sha, identifier, target.stat().st_size, sha256(target)))
    attribution = [
        "# Offline Science text and symbols", "",
        "Original fonts by the Noto Project Authors, licensed under SIL Open Font License 1.1.",
        "Official text project: https://github.com/notofonts/latin-greek-cyrillic",
        "Official math project: https://github.com/notofonts/math", "",
        f"Official Google Fonts distribution pinned to revision `{REVISION}`.", "",
        "Derived, renamed subsets: Norie Science Text (Noto Sans, width 100, weight 400)",
        "and Norie Science Symbols (Noto Sans Math, regular weight 400).",
        "The text subset includes ordinary letters/numerals, Greek, accented text and punctuation.",
        "The symbols subset supplies missing arrows, inequalities and mathematical operators;",
        "its cmap contains no ASCII letters, punctuation or digits. Neither subset claims emoji pictographs.",
        "Font sizes and the Norie theme remain unchanged. The app loads these local assets without network access.", "",
    ]
    for folder, filename, font_sha, identifier, size, artifact_sha in artifacts:
        attribution.extend([
            f"## {identifier}", "", f"Source: {source(folder, filename)}",
            f"Upstream SHA-256: `{font_sha}`",
            f"License: [{folder}-Science-OFL.txt]({folder}-Science-OFL.txt)",
            f"Bundled subset: {size:,} bytes; SHA-256 `{artifact_sha}`.", "",
        ])
    attribution.extend([
        "Rebuild: install `fonttools==4.60.1`, then run `python tools/build_science_text_font.py`.",
        "The script verifies pinned font/license checksums and derives paths from the repository location.",
        "Run `python tools/build_science_text_font.py --check` for glyph, ordinary-numeral and license validation without downloads.",
        "Subsets cover current Dart text plus planned Latin/Greek, superscript/subscript, arrow and math ranges;",
        "regenerate and review coverage when adding another script or unusual notation.", "",
    ])
    (output / "Science-ATTRIBUTION.md").write_text("\n".join(attribution), encoding="utf-8")
    verify_artifacts()


if __name__ == "__main__":
    main()
