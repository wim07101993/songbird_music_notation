import 'package:songbird_score/src/theory/fraction.dart';

/// The written note values, from the longest to the shortest MusicXML defines.
enum NoteType {
  maxima('maxima', 32),
  long('long', 16),
  breve('breve', 8),
  whole('whole', 4),
  half('half', 2),
  quarter('quarter', 1),
  eighth('eighth', 1, denominator: 2),
  sixteenth('16th', 1, denominator: 4),
  thirtySecond('32nd', 1, denominator: 8),
  sixtyFourth('64th', 1, denominator: 16),
  oneHundredTwentyEighth('128th', 1, denominator: 32),
  twoHundredFiftySixth('256th', 1, denominator: 64),
  fiveHundredTwelfth('512th', 1, denominator: 128),
  oneThousandTwentyFourth('1024th', 1, denominator: 256);

  const NoteType(
    this.xmlName,
    this.quarterNumerator, {
    this.denominator = 1,
  });

  /// The value MusicXML writes in a `<type>` element.
  final String xmlName;

  final int quarterNumerator;
  final int denominator;

  /// Length in whole notes, before dots and tuplets.
  Fraction get baseValue => Fraction(quarterNumerator, denominator * 4);

  /// Number of flags or beams a stemmed note of this value carries.
  int get flagCount => switch (this) {
    NoteType.eighth => 1,
    NoteType.sixteenth => 2,
    NoteType.thirtySecond => 3,
    NoteType.sixtyFourth => 4,
    NoteType.oneHundredTwentyEighth => 5,
    NoteType.twoHundredFiftySixth => 6,
    NoteType.fiveHundredTwelfth => 7,
    NoteType.oneThousandTwentyFourth => 8,
    _ => 0,
  };

  /// Whether a note of this value is drawn with a stem at all.
  bool get hasStem => index >= NoteType.half.index;

  /// Whether the notehead is drawn filled in.
  bool get isFilledNotehead => index >= NoteType.quarter.index;

  /// The next shorter value, or `null` at the bottom of the range.
  NoteType? get halved =>
      index + 1 < NoteType.values.length ? NoteType.values[index + 1] : null;

  /// The next longer value, or `null` at the top of the range.
  NoteType? get doubled => index > 0 ? NoteType.values[index - 1] : null;

  static NoteType? fromXmlName(String name) {
    for (final type in NoteType.values) {
      if (type.xmlName == name) return type;
    }
    return null;
  }

  /// The written value whose plain (undotted) length is [value], if any.
  static NoteType? forValue(Fraction value) {
    for (final type in NoteType.values) {
      if (type.baseValue == value) return type;
    }
    return null;
  }
}

/// How many notes are played in the time of how many, for tuplets.
class TimeModification {
  const TimeModification({
    required this.actualNotes,
    required this.normalNotes,
  });

  /// A triplet: three notes in the time of two.
  static const TimeModification triplet = TimeModification(
    actualNotes: 3,
    normalNotes: 2,
  );

  static const TimeModification none = TimeModification(
    actualNotes: 1,
    normalNotes: 1,
  );

  /// How many notes are actually written.
  final int actualNotes;

  /// How many notes of the same written value they replace.
  final int normalNotes;

  bool get isNone => actualNotes == normalNotes;

  /// The factor a written duration is multiplied by.
  Fraction get ratio => Fraction(normalNotes, actualNotes);

  @override
  bool operator ==(Object other) =>
      other is TimeModification &&
      actualNotes == other.actualNotes &&
      normalNotes == other.normalNotes;

  @override
  int get hashCode => Object.hash(actualNotes, normalNotes);

  @override
  String toString() => '$actualNotes:$normalNotes';
}

/// A complete written duration: a note value, its augmentation dots and any
/// tuplet ratio applying to it.
class RhythmicDuration {
  const RhythmicDuration(
    this.type, {
    this.dots = 0,
    this.timeModification = TimeModification.none,
  }) : assert(dots >= 0 && dots <= 4, 'dots out of range');

  /// The written note value.
  final NoteType type;

  /// Augmentation dots; each adds half of what came before it.
  final int dots;

  /// The tuplet ratio in force, if any.
  final TimeModification timeModification;

  /// Sounding length in whole notes.
  Fraction get value {
    var total = type.baseValue;
    var increment = type.baseValue;
    for (var i = 0; i < dots; i++) {
      increment = increment * Fraction.half;
      total = total + increment;
    }
    return total * timeModification.ratio;
  }

  /// Length in whole notes ignoring any tuplet ratio, which is what beaming and
  /// notehead choice depend on.
  Fraction get writtenValue {
    var total = type.baseValue;
    var increment = type.baseValue;
    for (var i = 0; i < dots; i++) {
      increment = increment * Fraction.half;
      total = total + increment;
    }
    return total;
  }

  bool get isTuplet => !timeModification.isNone;

  RhythmicDuration copyWith({
    NoteType? type,
    int? dots,
    TimeModification? timeModification,
  }) => RhythmicDuration(
    type ?? this.type,
    dots: dots ?? this.dots,
    timeModification: timeModification ?? this.timeModification,
  );

  /// The written durations that add up to [value], longest first.
  ///
  /// Used when an edit leaves a gap that has to be filled with rests, or when a
  /// note crosses a barline and has to be split and tied.
  static List<RhythmicDuration> decompose(Fraction value) {
    final result = <RhythmicDuration>[];
    var remaining = value;
    var guard = 0;
    while (remaining.isPositive && guard++ < 64) {
      final piece = _largestFitting(remaining);
      if (piece == null) break;
      result.add(piece);
      remaining = remaining - piece.value;
    }
    return result;
  }

  static RhythmicDuration? _largestFitting(Fraction remaining) {
    for (final type in NoteType.values) {
      for (var dots = 3; dots >= 0; dots--) {
        final candidate = RhythmicDuration(type, dots: dots);
        if (candidate.value <= remaining) return candidate;
      }
    }
    return null;
  }

  @override
  bool operator ==(Object other) =>
      other is RhythmicDuration &&
      type == other.type &&
      dots == other.dots &&
      timeModification == other.timeModification;

  @override
  int get hashCode => Object.hash(type, dots, timeModification);

  @override
  String toString() =>
      '${type.xmlName}${'.' * dots}${timeModification.isNone ? '' : ' $timeModification'}';
}
