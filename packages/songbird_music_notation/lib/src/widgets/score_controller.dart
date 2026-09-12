import 'dart:async';
import 'dart:math' as math;

import 'package:flutter/foundation.dart';
import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/layout_engine.dart';
import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_music_notation/src/painting/bravura.dart';
import 'package:songbird_score/songbird_score.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Owns everything a score view needs that outlives one frame: the score, the
/// zoom level, what is selected, and the history of edits.
///
/// Hold one of these to drive a view from outside — a toolbar button, a
/// keyboard shortcut, a menu — and to read back what the user has selected.
/// Create it once and dispose it with the widget that owns it.
class ScoreController extends ChangeNotifier {
  ScoreController({
    required Score score,
    EngravingStyle? style,
    double baseStaffSpace = 9,
    double zoom = 1,
    this.minZoom = 0.25,
    this.maxZoom = 6,
    this.maxPageWidth,
    this.deferRelayoutSlowerThan,
    SmuflFont? font,
  }) : _editor = ScoreEditor(score),
       _style = style ?? const EngravingStyle(),
       _baseStaffSpace = baseStaffSpace,
       _zoom = zoom.clamp(0.25, 6),
       _font = font ?? SmuflFont.bravuraFallback {
    _editorSubscription = _editor.changes.listen((_) {
      invalidateLayout();
      notifyListeners();
    });
    // The controller loads the font itself rather than being handed one during
    // a build: notifying listeners from inside a build is not allowed, and a
    // widget that pushed the font down would be doing exactly that.
    if (font == null) unawaited(_loadDefaultFont());
  }

  Future<void> _loadDefaultFont() async {
    final loaded = await loadBravura();
    if (_disposed) return;
    setFont(loaded);
  }

  final ScoreEditor _editor;
  late final StreamSubscription<ScoreChange> _editorSubscription;

  EngravingStyle _style;
  double _baseStaffSpace;
  double _zoom;
  SmuflFont _font;
  bool _disposed = false;
  ScoreSelection _selection = ScoreSelection.empty;
  Object? _hovered;

  ScoreLayout? _layout;
  double? _layoutWidth;
  LayoutEngine? _engine;

  /// Parts the reader has hidden, by id.
  ///
  /// Held as ids rather than as [Part]s so that a filter survives the score
  /// being read again from the same file, which is what an edit-and-reload
  /// cycle amounts to.
  final Set<String> _hiddenPartIds = {};

  /// The score as it is drawn: the whole thing, or only the parts left showing.
  Score? _visibleScore;

  /// Whether the engine in hand is following the file's own system breaks.
  bool _engineFollowsBreaks = true;

  final double minZoom;
  final double maxZoom;

  /// How long an engraving may take before a resize stops waiting for it.
  ///
  /// Dragging a window edge asks for a new width on every frame. A page of
  /// song engraves in a millisecond or two and can simply be redone each time;
  /// a symphony takes half a second, which is long enough that the desktop
  /// shell gives up waiting for the frame and says so in the log. Past this,
  /// the last engraving is drawn again while the width is moving and another
  /// is made once it settles.
  ///
  /// Null, the default, never defers: every width is engraved as it is asked
  /// for, which is what printing wants and what keeps a widget test free of
  /// a timer it did not ask for. An application showing scores of any size
  /// should set it — something well clear of a frame, say 40 milliseconds, so
  /// that a score anywhere near quick enough never takes the deferred path
  /// however busy the machine is.
  final Duration? deferRelayoutSlowerThan;

  /// The widest the music may be laid out, in staff spaces.
  ///
  /// `null`, the default, lets the score fill whatever width it is given. Set
  /// it to something like 140 to keep systems from stretching across a very
  /// wide window, which matches the proportions of printed music.
  final double? maxPageWidth;

  /// The score being shown.
  Score get score => _editor.score;

  /// The edit history. Prefer [execute], [undo] and [redo] over reaching in.
  ScoreEditor get editor => _editor;

  EngravingStyle get style => _style;

  set style(EngravingStyle value) {
    if (_style == value) return;
    _style = value;
    _engine = null;
    invalidateLayout();
    notifyListeners();
  }

