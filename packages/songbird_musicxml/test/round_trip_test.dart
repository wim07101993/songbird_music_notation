import 'dart:io';

import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_score/songbird_score.dart' as model;
import 'package:test/test.dart';
import 'package:xml/xml.dart';

/// Reads a fixture, whether the tests were started from the package directory
/// or from the workspace root.
String _read(String name) {
  for (final prefix in const ['', 'packages/songbird_musicxml/']) {
    final file = File('${prefix}test/data/$name');
    if (file.existsSync()) return file.readAsStringSync();
  }
  throw StateError('fixture "$name" not found');
}

void main() {
  group('chord symbols', () {
    /// Writes a one-measure chart holding [symbol] and reads it back.
    model.Harmony? roundTrip(String symbol) {
      final harmony = model.Harmony.parseSymbol(
        symbol,
        position: model.Fraction.zero,
      )!;
      final score = model.Score(
        parts: [
          model.Part(
            id: 'P1',
            name: 'Chart',
            measures: [
              model.Measure(
                number: '1',
                events: [
                  harmony,
                  model.Chord(
                    position: model.Fraction.zero,
                    notes: [
                      model.Note(pitch: const model.Pitch(model.Step.c, 4)),
                    ],
                    rhythm: const model.RhythmicDuration(model.NoteType.whole),
                  ),
                ],
              ),
            ],
          ),
        ],
      );
      final written = const MusicXmlWriter().write(score);
      final again = const MusicXmlReader()
          .readDocument(MusicXmlDocument.parse(written))
          .score;
      return again.parts.single.measures.single.events
          .whereType<model.Harmony>()
          .firstOrNull;
    }

    test('a typed symbol survives being written out and read back', () {
      for (final symbol in ['C', 'F#m7', 'Bbmaj7', 'Cmaj7/E', 'G/B']) {
        expect(roundTrip(symbol)?.symbol, symbol, reason: symbol);
      }
    });

    test('a quality the schema has no name for is kept as written', () {
      final read = roundTrip('C7alt');
      expect(read?.kind, model.ChordKind.other);
      expect(read?.symbol, 'C7alt');
    });
  });

  group('document', () {
    test('parses a minimal partwise score', () {
      final document = MusicXmlDocument.parse(_read('hello_world.musicxml'));
      expect(document.layout, MusicXmlLayout.partwise);
      final score = document.toPartwise();
      expect(score.work?.workTitle, 'Hello World');
      expect(score.part, hasLength(1));
      expect(score.part.single.measure, hasLength(1));
    });

    test('writes back every element it read', () {
      final source = _read('rich.musicxml');
      final document = MusicXmlDocument.parse(source);
      final written = document.toXmlString();
      final reparsed = MusicXmlDocument.parse(written);

      // Comparing the element trees rather than the text ignores formatting
      // while still catching anything dropped on the way through.
      expect(
        _elementCounts(XmlDocument.parse(written).rootElement),
        _elementCounts(XmlDocument.parse(source).rootElement),
      );
      expect(reparsed.toPartwise().part.single.measure, hasLength(2));
    });

    test('reads a file written in UTF-16', () {
      // The specification allows it and real files use it: two of the official
      // MusicXML sample scores are UTF-16, and a reader that only ever tries
      // UTF-8 throws them out as corrupt.
      final text = _read('rich.musicxml');
      for (final bigEndian in [false, true]) {
        final bytes = <int>[
          if (bigEndian) ...[0xFE, 0xFF] else ...[0xFF, 0xFE],
          for (final unit in text.codeUnits)
            if (bigEndian) ...[
              unit >> 8,
              unit & 0xFF,
            ] else ...[
              unit & 0xFF,
              unit >> 8,
            ],
        ];
        final restored = MusicXmlDocument.fromBytes(bytes);
        expect(
          restored.toPartwise().movementTitle,
          'Study in Two Voices',
          reason: bigEndian ? 'big endian' : 'little endian',
        );
      }
    });

    test('round-trips through a compressed .mxl container', () {
      final document = MusicXmlDocument.parse(_read('rich.musicxml'));
      final bytes = document.toCompressedBytes();
      expect(bytes[0], 0x50);
      final restored = MusicXmlDocument.fromBytes(bytes);
      expect(restored.toPartwise().movementTitle, 'Study in Two Voices');
    });
  });

  group('the side a curve is bowed to', () {
    const source = '''
<score-partwise version="4.0">
  <part-list><score-part id="P1"><part-name>Piano</part-name></score-part></part-list>
  <part id="P1"><measure number="1">
    <attributes><divisions>2</divisions>
      <clef><sign>F</sign><line>4</line></clef></attributes>
    <note><pitch><step>G</step><octave>2</octave></pitch><duration>2</duration>
      <voice>1</voice><type>quarter</type><tie type="start"/>
      <notations><tied orientation="under" type="start"/>
        <slur number="1" placement="below" type="start"/></notations></note>
    <note><pitch><step>G</step><octave>2</octave></pitch><duration>2</duration>
      <voice>1</voice><type>quarter</type><tie type="stop"/>
      <notations><tied type="stop"/>
        <slur number="1" type="stop"/></notations></note>
  </measure></part>
</score-partwise>
''';

    test('is read from the file rather than guessed from the stems', () {
      final score = const MusicXmlReader()
          .readDocument(MusicXmlDocument.parse(source))
          .score;
      final part = score.parts.single;
      expect(
        part.spanners.whereType<model.Tie>().single.orientation,
        model.LineOrientation.under,
      );
      expect(
        part.spanners.whereType<model.Slur>().single.placement,
        model.Placement.below,
      );
    });

    test('survives being written back out', () {
      final score = const MusicXmlReader()
          .readDocument(MusicXmlDocument.parse(source))
          .score;
      final written = const MusicXmlWriter().write(score);
      final again = const MusicXmlReader()
          .readDocument(MusicXmlDocument.parse(written))
          .score;
      final part = again.parts.single;
      expect(
        part.spanners.whereType<model.Tie>().single.orientation,
        model.LineOrientation.under,
      );
      expect(
        part.spanners.whereType<model.Slur>().single.placement,
        model.Placement.below,
      );
    });
  });

  group('a slur between voices', () {
    // A part is written a voice at a time, so a slur from a note in one voice
    // to a note in another can be closed on the page before it is opened in
    // the file: this one ends on the right hand's first note and begins on a
    // left hand note written further down the same measure. Read voice by
    // voice, it was thrown away as an end without a beginning — and the next
    // ending of that number was then paired with the wrong note.
    const source = '''
<score-partwise version="4.0">
  <part-list><score-part id="P1"><part-name>Piano</part-name></score-part></part-list>
  <part id="P1"><measure number="1">
    <attributes><divisions>2</divisions><staves>2</staves>
      <clef number="1"><sign>G</sign><line>2</line></clef>
      <clef number="2"><sign>F</sign><line>4</line></clef></attributes>
    <note><pitch><step>G</step><octave>4</octave></pitch><duration>4</duration>
      <voice>1</voice><type>half</type><staff>1</staff>
      <notations><slur number="1" type="stop"/></notations></note>
    <backup><duration>4</duration></backup>
    <note><pitch><step>C</step><octave>3</octave></pitch><duration>2</duration>
      <voice>2</voice><type>quarter</type><staff>2</staff>
      <notations><slur number="1" type="start"/></notations></note>
    <note><pitch><step>E</step><octave>3</octave></pitch><duration>2</duration>
      <voice>2</voice><type>quarter</type><staff>2</staff></note>
  </measure></part>
</score-partwise>
''';

    test('is read as one slur, from the note that begins it', () {
      final result = const MusicXmlReader().readDocument(
        MusicXmlDocument.parse(source),
      );
      expect(result.warnings, isEmpty);

      final part = result.score.parts.single;
      final slurs = part.spanners.whereType<model.Slur>().toList();
      expect(slurs, hasLength(1));

      final chords = part.measures.single.events
          .whereType<model.Chord>()
          .toList();
      final treble = chords.firstWhere((chord) => chord.staff == 1);
      final bass = chords.firstWhere((chord) => chord.staff == 2);
      expect(identical(slurs.single.start, bass), isTrue);
      expect(identical(slurs.single.end, treble), isTrue);
    });
  });

  group('hidden music', () {
    /// A note that sounds but is not printed, as a roll's realisation is.
    const source = '''
<score-partwise version="4.0">
  <part-list><score-part id="P1"><part-name>Timpani</part-name></score-part></part-list>
  <part id="P1"><measure number="1">
    <attributes><divisions>4</divisions><clef><sign>F</sign><line>4</line></clef></attributes>
    <note><pitch><step>E</step><octave>3</octave></pitch><duration>16</duration>
      <voice>1</voice><type>whole</type></note>
    <backup><duration>16</duration></backup>
    <note print-object="no" print-spacing="no">
      <pitch><step>E</step><octave>3</octave></pitch><duration>4</duration>
      <voice>2</voice><type>quarter</type></note>
    <note print-object="no"><rest/><duration>12</duration><voice>2</voice></note>
  </measure></part>
</score-partwise>
''';

    test('is read as music that is simply not drawn', () {
      final score = const MusicXmlReader()
          .readDocument(MusicXmlDocument.parse(source))
          .score;
      final events = score.parts.single.measures.single.events;
      final chords = events.whereType<model.Chord>().toList();
      expect(chords, hasLength(2));
      expect(chords.first.isPrinted, isTrue);
      expect(chords.last.isPrinted, isFalse);
      expect(chords.last.takesSpace, isFalse, reason: 'nor spaced for');

      final rest = events.whereType<model.Rest>().single;
      expect(rest.printObject, isFalse);
      expect(rest.printSpacing, isTrue, reason: 'it still holds its place');
    });

    test('is written back out still hidden', () {
      final score = const MusicXmlReader()
          .readDocument(MusicXmlDocument.parse(source))
          .score;
      final written = const MusicXmlWriter().write(score);
      expect(written, contains('print-object="no"'));
      expect(written, contains('print-spacing="no"'));

      final again = const MusicXmlReader()
          .readDocument(MusicXmlDocument.parse(written))
          .score;
      final chords = again.parts.single.measures.single.events
          .whereType<model.Chord>()
          .toList();
      expect(chords.where((chord) => chord.isPrinted), hasLength(1));
    });
  });

  group('reader', () {
    late model.Score score;
    late MusicXmlReadResult result;

    setUp(() {
      result = const MusicXmlReader().readDocument(
        MusicXmlDocument.parse(_read('rich.musicxml')),
      );
      score = result.score;
    });

    test('reads without warnings', () {
      expect(result.warnings, isEmpty);
    });

    test('reads metadata and the part list', () {
      expect(score.metadata.title, 'Study in Two Voices');
      expect(score.metadata.composer, 'Anon.');
      expect(score.parts, hasLength(1));
      expect(score.parts.single.name, 'Piano');
      expect(score.parts.single.abbreviation, 'Pno.');
      expect(score.partGroups, hasLength(1));
      expect(score.partGroups.single.symbol, model.GroupSymbol.brace);
      expect(score.parts.single.instruments.single.name, 'Piano');
    });

    test('reads attributes into the running context', () {
      final context = score.parts.single.contextAtMeasure(0);
      expect(context.keyFor(1).fifths, 2);
      expect(context.time.measureDuration, model.Fraction(3, 4));
      expect(context.staffCount, 2);
      expect(context.clefFor(1), model.Clef.treble);
      expect(context.clefFor(2), model.Clef.bass);
    });

    test('resolves the measure cursor into absolute positions', () {
      final measure = score.parts.single.measures.first;
      final upper = measure.eventsInVoice(1).whereType<model.Chord>().toList();
      expect(upper.first.position, model.Fraction.zero);
      // Three triplet eighths fill one quarter, so the fourth note starts there.
      expect(upper.last.position, model.Fraction(1, 4));

      final lower = measure.eventsInVoice(5);
      expect(lower.first.position, model.Fraction.zero);
      expect(lower.first.staff, 2);
    });

    test('merges chord notes into one event', () {
      final measure = score.parts.single.measures.first;
      final chord = measure.eventsInVoice(5).whereType<model.Chord>().first;
      expect(chord.notes, hasLength(2));
      expect(chord.lowestNote?.pitch, const model.Pitch(model.Step.d, 3));
      expect(chord.highestNote?.pitch, const model.Pitch(model.Step.a, 3));
    });

    test('reads tuplets, slurs and ties as resolved spanners', () {
      final spanners = score.parts.single.spanners;
      expect(spanners.whereType<model.Tuplet>(), hasLength(1));
      expect(spanners.whereType<model.Slur>(), hasLength(1));
      final ties = spanners.whereType<model.Tie>().toList();
      expect(ties, hasLength(1));
      // The tie crosses the barline, so its ends are in different measures.
      final first = score.parts.single.measures[0];
      final second = score.parts.single.measures[1];
      expect(first.events, contains(ties.single.start));
      expect(second.events, contains(ties.single.end));
    });

    test('reads triplets as exact durations', () {
      final measure = score.parts.single.measures.first;
      final triplet = measure.eventsInVoice(1).whereType<model.Chord>().first;
      expect(triplet.rhythm.timeModification.actualNotes, 3);
      expect(triplet.duration, model.Fraction(1, 12));
    });

    test('reads lyrics, articulations, beams and accidentals', () {
      final measure = score.parts.single.measures.first;
      final notes = measure.eventsInVoice(1).whereType<model.Chord>().toList();
      expect(notes.first.lyrics.single.text, 'Hel');
      expect(notes.first.lyrics.single.syllabic, model.Syllabic.begin);
      expect(notes.first.articulations, [model.Articulation.staccato]);
      expect(notes.first.beams.single.state, model.BeamState.begin);
      expect(
        notes[1].notes.single.accidental?.type,
        model.AccidentalType.sharp,
      );
    });

    test('reads directions and their sound information', () {
      final directions = score.parts.single.measures.first.directions;
      expect(directions, hasLength(2));
      final words = directions.first.types.whereType<model.WordsDirection>();
      expect(words.single.text, 'Andante');
      expect(directions.first.sound?.tempo, 72);
      final dynamics = directions.last.types
          .whereType<model.DynamicsDirection>();
      expect(dynamics.single.marks, [model.DynamicMark.mf]);
    });

    test('reads barlines and repeats', () {
      final barline = score.parts.single.measures.first.rightBarline;
      expect(barline?.style, model.BarStyle.lightHeavy);
      expect(barline?.repeat?.direction, model.RepeatDirection.backward);
    });
  });

  group('writer', () {
    test('a score survives a trip through the model', () {
      final original = const MusicXmlReader().read(_read('rich.musicxml'));
      final written = const MusicXmlWriter().write(original);
      final restored = const MusicXmlReader().read(written);

      expect(restored.metadata.title, original.metadata.title);
      expect(restored.parts.length, original.parts.length);
      expect(restored.measureCount, original.measureCount);

      final before = original.parts.single;
      final after = restored.parts.single;
      expect(after.name, before.name);
      expect(after.abbreviation, before.abbreviation);

      final beforeChords = before.chords.toList();
      final afterChords = after.chords.toList();
      expect(afterChords, hasLength(beforeChords.length));
      for (var i = 0; i < beforeChords.length; i++) {
        expect(
          afterChords[i].notes.map((n) => n.pitch).toList(),
          beforeChords[i].notes.map((n) => n.pitch).toList(),
          reason: 'chord $i pitches',
        );
        expect(
          afterChords[i].duration,
          beforeChords[i].duration,
          reason: 'chord $i duration',
        );
        expect(
          afterChords[i].position,
          beforeChords[i].position,
          reason: 'chord $i position',
        );
        expect(afterChords[i].staff, beforeChords[i].staff);
        expect(afterChords[i].voice, beforeChords[i].voice);
      }

      expect(
        after.spanners.whereType<model.Tuplet>().length,
        before.spanners.whereType<model.Tuplet>().length,
      );
      expect(
        after.spanners.whereType<model.Slur>().length,
        before.spanners.whereType<model.Slur>().length,
      );
      expect(
        after.spanners.whereType<model.Tie>().length,
        before.spanners.whereType<model.Tie>().length,
      );
      expect(
        after.contextAtMeasure(0).keyFor(1).fifths,
        before.contextAtMeasure(0).keyFor(1).fifths,
      );
      expect(
        after.measures.first.rightBarline?.repeat?.direction,
        model.RepeatDirection.backward,
      );
      expect(after.chords.first.lyrics.single.text, 'Hel');
    });

    test('chooses divisions that keep triplets exact', () {
      final score = const MusicXmlReader().read(_read('rich.musicxml'));
      final written = const MusicXmlWriter().write(score);
      final divisions = XmlDocument.parse(
        written,
      ).findAllElements('divisions').first.innerText;
      expect(int.parse(divisions) % 3, 0);
    });
  });
}

/// Counts every element name in a tree, so two documents can be compared
/// without caring about attribute order or whitespace.
Map<String, int> _elementCounts(XmlElement root) {
  final counts = <String, int>{};
  void visit(XmlElement element) {
    counts.update(element.name.local, (n) => n + 1, ifAbsent: () => 1);
    for (final child in element.childElements) {
      visit(child);
    }
  }

  visit(root);
  return counts;
}
