import 'package:flutter/painting.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_music_notation/src/layout/staff_geometry.dart';
import 'package:songbird_score/songbird_score.dart';

/// One staff of one part within a system.
///
/// Its [elements] are positioned in system x and staff-local y, so that the
/// painter can draw a whole staff with one canvas translation and the vertical
/// stacking of staves can be decided after their contents are known.
class StaffLayout {
  StaffLayout({
    required this.geometry,
    required this.elements,
    required this.contentTop,
    required this.contentBottom,
    this.pageTop = 0,
  });

  /// The staff's own geometry, with its top line at y zero.
  ///
  /// Local rather than absolute so that it agrees with [elements]: asking the
  /// geometry where a pitch goes gives a number that can be compared with an
  /// element's position directly. Use [pageY] to move into page coordinates.
  final StaffGeometry geometry;

  /// Drawables in system x, staff-local y — y zero is the top staff line.
  final List<LayoutElement> elements;

  /// Page y of this staff's top line.
  final double pageTop;

  /// How far the contents reach above the top line, as a positive number.
  final double contentTop;

  /// How far the contents reach below the bottom line, as a positive number.
  final double contentBottom;

  Part get part => geometry.part;

  int get staffNumber => geometry.staffNumber;

  /// Total vertical space this staff needs.
  double get totalHeight => contentTop + geometry.height + contentBottom;

  /// Page y for a staff-local y.
  double pageY(double localY) => pageTop + localY;

  /// Page y of the bottom staff line.
  double get pageBottom => pageTop + geometry.height;

  /// Page y of the middle line.
  double get pageMiddle => pageTop + geometry.middle;

  /// The staff position under a page y, which is what turns a click into a
  /// pitch.
  int staffPositionAtPage(double y) => geometry.staffPositionAt(y - pageTop);
}

/// One measure's slot within a system.
class MeasureSlot {
  MeasureSlot({
    required this.index,
    required this.left,
    required this.width,
    required this.musicLeft,
    required this.musicRight,
    required this.columnPositions,
  });

  /// Index of this measure within each part.
  final int index;

  /// x of the measure's left edge within the system.
  final double left;

  final double width;

  /// x where the notes start, after any clef or key printed in the measure.
  final double musicLeft;

  /// x where the notes end, before the gap and the barline that close the
  /// measure.
  final double musicRight;

  /// x of each rhythmic position in the measure, shared by every part.
  final Map<Fraction, double> columnPositions;

  double get right => left + width;

  /// x of [position] within the measure, falling back to proportional
  /// placement for a position no part actually used.
  double xFor(Fraction position) {
    final exact = columnPositions[position];
    if (exact != null) return exact;
    if (columnPositions.isEmpty) return musicLeft;
    Fraction? bestKey;
    for (final key in columnPositions.keys) {
      if (key <= position && (bestKey == null || key > bestKey)) bestKey = key;
    }
    return bestKey == null ? musicLeft : columnPositions[bestKey]!;
  }
}

/// One line of music across the page: every part, for a run of measures.
class SystemLayout {
  SystemLayout({
    required this.index,
    required this.top,
    required this.left,
    required this.width,
    required this.staves,
    required this.measures,
    required this.elements,
    required this.height,
  });

  /// Position of this system in the score, counting from 0.
  final int index;

  /// Page y of the system's first staff line.
  final double top;

  /// Page x of the system's left edge.
  final double left;

  final double width;

  /// Every staff of every part, top to bottom.
  final List<StaffLayout> staves;

  final List<MeasureSlot> measures;

  /// Drawables belonging to the system rather than to one staff: barlines that
  /// run between staves, brackets, part names.
  final List<LayoutElement> elements;

  final double height;

  Rect get bounds => Rect.fromLTWH(left, top, width, height);

  /// The staff of [part] numbered [staffNumber], if this system has it.
  StaffLayout? staffFor(Part part, int staffNumber) {
    for (final staff in staves) {
      if (identical(staff.part, part) && staff.staffNumber == staffNumber) {
        return staff;
      }
    }
    return null;
  }

  /// The measure slot containing page x, or `null` outside the system.
  MeasureSlot? measureAtX(double x) {
    final local = x - left;
    for (final measure in measures) {
      if (local >= measure.left && local < measure.right) return measure;
    }
    return measures.isEmpty ? null : measures.last;
  }
}

/// A complete laid-out score, ready to paint or hit-test.
class ScoreLayout {
  ScoreLayout({
    required this.score,
    required this.systems,
    required this.headerElements,
    required this.size,
    required this.staffSpace,
  });

  final Score score;

  final List<SystemLayout> systems;

  /// Title, composer and other page furniture, in page coordinates.
  final List<LayoutElement> headerElements;

  /// The whole page, in staff spaces.
  final Size size;

  /// The staff space this layout was measured in, in the same units as [size].
  ///
  /// Always 1: layout is in staff spaces and the painter scales. Kept explicit
  /// so that code converting to pixels reads clearly.
  final double staffSpace;

