// Model of the parts of XML Schema the MusicXML XSD actually uses, plus the
// naming rules that turn schema names into Dart names.
//
// Used only by tool/generate_dom.dart.
import 'package:analyzer/dart/ast/token.dart';
import 'package:xml/xml.dart';

const String xs = 'http://www.w3.org/2001/XMLSchema';

/// A field of a generated class: an attribute, a child element, the text value
/// of a simple-content type, or the ordered item list of a repeated choice.
enum FieldKind { attribute, element, textValue, items }

class SchemaField {
  SchemaField({
    required this.kind,
    required this.xmlName,
    required this.dartName,
    required this.dartType,
    required this.isList,
    required this.isNullable,
    required this.isComplex,
    this.isEnum = false,
    this.defaultValue,
    this.documentation,
    this.namespacePrefix,
  });

  final FieldKind kind;

  /// The name as it appears in the XML document.
  final String xmlName;

  final String dartName;

  /// The Dart type without any `?` or `List<>` wrapper.
  final String dartType;

  final bool isList;
  final bool isNullable;

  /// Whether the type is a generated class, as opposed to an enum or a
  /// primitive.
  final bool isComplex;

  final bool isEnum;
  final String? defaultValue;
  final String? documentation;

  /// Set for the handful of attributes that live in the xml: or xlink:
  /// namespaces.
  final String? namespacePrefix;

  /// The same field under a different Dart name, for resolving a clash.
  SchemaField renamed(String newDartName) => SchemaField(
    kind: kind,
    xmlName: xmlName,
    dartName: newDartName,
    dartType: dartType,
    isList: isList,
    isNullable: isNullable,
    isComplex: isComplex,
    isEnum: isEnum,
    defaultValue: defaultValue,
    documentation: documentation,
    namespacePrefix: namespacePrefix,
  );

  String get qualifiedXmlName =>
      namespacePrefix == null ? xmlName : '$namespacePrefix:$xmlName';

  /// The declared Dart type including nullability.
  String get declaredType {
    if (isList) return 'List<$dartType>';
    return isNullable ? '$dartType?' : dartType;
  }
}

class SchemaEnum {
  SchemaEnum({
    required this.name,
    required this.dartName,
    required this.values,
    this.documentation,
  });

  final String name;
  final String dartName;

  /// XML value to Dart member name.
  final Map<String, String> values;

  final String? documentation;
}

class SchemaClass {
  SchemaClass({
    required this.name,
    required this.dartName,
    required this.fields,
    this.documentation,
    this.defaultElementName,
    this.isItemUnion = false,
  });

  final String name;
  final String dartName;
  final List<SchemaField> fields;
  final String? documentation;

  /// The element name to use when writing this type without being told one.
  final String? defaultElementName;

  /// True for the generated classes that stand for one item of a repeated
  /// content model, which read and write themselves by element name rather
  /// than being given one.
  final bool isItemUnion;

  Iterable<SchemaField> get attributes =>
      fields.where((f) => f.kind == FieldKind.attribute);

  Iterable<SchemaField> get elements => fields.where(
    (f) => f.kind == FieldKind.element || f.kind == FieldKind.items,
  );

  SchemaField? get textValue {
    for (final field in fields) {
      if (field.kind == FieldKind.textValue) return field;
    }
    return null;
  }
}

/// Names in XML Schema are kebab-case; Dart wants camelCase for members and
/// PascalCase for types.
String camelCase(String name) {
  // Schema names are kebab-case, but a few enumeration values are plain
  // English with spaces ("bass drum") or carry punctuation, so split on
  // anything that is not part of an identifier.
  final parts = name.split(RegExp('[^A-Za-z0-9]+'));
  final buffer = StringBuffer(
    parts.first.isEmpty ? '' : _lowerFirst(parts.first),
  );
  for (final part in parts.skip(1)) {
    if (part.isEmpty) continue;
    buffer.write(_upperFirst(part));
  }
  final result = buffer.toString();
  return result.isEmpty ? 'value' : result;
}

String pascalCase(String name) => _upperFirst(camelCase(name));

