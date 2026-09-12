import 'package:songbird_score/src/model/notations.dart';
import 'package:songbird_score/src/theory/duration.dart';
import 'package:songbird_score/src/theory/fraction.dart';
import 'package:songbird_score/src/theory/interval.dart';
import 'package:songbird_score/src/theory/pitch.dart';

/// Anything that occupies a point in time inside a measure.
///
/// Positions are absolute within the measure rather than implied by document
/// order, so that voices, backups and cross-staff writing are all expressed the
/// same way. MusicXML's `<backup>`/`<forward>` cursor is resolved into these
/// positions on import and reconstructed on export.
///
/// Left open rather than sealed so a host application can add its own event
/// kinds — a chord-symbol lane, an analysis marker — without forking the model.
abstract class MusicalEvent {
  MusicalEvent({
    required this.position,
    this.voice = 1,
    this.staff = 1,
  });

  /// Offset from the start of the measure, in whole notes.
  Fraction position;

  /// The independent musical line this event belongs to.
  int voice;

  /// Which staff of the part it is written on, counting from 1 at the top.
  int staff;

  /// How long it occupies, in whole notes. Zero for events that take no time.
  Fraction get duration;

  /// The point just after this event.
  Fraction get endPosition => position + duration;

  /// A deep copy, used by the undo stack and by copy/paste.
  MusicalEvent copy();
}

/// A single notehead. One or more of these make up a [Chord].
class Note {
  Note({
    this.pitch,
    this.unpitchedPosition,
    this.accidental,
    this.tie = TieState.none,
    this.notehead,
    this.notehead2,
    this.filledNotehead,
    this.tied = false,
    this.instrumentId,
    this.color,
    this.string,
    this.fret,
    this.printObject = true,
    this.printSpacing = true,
  });

  /// The sounding pitch, or `null` for an unpitched percussion note.
  Pitch? pitch;

  /// Where an unpitched note is drawn, as the pitch of that staff position.
  Pitch? unpitchedPosition;

  /// The accidental to print, if any. Independent of [pitch]'s alteration:
  /// a note can be altered by the key signature without printing anything.
  Accidental? accidental;

  /// Whether this notehead starts or ends a tie.
  TieState tie;

  /// An explicit notehead shape overriding the default for the note value.
  NoteheadShape? notehead;

  /// The second notehead shape for a double-stemmed note.
  NoteheadShape? notehead2;

  /// Overrides whether the notehead is drawn filled.
  bool? filledNotehead;

  /// True when a tie is actually drawn, as opposed to only sounding.
  bool tied;

  /// The instrument sounding this note, for multi-instrument parts.
  String? instrumentId;

  /// A colour override, as `#RRGGBB` or `#AARRGGBB`.
  String? color;

  /// Which string the note is played on, counted from the highest, and where
  /// it is stopped. What a tablature staff is written from: the string says
  /// which line the number goes on, and the fret is the number.
  int? string;
  int? fret;

  /// Whether the notehead is printed at all.
  ///
  /// A file may write music that is played but not seen: the realisation of a
  /// drum roll, an ossia's cue, a voice kept for playback. It is still music —
  /// it sounds, it can be edited, it is written back out — and it is simply
  /// not drawn.
  bool printObject;

  /// Whether an unprinted note still takes its room on the page.
  ///
  /// The default, so that hidden music keeps the visible music above it in
  /// line. Turned off, the note takes no space at all, which is how a roll
  /// spelled out note by note is laid under the single note that shows it.
  bool printSpacing;

  /// The staff position this note is drawn at, whether pitched or not.
  Pitch? get displayPitch => pitch ?? unpitchedPosition;

  bool get isUnpitched => pitch == null && unpitchedPosition != null;

  /// This note moved by [interval], keeping its printed accidental in step.
  void transpose(Interval interval, {bool respellAccidental = true}) {
    final current = pitch;
    if (current == null) return;
    // Simplifying keeps repeated transposition readable: without it, four
    // steps up a semitone spells C as C quadruple sharp.
    final result = interval.transpose(current).simplified;
    pitch = result;
    if (respellAccidental && accidental != null) {
      final replacement = AccidentalType.forAlteration(result.alter);
      if (replacement != null) {
        accidental = accidental!.copyWith(type: replacement);
      }
    }
  }

  Note copy() => Note(
    pitch: pitch,
    unpitchedPosition: unpitchedPosition,
    accidental: accidental,
    tie: tie,
    notehead: notehead,
    notehead2: notehead2,
    filledNotehead: filledNotehead,
    tied: tied,
    instrumentId: instrumentId,
    color: color,
  );

  @override
  String toString() => 'Note(${pitch ?? 'unpitched'})';
}

/// How a grace note relates to the note it decorates.
class GraceInfo {
  const GraceInfo({
    this.slash = false,
    this.stealTimePrevious,
    this.stealTimeFollowing,
    this.makeTime,
  });

  /// An acciaccatura, drawn with a stroke through the flag.
  final bool slash;

  /// Percentage of the previous note's time this grace note takes.
  final double? stealTimePrevious;

  /// Percentage of the following note's time this grace note takes.
  final double? stealTimeFollowing;

  /// Extra time added to the measure for this grace note, in divisions.
  final double? makeTime;
}