  /// The music font.
  ///
  /// Starts as [SmuflFont.bravuraFallback] — the right glyphs at the
  /// specification's default measurements — and becomes the real Bravura once
  /// its metadata has loaded, a frame or two later. The difference is a
  /// fraction of a staff space, so the score does not visibly jump.
  SmuflFont get font => _font;

  /// Whether the font's own measurements have arrived.
  bool get isFontLoaded => _font.metadata != null;

  /// Replaces the music font.
  void setFont(SmuflFont font) {
    if (identical(_font, font)) return;
    _font = font;
    _engine = null;
    invalidateLayout();
    notifyListeners();
  }

  // ------------------------------------------------------------------ parts

  /// The parts currently drawn, in score order.
  ///
  /// Hiding a part hides all of its staves. Everything else about the score is
  /// untouched: the music is still there, still edited by the same commands,
  /// and still written out in full when the score is saved.
  List<Part> get visibleParts => [
    for (final part in score.parts)
      if (!_hiddenPartIds.contains(part.id)) part,
  ];

  /// Whether [part] is drawn.
  bool isPartVisible(Part part) => !_hiddenPartIds.contains(part.id);

  /// Shows or hides [part].
  void setPartVisible(Part part, bool visible) {
    final changed = visible
        ? _hiddenPartIds.remove(part.id)
        : _hiddenPartIds.add(part.id);
    if (!changed) return;
    _invalidateParts();
  }

  /// Draws only [parts], hiding every other part of the score.
  void showOnlyParts(Iterable<Part> parts) {
    final wanted = {for (final part in parts) part.id};
    final hidden = {
      for (final part in score.parts)
        if (!wanted.contains(part.id)) part.id,
    };
    if (_sameIds(hidden, _hiddenPartIds)) return;
    _hiddenPartIds
      ..clear()
      ..addAll(hidden);
    _invalidateParts();
  }

  /// Brings every part back.
  void showAllParts() {
    if (_hiddenPartIds.isEmpty) return;
    _hiddenPartIds.clear();
    _invalidateParts();
  }

  static bool _sameIds(Set<String> a, Set<String> b) =>
      a.length == b.length && a.containsAll(b);

  void _invalidateParts() {
    _visibleScore = null;
    invalidateLayout();
    notifyListeners();
  }

  // ------------------------------------------------------------------- zoom

  /// Size of a staff space in logical pixels at a zoom of 1.
  double get baseStaffSpace => _baseStaffSpace;

  set baseStaffSpace(double value) {
    if (_baseStaffSpace == value) return;
    _baseStaffSpace = value;
    invalidateLayout();
    notifyListeners();
  }

  /// The current zoom, where 1 is the score's natural size.
  double get zoom => _zoom;

  /// Size of a staff space in logical pixels right now.
  double get staffSpace => _baseStaffSpace * _zoom;

  /// The height of a five-line staff in logical pixels, which is the number
  /// most people mean by "how big is the music".
  double get staffHeight => staffSpace * 4;

  set zoom(double value) {
    final clamped = value.clamp(minZoom, maxZoom);
    if (_zoom == clamped) return;
    _zoom = clamped;
    // Zooming changes how many staff spaces fit across the viewport, so the
    // music reflows: fewer, larger measures per line. That is what a reader
    // expects from a continuous view, as opposed to magnifying a fixed page.
    invalidateLayout();
    notifyListeners();
  }

  /// One step in, following the usual ratio of about 1.2 per step.
  void zoomIn() => zoom = _zoom * 1.2;

  void zoomOut() => zoom = _zoom / 1.2;

  void resetZoom() => zoom = 1;

  /// Sets the zoom so that a staff is [pixels] logical pixels tall.
  void setStaffHeight(double pixels) => zoom = pixels / (4 * _baseStaffSpace);

  /// The zoom steps a zoom control cycles through.
  static const List<double> zoomSteps = [0.5, 0.75, 1, 1.25, 1.5, 2, 3, 4];

  /// Moves to the next larger preset.
  void zoomToNextStep() {
    for (final step in zoomSteps) {
      if (step > _zoom + 0.001) {
        zoom = step;
        return;
      }
    }
    zoom = maxZoom;
  }

