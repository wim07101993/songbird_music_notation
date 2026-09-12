import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:songbird_music_notation/src/layout/barline_metrics.dart';
import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/font_metrics.dart';
import 'package:songbird_music_notation/src/layout/glyphs.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_music_notation/src/layout/spacing.dart';
import 'package:songbird_music_notation/src/layout/staff_builder.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Turns a [Score] into a [ScoreLayout].
///
/// The work happens in three passes. First every measure is measured, across
/// all parts at once, so that the parts line up. Then the measures are packed
/// into systems that fit the page width and each system is justified. Only then
/// is each staff's content built, and the staves stacked using the space their
/// contents turned out to need.
class LayoutEngine {
  LayoutEngine({
    required SmuflFont font,
    EngravingStyle? style,
  }) : this._(font, (style ?? const EngravingStyle()).withFont(font));

  LayoutEngine._(
    this.font,
    this.style,
  ) : metrics = NotationMetrics(font: font, fonts: style.fonts);

  final SmuflFont font;

  /// The score's theme: its sizes, its colours and the faces its text is set
  /// in. Colours are not used here — they are chosen while painting, so that
  /// changing a palette does not mean engraving the score again.
  final EngravingStyle style;

  final NotationMetrics metrics;

  /// Lays [score] out to fit [width] staff spaces.
  ///
  /// [width] is the page width in staff spaces: at a staff space of 8 logical
  /// pixels, an 800-pixel viewport is 100 of them.
  ScoreLayout layout(Score score, {required double width}) {
    if (score.parts.isEmpty) {
      return ScoreLayout(
        score: score,
        systems: const [],
        headerElements: const [],
        size: Size(width, style.pageMargin * 2),
        staffSpace: 1,
      );
    }

    final spacing = SpacingEngine(style: style, metrics: metrics);
    final contextsByPart = [
      for (final part in score.parts) part.contextsPerMeasure(),
    ];
    // Built once for the whole score rather than once per staff per system,
    // which is the difference between a symphony laying out in a moment and
    // in a second.
    final spannerIndex = [for (final part in score.parts) SpannerIndex(part)];
    final measureCount = score.measureCount;

    final plans = <MeasureSpacing>[];
    for (var index = 0; index < measureCount; index++) {
      plans.add(
        spacing.planMeasure(score, index, [
          for (var p = 0; p < score.parts.length; p++)
            if (index < contextsByPart[p].length)
              contextsByPart[p][index]
            else
              MusicalContext(),
        ]),
      );
    }

    final headerElements = _buildHeader(score, width);
    final headerHeight = _extentOf(headerElements);

    final indent = _partNameWidth(score);
    final left = style.pageMargin + indent;
    final available = math.max(width - left - style.pageMargin, 8.0);

    final breaks = _breakIntoSystems(
      score: score,
      plans: plans,
      contextsByPart: contextsByPart,
      spacing: spacing,
      available: available,
    );

    final systems = <SystemLayout>[];
    var y = style.pageMargin + headerHeight;

    for (var systemIndex = 0; systemIndex < breaks.length; systemIndex++) {
      final range = breaks[systemIndex];
      final system = _buildSystem(
        score: score,
        systemIndex: systemIndex,
        range: range,
        plans: plans,
        contextsByPart: contextsByPart,
        spacing: spacing,
        spannerIndex: spannerIndex,
        left: left,
        width: available,
        top: y,
        isFirstSystem: systemIndex == 0,
      );
      systems.add(system);
      y = system.top + system.height + style.systemDistance;
    }

    return ScoreLayout(
      score: score,
      systems: systems,
      headerElements: headerElements,
      size: Size(width, y - style.systemDistance + style.pageMargin),
      staffSpace: 1,
    );
  }

  // --------------------------------------------------------- system breaks

