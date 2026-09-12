import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/theory/fraction.dart';
import 'package:songbird_score/src/theory/pitch.dart';

/// The quality of a chord, as MusicXML names it.
///
/// The [suffix] is what an English-language chord chart prints after the root
/// letter. A file may say something different in its own words, and when it
/// does [Harmony.text] is used instead — this is the fallback for a file that
/// only names the kind.
enum ChordKind {
  major('major', ''),
  minor('minor', 'm'),
  augmented('augmented', '+'),
  diminished('diminished', 'dim'),
  dominant('dominant', '7'),
  majorSeventh('major-seventh', 'maj7'),
  minorSeventh('minor-seventh', 'm7'),
  diminishedSeventh('diminished-seventh', 'dim7'),
  augmentedSeventh('augmented-seventh', '+7'),
  halfDiminished('half-diminished', 'm7b5'),
  majorMinor('major-minor', 'mMaj7'),
  majorSixth('major-sixth', '6'),
  minorSixth('minor-sixth', 'm6'),
  dominantNinth('dominant-ninth', '9'),
  majorNinth('major-ninth', 'maj9'),
  minorNinth('minor-ninth', 'm9'),
  dominantEleventh('dominant-11th', '11'),
  majorEleventh('major-11th', 'maj11'),
  minorEleventh('minor-11th', 'm11'),
  dominantThirteenth('dominant-13th', '13'),
  majorThirteenth('major-13th', 'maj13'),
  minorThirteenth('minor-13th', 'm13'),
  suspendedSecond('suspended-second', 'sus2'),
  suspendedFourth('suspended-fourth', 'sus4'),
  power('power', '5'),
  neapolitan('Neapolitan', 'N'),
  italian('Italian', 'It'),
  french('French', 'Fr'),
  german('German', 'Ger'),
  pedal('pedal', 'ped'),
  tristan('Tristan', 'Tr'),
  other('other', ''),
  none('none', '');

  const ChordKind(
    this.xmlName,
    this.suffix,
  );

  /// The value MusicXML writes in a `<kind>` element.
  final String xmlName;

  /// What is printed after the root letter.
  final String suffix;

  /// The kind a typed suffix means, or `null` when nothing recognises it.
  ///
  /// Charts are not consistent — `m7`, `min7` and `-7` are the same chord —
  /// so the spellings people actually type are accepted alongside the one
  /// this library prints.
  static ChordKind? fromSuffix(String suffix) {
    final trimmed = suffix.trim();
    for (final entry in _suffixAliases.entries) {
      if (entry.key == trimmed) return entry.value;
    }
    for (final kind in ChordKind.values) {
      if (kind.suffix == trimmed && kind != ChordKind.other) return kind;
    }
    return null;
  }

  static ChordKind fromXmlName(String? name) {
    for (final kind in ChordKind.values) {
      if (kind.xmlName == name) return kind;
    }
    return ChordKind.other;
  }
}

/// Spellings of a chord quality that are not the one [ChordKind.suffix]
/// prints, mapped to what they mean.
const Map<String, ChordKind> _suffixAliases = {
  'M': ChordKind.major,
  'maj': ChordKind.major,
  'min': ChordKind.minor,
  '-': ChordKind.minor,
  'aug': ChordKind.augmented,
  'o': ChordKind.diminished,
  'd': ChordKind.diminished,
  'M7': ChordKind.majorSeventh,
  'Ma7': ChordKind.majorSeventh,
  'maj7': ChordKind.majorSeventh,
  'min7': ChordKind.minorSeventh,
  '-7': ChordKind.minorSeventh,
  'o7': ChordKind.diminishedSeventh,
  'dim7': ChordKind.diminishedSeventh,
  'm7-5': ChordKind.halfDiminished,
  'ø': ChordKind.halfDiminished,
  'ø7': ChordKind.halfDiminished,
  'mMaj7': ChordKind.majorMinor,
  'mM7': ChordKind.majorMinor,
  'sus': ChordKind.suspendedFourth,
  'min9': ChordKind.minorNinth,
  '-9': ChordKind.minorNinth,
  'min11': ChordKind.minorEleventh,
  'min13': ChordKind.minorThirteenth,
};

/// A chord symbol printed above the staff.
///
/// It takes no time of its own — it names the harmony from where it stands
/// until the next one — so it is an event at a position rather than something
/// with a duration, like a [Direction].
///
/// The root and the bass are carried as [Pitch]es so that transposing a part
/// moves its chord symbols with the notes; only their step and alteration are
/// printed, and the octave is not used.
class Harmony extends MusicalEvent {
  Harmony({
    required super.position,
    required this.root,
    this.kind = ChordKind.major,
    this.text,
    this.bass,
    super.voice,
    super.staff,
  });

