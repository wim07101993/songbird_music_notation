import 'package:songbird_score/src/theory/pitch.dart';

/// The shape drawn at the start of a staff.
enum ClefSign { g, f, c, percussion, tab, none, jianpu }

/// A clef: which sign, on which staff line, optionally sounding an octave away.
///
/// A clef's job in this model is to answer one question — where on the staff
/// does a given pitch sit — which is what [staffPositionOf] provides. Which
/// staff it applies to is not part of it: clefs are held in a map keyed by
/// staff number, so two staves sharing a bass clef share one value.
class Clef {
  const Clef({
    required this.sign,
    required this.line,
    this.octaveChange = 0,
  });

  /// Treble clef: G on the second line.
  static const Clef treble = Clef(sign: ClefSign.g, line: 2);

  /// Bass clef: F on the fourth line.
  static const Clef bass = Clef(sign: ClefSign.f, line: 4);

  /// Alto clef: C on the middle line.
  static const Clef alto = Clef(sign: ClefSign.c, line: 3);

  /// Tenor clef: C on the fourth line.
  static const Clef tenor = Clef(sign: ClefSign.c, line: 4);

  /// Treble clef sounding an octave below, as written for tenor voices.
  static const Clef trebleOctaveDown = Clef(
    sign: ClefSign.g,
    line: 2,
    octaveChange: -1,
  );

  static const Clef percussion = Clef(sign: ClefSign.percussion, line: 3);

  final ClefSign sign;

  /// Staff line the sign is centred on, counted from the bottom line as 1.
  final int line;

  /// Octave transposition of the clef; -1 sounds an octave below what is
  /// written, as in a tenor's treble clef.
  final int octaveChange;

  /// Whether the clef fixes pitches to staff positions at all. Percussion and
  /// tablature clefs do not.
  bool get isPitched =>
      sign == ClefSign.g || sign == ClefSign.f || sign == ClefSign.c;

  /// The diatonic value of the pitch the sign names.
  int get _referenceDiatonic => switch (sign) {
    ClefSign.g => const Pitch(Step.g, 4).diatonicValue,
    ClefSign.f => const Pitch(Step.f, 3).diatonicValue,
    ClefSign.c => const Pitch(Step.c, 4).diatonicValue,
    _ => const Pitch(Step.b, 4).diatonicValue,
  };

  /// Vertical position of [pitch] in half staff spaces above the bottom line.
  ///
  /// One unit is the step from a line to the adjacent space, so the five lines
  /// of a staff sit at 0, 2, 4, 6 and 8. Values below 0 or above 8 need ledger
  /// lines.
  int staffPositionOf(Pitch pitch) =>
      (line - 1) * 2 +
      (pitch.diatonicValue - _referenceDiatonic) -
      7 * octaveChange;

  /// The pitch written at [staffPosition], the inverse of [staffPositionOf].
  ///
  /// Returns the natural spelling; the caller applies the key signature and any
  /// accidental in force.
  Pitch pitchAtStaffPosition(int staffPosition) {
    final diatonic =
        staffPosition - (line - 1) * 2 + _referenceDiatonic + 7 * octaveChange;
    return Pitch(Step.fromDiatonicIndex(diatonic % 7), (diatonic / 7).floor());
  }

  /// The default position for middle-of-staff decisions such as stem direction.
  static const int middleLinePosition = 4;

  Clef copyWith({ClefSign? sign, int? line, int? octaveChange}) => Clef(
    sign: sign ?? this.sign,
    line: line ?? this.line,
    octaveChange: octaveChange ?? this.octaveChange,
  );

  @override
  bool operator ==(Object other) =>
      other is Clef &&
      sign == other.sign &&
      line == other.line &&
      octaveChange == other.octaveChange;

  @override
  int get hashCode => Object.hash(sign, line, octaveChange);

  @override
  String toString() =>
      'Clef(${sign.name}$line${octaveChange != 0 ? ', 8va $octaveChange' : ''})';
}