  /// Packs measures into systems that fit [available].
  ///
  /// Greedy fitting is what a reader expects — measures fill the line and the
  /// next one starts a new system — and unlike a global optimisation it keeps
  /// earlier lines stable while later ones are edited.
  List<_SystemRange> _breakIntoSystems({
    required Score score,
    required List<MeasureSpacing> plans,
    required List<List<MusicalContext>> contextsByPart,
    required SpacingEngine spacing,
    required double available,
  }) {
    final ranges = <_SystemRange>[];
    var start = 0;
    var used = 0.0;
    var startFurniture = 0.0;

    for (var index = 0; index < plans.length; index++) {
      final plan = plans[index];
      final furniture = index == start
          ? _systemStartWidth(score, index, contextsByPart, spacing)
          : 0.0;

      // A measure may ask for a new system, and the request is honoured as
      // long as it does not produce an empty one.
      final forcedBreak =
          style.honourSystemBreaks &&
          index > start &&
          score.parts.any(
            (part) =>
                index < part.measures.length &&
                (part.measures[index].printHint?.newSystem ?? false),
          );

      // A fixed count breaks where it says to, full system or not, because a
      // reader following four-measure phrases wants each line to hold one.
      final perSystem = style.measuresPerSystem;
      final countedOut =
          perSystem != null && perSystem > 0 && index - start >= perSystem;

      final width = _measureWidth(plan, furniture);
      if (index > start &&
          (forcedBreak || countedOut || used + width > available)) {
        ranges.add(
          _SystemRange(start: start, end: index - 1, furniture: startFurniture),
        );
        start = index;
        startFurniture = _systemStartWidth(
          score,
          index,
          contextsByPart,
          spacing,
        );
        used = _measureWidth(plan, startFurniture);
        continue;
      }

      if (index == start) startFurniture = furniture;
      used += width;
    }

    if (start < plans.length) {
      ranges.add(
        _SystemRange(
          start: start,
          end: plans.length - 1,
          furniture: startFurniture,
        ),
      );
    }
    return ranges;
  }

  /// How wide a measure ends up, given the clef and key printed before it at
  /// the start of a system.
  ///
  /// The furniture is not part of the measure's own natural width, and it does
  /// not replace the leading space the measure already asked for — it widens
  /// the measure by whatever more it needs. Counting it any other way lets a
  /// system overflow the page.
  double _measureWidth(MeasureSpacing plan, double furniture) =>
      plan.naturalWidth +
      math.max(0, furniture + plan.headExtent - plan.leadingWidth);

  /// How much room the clef, key and time signature need at the start of a
  /// system beginning with measure [index].
  double _systemStartWidth(
    Score score,
    int index,
    List<List<MusicalContext>> contextsByPart,
    SpacingEngine spacing,
  ) {
    var widest = 0.0;
    // A system can begin on a measure that opens with a repeat, and the clef
    // reprinted after it has to start beyond the barline. Left out of the
    // reservation, the first notes of the system were placed over the key.
    var barline = 0.0;
    for (final part in score.parts) {
      if (index >= part.measures.length) continue;
      final left = part.measures[index].leftBarline;
      if (left == null) continue;
      barline = math.max(
        barline,
        BarlineMetrics.of(left, style, metrics).width,
      );
    }

    for (var p = 0; p < score.parts.length; p++) {
      final contexts = contextsByPart[p];
      if (index >= contexts.length) continue;
      final context = contexts[index];
      for (var staff = 1; staff <= context.staffCount; staff++) {
        final clef = context.clefFor(staff);
        var width =
            style.measureFurnitureGap +
            metrics.advanceWidth(NotationGlyphs.clef(clef)) +
            style.clefGap +
            spacing.keySignatureWidth(context.keyFor(staff));
        final showsTime =
            context.printTime &&
            (index == 0 ||
                (index < score.parts[p].measures.length &&
                    score.parts[p].measures[index].attributesOrNull?.time !=
                        null));
        if (showsTime) {
          width += spacing.timeSignatureWidth(context.time) + style.timeGap;
        }
        widest = math.max(widest, width);
      }
    }
    return widest == 0 ? 0 : widest + barline;
  }

  /// Where the right edge of a brace sits, just clear of the system's line.
  static const double _braceEdge = -0.35;

  /// How far left of the music a group bracket goes.
  ///
  /// Hard against whatever it has to clear: the line down the left of the
  /// system when there is nothing between them, the widest brace when there
  /// is. A bracket standing off from the system's own line leaves a channel of
  /// white where engraved music has the two touching.
  double _bracketLane(List<StaffLayout> staves) =>
      -_bracketRightEdge(_widestBrace(staves)) +
      style.lines.bracketThickness / 2;

  /// The white a bracket keeps between itself and whatever is to its right —
  /// the system's own line, or a brace. Enough to read as two marks rather
  /// than one, and not enough to be a channel.
  static const double _bracketGap = 0.45;

  /// The right edge of a bracket outside a brace of [widestBrace] spaces, or
  /// outside nothing.
  double _bracketRightEdge(double widestBrace) =>
      (widestBrace > 0 ? _braceEdge - widestBrace : 0) - _bracketGap;

