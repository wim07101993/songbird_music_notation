import 'package:flutter/painting.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// The sizes and colours a score is drawn with.
///
/// Every measurement is in staff spaces — the distance between two staff lines
/// — so that the same style describes a score at any zoom level. The painter
/// multiplies by the current staff space in pixels; nothing here knows about
/// pixels at all.
///
/// Line weights come from the font's own [EngravingDefaults] where the font
/// publishes them, because a stem drawn at Bravura's 0.12 spaces next to a
/// Bravura notehead is what makes the page look engraved rather than assembled.
class EngravingStyle {
  const EngravingStyle({
    this.staffLineCount = 5,
    this.staffDistance = 8,
    this.systemDistance = 12,
    this.partDistance = 10,
    this.systemLeftMargin = 0,
    this.pageMargin = 6,
    this.minimumNoteSpacing = 1.8,
    this.spacingExponent = 0.6,
    this.spacingWidth = 4.0,
    this.stemLength = 3.5,
    this.minimumStemLength = 2.5,
    this.ledgerLineExtension = 0.4,
    this.accidentalGap = 0.22,
    this.dotGap = 0.35,
    this.dotSpacing = 0.5,
    this.articulationGap = 0.5,
    this.arpeggioGap = 0.3,
    this.arpeggioHook = 0.4,
    this.directionGap = 0.45,
    this.lyricGap = 1.2,
    this.lyricLineHeight = 2.2,
    this.lyricFontSize = 1.6,
    this.textFontSize = 1.8,
    this.titleFontSize = 4,
    this.subtitleFontSize = 2.2,
    this.partNameFontSize = 1.7,
    this.chordFontSize = 1.9,
    this.tabFontSize = 1.15,
    this.slurHeight = 1.4,
    this.slurGap = 0.5,
    this.tupletBracketHeight = 1.2,
    this.endingHookLength = 1.7,
    this.endingFontSize = 1.5,
    this.barlineGap = 1.2,
    this.measureLeftPadding = 1.3,
    this.measureFurnitureGap = 0.55,
    this.clefGap = 1.0,
    this.keyGap = 0.4,
    this.timeGap = 1.4,
    this.clefChangeScale = 0.75,
    this.graceNoteScale = 0.6,
    this.cueNoteScale = 0.75,
    this.measureNumbers = MeasureNumbering.everySystem,
    this.measuresPerSystem,
    this.honourSystemBreaks = true,
    this.colors = const NotationColors(),
    this.fonts = const NotationFonts(),
    this.lines = const EngravingDefaults(),
  });

  /// A style that follows a loaded font's own engraving defaults.
  factory EngravingStyle.fromFont(
    SmuflFont font, {
    NotationColors colors = const NotationColors(),
    NotationFonts fonts = const NotationFonts(),
  }) => EngravingStyle(colors: colors, fonts: fonts).withFont(font);

  /// How many lines the staves have. Overridden per staff by the score.
  final int staffLineCount;

  /// Space between two staves of the same part, measured between the facing
  /// lines.
  final double staffDistance;

  /// Space between systems.
  final double systemDistance;

  /// Space between the staves of different parts within a system.
  final double partDistance;

  /// Indent at the left of every system, beyond any part names.
  final double systemLeftMargin;

  /// Margin around the whole page.
  final double pageMargin;

  /// The least space between two consecutive notes.
  final double minimumNoteSpacing;

  /// How sharply spacing grows with duration.
  ///
  /// A half note gets more room than a quarter but not twice as much; the
  /// classic engraving compromise is somewhere near the square root, and 0.6
  /// is the value most modern engravers settle on.
  final double spacingExponent;

  /// Space given to a quarter note before the exponent is applied.
  final double spacingWidth;

  /// Length of a stem on a note near the middle of the staff.
  final double stemLength;

  /// The shortest a stem may be squeezed to for a note far from the staff.
  final double minimumStemLength;

  /// How far a ledger line reaches past the notehead on each side.
  final double ledgerLineExtension;

