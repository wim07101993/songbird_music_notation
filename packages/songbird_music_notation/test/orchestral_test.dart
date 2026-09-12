import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/demo.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// What the library has to survive: a full orchestra with chorus, at the
/// length of a symphony movement.
///
/// The fixtures elsewhere are a page or two of one or two parts, which is the
/// easy case — a system holds a handful of staves and a spanner list is a
/// dozen long. Thirty-three parts over a thousand measures is where a
/// per-system scan of the whole score starts to show, and where two things
/// that fit comfortably apart on a single staff run out of room.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SmuflFont font;
  late EngravingStyle style;

  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
    font = await loadBravura();
    style = EngravingStyle.fromFont(font);
  });

  test('a full orchestra engraves without collisions', () {
    final score = buildOrchestralScore(measures: 12);
    expect(score.parts, hasLength(fullOrchestra.length));

    // From a narrow page, where everything is squeezed, to one wide enough to
    // hold the whole excerpt in a single system.
    for (final width in const [60.0, 120.0, 250.0, 600.0]) {
      final layout = LayoutEngine(
        font: font,
        style: style,
      ).layout(score, width: width);
      expect(
        _collisionsIn(layout),
        isEmpty,
        reason: 'at a page of $width staff spaces',
      );
    }
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('every part of every system is laid out', () {
    final score = buildOrchestralScore(measures: 40);
    final layout = LayoutEngine(
      font: font,
      style: style,
    ).layout(score, width: 200);

    // Two of the instruments are written on two staves.
    final staffCount = fullOrchestra.length + 2;
    for (final system in layout.systems) {
      expect(system.staves, hasLength(staffCount));
      expect(system.staves.every((s) => s.elements.isNotEmpty), isTrue);
    }
    final covered = {
      for (final system in layout.systems)
        for (final slot in system.measures) slot.index,
    };
    expect(covered, hasLength(40));
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('layout cost grows with the length of a score, not with its square', () {
    // Eight times the music should cost about eight times as much. Anything
    // that looks at the whole score once per system — the spanner list was
    // read that way once — costs sixty-four times instead, and the two are far
    // enough apart that the machine this runs on does not matter.
    //
    // The ratio is what is asserted rather than a duration, so a slow machine
    // fails this test only if it is slow in a way that depends on the size of
    // the score.
    final engine = LayoutEngine(font: font, style: style);
    engine.layout(buildOrchestralScore(measures: 32), width: 250);

    final short = buildOrchestralScore(measures: 128);
    final long = buildOrchestralScore(measures: 1024);

    final shortTime = _timeOf(() => engine.layout(short, width: 250));
    final longTime = _timeOf(() => engine.layout(long, width: 250));

    expect(
      longTime / shortTime,
      lessThan(10),
      reason:
          'eight times the music took ${(longTime / shortTime).toStringAsFixed(1)} '
          'times as long: ${shortTime ~/ 1000}ms for 128 measures, '
          '${longTime ~/ 1000}ms for 1024',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));

  testWidgets('the view tells the painter what the reader can see', (
    tester,
  ) async {
    // The culling above only helps if a widget actually supplies the area. It
    // did not for a while: the painter's viewport was left null everywhere,
    // so every frame drew the whole score however little of it was on screen.
    final controller = ScoreController(
      score: buildOrchestralScore(measures: 48),
    );
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 900,
            height: 600,
            child: MusicScoreView(controller: controller),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    final painter = tester
        .widgetList<CustomPaint>(find.byType(CustomPaint))
        .map((paint) => paint.painter)
        .whereType<ScorePainter>()
        .single;

    final whole = painter.layout.size.height;
    final seen = painter.visibleArea!();
    expect(seen.height, lessThan(whole / 4));
    expect(seen.top, closeTo(-16 / controller.staffSpace, 0.01));

    // And it follows the reader down the page.
    await tester.drag(find.byType(MusicScoreView), const Offset(0, -400));
    await tester.pumpAndSettle();
    expect(painter.visibleArea!().top, greaterThan(seen.top + 10));
  }, timeout: const Timeout(Duration(minutes: 5)));

  test('painting costs what is on screen, not what is in the score', () {
    final score = buildOrchestralScore(measures: 256);
    final layout = LayoutEngine(
      font: font,
      style: style,
    ).layout(score, width: 250);

    double paint(Rect? visible) => _timeOf(() {
      final recorder = ui.PictureRecorder();
      ScorePainter(
        layout: layout,
        font: font,
        style: style,
        staffSpace: 8,
        visibleArea: visible == null ? null : () => visible,
      ).paint(ui.Canvas(recorder), const Size(2000, 2000));
      recorder.endRecording().dispose();
    });

    final everything = paint(null);
    final oneScreen = paint(const Rect.fromLTWH(0, 0, 250, 120));
    expect(
      oneScreen,
      lessThan(everything / 3),
      reason:
          'a screenful cost ${oneScreen ~/ 1000}ms against '
          '${everything ~/ 1000}ms for the whole score, so the viewport is '
          'not being used to skip what is off screen',
    );
  }, timeout: const Timeout(Duration(minutes: 5)));
}

/// Microseconds [action] takes, taking the best of three so that a stray
/// garbage collection does not decide the result.
double _timeOf(void Function() action) {
  var best = double.infinity;
  for (var i = 0; i < 3; i++) {
    final watch = Stopwatch()..start();
    action();
    watch.stop();
    final elapsed = watch.elapsedMicroseconds.toDouble();
    if (elapsed < best) best = elapsed;
  }
  return best;
}

/// Everything drawn on top of something else it has to be told apart from.
///
/// The same rule as `collision_test.dart`, applied to a score too large to
/// keep as a fixture.
List<String> _collisionsIn(ScoreLayout layout) {
  final problems = <String>[];
  for (final system in layout.systems) {
    final items = <(LayoutElement, Rect)>[];
    for (final staff in system.staves) {
      for (final element in staff.elements) {
        if (!_carriesItsOwnMeaning(element.role)) continue;
        items.add((element, element.bounds.shift(Offset(0, staff.pageTop))));
      }
    }
    for (var i = 0; i < items.length; i++) {
      for (var j = i + 1; j < items.length; j++) {
        final (a, boundsA) = items[i];
        final (b, boundsB) = items[j];
        if (a.owner != null && identical(a.owner, b.owner)) continue;
        if (a.source != null && identical(a.source, b.source)) continue;
        if (a.role == ElementRole.notehead && b.role == ElementRole.notehead) {
          continue;
        }
        if (boundsA.deflate(0.05).overlaps(boundsB.deflate(0.05))) {
          problems.add(
            '${a.role.name} overlaps ${b.role.name} at '
            '${boundsA.left.toStringAsFixed(1)},${boundsA.top.toStringAsFixed(1)}',
          );
        }
      }
    }
  }
  return problems;
}

bool _carriesItsOwnMeaning(ElementRole role) => switch (role) {
  ElementRole.lyric ||
  ElementRole.dynamics ||
  ElementRole.text ||
  ElementRole.accidental ||
  ElementRole.notehead ||
  ElementRole.rest ||
  ElementRole.articulation ||
  ElementRole.ornament ||
  ElementRole.fermata ||
  ElementRole.augmentationDot ||
  ElementRole.flag ||
  ElementRole.barline ||
  ElementRole.tuplet ||
  ElementRole.clef ||
  ElementRole.keySignature ||
  ElementRole.timeSignature => true,
  _ => false,
};
