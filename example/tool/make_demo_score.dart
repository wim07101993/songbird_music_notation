// Builds the demo score shipped in assets/, using the packages themselves.
//
//   dart run tool/make_demo_score.dart
import 'dart:io';

import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_score/songbird_score.dart';

void main() {
  final xml = const MusicXmlWriter(
    software: 'songbird example generator',
  ).write(buildGreensleeves());
  File('assets/greensleeves.musicxml').writeAsStringSync(xml);
  stdout.writeln('Wrote assets/greensleeves.musicxml');
}

/// One written note of the melody.
typedef _Note = (String pitch, int eighths, String syllable);

/// Greensleeves — a traditional English melody in the public domain — with
/// lyrics, a simple broken-chord accompaniment, a tempo mark and a dynamic.
///
/// Each measure is given as a list of notes whose lengths add up to the six
/// eighths of a 6/8 measure, so the bar lines fall where they should.
Score buildGreensleeves() {
  const pickup = <_Note>[('A4', 1, 'A-')];
  const measures = <List<_Note>>[
    [('C5', 3, 'las'), ('D5', 1, 'my'), ('E5', 2, 'love')],
    [('F#5', 1, 'you'), ('E5', 2, 'do'), ('D5', 3, 'me')],
    [('B4', 3, 'wrong'), ('G4', 1, 'to'), ('A4', 2, 'cast')],
    [('B4', 1, 'me'), ('A4', 2, 'off'), ('G4', 3, 'dis-')],
    [('C5', 3, 'cour-'), ('D5', 1, 'teous-'), ('E5', 2, 'ly')],
    [('F#5', 1, 'And'), ('E5', 2, 'I'), ('D5', 3, 'have')],
    [('B4', 3, 'loved'), ('G4', 1, 'you'), ('A4', 2, 'so')],
    [('B4', 1, 'long'), ('A4', 2, 'de-'), ('E4', 3, 'lighting')],
  ];

  /// The root of the chord under each measure, following the tune's harmony.
  const harmony = <String>['A2', 'D3', 'E2', 'E2', 'A2', 'D3', 'E2', 'E2'];

  /// The chord symbol printed over each measure, as a chart would write it.
  ///
  /// Greensleeves is in the Dorian mode, so the tune turns on an A minor and a
  /// major E; the slash chord and the seventh are here because a reader of
  /// this library will want to see one of each.
  const symbols = <(String, ChordKind, String?)>[
    ('A', ChordKind.minor, null),
    ('C', ChordKind.major, null),
    ('E', ChordKind.dominant, 'G#'),
    ('E', ChordKind.major, null),
    ('A', ChordKind.minor, null),
    ('C', ChordKind.major, null),
    ('E', ChordKind.dominant, null),
    ('A', ChordKind.minor, null),
  ];

  final melody = Part(id: 'P1', name: 'Voice', abbreviation: 'V.');
  final accompaniment = Part(id: 'P2', name: 'Guitar', abbreviation: 'Gtr.');
  final score = Score(parts: [melody, accompaniment]);
  score.metadata
    ..movementTitle = 'Greensleeves'
    ..creators.add(const Creator(type: 'composer', name: 'Traditional'))
    ..creators.add(const Creator(type: 'lyricist', name: 'Anonymous'));

  melody.measures.add(_melodyMeasure(pickup, number: 0, implicit: true));
  accompaniment.measures.add(
    _accompanimentMeasure('A2', Fraction(1, 8), number: 0, implicit: true),
  );

  for (var i = 0; i < measures.length; i++) {
    final measure = _melodyMeasure(measures[i], number: i + 1);
    final (root, kind, bass) = symbols[i];
    measure.add(
      Harmony(
        position: Fraction.zero,
        root: Pitch.parse('${root}4'),
        kind: kind,
        bass: bass == null ? null : Pitch.parse('${bass}3'),
      ),
    );
    melody.measures.add(measure);
    accompaniment.measures.add(
      _accompanimentMeasure(harmony[i], Fraction(6, 8), number: i + 1),
    );
  }

  for (final part in score.parts) {
    part.measures.last.rightBarline = Barline(style: BarStyle.lightHeavy);
  }

  melody.measures[1]
    ..add(
      Direction(
        position: Fraction.zero,
        placement: Placement.above,
        types: const [WordsDirection('Andante', fontStyle: 'italic')],
        sound: const SoundInfo(tempo: 92),
      ),
    )
    ..add(
      Direction(
        position: Fraction.zero,
        types: const [
          DynamicsDirection([DynamicMark.mp]),
        ],
      ),
    );

  // A slur over the first phrase, to show that spanners survive the round trip.
  final phrase = melody.measures[1].events.whereType<Chord>().toList();
  final phraseEnd = melody.measures[2].events.whereType<Chord>().toList();
  if (phrase.isNotEmpty && phraseEnd.isNotEmpty) {
    melody.spanners.add(Slur(start: phrase.first, end: phraseEnd.last));
  }

  _finish(score);
  return score;
}

