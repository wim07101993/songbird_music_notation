import 'package:flutter/painting.dart';
import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/glyphs.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Measures glyphs and text for the layout engine.
///
/// Layout needs to know how wide a clef is before it can decide where the
/// first note goes. Glyph sizes come from the font metadata; text has to be
/// measured with a [TextPainter], which is cached because a page of lyrics
/// would otherwise lay out thousands of identical strings.
class NotationMetrics {
  NotationMetrics({
    required this.font,
    this.fonts = const NotationFonts(),
  });

  final SmuflFont font;

  /// The family used for lyrics and words. `null` uses the platform default.
  /// The families text is set in, chosen per [ElementRole] so that a lyric and
  /// a tempo mark can be measured in the faces they will be drawn in.
  final NotationFonts fonts;

  final Map<String, Size> _textCache = {};

  /// Advance width of [glyph] in staff spaces.
  double advanceWidth(SmuflGlyph glyph) => font.advanceWidthOf(glyph);

  /// The glyph's drawn extent in staff spaces, as a size centred on its
  /// origin's vertical position.
  Size glyphSize(SmuflGlyph glyph) {
    final box = font.boundingBoxOf(glyph);
    if (box == null) {
      return Size(font.advanceWidthOf(glyph), 1);
    }
    return Size(box.width, box.height);
  }

  /// How far [glyph] reaches above its origin, in staff spaces.
  double glyphTop(SmuflGlyph glyph) => font.boundingBoxOf(glyph)?.top ?? 0.5;

  /// How far [glyph] reaches below its origin; negative for a glyph that hangs
  /// down, matching the font's upward-positive convention.
  double glyphBottom(SmuflGlyph glyph) =>
      font.boundingBoxOf(glyph)?.bottom ?? -0.5;

  /// How far left of the origin the glyph starts.
  double glyphLeft(SmuflGlyph glyph) => font.boundingBoxOf(glyph)?.left ?? 0;

  /// How far right of the origin the glyph reaches.
  ///
  /// Not the same as the advance width: a flag reaches further than the pen
  /// moves, which is why an eighth note needs more room than its notehead.
  double glyphRight(SmuflGlyph glyph) =>
      font.boundingBoxOf(glyph)?.right ?? font.advanceWidthOf(glyph);

  /// Where an up stem attaches to [glyph], in staff spaces from its origin,
  /// with y measured downwards as layout does.
  Offset stemUpAnchor(SmuflGlyph glyph) {
    final anchor = font.stemUpAnchorOf(glyph);
    return Offset(anchor.x, -anchor.y);
  }

  /// Where a down stem attaches to [glyph].
  Offset stemDownAnchor(SmuflGlyph glyph) {
    final anchor = font.stemDownAnchorOf(glyph);
    return Offset(anchor.x, -anchor.y);
  }

  /// Splits [text] so that any sharp or flat in it is drawn from the music
  /// font, and measures each piece.
  ///
  /// "Clarinet in B♭" is what a score calls the instrument, and the flat in it
  /// is a character most text faces have never heard of: it comes out as an
  /// empty box. The music font has the sign, so the letters are set in the
  /// text face and the sign is taken from there.
  List<TextPiece> splitSigns(
    String text, {
    required double fontSize,
    ElementRole role = ElementRole.text,
    bool italic = false,
    bool bold = false,
  }) {
    final pieces = <TextPiece>[];
    final letters = StringBuffer();

    void flush() {
      if (letters.isEmpty) return;
      final run = letters.toString();
      letters.clear();
      pieces.add(
        TextPiece.letters(
          run,
          measureText(
            run,
            fontSize: fontSize,
            italic: italic,
            bold: bold,
            role: role,
          ).width,
        ),
      );
    }

    // Runes rather than code units, so that a double flat outside the basic
    // plane is one character and not two halves of one.
    for (final rune in text.runes) {
      final character = String.fromCharCode(rune);
      final accidental = NotationGlyphs.accidentalForCharacter(character);
      if (accidental == null) {
        letters.write(character);
        continue;
      }
      flush();
      final glyph = NotationGlyphs.accidental(accidental);
      // Sized against the letters beside it rather than against the staff, so
      // that a flat in a part name is the height of the B in front of it.
      final scale = fontSize / 3.2;
      pieces.add(
        TextPiece.sign(
          glyph,
          scale,
          advanceWidth(glyph) * scale + fontSize * 0.06,
        ),
      );
    }
    flush();
    return pieces;
  }

  /// The size of [text] at [fontSize] staff spaces.
  Size measureText(
    String text, {
    required double fontSize,
    bool italic = false,
    bool bold = false,
    ElementRole role = ElementRole.text,
  }) {
    final family = fonts.familyFor(role);
    final key = '$family|$fontSize|$italic|$bold|$text';
    final cached = _textCache[key];
    if (cached != null) return cached;

    // Measuring at a fixed nominal size and scaling keeps the cache small:
    // the same word at any zoom hits the same entry.
    const nominal = 100.0;
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: family,
          fontSize: nominal,
          fontStyle: italic ? FontStyle.italic : FontStyle.normal,
          fontWeight: bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    final size = Size(
      painter.width / nominal * fontSize,
      painter.height / nominal * fontSize,
    );
    painter.dispose();
    _textCache[key] = size;
    return size;
  }
}

/// One piece of a line of text: letters, or a sign taken from the music font.
class TextPiece {
  const TextPiece.letters(
    this.text,
    this.width,
  ) : glyph = null,
      scale = 1;
  const TextPiece.sign(
    this.glyph,
    this.scale,
    this.width,
  ) : text = null;

  /// The letters, for a run of ordinary text.
  final String? text;

  /// The sign, for a sharp or a flat.
  final SmuflGlyph? glyph;

  /// How large the sign is drawn, relative to a staff space.
  final double scale;

  /// How far this piece moves the pen along.
  final double width;
}
