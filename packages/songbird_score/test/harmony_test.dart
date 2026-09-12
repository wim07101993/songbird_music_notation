import 'package:songbird_score/songbird_score.dart';
import 'package:test/test.dart';

Measure _measure() => Measure(number: '1');

void main() {
  group('reading a typed chord symbol', () {
    Harmony? parse(String text) =>
        Harmony.parseSymbol(text, position: Fraction.zero);

    test('a bare letter is a major chord', () {
      final harmony = parse('C')!;
      expect(harmony.root.step, Step.c);
      expect(harmony.root.alter, 0);
      expect(harmony.kind, ChordKind.major);
      expect(harmony.symbol, 'C');
    });

    test('sharps and flats belong to the root', () {
      expect(parse('F#')!.root.alter, 1);
      expect(parse('Bb')!.root.alter, -1);
      expect(parse('Cx')!.root.alter, 2);
      expect(parse('Bbb')!.root.alter, -2);
    });

    test('the quality follows the root', () {
      expect(parse('Am')!.kind, ChordKind.minor);
      expect(parse('G7')!.kind, ChordKind.dominant);
      expect(parse('Cmaj7')!.kind, ChordKind.majorSeventh);
      expect(parse('Dsus4')!.kind, ChordKind.suspendedFourth);
    });

    test('the spellings people actually type mean the same chord', () {
      for (final text in ['Am', 'Amin', 'A-']) {
        expect(parse(text)!.kind, ChordKind.minor, reason: text);
      }
      for (final text in ['Cmaj7', 'CM7', 'CMa7']) {
        expect(parse(text)!.kind, ChordKind.majorSeventh, reason: text);
      }
      expect(parse('Bø')!.kind, ChordKind.halfDiminished);
      expect(parse('Bo7')!.kind, ChordKind.diminishedSeventh);
    });

    test('a bass note comes after the slash', () {
      final harmony = parse('Cmaj7/E')!;
      expect(harmony.root.step, Step.c);
      expect(harmony.kind, ChordKind.majorSeventh);
      expect(harmony.bass!.step, Step.e);
      expect(harmony.symbol, 'Cmaj7/E');
    });

    test('a slash chord over an altered bass keeps the accidental', () {
      expect(parse('G/B')!.bass!.alter, 0);
      expect(parse('D/F#')!.bass!.alter, 1);
    });

    test('a quality nobody knows is kept exactly as typed', () {
      final harmony = parse('C7alt')!;
      expect(harmony.kind, ChordKind.other);
      expect(harmony.text, '7alt');
      expect(harmony.symbol, 'C7alt');
    });

    test('text that does not name a chord is refused', () {
      expect(parse(''), isNull);
      expect(parse('   '), isNull);
      expect(parse('H7'), isNull);
      expect(parse('hello'), isNull);
      expect(parse('C/H'), isNull);
    });

    test('a symbol survives being written out and read back', () {
      for (final text in ['C', 'F#m7', 'Bbmaj7', 'G/B', 'Am7b5', 'C7alt']) {
        final first = parse(text)!;
        final again = parse(first.symbol)!;
        expect(again.symbol, first.symbol, reason: text);
        expect(again.kind, first.kind, reason: text);
      }
    });
  });

  group('writing a chord symbol into a measure', () {
    late Score score;
    late Measure measure;
    late ScoreEditor editor;

    setUp(() {
      measure = _measure();
      score = Score(
        parts: [
          Part(id: 'P1', name: 'Chords', measures: [measure]),
        ],
      );
      editor = ScoreEditor(score);
    });

    Harmony? symbolInMeasure() =>
        measure.events.whereType<Harmony>().firstOrNull;

    test('writing where there was nothing adds one', () {
      editor.execute(
        SetChordSymbolCommand(
          measure: measure,
          position: Fraction.zero,
          symbol: 'Am7',
        ),
      );
      expect(symbolInMeasure()!.symbol, 'Am7');

      editor.undo();
      expect(symbolInMeasure(), isNull);

      editor.redo();
      expect(symbolInMeasure()!.symbol, 'Am7');
    });

    test('writing over one that is there changes it in place', () {
      editor
        ..execute(
          SetChordSymbolCommand(
            measure: measure,
            position: Fraction.zero,
            symbol: 'Am7',
          ),
        )
        ..execute(
          SetChordSymbolCommand(
            measure: measure,
            position: Fraction.zero,
            symbol: 'D7',
          ),
        );
      expect(measure.events.whereType<Harmony>(), hasLength(1));
      expect(symbolInMeasure()!.symbol, 'D7');

      editor.undo();
      expect(symbolInMeasure()!.symbol, 'Am7');
    });

    test('emptying the text removes the symbol', () {
      editor
        ..execute(
          SetChordSymbolCommand(
            measure: measure,
            position: Fraction.zero,
            symbol: 'Am7',
          ),
        )
        ..execute(
          SetChordSymbolCommand(
            measure: measure,
            position: Fraction.zero,
            symbol: '',
          ),
        );
      expect(symbolInMeasure(), isNull);

      editor.undo();
      expect(symbolInMeasure()!.symbol, 'Am7');
    });

    test('two beats hold two symbols of their own', () {
      editor
        ..execute(
          SetChordSymbolCommand(
            measure: measure,
            position: Fraction.zero,
            symbol: 'C',
          ),
        )
        ..execute(
          SetChordSymbolCommand(
            measure: measure,
            position: Fraction.half,
            symbol: 'G',
          ),
        );
      expect(
        measure.events.whereType<Harmony>().map((h) => h.symbol),
        ['C', 'G'],
      );
    });

    test('text that names no chord is refused before it is run', () {
      final command = SetChordSymbolCommand(
        measure: measure,
        position: Fraction.zero,
        symbol: 'not a chord',
      );
      expect(command.isValid, isFalse);
    });
  });
}