  /// How wide the widest brace in [staves] comes out.
  double _widestBrace(List<StaffLayout> staves) {
    var widest = 0.0;
    var index = 0;
    while (index < staves.length) {
      final part = staves[index].part;
      var last = index;
      while (last + 1 < staves.length &&
          identical(staves[last + 1].part, part)) {
        last++;
      }
      if (last > index) {
        final span =
            staves[last].pageTop +
            staves[last].geometry.height -
            staves[index].pageTop;
        widest = math.max(widest, _braceWidth(span));
      }
      index = last + 1;
    }
    return widest;
  }

  /// How wide the brace glyph comes out when stretched over [span].
  double _braceWidth(double span) {
    const glyph = NotationGlyphs.brace;
    final natural = metrics.glyphTop(glyph) - metrics.glyphBottom(glyph);
    if (natural <= 0) return 0;
    return metrics.glyphRight(glyph) *
        _braceWidening(math.max(span, 1.0) / natural);
  }

  /// A brace spanning [topY] to [bottomY], with its right edge at [at].
  ///
  /// The font draws a brace four staff spaces tall — the height of one staff —
  /// so it is scaled to whatever the span turns out to be. A grand staff is
  /// about three times that, and a brace scaled with it widens as an engraved
  /// one does.
  GlyphElement _brace(
    double topY,
    double bottomY, {
    required double at,
    Object? source,
  }) {
    const glyph = NotationGlyphs.brace;
    final span = math.max(bottomY - topY, 1.0);
    final natural = metrics.glyphTop(glyph) - metrics.glyphBottom(glyph);
    final tall = natural <= 0 ? 1.0 : span / natural;
    final wide = _braceWidening(tall);
    return GlyphElement(
      glyph: glyph,
      origin: Offset(
        at - metrics.glyphRight(glyph) * wide,
        bottomY + metrics.glyphBottom(glyph) * tall,
      ),
      role: ElementRole.bracket,
      scale: wide,
      scaleY: tall,
      // As wide as the stroke ends up and as tall as the staves it spans,
      // hanging from the top of that span.
      size: Size(metrics.glyphRight(glyph) * wide, span),
      aboveOrigin: metrics.glyphTop(glyph) * tall,
      source: source,
    );
  }

  /// How much wider a brace gets as it gets taller.
  ///
  /// Far less than it gets taller. The font draws one the height of a single
  /// staff; stretched evenly to a grand staff it comes out over a staff space
  /// wide, which is thicker than a barline and heavier than the music beside
  /// it. An engraved brace thickens slowly and then stops, which the square
  /// root and the ceiling between them describe well enough.
  double _braceWidening(double tall) => math.min(math.sqrt(tall), 2.0);

  // ---------------------------------------------------------------- system

