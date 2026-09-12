part 'generated/glyph_names.g.dart';

/// A named SMuFL glyph.
///
/// Glyphs are identified by their specification name rather than by code point
/// so that the code says what it draws. The code point is a lookup away, and a
/// font that maps a glyph into its private-use area at a different address can
/// still be asked for it by name.
class SmuflGlyph {
  const SmuflGlyph(
    this.name,
  );

  /// The canonical SMuFL name, such as `noteheadBlack`.
  final String name;

  /// The code point in the SMuFL private-use range, or `null` if the name is
  /// not part of the specification.
  int? get codePoint => smuflCodePoints[name];

  /// The equivalent in Unicode's Musical Symbols block, where one exists.
  int? get alternateCodePoint => smuflAlternateCodePoints[name];

  /// The glyph as a string ready to be handed to a text renderer.
  String get text {
    final point = codePoint;
    return point == null ? '' : String.fromCharCode(point);
  }

  /// Whether the specification defines this name.
  bool get isDefined => smuflCodePoints.containsKey(name);

  /// The specification classes this glyph belongs to.
  List<String> get classes => [
    for (final entry in smuflClasses.entries)
      if (entry.value.contains(name)) entry.key,
  ];

  @override
  bool operator ==(Object other) => other is SmuflGlyph && name == other.name;

  @override
  int get hashCode => name.hashCode;

  @override
  String toString() => 'SmuflGlyph($name)';
}
