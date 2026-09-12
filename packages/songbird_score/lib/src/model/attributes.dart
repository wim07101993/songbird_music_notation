import 'package:songbird_score/src/theory/clef.dart';
import 'package:songbird_score/src/theory/fraction.dart';
import 'package:songbird_score/src/theory/interval.dart';
import 'package:songbird_score/src/theory/key.dart';
import 'package:songbird_score/src/theory/time_signature.dart';

/// Applies to every staff of the part rather than to one in particular.
const int allStaves = 0;

/// How an instrument's written pitch relates to its sounding pitch.
///
/// A B flat clarinet's written C sounds a B flat below, which is
/// `Transpose(interval: Interval(-1, -2))`.
class Transpose {
  const Transpose({
    this.interval = Interval.unison,
    this.doubled = false,
  });

  /// From written pitch to sounding pitch.
  final Interval interval;

  /// The part also sounds an octave below what is written.
  final bool doubled;

  bool get isNone => interval.isUnison && !doubled;

  /// The full displacement including the octave doubling.
  Interval get effectiveInterval =>
      doubled ? interval + Interval.octaves(-1) : interval;

  @override
  bool operator ==(Object other) =>
      other is Transpose &&
      interval == other.interval &&
      doubled == other.doubled;

  @override
  int get hashCode => Object.hash(interval, doubled);

  @override
  String toString() => 'Transpose($interval${doubled ? ', doubled' : ''})';
}

/// A single string of a tablature staff.
class StaffTuning {
  const StaffTuning({
    required this.line,
    required this.step,
    required this.octave,
    this.alter = 0,
  });

  final int line;
  final String step;
  final int octave;
  final double alter;
}

/// Per-staff appearance: how many lines it has, whether it is a tablature or
/// cue staff, and how its strings are tuned.
class StaffDetails {
  const StaffDetails({
    this.staffLines = 5,
    this.tunings = const [],
    this.capo,
    this.staffSize,
    this.showFrets,
    this.printObject = true,
    this.printSpacing = true,
    this.staffType,
  });

  final int staffLines;
  final List<StaffTuning> tunings;
  final int? capo;

  /// Size relative to the score's normal staff size, as a percentage.
  final double? staffSize;

  final String? showFrets;
  final bool printObject;
  final bool printSpacing;

  /// `regular`, `ossia`, `editorial`, `cue` or `alternate`.
  final String? staffType;
}

/// Multi-measure rests and the various repeat-shorthand notations.
class MeasureStyle {
  const MeasureStyle({
    this.staffNumber,
    this.multipleRest,
    this.multipleRestUseSymbols = false,
    this.measureRepeatSlashes,
    this.measureRepeatType,
    this.beatRepeatSlashes,
    this.beatRepeatType,
    this.slashType,
    this.slashDots,
    this.slashStart,
  });

  final int? staffNumber;

  /// How many measures a multi-measure rest covers.
  final int? multipleRest;
  final bool multipleRestUseSymbols;

  final int? measureRepeatSlashes;

  /// `start` or `stop`.
  final String? measureRepeatType;

  final int? beatRepeatSlashes;
  final String? beatRepeatType;

  final String? slashType;
  final int? slashDots;
  final String? slashStart;
}

/// Everything a measure can declare about how the following music is written.
///
/// Only the fields actually stated in the source are filled in; the effective
/// state at any point comes from [MusicalContext], which accumulates these.
class MeasureAttributes {
  MeasureAttributes({
    this.divisions,
    Map<int, KeySignature>? keys,
    this.time,
    this.staves,
    Map<int, Clef>? clefs,
    Map<int, Transpose>? transposes,
    Map<int, StaffDetails>? staffDetails,
    List<MeasureStyle>? measureStyles,
    this.instruments,
  }) : keys = keys ?? {},
       clefs = clefs ?? {},
       transposes = transposes ?? {},
       staffDetails = staffDetails ?? {},
       measureStyles = measureStyles ?? [];

  /// Divisions per quarter note, kept only so MusicXML export can reproduce the
  /// source's own unit. Nothing in the model depends on it.
  int? divisions;

  /// Key signatures by staff number; [allStaves] for one that applies to all.
  Map<int, KeySignature> keys;

  TimeSignature? time;

