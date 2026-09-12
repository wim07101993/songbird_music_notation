import 'dart:math' as math;

import 'package:flutter/painting.dart';
import 'package:songbird_music_notation/src/layout/barline_metrics.dart';
import 'package:songbird_music_notation/src/layout/chord_shape.dart';
import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/font_metrics.dart';
import 'package:songbird_music_notation/src/layout/glyphs.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_music_notation/src/layout/spacing.dart';
import 'package:songbird_music_notation/src/layout/staff_geometry.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// One measure of one part, with everything the builder needs about it.
class StaffMeasure {
  StaffMeasure({
    required this.measure,
    required this.slot,
    required this.context,
    required this.isSystemStart,
  });

  final Measure measure;
  final MeasureSlot slot;

  /// The clefs, keys and time signature in force at the start of the measure.
  final MusicalContext context;

  /// Whether this measure begins a system, and so reprints the clef and key.
  final bool isSystemStart;
}

/// The spanners of one part, indexed by the events they hang from.
///
/// A staff draws every slur, tie and tuplet with an endpoint inside its own
/// system. Finding those by walking the part's whole list costs nothing for a
/// song and a great deal for a symphony: the list grows with the length of the
/// score and is walked once per staff per system, so the work grows with the
/// square of it. Built once per part, this turns that walk into a lookup per
/// note actually on the staff.
class SpannerIndex {
  SpannerIndex(
    Part part,
  ) {
    for (var i = 0; i < part.spanners.length; i++) {
      final spanner = part.spanners[i];
      _order[spanner] = i;
      (_byEvent[spanner.start] ??= []).add(spanner);
      (_byEvent[spanner.end] ??= []).add(spanner);
    }
  }

  final Map<MusicalEvent, List<Spanner>> _byEvent = {};
  final Map<Spanner, int> _order = {};

  /// Every spanner with an endpoint among [events], in the order the part
  /// lists them, so that what is drawn on top of what does not depend on which
  /// note happened to be reached first.
  List<Spanner> touching(Iterable<MusicalEvent> events) {
    final found = <int, Spanner>{};
    for (final event in events) {
      final here = _byEvent[event];
      if (here == null) continue;
      for (final spanner in here) {
        found[_order[spanner]!] = spanner;
      }
    }
    final order = found.keys.toList()..sort();
    return [for (final key in order) found[key]!];
  }
}

/// Builds the drawables for one staff of one part across one system.
///
/// Everything it produces is in system x and staff-local y, so a staff can be
/// laid out before it is known where on the page it will sit.
class StaffContentBuilder {
  StaffContentBuilder({
    required this.part,
    required this.staffNumber,
    required this.style,
    required this.metrics,
    required this.spacing,
    required this.systemWidth,
    required this.lineCount,
    required this.spanners,
    this.showsEndings = false,
  }) : _geometry = StaffGeometry(
         top: 0,
         lineCount: lineCount,
         part: part,
         staffNumber: staffNumber,
       );

  final Part part;
  final int staffNumber;
  final EngravingStyle style;
  final NotationMetrics metrics;
  final SpacingEngine spacing;
  final double systemWidth;
  final int lineCount;

  /// The part's slurs, ties and tuplets, indexed so this staff can find the
  /// ones it has to draw without reading the whole score's worth.
  final SpannerIndex spanners;

  /// Whether volta brackets are drawn over this staff.
  ///
  /// One staff of the score carries them — the top one — because a repeat
  /// ending is an instruction to everybody playing. Drawn over every part they
  /// would be a row of brackets down the page rather than a direction.
  final bool showsEndings;

  final StaffGeometry _geometry;
  final List<LayoutElement> _elements = [];

  /// Where each chord's noteheads ended up, so that ties and slurs drawn
  /// afterwards know what to connect.
  final Map<Chord, _ChordPlacement> _placements = {};

  /// Hairpins wait until the whole system is built, because one usually starts
  /// in a measure and stops in a later one.
  final List<_PendingWedge> _pendingWedges = [];

  /// The articulations, ornaments and fermatas of each chord, held back until
  /// the beams are drawn: a beamed note's stem is only as long as its beam
  /// turns out to need, and a mark placed clear of the provisional length is
  /// left inside the beam.
  final List<({Chord chord, _ChordPlacement placement, bool shared})>
  _pendingMarks = [];

  /// Lyrics and directions are held back until the notes are placed.
  ///
  /// A verse of lyrics runs along one baseline for the whole system, and a
  /// dynamic sits at one height, rather than each following its own note up
  /// and down. Finding those baselines means knowing how far the notes reach
  /// first, so these are collected and drawn at the end.
  final List<_PendingLyric> _pendingLyrics = [];
  final List<_PendingDirection> _pendingDirections = [];

  /// Chord symbols, which run along one line above the staff.
  final List<_PendingChord> _pendingChords = [];

  /// Where the music of each measure begins, past the barline and whatever
  /// clef or key is printed at its head. A volta bracket starting a system
  /// begins there rather than on the system's left edge, where it would be
  /// drawn over the clef.
  final Map<int, double> _musicStart = {};

  double _contentTop = 0;
  double _contentBottom = 0;

  /// The measures of this system, kept so that a spanner reaching to another
  /// staff of the same instrument can still find where its other end sits.
  List<StaffMeasure> _entries = const [];

  /// Builds the staff and returns it with its content extents measured.
  StaffLayout build(List<StaffMeasure> measures) {
    _entries = measures;
    _drawStaffLines();

    for (final entry in measures) {
      _drawMeasure(entry);
    }
    _drawBeams(measures);
    _drawOrphanStems();
    _drawMarks();
    _drawSpanners();
    _drawDeferred();
    _drawEndings(measures);

    // Everything is drawn before the extents are known, so they are measured
    // from the result rather than predicted.
    for (final element in _elements) {
      if (element.role == ElementRole.staffLine) continue;
      final bounds = element.bounds;
      _contentTop = math.max(_contentTop, -bounds.top);
      _contentBottom = math.max(
        _contentBottom,
        bounds.bottom - _geometry.height,
      );
    }

    return StaffLayout(
      geometry: _geometry,
      elements: _elements,
      contentTop: math.max(_contentTop, 1),
      contentBottom: math.max(_contentBottom, 1),
    );
  }

  void _drawStaffLines() {
    for (var line = 1; line <= lineCount; line++) {
      _elements.add(
        LineElement(
          from: Offset(0, _geometry.lineY(line)),
          to: Offset(systemWidth, _geometry.lineY(line)),
          thickness: style.lines.staffLineThickness,
          role: ElementRole.staffLine,
        ),
      );
    }
  }

  // ---------------------------------------------------------------- measure

  void _drawMeasure(StaffMeasure entry) {
    final context = entry.context;
    final clef = context.clefFor(staffNumber);

    // Everything printed at the head of a measure starts after whatever the
    // measure's own left barline takes, and then after the air. A clef or a
    // key gets the closer gap: given a note's worth of air it reads as though
    // it were floating between the two measures rather than opening this one.
    final opens = entry.isSystemStart || entry.measure.attributesOrNull != null;
    var x =
        entry.slot.left +
        _leftBarlineExtent(entry) +
        (opens ? style.measureFurnitureGap : style.measureLeftPadding);

    if (entry.isSystemStart) {
      x = _drawClef(clef, x);
      x = _drawKeySignature(context.keyFor(staffNumber), clef, x);
      // A file may state a metre without showing it: an excerpt taken from the
      // middle of a movement carries its time signature without announcing it
      // again, and the bar lengths and beaming still follow from it.
      final showsTime =
          context.printTime &&
          (entry.slot.index == 0 ||
              entry.measure.attributesOrNull?.time != null);
      if (showsTime) x = _drawTimeSignature(context.time, x);
    } else {
      final opening = entry.measure.attributesOrNull;
      if (opening != null) {
        final newClef = opening.clefs[staffNumber] ?? opening.clefs[allStaves];
        if (newClef != null) {
          x = _drawClef(newClef, x, scale: style.clefChangeScale);
        }
        final newKey = opening.keys[staffNumber] ?? opening.keys[allStaves];
        if (newKey != null) x = _drawKeySignature(newKey, clef, x);
        if (opening.time != null && opening.printTime) {
          x = _drawTimeSignature(opening.time!, x);
        }
      }
    }

    _musicStart[entry.slot.index] = x;

    // A grace note shares the position of the note it decorates, so the two
    // cannot be drawn at the same place: the run of them is set back from the
    // beat, and read left to right in the order it is written, so that the
    // last grace is the one nearest the note it leads into.
    final graceOffsets = <Chord, double>{};
    final graceTotal = <Fraction, double>{};
    for (final event in entry.measure.eventsOnStaff(staffNumber)) {
      if (event is! Chord || !event.isGrace) continue;
      graceTotal[event.position] =
          (graceTotal[event.position] ?? 0) + _graceWidth(event);
    }
    final graceCursor = <Fraction, double>{};
    for (final event in entry.measure.eventsOnStaff(staffNumber)) {
      if (event is! Chord || !event.isGrace) continue;
      final used = graceCursor[event.position] ?? 0.0;
      graceOffsets[event] = used - graceTotal[event.position]!;
      graceCursor[event.position] = used + _graceWidth(event);
    }

    for (final event in entry.measure.eventsOnStaff(staffNumber)) {
      final eventX = entry.slot.xFor(event.position);
      switch (event) {
        case final Chord chord:
          _drawChord(chord, eventX + (graceOffsets[chord] ?? 0), entry);
        case final Rest rest:
          _drawRest(rest, eventX, entry);
        case Direction():
          break; // Placed against the part rather than this staff.
        case final Harmony harmony:
          // A chord symbol belongs to the instrument, so it goes above the
          // topmost staff of it and not above whichever one the file named.
          if (staffNumber == 1) {
            _pendingChords.add(_PendingChord(harmony, eventX));
          }
      }
    }

    _drawPartDirections(entry);
    _drawBarline(entry);
  }

  /// How big the glyphs printed among words are drawn.
  ///
  /// A segno, a coda or the note in a tempo mark is a mark on the page rather
  /// than a note on the staff: at full size they tower over the words beside
  /// them and read as something being played.
  static const double _markScale = 0.75;

  /// The stem direction a grace note takes.
  ///
  /// The one of the note it decorates, so that the little note and the note it
  /// leads into point the same way. A file writes grace notes stem-up as a
  /// matter of course; above a down-stemmed chord that leaves the stem and its
  /// flags towering over the note they belong to.
  StemDirection? _graceStem(Chord chord, StaffMeasure entry, Clef clef) {
    if (!chord.isGrace) return null;
    for (final event in entry.measure.eventsOnStaff(staffNumber)) {
      if (event is! Chord || event.isGrace) continue;
      if (event.position != chord.position || event.voice != chord.voice) {
        continue;
      }
      return ChordShape.of(event, clef, lineCount: lineCount).direction;
    }
    return null;
  }

  /// Whether [chord] moves aside for another voice sounding with it.
  bool _stepsAside(Chord chord, StaffMeasure entry, Clef clef) {
    if (!_sharesStaff(entry)) return false;
    for (final event in entry.measure.eventsOnStaff(staffNumber)) {
      if (event is! Chord || identical(event, chord)) continue;
      if (event.voice == chord.voice) continue;
      if (event.position != chord.position) continue;
      if (event.isGrace != chord.isGrace) continue;
      if (!event.isPrinted) continue;
      if (ChordShape.stepsAsideFrom(chord, event, clef, lineCount: lineCount)) {
        return true;
      }
    }
    return false;
  }

  /// Where a rest has already been drawn at each moment of each measure, so
  /// that the next voice's can step below it.
  final Map<(int, Fraction), List<({double top, double bottom})>> _restLanes =
      {};

  /// Whether more than one voice is written on this staff in [entry].
  ///
  /// Marks that would otherwise be written against a notehead have to go
  /// outside the pair of voices instead, or each voice's belong to the other.
  bool _sharesStaff(StaffMeasure entry) => _sharedStaff.putIfAbsent(
    entry.slot.index,
    () =>
        entry.measure
            .eventsOnStaff(staffNumber)
            .map((event) => event.voice)
            .toSet()
            .length >
        1,
  );

  final Map<int, bool> _sharedStaff = {};

  /// How much room one grace note takes, including the air after it.
  double _graceWidth(Chord chord) {
    final glyph = NotationGlyphs.notehead(chord.rhythm.type);
    // Including the reach of a ledger line: a grace note above the staff and
    // the chord it decorates both carry them, and set a notehead apart the two
    // sets run into one another and read as a single line.
    return metrics.advanceWidth(glyph) * style.graceNoteScale +
        style.dotGap +
        style.ledgerLineExtension;
  }

  /// How much room the measure's own opening barline takes at its left edge,
  /// including the air the spacing engine reserved in front of it.
  double _leftBarlineExtent(StaffMeasure entry) {
    final barline = entry.measure.leftBarline;
    if (barline == null ||
        BarlineMetrics.yieldsToPrevious(part, entry.slot.index)) {
      return 0;
    }
    return BarlineMetrics.of(barline, style, metrics).width +
        BarlineMetrics.separationBefore(part, entry.slot.index, style);
  }

