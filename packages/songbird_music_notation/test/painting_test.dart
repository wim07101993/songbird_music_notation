import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Where the ink actually lands.
///
/// Everything else asks the layout where it put things. This paints a page and
/// reads the pixels back, because the two can disagree: the layout was right
/// about a scaled glyph and the painter drew it half a staff space lower, and
/// nothing that only asked the layout could have noticed.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SmuflFont font;
  late NotationMetrics metrics;
  late EngravingStyle style;

  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
    font = await loadBravura();
    metrics = NotationMetrics(font: font);
    style = EngravingStyle.fromFont(font);
  });

  /// Paints [elements] on their own and returns the rows that carry ink,
  /// in staff spaces.
  Future<({double top, double bottom})> inkOf(
    List<LayoutElement> elements, {
    double staffSpace = 60,
  }) async {
    const size = Size(10, 8);
    final image = await renderScoreToImage(
      layout: ScoreLayout(
        score: Score(),
        systems: const [],
        headerElements: elements,
        size: size,
        staffSpace: 1,
      ),
      font: font,
      style: style,
      staffSpace: staffSpace,
    );
    final data = await image.toByteData();
    final pixels = data!.buffer.asUint8List();
    final width = image.width;
    var top = -1;
    var bottom = -1;
    for (var y = 0; y < image.height; y++) {
      for (var x = 0; x < width; x++) {
        // Anything appreciably darker than the paper.
        if (pixels[(y * width + x) * 4] < 128) {
          if (top < 0) top = y;
          bottom = y;
          break;
        }
      }
    }
    expect(top, isNonNegative, reason: 'nothing was drawn');
    return (top: top / staffSpace, bottom: (bottom + 1) / staffSpace);
  }

  /// A glyph drawn at [scale] with its own origin asked for at y = 3.
  Future<({double top, double bottom})> glyphInk(
    SmuflGlyph glyph,
    double scale,
  ) => inkOf([
    GlyphElement(
      glyph: glyph,
      origin: const Offset(1, 3),
      role: ElementRole.notehead,
      scale: scale,
      size: metrics.glyphSize(glyph) * scale,
      aboveOrigin: metrics.glyphTop(glyph) * scale,
    ),
  ]);

  test('a glyph is drawn from the baseline the layout gave it', () async {
    const glyph = NotationGlyphs.repeatDots;
    final ink = await glyphInk(glyph, 1);
    expect(ink.top, closeTo(3 - metrics.glyphTop(glyph), 0.05));
    expect(ink.bottom, closeTo(3 - metrics.glyphBottom(glyph), 0.05));
  });

  test('and from the same place when it is drawn smaller', () async {
    // The bug this is here for: everything is measured in staff spaces and the
    // canvas carries the zoom, so a glyph at its natural size was laid out
    // four logical pixels tall. Text is snapped to whole logical pixels, and
    // half a logical pixel is half a staff space — so a mark at three quarters
    // came out half a space low while the same mark at full size happened to
    // land on a whole number and looked right.
    for (final scale in [0.75, 0.6, 0.5]) {
      const glyph = NotationGlyphs.repeatDots;
      final ink = await glyphInk(glyph, scale);
      expect(
        ink.top,
        closeTo(3 - metrics.glyphTop(glyph) * scale, 0.05),
        reason: 'at $scale',
      );
      expect(
        ink.bottom,
        closeTo(3 - metrics.glyphBottom(glyph) * scale, 0.05),
        reason: 'at $scale',
      );
    }
  });

  test('a word stands where the layout put it, at any size', () async {
    // The test runner ships no text font, so how far a letter reaches below
    // its baseline is not something to assert against. What can be asserted is
    // that the same word given the same baseline lands in the same place
    // however large it is set — which is what the rounding broke.
    double? reach;
    for (final fontSize in [1.2, 1.8, 2.4, 3.7]) {
      final ink = await inkOf([
        TextElement(
          text: '88',
          origin: const Offset(1, 3),
          fontSize: fontSize,
          role: ElementRole.text,
          measuredWidth: 2,
        ),
      ]);
      // The descent grows with the size; what must not move is the baseline
      // it grows from.
      final below = (ink.bottom - 3) / fontSize;
      reach ??= below;
      // Loose enough for the runner's stand-in box, whose own metrics
      // quantise, and far tighter than the half a staff space that was wrong.
      expect(below, closeTo(reach, 0.06), reason: 'at $fontSize');
    }
  });

  test('a tempo mark and its words stand on one line', () async {
    // Which is what a reader sees first when they do not: the note hanging
    // below the words beside it. Measured against a rule drawn on the line
    // they are both supposed to stand on, so that no font is involved.
    final beat = NotationGlyphs.metronomeNote(NoteType.quarter);
    const scale = 0.75;
    final rule = await inkOf([
      const LineElement(
        from: Offset(0, 3),
        to: Offset(9, 3),
        thickness: 0.04,
        role: ElementRole.staffLine,
      ),
    ]);
    final note = await inkOf([
      GlyphElement(
        glyph: beat,
        origin: Offset(1, 3 + metrics.glyphBottom(beat) * scale),
        role: ElementRole.text,
        scale: scale,
        size: metrics.glyphSize(beat) * scale,
        aboveOrigin: metrics.glyphTop(beat) * scale,
      ),
    ]);
    expect(note.bottom, closeTo(rule.bottom, 0.06));
  });
}
