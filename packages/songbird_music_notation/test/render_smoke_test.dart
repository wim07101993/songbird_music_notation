import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

String _read(String name) {
  for (final prefix in const ['', 'packages/songbird_music_notation/']) {
    final file = File('${prefix}test/data/$name');
    if (file.existsSync()) return file.readAsStringSync();
  }
  throw StateError('fixture "$name" not found');
}

/// Where rendered images are written when SONGBIRD_RENDER_DIR is set, so the
/// engraving can be looked at rather than only asserted about.
String? get _outputDirectory => Platform.environment['SONGBIRD_RENDER_DIR'];

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SmuflFont font;

  setUpAll(() async {
    // A test runner ships no real fonts, so Bravura has to be registered by
    // hand before anything it draws will look like music. A font declared by a
    // package is addressed as "packages/<package>/<family>", which is what
    // TextStyle's `package:` argument expands to.
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    final loader = FontLoader('packages/songbird_smufl/Bravura')
      ..addFont(Future.value(bytes));
    await loader.load();
    font = await loadBravura();
  });

  Future<void> render(String fixture, String name, {double width = 150}) async {
    final score = const MusicXmlReader().read(_read(fixture));
    final style = EngravingStyle.fromFont(font);
    final layout = LayoutEngine(
      font: font,
      style: style,
    ).layout(score, width: width);

    final image = await renderScoreToImage(
      layout: layout,
      font: font,
      style: style,
      staffSpace: 10,
    );
    expect(image.width, greaterThan(0));
    expect(image.height, greaterThan(0));

    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    expect(data, isNotNull);
    expect(data!.lengthInBytes, greaterThan(1000));

    final directory = _outputDirectory;
    if (directory != null) {
      final file = File('$directory/$name.png');
      file.parent.createSync(recursive: true);
      file.writeAsBytesSync(data.buffer.asUint8List());
    }
  }

  test('renders a rich score to an image', () async {
    await render('rich.musicxml', 'rich');
  });

  test('renders a minimal score to an image', () async {
    await render('hello_world.musicxml', 'hello_world', width: 80);
  });

  test('renders a wide window as one long system', () async {
    await render('greensleeves.musicxml', 'wide', width: 247);
  });

  test('renders a generated score across several systems', () async {
    final score = _scaleScore();
    final style = EngravingStyle.fromFont(font);
    final layout = LayoutEngine(
      font: font,
      style: style,
    ).layout(score, width: 70);
    expect(layout.systems.length, greaterThan(1));

    final image = await renderScoreToImage(
      layout: layout,
      font: font,
      style: style,
      staffSpace: 10,
    );
    final data = await image.toByteData(format: ui.ImageByteFormat.png);
    final directory = _outputDirectory;
    if (directory != null && data != null) {
      File('$directory/scale.png')
        ..parent.createSync(recursive: true)
        ..writeAsBytesSync(data.buffer.asUint8List());
    }
  });
}

/// Two octaves of a C major scale up and down in eighth notes, which exercises
/// ledger lines, beaming, stem direction and system breaks.
Score _scaleScore() {
  final part = Part(id: 'P1', name: 'Scale');
  final score = Score(parts: [part])..metadata.movementTitle = 'Two Octaves';

  // Up two octaves and back down again: 15 notes each way, plus the note the
  // turn lands on, is 30 eighth notes — just under four measures of 4/4.
  var step = 0;
  var direction = 1;
  for (var measureIndex = 0; measureIndex < 4; measureIndex++) {
    final measure = Measure(number: '${measureIndex + 1}');
    if (measureIndex == 0) {
      measure.attributes
        ..divisions = 2
        ..time = TimeSignature.simple(4, 4)
        ..clefs[1] = Clef.treble
        ..keys[allStaves] = KeySignature.cMajor;
    }
    for (var beat = 0; beat < 8; beat++) {
      final diatonic = const Pitch(Step.c, 4).diatonicValue + step;
      measure.add(
        Chord(
          position: Fraction(beat, 8),
          notes: [
            Note(
              pitch: Pitch(
                Step.fromDiatonicIndex(diatonic % 7),
                (diatonic / 7).floor(),
              ),
            ),
          ],
          rhythm: const RhythmicDuration(NoteType.eighth),
        ),
      );
      if (step == 14) direction = -1;
      step += direction;
    }
    part.measures.add(measure);
  }

  for (var i = 0; i < part.measures.length; i++) {
    final context = part.contextAtMeasure(i);
    Beaming.applyTo(part.measures[i], time: context.time);
    Beaming.applyStemDirections(part.measures[i], clef: context.clefFor(1));
    AccidentalResolver.applyTo(part.measures[i], context: context);
  }
  return score;
}