  /// Draws the directions of the whole part that belong on this staff.
  ///
  /// A dynamic or a hairpin is the piano's, not its right hand's. Left on the
  /// staff its MusicXML happened to name, the crescendo under one hand ends up
  /// at a different height from the one under the other, and a tempo mark
  /// attached to the lower staff is printed in the middle of the instrument.
  /// So the whole part's directions are gathered onto one staff — the top one
  /// for anything placed above, the bottom one for anything below — where they
  /// stack outwards from the music on a single baseline.
  ///
  /// For a part on one staff this is simply that staff, and nothing changes.
  void _drawPartDirections(StaffMeasure entry) {
    final staffCount = math.max(1, entry.context.staffCount);
    final directions = entry.measure.events.whereType<Direction>().toList()
      ..sort((a, b) => a.position.compareTo(b.position));
    for (final direction in directions) {
      final home = direction.placement == Placement.above ? 1 : staffCount;
      if (home != staffNumber) continue;
      _drawDirection(direction, entry.slot.xFor(direction.position), entry);
    }
  }

  double _drawClef(Clef clef, double x, {double scale = 1}) {
    final glyph = NotationGlyphs.clef(clef);
    // A clef sits on the staff line it names: the G clef curls around line 2,
    // the F clef's dots straddle line 4. A tablature or percussion sign names
    // no line — it is a label for the whole staff — so it is centred on it,
    // whatever the file wrote in `<line>`.
    final spans = clef.sign == ClefSign.tab || clef.sign == ClefSign.percussion;
    final y = spans
        ? _geometry.middle +
              (metrics.glyphTop(glyph) + metrics.glyphBottom(glyph)) / 2 * scale
        : _geometry.lineY(clef.line);
    _elements.add(
      GlyphElement(
        glyph: glyph,
        origin: Offset(x, y),
        role: ElementRole.clef,
        scale: scale,
        size: metrics.glyphSize(glyph) * scale,
        aboveOrigin: metrics.glyphTop(glyph) * scale,
        source: clef,
      ),
    );
    // The gap after it shrinks with it: a clef drawn at three quarters does
    // not need a full-size clef's worth of air behind it, and every staff in
    // the score pays for the room this one takes.
    return x + (metrics.advanceWidth(glyph) + style.clefGap) * scale;
  }

  double _drawKeySignature(KeySignature key, Clef clef, double x) {
    final steps = key.alteredSteps;
    if (steps.isEmpty || !clef.isPitched) return x;
    final sharp = key.fifths > 0;
    final glyph = NotationGlyphs.keyAccidental(sharp: sharp);
    final width = metrics.advanceWidth(glyph);
    var cursor = x;
    for (final step in steps) {
      final position = _keySignaturePosition(step, clef, sharp: sharp);
      _elements.add(
        GlyphElement(
          glyph: glyph,
          origin: Offset(cursor, _geometry.yForStaffPosition(position)),
          role: ElementRole.keySignature,
          size: metrics.glyphSize(glyph),
          aboveOrigin: metrics.glyphTop(glyph),
          source: key,
        ),
      );
      cursor += width + style.keyGap;
    }
    return cursor + style.clefGap;
  }

  /// Where an accidental of a key signature is drawn.
  ///
  /// Signatures sit in a fixed band on the staff — sharps between the top line
  /// and the second space from the bottom, flats a little lower — rather than
  /// wherever the pitch happens to fall, and the band moves with the clef.
  int _keySignaturePosition(Step step, Clef clef, {required bool sharp}) {
    final octave = clef.pitchAtStaffPosition(sharp ? 8 : 7).octave;
    var position = clef.staffPositionOf(Pitch(step, octave));
    final upperLimit = sharp ? 8 : 7;
    final lowerLimit = sharp ? 2 : 1;
    while (position > upperLimit) {
      position -= 7;
    }
    while (position < lowerLimit) {
      position += 7;
    }
    return position;
  }

  double _drawTimeSignature(TimeSignature time, double x) {
    if (time.symbol == TimeSymbol.common || time.symbol == TimeSymbol.cut) {
      final glyph = time.symbol == TimeSymbol.common
          ? NotationGlyphs.commonTime
          : NotationGlyphs.cutTime;
      _elements.add(
        GlyphElement(
          glyph: glyph,
          origin: Offset(x, _geometry.middle),
          role: ElementRole.timeSignature,
          size: metrics.glyphSize(glyph),
          aboveOrigin: metrics.glyphTop(glyph),
          source: time,
        ),
      );
      return x + metrics.advanceWidth(glyph) + style.timeGap;
    }

    final top = '${time.beats}';
    final bottom = '${time.beatType}';
    final digitWidth = metrics.advanceWidth(
      NotationGlyphs.timeSignatureDigit(0),
    );
    final width = math.max(top.length, bottom.length) * digitWidth;

    void row(String digits, double y) {
      final rowWidth = digits.length * digitWidth;
      var cursor = x + (width - rowWidth) / 2;
      for (final character in digits.split('')) {
        final digit = int.tryParse(character);
        if (digit == null) continue;
        final glyph = NotationGlyphs.timeSignatureDigit(digit);
        _elements.add(
          GlyphElement(
            glyph: glyph,
            origin: Offset(cursor, y),
            role: ElementRole.timeSignature,
            size: metrics.glyphSize(glyph),
            aboveOrigin: metrics.glyphTop(glyph),
            source: time,
          ),
        );
        cursor += digitWidth;
      }
    }

    // The numbers are centred on the second and fourth lines of a five-line
    // staff, which is what puts them symmetrically about the middle.
    row(top, _geometry.yForStaffPosition(lineCount + 1));
    row(bottom, _geometry.yForStaffPosition(lineCount - 3));
    return x + width + style.timeGap;
  }

  void _drawBarline(StaffMeasure entry) {
    if (entry.measure.leftBarline != null &&
        !BarlineMetrics.yieldsToPrevious(part, entry.slot.index)) {
      _drawBarlineAt(
        entry.measure.leftBarline,
        entry.measure,
        // On the measure line itself. An opening repeat *is* the barline
        // between the two measures; standing it off from the line leaves it
        // hanging in the gap with nothing to divide.
        left:
            entry.slot.left +
            BarlineMetrics.separationBefore(part, entry.slot.index, style),
      );
    }

    final barline = entry.measure.rightBarline;
    if (BarlineMetrics.yieldsToNext(part, entry.slot.index)) return;
    final geometry = BarlineMetrics.of(barline, style, metrics);
    if (geometry.pieces.isEmpty) return;
    _drawBarlineAt(
      barline,
      entry.measure,
      // Right-aligned to the same edge the spacing engine measured back from,
      // which puts the whole of barlineGap between the last note and the
      // barline rather than splitting it across the measure boundary.
      left: entry.slot.right - geometry.width,
      geometry: geometry,
    );
  }

  /// Draws one barline group with its left edge at [left].
  void _drawBarlineAt(
    Barline? barline,
    Measure measure, {
    required double left,
    BarlineMetrics? geometry,
  }) {
    final shape = geometry ?? BarlineMetrics.of(barline, style, metrics);
    if (shape.pieces.isEmpty) return;

    final top = _geometry.lineY(lineCount);
    final bottom = _geometry.lineY(1);
    final source = barline ?? measure;
    final dashed =
        barline?.style == BarStyle.dashed || barline?.style == BarStyle.dotted;

    for (final piece in shape.pieces) {
      if (piece.isDots) {
        const dots = NotationGlyphs.repeatDots;
        // The dots glyph is drawn entirely above its origin — the font puts it
        // between a staff space and a half and two and a half above — so an
        // origin on the middle line lifts it clear off the top of the staff.
        // Centring the box on the middle line puts the dots in the second and
        // third spaces, where they belong, whatever the staff's line count.
        final centre = (metrics.glyphTop(dots) + metrics.glyphBottom(dots)) / 2;
        _elements.add(
          GlyphElement(
            glyph: dots,
            origin: Offset(left + piece.offset, _geometry.middle + centre),
            role: ElementRole.barline,
            size: metrics.glyphSize(dots),
            aboveOrigin: metrics.glyphTop(dots),
            source: source,
          ),
        );
        continue;
      }
      _elements.add(
        LineElement(
          from: Offset(left + piece.centre, top),
          to: Offset(left + piece.centre, bottom),
          thickness: piece.thickness,
          role: ElementRole.barline,
          dashLength: dashed ? style.lines.dashedBarlineDashLength : null,
          gapLength: dashed ? style.lines.dashedBarlineGapLength : null,
          source: source,
        ),
      );
    }
  }

  // ----------------------------------------------------------------- chords

  void _drawChord(Chord chord, double at, StaffMeasure entry) {
    // Music that sounds but is not seen: the realisation of a roll written as
    // one note, a voice kept for playback. Nothing of it is drawn — no stem,
    // no flag, no beam, and nothing hangs a slur from it either.
    if (!chord.isPrinted) return;
    final clef = entry.context.clefFor(staffNumber);
    if (clef.sign == ClefSign.tab) {
      _drawTabChord(chord, at);
      return;
    }
    final scale = chord.isGrace
        ? style.graceNoteScale
        : chord.cue
        ? style.cueNoteScale
        : 1.0;
    final shape = ChordShape.of(
      chord,
      clef,
      lineCount: lineCount,
      forced: _graceStem(chord, entry, clef),
    );
    final stemUp = shape.stemUp;
    final ordered = shape.notes;

    final noteheadGlyph = NotationGlyphs.notehead(
      chord.rhythm.type,
      shape: ordered.first.notehead,
      filled: ordered.first.filledNotehead,
    );
    final noteheadWidth = metrics.advanceWidth(noteheadGlyph) * scale;

    // Another voice may be sounding the same note, or one beside it, at this
    // very moment; one of the two has to step out of the other's way.
    final aside = _stepsAside(chord, entry, clef);
    final x = at - (aside ? noteheadWidth : 0.0);

    // Two notes a second apart cannot sit side by side, so one moves to the
    // other side of the stem.
    final sides = shape.shifted;

    final placements = <Note, Offset>{};
    var lowest = double.negativeInfinity;
    var highest = double.infinity;

    for (var i = 0; i < ordered.length; i++) {
      final note = ordered[i];
      final pitch = note.displayPitch;
      if (pitch == null || !note.printObject) continue;
      final position = clef.staffPositionOf(pitch);
      final y = _geometry.yForStaffPosition(position);
      final shifted = sides[i];
      final noteX =
          x + (shifted ? (stemUp ? noteheadWidth : -noteheadWidth) : 0);

      // A grace note's ledger lines are drawn at its own size, like the rest
      // of it; at full length they run into those of the note it decorates
      // and the two read as one line.
      final ledgerReach = style.ledgerLineExtension * scale;
      for (final ledger in _geometry.ledgerLinesFor(position)) {
        _elements.add(
          LineElement(
            from: Offset(
              noteX - ledgerReach,
              _geometry.yForStaffPosition(ledger),
            ),
            to: Offset(
              noteX + noteheadWidth + ledgerReach,
              _geometry.yForStaffPosition(ledger),
            ),
            thickness: style.lines.legerLineThickness * scale,
            role: ElementRole.ledgerLine,
            source: note,
            owner: chord,
          ),
        );
      }

      final glyph = NotationGlyphs.notehead(
        chord.rhythm.type,
        shape: note.notehead,
        filled: note.filledNotehead,
      );
      _elements.add(
        GlyphElement(
          glyph: glyph,
          origin: Offset(noteX, y),
          role: ElementRole.notehead,
          scale: scale,
          size: metrics.glyphSize(glyph) * scale,
          aboveOrigin: metrics.glyphTop(glyph) * scale,
          color: _parseColor(note.color),
          source: note,
          owner: chord,
        ),
      );
      placements[note] = Offset(noteX, y);
      lowest = math.max(lowest, y);
      highest = math.min(highest, y);
    }

    if (placements.isEmpty) return;

    // Accidentals stand left of the whole chord, and a second drawn across
    // the stem puts a notehead further left than the chord's own position:
    // measured from that position, the accidental was written over it.
    final leftmost = placements.values.fold(
      x,
      (found, offset) => math.min(found, offset.dx),
    );
    _drawAccidentals(chord, clef, leftmost, scale, placements);
    // A chord that has stepped aside still puts its dots past the voice it
    // stepped out of the way of, which is the room the measure reserved for
    // them and where a reader reads them.
    _drawAugmentationDots(
      chord,
      clef,
      x + noteheadWidth * (aside ? 2 : 1),
      scale,
      placements,
    );

    final placement = _ChordPlacement(
      chord: chord,
      x: x,
      noteheadWidth: noteheadWidth,
      stemUp: stemUp,
      topY: highest,
      bottomY: lowest,
      scale: scale,
      notePositions: placements,
    );
    _placements[chord] = placement;

    if (chord.arpeggiate || chord.nonArpeggiate) {
      _drawArpeggio(chord, placement);
    }
    if (chord.rhythm.type.hasStem) {
      _drawStem(chord, placement);
    }
    // The marks that hang off a note wait until the stems are their final
    // length. A beamed note's stem is only as long as the beam turns out to
    // need, and a mark set against the provisional one ends up inside it.
    _pendingMarks.add((
      chord: chord,
      placement: placement,
      shared: _sharesStaff(entry),
    ));
    _drawLyrics(chord, placement);
  }

