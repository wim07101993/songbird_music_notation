// Regenerates lib/src/generated/glyph_names.g.dart from the SMuFL metadata in
// this directory.
//
//   dart run tool/generate_glyph_names.dart
//
// glyphnames.json and classes.json come from the SMuFL specification:
// https://github.com/w3c/smufl/tree/gh-pages/metadata
import 'dart:convert';
import 'dart:io';

void main() {
  final root = File.fromUri(Platform.script).parent;
  final glyphs = readMetadata('${root.path}/glyphnames.json');
  final classes = readMetadata('${root.path}/classes.json');

  final output = File(
    '${root.parent.path}/lib/src/generated/glyph_names.g.dart',
  );
  output.writeAsStringSync(emitGlyphNames(glyphs: glyphs, classes: classes));
  stdout.writeln(
    'Wrote ${output.path} '
    '(${glyphs.length} glyphs, ${classes.length} classes)',
  );
}

/// Reads one of the specification's JSON files.
Map<String, dynamic> readMetadata(String path) =>
    jsonDecode(File(path).readAsStringSync()) as Map<String, dynamic>;

/// The contents of `glyph_names.g.dart` for the given specification metadata.
///
/// Kept separate from [main] so that a test can regenerate into memory and
/// compare against the committed file.
String emitGlyphNames({
  required Map<String, dynamic> glyphs,
  required Map<String, dynamic> classes,
}) {
  final names = glyphs.keys.toList()..sort();
  final buffer = StringBuffer()
    ..writeln('// dart format off')
    ..writeln('//')
    ..writeln('// GENERATED FILE - do not edit by hand.')
    ..writeln('//')
    ..writeln('// Regenerate with:')
    ..writeln('//   dart run tool/generate_glyph_names.dart')
    ..writeln('//')
    ..writeln('// Source: SMuFL ${names.length} glyph metadata,')
    ..writeln('// https://github.com/w3c/smufl/tree/gh-pages/metadata')
    ..writeln()
    ..writeln("part of '../glyph.dart';")
    ..writeln()
    ..writeln(
      '/// Every glyph the SMuFL specification defines, by canonical name.',
    )
    ..writeln('///')
    ..writeln(
      '/// Referring to [SmuflGlyphs.noteheadBlack] rather than to a raw code',
    )
    ..writeln(
      '/// point keeps the renderer readable and survives a font that maps a',
    )
    ..writeln('/// glyph somewhere unexpected.')
    ..writeln('abstract final class SmuflGlyphs {');

  for (final name in names) {
    final entry = glyphs[name] as Map<String, dynamic>;
    final description = (entry['description'] as String?) ?? name;
    buffer
      ..writeln('  /// ${_escapeDoc(description)}')
      ..writeln('  static const SmuflGlyph ${_identifier(name)} =')
      ..writeln("      SmuflGlyph('$name');")
      ..writeln();
  }

  buffer
    ..writeln('  /// Every glyph name defined by the specification, sorted.')
    ..writeln('  static const List<String> allNames = <String>[');
  for (final name in names) {
    buffer.writeln("    '$name',");
  }
  buffer
    ..writeln('  ];')
    ..writeln('}')
    ..writeln();

  buffer
    ..writeln(
      '/// Canonical name to Unicode code point, for every SMuFL glyph.',
    )
    ..writeln('const Map<String, int> smuflCodePoints = <String, int>{');
  for (final name in names) {
    final entry = glyphs[name] as Map<String, dynamic>;
    final codepoint = _parseCodePoint(entry['codepoint'] as String?);
    if (codepoint == null) continue;
    buffer.writeln(
      "  '$name': 0x${codepoint.toRadixString(16).toUpperCase()},",
    );
  }
  buffer
    ..writeln('};')
    ..writeln();

  buffer
    ..writeln('/// Alternate code points in the Unicode Musical Symbols block,')
    ..writeln('/// for the glyphs that have a standard Unicode equivalent.')
    ..writeln(
      'const Map<String, int> smuflAlternateCodePoints = <String, int>{',
    );
  for (final name in names) {
    final entry = glyphs[name] as Map<String, dynamic>;
    final codepoint = _parseCodePoint(entry['alternateCodepoint'] as String?);
    if (codepoint == null) continue;
    buffer.writeln(
      "  '$name': 0x${codepoint.toRadixString(16).toUpperCase()},",
    );
  }
  buffer
    ..writeln('};')
    ..writeln();

  final classNames = classes.keys.toList()..sort();
  buffer
    ..writeln(
      "/// The specification's glyph classes, such as `noteheadBlack` or",
    )
    ..writeln(
      '/// `articulationsAbove`, used to reason about families of glyphs.',
    )
    ..writeln(
      'const Map<String, List<String>> smuflClasses = <String, List<String>>{',
    );
  for (final className in classNames) {
    final members = (classes[className] as List<dynamic>).cast<String>();
    buffer
      ..writeln("  '$className': <String>[")
      ..writeln(members.map((m) => "    '$m',").join('\n'))
      ..writeln('  ],');
  }
  buffer.writeln('};');

  return buffer.toString();
}

/// SMuFL names are already valid Dart identifiers apart from the two tablature
/// clefs that start with a digit.
String _identifier(String name) =>
    RegExp('^[0-9]').hasMatch(name) ? 'n$name' : name;

int? _parseCodePoint(String? value) {
  if (value == null || !value.startsWith('U+')) return null;
  return int.tryParse(value.substring(2), radix: 16);
}

String _escapeDoc(String text) => text.replaceAll('\n', ' ').trim();
