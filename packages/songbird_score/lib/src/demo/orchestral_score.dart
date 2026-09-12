import 'dart:math';

import 'package:songbird_score/songbird_score.dart';

/// One line of the generated orchestra.
class OrchestralInstrument {
  const OrchestralInstrument(
    this.name,
    this.abbreviation, {
    required this.clefs,
    required this.centre,
    this.range = 12,
    this.sings = false,
  });

  final String name;
  final String abbreviation;

  /// The clef of each staff, so a piano or a harp is two staves deep.
  final List<Clef> clefs;

  /// The diatonic value the part's writing sits around.
  final int centre;

  /// How far above and below [centre] it wanders.
  final int range;

  /// True for a choral part, which carries a syllable under every note.
  final bool sings;
}

/// A full symphony orchestra with chorus: the shape of score this library has
/// to stay quick on, and the one that puts the most in a single system.
///
/// Diatonic values are [Pitch.diatonicValue]s, so 28 is C4.
const fullOrchestra = <OrchestralInstrument>[
  OrchestralInstrument('Piccolo', 'Picc.', clefs: [Clef.treble], centre: 42),
  OrchestralInstrument('Flute 1', 'Fl. 1', clefs: [Clef.treble], centre: 37),
  OrchestralInstrument('Flute 2', 'Fl. 2', clefs: [Clef.treble], centre: 36),
  OrchestralInstrument('Oboe 1', 'Ob. 1', clefs: [Clef.treble], centre: 35),
  OrchestralInstrument('Oboe 2', 'Ob. 2', clefs: [Clef.treble], centre: 34),
  OrchestralInstrument(
    'Clarinet in B♭ 1',
    'Cl. 1',
    clefs: [Clef.treble],
    centre: 33,
  ),
  OrchestralInstrument(
    'Clarinet in B♭ 2',
    'Cl. 2',
    clefs: [Clef.treble],
    centre: 32,
  ),
  OrchestralInstrument(
    'Bass Clarinet',
    'B. Cl.',
    clefs: [Clef.treble],
    centre: 28,
  ),
  OrchestralInstrument('Bassoon 1', 'Bsn. 1', clefs: [Clef.bass], centre: 24),
  OrchestralInstrument('Bassoon 2', 'Bsn. 2', clefs: [Clef.bass], centre: 22),
  OrchestralInstrument(
    'Contrabassoon',
    'Cbsn.',
    clefs: [Clef.bass],
    centre: 17,
  ),
  OrchestralInstrument(
    'Horn in F 1',
    'Hn. 1',
    clefs: [Clef.treble],
    centre: 31,
  ),
  OrchestralInstrument(
    'Horn in F 2',
    'Hn. 2',
    clefs: [Clef.treble],
    centre: 30,
  ),
  OrchestralInstrument(
    'Horn in F 3',
    'Hn. 3',
    clefs: [Clef.treble],
    centre: 29,
  ),
  OrchestralInstrument(
    'Horn in F 4',
    'Hn. 4',
    clefs: [Clef.treble],
    centre: 28,
  ),
  OrchestralInstrument(
    'Trumpet in C 1',
    'Tpt. 1',
    clefs: [Clef.treble],
    centre: 35,
  ),
  OrchestralInstrument(
    'Trumpet in C 2',
    'Tpt. 2',
    clefs: [Clef.treble],
    centre: 34,
  ),
  OrchestralInstrument('Trombone 1', 'Tbn. 1', clefs: [Clef.tenor], centre: 26),
  OrchestralInstrument('Trombone 2', 'Tbn. 2', clefs: [Clef.bass], centre: 24),
  OrchestralInstrument(
    'Bass Trombone',
    'B. Tbn.',
    clefs: [Clef.bass],
    centre: 20,
  ),
  OrchestralInstrument('Tuba', 'Tba.', clefs: [Clef.bass], centre: 17),
  OrchestralInstrument(
    'Timpani',
    'Timp.',
    clefs: [Clef.bass],
    centre: 21,
    range: 7,
  ),
  OrchestralInstrument(
    'Harp',
    'Hp.',
    clefs: [Clef.treble, Clef.bass],
    centre: 31,
  ),
  OrchestralInstrument(
    'Piano',
    'Pno.',
    clefs: [Clef.treble, Clef.bass],
    centre: 31,
  ),
  OrchestralInstrument(
    'Soprano',
    'S.',
    clefs: [Clef.treble],
    centre: 35,
    sings: true,
  ),
  OrchestralInstrument(
    'Alto',
    'A.',
    clefs: [Clef.treble],
    centre: 31,
    sings: true,
  ),
  OrchestralInstrument(
    'Tenor',
    'T.',
    clefs: [Clef.trebleOctaveDown],
    centre: 28,
    sings: true,
  ),
  OrchestralInstrument(
    'Bass',
    'B.',
    clefs: [Clef.bass],
    centre: 22,
    sings: true,
  ),
  OrchestralInstrument(
    'Violin I',
    'Vln. I',
    clefs: [Clef.treble],
    centre: 36,
    range: 16,
  ),
  OrchestralInstrument(
    'Violin II',
    'Vln. II',
    clefs: [Clef.treble],
    centre: 33,
    range: 16,
  ),
  OrchestralInstrument('Viola', 'Vla.', clefs: [Clef.alto], centre: 29),
  OrchestralInstrument('Violoncello', 'Vc.', clefs: [Clef.bass], centre: 24),
  OrchestralInstrument('Contrabass', 'Cb.', clefs: [Clef.bass], centre: 17),
];

