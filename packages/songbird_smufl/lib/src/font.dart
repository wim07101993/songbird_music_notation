import 'package:songbird_smufl/src/glyph.dart';
import 'package:songbird_smufl/src/metadata.dart';

/// A SMuFL font together with the measurements needed to draw with it.
///
/// SMuFL fonts are designed on a grid where one em equals one staff — four
/// staff spaces — so the text size that yields a given staff space is simply
/// four times it. [fontSizeForStaffSpace] does that conversion, and everything
/// else in the metadata is already in staff spaces and needs only scaling.
class SmuflFont {
  const SmuflFont({
    required this.family,
    required this.metadata,
    this.package,
  });

  /// Bravura, measured from the metadata this package ships.
  ///
  /// [source] is the contents of [bravuraMetadataAsset]. Reading it is the
  /// caller's business: on Flutter it is an asset and arrives through the
  /// bundle, and there is nothing else in this package that needs Flutter.
  factory SmuflFont.bravuraFrom(
    String source,
  ) => SmuflFont(
    family: 'Bravura',
    metadata: SmuflMetadata.parse(source),
    package: 'songbird_smufl',
  );

  /// Where the bundled Bravura metadata sits in a Flutter asset bundle.
  static const String bravuraMetadataAsset =
      'packages/songbird_smufl/assets/metadata/bravura_metadata.json';

  /// Where the bundled font file sits, for a test that loads it by hand.
  static const String bravuraFontAsset =
      'packages/songbird_smufl/assets/fonts/Bravura.otf';

  /// Bravura with default measurements, for before the metadata is read.
  ///
  /// The glyphs are correct — they come from the font itself — but positions
  /// derived from bounding boxes and anchors fall back to the specification's
  /// defaults, so a score drawn with this is slightly less precisely spaced.
  /// Useful as a first frame while the metadata is being read.
  static const SmuflFont bravuraFallback = SmuflFont(
    family: 'Bravura',
    metadata: null,
    package: 'songbird_smufl',
  );

  /// The Flutter font family name.
  final String family;

  /// The font's published measurements, or `null` when only the fallback
  /// defaults are available.
  final SmuflMetadata? metadata;

  /// The package the font asset lives in, for `TextStyle(package:)`.
  final String? package;

  EngravingDefaults get engraving =>
      metadata?.engravingDefaults ?? const EngravingDefaults();

  /// The text size, in the same units as [staffSpace], that draws glyphs at
  /// the right size for a staff whose lines are [staffSpace] apart.
  static double fontSizeForStaffSpace(double staffSpace) => staffSpace * 4;

  /// Advance width of [glyph] in staff spaces.
  double advanceWidthOf(SmuflGlyph glyph) =>
      metadata?.advanceWidthOf(glyph.name) ?? _fallbackWidth(glyph);

  GlyphBoundingBox? boundingBoxOf(SmuflGlyph glyph) =>
      metadata?.boundingBoxOf(glyph.name);

  GlyphAnchors anchorsOf(SmuflGlyph glyph) =>
      metadata?.anchorsOf(glyph.name) ?? GlyphAnchors.empty;

  /// Where an upward stem meets [glyph], in staff spaces from its origin.
  ///
  /// Falls back to the right edge of the bounding box at the vertical centre,
  /// which is where a stem goes on a notehead that publishes no anchor.
  SmuflPoint stemUpAnchorOf(SmuflGlyph glyph) {
    final anchor = anchorsOf(glyph).stemUpSE;
    if (anchor != null) return anchor;
    final box = boundingBoxOf(glyph);
    return SmuflPoint(box?.right ?? advanceWidthOf(glyph), 0);
  }

  /// Where a downward stem meets [glyph].
  SmuflPoint stemDownAnchorOf(SmuflGlyph glyph) {
    final anchor = anchorsOf(glyph).stemDownNW;
    if (anchor != null) return anchor;
    final box = boundingBoxOf(glyph);
    return SmuflPoint(box?.left ?? 0, 0);
  }

  /// A rough width for a glyph when no metadata is loaded, so that a first
  /// frame is laid out sensibly rather than collapsing to zero.
  double _fallbackWidth(SmuflGlyph glyph) {
    if (glyph.name.startsWith('notehead')) return 1.18;
    if (glyph.name.startsWith('accidental')) return 0.9;
    if (glyph.name.startsWith('rest')) return 1.1;
    if (glyph.name.startsWith('gClef') ||
        glyph.name.startsWith('fClef') ||
        glyph.name.startsWith('cClef')) {
      return 2.7;
    }
    if (glyph.name.startsWith('timeSig')) return 1.6;
    if (glyph.name.startsWith('flag')) return 1.0;
    return 1.0;
  }

  @override
  String toString() =>
      'SmuflFont($family${metadata == null ? ', no metadata' : ''})';
}