  /// Which of a chord's noteheads have to move to the far side of the stem.
  /// Draws the sign before a chord that says how to sound it together.
  ///
  /// A wavy line down the left of the chord for one to be spread, a bracket
  /// for one that is not to be. It is stretched to the height of the chord
  /// rather than repeated, since the font draws it as a single stroke.
  void _drawArpeggio(Chord chord, _ChordPlacement placement) {
    final top = placement.topY - 0.5;
    final bottom = placement.bottomY + 0.5;
    final span = math.max(bottom - top, 1.0);

    if (chord.nonArpeggiate) {
      // A bracket, which the font has no single glyph for: a stroke down the
      // side of the chord with a hook at each end turned towards it.
      final thickness = style.lines.bracketThickness;
      final left = placement.x - style.arpeggioGap - style.arpeggioHook;
      void stroke(Offset from, Offset to) => _elements.add(
        LineElement(
          from: from,
          to: to,
          thickness: thickness,
          role: ElementRole.arpeggio,
          source: chord,
          owner: chord,
        ),
      );
      stroke(Offset(left, top), Offset(left, bottom));
      stroke(Offset(left, top), Offset(left + style.arpeggioHook, top));
      stroke(Offset(left, bottom), Offset(left + style.arpeggioHook, bottom));
      return;
    }

    // The font draws the wave as one repeating segment, laid out across the
    // page; turned a quarter turn it runs down it. A taller chord is given
    // more waves rather than longer ones, which is what a stretched glyph
    // would have given it.
    const glyph = NotationGlyphs.arpeggiate;
    final step = metrics.advanceWidth(glyph);
    if (step <= 0) return;
    final reach = metrics.glyphRight(glyph) - metrics.glyphLeft(glyph);
    final wide = metrics.glyphTop(glyph) - metrics.glyphBottom(glyph);
    final left = placement.x - style.arpeggioGap - wide;
    for (var i = 0; i * step < span; i++) {
      _elements.add(
        GlyphElement(
          glyph: glyph,
          origin: Offset(left, top + i * step),
          role: ElementRole.arpeggio,
          rotation: math.pi / 2,
          // As it ends up: a quarter turn puts the segment's length down the
          // page and its thickness across it.
          size: Size(wide, reach),
          aboveOrigin: -metrics.glyphLeft(glyph),
          source: chord,
          owner: chord,
        ),
      );
    }
  }

  /// Draws a chord on a tablature staff.
  ///
  /// Tablature says which string to stop and where, not which note to play, so
  /// each note is written as its fret number on the line of its string. There
  /// are no accidentals and no ledger lines — every note is on a string — and
  /// no stems either: the rhythm is read from the staff of ordinary notation
  /// the tablature is written under.
  void _drawTabChord(Chord chord, double x) {
    final fontSize = style.tabFontSize;
    final placements = <Note, Offset>{};
    var lowest = double.negativeInfinity;
    var highest = double.infinity;
    var width = 0.0;

    for (final note in chord.notes) {
      final string = note.string;
      if (string == null || string < 1 || string > lineCount) continue;
      if (!note.printObject) continue;
      // String one is the highest sounding and is written on the top line.
      final y = _geometry.lineY(lineCount - string + 1);
      final label = '${note.fret ?? 0}';
      final size = metrics.measureText(label, fontSize: fontSize);
      width = math.max(width, size.width);
      _elements.add(
        TextElement(
          text: label,
          // Sitting on the line rather than above it, which is what the number
          // being on the line is how a player reads which string it is.
          origin: Offset(x + size.width / 2, y + fontSize * 0.36),
          fontSize: fontSize,
          alignment: TextAlignment.center,
          role: ElementRole.tabNumber,
          measuredWidth: size.width,
          color: _parseColor(note.color),
          source: note,
          owner: chord,
        ),
      );
      placements[note] = Offset(x, y);
      lowest = math.max(lowest, y);
      highest = math.min(highest, y);
    }
    if (placements.isEmpty) return;

    _placements[chord] = _ChordPlacement(
      chord: chord,
      x: x,
      noteheadWidth: width,
      stemUp: false,
      topY: highest,
      bottomY: lowest,
      scale: 1,
      notePositions: placements,
      tablature: true,
    );
  }

  void _drawAccidentals(
    Chord chord,
    Clef clef,
    double x,
    double scale,
    Map<Note, Offset> placements,
  ) {
    final columns = AccidentalColumns.forChord(chord, clef);
    if (columns.columnCount == 0) return;
    for (final entry in columns.columnOf.entries) {
      final note = entry.key;
      final accidental = note.accidental;
      final placed = placements[note];
      if (accidental == null || placed == null) continue;
      final glyph = NotationGlyphs.accidental(accidental.type);
      final width = metrics.advanceWidth(glyph) * scale;
      final offset = (entry.value + 1) * (width + style.accidentalGap * scale);
      _elements.add(
        GlyphElement(
          glyph: glyph,
          origin: Offset(x - offset, placed.dy),
          role: ElementRole.accidental,
          scale: scale,
          size: metrics.glyphSize(glyph) * scale,
          aboveOrigin: metrics.glyphTop(glyph) * scale,
          source: accidental,
          owner: chord,
        ),
      );
    }
  }

  void _drawAugmentationDots(
    Chord chord,
    Clef clef,
    double right,
    double scale,
    Map<Note, Offset> placements,
  ) {
    if (chord.rhythm.dots == 0) return;
    const glyph = NotationGlyphs.augmentationDot;
    final width = metrics.advanceWidth(glyph) * scale;
    for (final entry in placements.entries) {
      final pitch = entry.key.displayPitch;
      if (pitch == null) continue;
      final position = clef.staffPositionOf(pitch);
      // A dot never sits on a line: a note on a line has its dot in the space
      // above.
      final dotY = StaffGeometry.isOnLine(position)
          ? _geometry.yForStaffPosition(position + 1)
          : entry.value.dy;
      var dotX = right + style.dotGap * scale;
      for (var i = 0; i < chord.rhythm.dots; i++) {
        _elements.add(
          GlyphElement(
            glyph: glyph,
            origin: Offset(dotX, dotY),
            role: ElementRole.augmentationDot,
            scale: scale,
            size: metrics.glyphSize(glyph) * scale,
            aboveOrigin: metrics.glyphTop(glyph) * scale,
            source: entry.key,
            owner: chord,
          ),
        );
        dotX += width + style.dotSpacing * scale;
      }
    }
  }

  void _drawStem(Chord chord, _ChordPlacement placement) {
    final glyph = NotationGlyphs.notehead(chord.rhythm.type);
    final anchor = placement.stemUp
        ? metrics.stemUpAnchor(glyph)
        : metrics.stemDownAnchor(glyph);
    // The font names the point where the *side* of the stem meets the
    // notehead — the bottom right corner for a stem up, the top left for a
    // stem down — not where its middle goes. Centred on that point half the
    // stem stands outside the notehead, which is what makes the two read as
    // separate shapes stuck together.
    final thickness = style.lines.stemThickness * placement.scale;
    final stemX =
        placement.x +
        anchor.dx * placement.scale +
        (placement.stemUp ? -thickness / 2 : thickness / 2);
    final attachY = placement.stemUp ? placement.bottomY : placement.topY;
    final length = style.stemLength * placement.scale;
    final endY = placement.stemUp
        ? placement.topY - length
        : placement.bottomY + length;

    placement.stemX = stemX;
    placement.stemEndY = endY;

    // A beamed note's stem is drawn once the beam's slope is known.
    if (chord.isBeamed) return;

    _elements.add(
      LineElement(
        from: Offset(stemX, attachY + anchor.dy * placement.scale),
        to: Offset(stemX, endY),
        thickness: thickness,
        role: ElementRole.stem,
        source: chord,
        owner: chord,
      ),
    );

    final flag = NotationGlyphs.flag(
      chord.rhythm.type,
      stemUp: placement.stemUp,
    );
    if (flag != null) {
      _elements.add(
        GlyphElement(
          glyph: flag,
          origin: Offset(stemX, endY),
          role: ElementRole.flag,
          scale: placement.scale,
          size: metrics.glyphSize(flag) * placement.scale,
          aboveOrigin: metrics.glyphTop(flag) * placement.scale,
          source: chord,
          owner: chord,
        ),
      );
    }
  }

  /// Draws the marks hanging off every chord of the staff.
  void _drawMarks() {
    for (final pending in _pendingMarks) {
      _drawArticulations(
        pending.chord,
        pending.placement,
        shared: pending.shared,
      );
      _drawFermatas(pending.chord, pending.placement);
    }
  }

  void _drawArticulations(
    Chord chord,
    _ChordPlacement placement, {
    required bool shared,
  }) {
    if (chord.articulations.isEmpty && chord.ornaments.isEmpty) return;

    // A mark belongs to its note and is written against the notehead, on the
    // side away from the stem — in the staff space beside it, inside the staff
    // when the note is inside it. Set clear of the whole staff instead, the
    // staccato of a note on the middle line ended up four spaces above it with
    // nothing in between.
    //
    // Two voices sharing a staff are the exception: their marks go outside the
    // pair, past the stems, or the lower voice's dots are written among the
    // upper voice's notes and read as belonging to them.
    final above = shared ? placement.stemUp : !placement.stemUp;
    // By more than the hair a mark keeps from its neighbour: an accent under a
    // note set only an articulationGap from it is all but touching it.
    final gap = style.articulationGap + 0.35;
    var y = shared
        ? (above
              ? math.min(placement.topY, placement.stemEndY) - gap
              : math.max(placement.bottomY, placement.stemEndY) + gap)
        : (above ? placement.topY - gap : placement.bottomY + gap);

    final centre = placement.x + placement.noteheadWidth / 2;

    var first = true;
    for (final articulation in chord.articulations) {
      final glyph = NotationGlyphs.articulation(articulation, above: above);
      final height = metrics.glyphSize(glyph).height;
      if (first) {
        // Written in a space rather than across a line, which is where a
        // reader expects to find it and what keeps it legible on the staff.
        y =
            _spaceBeyond(y + (above ? -height / 2 : height / 2), above: above) +
            (above ? height / 2 : -height / 2);
        first = false;
      }
      _elements.add(
        _markAt(
          glyph,
          centre,
          y,
          above: above,
          role: ElementRole.articulation,
          source: articulation,
          owner: chord,
        ),
      );
      y += (above ? -1 : 1) * (height + 0.2);
    }

    for (final ornament in chord.ornaments) {
      final glyph = NotationGlyphs.ornament(ornament);
      // A trill or a turn is written above everything the note carries — its
      // beam and its accent included — and clear of the staff.
      final reach = _drawnReach(
        centre - 0.5,
        centre + 0.5,
        above: true,
        ignoreTuplets: false,
      );
      final ornamentY =
          math.min(reach, _geometry.lineY(lineCount)) -
          style.articulationGap * 2;
      _elements.add(
        _markAt(
          glyph,
          centre,
          ornamentY,
          above: true,
          role: ElementRole.ornament,
          source: ornament,
          owner: chord,
        ),
      );
    }
  }

  /// A small mark centred on [centre] with its near edge on [y].
  ///
  /// Both have to be worked out from the glyph's own box. A staccato dot is
  /// not centred on its origin and does not start at it either, so putting the
  /// origin where the mark should go leaves the dot beside the note rather
  /// than under it, and inside the staff rather than clear of it.
  GlyphElement _markAt(
    SmuflGlyph glyph,
    double centre,
    double y, {
    required bool above,
    required ElementRole role,
    Object? source,
    MusicalEvent? owner,
  }) {
    final box = metrics.glyphSize(glyph);
    return GlyphElement(
      glyph: glyph,
      origin: Offset(
        centre - metrics.glyphLeft(glyph) - box.width / 2,
        y + (above ? metrics.glyphBottom(glyph) : metrics.glyphTop(glyph)),
      ),
      role: role,
      size: box,
      aboveOrigin: metrics.glyphTop(glyph),
      source: source,
      owner: owner,
    );
  }

  void _drawFermatas(Chord chord, _ChordPlacement placement) {
    for (final fermata in chord.fermatas) {
      final above = fermata.placement == Placement.above;
      final glyph = NotationGlyphs.fermata(fermata.shape, above: above);
      final y = above
          ? math.min(placement.topY, _geometry.lineY(lineCount)) - 1.5
          : math.max(placement.bottomY, _geometry.lineY(1)) + 1.5;
      // Placed by its own box, like the other small marks. Put there by its
      // origin instead, a fermata sits half a space from where it was asked
      // for, and — because the box it reports is centred on that origin — the
      // marks above it clear a fermata that is not where they think it is.
      _elements.add(
        _markAt(
          glyph,
          placement.x + placement.noteheadWidth / 2,
          y,
          above: above,
          role: ElementRole.fermata,
          source: fermata,
          owner: chord,
        ),
      );
    }
  }

  void _drawLyrics(Chord chord, _ChordPlacement placement) {
    for (final lyric in chord.lyrics) {
      _pendingLyrics.add(
        _PendingLyric(
          lyric: lyric,
          chord: chord,
          x: placement.x + placement.noteheadWidth / 2,
        ),
      );
    }
  }

  // ------------------------------------------------------------------ rests