  bool get isEmpty => systems.isEmpty;

  /// The system containing page y, or the nearest one.
  SystemLayout? systemAtY(double y) {
    for (final system in systems) {
      if (y >= system.top - system.height * 0.2 &&
          y <= system.top + system.height * 1.2) {
        return system;
      }
    }
    return null;
  }

  /// The page-space bounds of everything drawn for [event], or `null` when
  /// nothing was.
  ///
  /// Pass a [role] to ask about one kind of drawable — where the lyric under a
  /// chord ended up, say, rather than the whole chord. This is what lets an
  /// editor put a text field exactly where the text it edits is printed.
  Rect? boundsOfEvent(MusicalEvent event, {ElementRole? role}) => boundsWhere(
    (element) =>
        (role == null || element.role == role) &&
        (identical(element.owner, event) || identical(element.source, event)),
  );

  /// The page-space bounds of every element [test] accepts, taken together.
  ///
  /// Elements are stored in three coordinate systems — page, system-local and
  /// staff-local — so finding where something ended up on the page means
  /// walking all three and undoing the translations the painter applies.
  Rect? boundsWhere(bool Function(LayoutElement element) test) {
    Rect? found;
    void include(Rect rect) =>
        found = found == null ? rect : found!.expandToInclude(rect);

    for (final element in headerElements) {
      if (test(element)) include(element.bounds);
    }
    for (final system in systems) {
      for (final element in system.elements) {
        if (test(element)) {
          include(element.bounds.shift(Offset(system.left, system.top)));
        }
      }
      for (final staff in system.staves) {
        for (final element in staff.elements) {
          if (test(element)) {
            include(element.bounds.shift(Offset(system.left, staff.pageTop)));
          }
        }
      }
    }
    return found;
  }

  /// Everything under [point], nearest first.
  ///
  /// Returns the elements rather than one winner so that a caller can prefer a
  /// notehead over the staff line behind it, which [hitTest] does.
  List<LayoutHit> hitTestAll(Offset point, {double tolerance = 0.3}) {
    final hits = <LayoutHit>[];
    for (final element in headerElements) {
      if (element.hitTest(point, tolerance: tolerance)) {
        hits.add(LayoutHit(element: element));
      }
    }
    for (final system in systems) {
      if (!system.bounds.inflate(system.height).contains(point)) continue;
      final systemLocal = point - Offset(system.left, system.top);
      for (final element in system.elements) {
        if (element.hitTest(systemLocal, tolerance: tolerance)) {
          hits.add(LayoutHit(element: element, system: system));
        }
      }
      for (final staff in system.staves) {
        final staffLocal = Offset(
          point.dx - system.left,
          point.dy - staff.pageTop,
        );
        for (final element in staff.elements) {
          if (element.hitTest(staffLocal, tolerance: tolerance)) {
            hits.add(LayoutHit(element: element, system: system, staff: staff));
          }
        }
      }
    }
    return hits;
  }

  /// The most interesting thing under [point].
  ///
  /// Noteheads win over stems, stems over staff lines, so that clicking a note
  /// selects the note and not the line it happens to sit on.
  LayoutHit? hitTest(Offset point, {double tolerance = 0.3}) {
    final hits = hitTestAll(point, tolerance: tolerance);
    if (hits.isEmpty) return null;
    hits.sort(
      (a, b) => _priority(b.element.role).compareTo(_priority(a.element.role)),
    );
    return hits.first;
  }

  static int _priority(ElementRole role) => switch (role) {
    ElementRole.notehead => 100,
    ElementRole.rest => 95,
    ElementRole.accidental => 90,
    ElementRole.lyric => 85,
    ElementRole.dynamics => 80,
    ElementRole.articulation || ElementRole.ornament => 75,
    ElementRole.augmentationDot => 70,
    ElementRole.flag => 60,
    ElementRole.stem => 55,
    ElementRole.beam => 50,
    ElementRole.slur || ElementRole.tie => 45,
    ElementRole.clef ||
    ElementRole.keySignature ||
    ElementRole.timeSignature => 40,
    ElementRole.barline => 30,
    ElementRole.text || ElementRole.partName => 20,
    ElementRole.ledgerLine => 10,
    ElementRole.staffLine => 5,
    _ => 1,
  };
}

/// Something found under a point, with the context needed to act on it.
class LayoutHit {
  const LayoutHit({
    required this.element,
    this.system,
    this.staff,
  });

  final LayoutElement element;
  final SystemLayout? system;
  final StaffLayout? staff;

  /// The model object the element came from.
  Object? get source => element.source;

  /// The event the element belongs to, whether it is the event itself or one
  /// of its noteheads.
  MusicalEvent? get event =>
      element.owner ??
      (element.source is MusicalEvent ? element.source! as MusicalEvent : null);

  /// The notehead, when one was hit.
  Note? get note => element.source is Note ? element.source! as Note : null;
}
