import 'dart:ui' as ui;

import 'package:flutter/foundation.dart';
import 'package:flutter/rendering.dart';
import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Draws a [ScoreLayout] onto a canvas.
///
/// The layout is in staff spaces; this multiplies by [staffSpace] on the way
/// to the canvas, so zooming is a matter of painting the same layout with a
/// bigger number — no relayout, no reflow, and the line breaks stay where they
/// were.
class ScorePainter extends CustomPainter {
  ScorePainter({
    required this.layout,
    required this.font,
    required this.style,
    required this.staffSpace,
    this.selection = const {},
    this.hidden = const {},
    this.hovered,
    this.visibleArea,
    super.repaint,
  });

  final ScoreLayout layout;
  final SmuflFont font;
  final EngravingStyle style;

  /// Size of one staff space in logical pixels.
  final double staffSpace;

  /// Model objects to draw as selected.
  final Set<Object> selection;

  /// Model objects to leave undrawn.
  ///
  /// An editor typing over a syllable puts the syllable in here, so that the
  /// words being typed do not sit on top of the words already engraved.
  final Set<Object> hidden;

  /// The object under the pointer, if any.
  final Object? hovered;

  /// What the reader can currently see, in staff spaces. Everything outside it
  /// is skipped, which is what keeps a long score scrolling smoothly.
  ///
  /// A function rather than a rectangle because scrolling repaints without
  /// rebuilding: a rectangle taken when the painter was made would describe
  /// where the reader was looking one frame ago and then stop changing at all.
  /// Null draws the whole score, which is what printing and
  /// [renderScoreToImage] want.
  final Rect Function()? visibleArea;

  final _GlyphPainterCache _glyphs = _GlyphPainterCache();

  @override
  void paint(Canvas canvas, Size size) {
    canvas.save();
    canvas.scale(staffSpace);

    final clip =
        visibleArea?.call() ??
        Rect.fromLTWH(0, 0, layout.size.width, layout.size.height);

    for (final element in layout.headerElements) {
      _paintElement(canvas, element, Offset.zero, clip);
    }

    for (final system in layout.systems) {
      if (!system.bounds.inflate(4).overlaps(clip)) continue;
      final systemOrigin = Offset(system.left, system.top);
      for (final element in system.elements) {
        _paintElement(canvas, element, systemOrigin, clip);
      }
      for (final staff in system.staves) {
        final staffOrigin = Offset(system.left, staff.pageTop);
        for (final element in staff.elements) {
          _paintElement(canvas, element, staffOrigin, clip);
        }
      }
    }

    canvas.restore();
  }

