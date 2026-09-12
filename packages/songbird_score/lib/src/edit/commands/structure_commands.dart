import 'package:songbird_score/src/edit/command.dart';
import 'package:songbird_score/src/model/attributes.dart';
import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/measure.dart';
import 'package:songbird_score/src/model/notations.dart';
import 'package:songbird_score/src/model/part.dart';
import 'package:songbird_score/src/model/score.dart';
import 'package:songbird_score/src/theory/clef.dart';
import 'package:songbird_score/src/theory/duration.dart';
import 'package:songbird_score/src/theory/fraction.dart';
import 'package:songbird_score/src/theory/key.dart';
import 'package:songbird_score/src/theory/time_signature.dart';

/// Adds an event to a measure.
class InsertEventCommand extends EditCommand {
  InsertEventCommand({
    required this.measure,
    required this.event,
  });

  final Measure measure;
  final MusicalEvent event;

  @override
  String get label => switch (event) {
    Chord() => 'Add note',
    Rest() => 'Add rest',
    _ => 'Add event',
  };

  @override
  void apply(Score score) => measure.add(event);

  @override
  void revert(Score score) => measure.remove(event);
}

/// Removes events from a measure, leaving the gap unfilled.
///
/// Use [ReplaceWithRestCommand] when the voice has to stay rhythmically
/// complete, which is usually what deleting a note in an existing part means.
class DeleteEventsCommand extends EditCommand {
  DeleteEventsCommand({
    required this.measure,
    required this.events,
  });

  final Measure measure;
  final List<MusicalEvent> events;

  @override
  String get label =>
      events.length == 1 ? 'Delete' : 'Delete ${events.length} items';

  @override
  void apply(Score score) {
    for (final event in events) {
      measure.remove(event);
    }
  }

  @override
  void revert(Score score) {
    for (final event in events) {
      measure.add(event);
    }
  }
}

/// Turns notes into rests of the same length, which keeps the measure full.
class ReplaceWithRestCommand extends EditCommand {
  ReplaceWithRestCommand({
    required this.measure,
    required this.events,
  });

  final Measure measure;
  final List<MusicalEvent> events;

  final List<Rest> _rests = [];

  @override
  String get label => 'Delete note';

  @override
  void apply(Score score) {
    if (_rests.isEmpty) {
      for (final event in events) {
        if (event is Chord) {
          _rests.add(
            Rest(
              position: event.position,
              rhythm: event.rhythm,
              voice: event.voice,
              staff: event.staff,
            ),
          );
        }
      }
    }
    for (final event in events) {
      measure.remove(event);
    }
    for (final rest in _rests) {
      measure.add(rest);
    }
  }

  @override
  void revert(Score score) {
    for (final rest in _rests) {
      measure.remove(rest);
    }
    for (final event in events) {
      measure.add(event);
    }
  }
}

/// Changes the written duration of a note or rest.
///
/// Only the event itself changes; the surrounding voice is left as it is, so a
/// caller that cares about keeping the measure full should pair this with rest
/// adjustments in a [CompositeCommand].
class SetDurationCommand extends EditCommand {
  SetDurationCommand({
    required this.event,
    required this.rhythm,
  });

  final MusicalEvent event;
  final RhythmicDuration rhythm;

  RhythmicDuration? _previous;

  @override
  String get label => 'Change duration';

  @override
  void apply(Score score) {
    switch (event) {
      case final Chord chord:
        _previous ??= chord.rhythm;
        chord.rhythm = rhythm;
      case final Rest rest:
        _previous ??= rest.rhythm;
        rest.rhythm = rhythm;
        rest.isMeasureRest = false;
    }
  }

  @override
  void revert(Score score) {
    final previous = _previous;
    if (previous == null) return;
    switch (event) {
      case final Chord chord:
        chord.rhythm = previous;
      case final Rest rest:
        rest.rhythm = previous;
    }
  }
}

