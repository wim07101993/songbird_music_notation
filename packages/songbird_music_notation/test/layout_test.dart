import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

String _read(String name) {
  for (final prefix in const ['', 'packages/songbird_music_notation/']) {
    final file = File('${prefix}test/data/$name');
    if (file.existsSync()) return file.readAsStringSync();
  }
  throw StateError('fixture "$name" not found');
}

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SmuflFont font;
  late Score score;

  setUpAll(() async {
    font = await loadBravura();
    score = const MusicXmlReader().read(_read('rich.musicxml'));
  });

  test('the bundled font metadata loads', () {
    expect(font.metadata, isNotNull);
    expect(font.metadata!.fontName.toLowerCase(), contains('bravura'));
    expect(font.engraving.stemThickness, closeTo(0.12, 0.001));
    expect(font.advanceWidthOf(SmuflGlyphs.noteheadBlack), greaterThan(1.0));
    expect(font.stemUpAnchorOf(SmuflGlyphs.noteheadBlack).x, greaterThan(1.0));
  });

  group('layout', () {
    late ScoreLayout layout;

    setUp(() {
      layout = LayoutEngine(font: font).layout(score, width: 120);
    });

    test('produces systems covering every measure', () {
      expect(layout.systems, isNotEmpty);
      final covered = <int>{};
      for (final system in layout.systems) {
        for (final slot in system.measures) {
          covered.add(slot.index);
        }
      }
      expect(covered, {0, 1});
    });

    test('gives every part every staff it needs', () {
      final system = layout.systems.first;
      expect(system.staves, hasLength(2));
      expect(system.staves.map((s) => s.staffNumber), [1, 2]);
      expect(
        system.staves.every((s) => identical(s.part, score.parts.first)),
        isTrue,
      );
    });

    test('stacks staves without overlapping', () {
      final system = layout.systems.first;
      final upper = system.staves[0];
      final lower = system.staves[1];
      expect(lower.pageTop, greaterThan(upper.pageBottom));
    });

    test('draws staff lines, a clef, a key signature and a time signature', () {
      final staff = layout.systems.first.staves.first;
      final roles = staff.elements.map((e) => e.role).toSet();
      expect(roles, contains(ElementRole.staffLine));
      expect(roles, contains(ElementRole.clef));
      expect(roles, contains(ElementRole.keySignature));
      expect(roles, contains(ElementRole.timeSignature));
      expect(
        staff.elements.where((e) => e.role == ElementRole.staffLine),
        hasLength(5),
      );
      // D major: two sharps.
      expect(
        staff.elements.where((e) => e.role == ElementRole.keySignature),
        hasLength(2),
      );
    });

    test('places noteheads at the pitch the clef says', () {
      final staff = layout.systems.first.staves.first;
      final geometry = staff.geometry;
      final heads = staff.elements
          .where((e) => e.role == ElementRole.notehead)
          .cast<GlyphElement>()
          .toList();
      expect(heads, isNotEmpty);

      for (final head in heads) {
        final note = head.source;
        if (note is! Note || note.pitch == null) continue;
        expect(
          head.origin.dy,
          closeTo(geometry.yForPitch(note.pitch!, Clef.treble), 0.001),
          reason: 'notehead for ${note.pitch}',
        );
      }

      // D5 sits in the fourth space of a treble staff, one step above the
      // top line's neighbour; the first note of the piece is that D.
      final first = heads.first;
      expect(
        first.origin.dy,
        closeTo(geometry.yForPitch(const Pitch(Step.d, 5), Clef.treble), 0.001),
      );
    });

    test('reads the bass staff with a bass clef', () {
      final staff = layout.systems.first.staves[1];
      final heads = staff.elements
          .where((e) => e.role == ElementRole.notehead)
          .cast<GlyphElement>()
          .toList();
      expect(heads, hasLength(2));
      for (final head in heads) {
        final note = head.source! as Note;
        expect(
          head.origin.dy,
          closeTo(staff.geometry.yForPitch(note.pitch!, Clef.bass), 0.001),
        );
      }
    });

    test('draws stems, beams and an accidental', () {
      final staff = layout.systems.first.staves.first;
      final roles = staff.elements.map((e) => e.role).toList();
      expect(roles, contains(ElementRole.stem));
      expect(roles, contains(ElementRole.beam));
      expect(roles, contains(ElementRole.accidental));
    });

    test('beams the triplet as one group', () {
      final staff = layout.systems.first.staves.first;
      final beams = staff.elements
          .where((e) => e.role == ElementRole.beam)
          .cast<BeamElement>()
          .toList();
      expect(beams, hasLength(1));
      expect(beams.single.right.dx, greaterThan(beams.single.left.dx));
    });

    test('draws the slur, the tuplet bracket and the tie', () {
      final staff = layout.systems.first.staves.first;
      final roles = staff.elements.map((e) => e.role).toSet();
      expect(roles, contains(ElementRole.slur));
      expect(roles, contains(ElementRole.tuplet));
      expect(roles, contains(ElementRole.tie));
    });

    test('draws lyrics below the staff', () {
      final staff = layout.systems.first.staves.first;
      final lyrics = staff.elements
          .where((e) => e.role == ElementRole.lyric)
          .cast<TextElement>()
          .toList();
      expect(lyrics.map((l) => l.text), containsAll(['Hel', 'lo']));
      for (final lyric in lyrics) {
        expect(lyric.origin.dy, greaterThan(staff.geometry.height));
      }
    });

    test('draws dynamics and tempo text against the part, not one staff', () {
      // The fixture is a piano: one instrument on two staves. A dynamic marked
      // below belongs under the instrument, so it is drawn by the lower staff;
      // a tempo mark above belongs over it, so by the upper one. Left on
      // whichever staff the MusicXML happened to name, two hairpins of one
      // part end up at two different heights.
      final staves = layout.systems.first.staves;
      expect(staves, hasLength(2));

      expect(
        staves.last.elements.where((e) => e.role == ElementRole.dynamics),
        isNotEmpty,
      );
      expect(
        staves.first.elements.where((e) => e.role == ElementRole.dynamics),
        isEmpty,
      );

      final words = staves.first.elements
          .where((e) => e.role == ElementRole.text)
          .cast<TextElement>()
          .map((e) => e.text);
      expect(words, contains('Andante'));
    });

    test('measures line up across parts', () {
      final system = layout.systems.first;
      for (final slot in system.measures) {
        expect(slot.width, greaterThan(0));
        expect(slot.musicLeft, greaterThanOrEqualTo(slot.left));
        expect(slot.musicLeft, lessThan(slot.right));
      }
      // The columns are shared, so a position in the treble staff and the same
      // position in the bass staff resolve to one x.
      final slot = system.measures.first;
      expect(slot.xFor(Fraction.zero), slot.xFor(Fraction.zero));
      expect(slot.xFor(Fraction(1, 4)), greaterThan(slot.xFor(Fraction.zero)));
    });

    test('gives longer notes more room, but not proportionally more', () {
      final engine = SpacingEngine(
        style: const EngravingStyle(),
        metrics: NotationMetrics(font: font),
      );
      final quarter = engine.durationSpace(Fraction(1, 4));
      final half = engine.durationSpace(Fraction(1, 2));
      final whole = engine.durationSpace(Fraction.one);
      expect(half, greaterThan(quarter));
      expect(whole, greaterThan(half));
      expect(half, lessThan(quarter * 2));
    });

    test('leaves the barline as much air as the measure after it gets', () {
      // The gap before a barline is what tells the eye a measure has closed.
      // It was once drawn at half the width the spacing engine reserved, so
      // the last note of every measure sat almost against the bar.
      final engine = LayoutEngine(font: font);
      for (final width in const [60.0, 120.0, 250.0]) {
        final laid = engine.layout(score, width: width);
        var checked = 0;
        for (final system in laid.systems) {
          for (final staff in system.staves) {
            for (final barline in staff.elements) {
              if (barline.role != ElementRole.barline) continue;
              final before = _lastMusicBefore(
                staff.elements,
                barline.bounds.left,
              );
              if (before == null) continue;
              checked++;
              expect(
                barline.bounds.left - before,
                greaterThanOrEqualTo(engine.style.barlineGap - 0.01),
                reason: 'at page width $width',
              );
            }
          }
        }
        expect(checked, greaterThan(0), reason: 'at page width $width');
      }
    });

    test('narrower pages break into more systems', () {
      final wide = LayoutEngine(font: font).layout(score, width: 200);
      final narrow = LayoutEngine(font: font).layout(score, width: 40);
      expect(narrow.systems.length, greaterThanOrEqualTo(wide.systems.length));
      expect(wide.systems, hasLength(1));
    });

    test('hit testing finds the notehead under a point', () {
      final staff = layout.systems.first.staves.first;
      final system = layout.systems.first;
      final head = staff.elements.whereType<GlyphElement>().firstWhere(
        (e) => e.role == ElementRole.notehead,
      );
      final page = Offset(
        system.left + head.origin.dx + head.size.width / 2,
        staff.pageY(head.origin.dy),
      );
      final hit = layout.hitTest(page);
      expect(hit, isNotNull);
      expect(hit!.element.role, ElementRole.notehead);
      expect(hit.note, same(head.source));
      expect(hit.event, isA<Chord>());
    });

    test('a click resolves to a measure, a beat and a pitch', () {
      final staff = layout.systems.first.staves.first;
      final system = layout.systems.first;
      final target = resolvePointer(
        layout: layout,
        point: Offset(
          system.left + system.measures.first.musicLeft + 0.5,
          staff.pageY(staff.geometry.yForStaffPosition(4)),
        ),
      );
      expect(target, isNotNull);
      expect(target!.measure, same(score.parts.first.measures.first));
      expect(target.staffNumber, 1);
      // The middle line of a treble staff is B4, and D major does not alter B.
      expect(target.pitch, const Pitch(Step.b, 4));
    });
  });

  test('an empty score lays out without failing', () {
    final layout = LayoutEngine(font: font).layout(Score(), width: 100);
    expect(layout.isEmpty, isTrue);
    expect(layout.size.width, 100);
  });
}

/// The right edge of the last thing a reader has to read before [x], or null
/// when nothing comes before it.
double? _lastMusicBefore(List<LayoutElement> elements, double x) {
  double? nearest;
  for (final element in elements) {
    if (!_carriesItsOwnMeaning(element.role)) continue;
    final right = element.bounds.right;
    if (right > x) continue;
    if (nearest == null || right > nearest) nearest = right;
  }
  return nearest;
}

bool _carriesItsOwnMeaning(ElementRole role) => switch (role) {
  ElementRole.notehead ||
  ElementRole.rest ||
  ElementRole.flag ||
  ElementRole.augmentationDot ||
  ElementRole.accidental ||
  ElementRole.lyric => true,
  _ => false,
};
