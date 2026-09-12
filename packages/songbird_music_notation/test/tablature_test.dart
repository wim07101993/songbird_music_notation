import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// A guitar's tablature staff.
///
/// Tablature says which string to stop and where, not which note to play, so
/// none of the ordinary machinery applies to it: no noteheads, no ledger
/// lines, no stems.
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

  Score buildTabScore() {
    final guitar = Part(id: 'P1', name: 'Guitar');
    final measure = Measure(number: '1');
    measure.attributes
      ..time = TimeSignature.simple(4, 4)
      ..clefs[1] = const Clef(sign: ClefSign.tab, line: 5)
      ..staffDetails[allStaves] = const StaffDetails(staffLines: 6);

    // An open top string, then a chord across the two lowest.
    measure.add(
      Chord(
        position: Fraction.zero,
        rhythm: const RhythmicDuration(NoteType.quarter),
        notes: [Note(pitch: Pitch.parse('E5'), string: 1, fret: 0)],
      ),
    );
    measure.add(
      Chord(
        position: Fraction(1, 4),
        rhythm: const RhythmicDuration(NoteType.quarter),
        notes: [
          Note(pitch: Pitch.parse('E2'), string: 6, fret: 0),
          Note(pitch: Pitch.parse('C3'), string: 5, fret: 3),
        ],
      ),
    );
    guitar.measures.add(measure);
    return Score(parts: [guitar]);
  }

  test('a note is written as its fret number on its string', () {
    final layout = LayoutEngine(font: font).layout(buildTabScore(), width: 120);
    final staff = layout.systems.single.staves.single;
    expect(staff.geometry.lineCount, 6);

    final numbers = staff.elements
        .whereType<TextElement>()
        .where((element) => element.role == ElementRole.tabNumber)
        .toList();
    expect(numbers.map((element) => element.text), ['0', '0', '3']);

    // The top string is written on the top line, the sixth on the bottom.
    final top = numbers.first;
    expect(top.origin.dy, closeTo(staff.geometry.lineY(6), 0.6));
    final sixth = numbers[1];
    expect(sixth.origin.dy, closeTo(staff.geometry.lineY(1), 0.6));
    final fifth = numbers[2];
    expect(fifth.origin.dy, closeTo(staff.geometry.lineY(2), 0.6));

    // And is a number, not a note: nothing is drawn that belongs to one.
    for (final role in const [
      ElementRole.notehead,
      ElementRole.stem,
      ElementRole.flag,
      ElementRole.ledgerLine,
      ElementRole.accidental,
    ]) {
      expect(
        staff.elements.where((element) => element.role == role),
        isEmpty,
        reason: 'a tablature staff drew a ${role.name}',
      );
    }
  });

  test('the tablature sign is centred on the staff it labels', () {
    // It names no line — it is a label for the whole staff — so a `<line>` in
    // the file must not push it up or down.
    final layout = LayoutEngine(font: font).layout(buildTabScore(), width: 120);
    final staff = layout.systems.single.staves.single;
    final clef = staff.elements.firstWhere(
      (element) => element.role == ElementRole.clef,
    );
    final geometry = staff.geometry;
    expect(
      clef.bounds.center.dy,
      closeTo((geometry.lineY(1) + geometry.lineY(6)) / 2, 0.1),
    );
  });
}