  SystemLayout _buildSystem({
    required Score score,
    required int systemIndex,
    required _SystemRange range,
    required List<MeasureSpacing> plans,
    required List<List<MusicalContext>> contextsByPart,
    required SpacingEngine spacing,
    required List<SpannerIndex> spannerIndex,
    required double left,
    required double width,
    required double top,
    required bool isFirstSystem,
  }) {
    // Lay the measures out at their natural widths, then share out whatever is
    // left over so the system reaches the right margin.
    final included = [for (var i = range.start; i <= range.end; i++) plans[i]];
    var natural = 0.0;
    var flexible = 0.0;
    for (final plan in included) {
      final extra = plan.index == range.start ? range.furniture : 0.0;
      natural += _measureWidth(plan, extra);
      flexible += plan.flexibleWidth;
    }
    final surplus = width - natural;
    // A line of whole rests has nothing that can stretch — a measure of one
    // column has no space between columns to grow — so justification had
    // nothing to work with and the line stopped short of the margin with the
    // barlines bunched at the left. The surplus is shared out between the
    // measures instead, which widens the bars and leaves a centred measure
    // rest in the middle of its own.
    final rigid = flexible <= 0.001 && surplus > 0 && included.isNotEmpty;
    // The last system of a score is left ragged rather than stretched across
    // the page, which is what engravers do — unless it is nearly full, in
    // which case stretching it to the margin looks deliberate and leaving a
    // sliver of white does not.
    final isLast = range.end == plans.length - 1;
    final nearlyFull = natural >= width * _lastSystemFillThreshold;
    final justify = (!isLast || nearlyFull) && surplus > 0;
    final stretch = justify && flexible > 0 ? surplus / flexible : 0.0;
    final padding = justify && rigid ? surplus / included.length : 0.0;

    final slots = <MeasureSlot>[];
    var x = 0.0;
    for (final plan in included) {
      final furniture = plan.index == range.start ? range.furniture : 0.0;
      // Whatever reaches left of the first note has to clear the clef and key
      // reprinted in front of it, not start where they end.
      final leading = math.max(plan.leadingWidth, furniture + plan.headExtent);
      final grown = plan.flexibleWidth * (1 + stretch);
      final measureWidth = leading + grown + plan.trailingWidth + padding;

      final positions = <Fraction, double>{};
      final scale = plan.flexibleWidth > 0 ? grown / plan.flexibleWidth : 1.0;
      for (final column in plan.columns) {
        positions[column.position] = x + leading + column.x * scale;
      }

      slots.add(
        MeasureSlot(
          index: plan.index,
          left: x,
          width: measureWidth,
          musicLeft: x + leading,
          musicRight: x + measureWidth - plan.barlineReserve,
          columnPositions: positions,
        ),
      );
      x += measureWidth;
    }

    // Build every staff, then stack them by how much room they turned out to
    // need.
    final built = <_BuiltStaff>[];
    for (var p = 0; p < score.parts.length; p++) {
      final part = score.parts[p];
      final contexts = contextsByPart[p];
      final staffCount = range.start < contexts.length
          ? contexts[range.start].staffCount
          : 1;
      for (var staff = 1; staff <= staffCount; staff++) {
        final entries = <StaffMeasure>[];
        for (var i = range.start; i <= range.end; i++) {
          if (i >= part.measures.length) continue;
          entries.add(
            StaffMeasure(
              measure: part.measures[i],
              slot: slots[i - range.start],
              context: i < contexts.length ? contexts[i] : MusicalContext(),
              isSystemStart: i == range.start,
            ),
          );
        }
        final details = range.start < contexts.length
            ? contexts[range.start].detailsFor(staff)
            : const StaffDetails();
        final builder = StaffContentBuilder(
          part: part,
          staffNumber: staff,
          style: style,
          metrics: metrics,
          spacing: spacing,
          systemWidth: x,
          lineCount: details.staffLines,
          spanners: spannerIndex[p],
          // The top staff of the score carries the volta brackets for all of
          // it, the way a conductor's score is written.
          showsEndings: p == 0 && staff == 1,
        );
        built.add(_BuiltStaff(partIndex: p, layout: builder.build(entries)));
      }
    }

    // [top] is where the system may begin; the first staff's lines sit below
    // it by however far its contents reach above them, so that a high note
    // with ledger lines does not run into the system above.
    final systemTop =
        top + (built.isEmpty ? 0.0 : built.first.layout.contentTop);

    var cursor = 0.0;
    final staves = <StaffLayout>[];
    for (var i = 0; i < built.length; i++) {
      final entry = built[i];
      final previous = i == 0 ? null : built[i - 1];
      if (previous != null) {
        final gap = previous.partIndex == entry.partIndex
            ? style.staffDistance
            : style.partDistance;
        cursor += math.max(
          gap,
          previous.layout.contentBottom + entry.layout.contentTop,
        );
      }
      final placed = StaffLayout(
        geometry: entry.layout.geometry,
        elements: entry.layout.elements,
        contentTop: entry.layout.contentTop,
        contentBottom: entry.layout.contentBottom,
        pageTop: systemTop + cursor,
      );
      staves.add(placed);
      cursor += placed.geometry.height;
    }

    final systemElements = _buildSystemFurniture(
      score: score,
      staves: staves,
      slots: slots,
      top: systemTop,
      width: x,
      isFirstSystem: isFirstSystem,
    );
    _addCrossStaffSlurs(
      score: score,
      staves: staves,
      elements: systemElements,
      top: systemTop,
      spannerIndex: spannerIndex,
    );

    final contentBottom = built.isEmpty ? 0.0 : built.last.layout.contentBottom;

    return SystemLayout(
      index: systemIndex,
      top: systemTop,
      left: left,
      width: x,
      staves: staves,
      measures: slots,
      elements: systemElements,
      height: cursor + contentBottom,
    );
  }

