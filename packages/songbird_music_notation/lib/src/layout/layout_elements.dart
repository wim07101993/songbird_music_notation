import 'package:flutter/painting.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// What a laid-out element is, so that hit testing and selection can tell a
/// notehead from the staff line behind it.
enum ElementRole {
  staffLine,
  ledgerLine,
  clef,
  keySignature,
  timeSignature,
  barline,
  notehead,
  tabNumber,
  stem,
  flag,
  beam,
  accidental,
  augmentationDot,
  rest,
  articulation,
  ornament,
  fermata,
  tie,
  slur,
  tuplet,
  arpeggio,
  ending,
  lyric,
  chordSymbol,
  dynamics,
  wedge,
  text,
  bracket,
  partName,
  measureNumber,
  cursor,
}

/// A drawable produced by layout, positioned in staff spaces.
///
/// Layout is deliberately kept free of pixels and of Flutter's canvas: it
/// produces this list, and painting walks it. That split is what lets the same
/// layout be measured for hit testing, exported to PDF, or drawn at any zoom
/// without being recomputed.
sealed class LayoutElement {
  const LayoutElement({
    this.source,
    this.owner,
    this.color,
    required this.role,
  });

  /// The model object this came from, for hit testing and highlighting.
  final Object? source;

  /// A colour the source asked for, or null to let the theme decide.
  ///
  /// This is the document's own wish — MusicXML lets a note carry a colour —
  /// and not a decision layout made. Everything the theme decides is decided
  /// while painting instead, so that changing a palette does not mean
  /// engraving the score again.
  final Color? color;

  /// The event the [source] belongs to, when [source] is a notehead or a
  /// lyric rather than the event itself.
  final MusicalEvent? owner;

  final ElementRole role;

  /// The area this covers, in staff spaces.
  Rect get bounds;

  /// Whether a click at [point] should select this.
  ///
  /// Defaults to the bounding box grown by [tolerance], which is the right
  /// answer for glyphs; lines and curves narrow it down.
  bool hitTest(Offset point, {double tolerance = 0.25}) =>
      bounds.inflate(tolerance).contains(point);
}

/// A SMuFL glyph drawn at a point.
///
/// [origin] is the glyph's own origin as the font defines it — the left edge
/// at the vertical centre of a notehead, the baseline of a clef — not the
/// corner of a box.
class GlyphElement extends LayoutElement {
  const GlyphElement({
    required this.glyph,
    required this.origin,
    required super.role,
    this.scale = 1,
    double? scaleY,
    super.color,
    required this.size,
    required this.aboveOrigin,
    this.rotation = 0,
    super.source,
    super.owner,
  }) : scaleY = scaleY ?? scale;

  final SmuflGlyph glyph;
  final Offset origin;

  /// Size relative to a full-size glyph; grace and cue notes are smaller.
  final double scale;

  /// Vertical size, when it differs from [scale].
  ///
  /// Only a brace needs this. It is stretched to whatever an instrument spans,
  /// and a brace scaled evenly grows as wide as it is tall: over a grand staff
  /// that is a mark thicker than a barline and heavier than the music. Drawn
  /// taller than it is wider, it stays the slender stroke it is meant to be.
  final double scaleY;

  /// Overrides the ink colour, for coloured notes and editorial marks.

  /// The glyph's extent, taken from the font metadata at layout time so that
  /// hit testing does not need the font.
  final Size size;

  /// How far the ink reaches above the point the glyph is drawn from.
  ///
  /// Both this and [size] are required, and both have to come from the font:
  /// they are what everything else measures a glyph by, and a glyph that
  /// reports a box its ink does not fill sends every mark placed clear of it
  /// to the wrong place. Guessing that the ink straddles the origin — true
  /// enough of a notehead, false of a clef or a fermata — is how a measure
  /// number came to be written across a G clef and a segno across a fermata.
  final double aboveOrigin;

  /// How far the glyph is turned about the point it is drawn from, clockwise
  /// in radians.
  ///
  /// The font draws its repeating line segments horizontally, to be turned by
  /// whoever needs one running up the page — the wave of an arpeggio is the
  /// same segment as the wave of a trill line. [size] and [aboveOrigin]
  /// describe the glyph as it ends up, so that everything measuring it can go
  /// on ignoring this.
  final double rotation;

  @override
  Rect get bounds => Rect.fromLTWH(
    origin.dx,
    origin.dy - aboveOrigin,
    size.width,
    size.height,
  );
}

/// A straight line: a staff line, a stem, a ledger line, a barline.
class LineElement extends LayoutElement {
  const LineElement({
    required this.from,
    required this.to,
    required this.thickness,
    required super.role,
    super.color,
    this.dashLength,
    this.gapLength,
    super.source,
    super.owner,
  });

  final Offset from;
  final Offset to;

  /// Stroke width in staff spaces.
  final double thickness;

  /// Set for a dashed line.
  final double? dashLength;
  final double? gapLength;

  @override
  Rect get bounds => Rect.fromPoints(from, to).inflate(thickness / 2);

