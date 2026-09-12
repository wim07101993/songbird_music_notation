/// Reads and writes MusicXML 4.0.
///
/// ```dart
/// final score = const MusicXmlReader().read(await file.readAsString());
/// score.transpose(Interval.named(2, IntervalQuality.major));
/// await file.writeAsString(const MusicXmlWriter().write(score));
/// ```
///
/// Two layers sit underneath. The document model mirrors the official XSD
/// element for element, so a file can be read and written back without losing
/// anything the schema can express. On top of it, [MusicXmlReader] and
/// [MusicXmlWriter] translate between that and the musical model in
/// `songbird_score`, resolving MusicXML's measure cursor into absolute
/// positions and its numbered start/stop markings into direct references.
///
/// This library exposes the second layer, which is what most callers want. The
/// document model lives in `package:songbird_musicxml/dom.dart`: it defines a
/// class per schema type, and several of those — `Note`, `Pitch`, `Clef` — take
/// names the musical model also uses, so it is kept out of the way and imported
/// deliberately, with a prefix.
library;

export 'src/document.dart';
export 'src/dom/xml_support.dart' show MusicXmlFormatException;
export 'src/mapping/reader.dart';
export 'src/mapping/writer.dart';