Measure _melodyMeasure(
  List<_Note> notes, {
  required int number,
  bool implicit = false,
}) {
  final measure = _newMeasure(number, first: number == 0, implicit: implicit);
  var at = Fraction.zero;
  for (final (pitch, eighths, syllable) in notes) {
    final length = Fraction(eighths, 8);
    measure.add(
      Chord(
        position: at,
        notes: [Note(pitch: Pitch.parse(pitch))],
        rhythm: RhythmicDuration.decompose(length).single,
        lyrics: [
          // A trailing hyphen in the data marks a syllable that carries on
          // into the next note, which is what draws the hyphen between them.
          Lyric(
            text: syllable.replaceAll('-', ''),
            syllabic: syllable.endsWith('-') ? Syllabic.begin : Syllabic.single,
          ),
        ],
      ),
    );
    at += length;
  }
  return measure;
}

/// A measure of the accompaniment: the chord's root and fifth in a rocking
/// eighth-note pattern.
///
/// Root and fifth rather than a full triad, because the third would need to
/// follow the key to be spelled correctly, and a bare fifth is what a guitar
/// actually plays under this tune.
Measure _accompanimentMeasure(
  String root,
  Fraction length, {
  required int number,
  bool implicit = false,
}) {
  final measure = _newMeasure(
    number,
    first: number == 0,
    implicit: implicit,
    bass: true,
  );
  final rootPitch = Pitch.parse(root);
  final fifth = Interval.named(5, IntervalQuality.perfect).transpose(rootPitch);
  final pattern = [rootPitch, fifth, rootPitch, fifth];

  var at = Fraction.zero;
  var index = 0;
  while (at < length) {
    measure.add(
      Chord(
        position: at,
        notes: [Note(pitch: pattern[index % pattern.length])],
        rhythm: const RhythmicDuration(NoteType.eighth),
        stem: StemDirection.up,
      ),
    );
    at += const RhythmicDuration(NoteType.eighth).value;
    index++;
  }
  return measure;
}

Measure _newMeasure(
  int number, {
  bool first = false,
  bool implicit = false,
  bool bass = false,
}) {
  final measure = Measure(number: '$number', implicit: implicit);
  if (first) {
    measure.attributes
      ..divisions = 4
      ..time = TimeSignature.simple(6, 8)
      ..keys[allStaves] = KeySignature.forTonic(
        const Pitch(Step.e, 4),
        mode: Mode.minor,
      )
      ..clefs[1] = bass ? Clef.bass : Clef.treble;
  }
  return measure;
}

/// Derives the beaming, stem directions and accidentals the notes did not
/// state, which is what a file exported from a sequencer would also need.
void _finish(Score score) {
  for (final part in score.parts) {
    for (var i = 0; i < part.measures.length; i++) {
      final context = part.contextAtMeasure(i);
      Beaming.applyTo(part.measures[i], time: context.time);
      Beaming.applyStemDirections(part.measures[i], clef: context.clefFor(1));
      AccidentalResolver.applyTo(part.measures[i], context: context);
    }
  }
}
