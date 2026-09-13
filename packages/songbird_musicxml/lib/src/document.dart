import 'dart:convert';
import 'dart:typed_data';

import 'package:archive/archive.dart';
import 'package:songbird_musicxml/src/dom/elements.g.dart';
import 'package:songbird_musicxml/src/dom/xml_support.dart';
import 'package:xml/xml.dart';

/// MusicXML comes in two arrangements of the same information.
enum MusicXmlLayout {
  /// Parts contain measures. This is what nearly every application writes.
  partwise,

  /// Measures contain parts, which suits score-following and analysis.
  timewise,
}

/// A parsed MusicXML document, in whichever of the two arrangements it used.
///
/// Reading gives back the document as the file had it; [toPartwise] converts a
/// timewise document so that callers only have to handle one shape.
class MusicXmlDocument {
  MusicXmlDocument.partwise(
    ScorePartwise score,
  ) : layout = MusicXmlLayout.partwise,
      partwise = score,
      timewise = null;

  MusicXmlDocument.timewise(
    ScoreTimewise score,
  ) : layout = MusicXmlLayout.timewise,
      partwise = null,
      timewise = score;

  /// Parses MusicXML source text.
  factory MusicXmlDocument.parse(
    String source,
  ) {
    final document = XmlDocument.parse(source);
    final root = document.rootElement;
    switch (root.name.local) {
      case 'score-partwise':
        return MusicXmlDocument.partwise(ScorePartwise.fromXml(root));
      case 'score-timewise':
        return MusicXmlDocument.timewise(ScoreTimewise.fromXml(root));
      default:
        throw MusicXmlFormatException(
          'expected <score-partwise> or <score-timewise>, '
          'found <${root.name.local}>',
          element: root,
        );
    }
  }

  /// Reads a document from bytes, unpacking it first if it is a compressed
  /// `.mxl` container.
  ///
  /// A `.mxl` file is a zip whose `META-INF/container.xml` names the score to
  /// read; falling back to the first `.xml` outside `META-INF` handles the
  /// files whose container is missing or wrong, which does happen.
  factory MusicXmlDocument.fromBytes(
    List<int> bytes,
  ) {
    if (_looksCompressed(bytes)) {
      return MusicXmlDocument.parse(_extractFromContainer(bytes));
    }
    return MusicXmlDocument.parse(_decodeText(bytes));
  }

  /// Which arrangement the document uses.
  final MusicXmlLayout layout;

  /// The score, when the document is partwise.
  final ScorePartwise? partwise;

  /// The score, when the document is timewise.
  final ScoreTimewise? timewise;

  /// The document as a partwise score, converting it if necessary.
  ScorePartwise toPartwise() {
    final existing = partwise;
    if (existing != null) return existing;
    final source = timewise!;

    // A timewise score lists, for each measure, what every part does. Turning
    // it inside out means collecting each part's measures in measure order.
    final partIds = <String>[];
    final measuresByPart = <String, List<ScorePartwisePartMeasure>>{};
    for (final measure in source.measure) {
      for (final part in measure.part) {
        final id = part.id;
        if (!measuresByPart.containsKey(id)) {
          partIds.add(id);
          measuresByPart[id] = [];
        }
        measuresByPart[id]!.add(
          ScorePartwisePartMeasure(
            number: measure.number,
            items: part.items,
            text: measure.text,
            implicit: measure.implicit,
            nonControlling: measure.nonControlling,
            width: measure.width,
            id: measure.id,
          ),
        );
      }
    }

    return ScorePartwise(
      work: source.work,
      movementNumber: source.movementNumber,
      movementTitle: source.movementTitle,
      identification: source.identification,
      defaults: source.defaults,
      credit: source.credit,
      partList: source.partList,
      part: [
        for (final id in partIds)
          ScorePartwisePart(id: id, measure: measuresByPart[id]),
      ],
      version: source.version,
    );
  }

  /// The document as XML.
  XmlDocument toXmlDocument() {
    final root = switch (layout) {
      MusicXmlLayout.partwise => partwise!.toXml(),
      MusicXmlLayout.timewise => timewise!.toXml(),
    };
    final doctype = switch (layout) {
      MusicXmlLayout.partwise =>
        'score-partwise PUBLIC "-//Recordare//DTD MusicXML 4.0 Partwise//EN" '
            '"http://www.musicxml.org/dtds/partwise.dtd"',
      MusicXmlLayout.timewise =>
        'score-timewise PUBLIC "-//Recordare//DTD MusicXML 4.0 Timewise//EN" '
            '"http://www.musicxml.org/dtds/timewise.dtd"',
    };
    return XmlDocument([
      XmlDeclaration([
        XmlAttribute(const XmlName.parts('version'), '1.0'),
        XmlAttribute(const XmlName.parts('encoding'), 'UTF-8'),
      ]),
      XmlDoctype(doctype),
      root,
    ]);
  }

