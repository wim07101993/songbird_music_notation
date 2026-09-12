import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/demo.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// The showcase score, engraved, for the tests that ask where a mark landed.
///
/// A notehead is easy: it goes on its line. The rest of engraving is the marks
/// that have to find a height of their own, and they are what looks wrong when
/// it is wrong. The showcase puts one of each on a page.
late SmuflFont font;
late NotationMetrics metrics;
late ScoreLayout layout;

/// The same score on a page wide enough to hold it in one system, for the
/// questions that only mean something within a system: two systems are
/// engraved independently and their marks sit where their own music leaves
/// room for them.
late ScoreLayout wide;

/// Loads the font and lays the showcase out. Call from `setUpAll`.
Future<void> loadShowcase() async {
  final bytes = await rootBundle.load(
    'packages/songbird_smufl/assets/fonts/Bravura.otf',
  );
  await (FontLoader(
    'packages/songbird_smufl/Bravura',
  )..addFont(Future.value(bytes))).load();
  font = await loadBravura();
  metrics = NotationMetrics(font: font);
  layout = LayoutEngine(font: font).layout(buildShowcaseScore(), width: 120);
  wide = LayoutEngine(font: font).layout(buildShowcaseScore(), width: 400);
  expect(wide.systems, hasLength(1));
}

/// The measure slot containing [x] in the wide layout, if any.
MeasureSlot? wideSlotUnder(double x) {
  for (final slot in wide.systems.single.measures) {
    if (x >= slot.left && x <= slot.right) return slot;
  }
  return null;
}

/// Every staff of every system of the narrow layout.
Iterable<StaffLayout> showcaseStaves() sync* {
  for (final system in layout.systems) {
    yield* system.staves;
  }
}
