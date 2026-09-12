import 'package:xml/xml.dart';

/// Thrown when a document is not valid MusicXML in a way the reader cannot
/// work around.
///
/// Real-world MusicXML is often slightly invalid, so the reader recovers where
/// it can; this is raised only when something the schema requires is missing
/// and nothing sensible can stand in for it.
class MusicXmlFormatException implements Exception {
  MusicXmlFormatException(
    this.message, {
    this.element,
  });

  final String message;

  /// The element being read when the problem was found.
  final XmlElement? element;

  /// The path from the document root to [element], for locating the problem.
  String get path {
    final parts = <String>[];
    XmlNode? node = element;
    while (node is XmlElement) {
      parts.insert(0, node.name.local);
      node = node.parent;
    }
    return parts.join('/');
  }

  @override
  String toString() => element == null
      ? 'MusicXmlFormatException: $message'
      : 'MusicXmlFormatException: $message (at $path)';
}

/// The first child element of [parent] named [name], or `null`.
XmlElement? xmlElement(XmlElement parent, String name) {
  for (final child in parent.childElements) {
    if (child.name.local == name) return child;
  }
  return null;
}

/// The first child element named [name], or a descriptive failure.
XmlElement xmlRequiredElement(XmlElement parent, String name) {
  final child = xmlElement(parent, name);
  if (child == null) {
    throw MusicXmlFormatException(
      'required element <$name> is missing',
      element: parent,
    );
  }
  return child;
}

/// Every child element of [parent] named [name], in document order.
List<XmlElement> xmlElements(XmlElement parent, String name) => [
  for (final child in parent.childElements)
    if (child.name.local == name) child,
];

/// Every child element of [parent], in document order.
List<XmlElement> xmlChildren(XmlElement parent) =>
    parent.childElements.toList();

/// The text of the first child element named [name], or `null`.
String? xmlElementText(XmlElement parent, String name) =>
    xmlElement(parent, name)?.innerText;

/// [value], or a descriptive failure if it is `null`.
T xmlRequiredValue<T>(T? value, String what, XmlElement element) {
  if (value == null) {
    throw MusicXmlFormatException(
      'missing or unreadable $what',
      element: element,
    );
  }
  return value;
}

/// Reads an integer, tolerating the surrounding whitespace and the trailing
/// decimals some exporters write.
int? xmlInt(String? text) {
  if (text == null) return null;
  final trimmed = text.trim();
  if (trimmed.isEmpty) return null;
  final parsed = int.tryParse(trimmed);
  if (parsed != null) return parsed;
  return double.tryParse(trimmed)?.round();
}

double? xmlDouble(String? text) {
  if (text == null) return null;
  final trimmed = text.trim();
  return trimmed.isEmpty ? null : double.tryParse(trimmed);
}

/// Reads a MusicXML `yes-no` value.
bool? xmlBool(String? text) {
  if (text == null) return null;
  return switch (text.trim().toLowerCase()) {
    'yes' || 'true' || '1' => true,
    'no' || 'false' || '0' => false,
    _ => null,
  };
}

/// Formats a number the way MusicXML does, without a pointless `.0`.
String xmlNumberText(num value) {
  if (value is int) return '$value';
  if (value == value.roundToDouble() && value.abs() < 1e15) {
    return '${value.toInt()}';
  }
  return '$value';
}

/// An element containing only [text].
XmlElement xmlTextElement(String name, String text) =>
    XmlElement(XmlName(name), const [], [XmlText(text)]);
