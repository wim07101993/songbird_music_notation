import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Chooses the SMuFL glyph for each thing the model can describe.
///
/// Kept apart from layout so that swapping a notehead set or supporting a new
/// articulation is a change in one place.
// A namespace rather than a type: `abstract final class` is how Dart spells
// one, and there is nothing here for an instance to hold.
// ignore: avoid_classes_with_only_static_members
abstract final class NotationGlyphs {
  /// One segment of the wavy line before a chord to be spread. The font draws
  /// it across the page; it is turned a quarter turn and repeated down the
  /// side of the chord.
  static const SmuflGlyph arpeggiate = SmuflGlyphs.wiggleArpeggiatoUp;

  /// The clef sign, including the small 8 or 15 for an octave-transposing clef.
  static SmuflGlyph clef(Clef clef) => switch ((clef.sign, clef.octaveChange)) {
    (ClefSign.g, 0) => SmuflGlyphs.gClef,
    (ClefSign.g, -1) => SmuflGlyphs.gClef8vb,
    (ClefSign.g, 1) => SmuflGlyphs.gClef8va,
    (ClefSign.g, -2) => SmuflGlyphs.gClef15mb,
    (ClefSign.g, 2) => SmuflGlyphs.gClef15ma,
    (ClefSign.f, 0) => SmuflGlyphs.fClef,
    (ClefSign.f, -1) => SmuflGlyphs.fClef8vb,
    (ClefSign.f, 1) => SmuflGlyphs.fClef8va,
    (ClefSign.f, -2) => SmuflGlyphs.fClef15mb,
    (ClefSign.f, 2) => SmuflGlyphs.fClef15ma,
    (ClefSign.c, 0) => SmuflGlyphs.cClef,
    (ClefSign.c, -1) => SmuflGlyphs.cClef8vb,
    (ClefSign.percussion, _) => SmuflGlyphs.unpitchedPercussionClef1,
    (ClefSign.tab, _) => SmuflGlyphs.n6stringTabClef,
    (ClefSign.jianpu, _) => SmuflGlyphs.gClef,
    (ClefSign.none, _) => SmuflGlyphs.gClef,
    _ => SmuflGlyphs.gClef,
  };

  /// The notehead for a written duration, unless the note overrides it.
  static SmuflGlyph notehead(
    NoteType type, {
    NoteheadShape? shape,
    bool? filled,
  }) {
    if (shape != null && shape != NoteheadShape.normal) {
      final override = _shapedNotehead(shape, filled ?? type.isFilledNotehead);
      if (override != null) return override;
    }
    if (filled != null) {
      return filled ? SmuflGlyphs.noteheadBlack : SmuflGlyphs.noteheadHalf;
    }
    return switch (type) {
      NoteType.maxima => SmuflGlyphs.noteheadDoubleWhole,
      NoteType.long => SmuflGlyphs.noteheadDoubleWhole,
      NoteType.breve => SmuflGlyphs.noteheadDoubleWhole,
      NoteType.whole => SmuflGlyphs.noteheadWhole,
      NoteType.half => SmuflGlyphs.noteheadHalf,
      _ => SmuflGlyphs.noteheadBlack,
    };
  }

  static SmuflGlyph? _shapedNotehead(NoteheadShape shape, bool filled) =>
      switch (shape) {
        NoteheadShape.x =>
          filled ? SmuflGlyphs.noteheadXBlack : SmuflGlyphs.noteheadXHalf,
        NoteheadShape.cross => SmuflGlyphs.noteheadPlusBlack,
        NoteheadShape.circleX => SmuflGlyphs.noteheadCircleX,
        NoteheadShape.diamond =>
          filled
              ? SmuflGlyphs.noteheadDiamondBlack
              : SmuflGlyphs.noteheadDiamondHalf,
        NoteheadShape.triangle =>
          filled
              ? SmuflGlyphs.noteheadTriangleUpBlack
              : SmuflGlyphs.noteheadTriangleUpHalf,
        NoteheadShape.invertedTriangle =>
          filled
              ? SmuflGlyphs.noteheadTriangleDownBlack
              : SmuflGlyphs.noteheadTriangleDownHalf,
        NoteheadShape.square || NoteheadShape.rectangle =>
          filled
              ? SmuflGlyphs.noteheadSquareBlack
              : SmuflGlyphs.noteheadSquareWhite,
        NoteheadShape.slash => SmuflGlyphs.noteheadSlashHorizontalEnds,
        NoteheadShape.slashed => SmuflGlyphs.noteheadSlashedBlack1,
        NoteheadShape.backSlashed => SmuflGlyphs.noteheadSlashedBlack2,
        NoteheadShape.cluster => SmuflGlyphs.noteheadClusterQuarter2nd,
        NoteheadShape.none => null,
        _ => null,
      };

