import 'package:songbird_score/src/theory/fraction.dart';

/// How a time signature is drawn.
enum TimeSymbol {
  /// Two stacked numbers, the default.
  normal,

  /// The C of common time.
  common,

  /// The struck-through C of cut time.
  cut,

  /// Only the number of beats is shown.
  singleNumber,

  /// The numbers are shown without a signature at all.
  note,
  dottedNote,
  none,
}

/// One `beats/beat-type` pair. Most signatures have exactly one; additive
/// signatures such as 3+2/8 have several.
class TimeSignatureComponent {
  const TimeSignatureComponent(
    this.beats,
    this.beatType,
  );

  /// The numerator. A list, because MusicXML writes `3+2` as a single
  /// `<beats>` element.
  final List<int> beats;

  /// The denominator: the note value that gets one beat.
  final int beatType;

  int get totalBeats => beats.fold(0, (sum, b) => sum + b);

  Fraction get duration => Fraction(totalBeats, beatType);

  @override
  bool operator ==(Object other) =>
      other is TimeSignatureComponent &&
      beatType == other.beatType &&
      beats.length == other.beats.length &&
      List.generate(
        beats.length,
        (i) => beats[i] == other.beats[i],
      ).every((e) => e);

  @override
  int get hashCode => Object.hash(Object.hashAll(beats), beatType);

  @override
  String toString() => '${beats.join('+')}/$beatType';
}

/// A time signature, including the interchangeable and additive forms.
class TimeSignature {
  const TimeSignature(
    this.components, {
    this.symbol = TimeSymbol.normal,
    this.interchangeable,
  });

  /// The usual case: a single `beats/beatType` pair.
  factory TimeSignature.simple(
    int beats,
    int beatType, {
    TimeSymbol symbol = TimeSymbol.normal,
  }) => TimeSignature([
    TimeSignatureComponent([beats], beatType),
  ], symbol: symbol);

  static final TimeSignature commonTime = TimeSignature.simple(
    4,
    4,
    symbol: TimeSymbol.common,
  );
  static final TimeSignature cutTime = TimeSignature.simple(
    2,
    2,
    symbol: TimeSymbol.cut,
  );

  /// One entry per `beats`/`beat-type` pair.
  final List<TimeSignatureComponent> components;

  final TimeSymbol symbol;

  /// An equivalent signature the music may also be read in, printed in
  /// parentheses after the main one.
  final TimeSignature? interchangeable;

  TimeSignatureComponent get primary => components.first;

  int get beats => primary.totalBeats;
  int get beatType => primary.beatType;

  /// Length of one full measure in whole notes.
  Fraction get measureDuration => components.fold(
    Fraction.zero,
    (sum, component) => sum + component.duration,
  );

  /// Length of one beat as counted by a conductor: a dotted quarter in 6/8, a
  /// quarter in 4/4.
  Fraction get beatUnit {
    final isCompound = beatType >= 8 && beats % 3 == 0 && beats > 3;
    return isCompound ? Fraction(3, beatType) : Fraction(1, beatType);
  }

  /// Which beats of the measure carry a metric accent, as offsets from the
  /// start. Beaming and rest grouping follow these.
  List<Fraction> get strongBeats {
    final unit = beatUnit;
    final total = measureDuration;
    final result = <Fraction>[];
    var at = Fraction.zero;
    while (at < total) {
      result.add(at);
      at = at + unit;
    }
    return result;
  }

  @override
  bool operator ==(Object other) =>
      other is TimeSignature &&
      symbol == other.symbol &&
      components.length == other.components.length &&
      List.generate(
        components.length,
        (i) => components[i] == other.components[i],
      ).every((e) => e);

  @override
  int get hashCode => Object.hash(Object.hashAll(components), symbol);

  @override
  String toString() => components.join(' + ');
}
