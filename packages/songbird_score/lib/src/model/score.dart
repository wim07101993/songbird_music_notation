import 'package:songbird_score/src/model/measure.dart';
import 'package:songbird_score/src/model/part.dart';
import 'package:songbird_score/src/theory/interval.dart';

/// One credited contributor.
class Creator {
  const Creator({
    required this.type,
    required this.name,
  });

  /// `composer`, `lyricist`, `arranger` and so on.
  final String type;
  final String name;
}

/// Title, credits and provenance.
class ScoreMetadata {
  ScoreMetadata({
    this.workTitle,
    this.workNumber,
    this.movementTitle,
    this.movementNumber,
    List<Creator>? creators,
    List<String>? rights,
    this.software,
    this.encodingDate,
    this.source,
    Map<String, String>? miscellaneous,
  }) : creators = creators ?? [],
       rights = rights ?? [],
       miscellaneous = miscellaneous ?? {};

  String? workTitle;
  String? workNumber;
  String? movementTitle;
  String? movementNumber;

  List<Creator> creators;
  List<String> rights;

  String? software;
  String? encodingDate;
  String? source;

  /// Anything the source recorded that has no dedicated field.
  Map<String, String> miscellaneous;

  /// The title to show, preferring the movement title as engravers do.
  String? get title => movementTitle ?? workTitle;

  String? creatorOfType(String type) {
    for (final creator in creators) {
      if (creator.type == type) return creator.name;
    }
    return null;
  }

  String? get composer => creatorOfType('composer');
  String? get lyricist => creatorOfType('lyricist') ?? creatorOfType('poet');
  String? get arranger => creatorOfType('arranger');

  ScoreMetadata copy() => ScoreMetadata(
    workTitle: workTitle,
    workNumber: workNumber,
    movementTitle: movementTitle,
    movementNumber: movementNumber,
    creators: [...creators],
    rights: [...rights],
    software: software,
    encodingDate: encodingDate,
    source: source,
    miscellaneous: {...miscellaneous},
  );
}

/// The relation between staff-space units and real-world size.
///
/// MusicXML measures everything in tenths of a staff space, and `<scaling>`
/// says how many millimetres [tenths] of them cover.
class Scaling {
  const Scaling({
    this.millimeters = 7.0,
    this.tenths = 40.0,
  });

  final double millimeters;
  final double tenths;

  /// Millimetres per tenth.
  double get millimetersPerTenth => millimeters / tenths;

  /// Height of one staff space in millimetres.
  double get staffSpaceMillimeters => millimetersPerTenth * 10;
}

/// Page geometry, in tenths.
class PageLayout {
  const PageLayout({
    this.pageWidth,
    this.pageHeight,
    this.evenMarginLeft,
    this.evenMarginRight,
    this.evenMarginTop,
    this.evenMarginBottom,
    this.oddMarginLeft,
    this.oddMarginRight,
    this.oddMarginTop,
    this.oddMarginBottom,
  });

  final double? pageWidth;
  final double? pageHeight;
  final double? evenMarginLeft;
  final double? evenMarginRight;
  final double? evenMarginTop;
  final double? evenMarginBottom;
  final double? oddMarginLeft;
  final double? oddMarginRight;
  final double? oddMarginTop;
  final double? oddMarginBottom;
}

/// Default system spacing, in tenths.
class SystemLayoutDefaults {
  const SystemLayoutDefaults({
    this.leftMargin,
    this.rightMargin,
    this.systemDistance,
    this.topSystemDistance,
  });

  final double? leftMargin;
  final double? rightMargin;
  final double? systemDistance;
  final double? topSystemDistance;
}

/// Score-wide defaults: how big a staff is and how the page is laid out.
class ScoreDefaults {
  const ScoreDefaults({
    this.scaling = const Scaling(),
    this.pageLayout = const PageLayout(),
    this.systemLayout = const SystemLayoutDefaults(),
    this.staffDistance,
    this.musicFont,
    this.wordFont,
    this.lyricFont,
  });

  final Scaling scaling;
  final PageLayout pageLayout;
  final SystemLayoutDefaults systemLayout;

  /// Distance between staves of the same part, in tenths.
  final double? staffDistance;