/// Moves an event to a different point in its measure, voice or staff.
class MoveEventCommand extends EditCommand {
  MoveEventCommand({
    required this.event,
    this.position,
    this.voice,
    this.staff,
  });

  final MusicalEvent event;
  final Fraction? position;
  final int? voice;
  final int? staff;

  Fraction? _previousPosition;
  int? _previousVoice;
  int? _previousStaff;

  @override
  String get label => 'Move';

  @override
  void apply(Score score) {
    // Where the event was, remembered the first time this is applied and kept
    // through however many undos and redos follow.
    _previousPosition ??= event.position;
    _previousVoice ??= event.voice;
    _previousStaff ??= event.staff;
    if (position != null) event.position = position!;
    if (voice != null) event.voice = voice!;
    if (staff != null) event.staff = staff!;
  }

  @override
  void revert(Score score) {
    event.position = _previousPosition ?? event.position;
    event.voice = _previousVoice ?? event.voice;
    event.staff = _previousStaff ?? event.staff;
  }
}

/// Adds or removes an articulation on a chord.
class ToggleArticulationCommand extends EditCommand {
  ToggleArticulationCommand({
    required this.chord,
    required this.articulation,
  });

  final Chord chord;
  final Articulation articulation;

  bool _added = false;

  @override
  String get label => 'Toggle ${articulation.name}';

  @override
  void apply(Score score) {
    if (chord.articulations.contains(articulation)) {
      chord.articulations = [...chord.articulations]..remove(articulation);
      _added = false;
    } else {
      chord.articulations = [...chord.articulations, articulation];
      _added = true;
    }
  }

  @override
  void revert(Score score) {
    if (_added) {
      chord.articulations = [...chord.articulations]..remove(articulation);
    } else {
      chord.articulations = [...chord.articulations, articulation];
    }
  }
}

/// Sets the key signature from a measure onwards.
class SetKeyCommand extends EditCommand {
  SetKeyCommand({
    required this.measure,
    required this.key,
    this.staff = allStaves,
  });

  final Measure measure;
  final KeySignature key;
  final int staff;

  Map<int, KeySignature>? _previous;

  @override
  String get label => 'Change key';

  @override
  void apply(Score score) {
    final attributes = measure.attributes;
    _previous ??= {...attributes.keys};
    attributes.keys[staff] = key;
  }

  @override
  void revert(Score score) {
    final previous = _previous;
    if (previous == null) return;
    measure.attributes.keys
      ..clear()
      ..addAll(previous);
  }
}

/// Sets the time signature from a measure onwards.
class SetTimeSignatureCommand extends EditCommand {
  SetTimeSignatureCommand({
    required this.measure,
    required this.time,
  });

  final Measure measure;
  final TimeSignature time;

  TimeSignature? _previous;
  bool _hadNone = false;

  @override
  String get label => 'Change time signature';

  @override
  void apply(Score score) {
    final attributes = measure.attributes;
    _previous = attributes.time;
    _hadNone = attributes.time == null;
    attributes.time = time;
  }

  @override
  void revert(Score score) {
    measure.attributes.time = _hadNone ? null : _previous;
  }
}

/// Sets a clef from a point in a measure onwards.
class SetClefCommand extends EditCommand {
  SetClefCommand({
    required this.measure,
    required this.clef,
    this.staff = 1,
    Fraction? at,
  }) : at = at ?? Fraction.zero;

  final Measure measure;
  final Clef clef;
  final int staff;

  /// Where in the measure the change happens; zero for the usual case.
  final Fraction at;

  Clef? _previous;
  AttributeChange? _createdChange;

  @override
  String get label => 'Change clef';

  @override
  void apply(Score score) {
    var change = measure.attributeChanges
        .where((c) => c.position == at)
        .cast<AttributeChange?>()
        .firstWhere((c) => true, orElse: () => null);
    if (change == null) {
      change = AttributeChange(position: at, attributes: MeasureAttributes());
      measure.attributeChanges.add(change);
      _createdChange = change;
    }
    _previous = change.attributes.clefs[staff];
    change.attributes.clefs[staff] = clef;
  }

