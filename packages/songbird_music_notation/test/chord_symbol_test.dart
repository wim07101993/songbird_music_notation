import 'dart:io';

import 'package:flutter/services.dart';
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

/// The chord symbols above a staff.
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

  Score greensleeves() =>
      const MusicXmlReader().read(_read('greensleeves.musicxml'));

  test('a chord symbol is read out of a file', () {
    final score = greensleeves();
    final harmonies = [
      for (final measure in score.parts.first.measures)
        ...measure.events.whereType<Harmony>(),
    ];
    expect(harmonies, hasLength(8));

    final first = harmonies.first;
    expect(first.root.step, Step.a);
    expect(first.kind, ChordKind.minor);
    expect(first.suffix, 'm');

    // The one written over a bass note.
    final slash = harmonies.firstWhere((h) => h.bass != null);
    expect(slash.root.step, Step.e);
    expect(slash.kind, ChordKind.dominant);
    expect(slash.bass!.step, Step.g);
    expect(slash.bass!.alter, 1);
  });

  test('and written back out again', () {
    final score = greensleeves();
    final xml = const MusicXmlWriter().write(score);
    expect(xml, contains('<harmony>'));

    final again = const MusicXmlReader().read(xml);
    final before = [
      for (final measure in score.parts.first.measures)
        ...measure.events.whereType<Harmony>(),
    ];
    final after = [
      for (final measure in again.parts.first.measures)
        ...measure.events.whereType<Harmony>(),
    ];
    expect(after, hasLength(before.length));
    for (var i = 0; i < before.length; i++) {
      expect(after[i].root, before[i].root);
      expect(after[i].kind, before[i].kind);
      expect(after[i].bass, before[i].bass);
    }
  });

  test('transposing a part takes its chord symbols with it', () {
    // A part moved up while its symbols stayed behind is telling a player two
    // different things at once.
    final score = greensleeves();
    final harmonies = [
      for (final measure in score.parts.first.measures)
        ...measure.events.whereType<Harmony>(),
    ];
    final roots = harmonies.map((h) => h.root.step).toList();

    score.transpose(Interval.chromatic(2));
    expect(harmonies.map((h) => h.root.step), isNot(roots));
    expect(harmonies.first.root.step, Step.b);
    expect(harmonies.firstWhere((h) => h.bass != null).bass!.step, Step.a);
  });

  group('drawing', () {
    late ScoreLayout layout;

    setUp(() {
      layout = LayoutEngine(font: font).layout(greensleeves(), width: 400);
    });

    test('every symbol is drawn, on the staff it belongs to', () {
      final voice = layout.systems.first.staves.first;
      final symbols = voice.elements
          .whereType<TextElement>()
          .where((element) => element.role == ElementRole.chordSymbol)
          .toList();
      // A letter for each, and a suffix for the ones that have one.
      expect(symbols.map((s) => s.text), containsAll(['A', 'C', 'E']));
      expect(symbols.map((s) => s.text), contains('m'));
      expect(symbols.map((s) => s.text), contains('/G'));
    });

    test('a sharp in a symbol comes from the music font', () {
      // Written as a character it is missing from most text faces, and drawn
      // at the size of a letter by the ones that have it.
      final voice = layout.systems.first.staves.first;
      final accidentals = voice.elements.whereType<GlyphElement>().where(
        (element) => element.role == ElementRole.chordSymbol,
      );
      expect(accidentals, isNotEmpty);
      expect(accidentals.first.scale, lessThan(1));
    });

    test('they run along one line above the staff', () {
      final voice = layout.systems.first.staves.first;
      final symbols = voice.elements.whereType<TextElement>().where(
        (element) => element.role == ElementRole.chordSymbol,
      );
      final baselines = symbols
          .map((s) => s.origin.dy.toStringAsFixed(3))
          .toSet();
      expect(baselines, hasLength(1), reason: 'a chart is read as a row');
      expect(
        symbols.first.origin.dy,
        lessThan(voice.geometry.lineY(voice.geometry.lineCount)),
        reason: 'above the staff',
      );
    });

    test('the other marks stack outside them', () {
      // Chord symbols sit closest to the staff; a tempo mark goes above them.
      final voice = layout.systems.first.staves.first;
      final chord = voice.elements.firstWhere(
        (element) => element.role == ElementRole.chordSymbol,
      );
      final words = voice.elements.whereType<TextElement>().firstWhere(
        (element) => element.text == 'Andante',
      );
      expect(words.bounds.bottom, lessThanOrEqualTo(chord.bounds.top));
    });
  });
}
