import 'dart:io';

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
  TestWidgetsFlutterBinding.ensureInitialized();

  late ScoreController controller;
  late ScoreEditActions actions;

  setUp(() {
    controller = ScoreController(
      score: const MusicXmlReader().read(_read('rich.musicxml')),
    );
    actions = ScoreEditActions(controller);
  });

  tearDown(() => controller.dispose());

  Chord firstChord() => controller.score.parts.first.chords.first;

  group('zoom', () {
    test('scales the staff and stays within its bounds', () {
      expect(controller.zoom, 1);
      final base = controller.staffSpace;
      controller.zoomIn();
      expect(controller.staffSpace, greaterThan(base));
      controller.zoomOut();
      expect(controller.staffSpace, closeTo(base, 1e-9));

      controller.zoom = 1000;
      expect(controller.zoom, controller.maxZoom);
      controller.zoom = 0;
      expect(controller.zoom, controller.minZoom);
    });

    test('steps through the presets', () {
      controller.zoom = 1;
      controller.zoomToNextStep();
      expect(controller.zoom, 1.25);
      controller.zoomToPreviousStep();
      expect(controller.zoom, 1);
    });

    test('a staff height in pixels sets the zoom', () {
      controller.setStaffHeight(56);
      expect(controller.staffHeight, closeTo(56, 1e-9));
    });

    test('notifies listeners', () {
      var notified = 0;
      controller.addListener(() => notified++);
      controller.zoomIn();
      expect(notified, 1);
    });
  });

  group('transposition', () {
    test('moves every note and the key signature', () {
      final before = firstChord().notes.first.pitch!;
      final keyBefore = controller.currentKey!.fifths;

      controller.transposeBy(Interval.named(2, IntervalQuality.major));

      expect(
        firstChord().notes.first.pitch,
        Interval.named(2, IntervalQuality.major).transpose(before),
      );
      // D major up a tone is E major: two sharps become four.
      expect(controller.currentKey!.fifths, keyBefore + 2);
    });

    test('spells the result the way a reader expects', () {
      // The upper part starts on D5; up a minor third is F5, not E sharp.
      controller.transposeBy(Interval.named(3, IntervalQuality.minor));
      expect(firstChord().notes.first.pitch, const Pitch(Step.f, 5));
    });

    test('is undoable, and restores the key too', () {
      final before = firstChord().notes.first.pitch;
      final keyBefore = controller.currentKey!.fifths;
      controller.transposeBySemitones(3);
      expect(firstChord().notes.first.pitch, isNot(before));

      controller.undo();
      expect(firstChord().notes.first.pitch, before);
      expect(controller.currentKey!.fifths, keyBefore);
    });

    test('going to a named key takes the short way round', () {
      // From D major, C major is a tone down rather than a seventh up.
      controller.transposeToKey(KeySignature.cMajor);
      expect(controller.currentKey!.fifths, 0);
      expect(controller.transposition.chromaticSemitones, -2);
    });

    test('resetting puts the score back', () {
      final before = firstChord().notes.first.pitch;
      controller
        ..transposeBySemitones(5)
        ..transposeBySemitones(2)
        ..resetTransposition();
      expect(firstChord().notes.first.pitch, before);
      expect(controller.transposition.isUnison, isTrue);
    });

    test('stepping up by semitones stays in readable keys', () {
      // The bug this guards: transposing repeatedly by an augmented unison
      // spells C as C quadruple sharp and pushes the key signature past the
      // seven accidentals that can be written, which used to throw.
      final seen = <int>[];
      for (var i = 0; i < 12; i++) {
        controller.transposeBySemitones(1);
        final key = controller.currentKey!;
        seen.add(key.fifths);
        expect(
          key.isPrintable,
          isTrue,
          reason: 'after ${i + 1} semitones the key was ${key.fifths} fifths',
        );
        for (final note in controller.score.parts.first.chords.expand(
          (chord) => chord.notes,
        )) {
          expect(
            note.pitch!.alter.abs(),
            lessThanOrEqualTo(2),
            reason: 'after ${i + 1} semitones, ${note.pitch}',
          );
        }
      }
      // Twelve semitones is an octave: the key comes back to where it started.
      expect(seen.last, 2);
    });

    test('stepping down by semitones stays in readable keys', () {
      for (var i = 0; i < 12; i++) {
        controller.transposeBySemitones(-1);
        expect(controller.currentKey!.isPrintable, isTrue);
      }
      expect(controller.currentKey!.fifths, 2);
    });

    test('a semitone up from E flat is E, not F flat', () {
      final measure = controller.score.parts.first.measures.first;
      ScoreEditActions(
        controller,
      ).setKey(measure, const KeySignature(fifths: -3));
      controller.transposeBySemitones(1);
      expect(controller.currentKey!.fifths, 4);
    });

    test('octaves leave the key signature alone', () {
      final keyBefore = controller.currentKey!.fifths;
      final before = firstChord().notes.first.pitch!;
      controller.transposeByOctaves(-1);
      expect(controller.currentKey!.fifths, keyBefore);
      expect(firstChord().notes.first.pitch!.octave, before.octave - 1);
    });
  });

  group('editing', () {
    test('nudging moves the selected note by a step', () {
      final chord = firstChord();
      final note = chord.notes.first;
      final before = note.pitch!;
      controller.selectEvent(chord);

      actions.nudgeSelection(1);
      expect(note.pitch!.diatonicValue, before.diatonicValue + 1);

      controller.undo();
      expect(note.pitch, before);
    });

    test('a held arrow key collapses into one undo step', () {
      final chord = firstChord();
      final note = chord.notes.first;
      final before = note.pitch;
      controller.selectEvent(chord);

      actions.nudgeSelection(1);
      actions.nudgeSelection(1, merge: true);
      actions.nudgeSelection(1, merge: true);
      expect(controller.editor.history, hasLength(1));

      controller.undo();
      expect(note.pitch, before);
    });

    test('altering a note respells its accidental', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      actions.alterSelection(1);
      final note = chord.notes.first;
      expect(note.pitch!.alter, 1);
      expect(note.accidental?.type, AccidentalType.sharp);
    });

    test('changing a duration is undoable', () {
      final chord = firstChord();
      final before = chord.rhythm;
      controller.selectEvent(chord);
      actions.setDuration(NoteType.half);
      expect(chord.rhythm.type, NoteType.half);
      controller.undo();
      expect(chord.rhythm, before);
    });

    test('a dot lengthens a note by half', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      actions.setDuration(NoteType.quarter);
      actions.toggleDot();
      expect(chord.rhythm.dots, 1);
      expect(chord.rhythm.value, Fraction(3, 8));
      actions.toggleDot();
      expect(chord.rhythm.dots, 0);
    });

    test('deleting a note leaves a rest of the same length', () {
      final chord = firstChord();
      final measure = actions.measureOf(chord)!;
      final length = chord.duration;
      final before = measure.events.length;

      controller.selectEvent(chord);
      actions.deleteSelection();

      expect(measure.events, isNot(contains(chord)));
      final rest = measure.events.whereType<Rest>().firstWhere(
        (rest) => rest.position == chord.position && rest.voice == chord.voice,
      );
      expect(rest.duration, length);
      expect(measure.events, hasLength(before));

      controller.undo();
      expect(measure.events, contains(chord));
    });

    test('an articulation toggles on and off', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      final had = chord.articulations.contains(Articulation.accent);
      actions.toggleArticulation(Articulation.accent);
      expect(chord.articulations.contains(Articulation.accent), !had);
      controller.undo();
      expect(chord.articulations.contains(Articulation.accent), had);
    });

    test('lyrics can be set and cleared', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      actions.setLyric('World');
      expect(chord.lyrics.single.text, 'World');
      actions.setLyric('');
      expect(chord.lyrics, isEmpty);
      controller.undo();
      expect(chord.lyrics.single.text, 'World');
    });

    test('a second verse sits alongside the first', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      actions
        ..setLyric('World')
        ..setLyric('Again', verse: 2);
      expect(
        chord.lyrics.map((lyric) => '${lyric.number}:${lyric.text}'),
        ['1:World', '2:Again'],
      );
      actions.setLyric('');
      expect(chord.lyrics.single.text, 'Again');
    });

    test('a syllable records how it sits within its word', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      actions.setLyric('hap', syllabic: Syllabic.begin);
      expect(actions.lyricOf(chord)!.syllabic, Syllabic.begin);
    });

    test('a chord symbol is written above the selected note', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      expect(actions.setChordSymbol('F#m7'), isTrue);

      final measure = actions.measureOf(chord)!;
      final harmony = actions.chordSymbolAt(
        measure,
        chord.position,
        staff: chord.staff,
      );
      expect(harmony!.symbol, 'F#m7');
      expect(harmony.root.step, Step.f);
      expect(harmony.kind, ChordKind.minorSeventh);

      controller.undo();
      expect(
        actions.chordSymbolAt(measure, chord.position, staff: chord.staff),
        isNull,
      );
    });

    test('a chord symbol that names no chord is refused', () {
      final chord = firstChord();
      controller.selectEvent(chord);
      final before = controller.canUndo;
      expect(actions.setChordSymbol('not a chord'), isFalse);
      expect(controller.canUndo, before);
    });

    test('inserting a note replaces the rest that was there', () {
      final part = controller.score.parts.first;
      final measure = part.measures[1];
      final rest = measure.events.whereType<Rest>().firstWhere(
        (rest) => rest.voice == 1,
      );
      final before = measure.events.whereType<Chord>().length;

      actions.insertNote(
        measure: measure,
        position: rest.position,
        pitch: const Pitch(Step.g, 4),
        rhythm: const RhythmicDuration(NoteType.quarter),
      );

      expect(measure.events.whereType<Chord>(), hasLength(before + 1));
      expect(measure.events, isNot(contains(rest)));

      controller.undo();
      expect(measure.events, contains(rest));
      expect(measure.events.whereType<Chord>(), hasLength(before));
    });

    test('adding a note to an existing chord makes it a chord', () {
      final chord = firstChord();
      final measure = actions.measureOf(chord)!;
      final before = chord.notes.length;

      actions.insertNote(
        measure: measure,
        position: chord.position,
        pitch: const Pitch(Step.a, 5),
        rhythm: chord.rhythm,
        voice: chord.voice,
        staff: chord.staff,
      );

      expect(chord.notes, hasLength(before + 1));
      controller.undo();
      expect(chord.notes, hasLength(before));
    });

    test('measures can be inserted and removed across every part', () {
      final part = controller.score.parts.first;
      final before = part.measures.length;

      actions.insertMeasures(1);
      expect(part.measures, hasLength(before + 1));
      expect(part.measures[1].events.whereType<Rest>(), isNotEmpty);
      expect(part.measures.map((m) => m.number), ['1', '2', '3']);

      controller.undo();
      expect(part.measures, hasLength(before));

      actions.deleteMeasures(1);
      expect(part.measures, hasLength(before - 1));
      controller.undo();
      expect(part.measures, hasLength(before));
    });

    test('the key signature can be changed from a measure onwards', () {
      final measure = controller.score.parts.first.measures[1];
      actions.setKey(measure, const KeySignature(fifths: -2));
      expect(
        controller.score.parts.first
            .contextAtMeasure(1)
            .keyFor(allStaves)
            .fifths,
        -2,
      );
      controller.undo();
      expect(
        controller.score.parts.first
            .contextAtMeasure(1)
            .keyFor(allStaves)
            .fifths,
        2,
      );
    });

    test('a clef change lands where it was asked for', () {
      final measure = controller.score.parts.first.measures[1];
      actions.setClef(measure, Clef.bass);
      expect(
        controller.score.parts.first.contextAtMeasure(1).clefFor(1),
        Clef.bass,
      );
      controller.undo();
      expect(
        controller.score.parts.first.contextAtMeasure(1).clefFor(1),
        Clef.treble,
      );
    });
  });

  group('undo history', () {
    test('reports what it would undo and redo', () {
      expect(controller.canUndo, isFalse);
      controller.selectEvent(firstChord());
      actions.nudgeSelection(1);

      expect(controller.canUndo, isTrue);
      expect(controller.undoLabel, 'Move up');
      expect(controller.canRedo, isFalse);

      controller.undo();
      expect(controller.canRedo, isTrue);
      expect(controller.redoLabel, 'Move up');

      controller.redo();
      expect(controller.canUndo, isTrue);
    });

    test('a new edit clears the redo stack', () {
      controller.selectEvent(firstChord());
      actions.nudgeSelection(1);
      controller.undo();
      expect(controller.canRedo, isTrue);
      actions.nudgeSelection(-1);
      expect(controller.canRedo, isFalse);
    });

    test('redo puts the change back', () {
      final note = firstChord().notes.first;
      final before = note.pitch;
      controller.selectEvent(firstChord());
      actions.nudgeSelection(2);
      final after = note.pitch;

      controller.undo();
      expect(note.pitch, before);
      controller.redo();
      expect(note.pitch, after);
    });
  });

  group('selection', () {
    test('selecting a note selects it alone', () {
      final chord = firstChord();
      final note = chord.notes.first;
      controller.selectNote(note, owner: chord);
      expect(controller.selection.notes, {note});
      expect(controller.selection.affectedNotes, {note});
    });

    test('selecting a chord covers all of its notes', () {
      final chord = controller.score.parts.first.chords.firstWhere(
        (chord) => chord.notes.length > 1,
      );
      controller.selectEvent(chord);
      expect(controller.selection.affectedNotes, chord.notes.toSet());
    });

    test('adding to a selection keeps what was there', () {
      final chords = controller.score.parts.first.chords.take(2).toList();
      controller
        ..selectEvent(chords[0])
        ..selectEvent(chords[1], add: true);
      expect(controller.selection.events, {chords[0], chords[1]});
    });
  });
}