/// Names that a generated type or member must not take, because Dart already
/// uses them for something every file can see.
const Set<String> dartCoreNames = {
  'String',
  'int',
  'double',
  'bool',
  'num',
  'List',
  'Map',
  'Set',
  'Object',
  'Function',
  'Type',
  'Symbol',
  'Iterable',
  'Duration',
  'Comparable',
  'Pattern',
  'Record',
  'Enum',
  'Never',
  'Null',
  'DateTime',
  'Uri',
  'Error',
  'Exception',
  'StringBuffer',
  'Future',
  'Stream',
  'Match',
  'Sink',
  'BigInt',
  'RegExp',
  'Iterator',
  'MapEntry',
  'StackTrace',
};

/// The Dart class name for a schema type.
///
/// MusicXML has a `string` type — the guitar string — which would otherwise
/// shadow `dart:core`'s.
String dartTypeName(String schemaName) {
  final name = pascalCase(schemaName);
  return dartCoreNames.contains(name) ? '${name}Element' : name;
}

String _upperFirst(String value) =>
    value.isEmpty ? value : value[0].toUpperCase() + value.substring(1);

String _lowerFirst(String value) =>
    value.isEmpty ? value : value[0].toLowerCase() + value.substring(1);

/// Words that cannot be used as a Dart identifier, straight from the
/// analyzer's own table.
///
/// Only reserved words are excluded. Built-in identifiers such as `part` and
/// `augment`, and contextual keywords such as `on` and `sync`, are legal as
/// member names, and MusicXML uses several of them — `score.part` reads better
/// than `score.partValue`. They are illegal as *type* names, which cannot
/// arise here because every generated type name starts with a capital.
final Set<String> dartReserved = {
  for (final keyword in Keyword.values)
    if (keyword.isReservedWord) keyword.lexeme,
};

/// Members that would clash with something every Dart object or enum already
/// has.
const Set<String> reservedMembers = {
  'hashCode',
  'runtimeType',
  'toString',
  'noSuchMethod',
  'index',
  'values',
  'name',
  'toXml',
  'fromXml',
};

String safeMemberName(String name, {bool isEnumMember = false}) {
  var result = camelCase(name);
  if (RegExp('^[0-9]').hasMatch(result)) result = 'n$result';
  if (dartReserved.contains(result)) result = '${result}Value';
  // MusicXML's <double> element would otherwise shadow the type `double` for
  // every other field of the same class.
  if (dartCoreNames.contains(result)) result = '${result}Value';
  if (isEnumMember && reservedMembers.contains(result)) {
    result = '${result}Value';
  }
  if (!isEnumMember &&
      (result == 'hashCode' ||
          result == 'runtimeType' ||
          result == 'toString')) {
    result = '${result}Value';
  }
  return result;
}

/// Reads the `<xs:documentation>` of a schema node as a single doc comment.
String? documentationOf(XmlElement element) {
  final annotation = element.getElement('annotation', namespace: xs);
  final doc = annotation?.getElement('documentation', namespace: xs);
  final text = doc?.innerText.trim();
  if (text == null || text.isEmpty) return null;
  return text;
}

/// Wraps [text] as a Dart doc comment at [indent] spaces.
String docComment(String? text, int indent) {
  if (text == null || text.isEmpty) return '';
  final pad = ' ' * indent;
  final lines = <String>[];
  for (final paragraph in text.split(RegExp(r'\n\s*\n'))) {
    final collapsed = paragraph.replaceAll(RegExp(r'\s+'), ' ').trim();
    if (collapsed.isEmpty) continue;
    if (lines.isNotEmpty) lines.add('');
    lines.addAll(_wrap(collapsed, 74 - indent));
  }
  return lines
      .map((line) => line.isEmpty ? '$pad///' : '$pad/// $line')
      .join('\n');
}

List<String> _wrap(String text, int width) {
  final words = text.split(' ');
  final lines = <String>[];
  var current = StringBuffer();
  for (final word in words) {
    if (current.isEmpty) {
      current.write(word);
    } else if (current.length + 1 + word.length <= width) {
      current.write(' $word');
    } else {
      lines.add(current.toString());
      current = StringBuffer(word);
    }
  }
  if (current.isNotEmpty) lines.add(current.toString());
  return lines;
}
