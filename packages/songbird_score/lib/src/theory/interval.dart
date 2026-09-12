import 'package:songbird_score/src/theory/key.dart';
import 'package:songbird_score/src/theory/pitch.dart';

/// How an interval is spelled relative to its diatonic size.
enum IntervalQuality {
  doublyDiminished('dd'),
  diminished('d'),
  minor('m'),
  perfect('P'),
  major('M'),
  augmented('A'),
  doublyAugmented('AA');

  const IntervalQuality(
    this.symbol,
  );

  /// The short form used when printing an interval, as in `P5` or `m3`.
  final String symbol;
}

/// A directed distance between two pitches, measured both diatonically and
/// chromatically.
///
/// Both numbers are needed: a diminished fourth and a major third sound alike
/// but move a different number of letter names, and only the diatonic component
/// tells transposition which letter the result should be spelled with.
class Interval {
  /// Creates an interval spanning [diatonicSteps] letter names and
  /// [chromaticSemitones] semitones. Negative values point downwards.
  const Interval(
    this.diatonicSteps,
    this.chromaticSemitones,
  );

  /// The interval that maps [from] onto [to].
  factory Interval.between(
    Pitch from,
    Pitch to,
  ) => Interval(
    to.diatonicValue - from.diatonicValue,
    to.midiNumber - from.midiNumber,
  );

  /// Builds an interval from its musician's name, e.g. a major third is
  /// `Interval.named(3, IntervalQuality.major)`.
  ///
  /// [number] is the ordinal name (1 = unison, 5 = fifth, 8 = octave) and must
  /// be at least 1; pass `descending: true` for a downward interval.
  factory Interval.named(
    int number,
    IntervalQuality quality, {
    bool descending = false,
  }) {
    if (number < 1) {
      throw ArgumentError.value(
        number,
        'number',
        'interval numbers start at 1',
      );
    }
    final steps = number - 1;
    final simple = steps % 7;
    final octaves = steps ~/ 7;
    final natural = _naturalSemitones[simple] + octaves * 12;
    final deviation = _deviation(simple, quality);
    if (deviation == null) {
      throw ArgumentError.value(
        quality,
        'quality',
        'a ${_ordinal(number)} cannot be ${quality.name}',
      );
    }
    final semitones = natural + deviation;
    return descending
        ? Interval(-steps, -semitones)
        : Interval(steps, semitones);
  }

  /// An interval of [semitones] with a plausible spelling, for cases where only
  /// a chromatic distance is known (a transpose-by-semitones control, MIDI
  /// input). Prefers the spelling used by the common key signatures.
  factory Interval.chromatic(
    int semitones,
  ) {
    final octaves = (semitones / 12).floor();
    final within = semitones - octaves * 12;
    final steps = _defaultDiatonicForSemitone[within] + octaves * 7;
    return Interval(steps, semitones);
  }

  /// A whole number of octaves, up for positive [count].
  factory Interval.octaves(
    int count,
  ) => Interval(count * 7, count * 12);

  static const Interval unison = Interval(0, 0);

  /// Signed count of letter names crossed; 0 is a unison, 4 a fifth up.
  final int diatonicSteps;

  /// Signed count of semitones.
  final int chromaticSemitones;

  bool get isDescending =>
      diatonicSteps < 0 || (diatonicSteps == 0 && chromaticSemitones < 0);
  bool get isUnison => diatonicSteps == 0 && chromaticSemitones == 0;

  /// Ordinal name: 1 for a unison, 5 for a fifth, 9 for a ninth.
  int get number => diatonicSteps.abs() + 1;

  /// The interval with the same size pointing the other way.
  Interval get inverted => Interval(-diatonicSteps, -chromaticSemitones);

  /// How far this interval moves a key around the circle of fifths.
  ///
  /// A perfect fifth up moves it one step, a major second two, a minor second
  /// five back. This is what says a piece in D major transposed up a minor
  /// second is in E flat major and not in D sharp.
  int get fifths => 7 * chromaticSemitones - 12 * diatonicSteps;

  /// The interval of [semitones] that lands a piece in [from] on the most
  /// readable key.
  ///
  /// Transposing up a semitone means an augmented unison from E flat (giving
  /// E) but a minor second from D (giving E flat) — the same sound, spelled to
  /// keep the key signature small.
  factory Interval.chromaticFromKey(
    int semitones,
    KeySignature from,
  ) {
    // Choosing the letter distance that brings the resulting key closest to C
    // is exactly the choice an engraver makes.
    final steps = ((from.fifths + 7 * semitones) / 12).round();
    return Interval(steps, semitones);
  }

