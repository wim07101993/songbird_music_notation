import 'dart:math' as math;

import 'package:songbird_music_notation/src/layout/barline_metrics.dart';
import 'package:songbird_music_notation/src/layout/chord_shape.dart';
import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/font_metrics.dart';
import 'package:songbird_music_notation/src/layout/glyphs.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_score/songbird_score.dart';

/// One vertical slice of a measure: everything that starts at the same moment,
/// across every part.
///
/// Parts have to line up — a note on beat three of the flute part must sit
/// directly above beat three of the cello — so spacing is decided for the score
/// as a whole and then used by every part.
class SpacingColumn {
  SpacingColumn(
    this.position,
  );

  /// When this column happens, as an offset into the measure.
  final Fraction position;

  /// How far the widest thing here reaches left of the column's x, mostly
  /// accidentals.
  double leftExtent = 0;

  /// How far the widest thing reaches right, mostly the notehead and its dots.
  double rightExtent = 0;

  /// Distance to the next column, filled in by [MeasureSpacing].
  double advance = 0;

  /// x of this column relative to the start of the measure's music.
  double x = 0;

  /// The shortest duration starting here, which is what the space to the next
  /// column is based on.
  Fraction shortestDuration = Fraction.zero;
}

/// The horizontal plan for one measure across the whole score.
class MeasureSpacing {
  MeasureSpacing({
    required this.index,
    required this.columns,
    required this.leadingWidth,
    required this.headExtent,
    required this.trailingWidth,
    required this.barlineReserve,
    required this.naturalWidth,
    required this.hasClefChange,
    required this.hasKeyChange,
    required this.hasTimeChange,
  });

  final int index;

  /// The columns, in time order.
  final List<SpacingColumn> columns;

  /// Space before the first note for clefs, keys and time signatures printed
  /// inside this measure.
  final double leadingWidth;

  /// How far the first thing in the measure reaches left of the note it hangs
  /// from — an accidental, or a second in a chord drawn across the stem.
  ///
  /// Part of [leadingWidth] already. It is kept separately because a system
  /// reprints its clef and key in front of the measure, and that reservation
  /// has to hold this as well or the first note is drawn back over them.
  final double headExtent;

  /// Space after the last note, up to and including the barline.
  final double trailingWidth;

  /// The tail end of [trailingWidth]: the gap before the barline plus the
  /// barline itself, with nothing of the last note in it.
  ///
  /// It is what separates the right edge of the measure from the right edge of
  /// its music, so anything that wants to sit inside the music — a centred
  /// whole-measure rest — measures back from here.
  final double barlineReserve;

  /// The width the measure wants when nothing is stretched.
  final double naturalWidth;

  final bool hasClefChange;
  final bool hasKeyChange;
  final bool hasTimeChange;

  /// How much of [naturalWidth] can be stretched when a system is justified.
  ///
  /// Furniture keeps its size; only the space between notes grows, which is
  /// why a measure holding one whole note stretches more readily than one
  /// packed with sixteenths.
  double get flexibleWidth =>
      math.max(0, naturalWidth - leadingWidth - trailingWidth);
}

/// Works out how wide each measure wants to be, and where within it each
/// moment falls.
///
/// The rule is the one engravers use: space grows with duration, but far more
/// slowly than duration does. A half note gets more room than a quarter, not
/// twice as much, because the eye reads rhythm from relative spacing and a
/// literal mapping leaves whole notes marooned in white space.
class SpacingEngine {
  SpacingEngine({
    required this.style,
    required this.metrics,
  });

  final EngravingStyle style;
  final NotationMetrics metrics;

