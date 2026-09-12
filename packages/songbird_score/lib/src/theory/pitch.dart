import 'dart:math' as math;

/// The seven diatonic letter names, ordered C through B as within an octave.
enum Step {
  c('C', 0),
  d('D', 2),
  e('E', 4),
  f('F', 5),
  g('G', 7),
  a('A', 9),
  b('B', 11);

  const Step(
    this.name,
    this.semitonesAboveC,
  );

  /// The single upper-case letter used by MusicXML and by musicians.
  final String name;

  /// Distance in semitones from C within the same octave, unaltered.
  final int semitonesAboveC;

  /// Position in the diatonic scale, C = 0 … B = 6.
  int get diatonicIndex => index;

  static Step fromName(String name) {
    final upper = name.trim().toUpperCase();
    return Step.values.firstWhere(
      (s) => s.name == upper,
      orElse: () =>
          throw ArgumentError.value(name, 'name', 'not a step letter'),
    );
  }

  static Step fromDiatonicIndex(int index) => Step.values[index % 7];
}

/// A written pitch: a letter name, a chromatic alteration and an octave.
///
/// Spelling is part of the identity — F sharp and G flat are different
/// [Pitch]es that happen to share a [midiNumber]. Keeping them distinct is what
/// lets transposition produce readable accidentals instead of arbitrary ones.
class Pitch implements Comparable<Pitch> {
  const Pitch(
    this.step,
    this.octave, {
    this.alter = 0,
  });

  /// Parses scientific pitch notation such as `C4`, `F#3`, `Bb5`, `Cx4`
  /// (double sharp) or `Dbb2`.
  factory Pitch.parse(
    String source,
  ) {
    final text = source.trim();
    if (text.isEmpty) throw ArgumentError.value(source, 'source', 'empty');
    final step = Step.fromName(text[0]);
    var i = 1;
    var alter = 0.0;
    while (i < text.length) {
      final c = text[i];
      if (c == '#') {
        alter += 1;
      } else if (c == 'x') {
        alter += 2;
      } else if (c == 'b') {
        alter -= 1;
      } else {
        break;
      }
      i++;
    }
    final octave = int.tryParse(text.substring(i));
    if (octave == null) {
      throw ArgumentError.value(source, 'source', 'missing octave number');
    }
    return Pitch(step, octave, alter: alter);
  }

  /// Reconstructs a spelling from a MIDI number, preferring [sharps] or flats.
  ///
  /// Only for pitches that have no spelling of their own, such as those coming
  /// from a MIDI keyboard; anything already spelled should keep its spelling.
  factory Pitch.fromMidiNumber(
    int midi, {
    bool sharps = true,
  }) {
    const sharpSpelling = <(Step, int)>[
      (Step.c, 0),
      (Step.c, 1),
      (Step.d, 0),
      (Step.d, 1),
      (Step.e, 0),
      (Step.f, 0),
      (Step.f, 1),
      (Step.g, 0),
      (Step.g, 1),
      (Step.a, 0),
      (Step.a, 1),
      (Step.b, 0),
    ];
    const flatSpelling = <(Step, int)>[
      (Step.c, 0),
      (Step.d, -1),
      (Step.d, 0),
      (Step.e, -1),
      (Step.e, 0),
      (Step.f, 0),
      (Step.g, -1),
      (Step.g, 0),
      (Step.a, -1),
      (Step.a, 0),
      (Step.b, -1),
      (Step.b, 0),
    ];
    final octave = (midi ~/ 12) - 1;
    final within = midi % 12;
    final (step, alter) = (sharps ? sharpSpelling : flatSpelling)[within];
    return Pitch(step, octave, alter: alter.toDouble());
  }

  /// The letter name.
  final Step step;

  /// Octave in scientific pitch notation; middle C is `C4`.
  final int octave;

  /// Chromatic alteration in semitones. Fractional values carry microtones,
  /// as MusicXML allows (`0.5` is a quarter-tone sharp).
  final double alter;

  /// Octave-independent diatonic position, so that consecutive letter names
  /// differ by exactly one regardless of accidentals.
  int get diatonicValue => octave * 7 + step.diatonicIndex;

  /// Sounding pitch in semitones above C-1, ignoring microtonal alteration.
  int get midiNumber =>
      (octave + 1) * 12 + step.semitonesAboveC + alter.round();

  /// Sounding pitch in semitones, retaining microtones.
  double get chromaticValue => (octave + 1) * 12 + step.semitonesAboveC + alter;

  /// Concert frequency in Hz at the given tuning reference.
  double get frequency => a4 * math.pow(2, (chromaticValue - 69) / 12);

  static const double a4 = 440;

  /// The same sounding pitch with a different spelling, or `null` when no
  /// enharmonic exists within a double accidental.
  Pitch? enharmonic({required int letterOffset}) {
    final newStep = Step.fromDiatonicIndex(step.diatonicIndex + letterOffset);
    final octaveShift = ((step.diatonicIndex + letterOffset) / 7).floor();
    final newOctave = octave + octaveShift;
    final newAlter =
        chromaticValue - ((newOctave + 1) * 12 + newStep.semitonesAboveC);
    if (newAlter.abs() > 2) return null;
    return Pitch(newStep, newOctave, alter: newAlter);
  }

  /// The same sound spelled with at most a double accidental, if it can be.
  ///
  /// Transposition can pile up sharps — a triple sharp is a valid pitch and an
  /// unreadable one — so anything that stacks intervals should simplify what it
  /// produces.
  Pitch get simplified {
    if (alter.abs() <= 2) return this;
    for (final offset in const [1, -1, 2, -2, 3, -3]) {
      final candidate = enharmonic(letterOffset: offset);
      if (candidate != null && candidate.alter.abs() < alter.abs()) {
        return candidate;
      }
    }
    return this;
  }

  Pitch copyWith({Step? step, int? octave, double? alter}) => Pitch(
    step ?? this.step,
    octave ?? this.octave,
    alter: alter ?? this.alter,
  );

  /// Same letter and octave regardless of accidental.
  bool isSameStaffPositionAs(Pitch other) =>
      diatonicValue == other.diatonicValue;

  /// Same sound, possibly a different spelling.
  bool isEnharmonicWith(Pitch other) => chromaticValue == other.chromaticValue;

  @override
  int compareTo(Pitch other) {
    final bySound = chromaticValue.compareTo(other.chromaticValue);
    if (bySound != 0) return bySound;
    return diatonicValue.compareTo(other.diatonicValue);
  }

  @override
  bool operator ==(Object other) =>
      other is Pitch &&
      step == other.step &&
      octave == other.octave &&
      alter == other.alter;

  @override
  int get hashCode => Object.hash(step, octave, alter);

  @override
  String toString() {
    final buffer = StringBuffer(step.name);
    var remaining = alter;
    while (remaining >= 1) {
      buffer.write('#');
      remaining -= 1;
    }
    while (remaining <= -1) {
      buffer.write('b');
      remaining += 1;
    }
    if (remaining != 0) buffer.write(remaining > 0 ? '+' : '-');
    return '$buffer$octave';
  }
}
