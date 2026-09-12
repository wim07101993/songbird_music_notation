import 'dart:math' as math;

import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/songbird_score.dart';

import 'support/showcase.dart';

/// The marks that are not notes, and the heights they find.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadShowcase);

  test('marks that do not collide share a line', () {
    // Each direction used to be stacked outwards from the last, so a page of
    // dynamics walked steadily down the score: the p in the first measure and
    // the ff in the third ended up at two different heights for no reason a
    // reader could see.
    final staff = wide.systems.single.staves.firstWhere(
      (staff) => staff.part.name == 'Voice',
    );
    final dynamics = staff.elements
        .whereType<GlyphElement>()
        .where((element) => element.role == ElementRole.dynamics)
        .toList();
    expect(dynamics, hasLength(greaterThan(1)));
    // Their feet, not their boxes: a p and an ff stand on the same line and
    // are not the same height.
    expect(
      dynamics
          .map(
            (e) =>
                (e.origin.dy - metrics.glyphBottom(e.glyph)).toStringAsFixed(2),
          )
          .toSet(),
      hasLength(1),
    );
  });

  test('several marks in one direction are printed in a row', () {
    // A segno and a coda given together used to be drawn one on top of the
    // other, because each took the direction's x rather than following on.
    final glyphs = <GlyphElement>[];
    for (final staff in showcaseStaves()) {
      for (final element in staff.elements) {
        if (element is! GlyphElement) continue;
        if (element.glyph == NotationGlyphs.segno ||
            element.glyph == NotationGlyphs.coda) {
          glyphs.add(element);
        }
      }
    }
    expect(glyphs, hasLength(2));
    final xs = glyphs.map((g) => g.origin.dx).toList()..sort();
    expect(xs.last - xs.first, greaterThan(1));
  });

  test('a tempo mark draws its beat from the music font', () {
    // Written as the character U+2669 it comes out at the size of a letter,
    // and on most machines it does not come out at all.
    final staff = wide.systems.single.staves.first;
    final beats = staff.elements.whereType<GlyphElement>().where(
      (element) =>
          element.glyph == NotationGlyphs.metronomeNote(NoteType.quarter),
    );
    expect(beats, hasLength(1));
    final text = staff.elements.whereType<TextElement>().map(
      (element) => element.text,
    );
    expect(text, isNot(contains(contains('\u2669'))));
    expect(text, contains(' = 88'));
  });

  test('a tempo mark reads along its note', () {
    // The note is three times the height of the words. Lining their blocks up
    // leaves the "= 88" floating well above the notehead it belongs to.
    final staff = wide.systems.single.staves.first;
    final beat = staff.elements.whereType<GlyphElement>().firstWhere(
      (element) =>
          element.glyph == NotationGlyphs.metronomeNote(NoteType.quarter),
    );
    final text = staff.elements.whereType<TextElement>().firstWhere(
      (element) => element.text.trim() == '= 88',
    );
    // The foot of the note and the baseline of the words are one line.
    expect(
      text.origin.dy,
      closeTo(beat.origin.dy - metrics.glyphBottom(beat.glyph) * 0.75, 0.01),
      reason: 'the words stand on the foot of the note, not above it',
    );
  });

  test('a staccato dot sits under the middle of its notehead', () {
    // Placed by its origin the dot lands beside the note and inside the staff:
    // the glyph is neither centred on its origin nor started at it.
    final staff = wide.systems.single.staves.first;
    final dot = staff.elements.whereType<GlyphElement>().firstWhere(
      (element) => element.role == ElementRole.articulation,
    );
    final chord = dot.owner;
    final head = staff.elements.whereType<GlyphElement>().firstWhere(
      (element) =>
          element.role == ElementRole.notehead &&
          identical(element.owner, chord),
    );
    final drawnLeft = dot.origin.dx + metrics.glyphLeft(dot.glyph);
    expect(
      drawnLeft + dot.size.width / 2,
      closeTo(head.origin.dx + head.size.width / 2, 0.05),
    );
    // And clear of the staff rather than sitting on the bottom line.
    final top = dot.origin.dy - metrics.glyphTop(dot.glyph);
    expect(top, greaterThan(staff.geometry.lineY(1)));
  });

  test('a staccato is written against its note, not above the staff', () {
    // Set clear of the whole staff, the dot on a note in the middle of it
    // ended up four spaces above, with nothing in between to say what it
    // belonged to.
    final part = Part(id: 'P1', name: 'Flute');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.treble;
    final chord = Chord(
      position: Fraction.zero,
      rhythm: const RhythmicDuration(NoteType.quarter),
      stem: StemDirection.up,
      notes: [Note(pitch: Pitch.parse('B4'))],
      articulations: const [Articulation.staccato],
    );
    measure.add(chord);
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final head = staff.elements.firstWhere(
      (element) => element.role == ElementRole.notehead,
    );
    final dot = staff.elements.firstWhere(
      (element) => element.role == ElementRole.articulation,
    );

    // Below the note, since the stem is above it, and within a space of it.
    expect(dot.bounds.top, greaterThan(head.bounds.bottom));
    expect(dot.bounds.top - head.bounds.bottom, lessThan(1.2));
    expect(
      dot.bounds.bottom,
      lessThan(staff.geometry.lineY(1) + 0.01),
      reason: 'the dot was pushed outside the staff',
    );
  });

  test('a tuplet without a bracket keeps its number against the notes', () {
    // A bracket has to stand off by its own height so its hooks clear the
    // music; a number written on its own does not, and given that room it
    // floated away from the notes it counts.
    final part = Part(id: 'P1', name: 'Flute');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.treble;
    final chords = [
      for (var i = 0; i < 3; i++)
        Chord(
          position: Fraction(i, 12),
          rhythm: const RhythmicDuration(NoteType.eighth),
          stem: StemDirection.down,
          notes: [Note(pitch: Pitch.parse('G5'))],
        ),
    ];
    for (final chord in chords) {
      measure.add(chord);
    }
    part.measures.add(measure);
    part.spanners.add(
      Tuplet(start: chords.first, end: chords.last, bracket: false),
    );

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final number = staff.elements.firstWhere(
      (element) => element.role == ElementRole.tuplet,
    );
    final highest = staff.elements
        .where((element) => element.role == ElementRole.notehead)
        .map((element) => element.bounds.top)
        .reduce(math.min);
    expect(number.bounds.bottom, lessThan(highest));
    expect(highest - number.bounds.bottom, lessThan(1.0));
  });

  test('a chord to be spread carries the sign that says so', () {
    final part = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(2, 4)
      ..clefs[1] = Clef.treble;
    final chord = Chord(
      position: Fraction.zero,
      rhythm: const RhythmicDuration(NoteType.half),
      notes: [
        for (final pitch in const ['C5', 'E5', 'A5'])
          Note(pitch: Pitch.parse(pitch)),
      ],
    )..arpeggiate = true;
    measure.add(chord);
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final wave = staff.elements
        .where((element) => element.role == ElementRole.arpeggio)
        .toList();
    final heads = staff.elements
        .where((element) => element.role == ElementRole.notehead)
        .toList();

    // Drawn as a run of the font's own segments rather than one of them
    // stretched, so a taller chord is given more waves and not longer ones.
    expect(wave.length, greaterThan(1));
    final sizes = wave.map((e) => (e as GlyphElement).size.height).toSet();
    expect(sizes, hasLength(1), reason: 'the waves are all one size');

    final box = wave
        .map((element) => element.bounds)
        .reduce((a, b) => a.expandToInclude(b));

    // Down the left of the chord, reaching from the lowest note to the
    // highest, and inside the measure rather than pushed out of it.
    expect(
      box.right,
      lessThanOrEqualTo(heads.map((h) => h.bounds.left).reduce(math.min)),
    );
    expect(box.top, lessThan(heads.map((h) => h.bounds.top).reduce(math.min)));
    expect(
      box.bottom,
      greaterThan(heads.map((h) => h.bounds.bottom).reduce(math.max) - 0.1),
    );
    expect(box.left, greaterThan(0));
  });

  test('a run of grace notes is given room for all of them', () {
    // They are laid backwards from the beat one after another, and the room
    // asked for was the widest of them rather than what they add up to, so a
    // flourish of three at the head of a measure was drawn over the clef.
    final part = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(2, 4)
      ..clefs[1] = Clef.bass;
    for (final pitch in const ['A2', 'C3', 'E3']) {
      measure.add(
        Chord(
          position: Fraction.zero,
          rhythm: const RhythmicDuration(NoteType.thirtySecond),
          grace: const GraceInfo(),
          notes: [Note(pitch: Pitch.parse(pitch))],
        ),
      );
    }
    measure.add(
      Chord(
        position: Fraction.zero,
        rhythm: const RhythmicDuration(NoteType.quarter),
        notes: [Note(pitch: Pitch.parse('A3'))],
      ),
    );
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    final furniture = staff.elements.where(
      (element) =>
          element.role == ElementRole.clef ||
          element.role == ElementRole.keySignature ||
          element.role == ElementRole.timeSignature,
    );
    final graces = staff.elements.where(
      (element) =>
          element.role == ElementRole.notehead &&
          (element.owner as Chord?)?.isGrace == true,
    );
    expect(graces, hasLength(3));
    for (final grace in graces) {
      for (final sign in furniture) {
        expect(
          grace.bounds.left,
          greaterThan(sign.bounds.right),
          reason: 'a grace note was drawn over the ${sign.role.name}',
        );
      }
    }

    // And they read left to right in the order they are written, so the last
    // of them is the one nearest the note it leads into. Laid the other way
    // round the flourish runs backwards into the barline before it.
    final written = measure.events
        .whereType<Chord>()
        .where((chord) => chord.isGrace)
        .toList();
    final drawn = graces.toList()
      ..sort((a, b) => a.bounds.left.compareTo(b.bounds.left));
    for (var i = 0; i < written.length; i++) {
      expect(
        identical(drawn[i].owner, written[i]),
        isTrue,
        reason: 'the grace notes were laid out backwards',
      );
    }

    // All of them inside their own measure.
    final slot = built.systems.single.measures.single;
    for (final grace in graces) {
      expect(grace.bounds.left, greaterThan(slot.left));
      expect(grace.bounds.right, lessThan(slot.right));
    }
  });

  test('a mark reports the box it actually covers', () {
    // Everything that places itself clear of something else asks that thing
    // for its box, so a box that is wrong is wrong twice over: a fermata is
    // drawn entirely above the point it is placed from, was reported as though
    // it straddled it, and a segno set clear of it was set half a space too
    // low — straight across it. Nothing that compares boxes can catch that,
    // because both boxes agree; only the font can say.
    var checked = 0;
    for (final staff in showcaseStaves()) {
      for (final element in staff.elements) {
        if (element is! GlyphElement) continue;
        if (!_placedByItsEdge(element.role)) continue;
        checked++;
        expect(
          element.bounds.top,
          closeTo(
            element.origin.dy -
                metrics.glyphTop(element.glyph) * element.scaleY,
            0.01,
          ),
          reason: '${element.role.name} ${element.glyph.name}',
        );
      }
    }
    expect(checked, greaterThan(0));
  });

  test('the hairpins of one part share a height', () {
    // One crescendo under each hand of the piano. They belong to the piano,
    // and two of them at two heights is what it looks like when each staff
    // places its own.
    // A hairpin is two lines, and a crescendo and a diminuendo are mirror
    // images, so it is the middle of the pair that has to line up.
    final middles = <Object, ({double top, double bottom})>{};
    final staves = <int>{};
    for (final staff in wide.systems.single.staves) {
      if (staff.part.name != 'Piano') continue;
      for (final element in staff.elements) {
        if (element.role != ElementRole.wedge) continue;
        staves.add(staff.staffNumber);
        final key = element.source!;
        final seen = middles[key];
        middles[key] = (
          top: seen == null
              ? element.bounds.top
              : math.min(seen.top, element.bounds.top),
          bottom: seen == null
              ? element.bounds.bottom
              : math.max(seen.bottom, element.bounds.bottom),
        );
      }
    }
    expect(middles, hasLength(2), reason: 'a crescendo and a diminuendo');
    expect(staves, {2}, reason: 'both are drawn under the lower staff');
    expect(
      middles.values
          .map((box) => ((box.top + box.bottom) / 2).toStringAsFixed(2))
          .toSet(),
      hasLength(1),
      reason: 'every hairpin of the part is on the same line',
    );
  });
}

/// The marks that are placed by an edge of their own box rather than by the
/// middle of it, and so cannot be described by a height alone.
bool _placedByItsEdge(ElementRole role) => switch (role) {
  ElementRole.fermata ||
  ElementRole.articulation ||
  ElementRole.ornament ||
  ElementRole.dynamics ||
  ElementRole.chordSymbol => true,
  _ => false,
};
