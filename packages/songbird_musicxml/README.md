# songbird_musicxml

Reads and writes MusicXML 4.0, in pure Dart.

```dart
import 'package:songbird_musicxml/songbird_musicxml.dart';

final score = const MusicXmlReader().read(await file.readAsString());
score.transpose(Interval.named(2, IntervalQuality.major));
await file.writeAsString(const MusicXmlWriter().write(score));
```

Compressed `.mxl` containers work too:

```dart
final score = const MusicXmlReader().readBytes(await file.readAsBytes());
await file.writeAsBytes(const MusicXmlWriter().writeCompressed(score));
```

## Two layers

The **document model** mirrors the official XSD element for element: 97
enumerations and 254 classes, generated from the schema, each able to read
itself from an `XmlElement` and write itself back. It lives in its own library
because several of its names — `Note`, `Pitch`, `Clef`, `Offset` — collide with
the musical model and with `dart:ui`:

```dart
import 'package:songbird_musicxml/dom.dart' as musicxml;

final document = MusicXmlDocument.parse(source);
for (final credit in document.toPartwise().credit) { /* ... */ }
```

Use it to reach a part of MusicXML the musical model does not carry — harmony
symbols, figured bass, page layout, MIDI settings — or to build a document by
hand.

The **mapping layer** is what most callers want. `MusicXmlReader` resolves the
measure cursor into absolute positions and numbered start/stop markings into
direct references; `MusicXmlWriter` puts both back, choosing a `<divisions>`
that keeps every duration a whole number.

## Files that are not quite right

Real-world MusicXML is frequently a little wrong — a missing duration, a tie
that never stops, a clef on a staff the part does not have. Reading recovers
from all of those and says what it had to do:

```dart
final result = const MusicXmlReader()
    .readDocument(MusicXmlDocument.parse(source));
for (final warning in result.warnings) {
  print(warning);   // 'a tie ends on C5 without starting'
}
```

## Regenerating the document model

`tool/musicxml.xsd` is the schema verbatim from
[w3c/musicxml](https://github.com/w3c/musicxml).

```sh
dart run tool/generate_dom.dart
```
