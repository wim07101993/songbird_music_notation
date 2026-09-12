// Generates the typed MusicXML document model from the official XSD.
//
//   dart run tool/generate_dom.dart
//
// Writes lib/src/dom/enums.g.dart and lib/src/dom/elements.g.dart. The schema is
// tool/musicxml.xsd, taken verbatim from https://github.com/w3c/musicxml.
//
// The generator covers the subset of XML Schema that MusicXML uses: simple
// types with enumerations and restrictions, complex types with simple or
// element content, groups, attribute groups, and single-level extension. The
// schema uses no wildcards and no substitution groups, so nothing here has to
// deal with them.
import 'dart:io';

import 'package:xml/xml.dart';

import 'schema.dart';

void main(List<String> args) {
  final root = Directory.fromUri(Platform.script.resolve('.'));
  final schemaFile = File('${root.path}/musicxml.xsd');
  final document = XmlDocument.parse(schemaFile.readAsStringSync());
  final generator = DomGenerator(document.rootElement);
  generator.run();

  final libDir = Directory('${root.parent.path}/lib/src/dom');
  libDir.createSync(recursive: true);
  File('${libDir.path}/enums.g.dart').writeAsStringSync(generator.emitEnums());
  File(
    '${libDir.path}/elements.g.dart',
  ).writeAsStringSync(generator.emitClasses());

  stdout.writeln(
    'Generated ${generator.enums.length} enums and '
    '${generator.classes.length} classes from MusicXML ${generator.version}.',
  );
}

class DomGenerator {
  DomGenerator(
    this.schema,
  );

  final XmlElement schema;

  final Map<String, XmlElement> simpleTypes = {};
  final Map<String, XmlElement> complexTypes = {};
  final Map<String, XmlElement> groups = {};
  final Map<String, XmlElement> attributeGroups = {};
  final Map<String, XmlElement> topLevelElements = {};

  final List<SchemaEnum> enums = [];
  final List<SchemaClass> classes = [];

  /// Schema type name to the Dart type it maps to.
  final Map<String, String> _dartTypeOfSimpleType = {};
  final Set<String> _emittedClassNames = {};

  /// Item classes already emitted, keyed by the set of elements they hold.
  final Map<String, String> _itemClassBySignature = {};

  String version = '4.0';

  void run() {
    for (final child in schema.childElements) {
      final name = child.getAttribute('name');
      if (name == null) continue;
      switch (child.localName) {
        case 'simpleType':
          simpleTypes[name] = child;
        case 'complexType':
          complexTypes[name] = child;
        case 'group':
          groups[name] = child;
        case 'attributeGroup':
          attributeGroups[name] = child;
        case 'element':
          topLevelElements[name] = child;
      }
    }

    for (final entry in simpleTypes.entries) {
      _resolveSimpleType(entry.key);
    }
    for (final entry in complexTypes.entries) {
      _buildClass(
        name: entry.key,
        dartName: dartTypeName(entry.key),
        definition: entry.value,
        documentation: documentationOf(entry.value),
      );
    }
    for (final entry in topLevelElements.entries) {
      final inline = entry.value.getElement('complexType', namespace: xs);
      if (inline == null) continue;
      _buildClass(
        name: entry.key,
        dartName: dartTypeName(entry.key),
        definition: inline,
        documentation: documentationOf(entry.value) ?? documentationOf(inline),
        defaultElementName: entry.key,
      );
    }
  }

  // ---------------------------------------------------------------- simple

  /// The Dart type a schema type maps to, generating an enum on the way if the
  /// type restricts a set of values.
  String _resolveSimpleType(String name) {
    final cached = _dartTypeOfSimpleType[name];
    if (cached != null) return cached;

    if (name.startsWith('xs:')) return _builtin(name);

    final definition = simpleTypes[name];
    if (definition == null) {
      // A complex type used where a simple one was expected does not occur in
      // this schema, so anything unknown is text.
      return 'String';
    }

    // Guard against a cycle while the type is being resolved.
    _dartTypeOfSimpleType[name] = 'String';

    final restriction = definition.getElement('restriction', namespace: xs);
    if (restriction != null) {
      final enumerations = restriction
          .findElements('enumeration', namespace: xs)
          .toList();
      if (enumerations.isNotEmpty) {
        final dartName = dartTypeName(name);
        final values = <String, String>{};
        final used = <String>{};
        for (final enumeration in enumerations) {
          final value = enumeration.getAttribute('value') ?? '';
          var member = safeMemberName(value, isEnumMember: true);
          var suffix = 2;
          while (used.contains(member)) {
            member = '${safeMemberName(value, isEnumMember: true)}$suffix';
            suffix++;
          }
          used.add(member);
          values[value] = member;
        }
        enums.add(
          SchemaEnum(
            name: name,
            dartName: dartName,
            values: values,
            documentation: documentationOf(definition),
          ),
        );
        _dartTypeOfSimpleType[name] = dartName;
        return dartName;
      }
      final base = restriction.getAttribute('base') ?? 'xs:string';
      final resolved = _resolveSimpleType(base);
      _dartTypeOfSimpleType[name] = resolved;
      return resolved;
    }

    // A union of a number and a keyword, such as font-size or yes-no-number.
    // Keeping the text is lossless and lets the caller decide how to read it.
    _dartTypeOfSimpleType[name] = 'String';
    return 'String';
  }

