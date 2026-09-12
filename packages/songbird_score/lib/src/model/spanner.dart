import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/notations.dart';

/// How a slur or tie is curved.
enum LineOrientation { over, under, auto }

/// A marking that connects two events, resolved into direct references rather
/// than left as MusicXML's start/stop numbers.
///
/// Resolving them at import time is what lets the renderer draw a slur without
/// scanning forward for its partner, and lets the editor know what to delete
/// when one endpoint goes away.
abstract class Spanner {
  Spanner({
    required this.start,
    required this.end,
    this.number = 1,
  });

  /// The event the marking begins on.
  MusicalEvent start;

  /// The event it ends on.
  MusicalEvent end;

  /// Distinguishes overlapping markings of the same kind.
  int number;

  /// True once both endpoints are known.
  bool get isComplete => true;
}

/// A slur joining two notes.
class Slur extends Spanner {
  Slur({
    required super.start,
    required super.end,
    super.number,
    this.orientation = LineOrientation.auto,
    this.placement,
  });

  LineOrientation orientation;
  Placement? placement;
}

/// A tie between two noteheads of the same pitch.
///
/// The individual [Note]s also carry a [TieState]; this object exists so the
/// renderer can find the exact notehead a tie lands on.
class Tie extends Spanner {
  Tie({
    required super.start,
    required super.end,
    required this.startNoteIndex,
    required this.endNoteIndex,
    this.orientation = LineOrientation.auto,
    this.placement,
  });

  /// Index into the starting chord's `notes`.
  final int startNoteIndex;

  /// Index into the ending chord's `notes`.
  final int endNoteIndex;

  LineOrientation orientation;

  /// Which side of the notes the file asked for, if it asked.
  Placement? placement;
}

/// A bracketed tuplet group.
class Tuplet extends Spanner {
  Tuplet({
    required super.start,
    required super.end,
    super.number,
    this.actualNotes = 3,
    this.normalNotes = 2,
    this.bracket,
    this.showNumber = true,
    this.placement = Placement.above,
  });

  final int actualNotes;
  final int normalNotes;

  /// Whether a bracket is drawn; `null` lets the renderer decide from whether
  /// the group is fully beamed.
  bool? bracket;

  bool showNumber;
  Placement placement;
}
