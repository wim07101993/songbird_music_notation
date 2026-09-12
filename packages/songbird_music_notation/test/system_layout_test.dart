import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/demo.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// How the score is broken into lines, and what is written above them.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SmuflFont font;

  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
    font = await loadBravura();
  });

  test('a second in the first chord of a system clears the clef', () {
    // A second is drawn across the stem, a whole notehead to one side of where
    // the chord itself stands. The reservation for a system's clef and key did
    // not hold that, so the lower note of the chord was drawn back over the
    // clef reprinted in front of it. The second system, where the clef is
    // reprinted without a time signature to leave slack behind it.
    final part = Part(id: 'P1', name: 'Cello');
    for (var i = 0; i < 2; i++) {
      final measure = Measure(number: '${i + 1}');
      if (i == 0) {
        measure.attributes
          ..time = TimeSignature.simple(4, 4)
          ..clefs[1] = Clef.bass;
      }
      measure.add(
        Chord(
          position: Fraction.zero,
          rhythm: const RhythmicDuration(NoteType.whole),
          stem: StemDirection.down,
          notes: [
            Note(pitch: Pitch.parse('A3')),
            Note(pitch: Pitch.parse('B3')),
          ],
        ),
      );
      part.measures.add(measure);
    }

    final layout = LayoutEngine(
      font: font,
      style: const EngravingStyle(measuresPerSystem: 1),
    ).layout(Score(parts: [part]), width: 60);
    expect(layout.systems, hasLength(2));

    final staff = layout.systems.last.staves.single;
    final clef = staff.elements.firstWhere(
      (element) => element.role == ElementRole.clef,
    );
    final heads = staff.elements
        .where((element) => element.role == ElementRole.notehead)
        .toList();
    expect(heads, hasLength(2));
    for (final head in heads) {
      expect(
        head.bounds.left,
        greaterThan(clef.bounds.right),
        reason: 'a notehead was drawn over the clef',
      );
    }
  });

  ScoreLayout layoutWith(EngravingStyle style, {double width = 260}) =>
      LayoutEngine(font: font, style: style).layout(
        buildOrchestralScore(
          measures: 24,
          instruments: fullOrchestra.take(2).toList(),
        ),
        width: width,
      );

  List<String> numbersIn(ScoreLayout layout) => [
    for (final system in layout.systems)
      for (final element in system.elements)
        if (element is TextElement && element.role == ElementRole.measureNumber)
          element.text,
  ];

  group('measure numbers', () {
    test('one at the start of every system, by default', () {
      final layout = layoutWith(EngravingStyle.fromFont(font));
      expect(layout.systems.length, greaterThan(1));

      final numbers = numbersIn(layout);
      // One per system except the first: a reader knows where a piece begins.
      expect(numbers, hasLength(layout.systems.length - 1));
      for (var i = 1; i < layout.systems.length; i++) {
        final first = layout.systems[i].measures.first;
        expect(numbers, contains('${first.index + 1}'));
      }
    });

    test('sits just above the staff, clear of the bracket', () {
      final layout = layoutWith(EngravingStyle.fromFont(font));
      final system = layout.systems[1];
      final number = system.elements.whereType<TextElement>().firstWhere(
        (element) => element.role == ElementRole.measureNumber,
      );
      final staff = system.staves.first;
      final staffTop = staff.pageTop - system.top;

      // One height for the whole score, just above the staff — not floating
      // over the tallest note in the line.
      expect(number.bounds.bottom, lessThan(staffTop));

      // Every number is on the same line as every other, whatever is beneath
      // it. At the head of a system that line is above the clef, since a clef
      // stands where the number would; every system starts with one, so it is
      // one fixed height too.
      final heights = <String>{};
      for (final line in layout.systems) {
        for (final element in line.elements) {
          if (element.role != ElementRole.measureNumber) continue;
          final top = line.staves.first.pageTop - line.top;
          heights.add((element.bounds.bottom - top).toStringAsFixed(3));
        }
      }
      expect(heights, hasLength(1));

      for (final mark in system.elements.where(
        (element) => element.role == ElementRole.bracket,
      )) {
        expect(number.bounds.left, greaterThanOrEqualTo(mark.bounds.right));
      }
    });

    test('but it does move for a note that is under it', () {
      // A whole note high on ledger lines at the head of a measure is exactly
      // where the number goes, and the two cannot both be there.
      final part = Part(id: 'P1', name: 'Flute');
      for (var i = 0; i < 6; i++) {
        final measure = Measure(number: '${i + 1}');
        if (i == 0) {
          measure.attributes
            ..divisions = 4
            ..time = TimeSignature.simple(4, 4)
            ..clefs[1] = Clef.treble;
        }
        measure.add(
          Chord(
            position: Fraction.zero,
            // Two ledger lines above the staff, right where a number sits.
            notes: [Note(pitch: Pitch(Step.c, i.isEven ? 7 : 5))],
            rhythm: const RhythmicDuration(NoteType.whole),
          ),
        );
        part.measures.add(measure);
      }

      final layout = LayoutEngine(
        font: font,
        style: EngravingStyle.fromFont(font),
      ).layout(Score(parts: [part]), width: 40);
      expect(layout.systems.length, greaterThan(1));

      var checked = 0;
      for (final system in layout.systems) {
        final staff = system.staves.first;
        for (final number in system.elements.where(
          (element) => element.role == ElementRole.measureNumber,
        )) {
          checked++;
          for (final element in staff.elements) {
            if (element.role != ElementRole.notehead &&
                element.role != ElementRole.ledgerLine) {
              continue;
            }
            expect(
              element.bounds.overlaps(
                number.bounds.shift(Offset(0, system.top - staff.pageTop)),
              ),
              isFalse,
              reason: 'the number is drawn over a ${element.role.name}',
            );
          }
        }
      }
      expect(checked, greaterThan(0));
    });

    test('none at all when they are turned off', () {
      final layout = layoutWith(
        EngravingStyle.fromFont(
          font,
        ).copyWith(measureNumbers: MeasureNumbering.none),
      );
      expect(numbersIn(layout), isEmpty);
    });

    test('every fifth measure, and the start of every line as well', () {
      final layout = layoutWith(
        EngravingStyle.fromFont(
          font,
        ).copyWith(measureNumbers: const MeasureNumbering.every(5)),
      );
      final numbers = numbersIn(layout).map(int.parse).toSet();
      expect(numbers, containsAll([6, 11, 16, 21]));
      expect(numbers, isNot(contains(1)));
      // Whatever else, a line is never left unlabelled.
      for (var i = 1; i < layout.systems.length; i++) {
        expect(numbers, contains(layout.systems[i].measures.first.index + 1));
      }
    });
  });

  group('resizing', () {
    testWidgets('a slow score is not engraved again on every frame', (
      tester,
    ) async {
      // Dragging a window edge asks for a new width every frame. Engraving a
      // symphony takes longer than a frame, and the desktop shell gives up
      // waiting for one — which is the warning this is about.
      final controller = ScoreController(
        score: buildOrchestralScore(measures: 256),
        font: font,
        deferRelayoutSlowerThan: const Duration(milliseconds: 40),
      );
      addTearDown(controller.dispose);

      final first = controller.layoutFor(2000);
      expect(
        controller.lastLayoutDuration,
        greaterThan(controller.deferRelayoutSlowerThan!),
        reason: 'the score has to be slow enough to matter',
      );

      // A run of widths, as a drag produces.
      for (var i = 1; i <= 20; i++) {
        expect(
          identical(controller.layoutFor(2000 - i * 7.0), first),
          isTrue,
          reason: 'the last engraving is drawn again while the width moves',
        );
      }

      // Once it settles, the controller asks for a frame and engraves.
      var notified = 0;
      controller.addListener(() => notified++);
      await tester.pump(const Duration(milliseconds: 200));
      expect(notified, 1);
      expect(identical(controller.layoutFor(1860), first), isFalse);
    });

    testWidgets('a score that engraves quickly is never deferred', (
      tester,
    ) async {
      final controller = ScoreController(
        score: buildShowcaseScore(),
        font: font,
        deferRelayoutSlowerThan: const Duration(seconds: 1),
      );
      addTearDown(controller.dispose);

      controller.layoutFor(2000);
      expect(
        controller.lastLayoutDuration,
        lessThan(controller.deferRelayoutSlowerThan!),
      );
      // And off altogether is the default, so a widget test is never left
      // holding a timer it did not ask for.
      expect(
        ScoreController(
          score: controller.score,
          font: font,
        ).deferRelayoutSlowerThan,
        isNull,
      );
      final second = controller.layoutFor(1800);
      expect(controller.layoutFor(1800), same(second));
      // Engraved there and then, not on a timer.
      expect(identical(controller.layoutFor(1600), second), isFalse);
    });
  });

  group('breaking into systems', () {
    test('fills each line to the margin by default', () {
      // The count follows the music rather than the other way round: a line
      // takes what fits and is justified out to the margin.
      final layout = layoutWith(EngravingStyle.fromFont(font));
      expect(layout.systems.length, greaterThan(1));
      for (final system in layout.systems.take(layout.systems.length - 1)) {
        expect(system.measures.last.right, closeTo(system.width, 1.0));
      }
    });

    test('breaks every four measures when asked to', () {
      // What a hymn book does: the phrases are four measures long and every
      // line holds one of them.
      final layout = layoutWith(
        EngravingStyle.fromFont(font).copyWith(measuresPerSystem: 4),
        width: 400,
      );
      expect(layout.systems, hasLength(6));
      for (final system in layout.systems) {
        expect(system.measures, hasLength(4));
      }
      // And the music still reaches the right margin.
      for (final system in layout.systems.take(5)) {
        final last = system.measures.last;
        expect(last.right, closeTo(system.width, 1.0));
      }
    });

    test('a count wider than the page still gives each measure a line', () {
      final layout = layoutWith(
        EngravingStyle.fromFont(font).copyWith(measuresPerSystem: 40),
        width: 60,
      );
      expect(layout.systems.length, greaterThan(1));
    });
  });
}