  void _drawRest(Rest rest, double x, StaffMeasure entry) {
    if (!rest.printObject) return;
    final type = rest.isMeasureRest ? NoteType.whole : rest.rhythm.type;
    final glyph = NotationGlyphs.rest(type);
    // A whole rest hangs from the second line from the top, a half rest sits
    // on the middle line, and everything else is centred on the staff.
    final position = switch (type) {
      NoteType.whole => (lineCount - 1) * 2 - 2,
      NoteType.half => (lineCount - 1) * 2 - 4,
      _ => lineCount - 1,
    };
    var y = rest.displayPitch != null
        ? _geometry.yForPitch(
            rest.displayPitch!,
            entry.context.clefFor(staffNumber),
          )
        : _geometry.yForStaffPosition(position);

    // Two voices resting at the same moment cannot both have the place a
    // single rest would take, and a condensed score puts three or four of them
    // there. Each in turn steps below the ones already written, in voice
    // order, so that the lines can be read apart.
    final lane = (entry.slot.index, rest.position);
    final clef = entry.context.clefFor(staffNumber);
    final taken = _restLanes.putIfAbsent(lane, () {
      // The notes the other voices are playing at that moment are in the way
      // as much as their rests are.
      final held = <({double top, double bottom})>[];
      for (final event in entry.measure.eventsOnStaff(staffNumber)) {
        if (event is! Chord || event.position != rest.position) continue;
        if (!event.isPrinted) continue;
        var top = double.infinity;
        var bottom = double.negativeInfinity;
        for (final note in event.notes) {
          final pitch = note.displayPitch;
          if (pitch == null || !note.printObject) continue;
          final centre = _geometry.yForPitch(pitch, clef);
          top = math.min(top, centre);
          bottom = math.max(bottom, centre);
        }
        if (top.isInfinite) continue;
        // Stem and flag included: a rest tucked under a notehead is still in
        // the way of what hangs from it.
        final shape = ChordShape.of(event, clef, lineCount: lineCount);
        if (shape.stemUp) {
          top -= style.stemLength;
        } else {
          bottom += style.stemLength;
        }
        held.add((top: top - 0.3, bottom: bottom + 0.3));
      }
      return held;
    });
    final above = metrics.glyphTop(glyph);
    final below = metrics.glyphBottom(glyph);
    for (var tries = 0; tries < 8; tries++) {
      ({double top, double bottom})? clash;
      for (final used in taken) {
        if (y - above < used.bottom + 0.2 && y - below > used.top - 0.2) {
          clash = used;
          break;
        }
      }
      if (clash == null) break;
      y = clash.bottom + 0.2 + above;
    }
    taken.add((top: y - above, bottom: y - below));

    // A whole-measure rest is centred in the measure rather than placed at the
    // downbeat, which is how a reader expects to see it.
    final restX = rest.isMeasureRest
        ? entry.slot.musicLeft +
              (entry.slot.musicRight - entry.slot.musicLeft) / 2 -
              metrics.advanceWidth(glyph) / 2
        : x;

    _elements.add(
      GlyphElement(
        glyph: glyph,
        origin: Offset(restX, y),
        role: ElementRole.rest,
        size: metrics.glyphSize(glyph),
        aboveOrigin: metrics.glyphTop(glyph),
        source: rest,
        owner: rest,
      ),
    );

    if (!rest.isMeasureRest && rest.rhythm.dots > 0) {
      const dot = NotationGlyphs.augmentationDot;
      var dotX = restX + metrics.advanceWidth(glyph) + style.dotGap;
      for (var i = 0; i < rest.rhythm.dots; i++) {
        _elements.add(
          GlyphElement(
            glyph: dot,
            origin: Offset(dotX, _geometry.yForStaffPosition(lineCount)),
            role: ElementRole.augmentationDot,
            size: metrics.glyphSize(dot),
            aboveOrigin: metrics.glyphTop(dot),
            source: rest,
            owner: rest,
          ),
        );
        dotX += metrics.advanceWidth(dot) + style.dotSpacing;
      }
    }

    for (final fermata in rest.fermatas) {
      final above = fermata.placement == Placement.above;
      final glyph = NotationGlyphs.fermata(fermata.shape, above: above);
      _elements.add(
        GlyphElement(
          glyph: glyph,
          origin: Offset(
            restX,
            above ? _geometry.lineY(lineCount) - 1.5 : _geometry.lineY(1) + 1.5,
          ),
          role: ElementRole.fermata,
          size: metrics.glyphSize(glyph),
          aboveOrigin: metrics.glyphTop(glyph),
          source: fermata,
          owner: rest,
        ),
      );
    }
  }

  // ------------------------------------------------------------- directions

  void _drawDirection(Direction direction, double x, StaffMeasure entry) {
    _pendingDirections.add(_PendingDirection(direction: direction, x: x));
  }

  // --------------------------------------------------------------- deferred

  /// Draws the things that need to know where the notes ended up.
  ///
  /// Lyrics and dynamics are read along a line. Following each note's own
  /// height would make a verse of text ripple up and down with the melody,
  /// which is unreadable; engravers put them on one baseline clear of the
  /// music, and so does this.
  void _drawDeferred() {
    final music = _measuredExtent();
    var below = math.max(music.bottom, _geometry.lineY(1)) + style.lyricGap;
    var above =
        math.min(music.top, _geometry.lineY(lineCount)) - style.lyricGap;

    final verses = _pendingLyrics.map((l) => l.lyric.number).toSet().toList()
      ..sort();
    final baselines = <int, double>{};
    for (final verse in verses) {
      below += style.lyricFontSize * 0.85;
      baselines[verse] = below;
      below += style.lyricLineHeight - style.lyricFontSize * 0.85;
    }

    for (final verse in verses) {
      final line =
          _pendingLyrics
              .where((pending) => pending.lyric.number == verse)
              .toList()
            ..sort((a, b) => a.x.compareTo(b.x));
      final baseline = baselines[verse] ?? below;

      for (var i = 0; i < line.length; i++) {
        final pending = line[i];
        final size = metrics.measureText(
          pending.lyric.text,
          fontSize: style.lyricFontSize,
          role: ElementRole.lyric,
        );
        _elements.add(
          TextElement(
            text: pending.lyric.text,
            origin: Offset(pending.x, baseline),
            fontSize: style.lyricFontSize,
            alignment: TextAlignment.center,
            role: ElementRole.lyric,
            measuredWidth: size.width,
            source: pending.lyric,
            owner: pending.chord,
          ),
        );

        // A syllable in the middle of a word is joined to the next by a
        // hyphen, which is what tells a singer the two belong together.
        final joins =
            pending.lyric.syllabic == Syllabic.begin ||
            pending.lyric.syllabic == Syllabic.middle;
        if (!joins || i + 1 >= line.length) continue;
        final next = line[i + 1];
        final nextSize = metrics.measureText(
          next.lyric.text,
          fontSize: style.lyricFontSize,
          role: ElementRole.lyric,
        );
        final gapStart = pending.x + size.width / 2;
        final gapEnd = next.x - nextSize.width / 2;
        final hyphenWidth = metrics
            .measureText(
              '-',
              fontSize: style.lyricFontSize,
              role: ElementRole.lyric,
            )
            .width;
        // Only draw the hyphen if it fits with air on both sides; two
        // syllables already touching read as one word without it.
        if (gapEnd - gapStart < hyphenWidth * 2) continue;
        _elements.add(
          TextElement(
            text: '-',
            origin: Offset((gapStart + gapEnd) / 2, baseline),
            fontSize: style.lyricFontSize,
            alignment: TextAlignment.center,
            role: ElementRole.lyric,
            measuredWidth: hyphenWidth,
            source: pending.lyric,
            owner: pending.chord,
          ),
        );
      }
    }

    below += style.articulationGap;
    above -= style.articulationGap;
    // Chord symbols sit closest to the staff and the rest of the marks stack
    // outside them, which is the order a chart is read in.
    _drawChordSymbols(above);
    _placeDirections(above: true, edge: above);
    _placeDirections(above: false, edge: below);

    _drawWedges();
  }

  // --------------------------------------------------------------- endings

  /// Draws the volta brackets over the measures of this system.
  ///
  /// A first and second ending read as one line running over the bars they
  /// cover, hooked down at each end and numbered at the left. All of them sit
  /// at one height, above everything else on the staff: a bracket is read
  /// across the system, and one that dipped over a quiet bar and rose over a
  /// loud one would no longer look like a single line.
  void _drawEndings(List<StaffMeasure> measures) {
    if (!showsEndings || measures.isEmpty) return;

    final spans = <_EndingSpan>[];

    // A bracket that began on an earlier system runs on into this one, without
    // its hook or its number: both were printed where it started.
    final first = measures.first;
    var open = _endingOpenBefore(first.slot.index);
    if (open != null) {
      spans.add(
        _EndingSpan(
          ending: open,
          left: _musicStart[first.slot.index] ?? first.slot.left,
          right: first.slot.right,
          opens: false,
        ),
      );
    }

    for (final entry in measures) {
      final starts = entry.measure.leftBarline?.ending;
      if (starts != null && starts.type == EndingType.start) {
        open = starts;
        spans.add(
          _EndingSpan(
            ending: starts,
            // On the barline it starts from, except at the head of a system,
            // where the clef and the key stand where the hook would go.
            left: entry.isSystemStart
                ? (_musicStart[entry.slot.index] ?? entry.slot.left)
                : entry.slot.left,
            right: entry.slot.right,
            opens: true,
          ),
        );
      }
      if (open == null || spans.isEmpty) continue;
      spans.last.right = entry.slot.right;
      final stops = entry.measure.rightBarline?.ending;
      if (stops == null || stops.type == EndingType.start) continue;
      // A "discontinue" is an ending that simply stops being written — a last
      // time bar that runs on into the rest of the piece — so it is left open.
      spans.last.closes = stops.type == EndingType.stop;
      open = null;
    }

    if (spans.isEmpty) return;

    var reach = _geometry.lineY(lineCount);
    for (final span in spans) {
      reach = math.min(
        reach,
        _drawnReach(span.left, span.right, above: true, ignoreTuplets: false),
      );
    }
    final bottom = reach - style.articulationGap;
    final line = bottom - style.endingHookLength;
    final thickness = style.lines.repeatEndingLineThickness;

    for (final span in spans) {
      void stroke(Offset from, Offset to) => _elements.add(
        LineElement(
          from: from,
          to: to,
          thickness: thickness,
          role: ElementRole.ending,
          source: span.ending,
        ),
      );

      stroke(Offset(span.left, line), Offset(span.right, line));
      if (span.opens) {
        stroke(Offset(span.left, line), Offset(span.left, bottom));
      }
      // Where a second ending begins as the first one stops, the two share the
      // stroke between them: it is one line drawn on the measure they divide,
      // not one bracket's hook standing on another's.
      final handedOn = spans.any(
        (other) => other.opens && (other.left - span.right).abs() < 0.01,
      );
      if (span.closes && !handedOn) {
        stroke(Offset(span.right, line), Offset(span.right, bottom));
      }
      if (!span.opens) continue;

      final label = _endingLabel(span.ending);
      if (label.isEmpty) continue;
      final size = metrics.measureText(label, fontSize: style.endingFontSize);
      _elements.add(
        TextElement(
          text: label,
          // Inside the bracket, standing on the foot of its hook, which is
          // what the hook is drawn deep enough to hold.
          origin: Offset(
            span.left + style.endingFontSize * 0.4,
            bottom - style.endingFontSize * 0.2,
          ),
          fontSize: style.endingFontSize,
          role: ElementRole.ending,
          measuredWidth: size.width,
          source: span.ending,
        ),
      );
    }
  }

  /// The ending a measure before [index] left open, if any.
  Ending? _endingOpenBefore(int index) {
    for (var i = math.min(index, part.measures.length) - 1; i >= 0; i--) {
      final measure = part.measures[i];
      final stops = measure.rightBarline?.ending;
      if (stops != null && stops.type != EndingType.start) return null;
      final starts = measure.leftBarline?.ending;
      if (starts != null && starts.type == EndingType.start) return starts;
    }
    return null;
  }

  /// What is written inside a volta bracket.
  ///
  /// Whatever the source wrote there, and otherwise the times it covers: "1."
  /// for a first ending, "1. 2." for one taken twice.
  String _endingLabel(Ending ending) {
    final text = ending.text;
    if (text != null && text.trim().isNotEmpty) return text.trim();
    return ending.numbers.map((number) => '$number.').join(' ');
  }

