/// Renders and edits music notation in Flutter.
///
/// Give a [ScoreController] a `Score` — from `songbird_musicxml` or built by
/// hand — and hand it to [MusicScoreView] to read, or [MusicScoreEditor] to
/// edit:
///
/// ```dart
/// final controller = ScoreController(score: score);
///
/// Column(
///   children: [
///     ScoreToolbar(controller: controller),
///     Expanded(child: MusicScoreEditor(controller: controller)),
///   ],
/// );
/// ```
///
/// The controller owns the zoom, the transposition, the selection and the undo
/// history, so a toolbar, a keyboard shortcut and a pinch gesture all drive the
/// same state.
///
/// Underneath, [LayoutEngine] turns a score into a [ScoreLayout] — a tree of
/// positioned glyphs, lines and curves measured in staff spaces — and
/// [ScorePainter] draws it. Both are usable on their own for printing, for
/// exporting an image, or for building a different widget entirely.
library;

export 'src/interaction/edit_actions.dart';
export 'src/layout/engraving_style.dart';
export 'src/layout/font_metrics.dart';
export 'src/layout/glyphs.dart';
export 'src/layout/layout_elements.dart';
export 'src/layout/layout_engine.dart';
export 'src/layout/score_layout.dart';
export 'src/layout/spacing.dart';
export 'src/layout/staff_builder.dart' show StaffMeasure;
export 'src/layout/staff_geometry.dart';
export 'src/painting/bravura.dart';
export 'src/painting/score_painter.dart';
export 'src/widgets/music_font_loader.dart';
export 'src/widgets/notation_controls.dart';
export 'src/widgets/score_canvas.dart';
export 'src/widgets/score_controller.dart';
export 'src/widgets/score_editor_view.dart';
export 'src/widgets/score_view.dart';
