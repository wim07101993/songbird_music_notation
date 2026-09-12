import 'dart:convert';

/// A point in a font's own coordinates: staff spaces, with y increasing
/// upwards.
///
/// Flutter's canvas has y increasing downwards, so anything taken from the
/// metadata has to be negated on the way to a [Canvas]. Keeping the font's own
/// convention here means the numbers can be checked against the published
/// metadata without mental arithmetic.
class SmuflPoint {
  const SmuflPoint(
    this.x,
    this.y,
  );

  /// Horizontal distance in staff spaces, positive to the right.
  final double x;

  /// Vertical distance in staff spaces, positive upwards.
  final double y;

  static const SmuflPoint zero = SmuflPoint(0, 0);

  @override
  bool operator ==(Object other) =>
      other is SmuflPoint && x == other.x && y == other.y;

  @override
  int get hashCode => Object.hash(x, y);

  @override
  String toString() => 'SmuflPoint($x, $y)';
}

/// The extent of a glyph, in staff spaces relative to its origin.
class GlyphBoundingBox {
  const GlyphBoundingBox({
    required this.northEast,
    required this.southWest,
  });

  /// Top-right corner.
  final SmuflPoint northEast;

  /// Bottom-left corner.
  final SmuflPoint southWest;

  double get left => southWest.x;
  double get right => northEast.x;

  /// Distance above the origin, in staff spaces.
  double get top => northEast.y;

  /// Distance below the origin; negative for a glyph that hangs down.
  double get bottom => southWest.y;

  double get width => right - left;
  double get height => top - bottom;

  @override
  String toString() =>
      'GlyphBoundingBox(${left.toStringAsFixed(3)}..${right.toStringAsFixed(3)}, '
      '${bottom.toStringAsFixed(3)}..${top.toStringAsFixed(3)})';
}

/// The attachment points a glyph publishes, chiefly where a stem meets a
/// notehead.
class GlyphAnchors {
  const GlyphAnchors({
    this.stemUpSE,
    this.stemDownNW,
    this.stemUpNW,
    this.stemDownSW,
    this.nominalWidth,
    this.numeralTop,
    this.numeralBottom,
    this.cutOutNE,
    this.cutOutSE,
    this.cutOutSW,
    this.cutOutNW,
    this.graceNoteSlashSW,
    this.graceNoteSlashNE,
    this.graceNoteSlashNW,
    this.graceNoteSlashSE,
    this.repeatOffset,
    this.noteheadOrigin,
    this.opticalCenter,
  });

  /// Where an upward stem leaves the right side of the glyph.
  final SmuflPoint? stemUpSE;

  /// Where a downward stem leaves the left side of the glyph.
  final SmuflPoint? stemDownNW;

  final SmuflPoint? stemUpNW;
  final SmuflPoint? stemDownSW;
  final SmuflPoint? nominalWidth;
  final SmuflPoint? numeralTop;
  final SmuflPoint? numeralBottom;

  /// Corners that may be tucked into, used to bring a flag close to a stem.
  final SmuflPoint? cutOutNE;
  final SmuflPoint? cutOutSE;
  final SmuflPoint? cutOutSW;
  final SmuflPoint? cutOutNW;

  final SmuflPoint? graceNoteSlashSW;
  final SmuflPoint? graceNoteSlashNE;
  final SmuflPoint? graceNoteSlashNW;
  final SmuflPoint? graceNoteSlashSE;

  final SmuflPoint? repeatOffset;

  /// Horizontal offset from the glyph origin to the notehead it contains, for
  /// composite glyphs.
  final SmuflPoint? noteheadOrigin;

  /// Where the glyph looks centred, which is not always its geometric centre.
  final SmuflPoint? opticalCenter;

  static const GlyphAnchors empty = GlyphAnchors();

  factory GlyphAnchors.fromJson(
    Map<String, dynamic> json,
  ) {
    SmuflPoint? point(String key) {
      final value = json[key];
      if (value is! List || value.length < 2) return null;
      return SmuflPoint(
        (value[0] as num).toDouble(),
        (value[1] as num).toDouble(),
      );
    }

    return GlyphAnchors(
      stemUpSE: point('stemUpSE'),
      stemDownNW: point('stemDownNW'),
      stemUpNW: point('stemUpNW'),
      stemDownSW: point('stemDownSW'),
      nominalWidth: point('nominalWidth'),
      numeralTop: point('numeralTop'),
      numeralBottom: point('numeralBottom'),
      cutOutNE: point('cutOutNE'),
      cutOutSE: point('cutOutSE'),
      cutOutSW: point('cutOutSW'),
      cutOutNW: point('cutOutNW'),
      graceNoteSlashSW: point('graceNoteSlashSW'),
      graceNoteSlashNE: point('graceNoteSlashNE'),
      graceNoteSlashNW: point('graceNoteSlashNW'),
      graceNoteSlashSE: point('graceNoteSlashSE'),
      repeatOffset: point('repeatOffset'),
      noteheadOrigin: point('noteheadOrigin'),
      opticalCenter: point('opticalCenter'),
    );
  }
}

