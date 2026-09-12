import 'package:flutter/painting.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/songbird_score.dart';

import 'support/showcase.dart';

/// What happens when several voices share one staff.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadShowcase);

  test('the beams of two voices are stacked, not laid on each other', () {
    // A condensed staff carries a beamed run in each voice. Each was left the
    // same distance above its own notes, so two runs a third apart came out
    // with their beams touching and their stems on the same line.
    final part = Part(id: 'P1', name: 'Ensemble');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(2, 4)
      ..clefs[1] = Clef.treble;
    for (var voice = 1; voice <= 2; voice++) {
      for (var i = 0; i < 4; i++) {
        measure.add(
          Chord(
            position: Fraction(i, 16),
            rhythm: const RhythmicDuration(NoteType.sixteenth),
            voice: voice,
            stem: StemDirection.up,
            notes: [Note(pitch: Pitch.parse(voice == 1 ? 'E5' : 'C5'))],
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
          ),
        );
      }
    }
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final beams = staff.elements.whereType<BeamElement>().toList();
    expect(beams, hasLength(4));
    final upper = beams
        .where((beam) => (beam.owner! as Chord).voice == 1)
        .toList();
    final lower = beams
        .where((beam) => (beam.owner! as Chord).voice == 2)
        .toList();
    final above = upper
        .map((beam) => beam.bounds)
        .reduce((a, b) => a.expandToInclude(b));
    final below = lower
        .map((beam) => beam.bounds)
        .reduce((a, b) => a.expandToInclude(b));
    expect(
      above.overlaps(below),
      isFalse,
      reason: 'the two stacks of beams were drawn into each other',
    );

    // And each voice's beam is still clear of the other's noteheads.
    for (final beam in beams) {
      for (final element in staff.elements) {
        if (element.role != ElementRole.notehead) continue;
        expect(
          beam.bounds.deflate(0.05).overlaps(element.bounds),
          isFalse,
          reason: 'a beam was drawn across a notehead',
        );
      }
    }
  });

  test('the rests of two voices are not written on top of each other', () {
    // A condensed score puts three or four voices on a staff, and they rest
    // together often. Each in turn steps below what is already written —
    // including the notes the other voices are playing at that moment.
    final part = Part(id: 'P1', name: 'Ensemble');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.treble;
    measure.add(
      Chord(
        position: Fraction.zero,
        rhythm: const RhythmicDuration(NoteType.quarter),
        stem: StemDirection.up,
        notes: [Note(pitch: Pitch.parse('G4'))],
      ),
    );
    for (var voice = 2; voice <= 4; voice++) {
      measure.add(
        Rest(
          position: Fraction.zero,
          rhythm: const RhythmicDuration(NoteType.quarter),
          voice: voice,
        ),
      );
    }
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final rests = staff.elements
        .where((element) => element.role == ElementRole.rest)
        .toList();
    expect(rests, hasLength(3));

    for (var i = 0; i < rests.length; i++) {
      for (var j = i + 1; j < rests.length; j++) {
        expect(
          rests[i].bounds.overlaps(rests[j].bounds),
          isFalse,
          reason: 'two rests were written in the same place',
        );
      }
      for (final element in staff.elements) {
        if (element.role != ElementRole.notehead &&
            element.role != ElementRole.stem) {
          continue;
        }
        expect(
          rests[i].bounds.deflate(0.05).overlaps(element.bounds),
          isFalse,
          reason: 'a rest was written across a ${element.role.name}',
        );
      }
    }
  });

  test('two voices on a staff keep their marks outside the pair', () {
    // The lower voice's staccato written above its notes lands among the upper
    // voice's, and reads as belonging to them.
    final part = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.treble;
    final upper = Chord(
      position: Fraction.zero,
      rhythm: const RhythmicDuration(NoteType.quarter),
      stem: StemDirection.up,
      notes: [Note(pitch: Pitch.parse('G5'))],
    );
    final lower = Chord(
      position: Fraction.zero,
      rhythm: const RhythmicDuration(NoteType.quarter),
      voice: 2,
      stem: StemDirection.down,
      notes: [Note(pitch: Pitch.parse('B4'))],
      articulations: const [Articulation.staccato],
    );
    measure
      ..add(upper)
      ..add(lower);
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final dot = staff.elements.firstWhere(
      (element) => element.role == ElementRole.articulation,
    );
    final stem = staff.elements.firstWhere(
      (element) =>
          element.role == ElementRole.stem && identical(element.owner, lower),
    );
    expect(
      dot.bounds.top,
      greaterThan(stem.bounds.bottom),
      reason: 'the mark was written inside the pair of voices',
    );
  });

  test('a mark on a beamed note is set clear of the beam', () {
    // The marks that hang off a note used to be placed while the chord was
    // drawn, before the beams existed: a beamed note's stem is only as long as
    // its beam turns out to need, and a mark set against the provisional
    // length was left inside the beam.
    final part = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(2, 4)
      ..clefs[1] = Clef.treble;
    // An upper voice to make the staff a shared one, which is what puts the
    // lower voice's marks out past its stems.
    measure.add(
      Chord(
        position: Fraction.zero,
        rhythm: const RhythmicDuration(NoteType.half),
        stem: StemDirection.up,
        notes: [Note(pitch: Pitch.parse('G5'))],
      ),
    );
    final lower = <Chord>[];
    for (var i = 0; i < 4; i++) {
      final chord = Chord(
        position: Fraction(i, 16),
        rhythm: const RhythmicDuration(NoteType.sixteenth),
        voice: 2,
        stem: StemDirection.down,
        notes: [
          Note(pitch: Pitch.parse(const ['B4', 'G5', 'B4', 'G5'][i])),
        ],
        articulations: const [Articulation.staccato],
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
      lower.add(chord);
      measure.add(chord);
    }
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final beams = staff.elements.whereType<BeamElement>().toList();
    expect(beams, isNotEmpty);

    for (final mark in staff.elements) {
      if (mark.role != ElementRole.articulation) continue;
      for (final beam in beams) {
        // Against the beam's own slope: the box around a sloping one covers
        // ground its ink never reaches.
        final span = beam.right.dx - beam.left.dx;
        final x = mark.bounds.center.dx;
        if (x < beam.left.dx || x > beam.right.dx) continue;
        final centre =
            beam.left.dy +
            (beam.right.dy - beam.left.dy) * (x - beam.left.dx) / span;
        expect(
          mark.bounds.top,
          greaterThan(centre + beam.thickness / 2 - 0.01),
          reason: 'a staccato was written inside the beam',
        );
      }
    }
  });

  test("two voices a second apart step out of each other's way", () {
    // Written at the same x they are one notehead with two stems, and neither
    // voice can be read. The down-stem voice steps to the left, since the
    // up-stem voice's noteheads belong against its stems on the right.
    final part = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.treble;
    final upper = Chord(
      position: Fraction.zero,
      rhythm: const RhythmicDuration(NoteType.quarter),
      stem: StemDirection.up,
      notes: [Note(pitch: Pitch.parse('C5'))],
    );
    final lower = Chord(
      position: Fraction.zero,
      rhythm: const RhythmicDuration(NoteType.quarter),
      voice: 2,
      stem: StemDirection.down,
      notes: [Note(pitch: Pitch.parse('B4'))],
    );
    measure
      ..add(upper)
      ..add(lower);
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    Rect headOf(Chord chord) => staff.elements
        .firstWhere(
          (element) =>
              element.role == ElementRole.notehead &&
              identical(element.owner, chord),
        )
        .bounds;

    final high = headOf(upper);
    final low = headOf(lower);
    expect(low.overlaps(high), isFalse);
    expect(low.right, lessThanOrEqualTo(high.left + 0.01));

    // And the room it steps into was reserved: it stays inside its measure.
    expect(low.left, greaterThan(built.systems.single.measures.single.left));
  });
}