  /// Gap between an accidental and the notehead it belongs to.
  final double accidentalGap;

  /// Gap between a notehead and its first augmentation dot.
  final double dotGap;

  /// Gap between augmentation dots.
  final double dotSpacing;

  /// Gap between the staff or notehead and an articulation.
  final double articulationGap;

  /// Gap between a chord and the wavy line telling a player to spread it.
  final double arpeggioGap;

  /// How far the hooks of a non-arpeggiate bracket turn towards the chord.
  final double arpeggioHook;

  /// Space between one row of marks above or below a staff and the next.
  ///
  /// A tempo mark under a rehearsal letter, or a coda under a tempo mark: each
  /// row is measured to the height of the tallest thing in it, and without a
  /// gap between them they read as one block of marks rather than as separate
  /// lines.
  final double directionGap;

  /// Gap between the staff and the first lyric line.
  final double lyricGap;

  /// Distance from one verse's baseline to the next.
  final double lyricLineHeight;

  final double lyricFontSize;
  final double textFontSize;
  final double titleFontSize;
  final double subtitleFontSize;
  final double partNameFontSize;

  /// Size of a chord symbol.
  final double chordFontSize;

  /// Size of a fret number on a tablature staff.
  final double tabFontSize;

  /// How far a slur bulges from the line between its ends.
  final double slurHeight;

  /// Air a slur keeps from what it arches over, another slur included.
  final double slurGap;

  /// Height of a tuplet bracket's end hooks.
  final double tupletBracketHeight;

  /// How far a volta bracket's hooks reach down towards the staff.
  ///
  /// Deep enough to hold the number written inside it, since that is what the
  /// hook is there to enclose.
  final double endingHookLength;

  /// Size of the number written inside a volta bracket.
  final double endingFontSize;

  /// Air between the last note of a measure and the barline that closes it.
  ///
  /// A barline wants about as much room in front of it as
  /// [measureLeftPadding] leaves behind it. With much less the measure reads
  /// as though it had been cut off rather than closed, and the eye loses the
  /// beat of white space that tells it one measure has ended.
  ///
  /// The same gap separates a closing barline from an opening repeat drawn
  /// immediately after it.
  final double barlineGap;

  /// Space between a barline and whatever the next measure starts with.
  ///
  /// Without it the first note of a measure lands on the barline: engraved
  /// music always leaves a little air there, and the eye uses that gap to see
  /// where one measure ends and the next begins.
  final double measureLeftPadding;

  /// Space between a barline and a clef, key or time signature printed just
  /// after it.
  ///
  /// Less than [measureLeftPadding], which is the air a *note* wants after a
  /// barline. A change of clef belongs close to the bar it applies from, and
  /// given a note's worth of air it reads as though it were floating between
  /// the two measures.
  final double measureFurnitureGap;

  /// Space after a clef.
  final double clefGap;

  /// Space between the accidentals of a key signature.
  ///
  /// The gap after the whole signature is [clefGap], so that a clef, a key and
  /// a time signature read as three separate things rather than one block.
  final double keyGap;

  /// Space between a time signature and the first note after it.
  final double timeGap;

  /// Size of a clef printed in the middle of a score, relative to the one at
  /// the start of a system.
  ///
  /// A change of clef is a reminder rather than an announcement, and engraved
  /// music draws it smaller. It also costs less room, which every other staff
  /// in the score pays for: the notes after it have to stay in line across the
  /// parts, so a full-size clef on one staff pushes them all along.
  final double clefChangeScale;

  /// Size of a grace note relative to a full-size one.
  final double graceNoteScale;

  /// Size of a cue note relative to a full-size one.
  final double cueNoteScale;

  /// How often a measure number is printed.
  final MeasureNumbering measureNumbers;

  /// Whether a break the file asked for is taken.
  ///
  /// A MusicXML file records where the systems fell in the engraving it came
  /// from. That is the right thing to follow when the whole score is shown and
  /// the wrong thing when it is not: a part extracted from it is a different
  /// engraving, and keeping the score's breaks leaves a line of one measure
  /// where the score had a page turn.
  final bool honourSystemBreaks;

