import 'package:songbird_score/src/model/attributes.dart';
import 'package:songbird_score/src/model/barline.dart';
import 'package:songbird_score/src/model/direction.dart';
import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/theory/fraction.dart';

/// A request to start a new system or page, from MusicXML's `<print>` element.
class PrintHint {
  const PrintHint({
    this.newSystem = false,
    this.newPage = false,
    this.blankPage,
    this.pageNumber,
    this.staffSpacing,
    this.systemDistance,
    this.topSystemDistance,
  });

  final bool newSystem;
  final bool newPage;
  final int? blankPage;
  final String? pageNumber;
  final double? staffSpacing;
  final double? systemDistance;
  final double? topSystemDistance;

  bool get isEmpty => !newSystem && !newPage && blankPage == null;
}

/// One measure of one part.
class Measure {
  Measure({
    required this.number,
    List<MusicalEvent>? events,
    List<AttributeChange>? attributeChanges,
    this.implicit = false,
    this.nonControlling = false,
    this.leftBarline,
    this.rightBarline,
    this.width,
    this.printHint,
  }) : events = events ?? [],
       attributeChanges = attributeChanges ?? [];

  /// The printed measure number. A string because MusicXML allows `1a`, `X1`
  /// and similar for pickups and inserted measures.
  String number;

  /// Everything happening in this measure, in no guaranteed order; use
  /// [eventsInOrder] when order matters.
  List<MusicalEvent> events;

  /// Attribute changes, each at its own point in the measure. A change at
  /// position zero is the usual case.
  List<AttributeChange> attributeChanges;

  /// A pickup or otherwise unnumbered measure.
  bool implicit;

  /// A measure whose numbering does not advance the count.
  bool nonControlling;

  Barline? leftBarline;
  Barline? rightBarline;

  /// The width the source asked for, in tenths. Layout is free to ignore it.
  double? width;

  PrintHint? printHint;

  /// The attributes stated at the very start of the measure, creating an empty
  /// set if there are none yet.
  MeasureAttributes get attributes {
    for (final change in attributeChanges) {
      if (change.position.isZero) return change.attributes;
    }
    final created = MeasureAttributes();
    attributeChanges.insert(
      0,
      AttributeChange(position: Fraction.zero, attributes: created),
    );
    return created;
  }

  /// The attributes stated at the start, or `null` if none are.
  MeasureAttributes? get attributesOrNull {
    for (final change in attributeChanges) {
      if (change.position.isZero) return change.attributes;
    }
    return null;
  }

  /// Events sorted by time, then by staff and voice, which is the order they
  /// are written and read in.
  ///
  /// A mark that takes no time — a direction, a chord symbol — comes before
  /// the note it stands over. MusicXML places one of those at wherever the
  /// cursor has got to, so a tempo mark written after the note it belongs to
  /// is read back standing over the note after that one.
  List<MusicalEvent> get eventsInOrder {
    final sorted = [...events];
    sorted.sort((a, b) {
      final byTime = a.position.compareTo(b.position);
      if (byTime != 0) return byTime;
      final byStaff = a.staff.compareTo(b.staff);
      if (byStaff != 0) return byStaff;
      final byVoice = a.voice.compareTo(b.voice);
      if (byVoice != 0) return byVoice;
      final aWaits = a.duration.isPositive;
      final bWaits = b.duration.isPositive;
      if (aWaits == bWaits) return 0;
      return aWaits ? 1 : -1;
    });
    return sorted;
  }

  /// The voice numbers used in this measure, ascending.
  List<int> get voices {
    final result = events.map((e) => e.voice).toSet().toList()..sort();
    return result;
  }

  /// The events of one voice, in time order.
  List<MusicalEvent> eventsInVoice(int voice) =>
      eventsInOrder.where((e) => e.voice == voice).toList();

  /// The events written on one staff, in time order.
  List<MusicalEvent> eventsOnStaff(int staff) =>
      eventsInOrder.where((e) => e.staff == staff).toList();

  /// The notes and rests, leaving out directions and other zero-length events.
  List<MusicalEvent> get timedEvents =>
      eventsInOrder.where((e) => e is Chord || e is Rest).toList();

  /// How far the written music actually reaches, which is not always the
  /// nominal measure length: pickups are short and cadenzas can overrun.
  Fraction get writtenDuration {
    var longest = Fraction.zero;
    for (final event in events) {
      final end = event.endPosition;
      if (end > longest) longest = end;
    }
    return longest;
  }

  /// The attributes in force at [position] within this measure, folded onto
  /// [incoming]. [incoming] is not modified.
  MusicalContext contextAt(Fraction position, MusicalContext incoming) {
    final result = incoming.copy();
    final applicable = [...attributeChanges]
      ..sort((a, b) => a.position.compareTo(b.position));
    for (final change in applicable) {
      if (change.position > position) break;
      result.apply(change.attributes);
    }
    return result;
  }

  /// Adds [event], keeping [events] consistent.
  void add(MusicalEvent event) => events.add(event);

  /// Removes [event] and returns whether it was present.
  bool remove(MusicalEvent event) => events.remove(event);

  Measure copy() => Measure(
    number: number,
    events: [for (final e in events) e.copy()],
    attributeChanges: [for (final a in attributeChanges) a.copy()],
    implicit: implicit,
    nonControlling: nonControlling,
    leftBarline: leftBarline?.copy(),
    rightBarline: rightBarline?.copy(),
    width: width,
    printHint: printHint,
  );

  @override
  String toString() => 'Measure($number, ${events.length} events)';
}

/// Convenience accessors for the directions in a measure.
extension MeasureDirections on Measure {
  List<Direction> get directions => events.whereType<Direction>().toList();
}