  /// Plans measure [index] across every part of [score].
  MeasureSpacing planMeasure(
    Score score,
    int index,
    List<MusicalContext> contexts,
  ) {
    final columns = <Fraction, SpacingColumn>{};
    // Grace notes are laid backwards from the beat one after another, so the
    // room a moment needs for them is what they add up to and not the widest
    // of them. Kept per staff of a part, since that is how they are laid out.
    final graceWidth = <(int, int, Fraction), double>{};
    var hasClefChange = false;
    var hasKeyChange = false;
    var hasTimeChange = false;
    var furniture = 0.0;
    var rightBarline = 0.0;
    var leftBarline = 0.0;

    for (var partIndex = 0; partIndex < score.parts.length; partIndex++) {
      final part = score.parts[partIndex];
      if (index >= part.measures.length) continue;
      final measure = part.measures[index];
      final context = contexts[partIndex];

      rightBarline = math.max(
        rightBarline,
        BarlineMetrics.of(measure.rightBarline, style, metrics).width,
      );
      // An opening repeat is the barline for its own boundary, so it stands on
      // the measure line and takes only its own width. It is only held off
      // when the measure before closes with a mark of its own, and then only
      // by a hair, to keep the two from touching.
      if (measure.leftBarline != null &&
          !BarlineMetrics.yieldsToPrevious(part, index)) {
        leftBarline = math.max(
          leftBarline,
          BarlineMetrics.of(measure.leftBarline, style, metrics).width +
              BarlineMetrics.separationBefore(part, index, style),
        );
      }

      final opening = measure.attributesOrNull;
      if (opening != null && index > 0) {
        var width = 0.0;
        if (opening.clefs.isNotEmpty) {
          hasClefChange = true;
          width +=
              (metrics.advanceWidth(
                    NotationGlyphs.clef(opening.clefs.values.first),
                  ) +
                  style.clefGap) *
              style.clefChangeScale;
        }
        if (opening.keys.isNotEmpty) {
          hasKeyChange = true;
          width += keySignatureWidth(opening.keys.values.first);
        }
        if (opening.time != null && opening.printTime) {
          hasTimeChange = true;
          width += timeSignatureWidth(opening.time!) + style.timeGap;
        }
        furniture = math.max(furniture, width);
      }

      for (final event in measure.timedEvents) {
        // A note the file says to print neither ink nor space for takes no
        // column of its own: it is the realisation of something that is drawn
        // another way, and spacing it out would stretch the measure to hold
        // music nobody can see.
        if (!_takesSpace(event)) continue;
        final column = columns.putIfAbsent(
          event.position,
          () => SpacingColumn(event.position),
        );
        final extents = _extentsOf(event, context, measure);
        if (event is Chord && event.isGrace) {
          final key = (partIndex, event.staff, event.position);
          graceWidth[key] = (graceWidth[key] ?? 0) + extents.left;
        } else {
          column.leftExtent = math.max(column.leftExtent, extents.left);
        }
        column.rightExtent = math.max(column.rightExtent, extents.right);
        if (column.shortestDuration.isZero ||
            (event.duration.isPositive &&
                event.duration < column.shortestDuration)) {
          column.shortestDuration = event.duration;
        }
      }
    }

    for (final entry in graceWidth.entries) {
      final column = columns[entry.key.$3];
      if (column == null) continue;
      column.leftExtent = math.max(column.leftExtent, entry.value);
    }

    // A measure that prints a clef or a key at its head gives that the closer
    // gap; one that starts straight into the music gives a note's worth of air.
    final leading =
        leftBarline +
        (furniture > 0
            ? style.measureFurnitureGap + furniture
            : style.measureLeftPadding);
    // A plain barline is a hairline, a closing repeat is a stack of strokes
    // and dots; the measure has to end far enough before the barline to hold
    // whichever it is, or the last note's flag lands on top of it.
    final trailing =
        style.barlineGap +
        math.max(rightBarline, style.lines.thinBarlineThickness);

    final ordered = columns.values.toList()
      ..sort((a, b) => a.position.compareTo(b.position));

    // A measure with nothing in it still needs room to be seen.
    if (ordered.isEmpty) {
      final width = leading + style.spacingWidth + trailing;
      return MeasureSpacing(
        index: index,
        columns: const [],
        leadingWidth: leading,
        headExtent: 0,
        trailingWidth: trailing,
        barlineReserve: trailing,
        naturalWidth: width,
        hasClefChange: hasClefChange,
        hasKeyChange: hasKeyChange,
        hasTimeChange: hasTimeChange,
      );
    }

    var x = 0.0;
    for (var i = 0; i < ordered.length; i++) {
      final column = ordered[i];
      column.x = x;
      if (i == ordered.length - 1) break;
      final next = ordered[i + 1];
      final duration = next.position - column.position;
      final ideal = durationSpace(duration);
      final minimum =
          column.rightExtent + next.leftExtent + style.minimumNoteSpacing * 0.4;
      column.advance = math.max(ideal, minimum);
      x += column.advance;
    }

    // The first thing in the measure may reach left of the note it belongs to
    // — an accidental does, and a microtone's is wider than a sharp — and that
    // has to be room the measure asked for. Left out, the accidental was drawn
    // back over the time signature in front of it.
    final head = leading + ordered.first.leftExtent;

    final last = ordered.last;
    final totalTrailing = last.rightExtent + trailing;
    return MeasureSpacing(
      index: index,
      columns: ordered,
      leadingWidth: head,
      headExtent: ordered.first.leftExtent,
      trailingWidth: totalTrailing,
      barlineReserve: trailing,
      naturalWidth: head + last.x + totalTrailing,
      hasClefChange: hasClefChange,
      hasKeyChange: hasKeyChange,
      hasTimeChange: hasTimeChange,
    );
  }