  /// Draws the chord symbols of the system along one line above the staff.
  ///
  /// One line for all of them, because a chart is read as a row: a symbol that
  /// rose over the one high note beneath it would break the row it belongs to.
  /// The line clears the music that is actually under a symbol rather than the
  /// tallest thing anywhere in the system.
  void _drawChordSymbols(double edge) {
    if (_pendingChords.isEmpty) return;
    final fontSize = style.chordFontSize;

    final pieces = [
      for (final pending in _pendingChords) _chordPieces(pending.harmony),
    ];

    var baseline = _geometry.lineY(lineCount) - style.lyricGap;
    for (var i = 0; i < _pendingChords.length; i++) {
      final left = _pendingChords[i].x;
      final reach = _drawnReach(
        left - 0.2,
        left + pieces[i].width + 0.2,
        above: true,
        ignoreTuplets: false,
      );
      baseline = math.min(baseline, reach - style.articulationGap);
    }

    for (var i = 0; i < _pendingChords.length; i++) {
      var x = _pendingChords[i].x;
      final harmony = _pendingChords[i].harmony;
      for (final piece in pieces[i].parts) {
        switch (piece) {
          case final _ChordText text:
            _elements.add(
              TextElement(
                text: text.text,
                origin: Offset(x, baseline),
                fontSize: fontSize,
                role: ElementRole.chordSymbol,
                measuredWidth: text.width,
                source: harmony,
                owner: harmony,
              ),
            );
          case final _ChordGlyph glyph:
            _elements.add(
              GlyphElement(
                glyph: glyph.glyph,
                // Raised to sit against the letter beside it rather than
                // hanging from its foot, as an accidental in a chord symbol
                // does.
                origin: Offset(x, baseline - fontSize * 0.28),
                role: ElementRole.chordSymbol,
                scale: glyph.scale,
                size: metrics.glyphSize(glyph.glyph) * glyph.scale,
                aboveOrigin: metrics.glyphTop(glyph.glyph) * glyph.scale,
                source: harmony,
                owner: harmony,
              ),
            );
        }
        x += piece.width;
      }
    }
  }

  /// The pieces a chord symbol is written with, left to right.
  ///
  /// A sharp or a flat comes from the music font: the text faces a reader has
  /// installed mostly do not carry one, and the ones that do draw it at the
  /// size of a letter rather than of an accidental.
  ({List<_ChordPiece> parts, double width}) _chordPieces(Harmony harmony) {
    final fontSize = style.chordFontSize;
    final parts = <_ChordPiece>[];

    void addText(String text) {
      if (text.isEmpty) return;
      parts.add(
        _ChordText(
          text,
          metrics
              .measureText(
                text,
                fontSize: fontSize,
                role: ElementRole.chordSymbol,
              )
              .width,
        ),
      );
    }

    void addAlteration(double alter) {
      final type = AccidentalType.forAlteration(alter);
      if (type == null || alter == 0) return;
      final glyph = NotationGlyphs.accidental(type);
      const scale = 0.62;
      parts.add(
        _ChordGlyph(glyph, scale, metrics.advanceWidth(glyph) * scale + 0.1),
      );
    }

    addText(harmony.root.step.name.toUpperCase());
    addAlteration(harmony.root.alter);
    addText(harmony.suffix);

    final bass = harmony.bass;
    if (bass != null) {
      addText('/${bass.step.name.toUpperCase()}');
      addAlteration(bass.alter);
    }

    var width = 0.0;
    for (final piece in parts) {
      width += piece.width;
    }
    return (parts: parts, width: width);
  }

  /// Lays the directions on one side of the staff out in rows.
  ///
  /// Marks only need a row of their own when they would otherwise run into
  /// each other. Giving every direction its own row — which is what stacking
  /// each one outwards from the last amounts to — walks a page of hairpins
  /// steadily down the page, so that the crescendo in the second measure and
  /// the one in the fifth sit at two different heights for no reason a reader
  /// can see. Here a direction takes the innermost row it fits in, and only
  /// a genuine overlap opens a new one.
  void _placeDirections({required bool above, required double edge}) {
    final mine = [
      for (final pending in _pendingDirections)
        if ((pending.direction.placement == Placement.above) == above) pending,
    ]..sort((a, b) => a.x.compareTo(b.x));
    if (mine.isEmpty) return;

    // Measured first, because a row's height is the tallest thing in it and
    // that has to be known before anything is drawn at its baseline.
    final extents = [
      for (var i = 0; i < mine.length; i++) _extentOfDirection(mine, i),
    ];

    final rowOf = List<int>.filled(mine.length, 0);
    final startX = [for (final pending in mine) pending.x];
    final rowRight = <double>[];
    final rowHeight = <double>[];
    for (var i = 0; i < mine.length; i++) {
      final extent = extents[i];
      var left = startX[i];
      var row = 0;
      while (row < rowRight.length &&
          left < rowRight[row] + style.articulationGap) {
        // A hairpin has no left edge of its own — it starts where it starts
        // being drawn — so one that runs into the dynamic it grows from is
        // moved along rather than pushed onto a line of its own. "f" and the
        // hairpin after it are one mark and belong on one line.
        if (_isBareWedge(mine[i].direction)) {
          left = rowRight[row] + style.articulationGap;
          break;
        }
        row++;
      }
      if (row == rowRight.length) {
        rowRight.add(double.negativeInfinity);
        rowHeight.add(0);
      }
      startX[i] = left;
      rowOf[i] = row;
      rowRight[row] = math.max(rowRight[row], left + extent.width);
      rowHeight[row] = math.max(rowHeight[row], extent.height);
    }

    // Each row stands clear of the music actually under it, not of the
    // tallest thing anywhere in the system. A segno in the last measure was
    // being lifted by a trill in the second, which is what made these look as
    // though they were floating at random heights.
    //
    // Only above the staff: below it the lyrics run along one line the whole
    // width of the system, and anything under them has to clear them
    // everywhere they are.
    final rowEdge = List<double>.filled(rowHeight.length, edge);
    if (above) {
      final reach = List<double>.filled(rowHeight.length, double.infinity);
      for (var i = 0; i < mine.length; i++) {
        final row = rowOf[i];
        reach[row] = math.min(
          reach[row],
          _drawnReach(
            startX[i] - 0.2,
            startX[i] + extents[i].width + 0.2,
            above: true,
            ignoreTuplets: false,
          ),
        );
      }
      for (var row = 0; row < rowEdge.length; row++) {
        if (!reach[row].isFinite) continue;
        // Clear of what is under it, and never nearer the staff than the gap
        // everything above it keeps.
        rowEdge[row] = math.min(
          reach[row] - style.articulationGap,
          _geometry.lineY(lineCount) - style.lyricGap,
        );
      }
    } else {
      // The same below, except that it may never come up past [edge]: the
      // lyrics run along one line the whole width of the system and anything
      // under them has to clear them everywhere they are. Without this a
      // dynamic under a run of notes on ledger lines was pushed so far down
      // that it read as belonging to the staff underneath.
      final reach = List<double>.filled(
        rowHeight.length,
        double.negativeInfinity,
      );
      for (var i = 0; i < mine.length; i++) {
        final row = rowOf[i];
        reach[row] = math.max(
          reach[row],
          _drawnReach(
            startX[i] - 0.2,
            startX[i] + extents[i].width + 0.2,
            above: false,
            ignoreTuplets: false,
          ),
        );
      }
      for (var row = 0; row < rowEdge.length; row++) {
        if (!reach[row].isFinite) continue;
        rowEdge[row] = math.max(
          math.min(reach[row] + style.articulationGap, edge),
          _geometry.lineY(1) + style.lyricGap,
        );
      }
    }

    final baselines = <double>[];
    var cursor = rowEdge.first;
    for (var row = 0; row < rowHeight.length; row++) {
      // Outside whatever the row before it took, and outside its own music.
      cursor = above
          ? math.min(cursor, rowEdge[row])
          : math.max(cursor, rowEdge[row]);
      baselines.add(cursor);
      // The row's own height, and then air, so that two rows read as two lines
      // of marks rather than as one block.
      cursor += (above ? -1 : 1) * (rowHeight[row] + style.directionGap);
    }

    for (var i = 0; i < mine.length; i++) {
      _drawDirectionAt(
        mine[i].direction,
        startX[i],
        baselines[rowOf[i]],
        above: above,
      );
    }
  }

  /// Whether a direction is nothing but a hairpin, and so has no left edge of
  /// its own that has to stay where it is.
  bool _isBareWedge(Direction direction) =>
      direction.types.isNotEmpty &&
      direction.types.every((type) => type is WedgeDirection);

  /// How much room the direction at [index] needs, without drawing it.
  ///
  /// A hairpin reaches as far as the stop that closes it, which is a later
  /// direction rather than anything this one carries, so it is looked up here.
  ({double width, double height}) _extentOfDirection(
    List<_PendingDirection> pending,
    int index,
  ) {
    final direction = pending[index].direction;
    final measured = _drawDirectionAt(
      direction,
      pending[index].x,
      0,
      above: true,
      paint: false,
    );
    var width = measured.width;
    for (final type in direction.types) {
      if (type is! WedgeDirection) continue;
      if (type.type == WedgeType.stop) continue;
      var end = systemWidth;
      for (var j = index + 1; j < pending.length; j++) {
        final closes = pending[j].direction.types.any(
          (other) => other is WedgeDirection && other.type == WedgeType.stop,
        );
        if (closes) {
          end = pending[j].x;
          break;
        }
      }
      width = math.max(width, end - pending[index].x);
    }
    return (width: width, height: measured.height);
  }

  /// How far the music drawn so far reaches above and below the staff.
  ({double top, double bottom}) _measuredExtent() {
    var top = double.infinity;
    var bottom = double.negativeInfinity;
    for (final element in _elements) {
      if (element.role == ElementRole.staffLine) continue;
      final bounds = element.bounds;
      if (bounds.top < top) top = bounds.top;
      if (bounds.bottom > bottom) bottom = bounds.bottom;
    }
    if (top.isInfinite) top = 0;
    if (bottom.isInfinite) bottom = _geometry.height;
    return (top: top, bottom: bottom);
  }