  /// Reads a chord symbol the way it is typed on a chart.
  ///
  /// `C`, `F#m7`, `Bb`, `Am`, `Cmaj7/E`, `G/B`. Returns `null` for anything
  /// that does not start with a note letter, which is how a text field tells
  /// a typo from a chord.
  ///
  /// A quality this library does not know is kept verbatim in [text] and the
  /// symbol prints exactly as typed, so an unusual chart is not flattened into
  /// the nearest thing in [ChordKind].
  static Harmony? parseSymbol(
    String source, {
    required Fraction position,
    int voice = 1,
    int staff = 1,
  }) {
    final text = source.trim();
    if (text.isEmpty) return null;

    // The bass comes after the last slash, so that a quality containing one
    // would still leave the bass findable.
    final slash = text.lastIndexOf('/');
    final head = slash < 0 ? text : text.substring(0, slash);
    final tail = slash < 0 ? null : text.substring(slash + 1).trim();

    final root = _parseRoot(head);
    if (root == null) return null;
    final bass = tail == null || tail.isEmpty ? null : _parseRoot(tail);
    if (tail != null && bass == null) return null;

    final suffix = head.substring(root.length);
    final kind = ChordKind.fromSuffix(suffix);
    return Harmony(
      position: position,
      root: root.pitch,
      kind: kind ?? ChordKind.other,
      // A recognised quality prints in this library's own spelling; anything
      // else prints as the user wrote it.
      text: kind == null && suffix.isNotEmpty ? suffix : null,
      bass: bass?.pitch,
      voice: voice,
      staff: staff,
    );
  }

  /// Reads a note letter and its accidentals off the front of [source].
  ///
  /// The octave is not part of a chord symbol, so the pitch gets a nominal
  /// one; only the step and the alteration are ever printed.
  static ({Pitch pitch, int length})? _parseRoot(String source) {
    if (source.isEmpty) return null;
    final letter = source[0].toUpperCase();
    if (letter.codeUnitAt(0) < 0x41 || letter.codeUnitAt(0) > 0x47) return null;

    var length = 1;
    var alter = 0.0;
    loop:
    while (length < source.length) {
      switch (source[length]) {
        case '#' || '\u266f':
          alter += 1;
        case 'b' || '\u266d':
          alter -= 1;
        case 'x' || '\u{1D12A}':
          alter += 2;
        default:
          break loop;
      }
      length++;
    }

    // `Bb` is B flat, but `Bbm` could be read as B, flat, minor either way;
    // both readings agree. `Cb` is likewise unambiguous. Nothing more is
    // needed because a chord quality never starts with one of these.
    return (
      pitch: Pitch(Step.fromName(letter), 4, alter: alter),
      length: length,
    );
  }

  /// The letter the symbol is built on, with any sharp or flat.
  Pitch root;

  /// The quality of the chord.
  ChordKind kind;

  /// What the file asked to have printed after the root, if it said.
  ///
  /// A chart may want "min7" where another wants "m7", and neither is more
  /// right; when a file states one, that is what is printed.
  String? text;

  /// The note in the bass, for a chord written over one — the B of `G/B`.
  Pitch? bass;

  /// What is printed after the root letter.
  String get suffix => text ?? kind.suffix;

  /// The whole symbol as it is printed and as [parseSymbol] would read it
  /// back: root, quality, and a bass note after a slash.
  String get symbol {
    final buffer = StringBuffer()
      ..write(root.step.name)
      ..write(_alterationText(root.alter))
      ..write(suffix);
    final bass = this.bass;
    if (bass != null) {
      buffer
        ..write('/')
        ..write(bass.step.name)
        ..write(_alterationText(bass.alter));
    }
    return buffer.toString();
  }

  @override
  Fraction get duration => Fraction.zero;

  @override
  Harmony copy() => Harmony(
    position: position,
    root: root,
    kind: kind,
    text: text,
    bass: bass,
    voice: voice,
    staff: staff,
  );
}

/// Sharps and flats as a chord chart writes them.
String _alterationText(double alter) {
  if (alter == 0) return '';
  final whole = alter.round();
  if (whole != alter) return alter > 0 ? '+' : '-';
  return (whole > 0 ? '#' : 'b') * whole.abs();
}
