import 'package:songbird_score/songbird_score.dart';
import 'package:test/test.dart';

void main() {
  group('Fraction', () {
    test('reduces and compares exactly', () {
      expect(Fraction(2, 4), Fraction(1, 2));
      expect(Fraction(-2, -4), Fraction(1, 2));
      expect(Fraction(1, -2), Fraction(-1, 2));
      expect(Fraction(1, 3) + Fraction(1, 6), Fraction(1, 2));
    });

    test('twelve triplet eighths make exactly one whole note', () {
      var total = Fraction.zero;
      for (var i = 0; i < 12; i++) {
        total += const RhythmicDuration(
          NoteType.eighth,
          timeModification: TimeModification.triplet,
        ).value;
      }
      expect(total, Fraction.one);
    });
  });

  group('Pitch', () {
    test('parses scientific notation', () {
      expect(Pitch.parse('C4'), const Pitch(Step.c, 4));
      expect(Pitch.parse('F#3'), const Pitch(Step.f, 3, alter: 1));
      expect(Pitch.parse('Bb5'), const Pitch(Step.b, 5, alter: -1));
      expect(Pitch.parse('Cx4'), const Pitch(Step.c, 4, alter: 2));
    });

    test('middle C is MIDI 60 and A4 is 440 Hz', () {
      expect(const Pitch(Step.c, 4).midiNumber, 60);
      expect(const Pitch(Step.a, 4).frequency, closeTo(440, 1e-9));
    });

    test('keeps enharmonic spellings distinct', () {
      const fSharp = Pitch(Step.f, 4, alter: 1);
      const gFlat = Pitch(Step.g, 4, alter: -1);
      expect(fSharp == gFlat, isFalse);
      expect(fSharp.isEnharmonicWith(gFlat), isTrue);
      expect(fSharp.midiNumber, gFlat.midiNumber);
    });
  });

  group('Interval', () {
    test('names match sizes', () {
      expect(Interval.named(5, IntervalQuality.perfect).chromaticSemitones, 7);
      expect(Interval.named(3, IntervalQuality.minor).chromaticSemitones, 3);
      expect(Interval.named(8, IntervalQuality.perfect).diatonicSteps, 7);
      expect(
        Interval.named(4, IntervalQuality.augmented).chromaticSemitones,
        6,
      );
    });

    test('reports its own quality', () {
      expect(const Interval(4, 7).quality, IntervalQuality.perfect);
      expect(const Interval(2, 3).quality, IntervalQuality.minor);
      expect(const Interval(2, 4).quality, IntervalQuality.major);
      expect(const Interval(3, 6).quality, IntervalQuality.augmented);
    });

    test('transposition keeps the spelling the interval implies', () {
      // Up a minor third from A is C, not B sharp.
      final up = Interval.named(3, IntervalQuality.minor);
      expect(up.transpose(const Pitch(Step.a, 4)), const Pitch(Step.c, 5));

      // Up a major third from C is E; from D flat it is F.
      final major3 = Interval.named(3, IntervalQuality.major);
      expect(major3.transpose(const Pitch(Step.c, 4)), const Pitch(Step.e, 4));
      expect(
        major3.transpose(const Pitch(Step.d, 4, alter: -1)),
        const Pitch(Step.f, 4),
      );

      // Up an augmented second from C is D sharp, not E flat.
      final aug2 = Interval.named(2, IntervalQuality.augmented);
      expect(
        aug2.transpose(const Pitch(Step.c, 4)),
        const Pitch(Step.d, 4, alter: 1),
      );
    });

    test('crosses octaves correctly', () {
      final fifth = Interval.named(5, IntervalQuality.perfect);
      expect(fifth.transpose(const Pitch(Step.g, 4)), const Pitch(Step.d, 5));
      expect(
        fifth.transpose(const Pitch(Step.b, 3)),
        const Pitch(Step.f, 4, alter: 1),
      );
    });

    test('descending intervals move down', () {
      final downFifth = Interval.named(
        5,
        IntervalQuality.perfect,
        descending: true,
      );
      expect(
        downFifth.transpose(const Pitch(Step.c, 4)),
        const Pitch(Step.f, 3),
      );
    });

    test('measures the interval between two pitches', () {
      final interval = Interval.between(
        const Pitch(Step.c, 4),
        const Pitch(Step.e, 4, alter: -1),
      );
      expect(interval.quality, IntervalQuality.minor);
      expect(interval.number, 3);
    });

    test('a chromatic interval picks a readable spelling', () {
      // Three semitones spells as a minor third, not an augmented second.
      expect(
        Interval.chromatic(3).transpose(const Pitch(Step.c, 4)),
        const Pitch(Step.e, 4, alter: -1),
      );
    });
  });

  group('KeySignature', () {
    test('derives its tonic from the circle of fifths', () {
      expect(KeySignature.cMajor.tonic().step, Step.c);
      expect(const KeySignature(fifths: 2).tonic().step, Step.d);
      expect(const KeySignature(fifths: -1).tonic().step, Step.f);
      expect(
        const KeySignature(fifths: -2).tonic(),
        const Pitch(Step.b, 4, alter: -1),
      );
      expect(
        const KeySignature(fifths: 6).tonic(),
        const Pitch(Step.f, 4, alter: 1),
      );
    });

    test('minor keys share their signature with the relative major', () {
      expect(const KeySignature(mode: Mode.minor).tonic().step, Step.a);
      expect(
        KeySignature.forTonic(const Pitch(Step.e, 4), mode: Mode.minor).fifths,
        1,
      );
    });

    test('D dorian has no accidentals', () {
      expect(
        KeySignature.forTonic(const Pitch(Step.d, 4), mode: Mode.dorian).fifths,
        0,
      );
    });

    test('alters the right steps', () {
      const gMajor = KeySignature(fifths: 1);
      expect(gMajor.alterationFor(Step.f), 1);
      expect(gMajor.alterationFor(Step.c), 0);
      expect(gMajor.alteredSteps, [Step.f]);

      const eFlat = KeySignature(fifths: -3);
      expect(eFlat.alteredSteps, [Step.b, Step.e, Step.a]);
    });

    test('transposes and stays inside the printable range', () {
      const c = KeySignature.cMajor;
      expect(c.transposed(Interval.named(2, IntervalQuality.major)).fifths, 2);

      // C flat major up a semitone would be 12 sharps; it respells as C major.
      const cFlat = KeySignature(fifths: -7);
      final up = cFlat.transposed(Interval.chromatic(1));
      expect(up.fifths.abs() <= 7, isTrue);
    });
  });

  group('Clef', () {
    test('places pitches where a reader expects them', () {
      // Bottom line of the treble staff is E4, top line F5.
      expect(Clef.treble.staffPositionOf(const Pitch(Step.e, 4)), 0);
      expect(Clef.treble.staffPositionOf(const Pitch(Step.g, 4)), 2);
      expect(Clef.treble.staffPositionOf(const Pitch(Step.f, 5)), 8);
      // Middle C sits one ledger line below the treble staff.
      expect(Clef.treble.staffPositionOf(const Pitch(Step.c, 4)), -2);

      // Bass staff: bottom line G2, F clef line is F3.
      expect(Clef.bass.staffPositionOf(const Pitch(Step.g, 2)), 0);
      expect(Clef.bass.staffPositionOf(const Pitch(Step.f, 3)), 6);
      // Middle C sits one ledger line above the bass staff.
      expect(Clef.bass.staffPositionOf(const Pitch(Step.c, 4)), 10);

      // Alto clef puts middle C on the middle line.
      expect(Clef.alto.staffPositionOf(const Pitch(Step.c, 4)), 4);
    });

    test('an octave-down treble clef writes a tenor part an octave higher', () {
      expect(
        Clef.trebleOctaveDown.staffPositionOf(const Pitch(Step.c, 4)),
        Clef.treble.staffPositionOf(const Pitch(Step.c, 5)),
      );
    });

    test('inverts back to the natural pitch at a position', () {
      for (var position = -6; position <= 14; position++) {
        expect(
          Clef.treble.staffPositionOf(
            Clef.treble.pitchAtStaffPosition(position),
          ),
          position,
        );
      }
    });
  });

  group('RhythmicDuration', () {
    test('dots add half of what came before', () {
      expect(const RhythmicDuration(NoteType.quarter).value, Fraction(1, 4));
      expect(
        const RhythmicDuration(NoteType.quarter, dots: 1).value,
        Fraction(3, 8),
      );
      expect(
        const RhythmicDuration(NoteType.quarter, dots: 2).value,
        Fraction(7, 16),
      );
    });

    test('decomposes a length into writable note values', () {
      final parts = RhythmicDuration.decompose(Fraction(7, 16));
      expect(
        parts.fold(Fraction.zero, (sum, p) => sum + p.value),
        Fraction(7, 16),
      );
    });
  });

  group('TimeSignature', () {
    test('compound time counts in dotted beats', () {
      expect(TimeSignature.simple(6, 8).beatUnit, Fraction(3, 8));
      expect(TimeSignature.simple(4, 4).beatUnit, Fraction(1, 4));
      expect(TimeSignature.simple(3, 4).beatUnit, Fraction(1, 4));
    });

    test('measure length matches the signature', () {
      expect(TimeSignature.simple(3, 4).measureDuration, Fraction(3, 4));
      expect(TimeSignature.commonTime.measureDuration, Fraction.one);
    });

    test('strong beats mark where beams may break', () {
      expect(TimeSignature.simple(4, 4).strongBeats.length, 4);
      expect(TimeSignature.simple(6, 8).strongBeats.length, 2);
    });
  });
}