  /// Draws one direction with its near edge at [y], and reports how much
  /// vertical room it took.
  ///
  /// Placing by the edge of the drawn shape rather than by a baseline is what
  /// keeps a dynamic from creeping into the verse above it: glyphs differ
  /// wildly in how far they reach from their origin, and only the font knows
  /// by how much.
  ({double width, double height}) _drawDirectionAt(
    Direction direction,
    double x,
    double y, {
    required bool above,
    bool paint = true,
  }) {
    var used = 0.0;
    // One direction can say several things at once — a segno and a coda, a
    // tempo and the words for it. They are printed in a row, so each moves the
    // next along rather than being stacked on the same spot.
    var cursorX = x;
    // Measuring and drawing are the same walk, so a dry run does the walk and
    // then puts back what it produced. Keeping a second copy of these sizes
    // only to measure them is how the two drift apart.
    final elementMark = _elements.length;
    final wedgeMark = _pendingWedges.length;

    double glyphHeight(SmuflGlyph glyph) =>
        metrics.glyphTop(glyph) - metrics.glyphBottom(glyph);

    // Everything in one direction stands on one line. A tempo mark is a note
    // and the words beside it, and the note is three times their height:
    // placed each by the block it occupies, the words float above the head of
    // the note they belong to. So the foot of the row is worked out first and
    // both are set on it — glyphs by their bottom edge, text by its baseline.
    var rowHeight = 0.0;
    for (final type in direction.types) {
      rowHeight = math.max(rowHeight, switch (type) {
        DynamicsDirection() => style.textFontSize,
        MetronomeDirection() =>
          glyphHeight(
                NotationGlyphs.metronomeNote(
                  NoteType.values.firstWhere(
                    (t) => t.xmlName == type.beatUnit,
                    orElse: () => NoteType.quarter,
                  ),
                ),
              ) *
              _markScale,
        RehearsalDirection() => style.textFontSize * 1.2,
        SegnoDirection() => glyphHeight(NotationGlyphs.segno) * _markScale,
        CodaDirection() => glyphHeight(NotationGlyphs.coda) * _markScale,
        _ => style.textFontSize,
      });
    }
    final rowBottom = above ? y : y + rowHeight;

    /// The y a glyph's origin needs so that it stands on the row's foot.
    double glyphOrigin(SmuflGlyph glyph, [double scale = 1]) =>
        rowBottom + metrics.glyphBottom(glyph) * scale;

    /// The baseline of a line of text in the row, which is the same foot.
    double textBaseline(double fontSize) => rowBottom;

    for (final type in direction.types) {
      switch (type) {
        case final DynamicsDirection dynamics:
          var cursor = cursorX;
          for (final mark in dynamics.marks) {
            final glyph = NotationGlyphs.dynamicMark(mark);
            _elements.add(
              GlyphElement(
                glyph: glyph,
                origin: Offset(cursor, glyphOrigin(glyph)),
                role: ElementRole.dynamics,
                size: metrics.glyphSize(glyph),
                aboveOrigin: metrics.glyphTop(glyph),
                source: direction,
                owner: direction,
              ),
            );
            cursor += metrics.advanceWidth(glyph);
            used = math.max(used, glyphHeight(glyph) + 0.4);
          }
          cursorX = cursor + style.articulationGap;
        case final WordsDirection words:
          final italic = words.fontStyle == 'italic';
          final bold = words.fontWeight == 'bold';
          // Split so that a sharp or a flat in the words — "B♭ Clarinet",
          // "in E♭" — comes from the music font instead of the empty box a
          // text face draws for it.
          final pieces = metrics.splitSigns(
            words.text,
            fontSize: style.textFontSize,
            italic: italic,
            bold: bold,
          );
          for (final piece in pieces) {
            final sign = piece.glyph;
            _elements.add(
              sign == null
                  ? TextElement(
                      text: piece.text!,
                      origin: Offset(cursorX, textBaseline(style.textFontSize)),
                      fontSize: style.textFontSize,
                      italic: italic,
                      bold: bold,
                      role: ElementRole.text,
                      measuredWidth: piece.width,
                      source: direction,
                      owner: direction,
                    )
                  : GlyphElement(
                      glyph: sign,
                      origin: Offset(
                        cursorX,
                        textBaseline(style.textFontSize) -
                            style.textFontSize * 0.28,
                      ),
                      role: ElementRole.text,
                      scale: piece.scale,
                      size: metrics.glyphSize(sign) * piece.scale,
                      aboveOrigin: metrics.glyphTop(sign) * piece.scale,
                      source: direction,
                      owner: direction,
                    ),
            );
            cursorX += piece.width;
          }
          used = math.max(used, style.textFontSize * 1.3);
          cursorX += style.articulationGap;
        case final MetronomeDirection metronome:
          // The beat is a note, drawn from the music font. Written as the
          // character U+2669 it comes out at the size of a letter, and on most
          // machines it does not come out at all.
          final beat = NotationGlyphs.metronomeNote(
            NoteType.values.firstWhere(
              (type) => type.xmlName == metronome.beatUnit,
              orElse: () => NoteType.quarter,
            ),
          );
          final beatY = glyphOrigin(beat, _markScale);
          _elements.add(
            GlyphElement(
              glyph: beat,
              origin: Offset(cursorX, beatY),
              role: ElementRole.text,
              scale: _markScale,
              size: metrics.glyphSize(beat) * _markScale,
              aboveOrigin: metrics.glyphTop(beat) * _markScale,
              source: direction,
              owner: direction,
            ),
          );
          cursorX += metrics.advanceWidth(beat) * _markScale;
          used = math.max(used, glyphHeight(beat) * _markScale + 0.4);

          for (var i = 0; i < metronome.beatUnitDots; i++) {
            const dot = NotationGlyphs.augmentationDot;
            _elements.add(
              GlyphElement(
                glyph: dot,
                origin: Offset(cursorX, beatY - 0.75),
                role: ElementRole.text,
                scale: _markScale,
                size: metrics.glyphSize(dot) * _markScale,
                aboveOrigin: metrics.glyphTop(dot) * _markScale,
                source: direction,
                owner: direction,
              ),
            );
            cursorX +=
                metrics.advanceWidth(dot) * _markScale + style.dotSpacing;
          }

          final text = metronome.perMinute == null
              ? ''
              : ' = ${metronome.perMinute!.round()}';
          if (text.isNotEmpty) {
            final size = metrics.measureText(
              text,
              fontSize: style.textFontSize,
            );
            _elements.add(
              TextElement(
                text: text,
                origin: Offset(cursorX, textBaseline(style.textFontSize)),
                fontSize: style.textFontSize,
                bold: true,
                role: ElementRole.text,
                measuredWidth: size.width,
                source: direction,
                owner: direction,
              ),
            );
            used = math.max(used, style.textFontSize * 1.3);
            cursorX += size.width;
          }
          cursorX += style.articulationGap;
        case final RehearsalDirection rehearsal:
          final fontSize = style.textFontSize * 1.2;
          final size = metrics.measureText(
            rehearsal.text,
            fontSize: fontSize,
            bold: true,
          );
          _elements.add(
            TextElement(
              text: rehearsal.text,
              origin: Offset(cursorX, textBaseline(fontSize)),
              fontSize: fontSize,
              bold: true,
              role: ElementRole.text,
              measuredWidth: size.width,
              source: direction,
              owner: direction,
            ),
          );
          used = math.max(used, fontSize * 1.4);
          cursorX += size.width + style.articulationGap;
        case final WedgeDirection wedge:
          _pendingWedges.add(
            _PendingWedge(wedge, x, above ? y - 0.9 : y + 0.9, direction),
          );
          used = math.max(used, 2.0);
        case SegnoDirection():
        case CodaDirection():
          final glyph = type is SegnoDirection
              ? NotationGlyphs.segno
              : NotationGlyphs.coda;
          _elements.add(
            GlyphElement(
              glyph: glyph,
              origin: Offset(cursorX, glyphOrigin(glyph, _markScale)),
              role: ElementRole.text,
              scale: _markScale,
              size: metrics.glyphSize(glyph) * _markScale,
              aboveOrigin: metrics.glyphTop(glyph) * _markScale,
              source: direction,
              owner: direction,
            ),
          );
          used = math.max(used, glyphHeight(glyph) * _markScale + 0.4);
          cursorX +=
              metrics.advanceWidth(glyph) * _markScale + style.articulationGap;
        default:
          break;
      }
    }
    if (!paint) {
      _elements.removeRange(elementMark, _elements.length);
      _pendingWedges.removeRange(wedgeMark, _pendingWedges.length);
    }
    return (width: cursorX - x, height: used);
  }

  // ------------------------------------------------------------------ beams

  /// Draws the beams, and the stems of the notes they join.
  ///
  /// A beamed note's stem cannot be drawn until the beam is placed, because it
  /// is the beam that decides where the stem ends. So stems are held back in
  /// [_drawStem] and drawn here instead.
  void _drawBeams(List<StaffMeasure> measures) {
    for (final run in _beamRuns(measures)) {
      if (run.length < 2) continue;
      final placements = [for (final chord in run) ?_placements[chord]];
      if (placements.length < 2) continue;

      final stemUp = placements.first.stemUp;
      final first = placements.first;
      final last = placements.last;

      // The beam follows the outline of the notes, but only gently: a run that
      // climbs an octave is drawn with a slope of about a space, not an
      // octave, or it would leave the staff.
      final firstOuter = stemUp ? first.topY : first.bottomY;
      final lastOuter = stemUp ? last.topY : last.bottomY;
      final span = last.stemX - first.stemX;
      final rawSlope = span == 0 ? 0.0 : (lastOuter - firstOuter) / span;
      final slope = rawSlope.clamp(-0.25, 0.25);

      final baseLength = style.stemLength * first.scale;
      var beamY = stemUp ? firstOuter - baseLength : firstOuter + baseLength;

      // Push the beam far enough out that no stem in the run gets shorter than
      // the minimum.
      for (final placement in placements) {
        final atX = beamY + slope * (placement.stemX - first.stemX);
        final outer = stemUp ? placement.topY : placement.bottomY;
        final length = stemUp ? outer - atX : atX - outer;
        final shortfall = style.minimumStemLength * placement.scale - length;
        if (shortfall > 0) beamY += stemUp ? -shortfall : shortfall;
      }

      // Grace notes are drawn small, and so are the beams across them: at
      // full weight three beams over a run of 32nd graces are a black smear
      // wider than the noteheads under them.
      final thickness = style.lines.beamThickness * first.scale;
      final gap = style.lines.beamSpacing * first.scale;

      final maxLevel = run
          .map((chord) => chord.rhythm.type.flagCount)
          .fold(0, (a, b) => a > b ? a : b);
      // How deep the stack of beams is, from the outermost to the one nearest
      // the notes.
      final depth = (maxLevel - 1) * (thickness + gap) + thickness;

      // A staff carrying several voices at once has a beamed run in each of
      // them, and they are drawn one outside the other. Left at the same
      // distance from their own notes, two runs a third apart come out with
      // their beams touching and their stems on the same line.
      final own = {for (final chord in run) chord};
      for (final element in _elements) {
        if (own.contains(element.owner)) continue;
        switch (element.role) {
          case ElementRole.staffLine ||
              ElementRole.ledgerLine ||
              ElementRole.tuplet:
            continue;
          default:
        }
        for (final point in _outlineOf(element)) {
          if (point.x < first.stemX - 0.1 || point.x > last.stemX + 0.1) {
            continue;
          }
          final top = stemUp ? beamY - thickness / 2 : beamY - depth;
          final bottom = stemUp ? beamY + depth : beamY + thickness / 2;
          if (point.bottom < top || point.top > bottom) continue;
          beamY += stemUp ? point.top - 0.3 - bottom : point.bottom + 0.3 - top;
        }
      }

      double beamYAt(double x) => beamY + slope * (x - first.stemX);

      for (final placement in placements) {
        final endY = beamYAt(placement.stemX);
        final attachY = stemUp ? placement.bottomY : placement.topY;
        _elements.add(
          LineElement(
            from: Offset(placement.stemX, attachY),
            to: Offset(placement.stemX, endY),
            thickness: style.lines.stemThickness * placement.scale,
            role: ElementRole.stem,
            source: placement.chord,
            owner: placement.chord,
          ),
        );
        placement.stemEndY = endY;
        placement.stemDrawn = true;
      }

      for (var level = 1; level <= maxLevel; level++) {
        final offset = (level - 1) * (thickness + gap);
        final levelY = stemUp ? offset : -offset;

        var segmentStart = -1;
        for (var i = 0; i < run.length; i++) {
          final hasLevel = run[i].beams.any((beam) => beam.level == level);
          if (hasLevel && segmentStart < 0) segmentStart = i;

          final ends = !hasLevel || i == run.length - 1;
          if (!ends || segmentStart < 0) continue;

          final endIndex = hasLevel ? i : i - 1;
          if (endIndex > segmentStart) {
            final leftX = placements[segmentStart].stemX;
            final rightX = placements[endIndex].stemX;
            _elements.add(
              BeamElement(
                left: Offset(
                  leftX,
                  beamYAt(leftX) +
                      levelY +
                      (stemUp ? thickness / 2 : -thickness / 2),
                ),
                right: Offset(
                  rightX,
                  beamYAt(rightX) +
                      levelY +
                      (stemUp ? thickness / 2 : -thickness / 2),
                ),
                thickness: thickness,
                role: ElementRole.beam,
                source: run[segmentStart],
                owner: run[segmentStart],
              ),
            );
          } else {
            // A lone short note inside the group gets a hook rather than a
            // beam that would reach a note not sharing this level.
            final state = run[segmentStart].beams
                .firstWhere(
                  (beam) => beam.level == level,
                  orElse: () => const Beam(level: 0, state: BeamState.begin),
                )
                .state;
            final stemX = placements[segmentStart].stemX;
            const hookWidth = 1.0;
            final towards = state == BeamState.backwardHook
                ? -hookWidth
                : hookWidth;
            _elements.add(
              BeamElement(
                left: Offset(
                  math.min(stemX, stemX + towards),
                  beamYAt(stemX) +
                      levelY +
                      (stemUp ? thickness / 2 : -thickness / 2),
                ),
                right: Offset(
                  math.max(stemX, stemX + towards),
                  beamYAt(stemX + towards) +
                      levelY +
                      (stemUp ? thickness / 2 : -thickness / 2),
                ),
                thickness: thickness,
                role: ElementRole.beam,
                source: run[segmentStart],
                owner: run[segmentStart],
              ),
            );
          }
          segmentStart = -1;
        }
      }
    }
  }

  /// Draws a plain stem for a note that claims a beam but ended up in no run,
  /// which happens when a file's beaming is inconsistent or a run is cut off by
  /// a system break.
  void _drawOrphanStems() {
    for (final placement in _placements.values) {
      final chord = placement.chord;
      if (placement.tablature) continue;
      if (!chord.isBeamed || placement.stemDrawn) continue;
      if (!chord.rhythm.type.hasStem) continue;
      final attachY = placement.stemUp ? placement.bottomY : placement.topY;
      final endY = placement.stemUp
          ? placement.topY - style.stemLength * placement.scale
          : placement.bottomY + style.stemLength * placement.scale;
      _elements.add(
        LineElement(
          from: Offset(placement.stemX, attachY),
          to: Offset(placement.stemX, endY),
          thickness: style.lines.stemThickness * placement.scale,
          role: ElementRole.stem,
          source: chord,
          owner: chord,
        ),
      );
      final flag = NotationGlyphs.flag(
        chord.rhythm.type,
        stemUp: placement.stemUp,
      );
      if (flag != null) {
        _elements.add(
          GlyphElement(
            glyph: flag,
            origin: Offset(placement.stemX, endY),
            role: ElementRole.flag,
            scale: placement.scale,
            size: metrics.glyphSize(flag) * placement.scale,
            aboveOrigin: metrics.glyphTop(flag) * placement.scale,
            source: chord,
            owner: chord,
          ),
        );
      }
      placement.stemDrawn = true;
    }
  }

  /// Consecutive beamed chords, split into the runs a single beam joins.
  List<List<Chord>> _beamRuns(List<StaffMeasure> measures) {
    final runs = <List<Chord>>[];
    final open = <int, List<Chord>>{};

    for (final entry in measures) {
      // Tablature carries no rhythm of its own, and so no beams.
      if (entry.context.clefFor(staffNumber).sign == ClefSign.tab) continue;
      for (final event in entry.measure.eventsOnStaff(staffNumber)) {
        if (event is! Chord || !event.isPrinted) continue;
        final primary = event.beams.where((beam) => beam.level == 1).toList();
        if (primary.isEmpty) continue;
        final state = primary.first.state;
        final voice = event.voice;
        switch (state) {
          case BeamState.begin:
            open[voice] = [event];
          case BeamState.continueBeam:
          case BeamState.forwardHook:
          case BeamState.backwardHook:
            open[voice]?.add(event);
          case BeamState.end:
            final run = open.remove(voice);
            if (run != null) runs.add([...run, event]);
        }
      }
    }
    // A beam that runs off the end of the system is still worth drawing.
    for (final run in open.values) {
      if (run.length > 1) runs.add(run);
    }
    return runs;
  }

