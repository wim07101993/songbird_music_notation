import 'package:songbird_score/songbird_score.dart';

/// A short score built to exercise the awkward parts of engraving.
///
/// Fixtures of real music are good for checking that ordinary notes come out
/// right, and useless for the rest: the marks that go wrong are the ones that
/// have to find a height of their own — a clef that is not a treble clef, a
/// hairpin under a keyboard part, the dots of a repeat. This puts one of each
/// on the page, in a few measures, so that a look at it says whether they are
/// where they belong.
///
/// It is generated rather than kept as a file so that it can say plainly what
/// it is testing, and so that adding a case is a line of Dart rather than
/// thirty lines of XML.
Score buildShowcaseScore() {
  final voice = Part(id: 'P1', name: 'Voice', abbreviation: 'V.');
  final viola = Part(id: 'P2', name: 'Viola', abbreviation: 'Vla.');
  final piano = Part(id: 'P3', name: 'Piano', abbreviation: 'Pno.');

  _buildVoice(voice);
  _buildViola(viola);
  _buildPiano(piano);

  final score = Score(
    parts: [voice, viola, piano],
    // The piano's two staves are braced together; the whole score is
    // bracketed, which is a different mark and a different rule.
    partGroups: [PartGroup(number: '1', startPartIndex: 0, endPartIndex: 2)],
  );
  score.metadata
    ..movementTitle = 'A Page of Awkward Marks'
    ..creators.add(const Creator(type: 'composer', name: 'Songbird'));

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

Measure _measure(int number) => Measure(number: '$number');

Chord _note(
  String pitch,
  Fraction position,
  NoteType type, {
  int dots = 0,
  int staff = 1,
  int voice = 1,
  List<Articulation> articulations = const [],
  List<Ornament> ornaments = const [],
  List<Fermata> fermatas = const [],
  String? lyric,
  bool grace = false,
}) => Chord(
  position: position,
  staff: staff,
  voice: voice,
  notes: [Note(pitch: Pitch.parse(pitch))],
  rhythm: RhythmicDuration(type, dots: dots),
  articulations: articulations,
  ornaments: ornaments,
  fermatas: fermatas,
  grace: grace ? const GraceInfo(slash: true) : null,
  lyrics: lyric == null ? const [] : [Lyric(text: lyric)],
);

/// A singer's line: the marks that hang above and below a single staff.
void _buildVoice(Part part) {
  final first = _measure(1);
  first.attributes
    ..divisions = 4
    ..time = TimeSignature.simple(4, 4)
    ..clefs[1] = Clef.treble
    ..keys[allStaves] = const KeySignature(fifths: -1);
  first
    ..add(
      Direction(
        position: Fraction.zero,
        placement: Placement.above,
        types: const [
          MetronomeDirection(beatUnit: 'quarter', perMinute: 88),
          WordsDirection('Andante', fontStyle: 'italic'),
        ],
      ),
    )
    ..add(
      Direction(
        position: Fraction.zero,
        placement: Placement.above,
        types: const [RehearsalDirection('A')],
      ),
    )
    ..add(
      Direction(
        position: Fraction.zero,
        types: const [
          DynamicsDirection([DynamicMark.p]),
        ],
      ),
    )
    ..add(
      _note(
        'F4',
        Fraction.zero,
        NoteType.quarter,
        articulations: [Articulation.staccato],
        lyric: 'Ev',
      ),
    )
    ..add(
      _note(
        'G4',
        Fraction(1, 4),
        NoteType.quarter,
        articulations: [Articulation.accent],
        lyric: 'ery',
      ),
    )
    ..add(
      _note(
        'A4',
        Fraction(1, 2),
        NoteType.quarter,
        articulations: [Articulation.tenuto],
        lyric: 'mark',
      ),
    )
    ..add(
      _note(
        'B4',
        Fraction(3, 4),
        NoteType.quarter,
        ornaments: [Ornament.trillMark],
        lyric: 'in',
      ),
    );

  final second = _measure(2)
    ..leftBarline = Barline(
      style: BarStyle.heavyLight,
      repeat: const Repeat(direction: RepeatDirection.forward),
    )
    ..add(
      Direction(
        position: Fraction.zero,
        types: const [WedgeDirection(WedgeType.crescendo)],
      ),
    )
    ..add(
      _note(
        'C5',
        Fraction.zero,
        NoteType.eighth,
        ornaments: [Ornament.mordent],
        lyric: 'its',
      ),
    )
    ..add(_note('D5', Fraction(1, 8), NoteType.eighth, lyric: 'own'))
    ..add(
      _note(
        'E5',
        Fraction(1, 4),
        NoteType.eighth,
        ornaments: [Ornament.turn],
        lyric: 'right',
      ),
    )
    ..add(_note('F5', Fraction(3, 8), NoteType.eighth, lyric: 'place'))
    ..add(
      Direction(
        position: Fraction.half,
        types: const [WedgeDirection(WedgeType.stop)],
      ),
    )
    ..add(
      _note(
        'G5',
        Fraction.half,
        NoteType.half,
        fermatas: [const Fermata()],
        lyric: 'now',
      ),
    );

  // Measures three and four are a first and a second ending: the repeat runs
  // back from the end of three, and four is played instead of it the second
  // time round. Its opening barline carries nothing but the volta's start,
  // which is a barline the page must not draw twice.
  final third = _measure(3)
    ..leftBarline = Barline(
      ending: const Ending(numbers: [1], type: EndingType.start),
    )
    ..rightBarline = Barline(
      style: BarStyle.lightHeavy,
      repeat: const Repeat(direction: RepeatDirection.backward, times: 2),
      ending: const Ending(numbers: [1], type: EndingType.stop),
    )
    ..add(
      Direction(
        position: Fraction.zero,
        types: const [
          DynamicsDirection([DynamicMark.ff]),
        ],
      ),
    )
    ..add(_note('E5', Fraction.zero, NoteType.quarter, grace: true))
    ..add(_note('F5', Fraction.zero, NoteType.half, dots: 1, lyric: 'and'))
    ..add(_note('E5', Fraction(3, 4), NoteType.quarter, lyric: 'then'));

  final fourth = _measure(4)
    ..leftBarline = Barline(
      ending: const Ending(numbers: [2], type: EndingType.start),
    )
    ..rightBarline = Barline(
      style: BarStyle.lightHeavy,
      ending: const Ending(numbers: [2], type: EndingType.stop),
    )
    ..add(
      Direction(
        position: Fraction.zero,
        placement: Placement.above,
        types: const [SegnoDirection(), CodaDirection()],
      ),
    )
    ..add(
      _note(
        'D5',
        Fraction.zero,
        NoteType.whole,
        fermatas: [const Fermata()],
        lyric: 'rest',
      ),
    );

  part.measures.addAll([first, second, third, fourth]);

  // A triplet in the second measure, bracketed, which has to find a height
  // clear of the beam it sits over.
  final triplet = second.events.whereType<Chord>().take(3).toList();
  for (final chord in triplet) {
    chord.rhythm = RhythmicDuration(
      chord.rhythm.type,
      timeModification: TimeModification.triplet,
    );
  }
  part.spanners
    ..add(Tuplet(start: triplet.first, end: triplet.last))
    ..add(Slur(start: triplet.first, end: triplet.last));
}

/// The clefs that are not a treble clef, including a change part way through.
void _buildViola(Part part) {
  const pitches = ['C4', 'D4', 'E4', 'F4'];
  for (var m = 0; m < 4; m++) {
    final measure = _measure(m + 1);
    if (m == 0) {
      measure.attributes
        ..divisions = 4
        ..time = TimeSignature.simple(4, 4)
        ..clefs[1] = Clef.alto
        ..keys[allStaves] = const KeySignature(fifths: -1);
    } else if (m == 1) {
      // A C clef on the fourth line rather than the third: the same glyph at a
      // different height, which is the case that gets it wrong.
      measure.attributes.clefs[1] = Clef.tenor;
    } else if (m == 2) {
      measure.attributes.clefs[1] = Clef.bass;
    } else if (m == 3) {
      measure.attributes.clefs[1] = Clef.alto;
    }
    if (m == 2) {
      measure.leftBarline = Barline(
        style: BarStyle.heavyLight,
        repeat: const Repeat(direction: RepeatDirection.forward),
      );
      measure.rightBarline = Barline(
        style: BarStyle.lightHeavy,
        repeat: const Repeat(direction: RepeatDirection.backward, times: 2),
      );
    }
    if (m == 3) measure.rightBarline = Barline(style: BarStyle.lightHeavy);
    for (var beat = 0; beat < 4; beat++) {
      measure.add(_note(pitches[beat], Fraction(beat, 4), NoteType.quarter));
    }
    part.measures.add(measure);
  }
}

/// Two staves of one instrument: the marks that belong to the part rather than
/// to either staff of it.
void _buildPiano(Part part) {
  for (var m = 0; m < 4; m++) {
    final measure = _measure(m + 1);
    if (m == 0) {
      measure.attributes
        ..divisions = 4
        ..staves = 2
        ..time = TimeSignature.simple(4, 4)
        ..clefs[1] = Clef.treble
        ..clefs[2] = Clef.bass
        ..keys[allStaves] = const KeySignature(fifths: -1);
    }
    if (m == 2) {
      measure.leftBarline = Barline(
        style: BarStyle.heavyLight,
        repeat: const Repeat(direction: RepeatDirection.forward),
      );
      measure.rightBarline = Barline(
        style: BarStyle.lightHeavy,
        repeat: const Repeat(direction: RepeatDirection.backward, times: 2),
      );
    }
    if (m == 3) measure.rightBarline = Barline(style: BarStyle.lightHeavy);

    // One hairpin written against the upper staff and another, later, against
    // the lower one — which is how exporters write them, and which used to put
    // the two at two different heights. They belong to the piano, not to its
    // right hand or its left, and being at different times they belong on the
    // same line as each other.
    if (m == 1 || m == 3) {
      final staff = m == 1 ? 1 : 2;
      final growing = m == 1;
      measure
        ..add(
          Direction(
            position: Fraction.zero,
            staff: staff,
            types: [
              WedgeDirection(
                growing ? WedgeType.crescendo : WedgeType.diminuendo,
              ),
            ],
          ),
        )
        ..add(
          Direction(
            position: Fraction(3, 4),
            staff: staff,
            types: const [WedgeDirection(WedgeType.stop)],
          ),
        );
    }
    if (m == 0) {
      measure
        ..add(
          Direction(
            position: Fraction.zero,
            placement: Placement.above,
            types: const [WordsDirection('con pedale')],
          ),
        )
        ..add(
          Direction(
            position: Fraction.zero,
            staff: 2,
            types: const [
              DynamicsDirection([DynamicMark.mp]),
            ],
          ),
        );
    }

    for (var beat = 0; beat < 4; beat++) {
      measure
        ..add(_note('C5', Fraction(beat, 4), NoteType.quarter))
        ..add(_note('E3', Fraction(beat, 4), NoteType.quarter, staff: 2));
    }
    part.measures.add(measure);
  }
}