  String _builtin(String name) => switch (name) {
    'xs:decimal' || 'xs:float' || 'xs:double' => 'double',
    'xs:integer' ||
    'xs:positiveInteger' ||
    'xs:nonNegativeInteger' ||
    'xs:int' => 'int',
    'xs:boolean' => 'bool',
    _ => 'String',
  };

  bool _isEnumType(String dartType) =>
      enums.any((element) => element.dartName == dartType);

  // --------------------------------------------------------------- complex

  void _buildClass({
    required String name,
    required String dartName,
    required XmlElement definition,
    String? documentation,
    String? defaultElementName,
  }) {
    if (!_emittedClassNames.add(dartName)) return;
    final fields = <SchemaField>[];

    var repeatedOwner = _repeatedContentOwner(definition, name);
    if (repeatedOwner == null && _hasDuplicateElementNames(definition, name)) {
      // The same element name appears twice in the content model, as
      // <metronome> does with the two <beat-unit> of a metric modulation.
      // Named fields would both read the first occurrence, so this type is
      // handled as an ordered list too.
      repeatedOwner = name;
    }
    if (repeatedOwner != null) {
      // Something in this type's content repeats, and a repeated choice or
      // sequence carries meaning in its order: `<music-data>` is what makes a
      // measure a measure. Named fields would lose that order, and would also
      // double up wherever an element name appears both inside the repeated
      // part and outside it, which `credit` and `lyric` both do. So the whole
      // element content becomes one ordered list instead.
      _collectAttributesOnly(definition, fields);
      fields.add(
        _buildItemsField(definition, owner: name, itemOwner: repeatedOwner),
      );
    } else {
      _collectContent(
        definition,
        fields,
        owner: name,
        optional: false,
        list: false,
      );
    }

    classes.add(
      SchemaClass(
        name: name,
        dartName: dartName,
        fields: _disambiguate(fields),
        documentation: documentation,
        defaultElementName: defaultElementName,
      ),
    );
  }

  /// Resolves two fields that would take the same Dart name.
  ///
  /// `<barline>` has both a `segno` child element and a `segno` attribute, so
  /// the attribute takes an `Attribute` suffix and the element keeps the plain
  /// name.
  List<SchemaField> _disambiguate(List<SchemaField> fields) {
    final taken = <String>{};
    final result = <SchemaField>[];
    for (final field in fields) {
      if (taken.add(field.dartName)) {
        result.add(field);
        continue;
      }
      var candidate = field.kind == FieldKind.attribute
          ? '${field.dartName}Attribute'
          : '${field.dartName}Element';
      var suffix = 2;
      while (!taken.add(candidate)) {
        candidate = '${field.dartName}$suffix';
        suffix++;
      }
      result.add(field.renamed(candidate));
    }
    return result;
  }

  /// Whether flattening this type's content would produce two fields reading
  /// the same element name.
  bool _hasDuplicateElementNames(XmlElement definition, String owner) {
    final probe = <SchemaField>[];
    _collectContent(
      definition,
      probe,
      owner: owner,
      optional: false,
      list: false,
    );
    final seen = <String>{};
    for (final field in probe) {
      if (field.kind != FieldKind.element) continue;
      if (!seen.add(field.xmlName)) return true;
    }
    return false;
  }

  /// The name to build the item class from: the group that owns the repeating
  /// particle where there is one, so that `music-data` yields a single
  /// `MusicDataItem` shared by parts and measures rather than one class per
  /// enclosing type.
  String? _repeatedContentOwner(
    XmlElement node,
    String owner, [
    Set<String>? seenGroups,
  ]) {
    for (final child in node.childElements) {
      switch (child.localName) {
        case 'sequence':
        case 'choice':
        case 'all':
          if (_isRepeated(child)) return owner;
          final nested = _repeatedContentOwner(child, owner, seenGroups);
          if (nested != null) return nested;
        case 'group':
          final ref = child.getAttribute('ref');
          if (ref == null) continue;
          if (_isRepeated(child)) return ref;
          final definition = groups[ref];
          if (definition == null) continue;
          final seen = seenGroups ?? <String>{};
          if (!seen.add(ref)) continue;
          final nested = _repeatedContentOwner(definition, ref, seen);
          if (nested != null) return nested;
        case 'simpleContent':
        case 'complexContent':
        case 'extension':
          final nested = _repeatedContentOwner(child, owner, seenGroups);
          if (nested != null) return nested;
      }
    }
    return null;
  }

