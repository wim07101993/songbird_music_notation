import 'dart:io';

import 'package:songbird_smufl/songbird_smufl.dart';
import 'package:test/test.dart';

/// Runs under `dart test`, not `flutter test`.
///
/// That is the point of it: this package has no Flutter in it, and a stray
/// import would stop these from running at all.
void main() {
  test('glyph names carry the code point the specification gives them', () {
    expect(SmuflGlyphs.noteheadBlack.name, 'noteheadBlack');
    expect(SmuflGlyphs.noteheadBlack.text, isNotEmpty);
  });

  test('a font without metadata still measures a notehead', () {
    const font = SmuflFont.bravuraFallback;
    expect(font.metadata, isNull);
    expect(font.advanceWidthOf(SmuflGlyphs.noteheadBlack), closeTo(1.18, 0.01));
    expect(font.engraving.staffLineThickness, greaterThan(0));
  });

  test('the bundled metadata measures it from the font itself', () {
    // Read straight off disk: what an asset bundle is for is Flutter's half of
    // the job, and there is none of that here.
    final source = File(
      'assets/metadata/bravura_metadata.json',
    ).readAsStringSync();
    final font = SmuflFont.bravuraFrom(source);

    expect(font.family, 'Bravura');
    expect(font.metadata, isNotNull);
    expect(font.advanceWidthOf(SmuflGlyphs.noteheadBlack), greaterThan(1));
    final box = font.boundingBoxOf(SmuflGlyphs.gClef);
    expect(box, isNotNull);
    // A G clef reaches much further above the line it names than below it.
    expect(box!.top, greaterThan(-box.bottom));
    expect(font.stemUpAnchorOf(SmuflGlyphs.noteheadBlack).x, greaterThan(0));
  });

  test('a staff space is a quarter of the em the font is drawn on', () {
    expect(SmuflFont.fontSizeForStaffSpace(8), 32);
  });
}
