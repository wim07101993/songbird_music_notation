import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/measure.dart';
import 'package:songbird_score/src/model/part.dart';

/// Points at one thing in the score, so that an edit knows what it applies to
/// and the renderer knows what to highlight.
class ScoreSelection {
  const ScoreSelection({
    this.events = const {},
    this.notes = const {},
    this.measures = const {},
    this.parts = const {},
  });

  static const ScoreSelection empty = ScoreSelection();

  /// Whole events — chords, rests, directions.
  final Set<MusicalEvent> events;

  /// Individual noteheads, for editing one note of a chord.
  final Set<Note> notes;

  final Set<Measure> measures;
  final Set<Part> parts;

  bool get isEmpty =>
      events.isEmpty && notes.isEmpty && measures.isEmpty && parts.isEmpty;

  bool get isNotEmpty => !isEmpty;

  /// Every chord touched by the selection, whether picked as a whole event or
  /// through one of its noteheads.
  Set<Chord> get chords => {
    ...events.whereType<Chord>(),
    ...{
      for (final event in events)
        if (event is Chord) event,
    },
  };

  /// The noteheads an edit should act on: the explicitly selected ones, plus
  /// every note of a fully selected chord.
  Set<Note> get affectedNotes => {
    ...notes,
    for (final event in events)
      if (event is Chord) ...event.notes,
  };

  bool contains(Object item) =>
      events.contains(item) ||
      notes.contains(item) ||
      measures.contains(item) ||
      parts.contains(item);

  ScoreSelection withEvent(MusicalEvent event) =>
      ScoreSelection(events: {event}, parts: parts);

  ScoreSelection withNote(Note note, {MusicalEvent? owner}) => ScoreSelection(
    notes: {note},
    events: owner == null ? const {} : {owner},
    parts: parts,
  );

  ScoreSelection addingEvent(MusicalEvent event) => ScoreSelection(
    events: {...events, event},
    notes: notes,
    measures: measures,
    parts: parts,
  );

  ScoreSelection togglingEvent(MusicalEvent event) => events.contains(event)
      ? ScoreSelection(
          events: {...events}..remove(event),
          notes: notes,
          measures: measures,
          parts: parts,
        )
      : addingEvent(event);

  @override
  bool operator ==(Object other) =>
      other is ScoreSelection &&
      _setEquals(events, other.events) &&
      _setEquals(notes, other.notes) &&
      _setEquals(measures, other.measures) &&
      _setEquals(parts, other.parts);

  @override
  int get hashCode => Object.hash(
    Object.hashAllUnordered(events),
    Object.hashAllUnordered(notes),
    Object.hashAllUnordered(measures),
    Object.hashAllUnordered(parts),
  );

  static bool _setEquals<T>(Set<T> a, Set<T> b) =>
      a.length == b.length && a.containsAll(b);
}