  /// Collects only the attributes of a type, for the classes whose element
  /// content is handled as an item list.
  void _collectAttributesOnly(XmlElement definition, List<SchemaField> fields) {
    for (final child in definition.childElements) {
      switch (child.localName) {
        case 'attribute':
          final field = _attributeField(child);
          if (field != null) fields.add(field);
        case 'attributeGroup':
          _collectAttributeGroupRef(child, fields);
        case 'simpleContent':
        case 'complexContent':
          _collectAttributesOnly(child, fields);
        case 'extension':
          _collectAttributesOnly(child, fields);
      }
    }
  }

  /// Builds the `items` field of a type with repeated content, generating the
  /// item class that lists every element the content may hold.
  ///
  /// Two types with identical content share one item class — `<part>` and
  /// `<measure>` both hold `music-data`, and one `MusicDataItem` serves both.
  /// Types whose content merely starts with the same group do not: `<time>`
  /// and `<interchangeable>` share the `time-signature` group but `<time>`
  /// can also hold `<senza-misura>`, so they get a class each.
  SchemaField _buildItemsField(
    XmlElement definition, {
    required String owner,
    required String itemOwner,
  }) {
    final collected = <SchemaField>[];
    // Collecting with `list: true` flattens every nested repeat instead of
    // nesting another item class inside this one.
    _collectContent(
      definition,
      collected,
      owner: itemOwner,
      optional: true,
      list: true,
    );
    final branches = <String, SchemaField>{};
    for (final field in collected) {
      if (field.kind != FieldKind.element) continue;
      branches.putIfAbsent(
        field.xmlName,
        () => SchemaField(
          kind: FieldKind.element,
          xmlName: field.xmlName,
          dartName: field.dartName,
          dartType: field.dartType,
          isList: false,
          isNullable: true,
          isComplex: field.isComplex,
          isEnum: field.isEnum,
          documentation: field.documentation,
        ),
      );
    }

    final signature = branches.values
        .map((f) => '${f.xmlName}:${f.dartType}')
        .join('|');
    final existing = _itemClassBySignature[signature];
    if (existing != null) {
      return _itemsFieldNamed(existing);
    }

    // Name the class after the group only when the group is the whole content,
    // so that a type adding elements of its own does not borrow the name.
    final preferred = _contentIsOnlyGroup(definition, itemOwner)
        ? itemOwner
        : owner;
    var itemClassName = '${dartTypeName(preferred)}Item';
    var suffix = 2;
    while (!_emittedClassNames.add(itemClassName)) {
      itemClassName = '${dartTypeName(preferred)}Item$suffix';
      suffix++;
    }
    _itemClassBySignature[signature] = itemClassName;

    classes.add(
      SchemaClass(
        name: '$preferred-item',
        dartName: itemClassName,
        fields: _disambiguate(branches.values.toList()),
        isItemUnion: true,
        documentation:
            'One child element of `$preferred`. Exactly one field is set, '
            'naming which element it was. Holding the content as a list of '
            'these keeps the order the document had, which the music '
            'depends on.',
      ),
    );
    return _itemsFieldNamed(itemClassName);
  }

  SchemaField _itemsFieldNamed(String itemClassName) => SchemaField(
    kind: FieldKind.items,
    xmlName: '',
    dartName: 'items',
    dartType: itemClassName,
    isList: true,
    isNullable: false,
    isComplex: true,
    documentation: 'The element content, in document order.',
  );

  /// Whether a type's element content is nothing but a reference to one group.
  bool _contentIsOnlyGroup(XmlElement definition, String groupName) {
    final particles = [
      for (final child in definition.childElements)
        if (child.localName != 'annotation' &&
            child.localName != 'attribute' &&
            child.localName != 'attributeGroup')
          child,
    ];
    if (particles.length != 1) return false;
    final only = particles.single;
    if (only.localName == 'group') return only.getAttribute('ref') == groupName;
    // A sequence wrapping a single group reference counts too.
    if (only.localName != 'sequence') return false;
    final inner = [
      for (final child in only.childElements)
        if (child.localName != 'annotation') child,
    ];
    return inner.length == 1 &&
        inner.single.localName == 'group' &&
        inner.single.getAttribute('ref') == groupName;
  }

