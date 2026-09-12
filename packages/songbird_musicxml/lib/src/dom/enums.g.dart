// dart format off
//
// GENERATED FILE - do not edit by hand.
//
// Regenerate with:
//   dart run tool/generate_dom.dart
//
// Source: the MusicXML 4.0 XSD, tool/musicxml.xsd.

/// The enumerated types of the MusicXML schema.
library;

/// The above-below type is used to indicate whether one element appears above
/// or below another element.
enum AboveBelow {
  above('above'),
  below('below');

  const AboveBelow(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static AboveBelow? parse(String? value) {
    if (value == null) return null;
    for (final member in AboveBelow.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The accidental-value type represents notated accidentals supported by
/// MusicXML. In the MusicXML 2.0 DTD this was a string with values that could
/// be included. The XSD strengthens the data typing to an enumerated list.
/// The quarter- and three-quarters- accidentals are Tartini-style
/// quarter-tone accidentals. The -down and -up accidentals are quarter-tone
/// accidentals that include arrows pointing down or up. The slash-
/// accidentals are used in Turkish classical music. The numbered sharp and
/// flat accidentals are superscripted versions of the accidental signs, used
/// in Turkish folk music. The sori and koron accidentals are microtonal sharp
/// and flat accidentals used in Iranian and Persian music. The other
/// accidental covers accidentals other than those listed here. It is usually
/// used in combination with the smufl attribute to specify a particular SMuFL
/// accidental. The smufl attribute may be used with any accidental value to
/// help specify the appearance of symbols that share the same MusicXML
/// semantics.
enum AccidentalValue {
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

  const AccidentalValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static AccidentalValue? parse(String? value) {
    if (value == null) return null;
    for (final member in AccidentalValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The arrow-direction type represents the direction in which an arrow
/// points, using Unicode arrow terminology.
enum ArrowDirection {
  left('left'),
  up('up'),
  right('right'),
  down('down'),
  northwest('northwest'),
  northeast('northeast'),
  southeast('southeast'),
  southwest('southwest'),
  leftRight('left right'),
  upDown('up down'),
  northwestSoutheast('northwest southeast'),
  northeastSouthwest('northeast southwest'),
  other('other');

  const ArrowDirection(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static ArrowDirection? parse(String? value) {
    if (value == null) return null;
    for (final member in ArrowDirection.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The arrow-style type represents the style of an arrow, using Unicode arrow
/// terminology. Filled and hollow arrows indicate polygonal single arrows.
/// Paired arrows are duplicate single arrows in the same direction. Combined
/// arrows apply to double direction arrows like left right, indicating that
/// an arrow in one direction should be combined with an arrow in the other
/// direction.
enum ArrowStyle {
  single('single'),
  doubleValue('double'),
  filled('filled'),
  hollow('hollow'),
  paired('paired'),
  combined('combined'),
  other('other');

  const ArrowStyle(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static ArrowStyle? parse(String? value) {
    if (value == null) return null;
    for (final member in ArrowStyle.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The backward-forward type is used to specify repeat directions. The start
/// of the repeat has a forward direction while the end of the repeat has a
/// backward direction.
enum BackwardForward {
  backward('backward'),
  forward('forward');

  const BackwardForward(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static BackwardForward? parse(String? value) {
    if (value == null) return null;
    for (final member in BackwardForward.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The bar-style type represents barline style information. Choices are
/// regular, dotted, dashed, heavy, light-light, light-heavy, heavy-light,
/// heavy-heavy, tick (a short stroke through the top line), short (a partial
/// barline between the 2nd and 4th lines), and none.
enum BarStyle {
  regular('regular'),
  dotted('dotted'),
  dashed('dashed'),
  heavy('heavy'),
  lightLight('light-light'),
  lightHeavy('light-heavy'),
  heavyLight('heavy-light'),
  heavyHeavy('heavy-heavy'),
  tick('tick'),
  short('short'),
  none('none');

  const BarStyle(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static BarStyle? parse(String? value) {
    if (value == null) return null;
    for (final member in BarStyle.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The beam-value type represents the type of beam associated with each of 8
/// beam levels (up to 1024th notes) available for each note.
enum BeamValue {
  begin('begin'),
  continueValue('continue'),
  end('end'),
  forwardHook('forward hook'),
  backwardHook('backward hook');

  const BeamValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static BeamValue? parse(String? value) {
    if (value == null) return null;
    for (final member in BeamValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The beater-value type represents pictograms for beaters, mallets, and
/// sticks that do not have different materials represented in the pictogram.
/// The finger and hammer values are in addition to Stone's list.
enum BeaterValue {
  bow('bow'),
  chimeHammer('chime hammer'),
  coin('coin'),
  drumStick('drum stick'),
  finger('finger'),
  fingernail('fingernail'),
  fist('fist'),
  guiroScraper('guiro scraper'),
  hammer('hammer'),
  hand('hand'),
  jazzStick('jazz stick'),
  knittingNeedle('knitting needle'),
  metalHammer('metal hammer'),
  slideBrushOnGong('slide brush on gong'),
  snareStick('snare stick'),
  spoonMallet('spoon mallet'),
  superball('superball'),
  triangleBeater('triangle beater'),
  triangleBeaterPlain('triangle beater plain'),
  wireBrush('wire brush');

  const BeaterValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static BeaterValue? parse(String? value) {
    if (value == null) return null;
    for (final member in BeaterValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The bend-shape type distinguishes between the angled bend symbols commonly
/// used in standard notation and the curved bend symbols commonly used in
/// both tablature and standard notation.
enum BendShape {
  angled('angled'),
  curved('curved');

  const BendShape(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static BendShape? parse(String? value) {
    if (value == null) return null;
    for (final member in BendShape.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The breath-mark-value type represents the symbol used for a breath mark.
enum BreathMarkValue {
  value(''),
  comma('comma'),
  tick('tick'),
  upbow('upbow'),
  salzedo('salzedo');

  const BreathMarkValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static BreathMarkValue? parse(String? value) {
    if (value == null) return null;
    for (final member in BreathMarkValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The caesura-value type represents the shape of the caesura sign.
enum CaesuraValue {
  normal('normal'),
  thick('thick'),
  short('short'),
  curved('curved'),
  single('single'),
  value('');

  const CaesuraValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static CaesuraValue? parse(String? value) {
    if (value == null) return null;
    for (final member in CaesuraValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The cancel-location type is used to indicate where a key signature
/// cancellation appears relative to a new key signature: to the left, to the
/// right, or before the barline and to the left. It is left by default. For
/// mid-measure key elements, a cancel-location of before-barline should be
/// treated like a cancel-location of left.
enum CancelLocation {
  left('left'),
  right('right'),
  beforeBarline('before-barline');

  const CancelLocation(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static CancelLocation? parse(String? value) {
    if (value == null) return null;
    for (final member in CancelLocation.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The circular-arrow type represents the direction in which a circular arrow
/// points, using Unicode arrow terminology.
enum CircularArrow {
  clockwise('clockwise'),
  anticlockwise('anticlockwise');

  const CircularArrow(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static CircularArrow? parse(String? value) {
    if (value == null) return null;
    for (final member in CircularArrow.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The clef-sign type represents the different clef symbols. The jianpu sign
/// indicates that the music that follows should be in jianpu numbered
/// notation, just as the TAB sign indicates that the music that follows
/// should be in tablature notation. Unlike TAB, a jianpu sign does not
/// correspond to a visual clef notation.
///
/// The none sign is deprecated as of MusicXML 4.0. Use the clef element's
/// print-object attribute instead. When the none sign is used, notes should
/// be displayed as if in treble clef.
enum ClefSign {
  g('G'),
  f('F'),
  c('C'),
  percussion('percussion'),
  tAB('TAB'),
  jianpu('jianpu'),
  none('none');

  const ClefSign(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static ClefSign? parse(String? value) {
    if (value == null) return null;
    for (final member in ClefSign.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The css-font-size type includes the CSS font sizes used as an alternative
/// to a numeric point size.
enum CssFontSize {
  xxSmall('xx-small'),
  xSmall('x-small'),
  small('small'),
  medium('medium'),
  large('large'),
  xLarge('x-large'),
  xxLarge('xx-large');

  const CssFontSize(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static CssFontSize? parse(String? value) {
    if (value == null) return null;
    for (final member in CssFontSize.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The degree-symbol-value type indicates which symbol should be used in
/// specifying a degree.
enum DegreeSymbolValue {
  major('major'),
  minor('minor'),
  augmented('augmented'),
  diminished('diminished'),
  halfDiminished('half-diminished');

  const DegreeSymbolValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static DegreeSymbolValue? parse(String? value) {
    if (value == null) return null;
    for (final member in DegreeSymbolValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The degree-type-value type indicates whether the current degree element is
/// an addition, alteration, or subtraction to the kind of the current chord
/// in the harmony element.
enum DegreeTypeValue {
  add('add'),
  alter('alter'),
  subtract('subtract');

  const DegreeTypeValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static DegreeTypeValue? parse(String? value) {
    if (value == null) return null;
    for (final member in DegreeTypeValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The effect-value type represents pictograms for sound effect percussion
/// instruments. The cannon, lotus flute, and megaphone values are in addition
/// to Stone's list.
enum EffectValue {
  anvil('anvil'),
  autoHorn('auto horn'),
  birdWhistle('bird whistle'),
  cannon('cannon'),
  duckCall('duck call'),
  gunShot('gun shot'),
  klaxonHorn('klaxon horn'),
  lionsRoar('lions roar'),
  lotusFlute('lotus flute'),
  megaphone('megaphone'),
  policeWhistle('police whistle'),
  siren('siren'),
  slideWhistle('slide whistle'),
  thunderSheet('thunder sheet'),
  windMachine('wind machine'),
  windWhistle('wind whistle');

  const EffectValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static EffectValue? parse(String? value) {
    if (value == null) return null;
    for (final member in EffectValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The enclosure-shape type describes the shape and presence / absence of an
/// enclosure around text or symbols. A bracket enclosure is similar to a
/// rectangle with the bottom line missing, as is common in jazz notation. An
/// inverted-bracket enclosure is similar to a rectangle with the top line
/// missing.
enum EnclosureShape {
  rectangle('rectangle'),
  square('square'),
  oval('oval'),
  circle('circle'),
  bracket('bracket'),
  invertedBracket('inverted-bracket'),
  triangle('triangle'),
  diamond('diamond'),
  pentagon('pentagon'),
  hexagon('hexagon'),
  heptagon('heptagon'),
  octagon('octagon'),
  nonagon('nonagon'),
  decagon('decagon'),
  none('none');

  const EnclosureShape(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static EnclosureShape? parse(String? value) {
    if (value == null) return null;
    for (final member in EnclosureShape.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The fan type represents the type of beam fanning present on a note, used
/// to represent accelerandos and ritardandos.
enum Fan {
  accel('accel'),
  rit('rit'),
  none('none');

  const Fan(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static Fan? parse(String? value) {
    if (value == null) return null;
    for (final member in Fan.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The fermata-shape type represents the shape of the fermata sign. The empty
/// value is equivalent to the normal value.
enum FermataShape {
  normal('normal'),
  angled('angled'),
  square('square'),
  doubleAngled('double-angled'),
  doubleSquare('double-square'),
  doubleDot('double-dot'),
  halfCurve('half-curve'),
  curlew('curlew'),
  value('');

  const FermataShape(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static FermataShape? parse(String? value) {
    if (value == null) return null;
    for (final member in FermataShape.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The font-style type represents a simplified version of the CSS font-style
/// property.
enum FontStyle {
  normal('normal'),
  italic('italic');

  const FontStyle(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static FontStyle? parse(String? value) {
    if (value == null) return null;
    for (final member in FontStyle.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The font-weight type represents a simplified version of the CSS
/// font-weight property.
enum FontWeight {
  normal('normal'),
  bold('bold');

  const FontWeight(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static FontWeight? parse(String? value) {
    if (value == null) return null;
    for (final member in FontWeight.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The glass-value type represents pictograms for glass percussion
/// instruments.
enum GlassValue {
  glassHarmonica('glass harmonica'),
  glassHarp('glass harp'),
  windChimes('wind chimes');

  const GlassValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static GlassValue? parse(String? value) {
    if (value == null) return null;
    for (final member in GlassValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The group-barline-value type indicates if the group should have common
/// barlines.
enum GroupBarlineValue {
  yes('yes'),
  no('no'),
  mensurstrich('Mensurstrich');

  const GroupBarlineValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static GroupBarlineValue? parse(String? value) {
    if (value == null) return null;
    for (final member in GroupBarlineValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The group-symbol-value type indicates how the symbol for a group or
/// multi-staff part is indicated in the score.
enum GroupSymbolValue {
  none('none'),
  brace('brace'),
  line('line'),
  bracket('bracket'),
  square('square');

  const GroupSymbolValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static GroupSymbolValue? parse(String? value) {
    if (value == null) return null;
    for (final member in GroupSymbolValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The handbell-value type represents the type of handbell technique being
/// notated.
enum HandbellValue {
  belltree('belltree'),
  damp('damp'),
  echo('echo'),
  gyro('gyro'),
  handMartellato('hand martellato'),
  malletLift('mallet lift'),
  malletTable('mallet table'),
  martellato('martellato'),
  martellatoLift('martellato lift'),
  mutedMartellato('muted martellato'),
  pluckLift('pluck lift'),
  swing('swing');

  const HandbellValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static HandbellValue? parse(String? value) {
    if (value == null) return null;
    for (final member in HandbellValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The harmon-closed-location type indicates which portion of the symbol is
/// filled in when the corresponding harmon-closed-value is half.
enum HarmonClosedLocation {
  right('right'),
  bottom('bottom'),
  left('left'),
  top('top');

  const HarmonClosedLocation(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static HarmonClosedLocation? parse(String? value) {
    if (value == null) return null;
    for (final member in HarmonClosedLocation.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The harmon-closed-value type represents whether the harmon mute is closed,
/// open, or half-open.
enum HarmonClosedValue {
  yes('yes'),
  no('no'),
  half('half');

  const HarmonClosedValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static HarmonClosedValue? parse(String? value) {
    if (value == null) return null;
    for (final member in HarmonClosedValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The harmony-arrangement type indicates how stacked chords and bass notes
/// are displayed within a harmony element. The vertical value specifies that
/// the second element appears below the first. The horizontal value specifies
/// that the second element appears to the right of the first. The diagonal
/// value specifies that the second element appears both below and to the
/// right of the first.
enum HarmonyArrangement {
  vertical('vertical'),
  horizontal('horizontal'),
  diagonal('diagonal');

  const HarmonyArrangement(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static HarmonyArrangement? parse(String? value) {
    if (value == null) return null;
    for (final member in HarmonyArrangement.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The harmony-type type differentiates different types of harmonies when
/// alternate harmonies are possible. Explicit harmonies have all note present
/// in the music; implied have some notes missing but implied; alternate
/// represents alternate analyses.
enum HarmonyType {
  explicit('explicit'),
  implied('implied'),
  alternate('alternate');

  const HarmonyType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static HarmonyType? parse(String? value) {
    if (value == null) return null;
    for (final member in HarmonyType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The hole-closed-location type indicates which portion of the hole is
/// filled in when the corresponding hole-closed-value is half.
enum HoleClosedLocation {
  right('right'),
  bottom('bottom'),
  left('left'),
  top('top');

  const HoleClosedLocation(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static HoleClosedLocation? parse(String? value) {
    if (value == null) return null;
    for (final member in HoleClosedLocation.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The hole-closed-value type represents whether the hole is closed, open, or
/// half-open.
enum HoleClosedValue {
  yes('yes'),
  no('no'),
  half('half');

  const HoleClosedValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static HoleClosedValue? parse(String? value) {
    if (value == null) return null;
    for (final member in HoleClosedValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// A kind-value indicates the type of chord. Degree elements can then add,
/// subtract, or alter from these starting points. Values include:
///
/// Triads: major (major third, perfect fifth) minor (minor third, perfect
/// fifth) augmented (major third, augmented fifth) diminished (minor third,
/// diminished fifth) Sevenths: dominant (major triad, minor seventh)
/// major-seventh (major triad, major seventh) minor-seventh (minor triad,
/// minor seventh) diminished-seventh (diminished triad, diminished seventh)
/// augmented-seventh (augmented triad, minor seventh) half-diminished
/// (diminished triad, minor seventh) major-minor (minor triad, major seventh)
/// Sixths: major-sixth (major triad, added sixth) minor-sixth (minor triad,
/// added sixth) Ninths: dominant-ninth (dominant-seventh, major ninth)
/// major-ninth (major-seventh, major ninth) minor-ninth (minor-seventh, major
/// ninth) 11ths (usually as the basis for alteration): dominant-11th
/// (dominant-ninth, perfect 11th) major-11th (major-ninth, perfect 11th)
/// minor-11th (minor-ninth, perfect 11th) 13ths (usually as the basis for
/// alteration): dominant-13th (dominant-11th, major 13th) major-13th
/// (major-11th, major 13th) minor-13th (minor-11th, major 13th) Suspended:
/// suspended-second (major second, perfect fifth) suspended-fourth (perfect
/// fourth, perfect fifth) Functional sixths: Neapolitan Italian French German
/// Other: pedal (pedal-point bass) power (perfect fifth) Tristan
///
/// The "other" kind is used when the harmony is entirely composed of add
/// elements.
///
/// The "none" kind is used to explicitly encode absence of chords or
/// functional harmony. In this case, the root, numeral, or function element
/// has no meaning. When using the root or numeral element, the root-step or
/// numeral-step text attribute should be set to the empty string to keep the
/// root or numeral from being displayed.
enum KindValue {
  major('major'),
  minor('minor'),
  augmented('augmented'),
  diminished('diminished'),
  dominant('dominant'),
  majorSeventh('major-seventh'),
  minorSeventh('minor-seventh'),
  diminishedSeventh('diminished-seventh'),
  augmentedSeventh('augmented-seventh'),
  halfDiminished('half-diminished'),
  majorMinor('major-minor'),
  majorSixth('major-sixth'),
  minorSixth('minor-sixth'),
  dominantNinth('dominant-ninth'),
  majorNinth('major-ninth'),
  minorNinth('minor-ninth'),
  dominant11th('dominant-11th'),
  major11th('major-11th'),
  minor11th('minor-11th'),
  dominant13th('dominant-13th'),
  major13th('major-13th'),
  minor13th('minor-13th'),
  suspendedSecond('suspended-second'),
  suspendedFourth('suspended-fourth'),
  neapolitan('Neapolitan'),
  italian('Italian'),
  french('French'),
  german('German'),
  pedal('pedal'),
  power('power'),
  tristan('Tristan'),
  other('other'),
  none('none');

  const KindValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static KindValue? parse(String? value) {
    if (value == null) return null;
    for (final member in KindValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The left-center-right type is used to define horizontal alignment and text
/// justification.
enum LeftCenterRight {
  left('left'),
  center('center'),
  right('right');

  const LeftCenterRight(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static LeftCenterRight? parse(String? value) {
    if (value == null) return null;
    for (final member in LeftCenterRight.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The left-right type is used to indicate whether one element appears to the
/// left or the right of another element.
enum LeftRight {
  left('left'),
  right('right');

  const LeftRight(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static LeftRight? parse(String? value) {
    if (value == null) return null;
    for (final member in LeftRight.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The line-end type specifies if there is a jog up or down (or both), an
/// arrow, or nothing at the start or end of a bracket.
enum LineEnd {
  up('up'),
  down('down'),
  both('both'),
  arrow('arrow'),
  none('none');

  const LineEnd(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static LineEnd? parse(String? value) {
    if (value == null) return null;
    for (final member in LineEnd.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The line-length type distinguishes between different line lengths for
/// doit, falloff, plop, and scoop articulations.
enum LineLength {
  short('short'),
  medium('medium'),
  long('long');

  const LineLength(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static LineLength? parse(String? value) {
    if (value == null) return null;
    for (final member in LineLength.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The line-shape type distinguishes between straight and curved lines.
enum LineShape {
  straight('straight'),
  curved('curved');

  const LineShape(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static LineShape? parse(String? value) {
    if (value == null) return null;
    for (final member in LineShape.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The line-type type distinguishes between solid, dashed, dotted, and wavy
/// lines.
enum LineType {
  solid('solid'),
  dashed('dashed'),
  dotted('dotted'),
  wavy('wavy');

  const LineType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static LineType? parse(String? value) {
    if (value == null) return null;
    for (final member in LineType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The margin-type type specifies whether margins apply to even page, odd
/// pages, or both.
enum MarginType {
  odd('odd'),
  even('even'),
  both('both');

  const MarginType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static MarginType? parse(String? value) {
    if (value == null) return null;
    for (final member in MarginType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The measure-numbering-value type describes how measure numbers are
/// displayed on this part: no numbers, numbers every measure, or numbers
/// every system.
enum MeasureNumberingValue {
  none('none'),
  measure('measure'),
  system('system');

  const MeasureNumberingValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static MeasureNumberingValue? parse(String? value) {
    if (value == null) return null;
    for (final member in MeasureNumberingValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The membrane-value type represents pictograms for membrane percussion
/// instruments.
enum MembraneValue {
  bassDrum('bass drum'),
  bassDrumOnSide('bass drum on side'),
  bongos('bongos'),
  chineseTomtom('Chinese tomtom'),
  congaDrum('conga drum'),
  cuica('cuica'),
  gobletDrum('goblet drum'),
  indoAmericanTomtom('Indo-American tomtom'),
  japaneseTomtom('Japanese tomtom'),
  militaryDrum('military drum'),
  snareDrum('snare drum'),
  snareDrumSnaresOff('snare drum snares off'),
  tabla('tabla'),
  tambourine('tambourine'),
  tenorDrum('tenor drum'),
  timbales('timbales'),
  tomtom('tomtom');

  const MembraneValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static MembraneValue? parse(String? value) {
    if (value == null) return null;
    for (final member in MembraneValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The metal-value type represents pictograms for metal percussion
/// instruments. The hi-hat value refers to a pictogram like Stone's high-hat
/// cymbals but without the long vertical line at the bottom.
enum MetalValue {
  agogo('agogo'),
  almglocken('almglocken'),
  bell('bell'),
  bellPlate('bell plate'),
  bellTree('bell tree'),
  brakeDrum('brake drum'),
  cencerro('cencerro'),
  chainRattle('chain rattle'),
  chineseCymbal('Chinese cymbal'),
  cowbell('cowbell'),
  crashCymbals('crash cymbals'),
  crotale('crotale'),
  cymbalTongs('cymbal tongs'),
  domedGong('domed gong'),
  fingerCymbals('finger cymbals'),
  flexatone('flexatone'),
  gong('gong'),
  hiHat('hi-hat'),
  highHatCymbals('high-hat cymbals'),
  handbell('handbell'),
  jawHarp('jaw harp'),
  jingleBells('jingle bells'),
  musicalSaw('musical saw'),
  shellBells('shell bells'),
  sistrum('sistrum'),
  sizzleCymbal('sizzle cymbal'),
  sleighBells('sleigh bells'),
  suspendedCymbal('suspended cymbal'),
  tamTam('tam tam'),
  tamTamWithBeater('tam tam with beater'),
  triangle('triangle'),
  vietnameseHat('Vietnamese hat');

  const MetalValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static MetalValue? parse(String? value) {
    if (value == null) return null;
    for (final member in MetalValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The mute type represents muting for different instruments, including
/// brass, winds, and strings. The on and off values are used for
/// undifferentiated mutes. The remaining values represent specific mutes.
enum Mute {
  on('on'),
  off('off'),
  straight('straight'),
  cup('cup'),
  harmonNoStem('harmon-no-stem'),
  harmonStem('harmon-stem'),
  bucket('bucket'),
  plunger('plunger'),
  hat('hat'),
  solotone('solotone'),
  practice('practice'),
  stopMute('stop-mute'),
  stopHand('stop-hand'),
  echo('echo'),
  palm('palm');

  const Mute(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static Mute? parse(String? value) {
    if (value == null) return null;
    for (final member in Mute.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The note-size-type type indicates the type of note being defined by a
/// note-size element. The grace-cue type is used for notes of grace-cue size.
/// The grace type is used for notes of cue size that include a grace element.
/// The cue type is used for all other notes with cue size, whether defined
/// explicitly or implicitly via a cue element. The large type is used for
/// notes of large size.
enum NoteSizeType {
  cue('cue'),
  grace('grace'),
  graceCue('grace-cue'),
  large('large');

  const NoteSizeType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static NoteSizeType? parse(String? value) {
    if (value == null) return null;
    for (final member in NoteSizeType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The note-type-value type is used for the MusicXML type element and
/// represents the graphic note type, from 1024th (shortest) to maxima
/// (longest).
enum NoteTypeValue {
  n1024th('1024th'),
  n512th('512th'),
  n256th('256th'),
  n128th('128th'),
  n64th('64th'),
  n32nd('32nd'),
  n16th('16th'),
  eighth('eighth'),
  quarter('quarter'),
  half('half'),
  whole('whole'),
  breve('breve'),
  long('long'),
  maxima('maxima');

  const NoteTypeValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static NoteTypeValue? parse(String? value) {
    if (value == null) return null;
    for (final member in NoteTypeValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The notehead-value type indicates shapes other than the open and closed
/// ovals associated with note durations.
///
/// The values do, re, mi, fa, fa up, so, la, and ti correspond to Aikin's
/// 7-shape system. The fa up shape is typically used with upstems; the fa
/// shape is typically used with downstems or no stems.
///
/// The arrow shapes differ from triangle and inverted triangle by being
/// centered on the stem. Slashed and back slashed notes include both the
/// normal notehead and a slash. The triangle shape has the tip of the
/// triangle pointing up; the inverted triangle shape has the tip of the
/// triangle pointing down. The left triangle shape is a right triangle with
/// the hypotenuse facing up and to the left.
///
/// The other notehead covers noteheads other than those listed here. It is
/// usually used in combination with the smufl attribute to specify a
/// particular SMuFL notehead. The smufl attribute may be used with any
/// notehead value to help specify the appearance of symbols that share the
/// same MusicXML semantics. Noteheads in the SMuFL Note name noteheads and
/// Note name noteheads supplement ranges (U+E150–U+E1AF and U+EEE0–U+EEFF)
/// should not use the smufl attribute or the "other" value, but instead use
/// the notehead-text element.
enum NoteheadValue {
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
  normal('normal'),
  cluster('cluster'),
  circleDot('circle dot'),
  leftTriangle('left triangle'),
  rectangle('rectangle'),
  none('none'),
  doValue('do'),
  re('re'),
  mi('mi'),
  fa('fa'),
  faUp('fa up'),
  so('so'),
  la('la'),
  ti('ti'),
  other('other');

  const NoteheadValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static NoteheadValue? parse(String? value) {
    if (value == null) return null;
    for (final member in NoteheadValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The numeral-mode type specifies the mode similar to the mode type, but
/// with a restricted set of values. The different minor values are used to
/// interpret numeral-root values of 6 and 7 when present in a minor key. The
/// harmonic minor value sharpens the 7 and the melodic minor value sharpens
/// both 6 and 7. If a minor mode is used without qualification, either in the
/// mode or numeral-mode elements, natural minor is used.
enum NumeralMode {
  major('major'),
  minor('minor'),
  naturalMinor('natural minor'),
  melodicMinor('melodic minor'),
  harmonicMinor('harmonic minor');

  const NumeralMode(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static NumeralMode? parse(String? value) {
    if (value == null) return null;
    for (final member in NumeralMode.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The on-off type is used for notation elements such as string mutes.
enum OnOff {
  on('on'),
  off('off');

  const OnOff(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static OnOff? parse(String? value) {
    if (value == null) return null;
    for (final member in OnOff.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The over-under type is used to indicate whether the tips of curved lines
/// such as slurs and ties are overhand (tips down) or underhand (tips up).
enum OverUnder {
  over('over'),
  under('under');

  const OverUnder(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static OverUnder? parse(String? value) {
    if (value == null) return null;
    for (final member in OverUnder.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The pedal-type simple type is used to distinguish types of pedal
/// directions. The start value indicates the start of a damper pedal, while
/// the sostenuto value indicates the start of a sostenuto pedal. The other
/// values can be used with either the damper or sostenuto pedal. The soft
/// pedal is not included here because there is no special symbol or graphic
/// used for it beyond what can be specified with words and bracket elements.
///
/// The change, continue, discontinue, and resume types are used when the line
/// attribute is yes. The change type indicates a pedal lift and retake
/// indicated with an inverted V marking. The continue type allows more
/// precise formatting across system breaks and for more complex pedaling
/// lines. The discontinue type indicates the end of a pedal line that does
/// not include the explicit lift represented by the stop type. The resume
/// type indicates the start of a pedal line that does not include the
/// downstroke represented by the start type. It can be used when a line
/// resumes after being discontinued, or to start a pedal line that is
/// preceded by a text or symbol representation of the pedal.
enum PedalType {
  start('start'),
  stop('stop'),
  sostenuto('sostenuto'),
  change('change'),
  continueValue('continue'),
  discontinue('discontinue'),
  resume('resume');

  const PedalType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static PedalType? parse(String? value) {
    if (value == null) return null;
    for (final member in PedalType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The pitched-value type represents pictograms for pitched percussion
/// instruments. The chimes and tubular chimes values distinguish the
/// single-line and double-line versions of the pictogram.
enum PitchedValue {
  celesta('celesta'),
  chimes('chimes'),
  glockenspiel('glockenspiel'),
  lithophone('lithophone'),
  mallet('mallet'),
  marimba('marimba'),
  steelDrums('steel drums'),
  tubaphone('tubaphone'),
  tubularChimes('tubular chimes'),
  vibraphone('vibraphone'),
  xylophone('xylophone');

  const PitchedValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static PitchedValue? parse(String? value) {
    if (value == null) return null;
    for (final member in PitchedValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The principal-voice-symbol type represents the type of symbol used to
/// indicate a principal or secondary voice. The "plain" value represents a
/// plain square bracket. The value of "none" is used for analysis markup when
/// the principal-voice element does not have a corresponding appearance in
/// the score.
enum PrincipalVoiceSymbol {
  hauptstimme('Hauptstimme'),
  nebenstimme('Nebenstimme'),
  plain('plain'),
  none('none');

  const PrincipalVoiceSymbol(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static PrincipalVoiceSymbol? parse(String? value) {
    if (value == null) return null;
    for (final member in PrincipalVoiceSymbol.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The right-left-middle type is used to specify barline location.
enum RightLeftMiddle {
  right('right'),
  left('left'),
  middle('middle');

  const RightLeftMiddle(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static RightLeftMiddle? parse(String? value) {
    if (value == null) return null;
    for (final member in RightLeftMiddle.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The semi-pitched type represents categories of indefinite pitch for
/// percussion instruments.
enum SemiPitched {
  high('high'),
  mediumHigh('medium-high'),
  medium('medium'),
  mediumLow('medium-low'),
  low('low'),
  veryLow('very-low');

  const SemiPitched(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static SemiPitched? parse(String? value) {
    if (value == null) return null;
    for (final member in SemiPitched.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The show-frets type indicates whether to show tablature frets as numbers
/// (0, 1, 2) or letters (a, b, c). The default choice is numbers.
enum ShowFrets {
  numbers('numbers'),
  letters('letters');

  const ShowFrets(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static ShowFrets? parse(String? value) {
    if (value == null) return null;
    for (final member in ShowFrets.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The show-tuplet type indicates whether to show a part of a tuplet relating
/// to the tuplet-actual element, both the tuplet-actual and tuplet-normal
/// elements, or neither.
enum ShowTuplet {
  actual('actual'),
  both('both'),
  none('none');

  const ShowTuplet(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static ShowTuplet? parse(String? value) {
    if (value == null) return null;
    for (final member in ShowTuplet.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The staff-divide-symbol type is used for staff division symbols. The down,
/// up, and up-down values correspond to SMuFL code points U+E00B, U+E00C, and
/// U+E00D respectively.
enum StaffDivideSymbol {
  down('down'),
  up('up'),
  upDown('up-down');

  const StaffDivideSymbol(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StaffDivideSymbol? parse(String? value) {
    if (value == null) return null;
    for (final member in StaffDivideSymbol.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The staff-type value can be ossia, editorial, cue, alternate, or regular.
/// An ossia staff represents music that can be played instead of what appears
/// on the regular staff. An editorial staff also represents musical
/// alternatives, but is created by an editor rather than the composer. It can
/// be used for suggested interpretations or alternatives from other sources.
/// A cue staff represents music from another part. An alternate staff shares
/// the same music as the prior staff, but displayed differently (e.g., treble
/// and bass clef, standard notation and tablature). It is not included in
/// playback. An alternate staff provides more information to an application
/// reading a file than encoding the same music in separate parts, so its use
/// is preferred in this situation if feasible. A regular staff is the
/// standard default staff-type.
enum StaffType {
  ossia('ossia'),
  editorial('editorial'),
  cue('cue'),
  alternate('alternate'),
  regular('regular');

  const StaffType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StaffType? parse(String? value) {
    if (value == null) return null;
    for (final member in StaffType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The start-note type describes the starting note of trills and mordents for
/// playback, relative to the current note.
enum StartNote {
  upper('upper'),
  main('main'),
  below('below');

  const StartNote(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StartNote? parse(String? value) {
    if (value == null) return null;
    for (final member in StartNote.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The start-stop type is used for an attribute of musical elements that can
/// either start or stop, such as tuplets.
///
/// The values of start and stop refer to how an element appears in musical
/// score order, not in MusicXML document order. An element with a stop
/// attribute may precede the corresponding element with a start attribute
/// within a MusicXML document. This is particularly common in multi-staff
/// music. For example, the stopping point for a tuplet may appear in staff 1
/// before the starting point for the tuplet appears in staff 2 later in the
/// document.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score
/// order.
enum StartStop {
  start('start'),
  stop('stop');

  const StartStop(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StartStop? parse(String? value) {
    if (value == null) return null;
    for (final member in StartStop.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The start-stop-change-continue type is used to distinguish types of pedal
/// directions.
enum StartStopChangeContinue {
  start('start'),
  stop('stop'),
  change('change'),
  continueValue('continue');

  const StartStopChangeContinue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StartStopChangeContinue? parse(String? value) {
    if (value == null) return null;
    for (final member in StartStopChangeContinue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The start-stop-continue type is used for an attribute of musical elements
/// that can either start or stop, but also need to refer to an intermediate
/// point in the symbol, as for complex slurs or for formatting of symbols
/// across system breaks.
///
/// The values of start, stop, and continue refer to how an element appears in
/// musical score order, not in MusicXML document order. An element with a
/// stop attribute may precede the corresponding element with a start
/// attribute within a MusicXML document. This is particularly common in
/// multi-staff music. For example, the stopping point for a slur may appear
/// in staff 1 before the starting point for the slur appears in staff 2 later
/// in the document.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score
/// order. For example, a note that marks both the end of one slur and the
/// start of a new slur should have the incoming slur element with a type of
/// stop precede the outgoing slur element with a type of start.
enum StartStopContinue {
  start('start'),
  stop('stop'),
  continueValue('continue');

  const StartStopContinue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StartStopContinue? parse(String? value) {
    if (value == null) return null;
    for (final member in StartStopContinue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The start-stop-discontinue type is used to specify ending types.
/// Typically, the start type is associated with the left barline of the first
/// measure in an ending. The stop and discontinue types are associated with
/// the right barline of the last measure in an ending. Stop is used when the
/// ending mark concludes with a downward jog, as is typical for first
/// endings. Discontinue is used when there is no downward jog, as is typical
/// for second endings that do not conclude a piece.
enum StartStopDiscontinue {
  start('start'),
  stop('stop'),
  discontinue('discontinue');

  const StartStopDiscontinue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StartStopDiscontinue? parse(String? value) {
    if (value == null) return null;
    for (final member in StartStopDiscontinue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The start-stop-single type is used for an attribute of musical elements
/// that can be used for either multi-note or single-note musical elements, as
/// for groupings.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score
/// order.
enum StartStopSingle {
  start('start'),
  stop('stop'),
  single('single');

  const StartStopSingle(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StartStopSingle? parse(String? value) {
    if (value == null) return null;
    for (final member in StartStopSingle.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The stem-value type represents the notated stem direction.
enum StemValue {
  down('down'),
  up('up'),
  doubleValue('double'),
  none('none');

  const StemValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StemValue? parse(String? value) {
    if (value == null) return null;
    for (final member in StemValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The step type represents a step of the diatonic scale, represented using
/// the English letters A through G.
enum Step {
  a('A'),
  b('B'),
  c('C'),
  d('D'),
  e('E'),
  f('F'),
  g('G');

  const Step(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static Step? parse(String? value) {
    if (value == null) return null;
    for (final member in Step.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The stick-location type represents pictograms for the location of sticks,
/// beaters, or mallets on cymbals, gongs, drums, and other instruments.
enum StickLocation {
  center('center'),
  rim('rim'),
  cymbalBell('cymbal bell'),
  cymbalEdge('cymbal edge');

  const StickLocation(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StickLocation? parse(String? value) {
    if (value == null) return null;
    for (final member in StickLocation.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The stick-material type represents the material being displayed in a stick
/// pictogram.
enum StickMaterial {
  soft('soft'),
  medium('medium'),
  hard('hard'),
  shaded('shaded'),
  x('x');

  const StickMaterial(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StickMaterial? parse(String? value) {
    if (value == null) return null;
    for (final member in StickMaterial.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The stick-type type represents the shape of pictograms where the material
/// in the stick, mallet, or beater is represented in the pictogram.
enum StickType {
  bassDrum('bass drum'),
  doubleBassDrum('double bass drum'),
  glockenspiel('glockenspiel'),
  gum('gum'),
  hammer('hammer'),
  superball('superball'),
  timpani('timpani'),
  wound('wound'),
  xylophone('xylophone'),
  yarn('yarn');

  const StickType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static StickType? parse(String? value) {
    if (value == null) return null;
    for (final member in StickType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The swing-type-value type specifies the note type, either eighth or 16th,
/// to which the ratio defined in the swing element is applied.
enum SwingTypeValue {
  n16th('16th'),
  eighth('eighth');

  const SwingTypeValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static SwingTypeValue? parse(String? value) {
    if (value == null) return null;
    for (final member in SwingTypeValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// Lyric hyphenation is indicated by the syllabic type. The single, begin,
/// end, and middle values represent single-syllable words, word-beginning
/// syllables, word-ending syllables, and mid-word syllables, respectively.
enum Syllabic {
  single('single'),
  begin('begin'),
  end('end'),
  middle('middle');

  const Syllabic(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static Syllabic? parse(String? value) {
    if (value == null) return null;
    for (final member in Syllabic.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The symbol-size type is used to distinguish between full, cue sized, grace
/// cue sized, and oversized symbols.
enum SymbolSize {
  full('full'),
  cue('cue'),
  graceCue('grace-cue'),
  large('large');

  const SymbolSize(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static SymbolSize? parse(String? value) {
    if (value == null) return null;
    for (final member in SymbolSize.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The sync-type type specifies the style that a score following application
/// should use to synchronize an accompaniment with a performer. The none type
/// indicates no synchronization to the performer. The tempo type indicates
/// synchronization based on the performer tempo rather than individual events
/// in the score. The event type indicates synchronization by following the
/// performance of individual events in the score rather than the performer
/// tempo. The mostly-tempo and mostly-event types combine these two
/// approaches, with mostly-tempo giving more weight to tempo and mostly-event
/// giving more weight to performed events. The always-event type provides the
/// strictest synchronization by not being forgiving of missing performed
/// events.
enum SyncType {
  none('none'),
  tempo('tempo'),
  mostlyTempo('mostly-tempo'),
  mostlyEvent('mostly-event'),
  event('event'),
  alwaysEvent('always-event');

  const SyncType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static SyncType? parse(String? value) {
    if (value == null) return null;
    for (final member in SyncType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The system-relation type distinguishes elements that are associated with a
/// system rather than the particular part where the element appears. A value
/// of only-top indicates that the element should appear only on the top part
/// of the current system. A value of also-top indicates that the element
/// should appear on both the current part and the top part of the current
/// system. If this value appears in a score, when parts are created the
/// element should only appear once in this part, not twice. A value of none
/// indicates that the element is associated only with the current part, not
/// with the system.
enum SystemRelation {
  onlyTop('only-top'),
  alsoTop('also-top'),
  none('none');

  const SystemRelation(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static SystemRelation? parse(String? value) {
    if (value == null) return null;
    for (final member in SystemRelation.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The system-relation-number type distinguishes measure numbers that are
/// associated with a system rather than the particular part where the element
/// appears. A value of only-top or only-bottom indicates that the number
/// should appear only on the top or bottom part of the current system,
/// respectively. A value of also-top or also-bottom indicates that the number
/// should appear on both the current part and the top or bottom part of the
/// current system, respectively. If these values appear in a score, when
/// parts are created the number should only appear once in this part, not
/// twice. A value of none indicates that the number is associated only with
/// the current part, not with the system.
enum SystemRelationNumber {
  onlyTop('only-top'),
  onlyBottom('only-bottom'),
  alsoTop('also-top'),
  alsoBottom('also-bottom'),
  none('none');

  const SystemRelationNumber(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static SystemRelationNumber? parse(String? value) {
    if (value == null) return null;
    for (final member in SystemRelationNumber.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The tap-hand type represents the symbol to use for a tap element. The left
/// and right values refer to the SMuFL guitarLeftHandTapping and
/// guitarRightHandTapping glyphs respectively.
enum TapHand {
  left('left'),
  right('right');

  const TapHand(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TapHand? parse(String? value) {
    if (value == null) return null;
    for (final member in TapHand.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The text-direction type is used to adjust and override the Unicode
/// bidirectional text algorithm, similar to the Directionality data category
/// in the W3C Internationalization Tag Set recommendation. Values are ltr
/// (left-to-right embed), rtl (right-to-left embed), lro (left-to-right
/// bidi-override), and rlo (right-to-left bidi-override). The default value
/// is ltr. This type is typically used by applications that store text in
/// left-to-right visual order rather than logical order. Such applications
/// can use the lro value to better communicate with other applications that
/// more fully support bidirectional text.
enum TextDirection {
  ltr('ltr'),
  rtl('rtl'),
  lro('lro'),
  rlo('rlo');

  const TextDirection(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TextDirection? parse(String? value) {
    if (value == null) return null;
    for (final member in TextDirection.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The tied-type type is used as an attribute of the tied element to specify
/// where the visual representation of a tie begins and ends. A tied element
/// which joins two notes of the same pitch can be specified with tied-type
/// start on the first note and tied-type stop on the second note. To indicate
/// a note should be undamped, use a single tied element with tied-type
/// let-ring. For other ties that are visually attached to a single note, such
/// as a tie leading into or out of a repeated section or coda, use two tied
/// elements on the same note, one start and one stop.
///
/// In start-stop cases, ties can add more elements using a continue type.
/// This is typically used to specify the formatting of cross-system ties.
///
/// When multiple elements with the same tag are used within the same note,
/// their order within the MusicXML document should match the musical score
/// order. For example, a note with a tie at the end of a first ending should
/// have the tied element with a type of start precede the tied element with a
/// type of stop.
enum TiedType {
  start('start'),
  stop('stop'),
  continueValue('continue'),
  letRing('let-ring');

  const TiedType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TiedType? parse(String? value) {
    if (value == null) return null;
    for (final member in TiedType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The time-relation type indicates the symbol used to represent the
/// interchangeable aspect of dual time signatures.
enum TimeRelation {
  parentheses('parentheses'),
  bracket('bracket'),
  equals('equals'),
  slash('slash'),
  space('space'),
  hyphen('hyphen');

  const TimeRelation(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TimeRelation? parse(String? value) {
    if (value == null) return null;
    for (final member in TimeRelation.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The time-separator type indicates how to display the arrangement between
/// the beats and beat-type values in a time signature. The default value is
/// none. The horizontal, diagonal, and vertical values represent horizontal,
/// diagonal lower-left to upper-right, and vertical lines respectively. For
/// these values, the beats and beat-type values are arranged on either side
/// of the separator line. The none value represents no separator with the
/// beats and beat-type arranged vertically. The adjacent value represents no
/// separator with the beats and beat-type arranged horizontally.
enum TimeSeparator {
  none('none'),
  horizontal('horizontal'),
  diagonal('diagonal'),
  vertical('vertical'),
  adjacent('adjacent');

  const TimeSeparator(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TimeSeparator? parse(String? value) {
    if (value == null) return null;
    for (final member in TimeSeparator.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The time-symbol type indicates how to display a time signature. The normal
/// value is the usual fractional display, and is the implied symbol type if
/// none is specified. Other options are the common and cut time symbols, as
/// well as a single number with an implied denominator. The note symbol
/// indicates that the beat-type should be represented with the corresponding
/// downstem note rather than a number. The dotted-note symbol indicates that
/// the beat-type should be represented with a dotted downstem note that
/// corresponds to three times the beat-type value, and a numerator that is
/// one third the beats value.
enum TimeSymbol {
  common('common'),
  cut('cut'),
  singleNumber('single-number'),
  note('note'),
  dottedNote('dotted-note'),
  normal('normal');

  const TimeSymbol(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TimeSymbol? parse(String? value) {
    if (value == null) return null;
    for (final member in TimeSymbol.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The tip-direction type represents the direction in which the tip of a
/// stick or beater points, using Unicode arrow terminology.
enum TipDirection {
  up('up'),
  down('down'),
  left('left'),
  right('right'),
  northwest('northwest'),
  northeast('northeast'),
  southeast('southeast'),
  southwest('southwest');

  const TipDirection(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TipDirection? parse(String? value) {
    if (value == null) return null;
    for (final member in TipDirection.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The top-bottom type is used to indicate the top or bottom part of a
/// vertical shape like non-arpeggiate.
enum TopBottom {
  top('top'),
  bottom('bottom');

  const TopBottom(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TopBottom? parse(String? value) {
    if (value == null) return null;
    for (final member in TopBottom.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The tremolo-type is used to distinguish double-note, single-note, and
/// unmeasured tremolos.
enum TremoloType {
  start('start'),
  stop('stop'),
  single('single'),
  unmeasured('unmeasured');

  const TremoloType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TremoloType? parse(String? value) {
    if (value == null) return null;
    for (final member in TremoloType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The trill-step type describes the alternating note of trills and mordents
/// for playback, relative to the current note.
enum TrillStep {
  whole('whole'),
  half('half'),
  unison('unison');

  const TrillStep(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TrillStep? parse(String? value) {
    if (value == null) return null;
    for (final member in TrillStep.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The two-note-turn type describes the ending notes of trills and mordents
/// for playback, relative to the current note.
enum TwoNoteTurn {
  whole('whole'),
  half('half'),
  none('none');

  const TwoNoteTurn(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static TwoNoteTurn? parse(String? value) {
    if (value == null) return null;
    for (final member in TwoNoteTurn.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The up-down type is used for the direction of arrows and other pointed
/// symbols like vertical accents, indicating which way the tip is pointing.
enum UpDown {
  up('up'),
  down('down');

  const UpDown(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static UpDown? parse(String? value) {
    if (value == null) return null;
    for (final member in UpDown.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The up-down-stop-continue type is used for octave-shift elements,
/// indicating the direction of the shift from their true pitched values
/// because of printing difficulty.
enum UpDownStopContinue {
  up('up'),
  down('down'),
  stop('stop'),
  continueValue('continue');

  const UpDownStopContinue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static UpDownStopContinue? parse(String? value) {
    if (value == null) return null;
    for (final member in UpDownStopContinue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The upright-inverted type describes the appearance of a fermata element.
/// The value is upright if not specified.
enum UprightInverted {
  upright('upright'),
  inverted('inverted');

  const UprightInverted(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static UprightInverted? parse(String? value) {
    if (value == null) return null;
    for (final member in UprightInverted.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The valign type is used to indicate vertical alignment to the top, middle,
/// bottom, or baseline of the text. If the text is on multiple lines,
/// baseline alignment refers to the baseline of the lowest line of text.
/// Defaults are implementation-dependent.
enum Valign {
  top('top'),
  middle('middle'),
  bottom('bottom'),
  baseline('baseline');

  const Valign(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static Valign? parse(String? value) {
    if (value == null) return null;
    for (final member in Valign.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The valign-image type is used to indicate vertical alignment for images
/// and graphics, so it does not include a baseline value. Defaults are
/// implementation-dependent.
enum ValignImage {
  top('top'),
  middle('middle'),
  bottom('bottom');

  const ValignImage(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static ValignImage? parse(String? value) {
    if (value == null) return null;
    for (final member in ValignImage.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The wedge type is crescendo for the start of a wedge that is closed at the
/// left side, diminuendo for the start of a wedge that is closed on the right
/// side, and stop for the end of a wedge. The continue type is used for
/// formatting wedges over a system break, or for other situations where a
/// single wedge is divided into multiple segments.
enum WedgeType {
  crescendo('crescendo'),
  diminuendo('diminuendo'),
  stop('stop'),
  continueValue('continue');

  const WedgeType(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static WedgeType? parse(String? value) {
    if (value == null) return null;
    for (final member in WedgeType.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The winged attribute indicates whether the repeat has winged extensions
/// that appear above and below the barline. The straight and curved values
/// represent single wings, while the double-straight and double-curved values
/// represent double wings. The none value indicates no wings and is the
/// default.
enum Winged {
  none('none'),
  straight('straight'),
  curved('curved'),
  doubleStraight('double-straight'),
  doubleCurved('double-curved');

  const Winged(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static Winged? parse(String? value) {
    if (value == null) return null;
    for (final member in Winged.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The wood-value type represents pictograms for wood percussion instruments.
/// The maraca and maracas values distinguish the one- and two-maraca versions
/// of the pictogram.
enum WoodValue {
  bambooScraper('bamboo scraper'),
  boardClapper('board clapper'),
  cabasa('cabasa'),
  castanets('castanets'),
  castanetsWithHandle('castanets with handle'),
  claves('claves'),
  footballRattle('football rattle'),
  guiro('guiro'),
  logDrum('log drum'),
  maraca('maraca'),
  maracas('maracas'),
  quijada('quijada'),
  rainstick('rainstick'),
  ratchet('ratchet'),
  recoReco('reco-reco'),
  sandpaperBlocks('sandpaper blocks'),
  slitDrum('slit drum'),
  templeBlock('temple block'),
  vibraslap('vibraslap'),
  whip('whip'),
  woodBlock('wood block');

  const WoodValue(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static WoodValue? parse(String? value) {
    if (value == null) return null;
    for (final member in WoodValue.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

/// The yes-no type is used for boolean-like attributes. We cannot use W3C XML
/// Schema booleans due to their restrictions on expression of boolean values.
enum YesNo {
  yes('yes'),
  no('no');

  const YesNo(this.xmlValue);

  /// The value as it appears in a MusicXML document.
  final String xmlValue;

  /// The member matching [value], or `null` if none does.
  static YesNo? parse(String? value) {
    if (value == null) return null;
    for (final member in YesNo.values) {
      if (member.xmlValue == value) return member;
    }
    return null;
  }
}

