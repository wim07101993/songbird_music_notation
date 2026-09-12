import 'package:songbird_score/src/theory/interval.dart';
import 'package:songbird_score/src/theory/pitch.dart';

/// The church modes plus the modern major/minor names MusicXML also uses.
enum Mode {
  major(0),
  minor(3),
  ionian(0),
  dorian(2),
  phrygian(4),
  lydian(-1),
  mixolydian(1),
  aeolian(3),
  locrian(5),
  none(0);

  const Mode(
    this.fifthsOffsetFromTonic,
  );

  /// How far around the circle of fifths the tonic sits from the signature's
  /// major key: D dorian and C major share a signature, so dorian is +2.
  final int fifthsOffsetFromTonic;
}

/// A key signature: a position on the circle of fifths plus a mode.
///
/// Stored as [fifths] rather than as a tonic because that is what a signature
/// actually is — G major and E minor print identically.
class KeySignature {
  /// Creates a signature [fifths] steps around the circle of fifths.
  ///
  /// Only -7 to 7 can be printed; wider values arise while transposing and are
  /// folded back by [normalized], so they are allowed here rather than being
  /// an error in the middle of an edit.
  const KeySignature({
    this.fifths = 0,
    this.mode = Mode.major,
  }) : assert(fifths >= -40 && fifths <= 40, 'fifths absurdly out of range');

  /// The signature with [tonic] as its tonic in [mode], if one exists within
  /// the writable range of the circle of fifths.
  factory KeySignature.forTonic(
    Pitch tonic, {
    Mode mode = Mode.major,
  }) {
    final base = _fifthsForStep(tonic.step) + (tonic.alter.round() * 7);
    return KeySignature(fifths: base - mode.fifthsOffsetFromTonic, mode: mode);
  }

  static const KeySignature cMajor = KeySignature();

  /// Signed count of accidentals: positive for sharps, negative for flats.
  final int fifths;

  final Mode mode;

  /// Whether this signature can be written with seven accidentals or fewer.
  bool get isPrintable => fifths >= -7 && fifths <= 7;

  /// The same sounding key folded into the range that can be printed.
  ///
  /// Transposing can land on a key like fourteen sharps, which is the same
  /// sound as two flats and is what a reader should be shown.
  KeySignature get normalized {
    var result = fifths;
    while (result > 7) {
      result -= 12;
    }
    while (result < -7) {
      result += 12;
    }
    return result == fifths ? this : KeySignature(fifths: result, mode: mode);
  }

  int get sharpCount => fifths > 0 ? fifths : 0;
  int get flatCount => fifths < 0 ? -fifths : 0;

  /// The steps carrying a sharp or a flat, in the order they are printed.
  List<Step> get alteredSteps {
    if (fifths > 0) return _sharpOrder.take(fifths.clamp(0, 7)).toList();
    if (fifths < 0) return _flatOrder.take((-fifths).clamp(0, 7)).toList();
    return const [];
  }

  /// The alteration the signature applies to [step], in semitones.
  double alterationFor(Step step) {
    if (fifths > 0) {
      final position = _sharpOrder.indexOf(step);
      return position >= 0 && position < fifths ? 1 : 0;
    }
    if (fifths < 0) {
      final position = _flatOrder.indexOf(step);
      return position >= 0 && position < -fifths ? -1 : 0;
    }
    return 0;
  }

  /// The tonic of this key in the given mode, spelled correctly.
  Pitch tonic({int octave = 4}) {
    final index = fifths + mode.fifthsOffsetFromTonic;
    final step = Step.fromDiatonicIndex((index * 4) % 7);
    final alter = ((index + 1) / 7).floor().toDouble();
    return Pitch(step, octave, alter: alter);
  }

  /// The signature reached by transposing this one by [interval].
  ///
  /// The result is normalised back into the printable range: transposing
  /// C flat major up would otherwise land on a signature with more than seven
  /// flats, so it is respelled enharmonically instead.
  KeySignature transposed(Interval interval) =>
      KeySignature(fifths: fifths + interval.fifths, mode: mode).normalized;

  KeySignature copyWith({int? fifths, Mode? mode}) =>
      KeySignature(fifths: fifths ?? this.fifths, mode: mode ?? this.mode);

  @override
  bool operator ==(Object other) =>
      other is KeySignature && fifths == other.fifths && mode == other.mode;

  @override
  int get hashCode => Object.hash(fifths, mode);

  @override
  String toString() => '${tonic()} ${mode.name} ($fifths)';

  static const List<Step> _sharpOrder = [
    Step.f,
    Step.c,
    Step.g,
    Step.d,
    Step.a,
    Step.e,
    Step.b,
  ];
  static const List<Step> _flatOrder = [
    Step.b,
    Step.e,
    Step.a,
    Step.d,
    Step.g,
    Step.c,
    Step.f,
  ];

  /// Position of a natural letter name on the circle of fifths, F = -1 … B = 5.
  static int _fifthsForStep(Step step) => switch (step) {
    Step.f => -1,
    Step.c => 0,
    Step.g => 1,
    Step.d => 2,
    Step.a => 3,
    Step.e => 4,
    Step.b => 5,
  };
}