  // --------------------------------------------------------------- spanners

  /// Draws ties, slurs, tuplet brackets and hairpins.
  ///
  /// These all connect two points that may be measures apart, so they are left
  /// until the notes they attach to have been placed.
  void _drawSpanners() {
    final slurs = <Slur>[];
    for (final spanner in spanners.touching(_placements.keys)) {
      final start = _placements[spanner.start];
      final end = _placements[spanner.end];
      // A spanner with an end outside this system is drawn to the system edge.
      if (start == null && end == null) continue;
      // One between the staves of an instrument is not drawn here at all: it
      // is the system that knows where both staves ended up, and left to each
      // staff it came out as two halves running off the edges of the page.
      if (start == null && _xOffStaff(spanner.start) != null) continue;
      if (end == null && _xOffStaff(spanner.end) != null) continue;

      switch (spanner) {
        case final Tie tie:
          _drawTie(tie, start, end);
        case final Slur slur:
          slurs.add(slur);
        case final Tuplet tuplet:
          _drawTuplet(tuplet, start, end);
      }
    }

    // Shortest first, so that a phrase slur drawn over a shorter one can arch
    // clear of it. Two slurs over the same notes at the same height read as
    // one line crossing itself.
    slurs.sort((a, b) => _slurSpan(a).compareTo(_slurSpan(b)));
    for (final slur in slurs) {
      _drawSlur(slur, _placements[slur.start], _placements[slur.end]);
    }
  }

  /// How far a slur reaches across this system.
  double _slurSpan(Slur slur) {
    final start = _placements[slur.start];
    final end = _placements[slur.end];
    return (end?.x ?? systemWidth) - (start?.x ?? 0);
  }

  /// Where a spanner that began on the system before picks up again.
  ///
  /// Just past the clef and the key, not at the system's left edge: started at
  /// nothing, a tie arriving from the line above is drawn straight over the
  /// signature reprinted in front of the music it belongs to. It stops short
  /// of where the music itself begins, so that the tie still reaches the note
  /// it holds rather than being squeezed out of existence.
  double get _continuedFromX {
    if (_musicStart.isEmpty) return 0;
    final music = _musicStart[_musicStart.keys.reduce(math.min)]!;
    var edge = 0.0;
    for (final element in _elements) {
      final isFurniture =
          element.role == ElementRole.clef ||
          element.role == ElementRole.keySignature ||
          element.role == ElementRole.timeSignature;
      // Only what is printed at the head of the system: a clef changing in
      // the middle of it stands past where the music began.
      if (!isFurniture || element.bounds.right > music) continue;
      edge = math.max(edge, element.bounds.right);
    }
    return edge == 0 ? 0 : edge + style.articulationGap;
  }

  void _drawTie(Tie tie, _ChordPlacement? start, _ChordPlacement? end) {
    final anchor = start ?? end!;
    final above = switch (tie.placement) {
      Placement.above => true,
      Placement.below => false,
      null => switch (tie.orientation) {
        LineOrientation.over => true,
        LineOrientation.under => false,
        LineOrientation.auto => !anchor.stemUp,
      },
    };
    final startNote = start == null
        ? null
        : _noteAt(start, tie.startNoteIndex, tie.start);
    final endNote = end == null
        ? null
        : _noteAt(end, tie.endNoteIndex, tie.end);

    final y = startNote?.dy ?? endNote?.dy ?? anchor.topY;
    final fromX = start != null
        ? (startNote?.dx ?? start.x) + start.noteheadWidth
        : (_xOffStaff(tie.start) ?? _continuedFromX);
    final toX = end != null
        ? (endNote?.dx ?? end.x)
        : (_xOffStaff(tie.end) ?? systemWidth);
    if (toX <= fromX) return;

    _addCurve(
      from: Offset(fromX + 0.2, y + (above ? -0.6 : 0.6)),
      to: Offset(toX - 0.2, y + (above ? -0.6 : 0.6)),
      above: above,
      role: ElementRole.tie,
      source: tie,
      height: 0.8,
    );
  }

  void _drawSlur(Slur slur, _ChordPlacement? start, _ChordPlacement? end) {
    final anchor = start ?? end!;
    // The side the file asked for, if it asked. Engraved music puts a slur
    // opposite the stems of the voice it belongs to, but a file that has
    // already made that decision has usually made it for a reason this cannot
    // see — a second voice on the staff, a phrase reaching over another.
    var above = switch (slur.placement) {
      Placement.above => true,
      Placement.below => false,
      null => switch (slur.orientation) {
        LineOrientation.over => true,
        LineOrientation.under => false,
        LineOrientation.auto => !anchor.stemUp,
      },
    };
    final fromX = start != null
        ? start.x + start.noteheadWidth / 2
        : (_xOffStaff(slur.start) ?? _continuedFromX);
    final toX = end != null
        ? end.x + end.noteheadWidth / 2
        : (_xOffStaff(slur.end) ?? systemWidth);
    if (toX <= fromX) return;

    // A grace note is slurred to the note it decorates, and the two stand a
    // notehead apart. Chasing the stem of a beamed chord takes that little arc
    // down past the beam and back up again, across everything between, so a
    // slur onto a grace note is written between the two nearest noteheads
    // instead — which is where an engraver draws it.
    final decorates =
        (slur.start is Chord && (slur.start as Chord).isGrace) ||
        (slur.end is Chord && (slur.end as Chord).isGrace);
    double? middleOf(_ChordPlacement? placement) =>
        placement == null ? null : (placement.topY + placement.bottomY) / 2;

    // The slur between a grace note and the note it decorates has to fit in
    // the space between them. Where the side the file asks for is taken by
    // another notehead of the same chord — under the top note of a close
    // chord there is nowhere to go — it is drawn on the other side instead.
    if (decorates && start != null && end != null) {
      final graceFirst = slur.start is Chord && (slur.start as Chord).isGrace;
      final main = graceFirst ? end : start;
      final grace = graceFirst ? start : end;
      final anchorY = _noteNearest(main, middleOf(grace), above: above);
      final blocked = main.notePositions.values.any((offset) {
        final away = offset.dy - anchorY;
        return above
            ? (away < -0.1 && away > -1.5)
            : (away > 0.1 && away < 1.5);
      });
      if (blocked) above = !above;
    }

    final towards = <_ChordPlacement, double?>{};
    if (start != null) towards[start] = middleOf(end ?? start);
    if (end != null) towards[end] = middleOf(start ?? end);

    // Where a slur meets a note it is written past the notehead, past the stem
    // when the stem is on the slur's own side, and past the staccato dot or
    // the accent on it: those go inside the slur, between it and the note.
    double reachOf(_ChordPlacement placement) {
      var reach = decorates
          ? _noteNearest(placement, towards[placement], above: above)
          : (above
                ? math.min(placement.topY, placement.stemEndY)
                : math.max(placement.bottomY, placement.stemEndY));
      for (final element in _elements) {
        if (!identical(element.owner, placement.chord)) continue;
        if (element.role != ElementRole.articulation) continue;
        final box = element.bounds;
        reach = above ? math.min(reach, box.top) : math.max(reach, box.bottom);
      }
      return reach;
    }

    // A slur running on from the system before hangs from nothing at that end,
    // so it takes its height from the music it arrives over rather than from
    // the note it eventually reaches, which may be a line's worth away.
    final air = above ? -1.0 : 1.0;
    var fromY = reachOf(start ?? _nearestPlacement(fromX) ?? anchor) + air;
    var toY = reachOf(end ?? _nearestPlacement(toX) ?? anchor) + air;

    final span = math.max(toX - fromX, 0.001);

    // Everything the slur passes over, taken from what is drawn rather than
    // from the notes alone: an accidental stands higher than the note it
    // belongs to, and a slur that cleared the noteheads was drawn straight
    // through the sharps between them. Its own two notes are not in the list —
    // it is written onto those.
    final obstacles = <({double x, double edge})>[];
    for (final element in _elements) {
      if (!_slurClears(element.role)) continue;

      // A beam is never counted as an endpoint's own mark: it belongs to the
      // whole run it crosses, and a slur starting on the first note of that
      // run still has to clear the rest of it.
      final owner = element.owner;
      if (element is! BeamElement &&
          owner != null &&
          (identical(owner, slur.start) || identical(owner, slur.end))) {
        continue;
      }
      for (final point in _outlineOf(element)) {
        if (point.x < fromX || point.x > toX) continue;
        obstacles.add((x: point.x, edge: above ? point.top : point.bottom));
      }
    }

    /// How far something at [edge] reaches past a slur drawn along [lineY],
    /// including the air a slur keeps over what it passes.
    double overshoot(double edge, double lineY) =>
        (above ? lineY - edge : edge - lineY) + style.slurGap;

    // Beside an endpoint the curve is pinned to the note it hangs from, and no
    // amount of arch clears something standing there. The end gives way
    // instead — by a couple of staff spaces at most, past which the slur has
    // come off the note it belongs to.
    var liftFrom = 0.0;
    var liftTo = 0.0;
    for (final obstacle in obstacles) {
      final t = (obstacle.x - fromX) / span;
      if (t < 0 || t > 1) continue;
      if (t > _slurShoulder && t < 1 - _slurShoulder) continue;
      final near = t < 0.5;
      final over = overshoot(obstacle.edge, near ? fromY : toY);
      if (over <= 0) continue;
      final lift = math.min(over, _maximumSlurLift);
      if (near) {
        liftFrom = math.max(liftFrom, lift);
      } else {
        liftTo = math.max(liftTo, lift);
      }
    }
    fromY += liftFrom * air;
    toY += liftTo * air;

    // A slur arches over everything it covers, not just over its two ends: a
    // curve drawn between the endpoints alone would run straight through the
    // notes in the middle of the phrase. It is the arch that grows to clear
    // them and not the ends — lifted at both ends to the height of the tallest
    // note under it, the slur comes away from the notes it joins, and there is
    // nothing left to show a player where the phrase begins.
    var clearance = 0.0;
    for (final obstacle in obstacles) {
      final t = (obstacle.x - fromX) / span;
      if (t < 0 || t > 1) continue;
      final over = overshoot(obstacle.edge, fromY + (toY - fromY) * t);
      if (over <= 0) continue;
      // Near an end, where the curve is pinned to its note and the arch has
      // barely begun, the same clearance costs many times the bulge: a slur
      // that tried to arch over a note beside its own would balloon over the
      // whole system to gain a fraction of a space beside it. That end has
      // already given way as far as it may, and what is left is a graze.
      if (t <= _slurShoulder || t >= 1 - _slurShoulder) continue;
      // Only part of the arch has grown by then: drawn with its control points
      // a bulge out at the quarters, the curve reaches 3t(1-t) of it.
      clearance = math.max(clearance, over / (3 * t * (1 - t)));
    }

    // A slur that begins or ends on a note another slur already hangs from is
    // drawn outside it. Two arches meeting at one notehead are a single line
    // with a kink in it, and nothing says which phrase is which.
    final drawn = [
      for (final element in _elements)
        if (element is CurveElement && element.role == ElementRole.slur)
          element,
    ];
    for (final other in drawn) {
      if ((other.start.dx - fromX).abs() < 0.5) {
        fromY = above
            ? math.min(fromY, other.start.dy - style.slurGap)
            : math.max(fromY, other.start.dy + style.slurGap);
      }
      if ((other.end.dx - toX).abs() < 0.5) {
        toY = above
            ? math.min(toY, other.end.dy - style.slurGap)
            : math.max(toY, other.end.dy + style.slurGap);
      }
    }

    // And the arch goes outside theirs all the way along, not merely over the
    // middle of it: two slurs from the same note part company at once, and it
    // is close to the note that the outer one has the least room to climb.
    for (final other in drawn) {
      for (var i = 0; i <= _slurSamples; i++) {
        final point = other.pointAt(i / _slurSamples);
        final t = (point.dx - fromX) / span;
        // Not at the ends: two slurs that share a note meet there, and no
        // arch can be drawn around a point it is pinned to.
        if (t <= _slurShoulder || t >= 1 - _slurShoulder) continue;
        final chordY = fromY + (toY - fromY) * t;
        final over =
            (above ? chordY - point.dy : point.dy - chordY) + style.slurGap;
        if (over <= 0) continue;
        clearance = math.max(clearance, over / (3 * t * (1 - t)));
      }
    }

    _addCurve(
      from: Offset(fromX, fromY),
      to: Offset(toX, toY),
      above: above,
      role: ElementRole.slur,
      source: slur,
      height: style.slurHeight,
      // However much is under it, a slur cannot bow much further than it is
      // long. The stub of one arriving from the system before is a few staff
      // spaces wide, and asked to clear the music beneath the whole of it, it
      // came out as a loop hanging off its own note.
      minimum: math.min(clearance, math.max(style.slurHeight, span / 2)),
    );
  }

  /// Where an event of this part sits in this system, wherever it is drawn.
  ///
  /// A slur may run from one hand of a keyboard to the other, and then one of
  /// its notes is on a staff this builder knows nothing about. The x it sits
  /// at is the same for every staff of the system, so it can still be found.
  double? _xOffStaff(MusicalEvent event) {
    for (final entry in _entries) {
      for (final other in entry.measure.events) {
        if (identical(other, event)) return entry.slot.xFor(event.position);
      }
    }
    return null;
  }

