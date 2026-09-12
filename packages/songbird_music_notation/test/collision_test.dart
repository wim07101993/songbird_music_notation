import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_score/demo.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

String _read(String name) {
  for (final prefix in const ['', 'packages/songbird_music_notation/']) {
    final file = File('${prefix}test/data/$name');
    if (file.existsSync()) return file.readAsStringSync();
  }
  throw StateError('fixture "$name" not found');
}

/// Nothing a reader has to tell apart may be drawn on top of anything else.
///
/// Stems touch noteheads, beams touch stems, ledger lines run through
/// noteheads — all of that is how notation is drawn. What must never overlap is
/// two things that carry separate meaning: two syllables, a dynamic and a
/// lyric, a flag and the barline after it. This checks exactly those, at
/// several page widths and in several keys, because the collisions that matter
/// only appear once the music is packed tightly.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  late SmuflFont font;

  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
    font = await loadBravura();
  });

  // The generated page of awkward marks, which is where the marks that have to
  // find a height of their own all live: a fermata under a segno, a tuplet
  // bracket over a trill, hairpins under a keyboard.
  group('the showcase', () {
    for (final width in const [40.0, 80.0, 150.0, 400.0]) {
      test('nothing collides at $width staff spaces', () {
        expect(_collisionsIn(buildShowcaseScore(), font, width), isEmpty);
      });
    }
  });

  for (final fixture in const ['greensleeves.musicxml', 'rich.musicxml']) {
    group(fixture, () {
      for (final width in const [50.0, 90.0, 150.0, 250.0]) {
        test('nothing collides at $width staff spaces', () {
          final score = const MusicXmlReader().read(_read(fixture));
          expect(_collisionsIn(score, font, width), isEmpty);
        });
      }

      test('nothing collides after transposing through the keys', () {
        final score = const MusicXmlReader().read(_read(fixture));
        for (var step = 0; step < 12; step++) {
          final key = score.parts.first.contextAtMeasure(0).keyFor(allStaves);
          score.transpose(Interval.chromaticFromKey(1, key));
          expect(
            _collisionsIn(score, font, 120),
            isEmpty,
            reason: 'after ${step + 1} semitones',
          );
        }
      });
    });
  }
}

List<String> _collisionsIn(Score score, SmuflFont font, double width) {
  final layout = LayoutEngine(
    font: font,
    style: EngravingStyle.fromFont(font),
  ).layout(score, width: width);
  final problems = <String>[];

  for (final system in layout.systems) {
    // Page coordinates, so that a lyric reaching into the staff below is
    // caught as well.
    final items = <(LayoutElement, Rect)>[];
    for (final staff in system.staves) {
      for (final element in staff.elements) {
        if (!_carriesItsOwnMeaning(element.role)) continue;
        items.add((element, element.bounds.shift(Offset(0, staff.pageTop))));
      }
    }

    for (var i = 0; i < items.length; i++) {
      for (var j = i + 1; j < items.length; j++) {
        final (a, boundsA) = items[i];
        final (b, boundsB) = items[j];
        if (a.owner != null && identical(a.owner, b.owner)) continue;
        // Parts of one thing — a barline's line and its repeat dots — belong
        // together.
        if (a.source != null && identical(a.source, b.source)) continue;
        // Two noteheads of different chords at the same moment are a chord
        // seen from two voices, which the voice layout handles.
        if (a.role == ElementRole.notehead && b.role == ElementRole.notehead) {
          continue;
        }
        // A row of volta brackets is drawn as one line with hooks in it: where
        // a second ending begins as the first stops, the two meet on the
        // measure line they divide, and are meant to.
        if (a.role == ElementRole.ending && b.role == ElementRole.ending) {
          continue;
        }
        if (boundsA.deflate(0.05).overlaps(boundsB.deflate(0.05))) {
          problems.add(
            '${a.role.name} ${_describe(a)} overlaps '
            '${b.role.name} ${_describe(b)} '
            'at ${boundsA.left.toStringAsFixed(1)},'
            '${boundsA.top.toStringAsFixed(1)}',
          );
        }
      }
    }
  }
  return problems;
}

String _describe(LayoutElement element) => switch (element) {
  final TextElement text => '"${text.text}"',
  final GlyphElement glyph => glyph.glyph.name,
  _ => '',
};

bool _carriesItsOwnMeaning(ElementRole role) => switch (role) {
  ElementRole.lyric ||
  ElementRole.chordSymbol ||
  ElementRole.dynamics ||
  ElementRole.text ||
  ElementRole.accidental ||
  ElementRole.notehead ||
  ElementRole.rest ||
  ElementRole.articulation ||
  ElementRole.ornament ||
  ElementRole.fermata ||
  ElementRole.augmentationDot ||
  ElementRole.flag ||
  ElementRole.barline ||
  ElementRole.tuplet ||
  ElementRole.ending ||
  ElementRole.clef ||
  ElementRole.keySignature ||
  ElementRole.timeSignature => true,
  _ => false,
};
