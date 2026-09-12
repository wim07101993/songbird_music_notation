import 'dart:math' as math;

import 'package:songbird_score/songbird_score.dart';

/// How a chord's noteheads sit around their stem.
///
/// Two notes a second apart cannot both sit on the same side of the stem, so
/// one of them moves across it — which one, and to which side, follows from
/// the stem direction. Spacing and layout both have to agree about it: the
/// room a chord asks for has to be the room it is drawn in, or a notehead
/// shifted to the left lands on whatever stands before it, which at the head
/// of a system is the clef.
class ChordShape {
  const ChordShape._({
    required this.notes,
    required this.direction,
    required this.shifted,
  });

  /// Works out where the noteheads of [chord] go, read in [clef] on a staff of
  /// [lineCount] lines.
  factory ChordShape.of(
    Chord chord,
    Clef clef, {
    required int lineCount,
    StemDirection? forced,
  }) {
    final notes = chord.sortedNotes;
    final direction = forced ?? _directionOf(chord, clef, lineCount);
    return ChordShape._(
      notes: notes,
      direction: direction,
      shifted: _sidesOf(notes, clef, stemUp: direction == StemDirection.up),
    );
  }

  /// The chord's noteheads, low to high.
  final List<Note> notes;

  final StemDirection direction;

  /// Whether each of [notes] is drawn on the far side of the stem.
  final List<bool> shifted;

  bool get stemUp => direction == StemDirection.up;

  /// Whether a notehead is drawn a notehead's width left of the chord's own
  /// position, which is where a second goes under a down stem.
  bool get reachesLeft => !stemUp && shifted.contains(true);

  /// The same to the right, under an up stem.
  bool get reachesRight => stemUp && shifted.contains(true);

  /// Whether [chord] moves aside for [other], sounding at the same moment in
  /// another voice of the same staff.
  ///
  /// Two voices whose notes are a second apart — or the same note twice —
  /// cannot be written one on top of the other. One of them steps to the left:
  /// the voice with its stems down, since the up-stem voice's noteheads belong
  /// against its stems on the right, and between two voices bowed the same way
  /// the lower one. It is the same question for spacing as for drawing, and
  /// both have to answer it alike or the note steps into the measure before.
  static bool stepsAsideFrom(
    Chord chord,
    Chord other,
    Clef clef, {
    required int lineCount,
  }) {
    final mine = _positionsOf(chord, clef);
    final theirs = _positionsOf(other, clef);
    if (mine.isEmpty || theirs.isEmpty) return false;

    var touching = false;
    for (final a in mine) {
      for (final b in theirs) {
        if ((a - b).abs() <= 1) touching = true;
      }
    }
    if (!touching) return false;

    final myStem = _directionOf(chord, clef, lineCount) == StemDirection.up;
    final theirStem = _directionOf(other, clef, lineCount) == StemDirection.up;
    if (myStem != theirStem) return !myStem;

    final myLowest = mine.reduce(math.min);
    final theirLowest = theirs.reduce(math.min);
    if (myLowest != theirLowest) return myLowest < theirLowest;
    // Two voices on the same notes: the later-numbered one gives way, so that
    // the two staves of a keyboard do not both decide to move.
    return chord.voice > other.voice;
  }

  static List<int> _positionsOf(Chord chord, Clef clef) => [
    for (final note in chord.notes)
      if (note.displayPitch != null && note.printObject)
        clef.staffPositionOf(note.displayPitch!),
  ];

  static StemDirection _directionOf(Chord chord, Clef clef, int lineCount) {
    if (chord.stem != StemDirection.none) return chord.stem;
    var extreme = 0;
    var distance = -1;
    for (final note in chord.notes) {
      final pitch = note.displayPitch;
      if (pitch == null) continue;
      final position = clef.staffPositionOf(pitch);
      final away = (position - (lineCount - 1)).abs();
      if (away > distance) {
        distance = away;
        extreme = position;
      }
    }
    return extreme > (lineCount - 1) ? StemDirection.down : StemDirection.up;
  }

  static List<bool> _sidesOf(
    List<Note> ordered,
    Clef clef, {
    required bool stemUp,
  }) {
    final sides = List<bool>.filled(ordered.length, false);
    if (ordered.length < 2) return sides;
    final positions = [
      for (final note in ordered)
        if (note.displayPitch case final pitch?)
          clef.staffPositionOf(pitch)
        else
          0,
    ];
    // Reading from the stem outwards: with an up stem the lowest note is
    // against the stem, with a down stem the highest is.
    if (stemUp) {
      for (var i = 1; i < ordered.length; i++) {
        if (!sides[i - 1] && (positions[i] - positions[i - 1]).abs() == 1) {
          sides[i] = true;
        }
      }
    } else {
      for (var i = ordered.length - 2; i >= 0; i--) {
        if (!sides[i + 1] && (positions[i + 1] - positions[i]).abs() == 1) {
          sides[i] = true;
        }
      }
    }
    return sides;
  }
}