  @override
  bool hitTest(Offset point, {double tolerance = 0.25}) {
    final reach = thickness / 2 + tolerance;
    final dx = to.dx - from.dx;
    final dy = to.dy - from.dy;
    final lengthSquared = dx * dx + dy * dy;
    if (lengthSquared == 0) return (point - from).distance <= reach;
    final t =
        (((point.dx - from.dx) * dx + (point.dy - from.dy) * dy) /
                lengthSquared)
            .clamp(0.0, 1.0);
    final closest = Offset(from.dx + t * dx, from.dy + t * dy);
    return (point - closest).distance <= reach;
  }
}

/// A beam, drawn as a filled quadrilateral so that it can be sloped.
class BeamElement extends LayoutElement {
  const BeamElement({
    required this.left,
    required this.right,
    required this.thickness,
    required super.role,
    super.color,
    super.source,
    super.owner,
  });

  /// The beam's left end, at the centre of its thickness.
  final Offset left;

  /// The beam's right end, at the centre of its thickness.
  final Offset right;

  final double thickness;

  /// The four corners, top-left first, going clockwise.
  List<Offset> get corners => [
    Offset(left.dx, left.dy - thickness / 2),
    Offset(right.dx, right.dy - thickness / 2),
    Offset(right.dx, right.dy + thickness / 2),
    Offset(left.dx, left.dy + thickness / 2),
  ];

  @override
  Rect get bounds => Rect.fromPoints(left, right).inflate(thickness / 2);
}

/// A slur or tie, as a cubic curve that is thicker in the middle than at the
/// ends.
class CurveElement extends LayoutElement {
  const CurveElement({
    required this.start,
    required this.end,
    required this.control1,
    required this.control2,
    required this.thickness,
    required this.endThickness,
    required super.role,
    super.color,
    super.source,
    super.owner,
  });

  final Offset start;
  final Offset end;
  final Offset control1;
  final Offset control2;

  /// Thickness at the middle of the curve.
  final double thickness;

  /// Thickness where it meets the notes.
  final double endThickness;

  @override
  Rect get bounds => Rect.fromPoints(
    start,
    end,
  ).expandToInclude(Rect.fromPoints(control1, control2)).inflate(thickness);

  @override
  bool hitTest(Offset point, {double tolerance = 0.25}) {
    // Sampling the curve is precise enough for picking, and much simpler than
    // solving for the nearest point on a cubic.
    const samples = 16;
    var previous = start;
    for (var i = 1; i <= samples; i++) {
      final t = i / samples;
      final current = _pointAt(t);
      final segment = LineElement(
        from: previous,
        to: current,
        thickness: thickness,
        role: role,
      );
      if (segment.hitTest(point, tolerance: tolerance)) return true;
      previous = current;
    }
    return false;
  }

  /// The point on the curve at parameter [t], from 0 at [start] to 1 at [end].
  Offset pointAt(double t) => _pointAt(t);

  Offset _pointAt(double t) {
    final u = 1 - t;
    return start * (u * u * u) +
        control1 * (3 * u * u * t) +
        control2 * (3 * u * t * t) +
        end * (t * t * t);
  }
}

/// Text drawn with an ordinary font: lyrics, tempo words, part names.
class TextElement extends LayoutElement {
  const TextElement({
    required this.text,
    required this.origin,
    required this.fontSize,
    required super.role,
    this.alignment = TextAlignment.left,
    this.italic = false,
    this.bold = false,
    super.color,
    this.measuredWidth = 0,
    super.source,
    super.owner,
  });

  final String text;

  /// The text's anchor point: the baseline, at whichever edge [alignment]
  /// names.
  final Offset origin;

  /// Size in staff spaces.
  final double fontSize;

  final TextAlignment alignment;
  final bool italic;
  final bool bold;

  /// Width measured at layout time, so hit testing and justification do not
  /// need to re-measure.
  final double measuredWidth;

  @override
  Rect get bounds {
    final left = switch (alignment) {
      TextAlignment.left => origin.dx,
      TextAlignment.center => origin.dx - measuredWidth / 2,
      TextAlignment.right => origin.dx - measuredWidth,
    };
    return Rect.fromLTWH(
      left,
      origin.dy - fontSize * 0.8,
      measuredWidth,
      fontSize,
    );
  }
}

enum TextAlignment { left, center, right }

/// A filled shape: a hairpin, a bracket, a note-entry caret.
class PolygonElement extends LayoutElement {
  const PolygonElement({
    required this.points,
    required super.role,
    this.filled = true,
    this.thickness = 0.16,
    this.closed = false,
    super.color,
    super.source,
    super.owner,
  });

  final List<Offset> points;
  final bool filled;
  final double thickness;
  final bool closed;

  @override
  Rect get bounds {
    var rect = Rect.fromPoints(points.first, points.first);
    for (final point in points) {
      rect = rect.expandToInclude(Rect.fromPoints(point, point));
    }
    return rect.inflate(thickness);
  }
}

/// A rectangle, used for selection highlights and staff backgrounds.
class RectElement extends LayoutElement {
  const RectElement({
    required this.rect,
    required super.role,
    super.color,
    this.filled = true,
    this.thickness = 0.1,
    this.cornerRadius = 0,
    super.source,
    super.owner,
  });

  final Rect rect;
  final bool filled;
  final double thickness;
  final double cornerRadius;

  @override
  Rect get bounds => rect;
}