  @override
  void revert(Score score) {
    final created = _createdChange;
    if (created != null) {
      measure.attributeChanges.remove(created);
      _createdChange = null;
      return;
    }
    for (final change in measure.attributeChanges) {
      if (change.position != at) continue;
      if (_previous == null) {
        change.attributes.clefs.remove(staff);
      } else {
        change.attributes.clefs[staff] = _previous!;
      }
    }
  }
}

/// Inserts a measure into every part at the same index, so the parts stay
/// aligned.
class InsertMeasureCommand extends EditCommand {
  InsertMeasureCommand({
    required this.index,
    this.count = 1,
  });

  final int index;
  final int count;

  final Map<String, List<Measure>> _inserted = {};

  @override
  String get label => count == 1 ? 'Insert measure' : 'Insert $count measures';

  @override
  void apply(Score score) {
    for (final part in score.parts) {
      final context = part.contextAtMeasure(index - 1);
      final measures = <Measure>[];
      for (var i = 0; i < count; i++) {
        measures.add(
          Measure(
            number: '${index + i + 1}',
            events: [
              for (var staff = 1; staff <= part.staffCount; staff++)
                Rest.wholeMeasure(
                  measureDuration: context.time.measureDuration,
                  staff: staff,
                ),
            ],
          ),
        );
      }
      _inserted[part.id] = measures;
      part.measures.insertAll(index.clamp(0, part.measures.length), measures);
    }
    _renumber(score);
  }

  @override
  void revert(Score score) {
    for (final part in score.parts) {
      for (final measure in _inserted[part.id] ?? const <Measure>[]) {
        part.measures.remove(measure);
      }
    }
    _renumber(score);
  }
}

/// Removes measures from every part at the same index.
class DeleteMeasuresCommand extends EditCommand {
  DeleteMeasuresCommand({
    required this.index,
    this.count = 1,
  });

  final int index;
  final int count;

  final Map<String, List<Measure>> _removed = {};

  @override
  String get label => count == 1 ? 'Delete measure' : 'Delete $count measures';

  @override
  void apply(Score score) {
    for (final part in score.parts) {
      final end = (index + count).clamp(0, part.measures.length);
      final start = index.clamp(0, end);
      _removed[part.id] = part.measures.sublist(start, end);
      part.measures.removeRange(start, end);
    }
    _renumber(score);
  }

  @override
  void revert(Score score) {
    for (final part in score.parts) {
      final removed = _removed[part.id] ?? const <Measure>[];
      part.measures.insertAll(index.clamp(0, part.measures.length), removed);
    }
    _renumber(score);
  }
}

/// Renumbers measures across the score, skipping pickups as engravers do.
void _renumber(Score score) {
  for (final part in score.parts) {
    var number = 1;
    for (final measure in part.measures) {
      if (measure.implicit) {
        measure.number = '0';
        continue;
      }
      measure.number = '$number';
      if (!measure.nonControlling) number++;
    }
  }
}

/// Renames a part.
class RenamePartCommand extends EditCommand {
  RenamePartCommand({
    required this.part,
    required this.name,
    this.abbreviation,
  });

  final Part part;
  final String name;
  final String? abbreviation;

  String? _previousName;
  String? _previousAbbreviation;

  @override
  String get label => 'Rename part';

  @override
  void apply(Score score) {
    // What the part was called, remembered the first time this is applied.
    _previousName ??= part.name;
    _previousAbbreviation ??= part.abbreviation;
    part.name = name;
    if (abbreviation != null) part.abbreviation = abbreviation;
  }

  @override
  void revert(Score score) {
    part.name = _previousName ?? part.name;
    part.abbreviation = _previousAbbreviation;
  }
}
