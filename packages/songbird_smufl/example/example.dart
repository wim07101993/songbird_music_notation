// Reads Bravura's published measurements and asks for the numbers a renderer
// needs to place a notehead and hang a stem off it.
//
// Nothing here needs Flutter. In a Flutter application the metadata arrives
// through the asset bundle instead — `rootBundle.loadString` on
// `SmuflFont.bravuraMetadataAsset` — and the rest is the same.
import 'dart:io';

import 'package:songbird_smufl/songbird_smufl.dart';

Future<void> main() async {
  final font = SmuflFont.bravuraFrom(
    await File('assets/metadata/bravura_metadata.json').readAsString(),
  );

  const glyph = SmuflGlyphs.noteheadBlack;
  // Every measurement is in staff spaces, y upwards, as SMuFL defines it.
  stdout
    ..writeln('advance width: ${font.advanceWidthOf(glyph)}')
    ..writeln('bounding box:  ${font.boundingBoxOf(glyph)}')
    ..writeln('stem up at:    ${font.stemUpAnchorOf(glyph)}')
    ..writeln('stem thickness: ${font.engraving.stemThickness}')
    // The glyph is named rather than spelled with a raw code point.
    ..writeln('draws as:      ${glyph.text} (${SmuflGlyphs.gClef.text})');
}