  /// The rest glyph for a written duration.
  static SmuflGlyph rest(NoteType type) => switch (type) {
    NoteType.maxima => SmuflGlyphs.restMaxima,
    NoteType.long => SmuflGlyphs.restLonga,
    NoteType.breve => SmuflGlyphs.restDoubleWhole,
    NoteType.whole => SmuflGlyphs.restWhole,
    NoteType.half => SmuflGlyphs.restHalf,
    NoteType.quarter => SmuflGlyphs.restQuarter,
    NoteType.eighth => SmuflGlyphs.rest8th,
    NoteType.sixteenth => SmuflGlyphs.rest16th,
    NoteType.thirtySecond => SmuflGlyphs.rest32nd,
    NoteType.sixtyFourth => SmuflGlyphs.rest64th,
    NoteType.oneHundredTwentyEighth => SmuflGlyphs.rest128th,
    NoteType.twoHundredFiftySixth => SmuflGlyphs.rest256th,
    NoteType.fiveHundredTwelfth => SmuflGlyphs.rest512th,
    NoteType.oneThousandTwentyFourth => SmuflGlyphs.rest1024th,
  };

  /// The flag on an unbeamed stem, or `null` for a note that has none.
  static SmuflGlyph? flag(NoteType type, {required bool stemUp}) {
    if (type.flagCount == 0) return null;
    return switch ((type, stemUp)) {
      (NoteType.eighth, true) => SmuflGlyphs.flag8thUp,
      (NoteType.eighth, false) => SmuflGlyphs.flag8thDown,
      (NoteType.sixteenth, true) => SmuflGlyphs.flag16thUp,
      (NoteType.sixteenth, false) => SmuflGlyphs.flag16thDown,
      (NoteType.thirtySecond, true) => SmuflGlyphs.flag32ndUp,
      (NoteType.thirtySecond, false) => SmuflGlyphs.flag32ndDown,
      (NoteType.sixtyFourth, true) => SmuflGlyphs.flag64thUp,
      (NoteType.sixtyFourth, false) => SmuflGlyphs.flag64thDown,
      (NoteType.oneHundredTwentyEighth, true) => SmuflGlyphs.flag128thUp,
      (NoteType.oneHundredTwentyEighth, false) => SmuflGlyphs.flag128thDown,
      (NoteType.twoHundredFiftySixth, true) => SmuflGlyphs.flag256thUp,
      (NoteType.twoHundredFiftySixth, false) => SmuflGlyphs.flag256thDown,
      (NoteType.fiveHundredTwelfth, true) => SmuflGlyphs.flag512thUp,
      (NoteType.fiveHundredTwelfth, false) => SmuflGlyphs.flag512thDown,
      (NoteType.oneThousandTwentyFourth, true) => SmuflGlyphs.flag1024thUp,
      (NoteType.oneThousandTwentyFourth, false) => SmuflGlyphs.flag1024thDown,
      _ => null,
    };
  }

  /// The accidental a character stands for, or null for ordinary text.
  ///
  /// Part names and words carry these — "Clarinet in B♭", "E♭ Alto Sax" — and
  /// a text face mostly does not have them.
  static AccidentalType? accidentalForCharacter(String character) =>
      switch (character) {
        '\u266D' => AccidentalType.flat,
        '\u266F' => AccidentalType.sharp,
        '\u266E' => AccidentalType.natural,
        '\u{1D12B}' => AccidentalType.flatFlat,
        '\u{1D12A}' => AccidentalType.doubleSharp,
        _ => null,
      };

