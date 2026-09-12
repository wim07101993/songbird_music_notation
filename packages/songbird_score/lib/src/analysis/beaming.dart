import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/measure.dart';
import 'package:songbird_score/src/model/notations.dart';
import 'package:songbird_score/src/theory/clef.dart';
import 'package:songbird_score/src/theory/duration.dart';
import 'package:songbird_score/src/theory/fraction.dart';
import 'package:songbird_score/src/theory/time_signature.dart';

/// Groups notes into beams and decides which way stems point.
///
/// Scores that come from an editor already carry their beams, and those are
/// honoured. Music that is generated, imported without beaming, or freshly
/// edited needs them derived, which is what this does — following the metric
/// grouping of the time signature rather than beaming everything in sight.
class Beaming {
  const Beaming._();

  /// Replaces the beams of one voice on one staff with beams derived from
  /// [time].
  ///
  /// Notes are beamed together while they stay inside one beat group and are
  /// short enough to carry a beam. Rests break a group, as do notes that reach
  /// a quarter or longer.
  static void applyTo(
    Measure measure, {
    required TimeSignature time,
    int? voice,
    int? staff,
  }) {
    final events = measure.eventsInOrder.where((event) {
      if (voice != null && event.voice != voice) return false;
      if (staff != null && event.staff != staff) return false;
      return event is Chord || event is Rest;
    }).toList();

    for (final group in _groupByBeat(events, time)) {
      _beamGroup(group);
    }
  }

  /// Splits the events of a voice into runs that may be beamed together.
  static List<List<Chord>> _groupByBeat(
    List<MusicalEvent> events,
    TimeSignature time,
  ) {
    final boundaries = time.strongBeats;
    final groups = <List<Chord>>[];
    var current = <Chord>[];

    Fraction beatStartFor(Fraction position) {
      var result = Fraction.zero;
      for (final boundary in boundaries) {
        if (boundary <= position) {
          result = boundary;
        } else {
          break;
        }
      }
      return result;
    }

    Fraction? currentBeat;
    for (final event in events) {
      if (event is! Chord ||
          event.isGrace ||
          event.rhythm.type.flagCount == 0) {
        if (current.length > 1) groups.add(current);
        current = [];
        currentBeat = null;
        continue;
      }
      final beat = beatStartFor(event.position);
      // A note that runs past the end of its beat ends the group with it.
      if (currentBeat != null && beat != currentBeat) {
        if (current.length > 1) groups.add(current);
        current = [];
      }
      currentBeat = beat;
      current.add(event);
    }
    if (current.length > 1) groups.add(current);
    return groups;
  }

  /// Assigns beams across one run of notes, including the partial hooks a
  /// sixteenth inside a group of eighths needs.
  static void _beamGroup(List<Chord> group) {
    if (group.length < 2) {
      for (final chord in group) {
        chord.beams = const [];
      }
      return;
    }
    for (var i = 0; i < group.length; i++) {
      final chord = group[i];
      final levels = chord.rhythm.type.flagCount;
      final previous = i > 0 ? group[i - 1].rhythm.type.flagCount : 0;
      final next = i < group.length - 1
          ? group[i + 1].rhythm.type.flagCount
          : 0;
      final beams = <Beam>[];
      for (var level = 1; level <= levels; level++) {
        final continuesBack = level <= previous;
        final continuesForward = level <= next;
        final BeamState state;
        if (continuesBack && continuesForward) {
          state = BeamState.continueBeam;
        } else if (continuesForward) {
          state = BeamState.begin;
        } else if (continuesBack) {
          state = BeamState.end;
        } else {
          // A lone short note inside the group gets a hook, pointing towards
          // whichever neighbour it groups with rhythmically.
          state = i == 0 ? BeamState.forwardHook : BeamState.backwardHook;
        }
        beams.add(Beam(level: level, state: state));
      }
      chord.beams = beams;
    }
  }