  /// The document as MusicXML text.
  String toXmlString({bool pretty = true}) =>
      toXmlDocument().toXmlString(pretty: pretty, indent: '  ');

  /// The document as a compressed `.mxl` container.
  Uint8List toCompressedBytes({String scoreFileName = 'score.musicxml'}) {
    final archive = Archive()
      ..addFile(
        ArchiveFile.string(
          'META-INF/container.xml',
          _containerXml(scoreFileName),
        ),
      )
      ..addFile(ArchiveFile.string(scoreFileName, toXmlString()));
    final encoded = ZipEncoder().encode(archive);
    return Uint8List.fromList(encoded);
  }

  static bool _looksCompressed(List<int> bytes) =>
      bytes.length >= 2 && bytes[0] == 0x50 && bytes[1] == 0x4B;

  static String _extractFromContainer(List<int> bytes) {
    final archive = ZipDecoder().decodeBytes(bytes);
    final named = <String, ArchiveFile>{
      for (final file in archive.files)
        if (file.isFile) file.name: file,
    };

    String? path;
    final container = named['META-INF/container.xml'];
    if (container != null) {
      try {
        final document = XmlDocument.parse(
          _decodeText(container.readBytes() ?? const []),
        );
        for (final rootFile in document.findAllElements('rootfile')) {
          final candidate = rootFile.getAttribute('full-path');
          if (candidate != null && named.containsKey(candidate)) {
            path = candidate;
            break;
          }
        }
      } on XmlException {
        // A broken container is no reason to give up; fall through to the
        // guess below.
      }
    }

    path ??= named.keys.firstWhere(
      (name) =>
          !name.startsWith('META-INF/') &&
          (name.endsWith('.xml') || name.endsWith('.musicxml')),
      orElse: () => throw MusicXmlFormatException(
        'the archive contains no MusicXML file',
      ),
    );

    final file = named[path];
    if (file == null) {
      throw MusicXmlFormatException('the archive has no entry named "$path"');
    }
    return _decodeText(file.readBytes() ?? const []);
  }

  /// Decodes bytes as UTF-8, tolerating a byte-order mark and falling back to
  /// Latin-1 for the older files that are not valid UTF-8.
  /// Reads [bytes] as text, working out what they are written in.
  ///
  /// A MusicXML file says its encoding in its own declaration, which is no
  /// help until the declaration has been read. The byte order mark is: UTF-16
  /// is allowed by the specification and used by real files — two of the
  /// official sample scores are written in it — and a reader that only ever
  /// tries UTF-8 rejects them as corrupt.
  static String _decodeText(List<int> bytes) {
    var data = bytes;

    if (data.length >= 2) {
      final first = data[0];
      final second = data[1];
      if (first == 0xFF && second == 0xFE) {
        return _decodeUtf16(data.sublist(2), bigEndian: false);
      }
      if (first == 0xFE && second == 0xFF) {
        return _decodeUtf16(data.sublist(2), bigEndian: true);
      }
    }

    if (data.length >= 3 &&
        data[0] == 0xEF &&
        data[1] == 0xBB &&
        data[2] == 0xBF) {
      data = data.sublist(3);
    }
    try {
      return utf8.decode(data);
    } on FormatException {
      return latin1.decode(data, allowInvalid: true);
    }
  }

  /// Decodes UTF-16 code units, joining surrogate pairs so that anything
  /// outside the basic plane survives the trip.
  static String _decodeUtf16(List<int> bytes, {required bool bigEndian}) {
    final units = <int>[];
    for (var i = 0; i + 1 < bytes.length; i += 2) {
      units.add(
        bigEndian
            ? (bytes[i] << 8) | bytes[i + 1]
            : (bytes[i + 1] << 8) | bytes[i],
      );
    }
    return String.fromCharCodes(units);
  }

  static String _containerXml(String path) =>
      '<?xml version="1.0" encoding="UTF-8"?>\n'
      '<container>\n'
      '  <rootfiles>\n'
      '    <rootfile full-path="$path" '
      'media-type="application/vnd.recordare.musicxml+xml"/>\n'
      '  </rootfiles>\n'
      '</container>\n';
}
