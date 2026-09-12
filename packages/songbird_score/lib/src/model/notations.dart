/// Where a mark sits relative to the staff or note it belongs to.
enum Placement { above, below }

/// Which way a stem points.
enum StemDirection { up, down, none, double }

/// The accidental symbols MusicXML can print, including the microtonal and
/// historical ones.
enum AccidentalType {
  sharp('sharp'),
  natural('natural'),
  flat('flat'),
  doubleSharp('double-sharp'),
  sharpSharp('sharp-sharp'),
  flatFlat('flat-flat'),
  naturalSharp('natural-sharp'),
  naturalFlat('natural-flat'),
  quarterFlat('quarter-flat'),
  quarterSharp('quarter-sharp'),
  threeQuartersFlat('three-quarters-flat'),
  threeQuartersSharp('three-quarters-sharp'),
  sharpDown('sharp-down'),
  sharpUp('sharp-up'),
  naturalDown('natural-down'),
  naturalUp('natural-up'),
  flatDown('flat-down'),
  flatUp('flat-up'),
  doubleSharpDown('double-sharp-down'),
  doubleSharpUp('double-sharp-up'),
  flatFlatDown('flat-flat-down'),
  flatFlatUp('flat-flat-up'),
  arrowDown('arrow-down'),
  arrowUp('arrow-up'),
  tripleSharp('triple-sharp'),
  tripleFlat('triple-flat'),
  slashQuarterSharp('slash-quarter-sharp'),
  slashSharp('slash-sharp'),
  slashFlat('slash-flat'),
  doubleSlashFlat('double-slash-flat'),
  sharp1('sharp-1'),
  sharp2('sharp-2'),
  sharp3('sharp-3'),
  sharp5('sharp-5'),
  flat1('flat-1'),
  flat2('flat-2'),
  flat3('flat-3'),
  flat4('flat-4'),
  sori('sori'),
  koron('koron'),
  other('other');

  const AccidentalType(
    this.xmlName,
  );

  final String xmlName;

  /// How much this symbol alters the pitch, in semitones. `null` for symbols
  /// whose meaning depends on the tuning system in use.
  double? get semitones => switch (this) {
    AccidentalType.sharp => 1,
    AccidentalType.natural => 0,
    AccidentalType.flat => -1,
    AccidentalType.doubleSharp || AccidentalType.sharpSharp => 2,
    AccidentalType.flatFlat => -2,
    AccidentalType.tripleSharp => 3,
    AccidentalType.tripleFlat => -3,
    AccidentalType.quarterSharp => 0.5,
    AccidentalType.quarterFlat => -0.5,
    AccidentalType.threeQuartersSharp => 1.5,
    AccidentalType.threeQuartersFlat => -1.5,
    AccidentalType.naturalSharp => 1,
    AccidentalType.naturalFlat => -1,
    _ => null,
  };

  /// The plain accidental that expresses [semitones], if there is one.
  static AccidentalType? forAlteration(double semitones) => switch (semitones) {
    0 => AccidentalType.natural,
    1 => AccidentalType.sharp,
    -1 => AccidentalType.flat,
    2 => AccidentalType.doubleSharp,
    -2 => AccidentalType.flatFlat,
    3 => AccidentalType.tripleSharp,
    -3 => AccidentalType.tripleFlat,
    0.5 => AccidentalType.quarterSharp,
    -0.5 => AccidentalType.quarterFlat,
    1.5 => AccidentalType.threeQuartersSharp,
    -1.5 => AccidentalType.threeQuartersFlat,
    _ => null,
  };

  static AccidentalType? fromXmlName(String name) {
    for (final value in AccidentalType.values) {
      if (value.xmlName == name) return value;
    }
    return null;
  }
}

/// A printed accidental, as distinct from the alteration it implies.
///
/// A note can be altered without printing anything (the key signature already
/// said so) and can print a courtesy accidental that alters nothing.
class Accidental {
  const Accidental(
    this.type, {
    this.cautionary = false,
    this.editorial = false,
    this.parentheses = false,
    this.bracket = false,
  });

  final AccidentalType type;

  /// Printed as a reminder, usually in parentheses.
  final bool cautionary;

  /// An editor's suggestion rather than the composer's marking.
  final bool editorial;

  final bool parentheses;
  final bool bracket;

  Accidental copyWith({
    AccidentalType? type,
    bool? cautionary,
    bool? editorial,
    bool? parentheses,
    bool? bracket,
  }) => Accidental(
    type ?? this.type,
    cautionary: cautionary ?? this.cautionary,
    editorial: editorial ?? this.editorial,
    parentheses: parentheses ?? this.parentheses,
    bracket: bracket ?? this.bracket,
  );

  @override
  bool operator ==(Object other) =>
      other is Accidental &&
      type == other.type &&
      cautionary == other.cautionary &&
      editorial == other.editorial &&
      parentheses == other.parentheses &&
      bracket == other.bracket;

