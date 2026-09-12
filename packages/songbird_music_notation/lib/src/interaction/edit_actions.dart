import 'dart:ui' show Offset;

import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_music_notation/src/widgets/score_controller.dart';
import 'package:songbird_score/songbird_score.dart';

/// The edits an interactive view offers, expressed once so that a keyboard
/// shortcut, a toolbar button and a drag all go through the same code — and so
/// that each of them lands on the undo stack as one step.
class ScoreEditActions {
  const ScoreEditActions(
    this.controller,
  );

  final ScoreController controller;

  Score get score => controller.score;

  /// Moves every selected note up or down by [steps] diatonic steps.
  ///
  /// [merge] folds the change into the previous one, which is what an
  /// auto-repeating arrow key wants: hold it down and the whole run undoes at
  /// once.
  void nudgeSelection(int steps, {bool merge = false}) {
    final notes = controller.selection.affectedNotes.toList();
    if (notes.isEmpty) return;
    controller.execute(
      NudgePitchCommand(notes: notes, steps: steps),
      merge: merge,
    );
  }

  /// Raises or lowers every selected note by a semitone, respelling it.
  void alterSelection(double semitones) {
    final notes = controller.selection.affectedNotes.toList();
    if (notes.isEmpty) return;
    controller.execute(AlterPitchCommand(notes: notes, semitones: semitones));
  }

  /// Sets the written duration of everything selected.
  void setDuration(NoteType type, {int dots = 0}) {
    final events = controller.selection.events
        .where((event) => event is Chord || event is Rest)
        .toList();
    if (events.isEmpty) return;
    controller.execute(
      CompositeCommand('Change duration', [
        for (final event in events)
          SetDurationCommand(
            event: event,
            rhythm: RhythmicDuration(type, dots: dots),
          ),
      ]),
    );
  }

  /// Adds or removes a dot on everything selected.
  void toggleDot() {
    final events = controller.selection.events.toList();
    final commands = <EditCommand>[];
    for (final event in events) {
      final rhythm = switch (event) {
        final Chord chord => chord.rhythm,
        final Rest rest => rest.rhythm,
        _ => null,
      };
      if (rhythm == null) continue;
      commands.add(
        SetDurationCommand(
          event: event,
          rhythm: rhythm.copyWith(dots: rhythm.dots > 0 ? 0 : 1),
        ),
      );
    }
    if (commands.isEmpty) return;
    controller.execute(CompositeCommand('Toggle dot', commands));
  }

  /// Turns the selected notes into rests, keeping the measure full.
  void deleteSelection() {
    final selection = controller.selection;
    if (selection.isEmpty) return;
    final commands = <EditCommand>[];
    for (final measure in _measuresOf(selection.events)) {
      final inMeasure = selection.events
          .where((event) => measure.events.contains(event))
          .toList();
      if (inMeasure.isEmpty) continue;
      final chords = inMeasure.whereType<Chord>().toList();
      final others = inMeasure.where((e) => e is! Chord).toList();
      if (chords.isNotEmpty) {
        commands.add(ReplaceWithRestCommand(measure: measure, events: chords));
      }
      if (others.isNotEmpty) {
        commands.add(DeleteEventsCommand(measure: measure, events: others));
      }
    }
    if (commands.isEmpty) return;
    controller
      ..execute(CompositeCommand('Delete', commands))
      ..clearSelection();
  }

