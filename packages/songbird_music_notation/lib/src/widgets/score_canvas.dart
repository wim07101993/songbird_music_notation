import 'package:flutter/material.dart';
import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_music_notation/src/painting/score_painter.dart';
import 'package:songbird_music_notation/src/widgets/score_controller.dart';
import 'package:songbird_score/songbird_score.dart';

/// The painted surface, plus the pointer handling that turns a position into a
/// hit on the layout.
///
/// Shared by the read-only view and the editor so that both hit-test the same
/// way; the editor supplies an [overlay] for its caret and selection.
class ScoreCanvas extends StatelessWidget {
  const ScoreCanvas({
    super.key,
    required this.layout,
    required this.controller,
    required this.size,
    this.onTap,
    this.onHover,
    this.hidden = const {},
    this.overlay,
    this.scrollController,
    this.padding = EdgeInsets.zero,
  });

  final ScoreLayout layout;
  final ScoreController controller;
  final Size size;
  final void Function(LayoutHit? hit)? onTap;
  final void Function(LayoutHit? hit)? onHover;

  /// Model objects to leave undrawn, so that an editor typing over engraved
  /// text does not print the old words underneath the new ones.
  final Set<Object> hidden;
  final CustomPainter? overlay;

  /// The scroll view this canvas sits in, if it sits in one.
  ///
  /// Without it the painter has no way to know what is on screen and draws the
  /// whole score every frame, which a symphony does not survive.
  final ScrollController? scrollController;

  /// The padding the scroll view puts around the canvas, which the scroll
  /// offset counts from and the music does not.
  final EdgeInsets padding;

  /// The part of the score on screen, in staff spaces.
  Rect _visibleArea() {
    final whole = Rect.fromLTWH(0, 0, layout.size.width, layout.size.height);
    final scroll = scrollController;
    if (scroll == null || !scroll.hasClients) return whole;
    final position = scroll.position;
    if (position.viewportDimension <= 0) return whole;
    final staffSpace = controller.staffSpace;
    return Rect.fromLTWH(
      0,
      (position.pixels - padding.top) / staffSpace,
      layout.size.width,
      position.viewportDimension / staffSpace,
    );
  }

  LayoutHit? _hitAt(Offset local) {
    final staffSpace = controller.staffSpace;
    return layout.hitTest(local / staffSpace);
  }

  @override
  Widget build(BuildContext context) {
    // A score with nothing in it — a new document, or one with every part
    // filtered out — would otherwise be a blank strip with no hint of why.
    if (layout.systems.isEmpty) {
      return _NothingToShow(
        score: controller.score,
        ink: controller.effectiveStyle.colors.ink,
      );
    }

    Widget canvas = CustomPaint(
      size: size,
      painter: ScorePainter(
        layout: layout,
        font: controller.font,
        style: controller.effectiveStyle,
        staffSpace: controller.staffSpace,
        selection: controller.selectedObjects,
        hidden: hidden,
        hovered: controller.hovered,
        visibleArea: _visibleArea,
        repaint: scrollController,
      ),
      foregroundPainter: overlay,
    );

    if (onHover != null) {
      canvas = MouseRegion(
        onHover: (event) => onHover!(_hitAt(event.localPosition)),
        onExit: (_) => onHover!(null),
        child: canvas,
      );
    }

    if (onTap != null) {
      canvas = GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapUp: (details) => onTap!(_hitAt(details.localPosition)),
        child: canvas,
      );
    }

    return canvas;
  }
}

/// Stands in for the music when there is none to draw.
class _NothingToShow extends StatelessWidget {
  const _NothingToShow({
    required this.score,
    required this.ink,
  });

  final Score score;
  final Color ink;

  @override
  Widget build(BuildContext context) => SizedBox(
    height: 160,
    child: Center(
      child: Text(
        score.parts.isEmpty
            ? 'This score has no parts.'
            : 'Every part is hidden.',
        style: Theme.of(
          context,
        ).textTheme.bodyMedium?.copyWith(color: ink.withValues(alpha: 0.6)),
      ),
    ),
  );
}