  /// The ideal space for a note lasting [duration], in staff spaces.
  double durationSpace(Fraction duration) {
    if (!duration.isPositive) return style.minimumNoteSpacing;
    final quarters = duration.toDouble() * 4;
    final scaled =
        style.spacingWidth * math.pow(quarters, style.spacingExponent);
    return math.max(style.minimumNoteSpacing, scaled);
  }

  /// How wide a key signature is, including the gap after it.
  double keySignatureWidth(KeySignature key) {
    final count = key.alteredSteps.length;
    if (count == 0) return 0;
    final glyph = NotationGlyphs.keyAccidental(sharp: key.fifths > 0);
    return count * (metrics.advanceWidth(glyph) + style.keyGap) + style.clefGap;
  }

  /// How wide a time signature is, not counting the gap after it.
  double timeSignatureWidth(TimeSignature time) {
    if (time.symbol == TimeSymbol.common || time.symbol == TimeSymbol.cut) {
      return metrics.advanceWidth(NotationGlyphs.commonTime);
    }
    final top = '${time.beats}';
    final bottom = '${time.beatType}';
    final digits = math.max(top.length, bottom.length);
    return digits * metrics.advanceWidth(NotationGlyphs.timeSignatureDigit(0));
  }

  /// How far to the right of a chord's origin its flag reaches, or zero for a
  /// chord that carries no flag.
  double _flagExtent(Chord chord, MusicalContext context) {
    if (chord.isBeamed || chord.rhythm.type.flagCount == 0) return 0;
    final stemUp = _stemsUp(chord, context.clefFor(chord.staff));
    final flag = NotationGlyphs.flag(chord.rhythm.type, stemUp: stemUp);
    if (flag == null) return 0;
    final notehead = NotationGlyphs.notehead(chord.rhythm.type);
    final stemX = stemUp
        ? metrics.stemUpAnchor(notehead).dx
        : metrics.stemDownAnchor(notehead).dx;
    return stemX + metrics.glyphRight(flag);
  }

  /// Which way a chord's stem points, agreeing with what the staff builder
  /// will decide.
  bool _stemsUp(Chord chord, Clef clef) {
    if (chord.stem == StemDirection.up) return true;
    if (chord.stem == StemDirection.down) return false;
    var extreme = 0;
    var distance = -1;
    for (final note in chord.notes) {
      final pitch = note.displayPitch;
      if (pitch == null) continue;
      final position = clef.staffPositionOf(pitch);
      final away = (position - Clef.middleLinePosition).abs();
      if (away > distance) {
        distance = away;
        extreme = position;
      }
    }
    return extreme <= Clef.middleLinePosition;
  }

  /// How far an event reaches to either side of its column.
  /// Whether [chord] moves aside for another voice sounding with it.
  bool _stepsAside(Chord chord, Measure measure, MusicalContext context) {
    final clef = context.clefFor(chord.staff);
    final lines = context.detailsFor(chord.staff).staffLines;
    for (final event in measure.eventsOnStaff(chord.staff)) {
      if (event is! Chord || identical(event, chord)) continue;
      if (event.voice == chord.voice) continue;
      if (event.position != chord.position) continue;
      if (event.isGrace != chord.isGrace) continue;
      if (!event.isPrinted) continue;
      if (ChordShape.stepsAsideFrom(chord, event, clef, lineCount: lines)) {
        return true;
      }
    }
    return false;
  }

  /// Whether [event] asks for room on the page.
  static bool _takesSpace(MusicalEvent event) => switch (event) {
    final Chord chord => chord.takesSpace,
    final Rest rest => rest.printObject || rest.printSpacing,
    _ => true,
  };