  /// Walks the body of a complex type, adding a field for everything it can
  /// contain.
  void _collectContent(
    XmlElement definition,
    List<SchemaField> fields, {
    required String owner,
    required bool optional,
    required bool list,
  }) {
    for (final child in definition.childElements) {
      switch (child.localName) {
        case 'simpleContent':
          _collectSimpleContent(child, fields);
        case 'complexContent':
          _collectComplexContent(child, fields, owner: owner);
        case 'sequence':
        case 'choice':
        case 'all':
          _collectParticle(
            child,
            fields,
            owner: owner,
            optional: optional,
            list: list,
          );
        case 'group':
          _collectGroupRef(
            child,
            fields,
            owner: owner,
            optional: optional,
            list: list,
          );
        case 'attribute':
          final field = _attributeField(child);
          if (field != null) fields.add(field);
        case 'attributeGroup':
          _collectAttributeGroupRef(child, fields);
      }
    }
  }

  /// An element with text content and attributes, such as `<beam number="1">`.
  void _collectSimpleContent(
    XmlElement simpleContent,
    List<SchemaField> fields,
  ) {
    final extension =
        simpleContent.getElement('extension', namespace: xs) ??
        simpleContent.getElement('restriction', namespace: xs);
    if (extension == null) return;
    final base = extension.getAttribute('base') ?? 'xs:string';
    final dartType = _resolveSimpleType(base);
    fields.add(
      SchemaField(
        kind: FieldKind.textValue,
        xmlName: 'value',
        dartName: 'value',
        dartType: dartType,
        isList: false,
        isNullable: false,
        isComplex: false,
        isEnum: _isEnumType(dartType),
        documentation: "The element's text content.",
      ),
    );
    for (final child in extension.childElements) {
      switch (child.localName) {
        case 'attribute':
          final field = _attributeField(child);
          if (field != null) fields.add(field);
        case 'attributeGroup':
          _collectAttributeGroupRef(child, fields);
      }
    }
  }

  /// A type extending another. The base's fields are copied rather than
  /// inherited: the five extensions in this schema add attributes to otherwise
  /// empty types, and flattening keeps the generated code free of a class
  /// hierarchy that would earn nothing.
  void _collectComplexContent(
    XmlElement complexContent,
    List<SchemaField> fields, {
    required String owner,
  }) {
    final extension = complexContent.getElement('extension', namespace: xs);
    if (extension == null) return;
    final base = extension.getAttribute('base');
    if (base != null) {
      final baseDefinition = complexTypes[base];
      if (baseDefinition != null) {
        _collectContent(
          baseDefinition,
          fields,
          owner: base,
          optional: false,
          list: false,
        );
      }
    }
    _collectContent(
      extension,
      fields,
      owner: owner,
      optional: false,
      list: false,
    );
  }

  void _collectGroupRef(
    XmlElement reference,
    List<SchemaField> fields, {
    required String owner,
    required bool optional,
    required bool list,
  }) {
    final ref = reference.getAttribute('ref');
    if (ref == null) return;
    final definition = groups[ref];
    if (definition == null) return;
    final isOptional = optional || _minOccurs(reference) == 0;
    final isList = list || _isRepeated(reference);
    for (final child in definition.childElements) {
      if (child.localName == 'annotation') continue;
      _collectParticle(
        child,
        fields,
        owner: ref,
        optional: isOptional,
        list: isList,
      );
    }
  }

  void _collectAttributeGroupRef(
    XmlElement reference,
    List<SchemaField> fields,
  ) {
    final ref = reference.getAttribute('ref');
    if (ref == null) return;
    final definition = attributeGroups[ref];
    if (definition == null) return;
    for (final child in definition.childElements) {
      switch (child.localName) {
        case 'attribute':
          final field = _attributeField(child);
          if (field != null) fields.add(field);
        case 'attributeGroup':
          _collectAttributeGroupRef(child, fields);
      }
    }
  }

  /// Adds fields for one particle — a sequence, a choice or an element.
  ///
  /// Nesting is flattened: an element inside an optional choice inside a
  /// sequence becomes an optional field. Types whose content repeats never
  /// reach here, because [_buildClass] sends those down the item-list path
  /// instead.
  void _collectParticle(
    XmlElement particle,
    List<SchemaField> fields, {
    required String owner,
    required bool optional,
    required bool list,
  }) {
    switch (particle.localName) {
      case 'sequence':
      case 'choice':
      case 'all':
        final repeated = list || _isRepeated(particle);
        final isOptional =
            optional ||
            _minOccurs(particle) == 0 ||
            particle.localName == 'choice';
        for (final child in particle.childElements) {
          if (child.localName == 'annotation') continue;
          _collectParticle(
            child,
            fields,
            owner: owner,
            optional: isOptional,
            list: repeated,
          );
        }
      case 'group':
        _collectGroupRef(
          particle,
          fields,
          owner: owner,
          optional: optional,
          list: list,
        );
      case 'element':
        final field = _elementField(
          particle,
          owner: owner,
          optional: optional,
          list: list,
        );
        if (field != null) fields.add(field);
    }
  }

