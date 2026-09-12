import 'package:songbird_score/src/model/attributes.dart';
import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/measure.dart';
import 'package:songbird_score/src/model/notations.dart';
import 'package:songbird_score/src/theory/clef.dart';
import 'package:songbird_score/src/theory/key.dart';
import 'package:songbird_score/src/theory/pitch.dart';

/// Which accidental, if any, to print in front of a notehead.
class ResolvedAccidental {
  const ResolvedAccidental({
    required this.type,
    this.cautionary = false,
    this.parentheses = false,
  });

  final AccidentalType type;
  final bool cautionary;
  final bool parentheses;
}

/// Works out the accidentals a measure should print.
///
/// A note's [Pitch] says how it sounds; whether a symbol is drawn depends on
/// the key signature and on what has already happened in the measure. Scores
/// usually state their accidentals explicitly, in which case the source is
/// followed — but generated or edited music needs them derived, and a courtesy
/// accidental after a tie has to be suppressed.
class AccidentalResolver {
  AccidentalResolver({
    required KeySignature key,
    this.cautionaryAfterKeyChange = true,
  }) : _key = key;

  final KeySignature _key;

  /// Print a reminder accidental on the first altered note after a key change.
  final bool cautionaryAfterKeyChange;

  /// Alterations currently in force, keyed by diatonic position, so that an
  /// accidental applies to one octave only — as notation has worked since the
  /// nineteenth century.
  final Map<int, double> _measureState = {};

  /// Resets to the start of a measure, where only the key signature applies.
  void startMeasure() => _measureState.clear();

  /// The accidental to print for [pitch], or `null` for none.
  ///
  /// Pass [tiedFrom] when the note continues a tie, which suppresses the
  /// symbol even though the alteration is still unusual.
  ResolvedAccidental? resolve(Pitch pitch, {bool tiedFrom = false}) {
    final position = pitch.diatonicValue;
    final expected = _measureState[position] ?? _key.alterationFor(pitch.step);
    _measureState[position] = pitch.alter;
    if (tiedFrom) return null;
    if (pitch.alter == expected) return null;
    final type = AccidentalType.forAlteration(pitch.alter);
    if (type == null) return null;
    return ResolvedAccidental(type: type);
  }

  /// Records an alteration without printing anything, for a note whose
  /// accidental the source already stated.
  void observe(Pitch pitch) => _measureState[pitch.diatonicValue] = pitch.alter;

  /// Fills in the [Accidental] of every note in [measure] that has none,
  /// leaving explicitly stated accidentals alone.
  ///
  /// Each staff is resolved separately because accidentals do not carry across
  /// staves, and each is walked in time order so that a later note in the
  /// measure sees the earlier ones.
  static void applyTo(
    Measure measure, {
    required MusicalContext context,
    Set<Note>? tiedContinuations,
  }) {
    final resolvers = <int, AccidentalResolver>{};
    for (final event in measure.eventsInOrder) {
      if (event is! Chord) continue;
      final resolver = resolvers.putIfAbsent(
        event.staff,
        () => AccidentalResolver(key: context.keyFor(event.staff)),
      );
      for (final note in event.sortedNotes) {
        final pitch = note.pitch;
        if (pitch == null) continue;
        if (note.accidental != null) {
          resolver.observe(pitch);
          continue;
        }
        final resolved = resolver.resolve(
          pitch,
          tiedFrom:
              tiedContinuations?.contains(note) ?? note.tie == TieState.stop,
        );
        if (resolved != null) note.accidental = Accidental(resolved.type);
      }
    }
  }
}

/// Vertical placement of the accidentals of one chord.
///
/// Accidentals on adjacent notes collide, so they are shifted into columns to
/// the left of the chord. The rule engravers use is to place the highest note's
/// accidental closest to the chord, then work down, moving an accidental one
/// column further left whenever it would touch one already placed.
class AccidentalColumns {
  const AccidentalColumns(
    this.columnOf,
  );

  /// Column index per note, 0 being closest to the noteheads.
  final Map<Note, int> columnOf;

  /// How many columns the accidentals occupy.
  int get columnCount => columnOf.isEmpty
      ? 0
      : columnOf.values.reduce((a, b) => a > b ? a : b) + 1;

  /// Assigns columns for the accidentals of [chord] as drawn under [clef].
  ///
  /// [minimumSeparation] is the vertical distance, in staff positions, two
  /// accidentals must keep to share a column; three positions is the usual
  /// engraving minimum for a sharp against a sharp.
  factory AccidentalColumns.forChord(
    Chord chord,
    Clef clef, {
    int minimumSeparation = 6,
  }) {
    final withAccidentals = [
      for (final note in chord.sortedNotes.reversed)
        if (note.accidental != null && note.displayPitch != null) note,
    ];
    final columns = <Note, int>{};
    final occupied = <int, List<int>>{};
    for (final note in withAccidentals) {
      final position = clef.staffPositionOf(note.displayPitch!);
      var column = 0;
      while (true) {
        final taken = occupied[column] ?? const <int>[];
        final collides = taken.any(
          (other) => (other - position).abs() < minimumSeparation,
        );
        if (!collides) break;
        column++;
      }
      columns[note] = column;
      (occupied[column] ??= []).add(position);
    }
    return AccidentalColumns(columns);
  }
}
