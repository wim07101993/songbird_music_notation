import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/demo.dart';
import 'package:songbird_score/songbird_score.dart';

import 'support/showcase.dart';

/// Braces, brackets, barlines, endings and the rest of the furniture
/// a system is built from.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(loadShowcase);

  test('repeat dots sit inside the staff', () {
    // They were drawn from an origin on the middle line, and the glyph is
    // drawn entirely upwards from its origin, so they floated off the top of
    // the staff instead of resting in the second and third spaces.
    const glyph = NotationGlyphs.repeatDots;
    var found = 0;
    for (final staff in showcaseStaves()) {
      for (final element in staff.elements) {
        if (element is! GlyphElement || element.glyph != glyph) continue;
        found++;
        final top = element.origin.dy - metrics.glyphTop(glyph);
        final bottom = element.origin.dy - metrics.glyphBottom(glyph);
        expect(
          top,
          greaterThan(staff.geometry.lineY(staff.geometry.lineCount) - 0.01),
        );
        expect(bottom, lessThan(staff.geometry.lineY(1) + 0.01));
      }
    }
    expect(found, greaterThan(0), reason: 'the score has repeats in it');
  });

  test('a part written on two staves is braced', () {
    final piano = layout.systems.first.staves
        .where((staff) => staff.part.name == 'Piano')
        .toList();
    expect(piano, hasLength(2));

    final brace =
        layout.systems.first.elements.firstWhere(
              (element) =>
                  element is GlyphElement &&
                  element.glyph == NotationGlyphs.brace,
              orElse: () => throw StateError('no brace was drawn'),
            )
            as GlyphElement;

    // It spans the whole instrument and sits to the left of the music.
    expect(brace.origin.dx, lessThan(0));
    expect(brace.bounds.width, greaterThan(0.3));
    expect(brace.scaleY, greaterThan(1), reason: 'stretched over both staves');

    // And stays a slender stroke while it does. Stretched evenly it comes out
    // as wide as a quarter of its height — over a staff space across a grand
    // staff, thicker than a barline and heavier than the music beside it.
    expect(brace.size.height, greaterThan(12));
    expect(
      brace.size.width,
      lessThan(0.8),
      reason: 'the brace widened with its height',
    );
  });

  test('a bracket keeps clear of the brace inside it', () {
    final system = layout.systems.first;
    final brace = system.elements.whereType<GlyphElement>().firstWhere(
      (element) => element.glyph == NotationGlyphs.brace,
    );
    final bracket = system.elements.whereType<LineElement>().firstWhere(
      (element) => element.role == ElementRole.bracket && element.from.dx < -1,
    );
    expect(bracket.from.dx, lessThan(brace.bounds.left));
  });

  test('a system is closed at its left by a line through every staff', () {
    // What says where one line of music begins and how far down it reaches.
    for (final system in layout.systems) {
      final staves = system.staves;
      final line = system.elements.whereType<LineElement>().firstWhere(
        (element) =>
            element.role == ElementRole.barline &&
            element.from.dx.abs() < 0.001,
        orElse: () => throw StateError('no line down the left of the system'),
      );
      final top = staves.first.pageTop - system.top;
      final bottom =
          staves.last.pageTop - system.top + staves.last.geometry.height;
      expect(line.from.dy, closeTo(top, 0.01));
      expect(line.to.dy, closeTo(bottom, 0.01));
    }
  });

  test('an instrument on two staves is named between them', () {
    final system = layout.systems.first;
    final piano = system.staves.where((s) => s.part.name == 'Piano').toList();
    final name = system.elements.whereType<TextElement>().firstWhere(
      (element) =>
          element.role == ElementRole.partName && element.text == 'Piano',
    );
    final top = piano.first.pageTop - system.top;
    final bottom = piano.last.pageTop - system.top + piano.last.geometry.height;
    // Centred on the brace rather than hanging beside the right hand.
    expect(name.origin.dy, greaterThan(top + (bottom - top) * 0.3));
    expect(name.origin.dy, lessThan(bottom - (bottom - top) * 0.3));
  });

  test('what a measure opens with clears its own barline', () {
    // A clef or a key printed at the head of a measure used to start from the
    // measure's left edge, which is where an opening repeat is drawn: the key
    // sat on the barline, and the clef stood a second padding away from it.
    for (final staff in showcaseStaves()) {
      for (final element in staff.elements) {
        if (element.role != ElementRole.clef &&
            element.role != ElementRole.keySignature) {
          continue;
        }
        final slot = wideSlotUnder(element.bounds.left);
        if (slot == null) continue;
        final barlines = staff.elements.where(
          (other) =>
              other.role == ElementRole.barline &&
              other is LineElement &&
              (other.from.dx - slot.left).abs() < 2,
        );
        for (final barline in barlines) {
          expect(
            element.bounds.left,
            greaterThan(barline.bounds.right),
            reason: '${element.role.name} runs into the barline before it',
          );
        }
      }
    }
  });

  test('a bracket is drawn with its hooks', () {
    // A bare stroke reads as a barline that has escaped the staff.
    final hooks = layout.systems.first.elements.whereType<GlyphElement>().where(
      (element) =>
          element.glyph == NotationGlyphs.bracketTop ||
          element.glyph == NotationGlyphs.bracketBottom,
    );
    expect(hooks, hasLength(2));
  });

  test('a part name keeps clear of the marks at the left of the system', () {
    final system = layout.systems.first;
    final names = system.elements.whereType<TextElement>().where(
      (element) => element.role == ElementRole.partName,
    );
    expect(names, isNotEmpty);
    final furniture = [
      ...system.elements.whereType<LineElement>().where(
        (element) => element.role == ElementRole.bracket,
      ),
      ...system.elements.whereType<GlyphElement>().where(
        (element) => element.role == ElementRole.bracket,
      ),
    ];
    expect(furniture, isNotEmpty);
    for (final name in names) {
      for (final mark in furniture) {
        expect(
          name.bounds.right,
          lessThanOrEqualTo(mark.bounds.left + 0.01),
          reason: 'the name "${name.text}" is written across the bracket',
        );
      }
    }
  });

  test('a stem meets its notehead at the edge, not through it', () {
    // The font names the point where the side of the stem meets the notehead.
    // Centred on it, half the stem stands out past the notehead and the two
    // read as separate shapes stuck together — which is what a reader sees
    // first when the score is zoomed in.
    var checked = 0;
    for (final staff in wide.systems.single.staves) {
      final stems = staff.elements.whereType<LineElement>().where(
        (element) => element.role == ElementRole.stem,
      );
      for (final stem in stems) {
        final chord = stem.owner;
        final head = staff.elements.whereType<GlyphElement>().firstWhere(
          (element) =>
              element.role == ElementRole.notehead &&
              identical(element.owner, chord),
        );
        checked++;
        final half = stem.thickness / 2;
        final up = stem.to.dy < stem.from.dy;
        if (up) {
          // Its right edge lands on the notehead's right edge.
          expect(
            stem.from.dx + half,
            closeTo(head.origin.dx + head.size.width, 0.02),
          );
        } else {
          expect(stem.from.dx - half, closeTo(head.origin.dx, 0.02));
        }
      }
    }
    expect(checked, greaterThan(0));
  });

  test('the score ends on a double bar', () {
    // Drawn, and drawn as two strokes: a piece that stops on a plain barline
    // reads as though the page had been torn off.
    final staff = wide.systems.last.staves.first;
    final end = wide.systems.last.measures.last;
    final strokes = staff.elements
        .whereType<LineElement>()
        .where(
          (element) =>
              element.role == ElementRole.barline &&
              element.from.dx > end.right - 3,
        )
        .toList();
    expect(strokes, hasLength(2), reason: 'a thin stroke and a thick one');
    final thicknesses = strokes.map((s) => s.thickness).toList()..sort();
    expect(thicknesses.last, greaterThan(thicknesses.first));
  });

  test('an opening repeat is the barline for its own boundary', () {
    // It carries the division between the two measures. An ordinary barline
    // drawn as well leaves a thin line, a gap, and then the repeat — three
    // strokes where music has two, with white space in the middle of them.
    final staff = wide.systems.single.staves.first;
    var checked = 0;
    for (final slot in wide.systems.single.measures) {
      final measure = staff.part.measures[slot.index];
      // A left barline carrying nothing but a volta's start is not one of
      // these: it has no strokes of its own to stand on the measure line.
      if (measure.leftBarline?.repeat == null) continue;
      checked++;

      final strokes =
          staff.elements
              .whereType<LineElement>()
              .where(
                (element) =>
                    element.role == ElementRole.barline &&
                    element.bounds.left >= slot.left - 3 &&
                    element.bounds.left < slot.left + 3,
              )
              .toList()
            ..sort((a, b) => a.bounds.left.compareTo(b.bounds.left));

      // A heavy and a light, which is what a forward repeat is drawn with —
      // and nothing before them.
      expect(strokes, hasLength(2));
      for (final stroke in strokes) {
        expect(
          stroke.bounds.right,
          greaterThan(slot.left),
          reason: 'a barline is still drawn before the repeat',
        );
      }

      // Standing on the measure line, not off in the gap before it.
      expect(strokes.first.bounds.left, closeTo(slot.left, 0.02));
    }
    expect(checked, greaterThan(0), reason: 'the score has an opening repeat');
  });

  test('a glyph reports the box the font gives it', () {
    // Most glyphs sit about evenly around the point they are drawn from, and
    // half the height was taken as close enough. A clef does not: a G clef
    // reaches much further above its origin than below, and reported as though
    // it straddled it, everything placed clear of it was placed most of a
    // staff space too low — which is how a measure number came to be written
    // across the clef beside it.
    for (final staff in showcaseStaves()) {
      for (final element in staff.elements) {
        if (element is! GlyphElement) continue;
        final top = metrics.glyphTop(element.glyph) * element.scaleY;
        expect(
          element.bounds.top,
          closeTo(element.origin.dy - top, 0.001),
          reason: '${element.glyph.name} reports a box the font disagrees with',
        );
      }
    }
  });

  test('a measure number at the head of a system clears the clef', () {
    for (final system in layout.systems) {
      final topStaff = system.staves.first;
      final clefs = topStaff.elements
          .where((element) => element.role == ElementRole.clef)
          .map(
            (element) =>
                element.bounds.translate(0, topStaff.pageTop - system.top),
          );
      for (final element in system.elements) {
        if (element.role != ElementRole.measureNumber) continue;
        for (final clef in clefs) {
          expect(
            element.bounds.overlaps(clef),
            isFalse,
            reason: 'a measure number was written across the clef',
          );
        }
      }
    }
  });

  test('a note the file hides is neither drawn nor spaced', () {
    // A roll is written as one note with a tremolo on it, and the notes it is
    // actually played as are written under it marked not to be printed — no
    // ink and, since they stand for something already drawn, no room either.
    // Laid out as music, they were a measure of forty overlapping noteheads
    // wide enough to need a system to itself.
    final part = Part(id: 'P1', name: 'Timpani');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = Clef.bass;
    measure.add(
      Chord(
        position: Fraction.zero,
        rhythm: const RhythmicDuration(NoteType.whole),
        notes: [Note(pitch: Pitch.parse('E3'))],
      ),
    );
    for (var i = 0; i < 16; i++) {
      measure.add(
        Chord(
          position: Fraction(i, 16),
          rhythm: const RhythmicDuration(NoteType.sixteenth),
          voice: 2,
          notes: [
            Note(
              pitch: Pitch.parse('E3'),
              printObject: false,
              printSpacing: false,
            ),
          ],
        ),
      );
    }
    part.measures.add(measure);

    final hidden = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 120);
    final staff = hidden.systems.single.staves.single;
    expect(
      staff.elements.where((element) => element.role == ElementRole.notehead),
      hasLength(1),
      reason: 'only the note that is written is drawn',
    );
    for (final role in const [ElementRole.stem, ElementRole.flag]) {
      expect(
        staff.elements.where((element) => element.role == role),
        isEmpty,
        reason: 'a hidden note grew a ${role.name}',
      );
    }

    // And the measure is the width of the one note it shows.
    final visible = Part(id: 'P1', name: 'Timpani')
      ..measures.add(
        Measure(number: '1')
          ..attributes.time = TimeSignature.simple(4, 4)
          ..attributes.clefs[1] = Clef.bass
          ..add(
            Chord(
              position: Fraction.zero,
              rhythm: const RhythmicDuration(NoteType.whole),
              notes: [Note(pitch: Pitch.parse('E3'))],
            ),
          ),
      );
    final plain = LayoutEngine(
      font: font,
    ).layout(Score(parts: [visible]), width: 120);
    expect(
      hidden.systems.single.measures.single.width,
      closeTo(plain.systems.single.measures.single.width, 0.01),
    );
  });

  test('a time signature the file hides is not printed', () {
    // An excerpt taken from the middle of a movement carries its metre without
    // announcing it again, and what it carries still governs the bar lengths.
    final part = Part(id: 'P1', name: 'Piano');
    final measure = Measure(number: '98');
    measure.attributes
      ..time = TimeSignature.simple(2, 4)
      ..printTime = false
      ..clefs[1] = Clef.treble;
    measure.add(
      Chord(
        position: Fraction.zero,
        rhythm: const RhythmicDuration(NoteType.half),
        notes: [Note(pitch: Pitch.parse('A4'))],
      ),
    );
    part.measures.add(measure);

    final built = LayoutEngine(
      font: font,
    ).layout(Score(parts: [part]), width: 60);
    final staff = built.systems.single.staves.single;
    expect(
      staff.elements.where(
        (element) => element.role == ElementRole.timeSignature,
      ),
      isEmpty,
    );
    expect(
      staff.elements.where((element) => element.role == ElementRole.clef),
      hasLength(1),
      reason: 'the clef is still printed',
    );
  });

  test('a repeat ending is bracketed over the bars it covers', () {
    // Measures three and four of the showcase are a first and a second ending.
    final staff = wide.systems.single.staves.first;
    final strokes = staff.elements
        .whereType<LineElement>()
        .where((element) => element.role == ElementRole.ending)
        .toList();
    final labels = staff.elements
        .whereType<TextElement>()
        .where((element) => element.role == ElementRole.ending)
        .toList();

    expect(labels.map((label) => label.text), ['1.', '2.']);

    final lines = strokes.where((s) => s.from.dy == s.to.dy).toList()
      ..sort((a, b) => a.from.dx.compareTo(b.from.dx));
    expect(lines, hasLength(2), reason: 'one bracket over each ending');

    final slots = wide.systems.single.measures;
    final third = slots.firstWhere((slot) => slot.index == 2);
    final fourth = slots.firstWhere((slot) => slot.index == 3);
    expect(lines.first.from.dx, closeTo(third.left, 0.02));
    expect(lines.first.to.dx, closeTo(third.right, 0.02));
    expect(lines.last.from.dx, closeTo(fourth.left, 0.02));
    expect(lines.last.to.dx, closeTo(fourth.right, 0.02));

    // Both at one height, above everything else the staff drew: a bracket is
    // read across the system, and one that dipped over a quiet bar would stop
    // looking like a single line.
    expect(lines.first.from.dy, closeTo(lines.last.from.dy, 0.001));
    for (final element in staff.elements) {
      if (element.role == ElementRole.staffLine ||
          element.role == ElementRole.ending) {
        continue;
      }
      final box = element.bounds;
      if (box.right < third.left || box.left > fourth.right) continue;
      expect(
        box.top,
        greaterThan(lines.first.from.dy),
        reason: '${element.role.name} is over the bracket',
      );
    }

    // Where the second begins as the first stops they share one stroke, drawn
    // on the measure line that divides them.
    final hooks = strokes.where((s) => s.from.dx == s.to.dx).toList();
    expect(hooks, hasLength(3));
    expect(
      hooks.map((hook) => hook.from.dx.toStringAsFixed(2)).toSet(),
      hasLength(3),
      reason: 'no two hooks are drawn on top of each other',
    );
  });

  test('a barline carrying only a volta start is not drawn twice', () {
    // Measure four opens with a `<barline location="left">` that holds nothing
    // but the second ending's start. The bar before already closes with a
    // repeat, and a plain stroke drawn for this one leaves a second thin line
    // a hair past it.
    final staff = wide.systems.single.staves.first;
    final fourth = wide.systems.single.measures.firstWhere(
      (slot) => slot.index == 3,
    );
    expect(staff.part.measures[3].leftBarline, isNotNull);

    final strokes = staff.elements.whereType<LineElement>().where(
      (element) =>
          element.role == ElementRole.barline &&
          element.from.dx > fourth.left + 0.02 &&
          element.from.dx < fourth.left + 1.5,
    );
    expect(strokes, isEmpty, reason: 'the repeat before it is the barline');
  });

  test('the barline between two staves is the one the staves drew', () {
    // The gap between a piano's staves is filled in by the system rather than
    // by either staff, and it used to ask only for the measure's closing
    // barline. At an opening repeat, where that closing barline gives way,
    // that left a stray stroke across the gap standing beside the repeat.
    final system = wide.systems.single;
    final piano = system.staves
        .where((staff) => staff.part.name == 'Piano')
        .toList();
    expect(piano, hasLength(2));

    var checked = 0;
    for (final slot in system.measures) {
      final measure = piano.first.part.measures[slot.index];
      if (measure.leftBarline == null) continue;
      checked++;

      List<String> strokesNear(Iterable<LayoutElement> elements) => [
        for (final element in elements)
          if (element is LineElement &&
              element.role == ElementRole.barline &&
              element.bounds.left >= slot.left - 3 &&
              element.bounds.left < slot.left + 3)
            element.bounds.left.toStringAsFixed(3),
      ]..sort();

      final onStaff = strokesNear(piano.first.elements);
      final between = strokesNear(system.elements);
      expect(onStaff, isNotEmpty);
      expect(
        between,
        onStaff,
        reason: 'the gap between the staves is filled with something else',
      );
    }
    expect(checked, greaterThan(0), reason: 'the piano has an opening repeat');
  });

  test('a bracket stands against the system line unless a brace is in it', () {
    // A channel of white between the bracket and the line down the left of the
    // system is not something engraved music has. The bracket only stands off
    // for what is inside it: a section of woodwinds has nothing between it and
    // the line, while the keyboards have their own braces there.
    final instruments = [
      ...fullOrchestra.where(
        (i) => i.name == 'Piccolo' || i.name.startsWith('Flute'),
      ),
      ...fullOrchestra.where((i) => i.name == 'Harp' || i.name == 'Piano'),
    ];
    final layout =
        LayoutEngine(font: font, style: EngravingStyle.fromFont(font)).layout(
          buildOrchestralScore(measures: 2, instruments: instruments),
          width: 90,
        );
    final system = layout.systems.first;

    final line = system.elements.whereType<LineElement>().firstWhere(
      (element) =>
          element.role == ElementRole.barline && element.from.dx.abs() < 0.001,
    );
    final brackets =
        system.elements
            .whereType<LineElement>()
            // Left of the music: the line a multi-staff part draws to join its own
            // staves carries the same role and sits on the measure line.
            .where(
              (element) =>
                  element.role == ElementRole.bracket &&
                  element.from.dx < -0.05,
            )
            .toList()
          ..sort((a, b) => a.bounds.top.compareTo(b.bounds.top));
    expect(brackets, hasLength(2));

    // The woodwinds, with nothing between them and the line: a hair of white,
    // not a channel and not a join.
    final gap = line.bounds.left - brackets.first.bounds.right;
    expect(gap, greaterThan(0.02), reason: 'the two run into each other');
    expect(gap, lessThan(0.6), reason: 'a channel of white opened up');

    // The keyboards, outside the braces that are.
    final braces = system.elements.whereType<GlyphElement>().where(
      (element) => element.glyph == NotationGlyphs.brace,
    );
    expect(braces, isNotEmpty);
    for (final brace in braces) {
      expect(brackets.last.bounds.right, lessThanOrEqualTo(brace.bounds.left));
    }
  });

  test('a flat in a name is drawn from the music font', () {
    // "Clarinet in B♭" is what the instrument is called, and the flat in it is
    // a character most text faces have never heard of: it comes out as an
    // empty box, which is what a page of woodwinds looked like.
    final score = buildOrchestralScore(
      measures: 1,
      instruments: fullOrchestra
          .where((i) => i.name.startsWith('Clarinet'))
          .toList(),
    );
    final page = LayoutEngine(
      font: font,
      style: EngravingStyle.fromFont(font),
    ).layout(score, width: 90);
    final system = page.systems.first;

    final words = system.elements
        .whereType<TextElement>()
        .where((element) => element.role == ElementRole.partName)
        .map((element) => element.text)
        .toList();
    expect(words, isNotEmpty);
    for (final word in words) {
      expect(
        word.contains('\u266D'),
        isFalse,
        reason: 'the flat was left in the text as a character',
      );
    }
    expect(words.any((word) => word.startsWith('Clarinet in B')), isTrue);

    final signs = system.elements.whereType<GlyphElement>().where(
      (element) => element.role == ElementRole.partName,
    );
    expect(signs, isNotEmpty, reason: 'no flat was drawn');
    expect(signs.first.glyph, NotationGlyphs.accidental(AccidentalType.flat));
    expect(signs.first.scale, lessThan(1), reason: 'sized against the letters');
  });

  test('a C clef is centred on the line it names', () {
    // Alto is the middle line, tenor the one above it; the glyph is symmetric
    // about its origin, so the origin is the line.
    for (final staff in showcaseStaves()) {
      if (staff.part.name != 'Viola') continue;
      for (final element in staff.elements) {
        if (element is! GlyphElement) continue;
        if (element.role != ElementRole.clef) continue;
        final clef = element.source;
        if (clef is! Clef || clef.sign != ClefSign.c) continue;
        expect(
          element.origin.dy,
          closeTo(staff.geometry.lineY(clef.line), 0.01),
        );
      }
    }
  });
}