  /// The slurs that run from one staff of an instrument to another.
  ///
  /// A staff is engraved on its own and knows nothing of the one beneath it,
  /// so a slur from the left hand of a keyboard up to the right cannot be
  /// drawn there: left to each staff, it came out as two halves running off
  /// the edges of the page. It is drawn here, where both staves have been
  /// given their places.
  void _addCrossStaffSlurs({
    required Score score,
    required List<StaffLayout> staves,
    required List<LayoutElement> elements,
    required double top,
    required List<SpannerIndex> spannerIndex,
  }) {
    // Where each chord of the system ended up, in the system's own y.
    final anchors = <MusicalEvent, ({Rect box, int staff})>{};
    final byPart = <int, List<MusicalEvent>>{};
    for (var i = 0; i < staves.length; i++) {
      final staff = staves[i];
      final offset = staff.pageTop - top;
      final partIndex = score.parts.indexWhere(
        (part) => identical(part, staff.part),
      );
      for (final element in staff.elements) {
        if (element.role != ElementRole.notehead &&
            element.role != ElementRole.tabNumber) {
          continue;
        }
        final owner = element.owner;
        if (owner == null) continue;
        final box = element.bounds.translate(0, offset);
        final seen = anchors[owner];
        anchors[owner] = (
          box: seen == null ? box : seen.box.expandToInclude(box),
          staff: i,
        );
        if (seen == null && partIndex >= 0) {
          (byPart[partIndex] ??= []).add(owner);
        }
      }
    }

    for (final entry in byPart.entries) {
      // Through the index rather than the part's whole list of spanners: that
      // list grows with the length of the score and would be walked once for
      // every system of it.
      for (final spanner in spannerIndex[entry.key].touching(entry.value)) {
        if (spanner is! Slur) continue;
        final from = anchors[spanner.start];
        final to = anchors[spanner.end];
        // Both ends on this system, and on different staves of it: anything
        // else the staff drew for itself.
        if (from == null || to == null || from.staff == to.staff) continue;

        final descends = to.staff > from.staff;
        final start = Offset(
          from.box.center.dx,
          descends ? from.box.bottom + 0.5 : from.box.top - 0.5,
        );
        final end = Offset(
          to.box.center.dx,
          descends ? to.box.top - 0.5 : to.box.bottom + 0.5,
        );

        // Bowed away from the line between the notes rather than upwards: a
        // slur between staves runs steeply, and a bulge measured in y alone
        // would pinch it into a loop.
        final delta = end - start;
        final length = delta.distance;
        if (length < 0.01) continue;
        final normal = Offset(-delta.dy, delta.dx) / length;
        final bulge = math.min(style.slurHeight, 0.4 + length * 0.12);
        elements.add(
          CurveElement(
            start: start,
            end: end,
            control1: Offset.lerp(start, end, 0.25)! + normal * bulge,
            control2: Offset.lerp(start, end, 0.75)! + normal * bulge,
            thickness: style.lines.slurMidpointThickness,
            endThickness: style.lines.slurEndpointThickness,
            role: ElementRole.slur,
            source: spanner,
          ),
        );
      }
    }
  }

