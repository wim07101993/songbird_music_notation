# Songbird Music Notation

Read, render and edit music notation in Dart and Flutter.

```dart
final score = const MusicXmlReader().read(await file.readAsString());
final controller = ScoreController(score: score);

Column(
  children: [
    ScoreToolbar(controller: controller),
    Expanded(child: MusicScoreEditor(controller: controller)),
  ],
);
```

That gives a score on the screen that can be read, zoomed, transposed and
edited, with undo — and written back out as MusicXML.

## The packages

Four packages, each usable on its own.

| Package | Depends on | What it is |
| --- | --- | --- |
| [`songbird_score`](packages/songbird_score) | nothing | The model: parts, measures, chords, rests, directions. Exact rational durations, spelling-aware transposition, accidental resolution, automatic beaming, and an undoable edit command stack. Pure Dart. |
| [`songbird_musicxml`](packages/songbird_musicxml) | `songbird_score` | MusicXML 4.0 in and out, compressed `.mxl` included. A document model generated from the official XSD, plus the mapping to and from the score model. Pure Dart. |
| [`songbird_smufl`](packages/songbird_smufl) | Flutter | SMuFL music-font support: every glyph name from the specification, the font metadata model, and the Bravura font bundled ready to use. |
| [`songbird_music_notation`](packages/songbird_music_notation) | the other three | The layout engine, the painter, and the widgets — viewing, zooming, transposing, selecting and editing. |

The split is deliberate. A server that transposes MusicXML needs only the first
two and never links Flutter. A renderer for another format — LilyPond,
ABC — targets the same model and gets the engraving for free. And the model
knows nothing about the file it came from, so nothing about MusicXML leaks into
the way music is described.

## What it does

**Reading.** The whole of MusicXML 4.0: 97 enumerations and 254 element types
generated from the published schema, so a file can be read and written back
without losing anything the schema can express. Reading resolves MusicXML's
`<backup>`/`<forward>` cursor into absolute positions and its numbered
start/stop markings into direct references, and reports what it had to work
around in files that are not quite valid.

**Engraving.** Staff layout in staff spaces, from the font's own published
measurements: notehead placement by clef, accidental columns, ledger lines,
stem direction and length, beam grouping and slope, slurs and ties as tapered
curves, tuplet brackets, hairpins, lyrics on a shared baseline with hyphens
between syllables, and duration-proportional horizontal spacing that also
leaves room for the words underneath.

**Editing.** Every change is a command with an inverse, so undo and redo are
exact and a held arrow key is one step rather than fifty. Notes can be dragged,
typed, retimed, deleted, articulated and given lyrics; measures, keys, clefs
and time signatures can be changed.

**Transposing.** Spelling-aware: up a minor third from A is C, not B sharp, and
the key signature moves with the notes.

**Big scores.** Layout is cached on the width, so scrolling and repainting
never re-engrave. Dragging a window edge does change the width, once a frame,
and a symphony takes longer than a frame to engrave — set
`deferRelayoutSlowerThan` on the controller and the last engraving is drawn
again while the edge is moving, with another made once it settles. It is off
by default so that nothing engraves on a timer unless it was asked to.

**Lines and numbering.** A system takes what fits and is justified to the
margin; `measuresPerSystem` breaks every four measures instead, which is what a
hymn book or a folk collection wants. Measure numbers are printed at the start
of every system by default, and `MeasureNumbering.none` or
`MeasureNumbering.every(5)` says otherwise.

**Theming.** `EngravingStyle` is the score's theme, and every field of it can
be changed one at a time. Colours — ink, staff lines, background, selection,
the caret, editorial marks — are independent of each other rather than derived
from a brightness, so a warm page with dark brown ink is as easy to ask for as
either of the two built-in palettes. Voices can be given colours of their own,
which is how two hands on one staff are told apart without reading the stems.
Lyrics and the rest of the text can be set in different faces; the notes come
from whichever SMuFL font is handed to the layout.

Nothing the theme decides is baked into the layout, so swapping a palette
repaints without engraving the score again. A colour written into a MusicXML
file is honoured by default and can be refused with
`colors.copyWith(honourSourceColors: false)` — which is what makes a dark
palette survive a file whose notes were all exported as black.

**Chord symbols.** Read from `<harmony>`, written back out, printed above the
staff on one line, and transposed with the part they belong to — a part moved
up while its symbols stayed behind is telling a player two different things.
The sharps and flats come from the music font, since a text face mostly does
not carry one.

**Choosing what to read.** Any part can be hidden, which is how a thirty-stave
conductor's score becomes the two lines someone actually wants in front of
them. Hiding changes only what is drawn: the music stays in the score, stays
editable through the filtered view, and is written back out in full.

**Zooming.** From 25% to 600%, by button, slider, pinch or ctrl-scroll. The
music fills the space it is given and reflows as it grows, as a continuous view
should; a page width can be capped if that suits better.

## Try it

```sh
cd example
flutter run
```

The example opens a score, switches between reading and editing, writes notes,
transposes, zooms, and saves back to MusicXML.

The music-library button also carries a showcase score built to exercise the
marks that go wrong when they go wrong — a braced grand staff, C clefs and a
clef change, repeats, hairpins under a keyboard, a tuplet, ornaments and a
fermata — in four measures, so a look at it says whether they are where they
belong.

It starts on Greensleeves — two parts, eight measures — which says nothing about
how any of this behaves under load. The music-library button in the toolbar
generates a full orchestra with chorus instead: thirty-three parts, two of them
on two staves, at sixteen, a hundred and twenty-eight, or five hundred and
twelve measures. The status bar along the bottom says what the last engraving
cost, which changes whenever the window is resized or the zoom moves. Scrolling
does not re-engrave anything, so it stays cheap however long the score is.

## The MusicXML sample set

The official examples — Dichterliebe, the Mozart quintet, a Binchois
Magnificat, an orchestral prelude — are the best thing to test a reader
against, and they are not in this repository. The page they come from carries
MakeMusic's copyright and says the copyright holders gave permission to
include the samples *on that site*, which is permission to host rather than
permission to pass on. Fetch them for yourself:

```sh
tool/fetch_musicxml_samples.sh
```

They land in `samples/`, which git ignores. The example's music-library menu
lists whatever is there, so they can be read straight from it, and
`samples_test.dart` reads and engraves every one of them when it finds them. That test is what turned
up UTF-16 MusicXML — two of the samples are written in it.

## Development

The repository is a pub workspace: one `flutter pub get` at the root resolves
everything.

```sh
flutter pub get
dart analyze
dart test packages/songbird_score packages/songbird_musicxml
cd packages/songbird_music_notation && flutter test
```

Two parts of the code are generated and checked in:

```sh
cd packages/songbird_musicxml && dart run tool/generate_dom.dart
cd packages/songbird_smufl   && dart run tool/generate_glyph_names.dart
```

The MusicXML XSD and the SMuFL metadata they read from live beside them in
`tool/`.

## Credits

The [Bravura](https://github.com/steinbergmedia/bravura) font is © Steinberg
Media Technologies GmbH, redistributed under the SIL Open Font License 1.1; the
licence travels with it in `packages/songbird_smufl/assets/fonts/`.

The MusicXML schema is published by the W3C Music Notation Community Group
under the W3C Community Final Specification Agreement.
