# songbird_score

A format-agnostic, editable model of a musical score, in pure Dart.

It describes music the way a reader sees it — parts, measures, chords, rests,
directions — and keeps no trace of the file it came from, so a MusicXML reader,
a LilyPond reader and an editor can all target the same structure.

```dart
final score = Score(parts: [Part(id: 'P1', name: 'Flute')]);
score.parts.first.measures.add(
  Measure(number: '1')
    ..attributes.time = TimeSignature.simple(4, 4)
    ..attributes.clefs[1] = Clef.treble
    ..add(
      Chord(
        position: Fraction.zero,
        notes: [Note(pitch: Pitch.parse('C4'))],
        rhythm: const RhythmicDuration(NoteType.quarter),
      ),
    ),
);
```

## Time is exact

Musical time does not survive floating point: a triplet eighth inside a
dotted-quarter beat is `1/12` of a whole note, and comparing accumulated
`double`s goes wrong within a few measures. Every position and duration is a
[`Fraction`] — exact rational arithmetic — so twelve triplet eighths add up to
one whole note and nothing drifts.

## Spelling is part of a pitch

F sharp and G flat are different `Pitch`es that happen to share a MIDI number.
Keeping them distinct is what lets transposition produce readable accidentals:

```dart
final up = Interval.named(3, IntervalQuality.minor);
up.transpose(Pitch.parse('A4'));   // C5, not B#4
```

`Interval` carries both a diatonic and a chromatic distance, because a
diminished fourth and a major third sound alike but move a different number of
letter names. `KeySignature.transposed` moves a key round the circle of fifths
and respells it if the result would need more than seven accidentals.

## Positions are absolute

MusicXML describes a measure as a stream with a cursor that `<backup>` and
`<forward>` move around. This model gives every event an absolute position
inside its measure instead, so overlapping voices are plain to see and nothing
downstream has to track a cursor.

## Editing is undoable

Every change is an `EditCommand` that captures what it needs to reverse itself.
The editor never snapshots the score — a score is tens of megabytes of objects,
and the inverse of an edit is almost always a few fields.

```dart
final editor = ScoreEditor(score);
editor.execute(TransposeCommand(interval: Interval.chromatic(2)));
editor.undo();
```

Commands can merge, so an auto-repeating arrow key produces one undo step
rather than fifty.

## Deriving what a file leaves out

`AccidentalResolver` works out which accidentals to print from the key
signature and what has already happened in the measure. `Beaming` groups notes
by the metric accents of the time signature and chooses stem directions.
`RestFilling` fills gaps so a voice stays rhythmically complete. All of it is
pure computation with no rendering attached.