  /// The middle of the staff space at or beyond [y], measured outwards.
  ///
  /// Staff positions count half spaces from the bottom line, so the middle of
  /// a space is an odd one; a mark asked for on a line is moved to the space
  /// past it rather than drawn across it.
  double _spaceBeyond(double y, {required bool above}) {
    final position = ((_geometry.bottom - y) * 2).round();
    final space = position.isOdd ? position : position + (above ? 1 : -1);
    return _geometry.yForStaffPosition(space);
  }

  /// The notehead of [placement] nearest [y], or its outer edge when there is
  /// nothing to be near.
  double _noteNearest(
    _ChordPlacement placement,
    double? y, {
    required bool above,
  }) {
    if (y == null) return above ? placement.topY : placement.bottomY;
    var best = above ? placement.topY : placement.bottomY;
    var distance = double.infinity;
    for (final offset in placement.notePositions.values) {
      final away = (offset.dy - y).abs();
      if (away >= distance) continue;
      distance = away;
      best = offset.dy;
    }
    return best;
  }

  /// The chord drawn nearest [x] on this staff, if any.
  _ChordPlacement? _nearestPlacement(double x) {
    _ChordPlacement? found;
    var best = double.infinity;
    for (final placement in _placements.values) {
      final away = (placement.x - x).abs();
      if (away >= best) continue;
      best = away;
      found = placement;
    }
    return found;
  }

  /// Whether a slur has to be drawn clear of a mark, rather than across it.
  ///
  /// What a reader has to tell apart from the phrase mark over it: the notes
  /// themselves and everything written tight against them.
  static bool _slurClears(ElementRole role) => switch (role) {
    ElementRole.notehead ||
    ElementRole.accidental ||
    ElementRole.augmentationDot ||
    ElementRole.flag ||
    ElementRole.stem ||
    ElementRole.beam ||
    ElementRole.rest ||
    ElementRole.articulation ||
    ElementRole.ornament => true,
    _ => false,
  };

  /// How near an end a note has to stand before a slur's end gives way to it
  /// rather than its arch.
  static const double _slurShoulder = 0.15;

  /// How far from the note it hangs from a slur's end is drawn at most.
  static const double _maximumSlurLift = 1.5;

  /// How many points of a slur already drawn the next one is arched over.
  static const int _slurSamples = 16;

  /// How many points of a beam anything clearing it is measured against.
  static const int _beamSamples = 12;

  /// Where an element's ink lies, sampled across its width.
  ///
  /// Everything but a beam is measured by the box around it, which is close
  /// enough for a notehead or an accidental. A beam is not: it is a sloping
  /// stroke, and the box around a steep one covers most of a staff, so
  /// anything keeping clear of it would be pushed away from ink that is
  /// nowhere near. It is measured along its own slope instead.
  List<({double x, double top, double bottom})> _outlineOf(
    LayoutElement element,
  ) {
    if (element is! BeamElement) {
      final box = element.bounds;
      return [
        (x: box.left, top: box.top, bottom: box.bottom),
        (x: box.right, top: box.top, bottom: box.bottom),
      ];
    }
    final span = element.right.dx - element.left.dx;
    final points = <({double x, double top, double bottom})>[];
    for (var i = 0; i <= _beamSamples; i++) {
      final x = element.left.dx + span * i / _beamSamples;
      final centre = span == 0
          ? element.left.dy
          : element.left.dy +
                (element.right.dy - element.left.dy) *
                    (x - element.left.dx) /
                    span;
      points.add((
        x: x,
        top: centre - element.thickness / 2,
        bottom: centre + element.thickness / 2,
      ));
    }
    return points;
  }

  void _addCurve({
    required Offset from,
    required Offset to,
    required bool above,
    required ElementRole role,
    required Object source,
    required double height,
    double minimum = 0,
  }) {
    // Measured along the line between the ends rather than across the page: a
    // slur from a low note to a high one covers more ground than its width
    // suggests, and one bowed only as far as its width would be flat.
    final chord = (to - from).distance;
    // A short slur is bowed less than a long one, however much room there is
    // for it; [minimum] is what it takes to clear the notes underneath, which
    // is not a matter of taste.
    final bulge =
        math.max(math.min(height, 0.4 + chord * 0.12), minimum) *
        (above ? -1 : 1);
    // The bow is taken from the line joining the ends, not from each end in
    // turn. Offsetting the control points from the endpoints leaves a steep
    // slur as a diagonal with a kink in it, which reads as a slide.
    final quarter = Offset.lerp(from, to, 0.25)!;
    final threeQuarters = Offset.lerp(from, to, 0.75)!;
    _elements.add(
      CurveElement(
        start: from,
        end: to,
        control1: Offset(quarter.dx, quarter.dy + bulge),
        control2: Offset(threeQuarters.dx, threeQuarters.dy + bulge),
        thickness: style.lines.slurMidpointThickness,
        endThickness: style.lines.slurEndpointThickness,
        role: role,
        source: source,
      ),
    );
  }

  /// How far what is already drawn between [left] and [right] reaches, on the
  /// side [above] names.
  double _drawnReach(
    double left,
    double right, {
    required bool above,
    bool ignoreTuplets = true,
  }) {
    var reach = above ? double.infinity : double.negativeInfinity;
    for (final element in _elements) {
      if (element.role == ElementRole.staffLine ||
          element.role == ElementRole.ledgerLine ||
          (ignoreTuplets && element.role == ElementRole.tuplet)) {
        continue;
      }
      final box = element.bounds;
      if (box.right < left - 0.1 || box.left > right + 0.1) continue;
      reach = above ? math.min(reach, box.top) : math.max(reach, box.bottom);
    }
    return reach.isFinite ? reach : (above ? 0 : _geometry.height);
  }

  void _drawTuplet(
    Tuplet tuplet,
    _ChordPlacement? start,
    _ChordPlacement? end,
  ) {
    if (start == null || end == null) return;
    final above = tuplet.placement == Placement.above;
    final label = tuplet.normalNotes == 2 && tuplet.actualNotes == 3
        ? '${tuplet.actualNotes}'
        : '${tuplet.actualNotes}:${tuplet.normalNotes}';

    final left = start.x;
    final right = end.x + end.noteheadWidth;

    // Clear everything the bracket passes over, not just the noteheads: it
    // belongs above the beam, and above the trills and accents on the notes
    // under it, which is where it used to be drawn straight through them.
    final reach = [
      start.topY,
      end.topY,
      start.bottomY,
      end.bottomY,
      start.stemEndY,
      end.stemEndY,
      _drawnReach(left, right, above: above),
    ];
    // The hooks hang back towards the music, so a bracket has to stand off by
    // its own height and not merely by a gap, or they come down into whatever
    // it was clearing. A number written on its own — which is what a beamed
    // tuplet is given, and what most files ask for — needs no such room, and
    // given it, the figure floats away from the notes it counts.
    final bracketed = tuplet.bracket ?? true;
    final clearance = bracketed
        ? style.tupletBracketHeight + style.lines.tupletBracketThickness + 0.4
        : style.articulationGap;
    final y = above
        ? reach.reduce(math.min) - clearance
        : reach.reduce(math.max) + clearance;
    final size = metrics.measureText(
      label,
      fontSize: style.textFontSize * 0.85,
      italic: true,
    );

    if (bracketed) {
      final hook = above
          ? style.tupletBracketHeight
          : -style.tupletBracketHeight;
      final midpoint = (left + right) / 2;
      _elements
        ..add(
          PolygonElement(
            points: [
              Offset(left, y + hook),
              Offset(left, y),
              Offset(midpoint - size.width, y),
            ],
            role: ElementRole.tuplet,
            filled: false,
            thickness: style.lines.tupletBracketThickness,
            source: tuplet,
          ),
        )
        ..add(
          PolygonElement(
            points: [
              Offset(midpoint + size.width, y),
              Offset(right, y),
              Offset(right, y + hook),
            ],
            role: ElementRole.tuplet,
            filled: false,
            thickness: style.lines.tupletBracketThickness,
            source: tuplet,
          ),
        );
    }

    if (tuplet.showNumber) {
      // Inside the bracket's own gap when there is one, and otherwise resting
      // against the music: the figure hangs from its baseline, so above the
      // notes that is the line itself and below it is a line's height down.
      final baseline = bracketed
          ? y + (above ? 0.4 : 0.2)
          : (above ? y : y + style.textFontSize * 0.85 * 0.8);
      _elements.add(
        TextElement(
          text: label,
          origin: Offset((left + right) / 2, baseline),
          fontSize: style.textFontSize * 0.85,
          alignment: TextAlignment.center,
          italic: true,
          role: ElementRole.tuplet,
          measuredWidth: size.width,
          source: tuplet,
        ),
      );
    }
  }

  /// Joins each hairpin's start to its stop and draws the pair of lines.
  void _drawWedges() {
    _PendingWedge? open;
    for (final pending in _pendingWedges) {
      switch (pending.wedge.type) {
        case WedgeType.crescendo:
        case WedgeType.diminuendo:
          open = pending;
        case WedgeType.stop:
          if (open == null) continue;
          _addWedge(open, pending.x);
          open = null;
        case WedgeType.wedgeContinue:
          break;
      }
    }
    if (open != null) _addWedge(open, systemWidth);
  }

  void _addWedge(_PendingWedge open, double endX) {
    if (endX <= open.x) return;
    final spread = (open.wedge.spread ?? 15) / 10;
    final growing = open.wedge.type == WedgeType.crescendo;
    final y = open.y;
    final left = growing
        ? [Offset(open.x, y), Offset(endX, y - spread / 2)]
        : [Offset(open.x, y - spread / 2), Offset(endX, y)];
    final right = growing
        ? [Offset(open.x, y), Offset(endX, y + spread / 2)]
        : [Offset(open.x, y + spread / 2), Offset(endX, y)];
    _elements
      ..add(
        PolygonElement(
          points: left,
          role: ElementRole.wedge,
          filled: false,
          thickness: style.lines.hairpinThickness,
          source: open.direction,
        ),
      )
      ..add(
        PolygonElement(
          points: right,
          role: ElementRole.wedge,
          filled: false,
          thickness: style.lines.hairpinThickness,
          source: open.direction,
        ),
      );
  }

  Offset? _noteAt(_ChordPlacement placement, int index, MusicalEvent event) {
    if (event is! Chord) return null;
    if (index < 0 || index >= event.notes.length) return null;
    return placement.notePositions[event.notes[index]];
  }

  static Color? _parseColor(String? value) {
    if (value == null || !value.startsWith('#')) return null;
    final hex = value.substring(1);
    final parsed = int.tryParse(hex, radix: 16);
    if (parsed == null) return null;
    return hex.length <= 6 ? Color(0xFF000000 | parsed) : Color(parsed);
  }
}

/// Where a chord's noteheads and stem ended up.
class _ChordPlacement {
  _ChordPlacement({
    required this.chord,
    required this.x,
    required this.noteheadWidth,
    required this.stemUp,
    required this.topY,
    required this.bottomY,
    required this.scale,
    required this.notePositions,
    this.tablature = false,
  });

  final double x;
  final double noteheadWidth;
  final bool stemUp;

  /// y of the highest notehead; smaller than [bottomY] because y grows down.
  final double topY;
  final double bottomY;

  final double scale;
  final Map<Note, Offset> notePositions;

  /// The chord these came from.
  final Chord chord;

  /// Whether it was written as fret numbers, which have no stem to hang a
  /// beam or a flag from.
  final bool tablature;

  double stemX = 0;
  double stemEndY = 0;
  bool stemDrawn = false;
}

class _PendingLyric {
  _PendingLyric({
    required this.lyric,
    required this.chord,
    required this.x,
  });

  final Lyric lyric;
  final Chord chord;

  /// Centre of the notehead the syllable belongs to.
  final double x;
}

class _PendingDirection {
  _PendingDirection({
    required this.direction,
    required this.x,
  });

  final Direction direction;
  final double x;
}

/// One part of a written chord symbol.
sealed class _ChordPiece {
  const _ChordPiece(
    this.width,
  );

  final double width;
}

class _ChordText extends _ChordPiece {
  const _ChordText(
    this.text,
    super.width,
  );

  final String text;
}

class _ChordGlyph extends _ChordPiece {
  const _ChordGlyph(
    this.glyph,
    this.scale,
    super.width,
  );

  final SmuflGlyph glyph;
  final double scale;
}

class _PendingChord {
  _PendingChord(
    this.harmony,
    this.x,
  );

  final Harmony harmony;
  final double x;
}

class _PendingWedge {
  _PendingWedge(
    this.wedge,
    this.x,
    this.y,
    this.direction,
  );

  final WedgeDirection wedge;
  final double x;
  final double y;
  final Direction direction;
}

/// One volta bracket, as far as it runs across one system.
class _EndingSpan {
  _EndingSpan({
    required this.ending,
    required this.left,
    required this.right,
    required this.opens,
  });

  final Ending ending;
  final double left;
  double right;

  /// Whether the bracket begins here, and so is hooked and numbered.
  final bool opens;

  /// Whether it is closed off here by a hook of its own.
  bool closes = false;
}