  /// Barlines that run between staves, part brackets and part names.
  List<LayoutElement> _buildSystemFurniture({
    required Score score,
    required List<StaffLayout> staves,
    required List<MeasureSlot> slots,
    required double top,
    required double width,
    required bool isFirstSystem,
  }) {
    final elements = <LayoutElement>[];
    if (staves.isEmpty) return elements;

    double localY(StaffLayout staff, double offset) =>
        staff.pageTop - top + offset;

    // Group the staves belonging to one part, so a piano's two staves are
    // joined by a brace and share their barlines.
    var index = 0;
    while (index < staves.length) {
      final part = staves[index].part;
      var last = index;
      while (last + 1 < staves.length &&
          identical(staves[last + 1].part, part)) {
        last++;
      }
      if (last > index) {
        final topY = localY(staves[index], 0);
        final bottomY = localY(staves[last], staves[last].geometry.height);
        elements
          ..add(
            LineElement(
              from: Offset(0, topY),
              to: Offset(0, bottomY),
              thickness: style.lines.thinBarlineThickness,
              role: ElementRole.bracket,
              source: part,
            ),
          )
          // What says at a glance that two staves are one instrument. The line
          // above only joins them; the brace is what makes them a keyboard.
          ..add(_brace(topY, bottomY, at: _braceEdge, source: part));
        // The barline between the staves of one part matches the one drawn on
        // each staff, so a closing repeat runs through the brace unbroken.
        // Which barline that is has to be decided the same way here as there:
        // asking only for the right one left a stray stroke across the gap at
        // an opening repeat, standing beside the repeat the staves had drawn.
        void connect(BarlineMetrics shape, double left) {
          for (final piece in shape.pieces) {
            if (piece.isDots) continue;
            elements.add(
              LineElement(
                from: Offset(left + piece.centre, topY),
                to: Offset(left + piece.centre, bottomY),
                thickness: piece.thickness,
                role: ElementRole.barline,
                source: part,
              ),
            );
          }
        }

        for (final slot in slots) {
          final measure = slot.index < part.measures.length
              ? part.measures[slot.index]
              : null;

          if (measure?.leftBarline != null) {
            final opening = BarlineMetrics.of(
              measure!.leftBarline,
              style,
              metrics,
            );
            connect(
              opening,
              slot.left +
                  BarlineMetrics.separationBefore(part, slot.index, style),
            );
          }

          if (BarlineMetrics.yieldsToNext(part, slot.index)) continue;
          final shape = BarlineMetrics.of(
            measure?.rightBarline,
            style,
            metrics,
          );
          connect(shape, slot.right - shape.width);
        }
      }
      index = last + 1;
    }

    for (final group in score.partGroups) {
      final members = [
        for (final staff in staves)
          if (score.parts.indexOf(staff.part) >= group.startPartIndex &&
              score.parts.indexOf(staff.part) <= group.endPartIndex)
            staff,
      ];
      if (members.isEmpty) continue;
      final topY = localY(members.first, 0);
      final bottomY = localY(members.last, members.last.geometry.height);
      if (group.symbol == GroupSymbol.none) continue;
      if (group.symbol == GroupSymbol.brace) {
        elements.add(_brace(topY, bottomY, at: _braceEdge, source: group));
        continue;
      }
      // Outside the braces inside *this* group, not every brace in the
      // system: a bracket around the woodwinds has none within it and belongs
      // hard against the system's line, whatever the keyboards further down
      // are doing.
      final x = -_bracketLane(members);
      elements
        ..add(
          LineElement(
            from: Offset(x, topY),
            to: Offset(x, bottomY),
            thickness: style.lines.bracketThickness,
            role: ElementRole.bracket,
            source: group,
          ),
        )
        // A bracket is a stroke with a hook curling out at each end. Drawn as
        // a bare line it reads as a barline that has escaped the staff, which
        // is what it looked like.
        ..add(
          GlyphElement(
            glyph: NotationGlyphs.bracketTop,
            origin: Offset(x - style.lines.bracketThickness / 2, topY),
            role: ElementRole.bracket,
            size: metrics.glyphSize(NotationGlyphs.bracketTop),
            aboveOrigin: metrics.glyphTop(NotationGlyphs.bracketTop),
            source: group,
          ),
        )
        ..add(
          GlyphElement(
            glyph: NotationGlyphs.bracketBottom,
            origin: Offset(x - style.lines.bracketThickness / 2, bottomY),
            role: ElementRole.bracket,
            size: metrics.glyphSize(NotationGlyphs.bracketBottom),
            aboveOrigin: metrics.glyphTop(NotationGlyphs.bracketBottom),
            source: group,
          ),
        );
    }

    // The line down the left of every system, joining everything in it. It is
    // what tells the eye where one line of music begins and how far down it
    // reaches — without it a system of many parts reads as loose staves.
    if (staves.length > 1) {
      elements.add(
        LineElement(
          from: Offset(0, localY(staves.first, 0)),
          to: Offset(0, localY(staves.last, staves.last.geometry.height)),
          thickness: style.lines.thinBarlineThickness,
          role: ElementRole.barline,
          source: staves.first.part,
        ),
      );
    }

    // Measure numbers ride above the top staff of the system, over the barline
    // that opens the measure rather than over its first note, which is where a
    // reader looks for them.
    final numbering = style.measureNumbers;
    if (numbering != MeasureNumbering.none) {
      final fontSize = style.partNameFontSize * 0.8;
      final topStaff = staves.first;
      for (var i = 0; i < slots.length; i++) {
        final slot = slots[i];
        if (!numbering.showsAt(index: slot.index, startsSystem: i == 0)) {
          continue;
        }
        final label = _measureLabel(score, slot.index);
        if (label.isEmpty) continue;
        final size = metrics.measureText(label, fontSize: fontSize);
        // Just above the staff at the barline, not above the tallest thing in
        // the system: a number floating over the top of a run of high notes
        // has come loose from the bar it counts. It still steps over whatever
        // is directly beneath it.
        // The bracket's hook curls rightwards over the corner of the staff,
        // which is where the first number of a system would otherwise be
        // written.
        // Centred on the line, except at the head of a system where there is
        // no measure before it to borrow room from and the bracket's hook
        // curls over the corner.
        var left = i == 0 ? slot.left : slot.left - size.width / 2;
        if (i == 0) {
          for (final element in elements) {
            if (element.role != ElementRole.bracket) continue;
            if (element.bounds.right <= slot.left) continue;
            left = math.max(left, element.bounds.right + 0.3);
          }
        }

        // One height for the whole score, just above the staff, and standing
        // on the measure line rather than beside it. A barline has air on both
        // sides of it by construction — the measure before ends a barlineGap
        // short of it, the measure after starts a padding past it — so a
        // number centred there is in white space and needs nothing moved for
        // it. Lifting it instead put the number of one bar higher than the
        // next for no reason a reader can see.
        //
        // The head of a system is the exception: there is no measure before to
        // borrow room from, and a clef stands where the number would. It goes
        // above the clef there, which is one fixed height too, because every
        // system starts with the same clef.
        var above = -0.7;
        for (final element in topStaff.elements) {
          // A volta bracket runs over the staff at exactly the height a number
          // is written at, so the number goes above the bracket instead. At
          // the head of a system there is a clef in the way as well.
          final inTheWay =
              element.role == ElementRole.ending ||
              (i == 0 &&
                  (element.role == ElementRole.clef ||
                      element.role == ElementRole.keySignature ||
                      element.role == ElementRole.timeSignature));
          if (!inTheWay) continue;
          final box = element.bounds;
          if (box.right < left - 0.2 || box.left > left + size.width + 0.2) {
            continue;
          }
          above = math.min(above, box.top - 0.4);
        }
        final top = localY(topStaff, above);
        elements.add(
          TextElement(
            text: label,
            origin: Offset(left, top),
            fontSize: fontSize,
            role: ElementRole.measureNumber,
            measuredWidth: size.width,
          ),
        );
      }
    }

    // Names go outside the braces and brackets, since they are right-aligned
    // to this edge and would otherwise be written across them.
    final hasBracket = score.partGroups.any(
      (group) =>
          group.symbol != GroupSymbol.none && group.symbol != GroupSymbol.brace,
    );
    final nameLane = math.max(
      hasBracket
          ? _bracketLane(staves) + style.lines.bracketThickness / 2 + 0.4
          : -_braceEdge + _widestBrace(staves) + 0.4,
      1.5,
    );

    // The first system names each part in full; later systems use the short
    // name, which is what the abbreviation is for.
    for (var i = 0; i < staves.length; i++) {
      final staff = staves[i];
      if (staff.staffNumber != 1) continue;
      final name = isFirstSystem
          ? (staff.part.printName ? staff.part.name : '')
          : (staff.part.printAbbreviation ? staff.part.abbreviation ?? '' : '');
      if (name.isEmpty) continue;
      final fontSize = isFirstSystem
          ? style.partNameFontSize
          : style.partNameFontSize * 0.9;
      // "Clarinet in B♭" is what the instrument is called, and the flat is not
      // a letter: it is taken from the music font and the name is laid out as
      // a row of pieces.
      final pieces = metrics.splitSigns(
        name,
        fontSize: fontSize,
        role: ElementRole.partName,
      );
      var nameWidth = 0.0;
      for (final piece in pieces) {
        nameWidth += piece.width;
      }
      // A name belongs to the instrument, not to the first of its staves, so
      // for a part on more than one it is centred on the brace rather than
      // left hanging beside the right hand of a piano.
      var lastOfPart = i;
      while (lastOfPart + 1 < staves.length &&
          identical(staves[lastOfPart + 1].part, staff.part)) {
        lastOfPart++;
      }
      final centre =
          (localY(staff, 0) +
              localY(staves[lastOfPart], staves[lastOfPart].geometry.height)) /
          2;
      final baseline = centre + style.partNameFontSize * 0.3;
      var penX = -nameLane - nameWidth;
      for (final piece in pieces) {
        final glyph = piece.glyph;
        elements.add(
          glyph == null
              ? TextElement(
                  text: piece.text!,
                  origin: Offset(penX, baseline),
                  fontSize: fontSize,
                  role: ElementRole.partName,
                  measuredWidth: piece.width,
                  source: staff.part,
                )
              : GlyphElement(
                  glyph: glyph,
                  origin: Offset(penX, baseline - fontSize * 0.28),
                  role: ElementRole.partName,
                  scale: piece.scale,
                  size: metrics.glyphSize(glyph) * piece.scale,
                  aboveOrigin: metrics.glyphTop(glyph) * piece.scale,
                  source: staff.part,
                ),
        );
        penX += piece.width;
      }
    }

    return elements;
  }