  final String? musicFont;
  final String? wordFont;
  final String? lyricFont;
}

/// A complete score: metadata, the parts, and how they are grouped.
class Score {
  Score({
    ScoreMetadata? metadata,
    List<Part>? parts,
    List<PartGroup>? partGroups,
    this.defaults = const ScoreDefaults(),
    List<String>? credits,
    this.version = '4.0',
  }) : metadata = metadata ?? ScoreMetadata(),
       parts = parts ?? [],
       partGroups = partGroups ?? [],
       credits = credits ?? [];

  ScoreMetadata metadata;

  List<Part> parts;

  /// Bracketing of the parts, outermost first.
  List<PartGroup> partGroups;

  ScoreDefaults defaults;

  /// Free text printed on the title page.
  List<String> credits;

  /// The MusicXML version the score came from.
  String version;

  /// The number of measures, taken from the longest part.
  int get measureCount => parts.fold(
    0,
    (m, part) => part.measures.length > m ? part.measures.length : m,
  );

  Part? partById(String id) {
    for (final part in parts) {
      if (part.id == id) return part;
    }
    return null;
  }

  /// The measures at [index] across every part, skipping parts that are short.
  List<Measure> measuresAt(int index) => [
    for (final part in parts)
      if (index < part.measures.length) part.measures[index],
  ];

  /// This score showing only [keep], in the order the parts already stand in.
  ///
  /// The parts themselves are shared rather than copied, so a layout built
  /// from the result still points at the same measures and notes: selecting,
  /// hit-testing and editing through it all reach the real score. That is what
  /// makes this the right way to show a few parts of a large score — nothing
  /// has to be merged back afterwards.
  ///
  /// Part groups are renumbered onto the parts that survive, since a group
  /// holds indices rather than parts, and a group left with no members is
  /// dropped along with its bracket.
  Score withParts(Iterable<Part> keep) {
    final wanted = Set<Part>.identity()..addAll(keep);
    final kept = [
      for (final part in parts)
        if (wanted.contains(part)) part,
    ];
    final newIndexOf = <Part, int>{};
    for (var i = 0; i < kept.length; i++) {
      newIndexOf[kept[i]] = i;
    }

    final groups = <PartGroup>[];
    for (final group in partGroups) {
      final members = <int>[];
      for (var i = group.startPartIndex; i <= group.endPartIndex; i++) {
        if (i < 0 || i >= parts.length) continue;
        final moved = newIndexOf[parts[i]];
        if (moved != null) members.add(moved);
      }
      if (members.isEmpty) continue;
      groups.add(
        PartGroup(
          number: group.number,
          startPartIndex: members.first,
          endPartIndex: members.last,
          name: group.name,
          abbreviation: group.abbreviation,
          symbol: group.symbol,
          groupBarline: group.groupBarline,
        ),
      );
    }

    return Score(
      metadata: metadata,
      parts: kept,
      partGroups: groups,
      defaults: defaults,
      credits: credits,
      version: version,
    );
  }

  /// Moves the whole score by [interval].
  ///
  /// This is a written-pitch transposition: every part moves by the same
  /// interval, which is what a singer asking for "a third lower" means. It is
  /// not the same as changing an instrument's transposition.
  void transpose(Interval interval, {bool transposeKeys = true}) {
    for (final part in parts) {
      part.transpose(interval, transposeKeys: transposeKeys);
    }
  }

  Score copy() => Score(
    metadata: metadata.copy(),
    parts: [
      for (final part in parts)
        Part(
          id: part.id,
          name: part.name,
          abbreviation: part.abbreviation,
          nameDisplay: part.nameDisplay,
          abbreviationDisplay: part.abbreviationDisplay,
          measures: [for (final m in part.measures) m.copy()],
          instruments: [...part.instruments],
          midiInstruments: [...part.midiInstruments],
          printName: part.printName,
          printAbbreviation: part.printAbbreviation,
        ),
    ],
    partGroups: [...partGroups],
    defaults: defaults,
    credits: [...credits],
    version: version,
  );

  @override
  String toString() =>
      'Score("${metadata.title ?? 'untitled'}", ${parts.length} parts, '
      '$measureCount measures)';
}
