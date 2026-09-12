import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/demo.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Choosing which parts to read.
///
/// A conductor's score is read a few staves at a time, and thirty at once does
/// not fit on a screen. Hiding a part must change what is drawn and nothing
/// else: the music stays in the score, stays editable, and comes back.
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

  ScoreController controllerOf({int measures = 4, int instruments = 5}) =>
      ScoreController(
        score: buildOrchestralScore(
          measures: measures,
          instruments: fullOrchestra.take(instruments).toList(),
        ),
        font: font,
      );

  test('hiding a part takes its staff out of the layout', () {
    final controller = controllerOf();
    addTearDown(controller.dispose);

    final before = controller.layoutFor(900).systems.first.staves.length;
    expect(before, 5);

    controller.setPartVisible(controller.score.parts[1], false);
    final after = controller.layoutFor(900).systems.first.staves;
    expect(after, hasLength(4));
    expect(
      after.map((staff) => staff.part.name),
      isNot(contains(controller.score.parts[1].name)),
    );
  });

  test('a part on two staves loses both of them', () {
    // The harp is written on two staves, so hiding it has to take away two.
    final controller = ScoreController(
      score: buildOrchestralScore(
        measures: 2,
        instruments: const [
          OrchestralInstrument(
            'Flute',
            'Fl.',
            clefs: [Clef.treble],
            centre: 35,
          ),
          OrchestralInstrument(
            'Harp',
            'Hp.',
            clefs: [Clef.treble, Clef.bass],
            centre: 31,
          ),
        ],
      ),
      font: font,
    );
    addTearDown(controller.dispose);

    expect(controller.layoutFor(900).systems.first.staves, hasLength(3));
    controller.setPartVisible(controller.score.parts[1], false);
    expect(controller.layoutFor(900).systems.first.staves, hasLength(1));
  });

  test('the hidden music is still in the score, and comes back', () {
    final controller = controllerOf();
    addTearDown(controller.dispose);
    final hidden = controller.score.parts[2];

    controller.setPartVisible(hidden, false);
    expect(controller.visibleParts, hasLength(4));
    // Hidden from the page, not removed from the music: it is still there to
    // be transposed, edited and written back out.
    expect(controller.score.parts, hasLength(5));
    expect(controller.score.parts, contains(hidden));

    controller.showAllParts();
    expect(controller.visibleParts, hasLength(5));
    expect(controller.layoutFor(900).systems.first.staves, hasLength(5));
  });

  test('a hit on a filtered layout lands on the real score', () {
    final controller = controllerOf();
    addTearDown(controller.dispose);
    controller.setPartVisible(controller.score.parts.first, false);

    final layout = controller.layoutFor(900);
    final system = layout.systems.first;
    final staff = system.staves.first;
    final notehead = staff.elements.firstWhere(
      (element) => element.role == ElementRole.notehead,
    );
    // Element bounds are staff-local; hit testing works in page coordinates.
    final hit = layout.hitTest(
      notehead.bounds.center + Offset(system.left, staff.pageTop),
    );

    expect(hit, isNotNull);
    // The staff it reports belongs to a part of the score itself, not to a
    // copy made for drawing, which is what keeps a filtered view editable.
    expect(controller.score.parts, contains(hit!.staff!.part));
    final note = hit.note;
    expect(note, isNotNull);
    expect(
      hit.staff!.part.measures.any(
        (measure) => measure.events.whereType<Chord>().any(
          (chord) => chord.notes.contains(note),
        ),
      ),
      isTrue,
    );
  });

  test('showOnlyParts replaces the whole choice at once', () {
    final controller = controllerOf();
    addTearDown(controller.dispose);
    final wanted = [controller.score.parts[1], controller.score.parts[3]];

    controller.showOnlyParts(wanted);
    expect(controller.visibleParts.map((p) => p.id), [
      wanted.first.id,
      wanted.last.id,
    ]);
  });

  test('replacing the score forgets the filter', () {
    final controller = controllerOf();
    addTearDown(controller.dispose);
    controller.setPartVisible(controller.score.parts.first, false);

    controller.replaceScore(
      buildOrchestralScore(
        measures: 2,
        instruments: fullOrchestra.take(3).toList(),
      ),
    );
    expect(controller.visibleParts, hasLength(3));
  });

  testWidgets('the toolbar filters what the view draws', (tester) async {
    final controller = controllerOf();
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 900,
            height: 700,
            child: Column(
              children: [
                ScoreToolbar(controller: controller),
                Expanded(child: MusicScoreView(controller: controller)),
              ],
            ),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.filter_alt_outlined));
    await tester.pumpAndSettle();

    expect(find.text('Parts'), findsOneWidget);
    expect(find.byType(CheckboxListTile), findsNWidgets(5));

    await tester.tap(find.text(controller.score.parts[1].name));
    await tester.pumpAndSettle();
    expect(controller.visibleParts, hasLength(4));

    await tester.tap(find.text('Done'));
    await tester.pumpAndSettle();
    expect(controller.layoutFor(900).systems.first.staves, hasLength(4));
  });

  testWidgets('hide all clears the page, ready for one part to be picked', (
    tester,
  ) async {
    // Getting to a single instrument out of thirty by unticking twenty-nine is
    // not a thing anyone should have to do.
    final controller = controllerOf(instruments: 4);
    addTearDown(controller.dispose);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: PartFilterButton(controller: controller)),
      ),
    );
    await tester.pumpAndSettle();
    await tester.tap(find.byIcon(Icons.filter_alt_outlined));
    await tester.pumpAndSettle();

    await tester.tap(find.text('Hide all'));
    await tester.pumpAndSettle();
    expect(controller.visibleParts, isEmpty);

    final wanted = controller.score.parts[2];
    await tester.tap(find.text(wanted.name));
    await tester.pumpAndSettle();
    expect(controller.visibleParts.single.id, wanted.id);
  });

  testWidgets('a score with every part hidden says so', (tester) async {
    final controller = controllerOf(instruments: 2);
    addTearDown(controller.dispose);
    controller.showOnlyParts(const []);

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 900,
            height: 400,
            child: MusicScoreView(controller: controller),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();

    expect(find.text('Every part is hidden.'), findsOneWidget);
  });
}