  /// Chooses stem directions for a voice.
  ///
  /// With one voice on a staff, the stem points away from the middle line and
  /// a beamed group takes a single direction decided by the note furthest from
  /// the centre. With more than one voice, the upper voice stems up and the
  /// lower stems down, which is what keeps two lines readable.
  static void applyStemDirections(
    Measure measure, {
    required Clef clef,
    int? staff,
  }) {
    final staffEvents = measure.eventsInOrder.where(
      (event) => staff == null || event.staff == staff,
    );
    final voices = staffEvents.map((e) => e.voice).toSet().toList()..sort();

    for (final voice in voices) {
      final chords = staffEvents
          .whereType<Chord>()
          .where((chord) => chord.voice == voice)
          .toList();
      if (chords.isEmpty) continue;

      if (voices.length > 1) {
        final direction = voice == voices.first
            ? StemDirection.up
            : StemDirection.down;
        for (final chord in chords) {
          chord.stem = direction;
        }
        continue;
      }

      for (final group in _beamRuns(chords)) {
        var extreme = 0;
        var extremeDistance = -1;
        for (final chord in group) {
          for (final note in chord.notes) {
            final pitch = note.displayPitch;
            if (pitch == null) continue;
            final position = clef.staffPositionOf(pitch);
            final distance = (position - Clef.middleLinePosition).abs();
            if (distance > extremeDistance) {
              extremeDistance = distance;
              extreme = position;
            }
          }
        }
        final direction = extreme > Clef.middleLinePosition
            ? StemDirection.down
            : StemDirection.up;
        for (final chord in group) {
          chord.stem = direction;
        }
      }
    }
  }

  /// Splits chords into beamed runs plus singletons, so that stem direction is
  /// decided per run.
  static List<List<Chord>> _beamRuns(List<Chord> chords) {
    final runs = <List<Chord>>[];
    var current = <Chord>[];
    for (final chord in chords) {
      final starts = chord.beams.any((b) => b.state == BeamState.begin);
      final ends = chord.beams.any((b) => b.state == BeamState.end);
      final continues = chord.beams.any(
        (b) => b.state == BeamState.continueBeam,
      );
      if (starts) {
        if (current.isNotEmpty) runs.add(current);
        current = [chord];
      } else if (continues || ends) {
        current.add(chord);
        if (ends) {
          runs.add(current);
          current = [];
        }
      } else {
        if (current.isNotEmpty) {
          runs.add(current);
          current = [];
        }
        runs.add([chord]);
      }
    }
    if (current.isNotEmpty) runs.add(current);
    return runs;
  }
}

/// Fills gaps in a voice with rests so that every measure is rhythmically
/// complete, which is what a renderer and a player both assume.
class RestFilling {
  const RestFilling._();

  /// Adds rests to [measure] wherever [voice] has a gap, up to [measureLength].
  static List<Rest> fill(
    Measure measure, {
    required int voice,
    required int staff,
    required Fraction measureLength,
  }) {
    final events = measure.eventsInOrder
        .where((e) => e.voice == voice && e.staff == staff)
        .where((e) => e is Chord || e is Rest)
        .toList();
    final added = <Rest>[];
    var cursor = Fraction.zero;
    for (final event in events) {
      if (event.position > cursor) {
        added.addAll(
          _restsFor(
            cursor,
            event.position - cursor,
            voice: voice,
            staff: staff,
          ),
        );
      }
      final end = event.endPosition;
      if (end > cursor) cursor = end;
    }
    if (cursor < measureLength) {
      added.addAll(
        _restsFor(cursor, measureLength - cursor, voice: voice, staff: staff),
      );
    }
    for (final rest in added) {
      measure.add(rest);
    }
    return added;
  }

  static List<Rest> _restsFor(
    Fraction start,
    Fraction length, {
    required int voice,
    required int staff,
  }) {
    final result = <Rest>[];
    var at = start;
    for (final rhythm in RhythmicDuration.decompose(length)) {
      result.add(
        Rest(position: at, rhythm: rhythm, voice: voice, staff: staff),
      );
      at = at + rhythm.value;
    }
    return result;
  }
}
