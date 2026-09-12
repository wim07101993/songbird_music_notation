import 'package:songbird_score/src/model/attributes.dart';
import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/harmony.dart';
import 'package:songbird_score/src/model/measure.dart';
import 'package:songbird_score/src/model/spanner.dart';
import 'package:songbird_score/src/theory/interval.dart';

/// A named sound a part can play, for parts that switch instruments.
class ScoreInstrument {
  ScoreInstrument({
    required this.id,
    required this.name,
    this.abbreviation,
    this.sound,
    this.virtualLibrary,
    this.virtualName,
  });

  final String id;
  String name;
  String? abbreviation;

  /// A standard sound id such as `wind.flutes.flute`.
  String? sound;

  String? virtualLibrary;
  String? virtualName;
}

/// MIDI playback settings for a [ScoreInstrument].
class MidiInstrument {
  MidiInstrument({
    required this.id,
    this.channel,
    this.program,
    this.unpitched,
    this.volume,
    this.pan,
    this.elevation,
    this.name,
    this.bank,
  });

  final String id;
  int? channel;
  int? program;
  int? unpitched;
  double? volume;
  double? pan;
  double? elevation;
  String? name;
  int? bank;
}

/// One instrumental or vocal line of the score, running the whole length of it.
class Part {
  Part({
    required this.id,
    required this.name,
    List<Measure>? measures,
    this.abbreviation,
    this.nameDisplay,
    this.abbreviationDisplay,
    List<ScoreInstrument>? instruments,
    List<MidiInstrument>? midiInstruments,
    List<Spanner>? spanners,
    this.printName = true,
    this.printAbbreviation = true,
  }) : measures = measures ?? [],
       instruments = instruments ?? [],
       midiInstruments = midiInstruments ?? [],
       spanners = spanners ?? [];

  /// The identifier the source uses, kept so export can reuse it.
  final String id;

  /// The full name printed at the start of the score.
  String name;

  /// The short name printed on later systems.
  String? abbreviation;

  /// Formatted overrides for the printed names.
  String? nameDisplay;
  String? abbreviationDisplay;

  List<Measure> measures;
  List<ScoreInstrument> instruments;
  List<MidiInstrument> midiInstruments;

  /// Slurs, ties and tuplets, resolved to their endpoints.
  List<Spanner> spanners;

  bool printName;
  bool printAbbreviation;

  /// The attributes in force at the start of measure [index], accumulated from
  /// the beginning of the part.
  MusicalContext contextAtMeasure(int index) {
    final context = MusicalContext();
    for (var i = 0; i <= index && i < measures.length; i++) {
      for (final change in measures[i].attributeChanges) {
        if (i < index || change.position.isZero) {
          context.apply(change.attributes);
        }
      }
    }
    return context;
  }

  /// The context at the start of every measure, computed in one pass.
  ///
  /// Layout needs all of them, and asking [contextAtMeasure] repeatedly would
  /// re-walk the part for each measure.
  List<MusicalContext> contextsPerMeasure() {
    final result = <MusicalContext>[];
    final running = MusicalContext();
    for (final measure in measures) {
      for (final change in measure.attributeChanges) {
        if (change.position.isZero) running.apply(change.attributes);
      }
      result.add(running.copy());
      for (final change in measure.attributeChanges) {
        if (!change.position.isZero) running.apply(change.attributes);
      }
    }
    return result;
  }

  /// The highest staff number this part uses.
  int get staffCount {
    var count = 1;
    for (final measure in measures) {
      for (final change in measure.attributeChanges) {
        final staves = change.attributes.staves;
        if (staves != null && staves > count) count = staves;
      }
      for (final event in measure.events) {
        if (event.staff > count) count = event.staff;
      }
    }
    return count;
  }

  /// Every chord in the part, in reading order.
  Iterable<Chord> get chords sync* {
    for (final measure in measures) {
      for (final event in measure.eventsInOrder) {
        if (event is Chord) yield event;
      }
    }
  }

  /// Moves every pitch in the part by [interval].
  ///
  /// Key signatures move with the notes unless [transposeKeys] is false, which
  /// is what a concert-pitch toggle wants.
  void transpose(Interval interval, {bool transposeKeys = true}) {
    for (final measure in measures) {
      for (final event in measure.events) {
        if (event is Chord) event.transpose(interval);
        // A chord symbol names the harmony of the notes under it, so it has to
        // go with them: a transposed part whose symbols stayed behind is
        // telling a player two different things at once.
        if (event is Harmony) {
          event.root = interval.transpose(event.root).simplified;
          final bass = event.bass;
          if (bass != null) event.bass = interval.transpose(bass).simplified;
        }
      }
      if (!transposeKeys) continue;
      for (final change in measure.attributeChanges) {
        final keys = change.attributes.keys;
        for (final staff in keys.keys.toList()) {
          keys[staff] = keys[staff]!.transposed(interval);
        }
      }
    }
  }

  /// Drops every spanner whose endpoints are no longer in the part, which an
  /// edit that deleted a note will have left behind.
  void pruneSpanners() {
    final live = <MusicalEvent>{
      for (final measure in measures) ...measure.events,
    };
    spanners.removeWhere(
      (spanner) => !live.contains(spanner.start) || !live.contains(spanner.end),
    );
  }

  @override
  String toString() => 'Part($id, "$name", ${measures.length} measures)';
}

/// How a group of parts is bracketed together in the score.
enum GroupSymbol { none, brace, line, bracket, square }

/// A bracketed group of parts, such as the strings of an orchestra.
class PartGroup {
  PartGroup({
    required this.number,
    required this.startPartIndex,
    required this.endPartIndex,
    this.name,
    this.abbreviation,
    this.symbol = GroupSymbol.bracket,
    this.groupBarline = true,
  });

  /// The group's nesting number, as written in the source.
  final String number;

  /// Index of the first part in the group.
  int startPartIndex;

  /// Index of the last part in the group, inclusive.
  int endPartIndex;

  String? name;
  String? abbreviation;
  GroupSymbol symbol;

  /// Whether barlines run through the whole group.
  bool groupBarline;

  bool contains(int partIndex) =>
      partIndex >= startPartIndex && partIndex <= endPartIndex;
}
