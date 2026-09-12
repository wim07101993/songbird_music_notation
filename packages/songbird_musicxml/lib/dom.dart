/// The MusicXML 4.0 document model, generated from the official XSD.
///
/// One class per complex type and one enum per enumerated simple type, each
/// able to read itself from an `XmlElement` and write itself back. Use this to
/// reach a part of MusicXML the musical model does not carry — harmony
/// symbols, figured bass, page layout, MIDI settings — or to build a document
/// by hand.
///
/// Many of these names — `Note`, `Pitch`, `Clef`, `Key`, `Offset` — collide
/// with `songbird_score` and with `dart:ui`. Import it with a prefix:
///
/// ```dart
/// import 'package:songbird_musicxml/dom.dart' as musicxml;
///
/// final pitch = musicxml.Pitch(step: musicxml.Step.c, octave: 4);
/// ```
library;

export 'src/dom/elements.g.dart';
export 'src/dom/enums.g.dart';
export 'src/dom/xml_support.dart';