/// The line weights and distances a font recommends, all in staff spaces.
///
/// These are what make a score look like it was engraved rather than drawn: a
/// stem is 0.12 spaces wide, a beam 0.5, and the gap between two beams 0.25.
class EngravingDefaults {
  const EngravingDefaults({
    this.arrowShaftThickness = 0.16,
    this.barlineSeparation = 0.4,
    this.beamSpacing = 0.25,
    this.beamThickness = 0.5,
    this.bracketThickness = 0.5,
    this.dashedBarlineDashLength = 0.5,
    this.dashedBarlineGapLength = 0.25,
    this.dashedBarlineThickness = 0.16,
    this.hairpinThickness = 0.16,
    this.hBarThickness = 1.0,
    this.legerLineExtension = 0.4,
    this.legerLineThickness = 0.16,
    this.lyricLineThickness = 0.16,
    this.octaveLineThickness = 0.16,
    this.pedalLineThickness = 0.16,
    this.repeatBarlineDotSeparation = 0.16,
    this.repeatEndingLineThickness = 0.16,
    this.slurEndpointThickness = 0.1,
    this.slurMidpointThickness = 0.22,
    this.staffLineThickness = 0.13,
    this.stemThickness = 0.12,
    this.subBracketThickness = 0.16,
    this.textEnclosureThickness = 0.16,
    this.thickBarlineThickness = 0.5,
    this.thinBarlineThickness = 0.16,
    this.thinThickBarlineSeparation = 0.4,
    this.tieEndpointThickness = 0.1,
    this.tieMidpointThickness = 0.22,
    this.tupletBracketThickness = 0.16,
    this.textFontFamily = const ['serif'],
  });

  final double arrowShaftThickness;
  final double barlineSeparation;

  /// Vertical gap between two beams of a group.
  final double beamSpacing;

  /// Thickness of a single beam.
  final double beamThickness;

  final double bracketThickness;
  final double dashedBarlineDashLength;
  final double dashedBarlineGapLength;
  final double dashedBarlineThickness;
  final double hairpinThickness;
  final double hBarThickness;

  /// How far a ledger line sticks out past the notehead on each side.
  final double legerLineExtension;

  final double legerLineThickness;
  final double lyricLineThickness;
  final double octaveLineThickness;
  final double pedalLineThickness;
  final double repeatBarlineDotSeparation;
  final double repeatEndingLineThickness;

  /// A slur is drawn thin at the ends and thicker in the middle.
  final double slurEndpointThickness;
  final double slurMidpointThickness;

  final double staffLineThickness;
  final double stemThickness;
  final double subBracketThickness;
  final double textEnclosureThickness;
  final double thickBarlineThickness;
  final double thinBarlineThickness;
  final double thinThickBarlineSeparation;
  final double tieEndpointThickness;
  final double tieMidpointThickness;
  final double tupletBracketThickness;

  /// Text faces the font's designer intends to sit alongside the music.
  final List<String> textFontFamily;

  @override
  bool operator ==(Object other) =>
      other is EngravingDefaults &&
      other.stemThickness == stemThickness &&
      other.beamThickness == beamThickness &&
      other.beamSpacing == beamSpacing &&
      other.staffLineThickness == staffLineThickness &&
      other.legerLineThickness == legerLineThickness &&
      other.thinBarlineThickness == thinBarlineThickness &&
      other.thickBarlineThickness == thickBarlineThickness &&
      other.slurMidpointThickness == slurMidpointThickness &&
      other.tieMidpointThickness == tieMidpointThickness &&
      other.hairpinThickness == hairpinThickness;

  @override
  int get hashCode => Object.hash(
    stemThickness,
    beamThickness,
    beamSpacing,
    staffLineThickness,
    legerLineThickness,
    thinBarlineThickness,
    thickBarlineThickness,
    slurMidpointThickness,
    tieMidpointThickness,
    hairpinThickness,
  );