/// One or more noteheads sharing a stem and a written duration.
///
/// A single note is a chord of one. Collapsing the two cases means beaming,
/// stem direction and spacing all have one thing to reason about.
class Chord extends MusicalEvent {
  Chord({
    required super.position,
    required this.notes,
    required this.rhythm,
    super.voice,
    super.staff,
    this.stem = StemDirection.none,
    this.beams = const [],
    this.articulations = const [],
    this.ornaments = const [],
    this.technicals = const [],
    this.lyrics = const [],
    this.fermatas = const [],
    this.tremolo,
    this.grace,
    this.cue = false,
    this.arpeggiate = false,
    this.nonArpeggiate = false,
  });

  /// The noteheads, in no guaranteed order; [sortedNotes] gives them low to
  /// high.
  List<Note> notes;

  /// The written duration shared by every notehead.
  RhythmicDuration rhythm;

  /// The stem direction, or [StemDirection.none] to let layout decide.
  StemDirection stem;

  /// Beams by level, empty for an unbeamed note.
  List<Beam> beams;

  List<Articulation> articulations;
  List<Ornament> ornaments;
  List<Technical> technicals;
  List<Lyric> lyrics;
  List<Fermata> fermatas;
  Tremolo? tremolo;

  /// Set when this is a grace note, which takes no time of its own.
  GraceInfo? grace;

  /// A cue-sized note.
  bool cue;

  bool arpeggiate;
  bool nonArpeggiate;

  bool get isGrace => grace != null;

  @override
  Fraction get duration => isGrace ? Fraction.zero : rhythm.value;

  /// Whether anything of this chord is drawn.
  ///
  /// False for a chord whose every notehead is hidden: there is then no stem,
  /// no flag and no beam either, since there is nothing for them to hang from.
  bool get isPrinted => notes.any((note) => note.printObject);

  /// Whether the chord takes room on the page, printed or not.
  bool get takesSpace =>
      notes.any((note) => note.printObject || note.printSpacing);

  /// The noteheads ordered from the lowest sounding pitch upwards.
  List<Note> get sortedNotes {
    final result = [...notes];
    result.sort((a, b) {
      final ap = a.displayPitch;
      final bp = b.displayPitch;
      if (ap == null || bp == null) return 0;
      return ap.compareTo(bp);
    });
    return result;
  }

  Note? get lowestNote => sortedNotes.isEmpty ? null : sortedNotes.first;
  Note? get highestNote => sortedNotes.isEmpty ? null : sortedNotes.last;

  bool get isBeamed => beams.isNotEmpty;

  void transpose(Interval interval, {bool respellAccidental = true}) {
    for (final note in notes) {
      note.transpose(interval, respellAccidental: respellAccidental);
    }
  }

  @override
  Chord copy() => Chord(
    position: position,
    notes: [for (final n in notes) n.copy()],
    rhythm: rhythm,
    voice: voice,
    staff: staff,
    stem: stem,
    beams: [...beams],
    articulations: [...articulations],
    ornaments: [...ornaments],
    technicals: [...technicals],
    lyrics: [for (final l in lyrics) l.copy()],
    fermatas: [...fermatas],
    tremolo: tremolo,
    grace: grace,
    cue: cue,
    arpeggiate: arpeggiate,
    nonArpeggiate: nonArpeggiate,
  );

  @override
  String toString() =>
      'Chord(@$position, ${notes.map((n) => n.pitch).join(' ')}, $rhythm)';
}

/// A silence occupying time in a voice.
class Rest extends MusicalEvent {
  Rest({
    required super.position,
    required this.rhythm,
    super.voice,
    super.staff,
    this.isMeasureRest = false,
    this.displayPitch,
    this.measureDuration,
    this.fermatas = const [],
    this.cue = false,
    this.printObject = true,
    this.printSpacing = true,
  });

  /// A whole-measure rest, which is centred and drawn as a whole rest whatever
  /// the time signature.
  factory Rest.wholeMeasure({
    required Fraction measureDuration,
    int voice = 1,
    int staff = 1,
  }) => Rest(
    position: Fraction.zero,
    rhythm: const RhythmicDuration(NoteType.whole),
    voice: voice,
    staff: staff,
    isMeasureRest: true,
    measureDuration: measureDuration,
  );

  RhythmicDuration rhythm;

  /// True for a rest that fills the whole measure regardless of its written
  /// value.
  bool isMeasureRest;

  /// An explicit vertical position for the rest, overriding the default.
  Pitch? displayPitch;

  /// For a measure rest, how long the measure actually is.
  Fraction? measureDuration;

  List<Fermata> fermatas;
  bool cue;

  /// Whether the rest is drawn, and whether it takes room when it is not.
  /// See [Note.printObject] and [Note.printSpacing].
  bool printObject;
  bool printSpacing;

  @override
  Fraction get duration =>
      isMeasureRest ? (measureDuration ?? rhythm.value) : rhythm.value;

  @override
  Rest copy() => Rest(
    position: position,
    rhythm: rhythm,
    voice: voice,
    staff: staff,
    isMeasureRest: isMeasureRest,
    displayPitch: displayPitch,
    measureDuration: measureDuration,
    fermatas: [...fermatas],
    cue: cue,
  );

  @override
  String toString() => 'Rest(@$position, $rhythm)';
}
