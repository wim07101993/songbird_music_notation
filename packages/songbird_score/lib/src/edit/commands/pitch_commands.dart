import 'package:songbird_score/src/edit/command.dart';
import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/notations.dart';
import 'package:songbird_score/src/model/score.dart';
import 'package:songbird_score/src/theory/interval.dart';
import 'package:songbird_score/src/theory/pitch.dart';

/// Replaces the pitch of one notehead.
class SetPitchCommand extends EditCommand {
  SetPitchCommand({
    required this.note,
    required this.pitch,
  });

  final Note note;
  final Pitch pitch;

  Pitch? _previous;
  Accidental? _previousAccidental;
  bool _applied = false;

  @override
  String get label => 'Change pitch';

  @override
  void apply(Score score) {
    if (!_applied) {
      _previous = note.pitch;
      _previousAccidental = note.accidental;
      _applied = true;
    }
    note.pitch = pitch;
    final accidental = AccidentalType.forAlteration(pitch.alter);
    note.accidental = accidental == null ? null : Accidental(accidental);
  }

  @override
  void revert(Score score) {
    note.pitch = _previous;
    note.accidental = _previousAccidental;
  }

  /// Dragging a note vertically produces a stream of these; folding them keeps
  /// the whole drag as one undo step.
  @override
  bool mergeWith(EditCommand next) =>
      next is SetPitchCommand && identical(next.note, note);
}

/// Moves a set of notes by a diatonic step, keeping their accidentals.
class NudgePitchCommand extends EditCommand {
  NudgePitchCommand({
    required this.notes,
    required this.steps,
  });

  final List<Note> notes;

  /// Diatonic steps to move by; positive is upwards.
  final int steps;

  final List<Pitch?> _previous = [];
  bool _applied = false;

  @override
  String get label => steps > 0 ? 'Move up' : 'Move down';

  @override
  void apply(Score score) {
    if (!_applied) {
      _previous.addAll(notes.map((n) => n.pitch));
      _applied = true;
    }
    for (final note in notes) {
      final pitch = note.pitch;
      if (pitch == null) continue;
      final diatonic = pitch.diatonicValue + steps;
      note.pitch = Pitch(
        Step.fromDiatonicIndex(diatonic % 7),
        (diatonic / 7).floor(),
        alter: pitch.alter,
      );
    }
  }

  @override
  void revert(Score score) {
    for (var i = 0; i < notes.length; i++) {
      notes[i].pitch = _previous[i];
    }
  }

  /// An auto-repeating arrow key produces one of these per repeat; folding
  /// them means the whole run undoes at once. The first command still holds the
  /// pitches from before the run, so its inverse is the right one.
  @override
  bool mergeWith(EditCommand next) =>
      next is NudgePitchCommand && _sameNotes(notes, next.notes);
}

/// Adds a fixed number of semitones to a set of notes, respelling them.
class AlterPitchCommand extends EditCommand {
  AlterPitchCommand({
    required this.notes,
    required this.semitones,
  });

  final List<Note> notes;
  final double semitones;

  final List<double> _previousAlters = [];
  final List<Accidental?> _previousAccidentals = [];
  bool _applied = false;

  @override
  String get label => semitones > 0 ? 'Raise' : 'Lower';

  @override
  void apply(Score score) {
    if (!_applied) {
      for (final note in notes) {
        _previousAlters.add(note.pitch?.alter ?? 0);
        _previousAccidentals.add(note.accidental);
      }
      _applied = true;
    }
    for (final note in notes) {
      final pitch = note.pitch;
      if (pitch == null) continue;
      final alter = pitch.alter + semitones;
      note.pitch = pitch.copyWith(alter: alter);
      final type = AccidentalType.forAlteration(alter);
      note.accidental = type == null ? null : Accidental(type);
    }
  }

  @override
  void revert(Score score) {
    for (var i = 0; i < notes.length; i++) {
      final pitch = notes[i].pitch;
      if (pitch != null) {
        notes[i].pitch = pitch.copyWith(alter: _previousAlters[i]);
      }
      notes[i].accidental = _previousAccidentals[i];
    }
  }

  @override
  bool mergeWith(EditCommand next) =>
      next is AlterPitchCommand && _sameNotes(notes, next.notes);
}

/// Whether two commands act on exactly the same noteheads.
bool _sameNotes(List<Note> a, List<Note> b) {
  if (a.length != b.length) return false;
  for (var i = 0; i < a.length; i++) {
    if (!identical(a[i], b[i])) return false;
  }
  return true;
}

/// Transposes the whole score, or named parts of it, by an interval.
class TransposeCommand extends EditCommand {
  TransposeCommand({
    required this.interval,
    this.partIds,
    this.transposeKeys = true,
  });

  final Interval interval;

  /// The parts to move, or `null` for the whole score.
  final List<String>? partIds;

  final bool transposeKeys;

  @override
  String get label => 'Transpose by $interval';

  @override
  void apply(Score score) => _run(score, interval);

  @override
  void revert(Score score) => _run(score, interval.inverted);

  void _run(Score score, Interval by) {
    final ids = partIds;
    for (final part in score.parts) {
      if (ids != null && !ids.contains(part.id)) continue;
      part.transpose(by, transposeKeys: transposeKeys);
    }
  }
}