  @override
  int get hashCode =>
      Object.hash(type, cautionary, editorial, parentheses, bracket);

  @override
  String toString() => 'Accidental(${type.xmlName})';
}

/// Notehead shapes.
enum NoteheadShape {
  normal('normal'),
  slash('slash'),
  triangle('triangle'),
  diamond('diamond'),
  square('square'),
  cross('cross'),
  x('x'),
  circleX('circle-x'),
  invertedTriangle('inverted triangle'),
  arrowDown('arrow down'),
  arrowUp('arrow up'),
  circled('circled'),
  slashed('slashed'),
  backSlashed('back slashed'),
  cluster('cluster'),
  rectangle('rectangle'),
  none('none'),
  doWhole('do'),
  re('re'),
  mi('mi'),
  fa('fa'),
  faUp('fa up'),
  so('so'),
  la('la'),
  ti('ti'),
  other('other');

  const NoteheadShape(
    this.xmlName,
  );

  final String xmlName;

  static NoteheadShape? fromXmlName(String name) {
    for (final value in NoteheadShape.values) {
      if (value.xmlName == name) return value;
    }
    return null;
  }
}

/// One beam at one beaming level.
enum BeamState { begin, end, forwardHook, backwardHook, continueBeam }

/// A beam at a given level, where level 1 is the beam closest to the noteheads.
class Beam {
  const Beam({
    required this.level,
    required this.state,
  });

  final int level;
  final BeamState state;

  @override
  bool operator ==(Object other) =>
      other is Beam && level == other.level && state == other.state;

  @override
  int get hashCode => Object.hash(level, state);

  @override
  String toString() => 'Beam($level, ${state.name})';
}

/// Marks attached directly to a notehead or stem.
enum Articulation {
  accent,
  strongAccent,
  staccato,
  tenuto,
  detachedLegato,
  staccatissimo,
  spiccato,
  scoop,
  plop,
  doit,
  falloff,
  breathMark,
  caesura,
  stress,
  unstress,
  softAccent,
  otherArticulation,
}

/// Ornament signs printed above or below a note.
enum Ornament {
  trillMark,
  turn,
  delayedTurn,
  invertedTurn,
  delayedInvertedTurn,
  verticalTurn,
  invertedVerticalTurn,
  shake,
  wavyLine,
  mordent,
  invertedMordent,
  schleifer,
  tremolo,
  haydn,
  otherOrnament,
}

/// Instrument-specific technique markings.
enum Technical {
  upBow,
  downBow,
  harmonic,
  openString,
  thumbPosition,
  fingering,
  pluck,
  doubleTongue,
  tripleTongue,
  stopped,
  snapPizzicato,
  fret,
  string,
  hammerOn,
  pullOff,
  bend,
  tap,
  heel,
  toe,
  fingernails,
  hole,
  arrow,
  handbell,
  brassBend,
  flip,
  smear,
  open,
  halfMuted,
  harmonMute,
  golpe,
  otherTechnical,
}

/// The fermata shapes.
enum FermataShape {
  normal,
  angled,
  square,
  doubleAngled,
  doubleSquare,
  doubleDot,
  halfCurve,
  curlew,
}

/// A hold over a note, rest or barline.
class Fermata {
  const Fermata({
    this.shape = FermataShape.normal,
    this.placement = Placement.above,
  });

  final FermataShape shape;
  final Placement placement;
}

/// Which end of a two-note tremolo or how many strokes a single-note tremolo
/// carries.
enum TremoloKind { single, start, stop, unmeasured }

class Tremolo {
  const Tremolo({
    this.marks = 3,
    this.kind = TremoloKind.single,
  });

  /// Number of strokes drawn through or between the stems.
  final int marks;
  final TremoloKind kind;
}

/// A syllable of text under a note.
class Lyric {
  Lyric({
    required this.text,
    this.number = 1,
    this.syllabic = Syllabic.single,
    this.name,
    this.extend = false,
    this.elision,
    this.placement = Placement.below,
  });

  /// The syllable itself.
  String text;

  /// Which verse this syllable belongs to.
  int number;

  /// Where the syllable falls within its word, which decides whether a hyphen
  /// is drawn after it.
  Syllabic syllabic;

  /// An optional label such as `chorus`.
  String? name;

  /// Whether a melisma line extends from this syllable.
  bool extend;

  /// Character joining this syllable to the next when two land on one note.
  String? elision;

  Placement placement;

  Lyric copy() => Lyric(
    text: text,
    number: number,
    syllabic: syllabic,
    name: name,
    extend: extend,
    elision: elision,
    placement: placement,
  );
}

enum Syllabic { single, begin, end, middle }

/// Whether a note starts or stops a tie, or both.
enum TieState { none, start, stop, stopStart }