/// Where each section of the orchestra begins, by the name of its first
/// instrument.
///
/// A score is read section by section — the woodwinds together, the brass
/// together — and the bracket down the left of each is what says so.
const _sectionStarts = <String, String>{
  'Piccolo': 'Woodwinds',
  'Horn in F 1': 'Brass',
  'Timpani': 'Percussion',
  'Harp': 'Keyboards',
  'Soprano': 'Chorus',
  'Violin I': 'Strings',
};

/// A bracket around each section of the orchestra present in [instruments].
List<PartGroup> _sectionsOf(List<OrchestralInstrument> instruments) {
  final groups = <PartGroup>[];
  var start = -1;
  String? name;
  for (var i = 0; i < instruments.length; i++) {
    final section = _sectionStarts[instruments[i].name];
    if (section == null) continue;
    if (start >= 0 && i - 1 >= start) {
      groups.add(_section(name!, start, i - 1));
    }
    start = i;
    name = section;
  }
  if (start >= 0 && instruments.length - 1 >= start) {
    groups.add(_section(name!, start, instruments.length - 1));
  }
  return groups;
}

PartGroup _section(String name, int start, int end) => PartGroup(
  number: name,
  startPartIndex: start,
  endPartIndex: end,
  name: name,
  // A section of one instrument — a lone tuba — reads perfectly well without
  // a bracket round it, and a bracket round one staff looks like a mistake.
  symbol: start == end ? GroupSymbol.none : GroupSymbol.bracket,
);

/// The rhythms a measure is filled with, as note types sharing 4/4.
const _patterns = <List<NoteType>>[
  [NoteType.whole],
  [NoteType.half, NoteType.half],
  [NoteType.quarter, NoteType.quarter, NoteType.half],
  [NoteType.quarter, NoteType.eighth, NoteType.eighth, NoteType.half],
  [
    NoteType.eighth,
    NoteType.eighth,
    NoteType.eighth,
    NoteType.eighth,
    NoteType.quarter,
    NoteType.quarter,
  ],
  [
    NoteType.sixteenth,
    NoteType.sixteenth,
    NoteType.sixteenth,
    NoteType.sixteenth,
    NoteType.eighth,
    NoteType.eighth,
    NoteType.half,
  ],
  [NoteType.half, NoteType.quarter, NoteType.eighth, NoteType.eighth],
];

const _syllables = [
  'Glo',
  'ri',
  'a',
  'in',
  'ex',
  'cel',
  'sis',
  'De',
  'o',
  'et',
  'in',
  'ter',
  'ra',
  'pax',
  'ho',
  'mi',
  'ni',
  'bus',
];