  _Extents _extentsOf(
    MusicalEvent event,
    MusicalContext context,
    Measure measure,
  ) {
    switch (event) {
      case final Chord chord:
        final glyph = NotationGlyphs.notehead(
          chord.rhythm.type,
          shape: chord.notes.first.notehead,
          filled: chord.notes.first.filledNotehead,
        );
        final scale = chord.isGrace
            ? style.graceNoteScale
            : chord.cue
            ? style.cueNoteScale
            : 1.0;
        // A grace note is drawn before the beat rather than on it, so the
        // room it needs is to the left: counted as width on the beat it would
        // be drawn straight through the note it decorates.
        if (chord.isGrace) {
          return _Extents(
            metrics.advanceWidth(glyph) * scale +
                style.dotGap +
                style.ledgerLineExtension,
            0,
          );
        }

        var right = metrics.advanceWidth(glyph) * scale;
        if (chord.rhythm.dots > 0) {
          right +=
              style.dotGap +
              chord.rhythm.dots *
                  (metrics.advanceWidth(NotationGlyphs.augmentationDot) +
                      style.dotSpacing);
        }

        // A flag hangs off the side of the stem and reaches further than the
        // notehead does. Leaving it out is what lets an eighth note's flag
        // fall across the barline after it.
        right = math.max(right, _flagExtent(chord, context) * scale);

        var left = 0.0;

        // A syllable is usually wider than the note above it, and two notes
        // spaced only for their noteheads would run their lyrics together.
        // Widening the column to hold the text is what keeps a vocal line
        // readable.
        for (final lyric in chord.lyrics) {
          if (lyric.text.isEmpty) continue;
          final width = metrics
              .measureText(
                lyric.text,
                fontSize: style.lyricFontSize,
                role: ElementRole.lyric,
              )
              .width;
          final overhang = (width - right) / 2;
          if (overhang > 0) {
            left = math.max(left, overhang);
            right += overhang;
          }
        }

        // A second in a chord is drawn across the stem, a whole notehead to
        // one side of where the chord itself stands. Left out of the
        // reservation it reaches into the measure's own leading, and at the
        // head of a system that is the clef.
        final shape = ChordShape.of(
          chord,
          context.clefFor(chord.staff),
          lineCount: context.detailsFor(chord.staff).staffLines,
        );
        final headWidth = metrics.advanceWidth(glyph) * scale;
        // A second drawn across the stem puts a notehead a whole head left of
        // where the chord stands, and the accidentals go left of that again.
        final reach = shape.reachesLeft ? headWidth : 0.0;
        left = math.max(left, reach);
        if (shape.reachesRight) right = math.max(right, headWidth * 2);

        // And a voice that steps out of another's way needs the room it steps
        // into, or it is drawn back over the note before it.
        if (_stepsAside(chord, measure, context)) left += headWidth;

        // A chord to be spread carries a wavy line down its left side.
        if (chord.arpeggiate || chord.nonArpeggiate) {
          left +=
              style.arpeggioGap +
              (chord.nonArpeggiate
                  ? style.arpeggioHook
                  : metrics.glyphSize(NotationGlyphs.arpeggiate).width);
        }

        final columns = AccidentalColumns.forChord(
          chord,
          context.clefFor(chord.staff),
        );
        if (columns.columnCount > 0) {
          for (final note in chord.notes) {
            final accidental = note.accidental;
            final column = columns.columnOf[note];
            if (accidental == null || column == null) continue;
            final width = metrics.advanceWidth(
              NotationGlyphs.accidental(accidental.type),
            );
            left = math.max(
              left,
              reach + (column + 1) * (width + style.accidentalGap) * scale,
            );
          }
        }
        return _Extents(left, right);
      case final Rest rest:
        final glyph = NotationGlyphs.rest(
          rest.isMeasureRest ? NoteType.whole : rest.rhythm.type,
        );
        var right = metrics.advanceWidth(glyph);
        if (!rest.isMeasureRest && rest.rhythm.dots > 0) {
          right +=
              style.dotGap +
              rest.rhythm.dots *
                  (metrics.advanceWidth(NotationGlyphs.augmentationDot) +
                      style.dotSpacing);
        }
        return _Extents(0, right);
      default:
        return const _Extents(0, 0);
    }
  }
}

class _Extents {
  const _Extents(
    this.left,
    this.right,
  );

  final double left;
  final double right;
}
