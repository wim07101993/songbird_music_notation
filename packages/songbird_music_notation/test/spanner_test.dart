import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/songbird_score.dart';

import 'support/showcase.dart';

/// Slurs and ties: where they hang from and what they arch over.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadShowcase);

  test('a slur arches over the notes it covers, however steep it is', () {
    // Bowed away from each end rather than from the line between them, a slur
    // between notes far apart in pitch comes out as a diagonal with a kink in
    // it, which reads as a slide.
    final slurs = <CurveElement>[];
    for (final staff in showcaseStaves()) {
      slurs.addAll(
        staff.elements.whereType<CurveElement>().where(
          (element) => element.role == ElementRole.slur,
        ),
      );
    }
    expect(slurs, isNotEmpty);
    for (final slur in slurs) {
      final chord = slur.end - slur.start;
      for (final control in [slur.control1, slur.control2]) {
        // Each control point sits off the line joining the ends, on the side
        // the slur bows towards, rather than off one end of it.
        final along = control - slur.start;
        final t = chord.dx == 0 ? 0.5 : along.dx / chord.dx;
        final onChord = slur.start + chord * t;
        expect((control.dy - onChord.dy).abs(), greaterThan(0.2));
      }
    }
  });

  test('a slur arches over the accidentals it passes, not just the notes', () {
    // The arch was measured against the noteheads under it. A flat stands most
    // of a staff space higher than the note it belongs to, so a slur that
    // cleared the heads was drawn straight through the accidentals between
    // them — and worst near the ends, where the arch has barely begun.
    final part = Part(id: 'P1', name: 'Flute');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.treble;
    final chords = <Chord>[];
    for (var i = 0; i < 8; i++) {
      final flattened = i == 1 || i == 6;
      final chord = Chord(
        position: Fraction(i, 8),
        rhythm: const RhythmicDuration(NoteType.eighth),
        stem: StemDirection.down,
        notes: [
          Note(
            pitch: Pitch.parse(flattened ? 'Bb5' : 'B5'),
            accidental: flattened
                ? const Accidental(AccidentalType.flat)
                : null,
          ),
        ],
      );
      chords.add(chord);
      measure.add(chord);
    }
    part.measures.add(measure);
    part.spanners.add(Slur(start: chords.first, end: chords.last));

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final curve = staff.elements.whereType<CurveElement>().firstWhere(
      (element) => element.role == ElementRole.slur,
    );

    var checked = 0;
    for (final element in staff.elements) {
      if (element.role != ElementRole.accidental) continue;
      checked++;
      final box = element.bounds.deflate(0.05);
      for (var i = 0; i <= 60; i++) {
        expect(
          box.contains(curve.pointAt(i / 60)),
          isFalse,
          reason: 'the slur was drawn through an accidental',
        );
      }
    }
    expect(checked, 2);
  });

  test('a slur between the staves of an instrument is drawn once', () {
    // A staff is engraved on its own and knows nothing of the one beneath it,
    // so a slur from the left hand of a keyboard up to the right came out as
    // two halves, one on each staff, each running off to the edge of the page.
    final piano = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(2, 4)
      ..staves = 2
      ..clefs[1] = Clef.treble
      ..clefs[2] = Clef.bass;
    final bass = Chord(
      position: Fraction.zero,
      rhythm: const RhythmicDuration(NoteType.quarter),
      staff: 2,
      voice: 2,
      notes: [Note(pitch: Pitch.parse('C3'))],
    );
    final treble = Chord(
      position: Fraction(1, 4),
      rhythm: const RhythmicDuration(NoteType.quarter),
      notes: [Note(pitch: Pitch.parse('G4'))],
    );
    measure
      ..add(bass)
      ..add(treble);
    piano.measures.add(measure);
    piano.spanners.add(Slur(start: bass, end: treble));

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [piano]), width: 60);
    final system = built.systems.single;
    expect(system.staves, hasLength(2));

    for (final staff in system.staves) {
      expect(
        staff.elements.where((element) => element.role == ElementRole.slur),
        isEmpty,
        reason: 'staff ${staff.staffNumber} drew half of a slur',
      );
    }

    final curve = system.elements.whereType<CurveElement>().singleWhere(
      (element) => element.role == ElementRole.slur,
    );

    // It joins the two notes rather than running to the page edge: each end is
    // over the notehead it belongs to, on that notehead's own staff.
    Rect headOn(int number, Chord chord) => system.staves
        .firstWhere((staff) => staff.staffNumber == number)
        .elements
        .firstWhere(
          (element) =>
              element.role == ElementRole.notehead &&
              identical(element.owner, chord),
        )
        .bounds
        .translate(
          0,
          system.staves
                  .firstWhere((staff) => staff.staffNumber == number)
                  .pageTop -
              system.top,
        );

    final low = headOn(2, bass);
    final high = headOn(1, treble);
    expect(curve.start.dx, closeTo(low.center.dx, 0.6));
    expect(curve.end.dx, closeTo(high.center.dx, 0.6));
    expect(curve.start.dy, lessThan(low.top));
    expect(curve.end.dy, greaterThan(high.bottom));
  });

  test('a curve is bowed to the side the file asked for', () {
    // Engraved music puts a slur opposite the stems and a tie away from the
    // notehead, but a file that has already made that choice has usually made
    // it for a reason layout cannot see — a second voice, notes above the tie.
    final part = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.bass;
    final chords = [
      for (var i = 0; i < 2; i++)
        Chord(
          position: Fraction(i, 4),
          rhythm: const RhythmicDuration(NoteType.quarter),
          stem: StemDirection.up,
          notes: [Note(pitch: Pitch.parse('G2'), tied: true)],
        ),
    ];
    for (final chord in chords) {
      measure.add(chord);
    }
    part.measures.add(measure);
    // Both would be bowed the other way if the stems decided it.
    part.spanners.add(
      Slur(start: chords.first, end: chords.last, placement: Placement.above),
    );
    part.spanners.add(
      Tie(
        start: chords.first,
        end: chords.last,
        startNoteIndex: 0,
        endNoteIndex: 0,
        orientation: LineOrientation.under,
      ),
    );

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final curves = built.systems.single.staves.single.elements
        .whereType<CurveElement>();
    final slur = curves.firstWhere(
      (element) => element.role == ElementRole.slur,
    );
    final tie = curves.firstWhere((element) => element.role == ElementRole.tie);
    expect(slur.control1.dy, lessThan(slur.start.dy), reason: 'slur above');
    expect(tie.control1.dy, greaterThan(tie.start.dy), reason: 'tie below');
  });

  test('a slur over a beamed run arches over the beam', () {
    // The beam belongs to the whole run, so it was counted as the first note's
    // own mark and left out of what the slur has to clear — and a beam is
    // measured along its slope, not by the box around it, which for a steep
    // one is most of a staff.
    final part = Part(id: 'P1', name: 'Flute');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(2, 4)
      ..clefs[1] = Clef.treble;
    // A beamed run high in the staff, then a note well below it: the beam
    // stands above the line between the slur's two ends, so the slur has to
    // climb over it.
    final chords = <Chord>[];
    for (var i = 0; i < 4; i++) {
      final chord = Chord(
        position: Fraction(i, 16),
        rhythm: const RhythmicDuration(NoteType.sixteenth),
        stem: StemDirection.up,
        notes: [
          Note(pitch: Pitch.parse(const ['A4', 'B4', 'A4', 'B4'][i])),
        ],
        beams: [
          for (var level = 1; level <= 2; level++)
            Beam(
              level: level,
              state: switch (i) {
                0 => BeamState.begin,
                3 => BeamState.end,
                _ => BeamState.continueBeam,
              },
            ),
        ],
      );
      chords.add(chord);
      measure.add(chord);
    }
    final last = Chord(
      position: Fraction(1, 4),
      rhythm: const RhythmicDuration(NoteType.quarter),
      stem: StemDirection.up,
      notes: [Note(pitch: Pitch.parse('C4'))],
    );
    chords.add(last);
    measure.add(last);
    part.measures.add(measure);
    part.spanners.add(
      Slur(start: chords.first, end: last, placement: Placement.above),
    );

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final curve = staff.elements.whereType<CurveElement>().firstWhere(
      (element) => element.role == ElementRole.slur,
    );

    for (final beam in staff.elements.whereType<BeamElement>()) {
      final span = beam.right.dx - beam.left.dx;
      for (var i = 0; i <= 60; i++) {
        final point = curve.pointAt(i / 60);
        if (point.dx < beam.left.dx || point.dx > beam.right.dx) continue;
        final centre =
            beam.left.dy +
            (beam.right.dy - beam.left.dy) * (point.dx - beam.left.dx) / span;
        expect(
          (point.dy - centre).abs(),
          greaterThan(beam.thickness / 2),
          reason: 'the slur was drawn through the beam',
        );
      }
    }
  });

  test('a slur over a slur is drawn outside it', () {
    // A phrase mark over a shorter slur used to be drawn at the same height as
    // it: two arches over the same notes, crossing twice, and nothing to say
    // which phrase is which.
    final part = Part(id: 'P1', name: 'Flute');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.treble;
    final chords = [
      for (final pitch in const ['C4', 'E4', 'G4', 'E4'])
        Chord(
          position: Fraction(const ['C4', 'E4', 'G4', 'E4'].indexOf(pitch), 4),
          rhythm: const RhythmicDuration(NoteType.quarter),
          notes: [Note(pitch: Pitch.parse(pitch))],
        ),
    ];
    for (final chord in chords) {
      measure.add(chord);
    }
    part.measures.add(measure);
    part.spanners.add(Slur(start: chords.first, end: chords[1]));
    part.spanners.add(Slur(start: chords.first, end: chords.last));

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final curves = built.systems.single.staves.single.elements
        .whereType<CurveElement>()
        .where((element) => element.role == ElementRole.slur)
        .toList();
    expect(curves, hasLength(2));

    // The two are sampled along the stretch they share; the outer one is on
    // the far side of the inner one at every point of it.
    final inner = curves.firstWhere((c) => c.end.dx < c.start.dx + 20);
    final outer = curves.firstWhere((c) => !identical(c, inner));
    final above = outer.control1.dy < outer.start.dy;
    for (var i = 0; i <= 16; i++) {
      final point = inner.pointAt(i / 16);
      final t = (point.dx - outer.start.dx) / (outer.end.dx - outer.start.dx);
      if (t < 0 || t > 1) continue;
      final theirs = outer.pointAt(t);
      expect(
        above ? theirs.dy < point.dy : theirs.dy > point.dy,
        isTrue,
        reason: 'the slurs cross at ${point.dx.toStringAsFixed(1)}',
      );
    }
  });
}