  // ---------------------------------------------------------------- header

  List<LayoutElement> _buildHeader(Score score, double width) {
    final elements = <LayoutElement>[];
    var y = style.pageMargin + style.titleFontSize;

    final title = score.metadata.title;
    if (title != null && title.isNotEmpty) {
      final size = metrics.measureText(
        title,
        fontSize: style.titleFontSize,
        bold: true,
      );
      elements.add(
        TextElement(
          text: title,
          origin: Offset(width / 2, y),
          fontSize: style.titleFontSize,
          alignment: TextAlignment.center,
          bold: true,
          role: ElementRole.text,
          measuredWidth: size.width,
          source: score.metadata,
        ),
      );
      y += style.titleFontSize * 1.1;
    }

    final composer = score.metadata.composer;
    if (composer != null && composer.isNotEmpty) {
      final size = metrics.measureText(
        composer,
        fontSize: style.subtitleFontSize,
        italic: true,
      );
      elements.add(
        TextElement(
          text: composer,
          origin: Offset(width - style.pageMargin, y),
          fontSize: style.subtitleFontSize,
          alignment: TextAlignment.right,
          italic: true,
          role: ElementRole.text,
          measuredWidth: size.width,
          source: score.metadata,
        ),
      );
      y += style.subtitleFontSize * 1.2;
    }

    return elements;
  }