  /// How this interval is spelled, or `null` if it is stretched further than a
  /// doubly augmented/diminished interval.
  IntervalQuality? get quality {
    final steps = diatonicSteps.abs();
    final semitones = chromaticSemitones.abs();
    if (diatonicSteps.sign * chromaticSemitones.sign < 0) return null;
    final simple = steps % 7;
    final octaves = steps ~/ 7;
    final deviation = semitones - (_naturalSemitones[simple] + octaves * 12);
    final table = _isPerfectType(simple) ? _perfectQualities : _majorQualities;
    return table[deviation];
  }

  /// Adds two intervals, as in stacking a third on top of a fifth.
  Interval operator +(Interval other) => Interval(
    diatonicSteps + other.diatonicSteps,
    chromaticSemitones + other.chromaticSemitones,
  );

  Interval operator -(Interval other) => this + other.inverted;

  Interval operator -() => inverted;

  /// The transposition of [pitch] by this interval, with the letter name that
  /// keeps the interval's spelling intact.
  Pitch transpose(Pitch pitch) {
    final diatonic = pitch.diatonicValue + diatonicSteps;
    final step = Step.fromDiatonicIndex(diatonic % 7);
    final octave = (diatonic / 7).floor();
    final targetChromatic = pitch.chromaticValue + chromaticSemitones;
    final naturalChromatic = (octave + 1) * 12 + step.semitonesAboveC;
    return Pitch(step, octave, alter: targetChromatic - naturalChromatic);
  }

  @override
  bool operator ==(Object other) =>
      other is Interval &&
      diatonicSteps == other.diatonicSteps &&
      chromaticSemitones == other.chromaticSemitones;

  @override
  int get hashCode => Object.hash(diatonicSteps, chromaticSemitones);

  @override
  String toString() {
    final sign = isDescending ? '-' : '';
    final q = quality?.symbol ?? '?';
    return '$sign$q$number';
  }

  static const List<int> _naturalSemitones = [0, 2, 4, 5, 7, 9, 11];

  /// Semitone-to-letter choices that reproduce the usual spellings: a minor
  /// second rather than an augmented unison, a minor third rather than an
  /// augmented second, and a tritone spelled as an augmented fourth.
  ///
  /// Preferring the minor second matters: transposing up a semitone four times
  /// with augmented unisons would spell C as C quadruple sharp, which is not
  /// music anyone can read.
  static const List<int> _defaultDiatonicForSemitone = [
    0, // unison
    1, // minor second
    1, // major second
    2, // minor third
    2, // major third
    3, // perfect fourth
    3, // augmented fourth
    4, // perfect fifth
    5, // minor sixth
    5, // major sixth
    6, // minor seventh
    6, // major seventh
  ];

  static bool _isPerfectType(int simpleSteps) =>
      simpleSteps == 0 || simpleSteps == 3 || simpleSteps == 4;

  static const Map<int, IntervalQuality> _perfectQualities = {
    -2: IntervalQuality.doublyDiminished,
    -1: IntervalQuality.diminished,
    0: IntervalQuality.perfect,
    1: IntervalQuality.augmented,
    2: IntervalQuality.doublyAugmented,
  };

  static const Map<int, IntervalQuality> _majorQualities = {
    -3: IntervalQuality.doublyDiminished,
    -2: IntervalQuality.diminished,
    -1: IntervalQuality.minor,
    0: IntervalQuality.major,
    1: IntervalQuality.augmented,
    2: IntervalQuality.doublyAugmented,
  };

  static int? _deviation(int simpleSteps, IntervalQuality quality) {
    final table = _isPerfectType(simpleSteps)
        ? _perfectQualities
        : _majorQualities;
    for (final entry in table.entries) {
      if (entry.value == quality) return entry.key;
    }
    return null;
  }

  static String _ordinal(int n) => switch (n) {
    1 => 'unison',
    2 => 'second',
    3 => 'third',
    4 => 'fourth',
    5 => 'fifth',
    6 => 'sixth',
    7 => 'seventh',
    8 => 'octave',
    _ => '${n}th',
  };
}