  SchemaField? _elementField(
    XmlElement element, {
    required String owner,
    required bool optional,
    required bool list,
  }) {
    final name = element.getAttribute('name');
    if (name == null) return null;

    final isList = list || _isRepeated(element);
    final isOptional = optional || _minOccurs(element) == 0;

    final inlineComplex = element.getElement('complexType', namespace: xs);
    String dartType;
    var isComplex = false;
    if (inlineComplex != null) {
      dartType = dartTypeName('$owner-$name');
      _buildClass(
        name: '$owner-$name',
        dartName: dartType,
        definition: inlineComplex,
        documentation:
            documentationOf(element) ?? documentationOf(inlineComplex),
        defaultElementName: name,
      );
      isComplex = true;
    } else {
      final typeName = element.getAttribute('type') ?? 'xs:string';
      if (complexTypes.containsKey(typeName)) {
        dartType = dartTypeName(typeName);
        isComplex = true;
      } else {
        dartType = _resolveSimpleType(typeName);
      }
    }

    return SchemaField(
      kind: FieldKind.element,
      xmlName: name,
      dartName: safeMemberName(name),
      dartType: dartType,
      isList: isList,
      isNullable: isOptional && !isList,
      isComplex: isComplex,
      isEnum: !isComplex && _isEnumType(dartType),
      documentation: documentationOf(element),
    );
  }

  SchemaField? _attributeField(XmlElement attribute) {
    final ref = attribute.getAttribute('ref');
    if (ref != null) {
      // The schema imports four xml: and six xlink: attributes; they are plain
      // strings and need no type of their own.
      final parts = ref.split(':');
      final local = parts.last;
      return SchemaField(
        kind: FieldKind.attribute,
        xmlName: local,
        dartName: safeMemberName('${parts.first}-$local'),
        dartType: 'String',
        isList: false,
        isNullable: true,
        isComplex: false,
        namespacePrefix: parts.length > 1 ? parts.first : null,
        documentation: 'The `$ref` attribute.',
      );
    }

    final name = attribute.getAttribute('name');
    if (name == null) return null;
    final typeName = attribute.getAttribute('type') ?? 'xs:string';
    final dartType = _resolveSimpleType(typeName);
    final required = attribute.getAttribute('use') == 'required';
    return SchemaField(
      kind: FieldKind.attribute,
      xmlName: name,
      dartName: safeMemberName(name),
      dartType: dartType,
      isList: false,
      isNullable: !required,
      isComplex: false,
      isEnum: _isEnumType(dartType),
      defaultValue: attribute.getAttribute('default'),
      documentation: documentationOf(attribute),
    );
  }

  int _minOccurs(XmlElement element) =>
      int.tryParse(element.getAttribute('minOccurs') ?? '1') ?? 1;

  bool _isRepeated(XmlElement element) {
    final max = element.getAttribute('maxOccurs');
    if (max == null) return false;
    if (max == 'unbounded') return true;
    return (int.tryParse(max) ?? 1) > 1;
  }

  // ----------------------------------------------------------------- emit

  String emitEnums() {
    final buffer = StringBuffer()
      ..writeln('// dart format off')
      ..writeln('//')
      ..writeln('// GENERATED FILE - do not edit by hand.')
      ..writeln('//')
      ..writeln('// Regenerate with:')
      ..writeln('//   dart run tool/generate_dom.dart')
      ..writeln('//')
      ..writeln('// Source: the MusicXML $version XSD, tool/musicxml.xsd.')
      ..writeln()
      ..writeln('/// The enumerated types of the MusicXML schema.')
      ..writeln('library;')
      ..writeln();

    final sorted = [...enums]..sort((a, b) => a.dartName.compareTo(b.dartName));
    for (final schemaEnum in sorted) {
      final doc = docComment(schemaEnum.documentation, 0);
      if (doc.isNotEmpty) buffer.writeln(doc);
      buffer.writeln('enum ${schemaEnum.dartName} {');
      final entries = schemaEnum.values.entries.toList();
      for (var i = 0; i < entries.length; i++) {
        final entry = entries[i];
        final terminator = i == entries.length - 1 ? ';' : ',';
        buffer.writeln("  ${entry.value}('${_escape(entry.key)}')$terminator");
      }
      buffer
        ..writeln()
        ..writeln('  const ${schemaEnum.dartName}(this.xmlValue);')
        ..writeln()
        ..writeln('  /// The value as it appears in a MusicXML document.')
        ..writeln('  final String xmlValue;')
        ..writeln()
        ..writeln('  /// The member matching [value], or `null` if none does.')
        ..writeln('  static ${schemaEnum.dartName}? parse(String? value) {')
        ..writeln('    if (value == null) return null;')
        ..writeln('    for (final member in ${schemaEnum.dartName}.values) {')
        ..writeln('      if (member.xmlValue == value) return member;')
        ..writeln('    }')
        ..writeln('    return null;')
        ..writeln('  }')
        ..writeln('}')
        ..writeln();
    }
    return buffer.toString();
  }