  static SmuflGlyph accidental(AccidentalType type) => switch (type) {
    AccidentalType.sharp => SmuflGlyphs.accidentalSharp,
    AccidentalType.natural => SmuflGlyphs.accidentalNatural,
    AccidentalType.flat => SmuflGlyphs.accidentalFlat,
    AccidentalType.doubleSharp => SmuflGlyphs.accidentalDoubleSharp,
    AccidentalType.sharpSharp => SmuflGlyphs.accidentalDoubleSharp,
    AccidentalType.flatFlat => SmuflGlyphs.accidentalDoubleFlat,
    AccidentalType.tripleSharp => SmuflGlyphs.accidentalTripleSharp,
    AccidentalType.tripleFlat => SmuflGlyphs.accidentalTripleFlat,
    AccidentalType.naturalSharp => SmuflGlyphs.accidentalNaturalSharp,
    AccidentalType.naturalFlat => SmuflGlyphs.accidentalNaturalFlat,
    AccidentalType.quarterSharp => SmuflGlyphs.accidentalQuarterToneSharpStein,
    AccidentalType.quarterFlat => SmuflGlyphs.accidentalQuarterToneFlatStein,
    AccidentalType.threeQuartersSharp =>
      SmuflGlyphs.accidentalThreeQuarterTonesSharpStein,
    AccidentalType.threeQuartersFlat =>
      SmuflGlyphs.accidentalThreeQuarterTonesFlatZimmermann,
    AccidentalType.sori => SmuflGlyphs.accidentalSori,
    AccidentalType.koron => SmuflGlyphs.accidentalKoron,
    AccidentalType.arrowUp => SmuflGlyphs.accidentalArrowUp,
    AccidentalType.arrowDown => SmuflGlyphs.accidentalArrowDown,
    _ => SmuflGlyphs.accidentalNatural,
  };

  /// The accidental drawn in a key signature for [steps] alteration.
  static SmuflGlyph keyAccidental({required bool sharp}) =>
      sharp ? SmuflGlyphs.accidentalSharp : SmuflGlyphs.accidentalFlat;

  /// A digit of a time signature.
  static SmuflGlyph timeSignatureDigit(int digit) => switch (digit) {
    0 => SmuflGlyphs.timeSig0,
    1 => SmuflGlyphs.timeSig1,
    2 => SmuflGlyphs.timeSig2,
    3 => SmuflGlyphs.timeSig3,
    4 => SmuflGlyphs.timeSig4,
    5 => SmuflGlyphs.timeSig5,
    6 => SmuflGlyphs.timeSig6,
    7 => SmuflGlyphs.timeSig7,
    8 => SmuflGlyphs.timeSig8,
    _ => SmuflGlyphs.timeSig9,
  };

  static const SmuflGlyph augmentationDot = SmuflGlyphs.augmentationDot;
  static const SmuflGlyph commonTime = SmuflGlyphs.timeSigCommon;
  static const SmuflGlyph cutTime = SmuflGlyphs.timeSigCutCommon;
  static const SmuflGlyph repeatDots = SmuflGlyphs.repeatDots;
  static const SmuflGlyph brace = SmuflGlyphs.brace;
  static const SmuflGlyph bracketTop = SmuflGlyphs.bracketTop;
  static const SmuflGlyph bracketBottom = SmuflGlyphs.bracketBottom;