  /// Break a system after this many measures, whatever else would fit.
  ///
  /// Null, the default, fills each system to the margin, which is what
  /// engraved music does. Setting it to four is what a hymn book or a folk
  /// collection does instead: the phrases are four measures long and every
  /// line holds one of them, so the eye learns where it is.
  ///
  /// A measure too wide for a system still gets one to itself.
  final int? measuresPerSystem;

  final NotationColors colors;

  /// The typefaces used for the writing around the notes.
  final NotationFonts fonts;

  /// Stem, beam, barline and staff-line weights.
  ///
  /// Taken from the font by [withFont]; otherwise the specification's
  /// defaults, which are close enough that a score drawn before the metadata
  /// has loaded does not visibly jump when it arrives.
  final EngravingDefaults lines;

  /// This style using [font]'s own line weights.
  EngravingStyle withFont(SmuflFont font) => copyWith(lines: font.engraving);

  /// The fields, in a fixed order, so equality and hashing stay in step with
  /// the constructor without repeating the list twice more.
  List<Object?> get _fields => [
    staffLineCount,
    staffDistance,
    systemDistance,
    partDistance,
    systemLeftMargin,
    pageMargin,
    minimumNoteSpacing,
    spacingExponent,
    spacingWidth,
    stemLength,
    minimumStemLength,
    ledgerLineExtension,
    accidentalGap,
    dotGap,
    dotSpacing,
    articulationGap,
    arpeggioGap,
    arpeggioHook,
    directionGap,
    lyricGap,
    lyricLineHeight,
    lyricFontSize,
    textFontSize,
    titleFontSize,
    subtitleFontSize,
    partNameFontSize,
    chordFontSize,
    tabFontSize,
    slurHeight,
    slurGap,
    endingHookLength,
    endingFontSize,
    tupletBracketHeight,
    barlineGap,
    measureLeftPadding,
    measureFurnitureGap,
    clefGap,
    keyGap,
    timeGap,
    clefChangeScale,
    graceNoteScale,
    cueNoteScale,
    measureNumbers,
    measuresPerSystem,
    honourSystemBreaks,
    colors,
    fonts,
    lines,
  ];

