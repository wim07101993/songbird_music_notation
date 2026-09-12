// Builds a flute part by hand, transposes it up a minor third through the
// editor and undoes that again — the shape of the whole package in one file.
import 'dart:io';

import 'package:songbird_score/songbird_score.dart';

void main() {
  final score = Score(
    parts: [
      Part(
        id: 'P1',
        name: 'Flute',
        measures: [
          Measure(number: '1')
            ..attributes.time = TimeSignature.simple(4, 4)
            ..attributes.clefs[1] = Clef.treble
            ..add(
              Chord(
                position: Fraction.zero,
                notes: [Note(pitch: const Pitch(Step.a, 4))],
                rhythm: const RhythmicDuration(NoteType.quarter),
              ),
            ),
        ],
      ),
    ],
  );

  final editor = ScoreEditor(score);
  stdout.writeln(_firstPitch(score));

  // Spelling-aware: a minor third above A4 is C5, not B sharp 4.
  editor.execute(
    TransposeCommand(interval: Interval.named(3, IntervalQuality.minor)),
  );
  stdout.writeln(_firstPitch(score));

  // Every edit knows how to reverse itself, so nothing is snapshotted.
  editor.undo();
  stdout.writeln(_firstPitch(score));
}

Pitch? _firstPitch(Score score) => score.parts.first.measures.first.events
    .whereType<Chord>()
    .first
    .notes
    .first
    .pitch;