  factory EngravingDefaults.fromJson(
    Map<String, dynamic> json,
  ) {
    double read(String key, double fallback) {
      final value = json[key];
      return value is num ? value.toDouble() : fallback;
    }

    const fallback = EngravingDefaults();
    final families = json['textFontFamily'];
    return EngravingDefaults(
      arrowShaftThickness: read(
        'arrowShaftThickness',
        fallback.arrowShaftThickness,
      ),
      barlineSeparation: read('barlineSeparation', fallback.barlineSeparation),
      beamSpacing: read('beamSpacing', fallback.beamSpacing),
      beamThickness: read('beamThickness', fallback.beamThickness),
      bracketThickness: read('bracketThickness', fallback.bracketThickness),
      dashedBarlineDashLength: read(
        'dashedBarlineDashLength',
        fallback.dashedBarlineDashLength,
      ),
      dashedBarlineGapLength: read(
        'dashedBarlineGapLength',
        fallback.dashedBarlineGapLength,
      ),
      dashedBarlineThickness: read(
        'dashedBarlineThickness',
        fallback.dashedBarlineThickness,
      ),
      hairpinThickness: read('hairpinThickness', fallback.hairpinThickness),
      hBarThickness: read('hBarThickness', fallback.hBarThickness),
      legerLineExtension: read(
        'legerLineExtension',
        fallback.legerLineExtension,
      ),
      legerLineThickness: read(
        'legerLineThickness',
        fallback.legerLineThickness,
      ),
      lyricLineThickness: read(
        'lyricLineThickness',
        fallback.lyricLineThickness,
      ),
      octaveLineThickness: read(
        'octaveLineThickness',
        fallback.octaveLineThickness,
      ),
      pedalLineThickness: read(
        'pedalLineThickness',
        fallback.pedalLineThickness,
      ),
      repeatBarlineDotSeparation: read(
        'repeatBarlineDotSeparation',
        fallback.repeatBarlineDotSeparation,
      ),
      repeatEndingLineThickness: read(
        'repeatEndingLineThickness',
        fallback.repeatEndingLineThickness,
      ),
      slurEndpointThickness: read(
        'slurEndpointThickness',
        fallback.slurEndpointThickness,
      ),
      slurMidpointThickness: read(
        'slurMidpointThickness',
        fallback.slurMidpointThickness,
      ),
      staffLineThickness: read(
        'staffLineThickness',
        fallback.staffLineThickness,
      ),
      stemThickness: read('stemThickness', fallback.stemThickness),
      subBracketThickness: read(
        'subBracketThickness',
        fallback.subBracketThickness,
      ),
      textEnclosureThickness: read(
        'textEnclosureThickness',
        fallback.textEnclosureThickness,
      ),
      thickBarlineThickness: read(
        'thickBarlineThickness',
        fallback.thickBarlineThickness,
      ),
      thinBarlineThickness: read(
        'thinBarlineThickness',
        fallback.thinBarlineThickness,
      ),
      thinThickBarlineSeparation: read(
        'thinThickBarlineSeparation',
        fallback.thinThickBarlineSeparation,
      ),
      tieEndpointThickness: read(
        'tieEndpointThickness',
        fallback.tieEndpointThickness,
      ),
      tieMidpointThickness: read(
        'tieMidpointThickness',
        fallback.tieMidpointThickness,
      ),
      tupletBracketThickness: read(
        'tupletBracketThickness',
        fallback.tupletBracketThickness,
      ),
      textFontFamily: families is List
          ? families.whereType<String>().toList()
          : fallback.textFontFamily,
    );
  }
}

/// The measurements a SMuFL font publishes about itself.
///
/// Without these a renderer cannot place a stem on a notehead or know how wide
/// a clef is; every position in an engraved score depends on them.
class SmuflMetadata {
  const SmuflMetadata({
    required this.fontName,
    required this.fontVersion,
    required this.engravingDefaults,
    required this.advanceWidths,
    required this.boundingBoxes,
    required this.anchors,
    this.ligatures = const {},
    this.optionalGlyphs = const {},
    this.sets = const {},
  });

  /// A metadata set with nothing but the specification's default measurements,
  /// used when a font ships without metadata of its own.
  factory SmuflMetadata.fallback({
    String fontName = 'unknown',
  }) => SmuflMetadata(
    fontName: fontName,
    fontVersion: '0',
    engravingDefaults: const EngravingDefaults(),
    advanceWidths: const {},
    boundingBoxes: const {},
    anchors: const {},
  );

