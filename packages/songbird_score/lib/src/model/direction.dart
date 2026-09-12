import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/notations.dart';
import 'package:songbird_score/src/theory/fraction.dart';

/// The dynamic marks MusicXML names explicitly.
enum DynamicMark {
  p,
  pp,
  ppp,
  pppp,
  ppppp,
  pppppp,
  f,
  ff,
  fff,
  ffff,
  fffff,
  ffffff,
  mp,
  mf,
  sf,
  sfp,
  sfpp,
  fp,
  rf,
  rfz,
  sfz,
  sffz,
  fz,
  n,
  pf,
  sfzp,
}

/// The direction of a hairpin.
enum WedgeType { crescendo, diminuendo, stop, wedgeContinue }

/// The kind of bracketed octave transposition line.
enum OctaveShiftType { up, down, stop, octaveContinue }

enum PedalType {
  start,
  stop,
  sostenuto,
  change,
  pedalContinue,
  discontinue,
  resume,
}

/// What a [Direction] actually says. One direction can carry several of these,
/// which is how MusicXML groups a dynamic with its hairpin.
sealed class DirectionType {
  const DirectionType();
}

/// A dynamic marking such as `mf`.
class DynamicsDirection extends DirectionType {
  const DynamicsDirection(
    this.marks, {
    this.otherText,
  });

  final List<DynamicMark> marks;

  /// Free text for dynamics outside the standard list.
  final String? otherText;
}

/// Free text placed above or below the staff.
class WordsDirection extends DirectionType {
  const WordsDirection(
    this.text, {
    this.fontStyle,
    this.fontWeight,
    this.fontSize,
  });

  final String text;
  final String? fontStyle;
  final String? fontWeight;
  final double? fontSize;
}

/// A hairpin.
class WedgeDirection extends DirectionType {
  const WedgeDirection(
    this.type, {
    this.number = 1,
    this.spread,
  });

  final WedgeType type;

  /// Distinguishes overlapping hairpins in the same part.
  final int number;

  /// The opening of the hairpin at this end, in tenths.
  final double? spread;
}

/// A metronome mark, either `note = number` or `note = note`.
class MetronomeDirection extends DirectionType {
  const MetronomeDirection({
    required this.beatUnit,
    this.beatUnitDots = 0,
    this.perMinute,
    this.secondBeatUnit,
    this.secondBeatUnitDots = 0,
    this.parentheses = false,
  });

  /// The note value on the left of the equals sign, as a MusicXML type name.
  final String beatUnit;
  final int beatUnitDots;

  /// The tempo in beats per minute, when the right side is a number.
  final double? perMinute;

  /// The note value on the right, for a metric modulation.
  final String? secondBeatUnit;
  final int secondBeatUnitDots;

  final bool parentheses;
}

/// A bracketed 8va/8vb line.
class OctaveShiftDirection extends DirectionType {
  const OctaveShiftDirection(
    this.type, {
    this.size = 8,
    this.number = 1,
  });

  final OctaveShiftType type;

  /// 8, 15 or 22 for one, two or three octaves.
  final int size;
  final int number;

  /// How many diatonic steps the written pitches are displaced by.
  int get diatonicOffset => switch (size) {
    15 => 14,
    22 => 21,
    _ => 7,
  };
}

/// A piano pedal marking.
class PedalDirection extends DirectionType {
  const PedalDirection(
    this.type, {
    this.line = false,
    this.sign = true,
  });

  final PedalType type;

  /// Drawn as a bracketed line rather than as `Ped.`/`*`.
  final bool line;
  final bool sign;
}

/// A rehearsal mark.
class RehearsalDirection extends DirectionType {
  const RehearsalDirection(
    this.text, {
    this.enclosure = 'square',
  });

  final String text;
  final String enclosure;
}

/// A segno, coda or other navigation sign.
class SegnoDirection extends DirectionType {
  const SegnoDirection();
}

class CodaDirection extends DirectionType {
  const CodaDirection();
}

/// A direction whose type this model does not interpret, kept so that export
/// can put it back.
class UnknownDirection extends DirectionType {
  const UnknownDirection(
    this.elementName,
  );

  final String elementName;
}

/// A performance instruction attached to a point in the music rather than to a
/// note: dynamics, tempo, hairpins, pedal, text.
class Direction extends MusicalEvent {
  Direction({
    required super.position,
    required this.types,
    super.voice,
    super.staff,
    this.placement = Placement.below,
    this.sound,
  });

  /// One direction can say several things at once.
  List<DirectionType> types;

  Placement placement;

  /// Playback information carried alongside, chiefly a tempo change.
  SoundInfo? sound;

  @override
  Fraction get duration => Fraction.zero;

  @override
  Direction copy() => Direction(
    position: position,
    types: [...types],
    voice: voice,
    staff: staff,
    placement: placement,
    sound: sound,
  );

  @override
  String toString() => 'Direction(@$position, ${types.length} type(s))';
}

/// Playback instructions, which MusicXML attaches to directions and measures.
class SoundInfo {
  const SoundInfo({
    this.tempo,
    this.dynamics,
    this.dacapo = false,
    this.segno,
    this.dalsegno,
    this.coda,
    this.tocoda,
    this.fine,
    this.forwardRepeat = false,
    this.pizzicato,
  });

  /// Quarter notes per minute.
  final double? tempo;

  /// Velocity as a percentage of a forte.
  final double? dynamics;

  final bool dacapo;
  final String? segno;
  final String? dalsegno;
  final String? coda;
  final String? tocoda;
  final String? fine;
  final bool forwardRepeat;
  final bool? pizzicato;
}