  double _extentOf(List<LayoutElement> elements) {
    var bottom = 0.0;
    for (final element in elements) {
      bottom = math.max(bottom, element.bounds.bottom);
    }
    return bottom == 0 ? 0 : bottom - style.pageMargin + style.systemDistance;
  }

  /// The indent needed for the widest part name or abbreviation printed at the
  /// left of a system.
  double _partNameWidth(Score score) {
    var widest = 0.0;
    for (final part in score.parts) {
      double widthOf(String text, double fontSize) {
        var total = 0.0;
        for (final piece in metrics.splitSigns(
          text,
          fontSize: fontSize,
          role: ElementRole.partName,
        )) {
          total += piece.width;
        }
        return total;
      }

      if (part.printName && part.name.isNotEmpty) {
        widest = math.max(widest, widthOf(part.name, style.partNameFontSize));
      }
      final abbreviation = part.abbreviation;
      if (part.printAbbreviation &&
          abbreviation != null &&
          abbreviation.isNotEmpty) {
        widest = math.max(
          widest,
          widthOf(abbreviation, style.partNameFontSize * 0.9),
        );
      }
    }
    // Even a score with no names printed has a brace or a bracket hanging off
    // the left of every system, and clipping those at the page margin is what
    // it looks like when the indent only counts the words.
    var furniture = 0.0;
    for (final part in score.parts) {
      if (part.staffCount > 1) {
        furniture = math.max(furniture, _braceWidth(_staffSpan(part)));
      }
    }
    var lane = -_braceEdge + furniture;
    if (score.partGroups.any((group) => group.symbol != GroupSymbol.none)) {
      lane = -_bracketRightEdge(furniture) + style.lines.bracketThickness;
    }
    return (widest == 0 ? 0 : widest + 1) + math.max(lane + 0.4, 1.5);
  }

  /// What a measure is called, which is what the source said rather than a
  /// count of our own: a pickup is measure 0 or unnumbered, and inserted
  /// measures are 12a and 12b.
  String _measureLabel(Score score, int index) {
    for (final part in score.parts) {
      if (index >= part.measures.length) continue;
      final measure = part.measures[index];
      if (measure.implicit) return '';
      return measure.number;
    }
    return '';
  }

  /// A rough vertical span for one part's staves, for measuring its brace
  /// before any system has been laid out.
  double _staffSpan(Part part) =>
      (part.staffCount - 1) * style.staffDistance +
      part.staffCount * (style.staffLineCount - 1);
}

/// How full the last system has to be before it is stretched to the margin.
const double _lastSystemFillThreshold = 0.6;

class _SystemRange {
  _SystemRange({
    required this.start,
    required this.end,
    required this.furniture,
  });

  final int start;
  final int end;

  /// Width of the clef, key and time signature printed at the system's start.
  final double furniture;
}

class _BuiltStaff {
  _BuiltStaff({
    required this.partIndex,
    required this.layout,
  });

  final int partIndex;
  final StaffLayout layout;
}