  /// Moves to the next smaller preset.
  void zoomToPreviousStep() {
    for (final step in zoomSteps.reversed) {
      if (step < _zoom - 0.001) {
        zoom = step;
        return;
      }
    }
    zoom = minZoom;
  }

  // ------------------------------------------------------------ transposing

  /// The interval the score has been moved by since it was loaded.
  ///
  /// Reported so that a control can show "up a major second" rather than
  /// leaving the user to remember what they pressed.
  Interval get transposition => _transposition;
  Interval _transposition = Interval.unison;

  /// Moves the whole score by [interval] as one undoable step.
  ///
  /// Transposition is spelling-aware: up a minor third from A gives C, not
  /// B sharp, and the key signature moves with the notes.
  void transposeBy(Interval interval, {bool transposeKeys = true}) {
    if (interval.isUnison) return;
    execute(TransposeCommand(interval: interval, transposeKeys: transposeKeys));
    _transposition += interval;
  }

  /// Moves the score by [semitones], choosing the spelling that keeps the key
  /// signature readable.
  ///
  /// Up a semitone from D major gives E flat major, and up a semitone from
  /// E flat gives E — the same sound each time, spelled so that the signature
  /// stays small rather than accumulating sharps.
  void transposeBySemitones(int semitones, {bool transposeKeys = true}) {
    if (semitones == 0) return;
    final key = currentKey ?? KeySignature.cMajor;
    transposeBy(
      Interval.chromaticFromKey(semitones, key),
      transposeKeys: transposeKeys,
    );
  }

  /// Moves the score up or down by an octave.
  void transposeByOctaves(int octaves) =>
      transposeBy(Interval.octaves(octaves), transposeKeys: false);

  /// Moves the score so that the first key signature becomes [key].
  ///
  /// The direction is chosen to be the shorter way round the circle of fifths,
  /// so asking for B flat from C moves down a tone rather than up a seventh.
  void transposeToKey(KeySignature key) {
    final current = currentKey;
    if (current == null) return;
    final up = Interval.between(current.tonic(), key.tonic());
    final interval = up.chromaticSemitones.abs() <= 6
        ? up
        : (up.chromaticSemitones > 0
              ? up - Interval.octaves(1)
              : up + Interval.octaves(1));
    transposeBy(interval);
  }

  /// Puts the score back in the key it was loaded in.
  void resetTransposition() {
    if (_transposition.isUnison) return;
    transposeBy(_transposition.inverted);
    _transposition = Interval.unison;
  }

  /// The key signature at the start of the score, if it has one.
  KeySignature? get currentKey {
    if (score.parts.isEmpty) return null;
    return score.parts.first.contextAtMeasure(0).keyFor(allStaves);
  }

  // ------------------------------------------------------------- selection

  ScoreSelection get selection => _selection;

  set selection(ScoreSelection value) {
    if (_selection == value) return;
    _selection = value;
    notifyListeners();
  }

  /// The model objects to draw as selected.
  Set<Object> get selectedObjects => {
    ..._selection.events,
    ..._selection.notes,
    ..._selection.measures,
  };

  void clearSelection() => selection = ScoreSelection.empty;

  void selectEvent(MusicalEvent event, {bool add = false}) => selection = add
      ? _selection.togglingEvent(event)
      : _selection.withEvent(event);

  void selectNote(Note note, {MusicalEvent? owner, bool add = false}) {
    if (add) {
      selection = ScoreSelection(
        notes: {..._selection.notes, note},
        events: _selection.events,
      );
    } else {
      selection = _selection.withNote(note, owner: owner);
    }
  }

  /// The object under the pointer, drawn highlighted.
  Object? get hovered => _hovered;

  set hovered(Object? value) {
    if (identical(_hovered, value)) return;
    _hovered = value;
    notifyListeners();
  }

  // ---------------------------------------------------------------- editing

  bool get canUndo => _editor.canUndo;
  bool get canRedo => _editor.canRedo;
  String? get undoLabel => _editor.undoLabel;
  String? get redoLabel => _editor.redoLabel;

  /// Applies [command] and records it for undo.
  void execute(EditCommand command, {bool merge = false}) =>
      _editor.execute(command, merge: merge);

  void undo() => _editor.undo();

  void redo() => _editor.redo();

