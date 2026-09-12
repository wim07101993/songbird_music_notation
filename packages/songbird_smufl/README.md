# songbird_smufl

SMuFL music-font support for Flutter, with the Bravura font included.

SMuFL — the Standard Music Font Layout — puts every notation symbol at a known
code point and publishes the measurements a renderer needs: how wide each glyph
is, how far it extends, and where a stem attaches. This package exposes those as
Dart.

```dart
final font = await SmuflFont.bravura();

Text(
  SmuflGlyphs.noteheadBlack.text,
  style: TextStyle(
    fontFamily: font.family,
    package: font.package,
    fontSize: SmuflFont.fontSizeForStaffSpace(8),
  ),
);
```

## Names, not code points

All 2,940 glyphs the specification defines are generated as constants, so
drawing a notehead is `SmuflGlyphs.noteheadBlack` rather than `''`.

## Measurements

```dart
font.advanceWidthOf(SmuflGlyphs.gClef);        // staff spaces
font.boundingBoxOf(SmuflGlyphs.accidentalFlat);
font.stemUpAnchorOf(SmuflGlyphs.noteheadBlack);
font.engraving.stemThickness;                   // 0.12
font.engraving.beamThickness;                   // 0.5
```

Everything is in staff spaces with y increasing upwards, as the specification
defines it — Flutter's canvas has y increasing downwards, so anything taken
from the metadata has to be negated on the way to a `Canvas`. Keeping the
font's own convention here means the numbers can be checked against the
published metadata without mental arithmetic.

A SMuFL em is one staff — four staff spaces — so the text size that yields a
given staff space is four times it, which is what `fontSizeForStaffSpace` does.

## Another font

Any SMuFL font works; supply its metadata and family:

```dart
final font = SmuflFont(
  family: 'Petaluma',
  metadata: SmuflMetadata.parse(await rootBundle.loadString('...json')),
);
```

## Bravura

`Bravura.otf` is © 2015 Steinberg Media Technologies GmbH, with Reserved Font
Name "Bravura", redistributed under the SIL Open Font License 1.1. The full
licence is in `assets/fonts/OFL.txt`.