  /// Adds a note to a chord, or replaces a rest with one.
  void insertNote({
    required Measure measure,
    required Fraction position,
    required Pitch pitch,
    required RhythmicDuration rhythm,
    int voice = 1,
    int staff = 1,
  }) {
    final existing = measure.events.whereType<Chord>().where(
      (chord) =>
          chord.position == position &&
          chord.voice == voice &&
          chord.staff == staff,
    );

    if (existing.isNotEmpty) {
      final chord = existing.first;
      controller.execute(
        _AddNoteToChordCommand(
          chord: chord,
          note: Note(pitch: pitch),
        ),
      );
      return;
    }

    // Adding a note where a rest sits replaces the rest, which is what note
    // entry into an empty measure means.
    final rest = measure.events.whereType<Rest>().where(
      (rest) =>
          rest.voice == voice &&
          rest.staff == staff &&
          rest.position <= position &&
          rest.endPosition > position,
    );

    final chord = Chord(
      position: position,
      notes: [Note(pitch: pitch)],
      rhythm: rhythm,
      voice: voice,
      staff: staff,
    );

    controller.execute(
      CompositeCommand('Add note', [
        if (rest.isNotEmpty)
          DeleteEventsCommand(measure: measure, events: [rest.first]),
        InsertEventCommand(measure: measure, event: chord),
      ]),
    );
    controller.selectEvent(chord);
  }

  /// Toggles an articulation on everything selected.
  void toggleArticulation(Articulation articulation) {
    final chords = controller.selection.events.whereType<Chord>().toList();
    if (chords.isEmpty) return;
    controller.execute(
      CompositeCommand('Toggle ${articulation.name}', [
        for (final chord in chords)
          ToggleArticulationCommand(chord: chord, articulation: articulation),
      ]),
    );
  }

  /// Sets a verse of lyrics under a chord, or under the selected one.
  ///
  /// An empty [text] removes that verse. [syllabic] says how the syllable sits
  /// within its word, which is what decides whether a hyphen is drawn after
  /// it; a caller typing word by word wants [Syllabic.single], one typing
  /// syllable by syllable sets it as it goes.
  void setLyric(
    String text, {
    int verse = 1,
    Syllabic syllabic = Syllabic.single,
    Chord? chord,
  }) {
    final target = chord ?? selectedChord;
    if (target == null) return;
    controller.execute(
      SetLyricCommand(
        chord: target,
        verse: verse,
        text: text,
        syllabic: syllabic,
      ),
    );
  }

  /// The syllable already written under [chord] in [verse], if any.
  Lyric? lyricOf(Chord chord, {int verse = 1}) {
    for (final lyric in chord.lyrics) {
      if (lyric.number == verse) return lyric;
    }
    return null;
  }

  /// Writes the chord symbol above a beat from typed text such as `F#m7`.
  ///
  /// Without [measure] and [position] it acts on the selection, which is what
  /// a text field opened over the selected note wants. An empty [symbol]
  /// removes the symbol; text that does not name a chord is refused, and the
  /// undo stack is left alone.
  bool setChordSymbol(
    String symbol, {
    Measure? measure,
    Fraction? position,
    int staff = 1,
    int voice = 1,
  }) {
    var target = measure;
    var beat = position;
    var onStaff = staff;
    var inVoice = voice;

    if (target == null || beat == null) {
      final event = controller.selection.events.firstOrNull;
      if (event == null) return false;
      target = measureOf(event);
      if (target == null) return false;
      beat = event.position;
      onStaff = event.staff;
      inVoice = event.voice;
    }

    final command = SetChordSymbolCommand(
      measure: target,
      position: beat,
      symbol: symbol,
      staff: onStaff,
      voice: inVoice,
    );
    if (!command.isValid) return false;
    controller.execute(command);
    return true;
  }

  /// The chord symbol written at a beat, if there is one.
  Harmony? chordSymbolAt(Measure measure, Fraction position, {int staff = 1}) {
    for (final event in measure.events) {
      if (event is Harmony &&
          event.position == position &&
          event.staff == staff) {
        return event;
      }
    }
    return null;
  }

  /// The chord an edit that needs one should act on.
  Chord? get selectedChord =>
      controller.selection.events.whereType<Chord>().firstOrNull;

  /// Inserts empty measures at [index] in every part.
  void insertMeasures(int index, {int count = 1}) =>
      controller.execute(InsertMeasureCommand(index: index, count: count));

  /// Removes measures from every part.
  void deleteMeasures(int index, {int count = 1}) => controller
    ..execute(DeleteMeasuresCommand(index: index, count: count))
    ..clearSelection();

  /// Sets the key signature from [measure] onwards.
  void setKey(Measure measure, KeySignature key) =>
      controller.execute(SetKeyCommand(measure: measure, key: key));