/// Builds a score of [measures] measures for [instruments].
///
/// The music is arbitrary but deterministic, and deliberately dense: every
/// part plays in every measure, with beams, accidentals, slurs, ties, dynamics
/// and — for the chorus — a syllable under every note. A score that lays out
/// quickly here will lay out quickly for anything real.
Score buildOrchestralScore({
  int measures = 64,
  List<OrchestralInstrument> instruments = fullOrchestra,
  int seed = 20260909,
}) {
  final random = Random(seed);
  final parts = <Part>[];

  for (var p = 0; p < instruments.length; p++) {
    final instrument = instruments[p];
    final part = Part(
      id: 'P${p + 1}',
      name: instrument.name,
      abbreviation: instrument.abbreviation,
    );

    for (var m = 0; m < measures; m++) {
      final measure = Measure(number: '${m + 1}');
      if (m == 0) {
        measure.attributes
          ..divisions = 4
          ..staves = instrument.clefs.length
          ..time = TimeSignature.simple(4, 4)
          ..keys[allStaves] = const KeySignature(fifths: 3);
        for (var s = 0; s < instrument.clefs.length; s++) {
          measure.attributes.clefs[s + 1] = instrument.clefs[s];
        }
      } else if (m % 24 == 0) {
        // A key change every so often, which forces a fresh accidental
        // resolution and a wider measure.
        measure.attributes.keys[allStaves] = KeySignature(
          fifths: 3 - (m ~/ 24) % 5,
        );
      }

      for (var staff = 1; staff <= instrument.clefs.length; staff++) {
        _fillStaff(
          measure,
          instrument: instrument,
          staff: staff,
          part: part,
          random: random,
        );
      }

      if (m % 8 == 0) {
        measure.add(
          Direction(
            position: Fraction.zero,
            types: const [
              DynamicsDirection([DynamicMark.mf]),
            ],
          ),
        );
      }
      if (m % 16 == 15) {
        measure.rightBarline = Barline(
          style: BarStyle.lightHeavy,
          repeat: const Repeat(direction: RepeatDirection.backward),
        );
      }
      part.measures.add(measure);
    }
    // Music ends on a double bar, and a score that stops on a plain one reads
    // as though the page had been torn off.
    part.measures.last.rightBarline = Barline(style: BarStyle.lightHeavy);
    parts.add(part);
  }

  final score = Score(parts: parts, partGroups: _sectionsOf(instruments))
    ..metadata.movementTitle = 'Sinfonia';

  // The same preparation a reader does after parsing: beams, stem directions
  // and printed accidentals.
  for (final part in score.parts) {
    for (var i = 0; i < part.measures.length; i++) {
      final context = part.contextAtMeasure(i);
      Beaming.applyTo(part.measures[i], time: context.time);
      for (var staff = 1; staff <= context.staffCount; staff++) {
        Beaming.applyStemDirections(
          part.measures[i],
          clef: context.clefFor(staff),
        );
      }
      AccidentalResolver.applyTo(part.measures[i], context: context);
    }
  }
  return score;
}

void _fillStaff(
  Measure measure, {
  required OrchestralInstrument instrument,
  required int staff,
  required Part part,
  required Random random,
}) {
  final pattern = _patterns[random.nextInt(_patterns.length)];
  var position = Fraction.zero;
  final written = <Chord>[];

  for (var i = 0; i < pattern.length; i++) {
    final type = pattern[i];
    final duration = type.baseValue;
    final centre = instrument.centre - (staff - 1) * 7;
    final diatonic =
        centre + random.nextInt(instrument.range) - instrument.range ~/ 2;
    final chord = Chord(
      position: position,
      staff: staff,
      notes: [
        Note(
          pitch: Pitch(
            Step.fromDiatonicIndex(diatonic % 7),
            (diatonic / 7).floor(),
            // An occasional chromatic note, so accidentals have to be drawn
            // and spaced.
            alter: random.nextInt(6) == 0 ? -1 : 0,
          ),
        ),
      ],
      rhythm: RhythmicDuration(type),
      lyrics: instrument.sings
          ? [Lyric(text: _syllables[random.nextInt(_syllables.length)])]
          : const [],
    );
    measure.add(chord);
    written.add(chord);
    position += duration;
  }

  // A slur over the first half of the measure, and a tie where two neighbours
  // happen to share a pitch.
  if (written.length > 2) {
    part.spanners.add(Slur(start: written.first, end: written[1]));
  }
  for (var i = 0; i + 1 < written.length; i++) {
    final a = written[i].notes.first;
    final b = written[i + 1].notes.first;
    if (a.pitch == b.pitch) {
      a
        ..tie = TieState.start
        ..tied = true;
      b
        ..tie = TieState.stop
        ..tied = true;
      part.spanners.add(
        Tie(
          start: written[i],
          end: written[i + 1],
          startNoteIndex: 0,
          endNoteIndex: 0,
        ),
      );
    }
  }
}