  /// The note printed in a metronome mark, for a beat of [type].
  ///
  /// Drawn from the music font rather than written as a character: the text
  /// fonts a reader has installed mostly do not carry a quarter note, and the
  /// ones that do draw it at the size of a letter.
  static SmuflGlyph metronomeNote(NoteType type) => switch (type) {
    NoteType.breve ||
    NoteType.long ||
    NoteType.maxima => SmuflGlyphs.metNoteDoubleWhole,
    NoteType.whole => SmuflGlyphs.metNoteWhole,
    NoteType.half => SmuflGlyphs.metNoteHalfUp,
    NoteType.eighth => SmuflGlyphs.metNote8thUp,
    NoteType.sixteenth => SmuflGlyphs.metNote16thUp,
    NoteType.thirtySecond => SmuflGlyphs.metNote32ndUp,
    _ => SmuflGlyphs.metNoteQuarterUp,
  };
  static const SmuflGlyph segno = SmuflGlyphs.segno;
  static const SmuflGlyph coda = SmuflGlyphs.coda;

  static SmuflGlyph articulation(
    Articulation articulation, {
    required bool above,
  }) => switch ((articulation, above)) {
    (Articulation.accent, true) => SmuflGlyphs.articAccentAbove,
    (Articulation.accent, false) => SmuflGlyphs.articAccentBelow,
    (Articulation.staccato, true) => SmuflGlyphs.articStaccatoAbove,
    (Articulation.staccato, false) => SmuflGlyphs.articStaccatoBelow,
    (Articulation.tenuto, true) => SmuflGlyphs.articTenutoAbove,
    (Articulation.tenuto, false) => SmuflGlyphs.articTenutoBelow,
    (Articulation.staccatissimo, true) => SmuflGlyphs.articStaccatissimoAbove,
    (Articulation.staccatissimo, false) => SmuflGlyphs.articStaccatissimoBelow,
    (Articulation.strongAccent, true) => SmuflGlyphs.articMarcatoAbove,
    (Articulation.strongAccent, false) => SmuflGlyphs.articMarcatoBelow,
    (Articulation.detachedLegato, true) => SmuflGlyphs.articTenutoStaccatoAbove,
    (Articulation.detachedLegato, false) =>
      SmuflGlyphs.articTenutoStaccatoBelow,
    (Articulation.spiccato, true) => SmuflGlyphs.articStaccatissimoWedgeAbove,
    (Articulation.spiccato, false) => SmuflGlyphs.articStaccatissimoWedgeBelow,
    (Articulation.stress, true) => SmuflGlyphs.articStressAbove,
    (Articulation.stress, false) => SmuflGlyphs.articStressBelow,
    (Articulation.unstress, true) => SmuflGlyphs.articUnstressAbove,
    (Articulation.unstress, false) => SmuflGlyphs.articUnstressBelow,
    (Articulation.softAccent, true) => SmuflGlyphs.articSoftAccentAbove,
    (Articulation.softAccent, false) => SmuflGlyphs.articSoftAccentBelow,
    (Articulation.breathMark, _) => SmuflGlyphs.breathMarkComma,
    (Articulation.caesura, _) => SmuflGlyphs.caesura,
    (Articulation.doit, _) => SmuflGlyphs.brassDoitMedium,
    (Articulation.falloff, _) => SmuflGlyphs.brassFallLipMedium,
    (Articulation.plop, _) => SmuflGlyphs.brassPlop,
    (Articulation.scoop, _) => SmuflGlyphs.brassScoop,
    (Articulation.otherArticulation, true) => SmuflGlyphs.articAccentAbove,
    (Articulation.otherArticulation, false) => SmuflGlyphs.articAccentBelow,
  };

  static SmuflGlyph ornament(Ornament ornament) => switch (ornament) {
    Ornament.trillMark => SmuflGlyphs.ornamentTrill,
    Ornament.turn => SmuflGlyphs.ornamentTurn,
    Ornament.delayedTurn => SmuflGlyphs.ornamentTurn,
    Ornament.invertedTurn => SmuflGlyphs.ornamentTurnInverted,
    Ornament.delayedInvertedTurn => SmuflGlyphs.ornamentTurnInverted,
    Ornament.verticalTurn => SmuflGlyphs.ornamentTurnUp,
    Ornament.invertedVerticalTurn => SmuflGlyphs.ornamentTurnUpS,
    Ornament.shake => SmuflGlyphs.ornamentShakeMuffat1,
    Ornament.wavyLine => SmuflGlyphs.wiggleTrill,
    Ornament.mordent => SmuflGlyphs.ornamentMordent,
    Ornament.invertedMordent => SmuflGlyphs.ornamentShortTrill,
    Ornament.schleifer => SmuflGlyphs.ornamentSchleifer,
    Ornament.tremolo => SmuflGlyphs.tremolo3,
    Ornament.haydn => SmuflGlyphs.ornamentHaydn,
    Ornament.otherOrnament => SmuflGlyphs.ornamentTrill,
  };