  void _paintElement(
    Canvas canvas,
    LayoutElement element,
    Offset origin,
    Rect clip,
  ) {
    final bounds = element.bounds.shift(origin);
    if (!bounds.inflate(1).overlaps(clip)) return;
    if (hidden.isNotEmpty &&
        (hidden.contains(element.source) || hidden.contains(element.owner))) {
      return;
    }

    final isSelected =
        element.source != null &&
        (selection.contains(element.source) ||
            (element.owner != null && selection.contains(element.owner)));
    final isHovered =
        hovered != null &&
        (identical(element.source, hovered) ||
            identical(element.owner, hovered));

    final color = isSelected
        ? style.colors.selection
        : isHovered
        ? _blend(inkFor(element), style.colors.selection, 0.4)
        : null;

    if (isSelected && _isSelectableRole(element.role)) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          bounds.inflate(0.18),
          const Radius.circular(0.25),
        ),
        Paint()..color = style.colors.selectionFill,
      );
    }

    switch (element) {
      case final GlyphElement glyph:
        _paintGlyph(canvas, glyph, origin, color);
      case final LineElement line:
        _paintLine(canvas, line, origin, color);
      case final BeamElement beam:
        _paintBeam(canvas, beam, origin, color);
      case final CurveElement curve:
        _paintCurve(canvas, curve, origin, color);
      case final TextElement text:
        _paintText(canvas, text, origin, color);
      case final PolygonElement polygon:
        _paintPolygon(canvas, polygon, origin, color);
      case final RectElement rect:
        _paintRect(canvas, rect, origin, color);
    }
  }

  void _paintGlyph(
    Canvas canvas,
    GlyphElement element,
    Offset origin,
    Color? override,
  ) {
    final painter = _glyphs.painterFor(
      glyph: element.glyph,
      font: font,
      color: override ?? inkFor(element),
    );
    if (painter == null) return;
    final position = element.origin + origin;
    // A SMuFL glyph is drawn from its baseline, which sits on the staff
    // position the glyph refers to; TextPainter draws from the top of its box.
    final baseline = painter.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );
    _paintOnBaseline(
      canvas,
      painter,
      at: position,
      baseline: baseline,
      scale: element.scale,
      scaleY: element.scaleY,
      rotation: element.rotation,
    );
  }

  /// How much larger than a staff space text is laid out before being scaled
  /// down onto the canvas.
  ///
  /// Everything here is measured in staff spaces and the canvas carries the
  /// zoom, so a glyph asked for at its natural size is four logical pixels
  /// tall and a lyric is under two. Text is not rasterised at that size: it is
  /// snapped to whole logical pixels, and half a logical pixel is half a staff
  /// space. A mark drawn at three quarters landed half a space low while the
  /// same mark at full size happened to fall on a whole number and looked
  /// right — which is why a tempo mark's note hung below the words beside it.
  /// Laying out sixteen times larger and scaling down puts the snapping three
  /// orders of magnitude below anything a reader can see.
  static const double _nominalScale = 16;

  /// Draws [painter] so that its [baseline] lands on [at].
  ///
  /// The scaling is done on the canvas rather than in the offsets, so the
  /// baseline is subtracted in the space the painter was laid out in and there
  /// is nothing to get the factor wrong in.
  void _paintOnBaseline(
    Canvas canvas,
    TextPainter painter, {
    required Offset at,
    required double baseline,
    double scale = 1,
    double? scaleY,
    double rotation = 0,
  }) {
    canvas
      ..save()
      ..translate(at.dx, at.dy);
    // Turned about the point it is drawn from, which is how the font's own
    // line segments are made to run up a page rather than across it.
    if (rotation != 0) canvas.rotate(rotation);
    canvas.scale(scale / _nominalScale, (scaleY ?? scale) / _nominalScale);
    painter.paint(canvas, Offset(0, -baseline));
    canvas.restore();
  }

  void _paintLine(
    Canvas canvas,
    LineElement element,
    Offset origin,
    Color? override,
  ) {
    final paint = Paint()
      ..color = override ?? inkFor(element)
      ..strokeWidth = element.thickness
      ..strokeCap = StrokeCap.butt
      ..isAntiAlias = true;
    final from = element.from + origin;
    final to = element.to + origin;

    final dash = element.dashLength;
    if (dash == null) {
      canvas.drawLine(from, to, paint);
      return;
    }
    final gap = element.gapLength ?? dash;
    final total = (to - from).distance;
    if (total <= 0) return;
    final step = (to - from) / total;
    var travelled = 0.0;
    while (travelled < total) {
      final end = (travelled + dash).clamp(0.0, total);
      canvas.drawLine(from + step * travelled, from + step * end, paint);
      travelled = end + gap;
    }
  }

  void _paintBeam(
    Canvas canvas,
    BeamElement element,
    Offset origin,
    Color? override,
  ) {
    final path = Path();
    final corners = element.corners;
    path.moveTo(corners.first.dx + origin.dx, corners.first.dy + origin.dy);
    for (final corner in corners.skip(1)) {
      path.lineTo(corner.dx + origin.dx, corner.dy + origin.dy);
    }
    path.close();
    canvas.drawPath(
      path,
      Paint()
        ..color = override ?? inkFor(element)
        ..isAntiAlias = true,
    );
  }

  void _paintCurve(
    Canvas canvas,
    CurveElement element,
    Offset origin,
    Color? override,
  ) {
    // A slur is not a stroked curve of even width: it is a closed shape,
    // thickest in the middle and tapering to points at the ends. Drawing it as
    // two cubics — one out along the top, one back along the bottom — is what
    // gives it that shape.
    final start = element.start + origin;
    final end = element.end + origin;
    final c1 = element.control1 + origin;
    final c2 = element.control2 + origin;
    final bulge = (c1.dy - start.dy).sign * element.thickness;

    final path = Path()
      ..moveTo(start.dx, start.dy)
      ..cubicTo(c1.dx, c1.dy, c2.dx, c2.dy, end.dx, end.dy)
      ..cubicTo(c2.dx, c2.dy - bulge, c1.dx, c1.dy - bulge, start.dx, start.dy)
      ..close();

    canvas.drawPath(
      path,
      Paint()
        ..color = override ?? inkFor(element)
        ..isAntiAlias = true,
    );
    // The tapered ends would otherwise vanish at small sizes.
    canvas.drawPath(
      path,
      Paint()
        ..color = override ?? inkFor(element)
        ..style = PaintingStyle.stroke
        ..strokeWidth = element.endThickness
        ..isAntiAlias = true,
    );
  }

  void _paintText(
    Canvas canvas,
    TextElement element,
    Offset origin,
    Color? override,
  ) {
    // Laid out large and scaled down, for the same reason as a glyph: at a
    // lyric's true size of under two logical pixels the baseline snaps to a
    // whole one, which is most of a staff space.
    final painter = TextPainter(
      text: TextSpan(
        text: element.text,
        style: TextStyle(
          fontFamily: style.fonts.familyFor(element.role),
          fontSize: element.fontSize * _nominalScale,
          height: 1,
          color: override ?? inkFor(element),
          fontStyle: element.italic ? FontStyle.italic : FontStyle.normal,
          fontWeight: element.bold ? FontWeight.w600 : FontWeight.normal,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    final position = element.origin + origin;
    final width = painter.width / _nominalScale;
    final left = switch (element.alignment) {
      TextAlignment.left => position.dx,
      TextAlignment.center => position.dx - width / 2,
      TextAlignment.right => position.dx - width,
    };
    final baseline = painter.computeDistanceToActualBaseline(
      TextBaseline.alphabetic,
    );

    // A fret number is written on the line of its string, and the line is
    // broken to let it through: printed over it the digits are unreadable.
    if (element.role == ElementRole.tabNumber) {
      final height = painter.height / _nominalScale;
      canvas.drawRect(
        Rect.fromLTWH(
          left - 0.12,
          position.dy - baseline / _nominalScale,
          width + 0.24,
          height,
        ),
        Paint()..color = style.colors.background,
      );
    }

    _paintOnBaseline(
      canvas,
      painter,
      at: Offset(left, position.dy),
      baseline: baseline,
    );
    painter.dispose();
  }

  void _paintPolygon(
    Canvas canvas,
    PolygonElement element,
    Offset origin,
    Color? override,
  ) {
    if (element.points.isEmpty) return;
    final path = Path()
      ..moveTo(
        element.points.first.dx + origin.dx,
        element.points.first.dy + origin.dy,
      );
    for (final point in element.points.skip(1)) {
      path.lineTo(point.dx + origin.dx, point.dy + origin.dy);
    }
    if (element.closed) path.close();

    final paint = Paint()
      ..color = override ?? inkFor(element)
      ..isAntiAlias = true;
    if (element.filled) {
      canvas.drawPath(path, paint);
    } else {
      canvas.drawPath(
        path,
        paint
          ..style = PaintingStyle.stroke
          ..strokeWidth = element.thickness
          ..strokeJoin = StrokeJoin.miter,
      );
    }
  }

  void _paintRect(
    Canvas canvas,
    RectElement element,
    Offset origin,
    Color? override,
  ) {
    final rect = element.rect.shift(origin);
    final paint = Paint()
      ..color = override ?? inkFor(element)
      ..isAntiAlias = true;
    if (!element.filled) {
      paint
        ..style = PaintingStyle.stroke
        ..strokeWidth = element.thickness;
    }
    if (element.cornerRadius > 0) {
      canvas.drawRRect(
        RRect.fromRectAndRadius(rect, Radius.circular(element.cornerRadius)),
        paint,
      );
    } else {
      canvas.drawRect(rect, paint);
    }
  }

  static bool _isSelectableRole(ElementRole role) => switch (role) {
    ElementRole.staffLine ||
    ElementRole.ledgerLine ||
    ElementRole.barline => false,
    _ => true,
  };

  /// The colour [element] is drawn in when nothing has selected it.
  ///
  /// Public because it is the whole of the theme's colour logic, and anything
  /// drawing a [ScoreLayout] some other way — a PDF, a different canvas —
  /// needs the same answers.
  ///
  /// The order is the order of how specific a wish is. A voice colour is the
  /// reader asking, right now, to see one line apart from the others, so it
  /// wins. A colour written into the file is the document asking, and is
  /// obeyed unless [NotationColors.honourSourceColors] says not to — which is
  /// what rescues a dark palette from a file whose notes are all black.
  /// Otherwise the role decides: staff lines are their own colour, an
  /// editorial accidental is greyed, everything else is ink.
  Color inkFor(LayoutElement element) {
    final colors = style.colors;

    if (colors.voices.isNotEmpty) {
      final voice = _voiceOf(element);
      if (voice != null) {
        final chosen = colors.forVoice(voice);
        if (chosen != null) return chosen;
      }
    }

    final own = element.color;
    if (own != null && colors.honourSourceColors) return own;

    if (element.role == ElementRole.staffLine) return colors.staffLines;
    final source = element.source;
    if (source is Accidental && source.editorial) return colors.editorial;
    return colors.ink;
  }

  /// The voice an element belongs to, or null for something — a staff line, a
  /// title — that belongs to no line of music.
  static int? _voiceOf(LayoutElement element) {
    final owner = element.owner;
    if (owner is MusicalEvent) return owner.voice;
    final source = element.source;
    if (source is MusicalEvent) return source.voice;
    // A slur or a tie is not an event, but it belongs to the line its first
    // note belongs to, and colouring a voice apart while its slurs stay behind
    // in ink would leave the phrase mark hanging off nothing.
    if (source is Spanner) return source.start.voice;
    return null;
  }

  static Color _blend(Color a, Color b, double t) => Color.lerp(a, b, t) ?? a;

  @override
  bool shouldRepaint(ScorePainter old) =>
      old.layout != layout ||
      old.staffSpace != staffSpace ||
      old.selection != selection ||
      !setEquals(old.hidden, hidden) ||
      old.hovered != hovered ||
      old.style != style;
  // [visibleArea] is deliberately not compared: it is read while painting, and
  // scrolling repaints through the position this painter was given.
}

/// Caches the [TextPainter] for each glyph.
///
/// A page holds thousands of noteheads and a handful of distinct glyphs;
/// laying out the same one-character string for each of them dominates the
/// frame otherwise. Painters are laid out at a nominal size and the canvas
/// scale does the rest, so zooming does not invalidate the cache.
class _GlyphPainterCache {
  final Map<String, TextPainter?> _cache = {};

  TextPainter? painterFor({
    required SmuflGlyph glyph,
    required SmuflFont font,
    required Color color,
  }) {
    final key = '${glyph.name}|${color.toARGB32()}';
    if (_cache.containsKey(key)) return _cache[key];

    final text = glyph.text;
    if (text.isEmpty) {
      _cache[key] = null;
      return null;
    }
    final painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: font.family,
          package: font.package,
          // Layout works in staff spaces, and a SMuFL em is four of them —
          // laid out larger than that and scaled down when it is drawn, so
          // that the text engine's rounding stays far below a staff space.
          fontSize:
              SmuflFont.fontSizeForStaffSpace(1) * ScorePainter._nominalScale,
          height: 1,
          color: color,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    _cache[key] = painter;
    return painter;
  }
}

/// Renders a layout to an image, for export and for tests.
Future<ui.Image> renderScoreToImage({
  required ScoreLayout layout,
  required SmuflFont font,
  required EngravingStyle style,
  required double staffSpace,
}) {
  final recorder = ui.PictureRecorder();
  final size = Size(
    layout.size.width * staffSpace,
    layout.size.height * staffSpace,
  );
  final canvas = Canvas(recorder, Offset.zero & size);
  canvas.drawRect(Offset.zero & size, Paint()..color = style.colors.background);
  ScorePainter(
    layout: layout,
    font: font,
    style: style,
    staffSpace: staffSpace,
  ).paint(canvas, size);
  return recorder.endRecording().toImage(size.width.ceil(), size.height.ceil());
}
