import 'dart:io';

import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_score/songbird_score.dart';

String _read(String name) {
  for (final prefix in const ['', 'packages/songbird_music_notation/']) {
    final file = File('${prefix}test/data/$name');
    if (file.existsSync()) return file.readAsStringSync();
  }
  throw StateError('fixture "$name" not found');
}

void main() {
  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
  });

  late ScoreController controller;

  setUp(() {
    controller = ScoreController(
      score: const MusicXmlReader().read(_read('rich.musicxml')),
    );
  });

  tearDown(() => controller.dispose());

  Widget wrap(Widget child) => MaterialApp(
    home: Scaffold(body: SizedBox(width: 900, height: 600, child: child)),
  );

  testWidgets('the view paints a score once the font has loaded', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(MusicScoreView(controller: controller)));
    await tester.pumpAndSettle();

    expect(find.byType(CustomPaint), findsWidgets);
    expect(controller.font, isNotNull);
    expect(controller.layoutFor(600).systems, isNotEmpty);
  });

  testWidgets('the view builds cleanly while the font is still loading', (
    tester,
  ) async {
    // The bug this guards: the view used to hand the font to the controller
    // from inside its own build, and notifying listeners during a build throws
    // "setState() called during build" on every frame.
    resetBravuraForTesting();
    final fresh = ScoreController(
      score: const MusicXmlReader().read(_read('rich.musicxml')),
    );
    addTearDown(fresh.dispose);

    await tester.pumpWidget(wrap(MusicScoreView(controller: fresh)));
    expect(tester.takeException(), isNull);
    await tester.pump();
    expect(tester.takeException(), isNull);
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the editor builds cleanly while the font is still loading', (
    tester,
  ) async {
    resetBravuraForTesting();
    final fresh = ScoreController(
      score: const MusicXmlReader().read(_read('rich.musicxml')),
    );
    addTearDown(fresh.dispose);

    await tester.pumpWidget(wrap(MusicScoreEditor(controller: fresh)));
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('the view survives a resize', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreView(controller: controller)));
    await tester.pumpAndSettle();

    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: SizedBox(
            width: 400,
            height: 600,
            child: MusicScoreView(controller: controller),
          ),
        ),
      ),
    );
    await tester.pumpAndSettle();
    expect(tester.takeException(), isNull);
  });

  testWidgets('zoom controls change the zoom', (tester) async {
    await tester.pumpWidget(wrap(ZoomControls(controller: controller)));
    await tester.pumpAndSettle();

    expect(find.text('100%'), findsOneWidget);
    await tester.tap(find.byIcon(Icons.zoom_in));
    await tester.pumpAndSettle();
    expect(controller.zoom, greaterThan(1));
    expect(find.text('100%'), findsNothing);
  });

  testWidgets('transpose controls move the score', (tester) async {
    final before = controller.score.parts.first.chords.first.notes.first.pitch;
    await tester.pumpWidget(wrap(TransposeControls(controller: controller)));
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.arrow_upward));
    await tester.pumpAndSettle();
    expect(
      controller.score.parts.first.chords.first.notes.first.pitch,
      isNot(before),
    );

    // The reset button appears once the score has moved.
    await tester.tap(find.byIcon(Icons.undo));
    await tester.pumpAndSettle();
    expect(controller.score.parts.first.chords.first.notes.first.pitch, before);
  });

  testWidgets('the toolbar drives undo and redo', (tester) async {
    await tester.pumpWidget(wrap(ScoreToolbar(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    final before = chord.notes.first.pitch;
    controller.selectEvent(chord);
    ScoreEditActions(controller).nudgeSelection(1);
    await tester.pumpAndSettle();

    await tester.tap(find.byIcon(Icons.undo).first);
    await tester.pumpAndSettle();
    expect(chord.notes.first.pitch, before);

    await tester.tap(find.byIcon(Icons.redo).first);
    await tester.pumpAndSettle();
    expect(chord.notes.first.pitch, isNot(before));
  });

  testWidgets('tapping a notehead selects it', (tester) async {
    await tester.pumpWidget(
      wrap(MusicScoreView(controller: controller, selectable: true)),
    );
    await tester.pumpAndSettle();

    final layout = controller.layoutFor(600);
    final system = layout.systems.first;
    final staff = system.staves.first;
    final head = staff.elements.whereType<GlyphElement>().firstWhere(
      (e) => e.role == ElementRole.notehead,
    );

    // The canvas sits inside a scrolling page, so the tap is aimed at the
    // painted surface rather than at the widget as a whole.
    final target =
        Offset(
          system.left + head.origin.dx + head.size.width / 2,
          staff.pageY(head.origin.dy),
        ) *
        controller.staffSpace;
    final painter = tester.getTopLeft(find.byType(CustomPaint).last);
    await tester.tapAt(painter + target);
    await tester.pumpAndSettle();

    expect(controller.selection.isNotEmpty, isTrue);
  });

  testWidgets('the editor moves a selected note with the arrow keys', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    final note = chord.notes.first;
    final before = note.pitch!;
    controller.selectEvent(chord);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    expect(note.pitch!.diatonicValue, before.diatonicValue + 1);

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowDown);
    await tester.pumpAndSettle();
    expect(note.pitch!.diatonicValue, before.diatonicValue);
  });

  testWidgets('the editor sets a duration from the number row', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    controller.selectEvent(chord);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.digit2);
    await tester.pumpAndSettle();
    expect(chord.rhythm.type, NoteType.half);
  });

  testWidgets('the editor types lyrics from note to note', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final first = controller.score.parts.first.chords.first;
    controller.selectEvent(first);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyL);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsOneWidget);

    // A hyphen ends a syllable rather than being typed into it, and moves on
    // to whatever note comes next in the same voice.
    await tester.enterText(find.byType(TextField), 'hap-');
    await tester.pumpAndSettle();
    expect(first.lyrics.single.text, 'hap');
    expect(first.lyrics.single.syllabic, Syllabic.begin);

    final second = controller.selection.events.single as Chord;
    expect(second, isNot(same(first)));

    // A space ends the word, so the second syllable closes it.
    await tester.enterText(find.byType(TextField), 'py ');
    await tester.pumpAndSettle();
    expect(second.lyrics.single.text, 'py');
    expect(second.lyrics.single.syllabic, Syllabic.end);

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(find.byType(TextField), findsNothing);
  });

  testWidgets('the editor opens a lyric already written', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    controller.selectEvent(chord);
    ScoreEditActions(controller).setLyric('World');
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyL);
    await tester.pumpAndSettle();
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'World',
    );
  });

  testWidgets('the editor types a chord symbol above a note', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    controller.selectEvent(chord);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.pumpAndSettle();

    await tester.enterText(find.byType(TextField), 'Cmaj7/E');
    await tester.testTextInput.receiveAction(TextInputAction.done);
    await tester.pumpAndSettle();

    final actions = ScoreEditActions(controller);
    final measure = actions.measureOf(chord)!;
    expect(
      actions
          .chordSymbolAt(measure, chord.position, staff: chord.staff)!
          .symbol,
      'Cmaj7/E',
    );
  });

  /// Where a point in staff spaces lands on the screen.
  ///
  /// The editor draws inside its own padding and the fixtures are short
  /// enough not to scroll, so the canvas starts at the padded corner.
  Offset onScreen(WidgetTester tester, Offset point) {
    const padding = 16.0;
    return tester.getTopLeft(find.byType(MusicScoreEditor)) +
        const Offset(padding, padding) +
        point * controller.staffSpace;
  }

  Future<void> doubleTapAt(WidgetTester tester, Offset point) async {
    final at = onScreen(tester, point);
    await tester.tapAt(at);
    await tester.pump(kDoubleTapMinTime);
    await tester.tapAt(at);
    await tester.pumpAndSettle();
  }

  testWidgets('double-clicking a lyric opens it for editing', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final layout = controller.layoutFor(900 - 32);
    final lyric = layout.boundsWhere(
      (element) => element.role == ElementRole.lyric,
    )!;

    await doubleTapAt(tester, lyric.center);
    expect(find.byType(TextField), findsOneWidget);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Hel',
    );

    await tester.enterText(find.byType(TextField), 'Good ');
    await tester.pumpAndSettle();
    expect(
      controller.score.parts
          .expand((part) => part.chords)
          .expand((chord) => chord.lyrics)
          .map((lyric) => lyric.text),
      contains('Good'),
    );
  });

  testWidgets('double-clicking a chord symbol opens it for editing', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    controller.selectEvent(chord);
    ScoreEditActions(controller).setChordSymbol('Am7');
    await tester.pumpAndSettle();

    final layout = controller.layoutFor(900 - 32);
    final symbol = layout.boundsWhere(
      (element) => element.role == ElementRole.chordSymbol,
    )!;

    await doubleTapAt(tester, symbol.center);
    expect(
      tester.widget<TextField>(find.byType(TextField)).controller!.text,
      'Am7',
    );
  });

  testWidgets('leaving the editor keeps what was being typed', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    controller.selectEvent(chord);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.keyK);
    await tester.pumpAndSettle();
    await tester.enterText(find.byType(TextField), 'Am7');
    await tester.pumpAndSettle();

    // No space, no Enter, no Escape: the view simply goes away, as it does
    // when an application switches out of editing.
    await tester.pumpWidget(wrap(const SizedBox.shrink()));
    await tester.pumpAndSettle();

    final actions = ScoreEditActions(controller);
    final measure = actions.measureOf(chord)!;
    expect(
      actions
          .chordSymbolAt(measure, chord.position, staff: chord.staff)
          ?.symbol,
      'Am7',
    );
  });

  testWidgets('double-clicking puts the caret in the field', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final layout = controller.layoutFor(900 - 32);
    final lyric = layout.boundsWhere(
      (element) => element.role == ElementRole.lyric,
    )!;

    await doubleTapAt(tester, lyric.center);
    expect(tester.takeException(), isNull);

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.focusNode!.hasFocus, isTrue);
  });

  testWidgets('the words being typed replace the engraved ones', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    expect(
      tester.widget<ScoreCanvas>(find.byType(ScoreCanvas)).hidden,
      isEmpty,
    );

    final layout = controller.layoutFor(900 - 32);
    final lyric = layout.boundsWhere(
      (element) => element.role == ElementRole.lyric,
    )!;
    await doubleTapAt(tester, lyric.center);

    // The syllable being typed over is left undrawn, so that the field — which
    // has no background of its own — does not print over it.
    final hidden = tester.widget<ScoreCanvas>(find.byType(ScoreCanvas)).hidden;
    expect(hidden, hasLength(1));
    expect(hidden.single, isA<Lyric>().having((l) => l.text, 'text', 'Hel'));

    await tester.sendKeyEvent(LogicalKeyboardKey.escape);
    await tester.pumpAndSettle();
    expect(
      tester.widget<ScoreCanvas>(find.byType(ScoreCanvas)).hidden,
      isEmpty,
    );
  });

  testWidgets('the typing field is bare text, not a form control', (
    tester,
  ) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    controller.selectEvent(controller.score.parts.first.chords.first);
    await tester.pumpAndSettle();
    await tester.sendKeyEvent(LogicalKeyboardKey.keyL);
    await tester.pumpAndSettle();

    final field = tester.widget<TextField>(find.byType(TextField));
    expect(field.decoration, isNull);
    expect(field.style!.color, controller.style.colors.ink);
  });

  testWidgets('the editor undoes with the keyboard', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    final before = chord.notes.first.pitch;
    controller.selectEvent(chord);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.arrowUp);
    await tester.pumpAndSettle();
    expect(chord.notes.first.pitch, isNot(before));

    await tester.sendKeyDownEvent(LogicalKeyboardKey.controlLeft);
    await tester.sendKeyEvent(LogicalKeyboardKey.keyZ);
    await tester.sendKeyUpEvent(LogicalKeyboardKey.controlLeft);
    await tester.pumpAndSettle();
    expect(chord.notes.first.pitch, before);
  });

  testWidgets('deleting leaves a rest', (tester) async {
    await tester.pumpWidget(wrap(MusicScoreEditor(controller: controller)));
    await tester.pumpAndSettle();

    final chord = controller.score.parts.first.chords.first;
    final measure = ScoreEditActions(controller).measureOf(chord)!;
    controller.selectEvent(chord);
    await tester.pumpAndSettle();

    await tester.sendKeyEvent(LogicalKeyboardKey.delete);
    await tester.pumpAndSettle();
    expect(measure.events, isNot(contains(chord)));
    expect(
      measure.events.whereType<Rest>().any(
        (rest) => rest.position == chord.position,
      ),
      isTrue,
    );
  });
}
