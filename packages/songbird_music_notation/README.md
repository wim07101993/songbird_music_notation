# songbird_music_notation

Renders and edits music notation in Flutter.

```dart
final controller = ScoreController(score: score);

Column(
  children: [
    ScoreToolbar(controller: controller),
    Expanded(child: MusicScoreEditor(controller: controller)),
  ],
);
```

For a score that should only be read, use `MusicScoreView` instead. The two
share a `ScoreController`, so a reader and an editor can be swapped without
losing the zoom level or the selection.

## The controller

`ScoreController` owns everything that outlives a frame — the score, the zoom,
the selection, the undo history — so a toolbar button, a keyboard shortcut and
a pinch gesture all drive the same state.

```dart
controller.zoomIn();
controller.setStaffHeight(40);                      // logical pixels
controller.transposeBySemitones(-2);
controller.transposeToKey(const KeySignature(fifths: -1));
controller.undo();
```

Transposition is spelling-aware and undoable, and the key signature moves with
the notes.

## Editing

`MusicScoreEditor` offers three tools — select and drag, write notes, erase —
and these shortcuts while focused:

| Key                                | Effect                               |
|------------------------------------|--------------------------------------|
| Arrow up/down                      | move the selected notes by a step    |
| Shift + arrow up/down              | move them by an octave               |
| Arrow left/right                   | select the next or previous note     |
| `+` / `-`                          | raise or lower by a semitone         |
| 1 … 7                              | set the duration, whole through 64th |
| `.`                                | toggle a dot                         |
| Delete                             | replace with a rest                  |
| `L`                                | type lyrics under the selected note  |
| `K`                                | type a chord symbol above it         |
| Ctrl/Cmd + Z, Ctrl/Cmd + Shift + Z | undo, redo                           |
| Ctrl/Cmd + `+` / `-` / `0`         | zoom in, out, reset                  |

`L` and `K` open a caret where the text is printed — no box and no
placeholder, since it stands in for engraved text. Space or Enter stores what
has been typed and moves to the next note, so a verse is typed straight
through; in lyrics a hyphen does the same and joins the syllable to the next,
turning `hap-py` into one hyphenated word. Escape stops, and anything typed is
stored when the caret leaves, so clicking away or closing the editor keeps the
words rather than dropping them.

Double-clicking a word or a chord symbol already in the score opens it for
editing, which is also how to reach a verse other than the one `L` writes
into.

Anything the widget can do is also available as a method, so an application's
own buttons make the same undoable edits:

```dart
final actions = ScoreEditActions(controller);
actions.setDuration(NoteType.eighth);
actions.toggleArticulation(Articulation.staccato);
actions.setLyric('sing', verse: 1);
actions.setChordSymbol('F#m7');
```

Chord symbols are read from the text the way a chart writes them — `C`, `Am7`,
`Bbmaj7`, `Cmaj7/E` — accepting the spellings people actually type (`min7`,
`-7` and `m7` are the same chord). A quality this library has no name for is
kept verbatim and printed as typed, so an unusual chart is not flattened into
the nearest thing it recognises.

## Underneath

`LayoutEngine` turns a score into a `ScoreLayout`: a tree of positioned glyphs,
lines and curves measured in staff spaces, each carrying a reference to the
model object it came from. `ScorePainter` draws it, multiplying by the staff
space on the way to the canvas — which is why zooming does not re-engrave the
music.

Both are usable without a widget, for printing or for exporting an image:

```dart
final layout = LayoutEngine(font: font).layout(score, width: 140);
final image = await renderScoreToImage(
  layout: layout, font: font, style: style, staffSpace: 12,
);
```

The layout is also what hit testing works on, so a click resolves to a
notehead, and a click on empty staff resolves to a measure, a beat and a pitch:

```dart
final hit = layout.hitTest(point);            // hit.note, hit.event
final target = resolvePointer(layout: layout, point: point);
```

The score fills whatever space the widget is given, reflowing as the zoom
changes. To keep systems from stretching across a very wide window, cap the
width instead:

```dart
ScoreController(score: score, maxPageWidth: 140);   // staff spaces
```

## Appearance

`EngravingStyle` holds every distance in staff spaces, so one style describes a
score at any zoom. Line weights come from the font's own published defaults —
a stem at Bravura's 0.12 spaces next to a Bravura notehead is what makes a page
look engraved rather than assembled.

```dart
controller.style = EngravingStyle(
  staffDistance: 10,
  spacingWidth: 4.5,
  colors: NotationColors.dark,
);
```