  String emitClasses() {
    final buffer = StringBuffer()
      ..writeln('// dart format off')
      ..writeln('//')
      ..writeln('// GENERATED FILE - do not edit by hand.')
      ..writeln('//')
      ..writeln('// Regenerate with:')
      ..writeln('//   dart run tool/generate_dom.dart')
      ..writeln('//')
      ..writeln('// Source: the MusicXML $version XSD, tool/musicxml.xsd.')
      ..writeln('//')
      ..writeln(
        '// Every complex type in the schema becomes a class that can read',
      )
      ..writeln(
        '// itself from an XmlElement and write itself back. The classes',
      )
      ..writeln('// mirror the schema exactly, so a document read and written')
      ..writeln(
        '// unchanged comes back the same; the musical meaning is added by',
      )
      ..writeln('// the mapping layer, not here.')
      ..writeln()
      ..writeln(
        '// ignore_for_file: unnecessary_this, lines_longer_than_80_chars',
      )
      ..writeln()
      ..writeln("import 'package:xml/xml.dart';")
      ..writeln()
      ..writeln("import 'enums.g.dart';")
      ..writeln("import 'xml_support.dart';")
      ..writeln();

    final sorted = [...classes]
      ..sort((a, b) => a.dartName.compareTo(b.dartName));
    for (final schemaClass in sorted) {
      buffer.write(_emitClass(schemaClass));
    }
    return buffer.toString();
  }

  String _emitClass(SchemaClass schemaClass) => schemaClass.isItemUnion
      ? _emitItemClass(schemaClass)
      : _emitPlainClass(schemaClass);

  String _emitPlainClass(SchemaClass schemaClass) {
    final buffer = StringBuffer();
    final doc = docComment(schemaClass.documentation, 0);
    if (doc.isNotEmpty) buffer.writeln(doc);
    buffer.writeln('class ${schemaClass.dartName} {');
    buffer.write(_emitConstructor(schemaClass));
    buffer.writeln();

    buffer.writeln('  /// Reads an instance from [element].');
    if (schemaClass.fields.isEmpty) {
      buffer
        ..writeln(
          '  factory ${schemaClass.dartName}.fromXml(XmlElement element) =>',
        )
        ..writeln('      ${schemaClass.dartName}();')
        ..writeln();
    } else {
      buffer
        ..writeln(
          '  factory ${schemaClass.dartName}.fromXml(XmlElement element) =>',
        )
        ..writeln('      ${schemaClass.dartName}(');
      for (final field in schemaClass.fields) {
        buffer.writeln('        ${field.dartName}: ${_readExpression(field)},');
      }
      buffer
        ..writeln('      );')
        ..writeln();
    }

    buffer.write(_emitFields(schemaClass));

    // Convenience getters over an item list, so that callers who only want one
    // kind of child do not have to filter the list themselves.
    final items = schemaClass.fields
        .where((f) => f.kind == FieldKind.items)
        .toList();
    for (final field in items) {
      final itemClass = classes.firstWhere((c) => c.dartName == field.dartType);
      for (final branch in itemClass.fields) {
        buffer
          ..writeln(
            docComment(
              'Every `${branch.xmlName}` child, in document order.',
              2,
            ),
          )
          ..writeln(
            '  List<${branch.dartType}> get ${branch.dartName}Elements => [',
          )
          ..writeln('    for (final item in items)')
          ..writeln(
            '      if (item.${branch.dartName} != null) item.${branch.dartName}!,',
          )
          ..writeln('  ];')
          ..writeln();
      }
    }

    final defaultName = schemaClass.defaultElementName;
    buffer
      ..writeln('  /// Writes this value as an element named [name].')
      ..writeln(
        '  XmlElement toXml(${defaultName == null ? 'String elementName' : "[String elementName = '$defaultName']"}) {',
      )
      ..writeln('    final node = XmlElement(XmlName(elementName));');
    for (final field in schemaClass.attributes) {
      buffer.writeln(_writeAttribute(field));
    }
    for (final field in schemaClass.fields) {
      switch (field.kind) {
        case FieldKind.textValue:
          buffer.writeln(
            '    node.children.add(XmlText(${_toTextExpression(field, field.dartName)}));',
          );
        case FieldKind.element:
        case FieldKind.items:
          buffer.writeln(_writeElement(field));
        case FieldKind.attribute:
          break;
      }
    }
    buffer
      ..writeln('    return node;')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();
    return buffer.toString();
  }

