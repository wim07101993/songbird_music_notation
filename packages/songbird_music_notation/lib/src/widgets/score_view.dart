import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:songbird_music_notation/src/layout/engraving_style.dart';
import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_music_notation/src/widgets/score_canvas.dart';
import 'package:songbird_music_notation/src/widgets/score_controller.dart';
import 'package:songbird_score/songbird_score.dart';

/// Shows a score.
///
/// This is the read-only view: it draws, scrolls and zooms, and can report
/// what the reader clicked, but nothing here changes the music. Use
/// [MusicScoreEditor] when the score should be editable — the two share a
/// [ScoreController], so a view and an editor can be swapped without losing
/// the zoom level or the selection.
class MusicScoreView extends StatefulWidget {
  const MusicScoreView({
    super.key,
    required this.controller,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.selectable = false,
    this.onTapElement,
    this.scrollController,
    this.enableZoomGestures = true,
  });

  /// Builds a view over [score] with a controller of its own.
  ///
  /// Use this for the simple case; supply a [ScoreController] instead when the
  /// zoom or the selection has to be driven from elsewhere.
  static Widget forScore(
    Score score, {
    Key? key,
    EdgeInsets padding = const EdgeInsets.all(16),
    double zoom = 1,
  }) => _SelfContainedScoreView(
    key: key,
    score: score,
    padding: padding,
    zoom: zoom,
  );

  final ScoreController controller;
  final EdgeInsets padding;
  final Color? backgroundColor;

  /// Whether clicking highlights what was clicked.
  final bool selectable;

  /// Called when the reader clicks something, whether or not [selectable].
  final void Function(LayoutHit hit)? onTapElement;

  final ScrollController? scrollController;

  /// Whether pinch and ctrl+scroll change the zoom.
  final bool enableZoomGestures;

  @override
  State<MusicScoreView> createState() => _MusicScoreViewState();
}

class _MusicScoreViewState extends State<MusicScoreView> {
  double _gestureStartZoom = 1;

  /// A scroll controller of our own when the caller did not supply one, so the
  /// canvas can always be told what is on screen.
  ScrollController? _ownScroll;
  ScrollController get _scroll =>
      widget.scrollController ?? (_ownScroll ??= ScrollController());

  @override
  void dispose() {
    _ownScroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background =
        widget.backgroundColor ?? widget.controller.style.colors.background;

    return ColoredBox(
      color: background,
      child: ListenableBuilder(
        listenable: widget.controller,
        builder: (context, _) => LayoutBuilder(
          builder: (context, constraints) {
            final available =
                constraints.maxWidth -
                widget.padding.left -
                widget.padding.right;
            if (available <= 0) return const SizedBox.shrink();

            final layout = widget.controller.layoutFor(available);
            final staffSpace = widget.controller.staffSpace;
            final size = Size(
              layout.size.width * staffSpace,
              layout.size.height * staffSpace,
            );

            return _wrapGestures(
              child: SingleChildScrollView(
                controller: _scroll,
                padding: widget.padding,
                child: ScoreCanvas(
                  layout: layout,
                  controller: widget.controller,
                  size: size,
                  onTap: _handleTap,
                  onHover: widget.selectable ? _handleHover : null,
                  scrollController: _scroll,
                  padding: widget.padding,
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _wrapGestures({required Widget child}) {
    if (!widget.enableZoomGestures) return child;
    return Listener(
      onPointerSignal: (event) {
        // Ctrl+wheel zooms, as it does in every other document viewer; a plain
        // wheel is left to the scroll view.
        if (event is! PointerScrollEvent) return;
        final pressed =
            HardwareKeyboard.instance.isControlPressed ||
            HardwareKeyboard.instance.isMetaPressed;
        if (!pressed) return;
        widget.controller.zoom =
            widget.controller.zoom * (event.scrollDelta.dy > 0 ? 0.9 : 1.1);
      },
      child: GestureDetector(
        onScaleStart: (_) => _gestureStartZoom = widget.controller.zoom,
        onScaleUpdate: (details) {
          if (details.pointerCount < 2) return;
          widget.controller.zoom = _gestureStartZoom * details.scale;
        },
        child: child,
      ),
    );
  }

  void _handleTap(LayoutHit? hit) {
    if (hit == null) {
      if (widget.selectable) widget.controller.clearSelection();
      return;
    }
    widget.onTapElement?.call(hit);
    if (!widget.selectable) return;
    final note = hit.note;
    if (note != null) {
      widget.controller.selectNote(note, owner: hit.event);
      return;
    }
    final event = hit.event;
    if (event != null) widget.controller.selectEvent(event);
  }

  void _handleHover(LayoutHit? hit) {
    widget.controller.hovered = hit?.note ?? hit?.event;
  }
}

/// A score view that owns its controller, for the common read-only case.
class _SelfContainedScoreView extends StatefulWidget {
  const _SelfContainedScoreView({
    super.key,
    required this.score,
    required this.padding,
    required this.zoom,
  });

  final Score score;
  final EdgeInsets padding;
  final double zoom;

  @override
  State<_SelfContainedScoreView> createState() =>
      _SelfContainedScoreViewState();
}

class _SelfContainedScoreViewState extends State<_SelfContainedScoreView> {
  late final ScoreController _controller = ScoreController(
    score: widget.score,
    zoom: widget.zoom,
    style: const EngravingStyle(),
  );

  @override
  void didUpdateWidget(_SelfContainedScoreView oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (!identical(widget.score, oldWidget.score)) {
      _controller.replaceScore(widget.score);
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) =>
      MusicScoreView(controller: _controller, padding: widget.padding);
}
