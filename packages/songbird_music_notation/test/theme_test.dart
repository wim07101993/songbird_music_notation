import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// The score's theme: what it is drawn in, as opposed to where things go.
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

  /// A style with nothing left at its default, so that a field copyWith forgets
  /// shows up as a difference rather than hiding behind the value it would
  /// have had anyway.
  const customised = EngravingStyle(
    staffLineCount: 4,
    staffDistance: 9,
    systemDistance: 13,
    partDistance: 11,
    systemLeftMargin: 2,
    pageMargin: 7,
    minimumNoteSpacing: 2.1,
    spacingExponent: 0.55,
    spacingWidth: 4.4,
    stemLength: 3.6,
    minimumStemLength: 2.6,
    ledgerLineExtension: 0.45,
    accidentalGap: 0.25,
    dotGap: 0.4,
    dotSpacing: 0.55,
    articulationGap: 0.55,
    lyricGap: 1.3,
    lyricLineHeight: 2.3,
    lyricFontSize: 1.7,
    textFontSize: 1.9,
    titleFontSize: 4.5,
    subtitleFontSize: 2.3,
    partNameFontSize: 1.8,
    slurHeight: 1.5,
    tupletBracketHeight: 1.3,
    barlineGap: 1.4,
    measureLeftPadding: 1.5,
    clefGap: 1.1,
    keyGap: 0.45,
    timeGap: 1.5,
    graceNoteScale: 0.65,
    cueNoteScale: 0.8,
    colors: NotationColors(ink: Color(0xFF102030)),
    fonts: NotationFonts(lyrics: 'Georgia', text: 'Inter'),
  );

  group('copyWith', () {
    test('an empty copy of a customised style changes nothing', () {
      // Which is only true if every field reaches copyWith. A field left out
      // silently falls back to its default, and this is what notices.
      expect(customised.copyWith(), customised);
    });

    test('an empty copy of a customised palette changes nothing', () {
      const colors = NotationColors(
        ink: Color(0xFF111111),
        staffLines: Color(0xFF222222),
        selection: Color(0xFF333333),
        selectionFill: Color(0x44444444),
        hover: Color(0x55555555),
        cursor: Color(0xFF666666),
        editorial: Color(0xFF777777),
        background: Color(0xFF888888),
        voices: {2: Color(0xFF999999)},
        honourSourceColors: false,
      );
      expect(colors.copyWith(), colors);
    });

    test('changing the background leaves the ink alone', () {
      // The case that started this: taking the dark palette, putting a light
      // background on it, and finding light notes on a light page.
      final swapped = NotationColors.dark.copyWith(
        background: const Color(0xFFFFFFFF),
      );
      expect(swapped.background, const Color(0xFFFFFFFF));
      expect(swapped.ink, NotationColors.dark.ink);
      // Both are settable at once, which is what that case actually wants.
      final both = NotationColors.dark.copyWith(
        background: const Color(0xFFFFFFFF),
        ink: const Color(0xFF000000),
      );
      expect(both.ink, const Color(0xFF000000));
      expect(both.staffLines, NotationColors.dark.staffLines);
    });

    test('changes one field without disturbing the rest', () {
      final wider = customised.copyWith(staffDistance: 20);
      expect(wider.staffDistance, 20);
      expect(
        wider.copyWith(staffDistance: customised.staffDistance),
        customised,
      );
    });
  });

  group('fonts', () {
    test('lyrics and everything else can be set apart', () {
      const fonts = NotationFonts(lyrics: 'Georgia', text: 'Inter');
      expect(fonts.familyFor(ElementRole.lyric), 'Georgia');
      expect(fonts.familyFor(ElementRole.dynamics), 'Inter');
      expect(fonts.familyFor(ElementRole.partName), 'Inter');
      expect(fonts.familyFor(ElementRole.text), 'Inter');
    });

    test('one family can be given for all of it', () {
      const fonts = NotationFonts.all('Inter');
      expect(fonts.familyFor(ElementRole.lyric), 'Inter');
      expect(fonts.familyFor(ElementRole.text), 'Inter');
    });

    test('a style carries its fonts through the font it is measured with', () {
      final style = EngravingStyle.fromFont(
        font,
        fonts: const NotationFonts(lyrics: 'Georgia'),
      );
      expect(style.fonts.lyrics, 'Georgia');
      expect(style.withFont(font).fonts.lyrics, 'Georgia');
    });
  });

  group('colours are chosen while painting', () {
    ScorePainter painterFor(Score score, EngravingStyle style) => ScorePainter(
      layout: LayoutEngine(font: font, style: style).layout(score, width: 120),
      font: font,
      style: style,
      staffSpace: 8,
    );

    Score twoVoices({String? noteColor}) {
      final part = Part(id: 'P1', name: 'Piano');
      final measure = Measure(number: '1')
        ..attributes.time = TimeSignature.simple(4, 4)
        ..attributes.clefs[1] = Clef.treble;
      for (final voice in [1, 2]) {
        measure.add(
          Chord(
            position: Fraction.zero,
            voice: voice,
            notes: [
              Note(
                pitch: Pitch(Step.c, voice == 1 ? 5 : 4),
                color: voice == 2 ? noteColor : null,
              ),
            ],
            rhythm: const RhythmicDuration(NoteType.whole),
          ),
        );
      }
      part.measures.add(measure);
      return Score(parts: [part]);
    }

    LayoutElement noteheadOf(ScorePainter painter, int voice) =>
        painter.layout.systems.first.staves.first.elements.firstWhere(
          (element) =>
              element.role == ElementRole.notehead &&
              (element.owner! as Chord).voice == voice,
        );

    test('a voice can be given a colour of its own', () {
      const red = Color(0xFFCC2222);
      final painter = painterFor(
        twoVoices(),
        EngravingStyle.fromFont(
          font,
          colors: const NotationColors(voices: {2: red}),
        ),
      );
      expect(painter.inkFor(noteheadOf(painter, 2)), red);
      // The other voice is left in ink, which is what makes the coloured one
      // stand out.
      expect(
        painter.inkFor(noteheadOf(painter, 1)),
        const NotationColors().ink,
      );
    });

    test('a colour written into the file is used by default', () {
      final painter = painterFor(
        twoVoices(noteColor: '#00A000'),
        EngravingStyle.fromFont(font),
      );
      expect(painter.inkFor(noteheadOf(painter, 2)), const Color(0xFF00A000));
    });

    test("a dark palette can refuse the file's own colours", () {
      // An exporter writing color="#000000" on every note makes a dark page
      // unreadable, and no choice of palette fixes it while the file is being
      // obeyed.
      final style = EngravingStyle.fromFont(
        font,
        colors: NotationColors.dark.copyWith(honourSourceColors: false),
      );
      final painter = painterFor(twoVoices(noteColor: '#000000'), style);
      expect(painter.inkFor(noteheadOf(painter, 2)), NotationColors.dark.ink);
    });

    test('a voice colour beats a colour from the file', () {
      const blue = Color(0xFF2255CC);
      final style = EngravingStyle.fromFont(
        font,
        colors: const NotationColors(voices: {2: blue}),
      );
      final painter = painterFor(twoVoices(noteColor: '#00A000'), style);
      expect(painter.inkFor(noteheadOf(painter, 2)), blue);
    });

    test('a slur takes the colour of the voice it belongs to', () {
      const red = Color(0xFFCC2222);
      final part = Part(id: 'P1', name: 'Voice');
      final measure = Measure(number: '1')
        ..attributes.time = TimeSignature.simple(4, 4)
        ..attributes.clefs[1] = Clef.treble;
      final chords = [
        for (final beat in [0, 1])
          Chord(
            position: Fraction(beat, 4),
            voice: 2,
            notes: [Note(pitch: Pitch(Step.c, 5 - beat))],
            rhythm: const RhythmicDuration(NoteType.quarter),
          ),
      ];
      for (final chord in chords) {
        measure.add(chord);
      }
      part
        ..measures.add(measure)
        ..spanners.add(Slur(start: chords.first, end: chords.last));

      final painter = painterFor(
        Score(parts: [part]),
        EngravingStyle.fromFont(
          font,
          colors: const NotationColors(voices: {2: red}),
        ),
      );
      final slur = painter.layout.systems.first.staves.first.elements
          .firstWhere((element) => element.role == ElementRole.slur);
      expect(painter.inkFor(slur), red);
    });

    test('staff lines follow their own colour, not the ink', () {
      final style = EngravingStyle.fromFont(font, colors: NotationColors.dark);
      final painter = painterFor(twoVoices(), style);
      final line = painter.layout.systems.first.staves.first.elements
          .firstWhere((element) => element.role == ElementRole.staffLine);
      expect(painter.inkFor(line), NotationColors.dark.staffLines);
    });

    test('a palette swap does not need the score engraving again', () {
      // Nothing the theme decides is baked into the layout, so the same
      // layout answers for either palette.
      final layout = LayoutEngine(font: font).layout(twoVoices(), width: 120);
      final notehead = layout.systems.first.staves.first.elements.firstWhere(
        (element) => element.role == ElementRole.notehead,
      );
      Color inkWith(NotationColors colors) => ScorePainter(
        layout: layout,
        font: font,
        style: EngravingStyle.fromFont(font, colors: colors),
        staffSpace: 8,
      ).inkFor(notehead);

      expect(inkWith(const NotationColors()), const NotationColors().ink);
      expect(inkWith(NotationColors.dark), NotationColors.dark.ink);
    });
  });
}