  /// Replaces the score, discarding the history and the selection.
  void replaceScore(Score score) {
    _selection = ScoreSelection.empty;
    _transposition = Interval.unison;
    // A different score has different parts; carrying a filter across would
    // hide whichever of them happened to share an id with something hidden
    // before.
    _hiddenPartIds.clear();
    _visibleScore = null;
    _editor.replaceScore(score);
  }

  // ----------------------------------------------------------------- layout

  /// Throws away the cached layout, so the next frame recomputes it.
  ///
  /// Called for you when the score, style or zoom changes; call it yourself
  /// only after editing the score behind the controller's back.
  void invalidateLayout() {
    _layout = null;
    _layoutWidth = null;
    _visibleScore = null;
  }

  /// How still the width has to be before the deferred engraving happens.
  static const Duration _relayoutQuietPeriod = Duration(milliseconds: 90);

  Timer? _relayoutTimer;
  double? _pendingWidth;

  bool get _isRelayoutSlow {
    final threshold = deferRelayoutSlowerThan;
    final last = _lastLayoutDuration;
    return threshold != null && last != null && last > threshold;
  }

  void _engraveDeferred() {
    _relayoutTimer = null;
    final width = _pendingWidth;
    _pendingWidth = null;
    if (_disposed || width == null) return;
    if (_layoutWidth != null && (_layoutWidth! - width).abs() < 0.01) return;
    _layout = null;
    _layoutWidth = null;
    notifyListeners();
  }

  /// How long the last engraving took, or null before there has been one.
  ///
  /// Only set when a layout is actually computed, so it says what a change of
  /// width or a zoom costs rather than being reset to nothing by the frames
  /// that hit the cache.
  Duration? get lastLayoutDuration => _lastLayoutDuration;
  Duration? _lastLayoutDuration;

  /// The layout for a viewport [pixelWidth] wide, computing it if needed.
  ///
  /// Layouts are cached on the width so that scrolling and repainting do not
  /// re-engrave the score every frame.
  ScoreLayout layoutFor(double pixelWidth) {
    var width = math.max(pixelWidth / staffSpace, 16.0);
    final cap = maxPageWidth;
    if (cap != null && width > cap) width = cap;
    final cached = _layout;
    if (cached != null &&
        _layoutWidth != null &&
        (_layoutWidth! - width).abs() < 0.01) {
      return cached;
    }

    // Dragging a window edge asks for a new width on every frame, and
    // engraving a symphony takes longer than a frame — long enough that the
    // desktop shell gives up waiting for one and says so. While the width is
    // still moving, the last engraving is drawn again and another is asked for
    // once it settles. A score that engraves inside a frame never gets here.
    if (cached != null && _isRelayoutSlow) {
      _pendingWidth = width;
      _relayoutTimer?.cancel();
      _relayoutTimer = Timer(_relayoutQuietPeriod, _engraveDeferred);
      return cached;
    }

    final engine = _engine ??= LayoutEngine(
      font: _font,
      style: _style.copyWith(honourSystemBreaks: _engineFollowsBreaks),
    );
    // Sharing the parts rather than copying them means a hit on this layout
    // still lands on the real score, so a filtered view stays editable.
    final drawn = _visibleScore ??= _hiddenPartIds.isEmpty
        ? score
        : score.withParts(visibleParts);
    // A part read on its own is a different engraving from the score it came
    // out of, so the score's own system breaks are let go of: kept, they leave
    // a line of one measure where the full score had a page turn.
    if (_hiddenPartIds.isEmpty != _engineFollowsBreaks) {
      _engineFollowsBreaks = _hiddenPartIds.isEmpty;
      _engine = null;
    }
    final watch = Stopwatch()..start();
    final layout = engine.layout(drawn, width: width);
    watch.stop();
    _lastLayoutDuration = watch.elapsed;
    _layout = layout;
    _layoutWidth = width;
    return layout;
  }

  /// The style actually used for painting, which follows the loaded font.
  EngravingStyle get effectiveStyle => _style.withFont(_font);

  @override
  void dispose() {
    _disposed = true;
    _relayoutTimer?.cancel();
    unawaited(_editorSubscription.cancel());
    unawaited(_editor.dispose());
    super.dispose();
  }
}