  /// Whether the time signature stated here is printed.
  ///
  /// A file may state one without showing it — an excerpt taken from the
  /// middle of a movement carries its metre without announcing it again — and
  /// what it states still governs the beaming and the bar lengths.
  bool printTime = true;

  /// How many staves the part uses from here on.
  int? staves;

  /// Clefs by staff number.
  Map<int, Clef> clefs;

  /// Instrument transposition by staff number.
  Map<int, Transpose> transposes;

  Map<int, StaffDetails> staffDetails;
  List<MeasureStyle> measureStyles;

  /// How many instruments sound at once, for percussion parts.
  int? instruments;

  bool get isEmpty =>
      divisions == null &&
      keys.isEmpty &&
      time == null &&
      staves == null &&
      clefs.isEmpty &&
      transposes.isEmpty &&
      staffDetails.isEmpty &&
      measureStyles.isEmpty &&
      instruments == null;

  MeasureAttributes copy() => MeasureAttributes(
    divisions: divisions,
    keys: {...keys},
    time: time,
    staves: staves,
    clefs: {...clefs},
    transposes: {...transposes},
    staffDetails: {...staffDetails},
    measureStyles: [...measureStyles],
    instruments: instruments,
  )..printTime = printTime;
}

/// A set of attribute changes taking effect part-way through a measure, which
/// is how mid-measure clef changes are written.
class AttributeChange {
  AttributeChange({
    required this.position,
    required this.attributes,
  });

  /// Offset from the start of the measure, in whole notes.
  Fraction position;

  MeasureAttributes attributes;

  AttributeChange copy() =>
      AttributeChange(position: position, attributes: attributes.copy());
}

/// The attributes actually in force at some point in the music.
///
/// Built by walking measures from the start of the part and layering each
/// [MeasureAttributes] on top of the previous state, which is what a reader
/// does: a clef stated in measure 1 still applies in measure 40.
class MusicalContext {
  MusicalContext({
    this.divisions = 1,
    Map<int, KeySignature>? keys,
    TimeSignature? time,
    this.staffCount = 1,
    Map<int, Clef>? clefs,
    Map<int, Transpose>? transposes,
    Map<int, StaffDetails>? staffDetails,
    this.printTime = true,
  }) : keys = keys ?? {allStaves: KeySignature.cMajor},
       time = time ?? TimeSignature.commonTime,
       clefs = clefs ?? {1: Clef.treble},
       transposes = transposes ?? {},
       staffDetails = staffDetails ?? {};

  int divisions;
  Map<int, KeySignature> keys;
  TimeSignature time;
  int staffCount;
  Map<int, Clef> clefs;
  Map<int, Transpose> transposes;
  Map<int, StaffDetails> staffDetails;

  /// Whether the time signature in force is printed. See
  /// [MeasureAttributes.printTime].
  bool printTime;

  KeySignature keyFor(int staff) =>
      keys[staff] ?? keys[allStaves] ?? KeySignature.cMajor;

  Clef clefFor(int staff) => clefs[staff] ?? clefs[allStaves] ?? Clef.treble;

  Transpose transposeFor(int staff) =>
      transposes[staff] ?? transposes[allStaves] ?? const Transpose();

  StaffDetails detailsFor(int staff) =>
      staffDetails[staff] ?? staffDetails[allStaves] ?? const StaffDetails();

  /// Folds [attributes] into this context, in place.
  void apply(MeasureAttributes attributes) {
    if (attributes.divisions != null) divisions = attributes.divisions!;
    if (attributes.time != null) {
      time = attributes.time!;
      printTime = attributes.printTime;
    }
    if (attributes.staves != null) staffCount = attributes.staves!;
    if (attributes.keys.containsKey(allStaves)) keys.clear();
    keys.addAll(attributes.keys);
    clefs.addAll(attributes.clefs);
    transposes.addAll(attributes.transposes);
    staffDetails.addAll(attributes.staffDetails);
  }

  MusicalContext copy() => MusicalContext(
    divisions: divisions,
    keys: {...keys},
    time: time,
    staffCount: staffCount,
    clefs: {...clefs},
    transposes: {...transposes},
    staffDetails: {...staffDetails},
    printTime: printTime,
  );
}
