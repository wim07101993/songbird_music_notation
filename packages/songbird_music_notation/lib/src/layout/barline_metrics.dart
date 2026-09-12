import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/font_metrics.dart';
import 'package:songbird_music_notation/src/layout/glyphs.dart';
import 'package:songbird_score/songbird_score.dart';

/// One stroke or glyph of a barline, measured from the group's left edge.
class BarlinePiece {
  const BarlinePiece({
    required this.offset,
    required this.thickness,
    required this.isDots,
  });

  /// Distance from the left edge of the barline group to this piece's own left
  /// edge.
  final double offset;

  /// Width of the stroke, or of the dots glyph.
  final double thickness;

  /// True for the repeat dots rather than a vertical line.
  final bool isDots;

  /// Where the centre of the stroke falls, which is where a line is drawn.
  double get centre => offset + thickness / 2;
}

/// How a barline is put together.
///
/// A closing repeat is dots, a thin line and a thick line, and takes about a
/// staff space and a half; a plain barline is a single hairline. Layout has to
/// know which before it can decide where the last note of the measure goes,
/// and the painter has to draw exactly what layout reserved — so both ask this,
/// rather than each carrying its own idea of the geometry.
class BarlineMetrics {
  BarlineMetrics(
    this.pieces,
    this.width,
  );

  /// The strokes and dots, left to right.
  final List<BarlinePiece> pieces;

  /// Total width of the group.
  final double width;

  static final BarlineMetrics none = BarlineMetrics(const [], 0);

  /// Whether the plain barline closing measure [index] gives way to the one
  /// that opens the measure after it.
  ///
  /// A measure that opens with a repeat carries the division between it and
  /// the one before: its heavy-light stroke is the barline there. Drawing an
  /// ordinary one as well leaves a thin line, a gap, and then the repeat.
  ///
  /// Anything the source asked for by name — a double bar, a closing repeat —
  /// is kept and drawn, and the two stand side by side.
  static bool yieldsToNext(Part part, int index) {
    final own = index < part.measures.length
        ? part.measures[index].rightBarline
        : null;
    if (own != null && (own.repeat != null || own.style != BarStyle.regular)) {
      return false;
    }
    final next = index + 1;
    if (next >= part.measures.length) return false;
    return part.measures[next].leftBarline != null;
  }

  /// Whether the barline opening measure [index] gives way to the one that
  /// closed the measure before it.
  ///
  /// A `<barline location="left">` that carries nothing of its own — no
  /// repeat, no style the source named — is there to hang a volta's start on,
  /// not to divide the measures. The bar before already ends in a barline, and
  /// drawing this one as well leaves a second thin line a hair past it.
  static bool yieldsToPrevious(Part part, int index) {
    if (index <= 0 || index >= part.measures.length) return false;
    final own = part.measures[index].leftBarline;
    if (own == null) return false;
    if (own.repeat != null || own.style != BarStyle.regular) return false;
    if (yieldsToNext(part, index - 1)) return false;
    final previous = part.measures[index - 1].rightBarline;
    return previous == null ||
        previous.repeat != null ||
        previous.style != BarStyle.none;
  }

  /// The air between the barline closing the measure before [index] and that
  /// measure's own opening barline.
  ///
  /// Nothing when the one before gave way, so the opening repeat stands on the
  /// measure line; a hair's breadth when both are drawn, which is what keeps a
  /// closing repeat from touching an opening one.
  static double separationBefore(Part part, int index, EngravingStyle style) {
    if (index <= 0 || index > part.measures.length) return 0;
    final previous = part.measures[index - 1].rightBarline;
    final drawn =
        previous != null &&
        (previous.repeat != null || previous.style != BarStyle.regular);
    return drawn ? style.lines.thinThickBarlineSeparation : 0;
  }

  /// Measures the barline drawn at the given [location] of a measure.
  factory BarlineMetrics.of(
    Barline? barline,
    EngravingStyle style,
    NotationMetrics metrics,
  ) {
    final barStyle = barline?.style ?? BarStyle.regular;
    if (barStyle == BarStyle.none && barline?.repeat == null) {
      return BarlineMetrics.none;
    }

    final thin = style.lines.thinBarlineThickness;
    final thick = style.lines.thickBarlineThickness;
    final separation = style.lines.thinThickBarlineSeparation;
    final dotsWidth = metrics.advanceWidth(NotationGlyphs.repeatDots);
    final dotsGap = style.lines.repeatBarlineDotSeparation;

    final repeat = barline?.repeat;
    final opensRepeat = repeat?.direction == RepeatDirection.forward;

    final pieces = <BarlinePiece>[];
    var cursor = 0.0;

    void add(double thickness, {bool isDots = false}) {
      pieces.add(
        BarlinePiece(offset: cursor, thickness: thickness, isDots: isDots),
      );
      cursor += thickness;
    }

    // A closing repeat reads dots, thin, thick; an opening one reads the same
    // backwards.
    if (repeat != null && !opensRepeat) {
      add(dotsWidth, isDots: true);
      cursor += dotsGap;
    }

    final strokes = _strokesFor(
      repeat == null
          ? barStyle
          : (opensRepeat ? BarStyle.heavyLight : BarStyle.lightHeavy),
      thin: thin,
      thick: thick,
    );
    for (var i = 0; i < strokes.length; i++) {
      if (i > 0) cursor += separation;
      add(strokes[i]);
    }

    if (repeat != null && opensRepeat) {
      cursor += dotsGap;
      add(dotsWidth, isDots: true);
    }

    return BarlineMetrics(pieces, cursor);
  }

  /// The vertical strokes a bar style is drawn with, left to right.
  static List<double> _strokesFor(
    BarStyle style, {
    required double thin,
    required double thick,
  }) => switch (style) {
    BarStyle.lightHeavy => [thin, thick],
    BarStyle.heavyLight => [thick, thin],
    BarStyle.lightLight => [thin, thin],
    BarStyle.heavyHeavy => [thick, thick],
    BarStyle.heavy => [thick],
    BarStyle.none => const [],
    _ => [thin],
  };
}