  @override
  bool operator ==(Object other) {
    if (other is! EngravingStyle) return false;
    final mine = _fields;
    final theirs = other._fields;
    for (var i = 0; i < mine.length; i++) {
      if (mine[i] != theirs[i]) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hashAll(_fields);

  /// Stands for "leave this one alone" where null is a real value.
  ///
  /// [measuresPerSystem] is null when systems are filled to the margin, which
  /// is something a caller has to be able to ask for; a plain nullable
  /// parameter cannot tell that apart from not passing one.
  static const Object _keep = Object();

  /// This style with the named fields changed.
  ///
  /// Every field is here on purpose. A style is the score's theme, and a theme
  /// people cannot adjust one piece at a time is not a theme: leaving fields
  /// out means anyone wanting a slightly wider staff has to restate all
  /// thirty-odd values, and quietly loses whatever they forget.
  EngravingStyle copyWith({
    int? staffLineCount,
    double? staffDistance,
    double? systemDistance,
    double? partDistance,
    double? systemLeftMargin,
    double? pageMargin,
    double? minimumNoteSpacing,
    double? spacingExponent,
    double? spacingWidth,
    double? stemLength,
    double? minimumStemLength,
    double? ledgerLineExtension,
    double? accidentalGap,
    double? dotGap,
    double? dotSpacing,
    double? articulationGap,
    double? arpeggioGap,
    double? arpeggioHook,
    double? directionGap,
    double? lyricGap,
    double? lyricLineHeight,
    double? lyricFontSize,
    double? textFontSize,
    double? titleFontSize,
    double? subtitleFontSize,
    double? partNameFontSize,
    double? chordFontSize,
    double? tabFontSize,
    double? endingHookLength,
    double? endingFontSize,
    double? slurHeight,
    double? slurGap,
    double? tupletBracketHeight,
    double? barlineGap,
    double? measureLeftPadding,
    double? measureFurnitureGap,
    double? clefGap,
    double? keyGap,
    double? timeGap,
    double? clefChangeScale,
    double? graceNoteScale,
    double? cueNoteScale,
    MeasureNumbering? measureNumbers,
    Object? measuresPerSystem = _keep,
    bool? honourSystemBreaks,
    NotationColors? colors,
    NotationFonts? fonts,
    EngravingDefaults? lines,
  }) => EngravingStyle(
    staffLineCount: staffLineCount ?? this.staffLineCount,
    staffDistance: staffDistance ?? this.staffDistance,
    systemDistance: systemDistance ?? this.systemDistance,
    partDistance: partDistance ?? this.partDistance,
    systemLeftMargin: systemLeftMargin ?? this.systemLeftMargin,
    pageMargin: pageMargin ?? this.pageMargin,
    minimumNoteSpacing: minimumNoteSpacing ?? this.minimumNoteSpacing,
    spacingExponent: spacingExponent ?? this.spacingExponent,
    spacingWidth: spacingWidth ?? this.spacingWidth,
    stemLength: stemLength ?? this.stemLength,
    minimumStemLength: minimumStemLength ?? this.minimumStemLength,
    ledgerLineExtension: ledgerLineExtension ?? this.ledgerLineExtension,
    accidentalGap: accidentalGap ?? this.accidentalGap,
    dotGap: dotGap ?? this.dotGap,
    dotSpacing: dotSpacing ?? this.dotSpacing,
    articulationGap: articulationGap ?? this.articulationGap,
    arpeggioGap: arpeggioGap ?? this.arpeggioGap,
    arpeggioHook: arpeggioHook ?? this.arpeggioHook,
    directionGap: directionGap ?? this.directionGap,
    lyricGap: lyricGap ?? this.lyricGap,
    lyricLineHeight: lyricLineHeight ?? this.lyricLineHeight,
    lyricFontSize: lyricFontSize ?? this.lyricFontSize,
    textFontSize: textFontSize ?? this.textFontSize,
    titleFontSize: titleFontSize ?? this.titleFontSize,
    subtitleFontSize: subtitleFontSize ?? this.subtitleFontSize,
    partNameFontSize: partNameFontSize ?? this.partNameFontSize,
    chordFontSize: chordFontSize ?? this.chordFontSize,
    tabFontSize: tabFontSize ?? this.tabFontSize,
    slurHeight: slurHeight ?? this.slurHeight,
    slurGap: slurGap ?? this.slurGap,
    tupletBracketHeight: tupletBracketHeight ?? this.tupletBracketHeight,
    endingHookLength: endingHookLength ?? this.endingHookLength,
    endingFontSize: endingFontSize ?? this.endingFontSize,
    barlineGap: barlineGap ?? this.barlineGap,
    measureLeftPadding: measureLeftPadding ?? this.measureLeftPadding,
    measureFurnitureGap: measureFurnitureGap ?? this.measureFurnitureGap,
    clefGap: clefGap ?? this.clefGap,
    keyGap: keyGap ?? this.keyGap,
    timeGap: timeGap ?? this.timeGap,
    clefChangeScale: clefChangeScale ?? this.clefChangeScale,
    graceNoteScale: graceNoteScale ?? this.graceNoteScale,
    cueNoteScale: cueNoteScale ?? this.cueNoteScale,
    measureNumbers: measureNumbers ?? this.measureNumbers,
    measuresPerSystem: measuresPerSystem == _keep
        ? this.measuresPerSystem
        : measuresPerSystem as int?,
    honourSystemBreaks: honourSystemBreaks ?? this.honourSystemBreaks,
    colors: colors ?? this.colors,
    fonts: fonts ?? this.fonts,
    lines: lines ?? this.lines,
  );
}

/// How often a measure number is printed above the staff.
///
/// Most engraved music numbers the first measure of every system, which is
/// enough for a player to find their place and little enough to stay out of
/// the way. Rehearsal-heavy parts number every fifth or tenth measure instead,
/// and a single line of melody often carries no numbers at all.
class MeasureNumbering {
  const MeasureNumbering._(
    this._kind,
    this.interval,
  );

  /// No numbers anywhere.
  static const MeasureNumbering none = MeasureNumbering._(_Numbering.none, 0);

  /// One at the start of each system.
  static const MeasureNumbering everySystem = MeasureNumbering._(
    _Numbering.system,
    0,
  );

  /// One every [measures] measures, counting from the start of the score.
  ///
  /// The first measure is never numbered — a reader knows where a piece
  /// begins — and the first measure of a system is numbered as well, so that
  /// a line never goes unlabelled.
  const MeasureNumbering.every(
    int measures,
  ) : this._(_Numbering.interval, measures);

  final _Numbering _kind;

  /// How many measures apart the numbers are, for [MeasureNumbering.every].
  final int interval;

  /// Whether the measure at [index] carries a number.
  bool showsAt({required int index, required bool startsSystem}) =>
      switch (_kind) {
        _Numbering.none => false,
        _Numbering.system => startsSystem && index > 0,
        _Numbering.interval =>
          index > 0 &&
              (startsSystem || (interval > 0 && index % interval == 0)),
      };

  @override
  bool operator ==(Object other) =>
      other is MeasureNumbering &&
      _kind == other._kind &&
      interval == other.interval;

  @override
  int get hashCode => Object.hash(_kind, interval);
}

enum _Numbering { none, system, interval }

/// The typefaces the writing around the notes is set in.
///
/// The notes themselves are not here: they are drawn from the SMuFL font given
/// to the layout — [SmuflFont] and its siblings — because the glyphs
/// and the measurements that space them have to come from the same file. Give
/// a different [SmuflFont] to change the music; these change everything else.
///
/// A null family means the platform default, which is what most scores want
/// for lyrics and is always what a name falls back to when the font named is
/// not there.
class NotationFonts {
  const NotationFonts({
    this.lyrics,
    this.chords,
    this.text,
  });

  /// A family for every kind of writing at once.
  const NotationFonts.all(
    String? family,
  ) : lyrics = family,
      chords = family,
      text = family;

  /// The syllables under the staff.
  ///
  /// Usually a serif face, and usually not the one the titles are set in: a
  /// lyric is read as running text and a tempo mark is read as a label.
  final String? lyrics;

  /// The chord symbols above the staff.
  ///
  /// Usually a sans face, and usually not the one the lyrics are set in: a
  /// chart is read at a glance and a lyric is read as running text.
  final String? chords;

  /// Dynamics, tempo marks, words, part names, titles and measure numbers.
  final String? text;

  /// The family for text drawn as [role].
  String? familyFor(ElementRole role) => switch (role) {
    ElementRole.lyric => lyrics,
    ElementRole.chordSymbol => chords,
    _ => text,
  };

  NotationFonts copyWith({String? lyrics, String? chords, String? text}) =>
      NotationFonts(
        lyrics: lyrics ?? this.lyrics,
        chords: chords ?? this.chords,
        text: text ?? this.text,
      );

  @override
  bool operator ==(Object other) =>
      other is NotationFonts &&
      lyrics == other.lyrics &&
      chords == other.chords &&
      text == other.text;

  @override
  int get hashCode => Object.hash(lyrics, chords, text);
}

/// The colours a score is drawn in.
///
/// Kept as plain [Color]s rather than tied to a Flutter theme so that the
/// layout and painting code stays usable outside a widget tree — printing a
/// PDF, rendering to an image on a server.
///
/// [ink] and [background] are independent of each other on purpose. A palette
/// is not a light one or a dark one; it is whatever pair someone chose, and
/// taking [dark] and changing only its background is a fair thing to want to
/// do — so every colour here can be replaced on its own, and every one of them
/// reaches [copyWith].
class NotationColors {
  const NotationColors({
    this.ink = const Color(0xFF1A1A1A),
    this.staffLines = const Color(0xFF444444),
    this.selection = const Color(0xFF1E6FE0),
    this.selectionFill = const Color(0x221E6FE0),
    this.hover = const Color(0x331E6FE0),
    this.cursor = const Color(0xFFE05A1E),
    this.editorial = const Color(0xFF7A7A7A),
    this.background = const Color(0xFFFFFFFF),
    this.voices = const {},
    this.honourSourceColors = true,
  });

  /// A palette that reads on a dark background.
  static const NotationColors dark = NotationColors(
    ink: Color(0xFFE8E8E8),
    staffLines: Color(0xFFAAAAAA),
    selection: Color(0xFF6FB4FF),
    selectionFill: Color(0x336FB4FF),
    hover: Color(0x226FB4FF),
    cursor: Color(0xFFFFA366),
    editorial: Color(0xFF9A9A9A),
    background: Color(0xFF15171A),
  );

  /// Notes, stems, beams and text.
  final Color ink;

  final Color staffLines;

  /// Outline drawn around a selected item.
  final Color selection;

  /// Wash drawn behind a selected item.
  final Color selectionFill;

  final Color hover;

  /// The note-entry caret.
  final Color cursor;

  /// Editorial and cautionary marks.
  final Color editorial;

  final Color background;

  /// A colour for particular voices, by voice number.
  ///
  /// Two voices sharing a staff are told apart by their stems, which takes
  /// reading; colouring them apart takes none, and is how anyone following one
  /// line of a fugue or one hand of a keyboard part wants to see it. A voice
  /// not named here is drawn in [ink], which is the usual case — this is empty
  /// unless someone asks for it.
  final Map<int, Color> voices;

  /// Whether a colour written into the file itself is used.
  ///
  /// MusicXML lets a note carry its own colour, and exporters write one far
  /// more often than anyone means to look at it — usually plain black. On a
  /// dark background that black is invisible, and no amount of choosing a
  /// palette fixes it, because the file is being obeyed rather than the
  /// palette. Turn this off to have the document's colours ignored and the
  /// palette followed everywhere.
  final bool honourSourceColors;

  /// The colour for an event in [voice], or null to leave it to the usual ink.
  Color? forVoice(int voice) => voices[voice];

  @override
  bool operator ==(Object other) =>
      other is NotationColors &&
      ink == other.ink &&
      staffLines == other.staffLines &&
      selection == other.selection &&
      selectionFill == other.selectionFill &&
      hover == other.hover &&
      cursor == other.cursor &&
      editorial == other.editorial &&
      background == other.background &&
      honourSourceColors == other.honourSourceColors &&
      _sameVoices(voices, other.voices);

  static bool _sameVoices(Map<int, Color> a, Map<int, Color> b) {
    if (a.length != b.length) return false;
    for (final entry in a.entries) {
      if (b[entry.key] != entry.value) return false;
    }
    return true;
  }

  @override
  int get hashCode => Object.hash(
    ink,
    staffLines,
    selection,
    selectionFill,
    hover,
    cursor,
    editorial,
    background,
    honourSourceColors,
    Object.hashAllUnordered([
      for (final entry in voices.entries) Object.hash(entry.key, entry.value),
    ]),
  );

  NotationColors copyWith({
    Color? ink,
    Color? staffLines,
    Color? selection,
    Color? selectionFill,
    Color? hover,
    Color? cursor,
    Color? editorial,
    Color? background,
    Map<int, Color>? voices,
    bool? honourSourceColors,
  }) => NotationColors(
    ink: ink ?? this.ink,
    staffLines: staffLines ?? this.staffLines,
    selection: selection ?? this.selection,
    selectionFill: selectionFill ?? this.selectionFill,
    hover: hover ?? this.hover,
    cursor: cursor ?? this.cursor,
    editorial: editorial ?? this.editorial,
    background: background ?? this.background,
    voices: voices ?? this.voices,
    honourSourceColors: honourSourceColors ?? this.honourSourceColors,
  );
}
