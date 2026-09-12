// Writes a score to MusicXML and reads it back, which is the round trip the
// package exists for. A real caller reads a file instead:
//
//   final score = const MusicXmlReader().read(await file.readAsString());
//   final score = const MusicXmlReader().readBytes(await file.readAsBytes());
//
// The second one takes a compressed `.mxl` container.
import 'dart:io';

import 'package:songbird_musicxml/songbird_musicxml.dart';
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
  )..metadata.movementTitle = 'One note';

  final xml = const MusicXmlWriter().write(score);
  stdout.writeln(xml.split('\n').take(8).join('\n'));

  final again = const MusicXmlReader().read(xml);
  stdout.writeln(
    'read back: ${again.metadata.movementTitle}, '
    '${again.parts.length} part, '
    '${again.parts.first.measures.length} measure',
  );

  // A compressed .mxl container is the same score in a zip.
  stdout.writeln(
    '.mxl size: ${const MusicXmlWriter().writeCompressed(score).length} bytes',
  );
}