  /// Emits a class standing for one child of a repeated content model.
  ///
  /// It reads itself by looking at the element's name and writes itself back
  /// under that same name, which is what lets a list of them round-trip.
  String _emitItemClass(SchemaClass schemaClass) {
    final buffer = StringBuffer();
    final doc = docComment(schemaClass.documentation, 0);
    if (doc.isNotEmpty) buffer.writeln(doc);
    buffer.writeln('class ${schemaClass.dartName} {');
    buffer.write(_emitConstructor(schemaClass));
    buffer.writeln();

    buffer
      ..writeln('  /// Reads [element] if its name is one this content model')
      ..writeln('  /// allows, and returns `null` otherwise.')
      ..writeln(
        '  static ${schemaClass.dartName}? tryFromXml(XmlElement element) {',
      )
      ..writeln('    switch (element.name.local) {');
    for (final field in schemaClass.fields) {
      final value = field.isComplex
          ? '${field.dartType}.fromXml(element)'
          : _parseExpression(
              field,
              'element.innerText',
              nullable: false,
              rawIsNonNull: true,
            );
      buffer
        ..writeln("      case '${field.xmlName}':")
        ..writeln(
          '        return ${schemaClass.dartName}(${field.dartName}: $value);',
        );
    }
    buffer
      ..writeln('    }')
      ..writeln('    return null;')
      ..writeln('  }')
      ..writeln();

    buffer.write(_emitFields(schemaClass));

    buffer
      ..writeln('  /// The name of the element this item holds.')
      ..writeln('  String? get elementName {');
    for (final field in schemaClass.fields) {
      buffer.writeln(
        "    if (${field.dartName} != null) return '${field.xmlName}';",
      );
    }
    buffer
      ..writeln('    return null;')
      ..writeln('  }')
      ..writeln()
      ..writeln('  /// Writes the element this item holds, or `null` when it')
      ..writeln('  /// holds nothing.')
      ..writeln('  XmlElement? toXmlOrNull() {');
    for (final field in schemaClass.fields) {
      final write = field.isComplex
          ? "${field.dartName}!.toXml('${field.xmlName}')"
          : "xmlTextElement('${field.xmlName}', ${_toTextExpression(field, '${field.dartName}!')})";
      buffer.writeln('    if (${field.dartName} != null) return $write;');
    }
    buffer
      ..writeln('    return null;')
      ..writeln('  }')
      ..writeln('}')
      ..writeln();
    return buffer.toString();
  }

  String _emitConstructor(SchemaClass schemaClass) {
    if (schemaClass.fields.isEmpty) return '  ${schemaClass.dartName}();\n';
    final buffer = StringBuffer()..writeln('  ${schemaClass.dartName}({');
    for (final field in schemaClass.fields) {
      if (field.isList) {
        buffer.writeln('    List<${field.dartType}>? ${field.dartName},');
      } else if (field.isNullable) {
        buffer.writeln('    this.${field.dartName},');
      } else {
        buffer.writeln('    required this.${field.dartName},');
      }
    }
    final lists = schemaClass.fields.where((f) => f.isList).toList();
    if (lists.isEmpty) {
      buffer.writeln('  });');
    } else {
      final initializers = lists
          .map((f) => '${f.dartName} = ${f.dartName} ?? <${f.dartType}>[]')
          .join(',\n        ');
      buffer.writeln('  })  : $initializers;');
    }
    return buffer.toString();
  }

  String _emitFields(SchemaClass schemaClass) {
    final buffer = StringBuffer();
    for (final field in schemaClass.fields) {
      final fieldDoc = docComment(field.documentation, 2);
      if (fieldDoc.isNotEmpty) buffer.writeln(fieldDoc);
      buffer
        ..writeln('  ${field.declaredType} ${field.dartName};')
        ..writeln();
    }
    return buffer.toString();
  }

  String _readExpression(SchemaField field) {
    switch (field.kind) {
      case FieldKind.attribute:
        final raw = "element.getAttribute('${field.qualifiedXmlName}')";
        return _parseExpression(field, raw, nullable: field.isNullable);
      case FieldKind.textValue:
        return _parseExpression(
          field,
          'element.innerText',
          nullable: false,
          rawIsNonNull: true,
        );
      case FieldKind.items:
        return 'xmlChildren(element)\n'
            '            .map(${field.dartType}.tryFromXml)\n'
            '            .whereType<${field.dartType}>()\n'
            '            .toList()';
      case FieldKind.element:
        if (field.isList) {
          if (field.isComplex) {
            return "xmlElements(element, '${field.xmlName}')\n"
                '            .map(${field.dartType}.fromXml)\n'
                '            .toList()';
          }
          return "xmlElements(element, '${field.xmlName}')\n"
              '            .map((e) => ${_parseExpression(field, 'e.innerText', nullable: false, rawIsNonNull: true)})\n'
              '            .toList()';
        }
        if (field.isComplex) {
          final read = "xmlElement(element, '${field.xmlName}')";
          if (field.isNullable) {
            return 'switch ($read) {\n'
                '          final child? => ${field.dartType}.fromXml(child),\n'
                '          _ => null,\n'
                '        }';
          }
          return "${field.dartType}.fromXml(xmlRequiredElement(element, '${field.xmlName}'))";
        }
        final raw = "xmlElementText(element, '${field.xmlName}')";
        return _parseExpression(field, raw, nullable: field.isNullable);
    }
  }