  static SmuflGlyph fermata(FermataShape shape, {required bool above}) =>
      switch ((shape, above)) {
        (FermataShape.normal, true) => SmuflGlyphs.fermataAbove,
        (FermataShape.normal, false) => SmuflGlyphs.fermataBelow,
        (FermataShape.angled, true) => SmuflGlyphs.fermataShortAbove,
        (FermataShape.angled, false) => SmuflGlyphs.fermataShortBelow,
        (FermataShape.square, true) => SmuflGlyphs.fermataLongAbove,
        (FermataShape.square, false) => SmuflGlyphs.fermataLongBelow,
        (FermataShape.doubleAngled, true) => SmuflGlyphs.fermataVeryShortAbove,
        (FermataShape.doubleAngled, false) => SmuflGlyphs.fermataVeryShortBelow,
        (FermataShape.doubleSquare, true) => SmuflGlyphs.fermataVeryLongAbove,
        (FermataShape.doubleSquare, false) => SmuflGlyphs.fermataVeryLongBelow,
        (FermataShape.doubleDot, _) => SmuflGlyphs.fermataAbove,
        (FermataShape.halfCurve, true) => SmuflGlyphs.fermataShortHenzeAbove,
        (FermataShape.halfCurve, false) => SmuflGlyphs.fermataShortHenzeBelow,
        (FermataShape.curlew, _) => SmuflGlyphs.curlewSign,
      };

  static SmuflGlyph dynamicMark(DynamicMark mark) => switch (mark) {
    DynamicMark.p => SmuflGlyphs.dynamicPiano,
    DynamicMark.pp => SmuflGlyphs.dynamicPP,
    DynamicMark.ppp => SmuflGlyphs.dynamicPPP,
    DynamicMark.pppp => SmuflGlyphs.dynamicPPPP,
    DynamicMark.ppppp => SmuflGlyphs.dynamicPPPPP,
    DynamicMark.pppppp => SmuflGlyphs.dynamicPPPPPP,
    DynamicMark.f => SmuflGlyphs.dynamicForte,
    DynamicMark.ff => SmuflGlyphs.dynamicFF,
    DynamicMark.fff => SmuflGlyphs.dynamicFFF,
    DynamicMark.ffff => SmuflGlyphs.dynamicFFFF,
    DynamicMark.fffff => SmuflGlyphs.dynamicFFFFF,
    DynamicMark.ffffff => SmuflGlyphs.dynamicFFFFFF,
    DynamicMark.mp => SmuflGlyphs.dynamicMP,
    DynamicMark.mf => SmuflGlyphs.dynamicMF,
    DynamicMark.sf => SmuflGlyphs.dynamicSforzando1,
    DynamicMark.sfp => SmuflGlyphs.dynamicSforzatoPiano,
    DynamicMark.sfpp => SmuflGlyphs.dynamicSforzatoPiano,
    DynamicMark.fp => SmuflGlyphs.dynamicFortePiano,
    DynamicMark.rf => SmuflGlyphs.dynamicRinforzando1,
    DynamicMark.rfz => SmuflGlyphs.dynamicRinforzando2,
    DynamicMark.sfz => SmuflGlyphs.dynamicSforzato,
    DynamicMark.sffz => SmuflGlyphs.dynamicSforzatoFF,
    DynamicMark.fz => SmuflGlyphs.dynamicForzando,
    DynamicMark.n => SmuflGlyphs.dynamicNiente,
    DynamicMark.pf => SmuflGlyphs.dynamicPF,
    DynamicMark.sfzp => SmuflGlyphs.dynamicSforzandoPiano,
  };
}