  /// Sets the time signature from [measure] onwards.
  void setTimeSignature(Measure measure, TimeSignature time) =>
      controller.execute(SetTimeSignatureCommand(measure: measure, time: time));

  /// Sets the clef on one staff from [measure] onwards.
  void setClef(Measure measure, Clef clef, {int staff = 1}) => controller
      .execute(SetClefCommand(measure: measure, clef: clef, staff: staff));

  /// The measure a laid-out element belongs to, if it can be found.
  Measure? measureOf(MusicalEvent event) {
    for (final part in score.parts) {
      for (final measure in part.measures) {
        if (measure.events.contains(event)) return measure;
      }
    }
    return null;
  }

  /// The part a measure belongs to.
  Part? partOf(Measure measure) {
    for (final part in score.parts) {
      if (part.measures.contains(measure)) return part;
    }
    return null;
  }

  Iterable<Measure> _measuresOf(Iterable<MusicalEvent> events) {
    final result = <Measure>{};
    for (final event in events) {
      final measure = measureOf(event);
      if (measure != null) result.add(measure);
    }
    return result;
  }
}

/// Adds one notehead to an existing chord.
class _AddNoteToChordCommand extends EditCommand {
  _AddNoteToChordCommand({
    required this.chord,
    required this.note,
  });

  final Chord chord;
  final Note note;

  @override
  String get label => 'Add note to chord';

  @override
  void apply(Score score) => chord.notes.add(note);

  @override
  void revert(Score score) => chord.notes.remove(note);
}

/// Turns a click on the page into the measure, staff and pitch under it.
///
/// This is what makes note entry work: the reader clicks a spot on a staff and
/// the editor has to know which measure, which beat and which pitch that spot
/// means.
class ScorePointerTarget {
  const ScorePointerTarget({
    required this.part,
    required this.measure,
    required this.staffNumber,
    required this.position,
    required this.pitch,
    required this.staffPosition,
  });

  final Part part;
  final Measure measure;
  final int staffNumber;

  /// The rhythmic position within the measure.
  final Fraction position;

  /// The pitch at the clicked height, spelled by the key signature.
  final Pitch pitch;

  /// The staff position clicked, in half spaces above the bottom line.
  final int staffPosition;
}

/// Works out what a point on the page refers to.
ScorePointerTarget? resolvePointer({
  required ScoreLayout layout,
  required Offset point,
}) {
  final system = layout.systemAtY(point.dy);
  if (system == null) return null;

  StaffLayout? closest;
  var bestDistance = double.infinity;
  for (final staff in system.staves) {
    final distance = (point.dy - staff.pageMiddle).abs();
    if (distance < bestDistance) {
      bestDistance = distance;
      closest = staff;
    }
  }
  if (closest == null) return null;

  final slot = system.measureAtX(point.dx);
  if (slot == null) return null;
  final part = closest.part;
  if (slot.index >= part.measures.length) return null;
  final measure = part.measures[slot.index];

  // The nearest rhythmic column to the left is the beat the click belongs to.
  final localX = point.dx - system.left;
  var position = Fraction.zero;
  var bestX = double.negativeInfinity;
  slot.columnPositions.forEach((column, x) {
    if (x <= localX + 0.5 && x > bestX) {
      bestX = x;
      position = column;
    }
  });

  final context = part.contextAtMeasure(slot.index);
  final clef = context.clefFor(closest.staffNumber);
  final staffPosition = closest.staffPositionAtPage(point.dy);
  final natural = clef.pitchAtStaffPosition(staffPosition);
  final key = context.keyFor(closest.staffNumber);

  return ScorePointerTarget(
    part: part,
    measure: measure,
    staffNumber: closest.staffNumber,
    position: position,
    // Spelling the pitch with the key signature is what makes clicking on the
    // third line of a score in D major give F sharp rather than F.
    pitch: Pitch(
      natural.step,
      natural.octave,
      alter: key.alterationFor(natural.step),
    ),
    staffPosition: staffPosition,
  );
}