  /// Turns raw text into the field's Dart type.
  ///
  /// A required value that cannot be read is an error worth naming rather than
  /// a silent default, except for numbers, where a missing value has an
  /// obvious zero to fall back on.
  String _parseExpression(
    SchemaField field,
    String raw, {
    required bool nullable,
    bool rawIsNonNull = false,
  }) {
    final fallback = field.defaultValue;
    if (field.isEnum) {
      final parsed = '${field.dartType}.parse($raw)';
      if (fallback != null) {
        final member = _enumMember(field.dartType, fallback);
        return '$parsed ?? ${field.dartType}.$member';
      }
      if (nullable) return parsed;
      return "xmlRequiredValue($parsed, '${field.xmlName}', element)";
    }
    switch (field.dartType) {
      case 'int':
        final parsed = 'xmlInt($raw)';
        if (nullable) return fallback == null ? parsed : '$parsed ?? $fallback';
        return '$parsed ?? ${fallback ?? 0}';
      case 'double':
        final parsed = 'xmlDouble($raw)';
        if (nullable) return fallback == null ? parsed : '$parsed ?? $fallback';
        return '$parsed ?? ${fallback ?? 0}';
      case 'bool':
        final parsed = 'xmlBool($raw)';
        if (nullable && fallback == null) return parsed;
        return "$parsed ?? ${fallback == 'yes'}";
      default:
        if (fallback != null) return "$raw ?? '${_escape(fallback)}'";
        if (nullable) return raw;
        return rawIsNonNull ? raw : "$raw ?? ''";
    }
  }

  /// The Dart member name for an enum's default value.
  String _enumMember(String dartType, String xmlValue) {
    for (final schemaEnum in enums) {
      if (schemaEnum.dartName != dartType) continue;
      final member = schemaEnum.values[xmlValue];
      if (member != null) return member;
    }
    return safeMemberName(xmlValue, isEnumMember: true);
  }

  String _toTextExpression(SchemaField field, String access) {
    if (field.isEnum) return '$access.xmlValue';
    switch (field.dartType) {
      case 'bool':
        return "$access ? 'yes' : 'no'";
      case 'double':
      case 'int':
        return 'xmlNumberText($access)';
      default:
        return access;
    }
  }

  String _writeAttribute(SchemaField field) {
    final access = field.dartName;
    final text = _toTextExpression(
      field,
      field.isNullable ? '$access!' : access,
    );
    if (field.isNullable) {
      return '    if ($access != null) {\n'
          "      node.setAttribute('${field.qualifiedXmlName}', $text);\n"
          '    }';
    }
    return "    node.setAttribute('${field.qualifiedXmlName}', $text);";
  }

  String _writeElement(SchemaField field) {
    if (field.kind == FieldKind.items) {
      return '    for (final item in ${field.dartName}) {\n'
          '      final child = item.toXmlOrNull();\n'
          '      if (child != null) node.children.add(child);\n'
          '    }';
    }
    if (field.isList) {
      if (field.isComplex) {
        return '    for (final item in ${field.dartName}) {\n'
            "      node.children.add(item.toXml('${field.xmlName}'));\n"
            '    }';
      }
      return '    for (final item in ${field.dartName}) {\n'
          "      node.children.add(xmlTextElement('${field.xmlName}', ${_toTextExpression(field, 'item')}));\n"
          '    }';
    }
    if (field.isComplex) {
      if (field.isNullable) {
        return '    if (${field.dartName} != null) {\n'
            "      node.children.add(${field.dartName}!.toXml('${field.xmlName}'));\n"
            '    }';
      }
      return "    node.children.add(${field.dartName}.toXml('${field.xmlName}'));";
    }
    final access = field.isNullable ? '${field.dartName}!' : field.dartName;
    final text = _toTextExpression(field, access);
    if (field.isNullable) {
      return '    if (${field.dartName} != null) {\n'
          "      node.children.add(xmlTextElement('${field.xmlName}', $text));\n"
          '    }';
    }
    return "    node.children.add(xmlTextElement('${field.xmlName}', $text));";
  }

  String _escape(String value) =>
      value.replaceAll(r'\', r'\\').replaceAll("'", r"\'");
}