  /// Parses the `*_metadata.json` a SMuFL font ships with.
  factory SmuflMetadata.fromJson(
    Map<String, dynamic> json,
  ) {
    final widths = <String, double>{};
    final rawWidths = json['glyphAdvanceWidths'];
    if (rawWidths is Map) {
      rawWidths.forEach((key, value) {
        if (key is String && value is num) widths[key] = value.toDouble();
      });
    }

    final boxes = <String, GlyphBoundingBox>{};
    final rawBoxes = json['glyphBBoxes'];
    if (rawBoxes is Map) {
      rawBoxes.forEach((key, value) {
        if (key is! String || value is! Map) return;
        final ne = value['bBoxNE'];
        final sw = value['bBoxSW'];
        if (ne is! List || sw is! List || ne.length < 2 || sw.length < 2) {
          return;
        }
        boxes[key] = GlyphBoundingBox(
          northEast: SmuflPoint(
            (ne[0] as num).toDouble(),
            (ne[1] as num).toDouble(),
          ),
          southWest: SmuflPoint(
            (sw[0] as num).toDouble(),
            (sw[1] as num).toDouble(),
          ),
        );
      });
    }

    final anchors = <String, GlyphAnchors>{};
    final rawAnchors = json['glyphsWithAnchors'];
    if (rawAnchors is Map) {
      rawAnchors.forEach((key, value) {
        if (key is String && value is Map) {
          anchors[key] = GlyphAnchors.fromJson(value.cast<String, dynamic>());
        }
      });
    }

    final defaults = json['engravingDefaults'];
    return SmuflMetadata(
      fontName: (json['fontName'] as String?) ?? 'unknown',
      fontVersion: '${json['fontVersion'] ?? '0'}',
      engravingDefaults: defaults is Map
          ? EngravingDefaults.fromJson(defaults.cast<String, dynamic>())
          : const EngravingDefaults(),
      advanceWidths: widths,
      boundingBoxes: boxes,
      anchors: anchors,
      ligatures: _stringListMap(json['ligatures'], 'componentGlyphs'),
      optionalGlyphs: _codePointMap(json['optionalGlyphs']),
      sets: _setMap(json['sets']),
    );
  }

  /// Parses metadata from its JSON source text.
  factory SmuflMetadata.parse(
    String source,
  ) => SmuflMetadata.fromJson(jsonDecode(source) as Map<String, dynamic>);

  final String fontName;
  final String fontVersion;
  final EngravingDefaults engravingDefaults;

  /// How far the pen advances after drawing each glyph, in staff spaces.
  final Map<String, double> advanceWidths;

  final Map<String, GlyphBoundingBox> boundingBoxes;
  final Map<String, GlyphAnchors> anchors;

  /// Ligature name to the glyphs it stands in for.
  final Map<String, List<String>> ligatures;

  /// Optional glyphs the font offers beyond the standard range.
  final Map<String, int> optionalGlyphs;

  /// Stylistic sets, such as a font's smaller staff-size variants.
  final Map<String, List<String>> sets;

  /// Advance width of [glyphName] in staff spaces, falling back to the
  /// bounding-box width and finally to one space.
  double advanceWidthOf(String glyphName) =>
      advanceWidths[glyphName] ?? boundingBoxes[glyphName]?.width ?? 1.0;

  GlyphBoundingBox? boundingBoxOf(String glyphName) => boundingBoxes[glyphName];

  GlyphAnchors anchorsOf(String glyphName) =>
      anchors[glyphName] ?? GlyphAnchors.empty;

  static Map<String, List<String>> _stringListMap(Object? raw, String key) {
    final result = <String, List<String>>{};
    if (raw is Map) {
      raw.forEach((name, value) {
        if (name is! String || value is! Map) return;
        final list = value[key];
        if (list is List) result[name] = list.whereType<String>().toList();
      });
    }
    return result;
  }

  static Map<String, int> _codePointMap(Object? raw) {
    final result = <String, int>{};
    if (raw is Map) {
      raw.forEach((name, value) {
        if (name is! String || value is! Map) return;
        final code = value['codepoint'];
        if (code is String && code.startsWith('U+')) {
          final parsed = int.tryParse(code.substring(2), radix: 16);
          if (parsed != null) result[name] = parsed;
        }
      });
    }
    return result;
  }

  static Map<String, List<String>> _setMap(Object? raw) {
    final result = <String, List<String>>{};
    if (raw is Map) {
      raw.forEach((name, value) {
        if (name is! String || value is! Map) return;
        final glyphs = value['glyphs'];
        if (glyphs is! List) return;
        result[name] = [
          for (final glyph in glyphs)
            if (glyph is Map && glyph['name'] is String)
              glyph['name'] as String,
        ];
      });
    }
    return result;
  }
}
