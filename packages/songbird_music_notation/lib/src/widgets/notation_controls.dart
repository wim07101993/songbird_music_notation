import 'dart:math' as math;

import 'package:flutter/material.dart' hide Step;
import 'package:songbird_music_notation/src/widgets/score_controller.dart';
import 'package:songbird_score/songbird_score.dart';

/// Buttons for zooming a score.
///
/// Everything it does goes through the controller, so the same zoom can be
/// driven from a menu, a shortcut or a pinch without these buttons falling out
/// of step.
class ZoomControls extends StatelessWidget {
  const ZoomControls({
    super.key,
    required this.controller,
    this.showPercentage = true,
    this.axis = Axis.horizontal,
    this.compact = false,
  });

  final ScoreController controller;

  /// Whether to show the current zoom as a percentage between the buttons.
  final bool showPercentage;

  final Axis axis;

  /// Uses tighter spacing and no labels, for a crowded toolbar.
  final bool compact;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final children = <Widget>[
        IconButton(
          icon: const Icon(Icons.zoom_out),
          tooltip: 'Zoom out',
          onPressed: controller.zoom > controller.minZoom
              ? controller.zoomOut
              : null,
          visualDensity: compact ? VisualDensity.compact : null,
        ),
        if (showPercentage)
          _ZoomLabel(controller: controller, compact: compact),
        IconButton(
          icon: const Icon(Icons.zoom_in),
          tooltip: 'Zoom in',
          onPressed: controller.zoom < controller.maxZoom
              ? controller.zoomIn
              : null,
          visualDensity: compact ? VisualDensity.compact : null,
        ),
        if (!compact)
          IconButton(
            icon: const Icon(Icons.restart_alt),
            tooltip: 'Reset zoom',
            onPressed: (controller.zoom - 1).abs() < 0.001
                ? null
                : controller.resetZoom,
          ),
      ];

      return axis == Axis.horizontal
          ? Row(mainAxisSize: MainAxisSize.min, children: children)
          : Column(mainAxisSize: MainAxisSize.min, children: children);
    },
  );
}

class _ZoomLabel extends StatelessWidget {
  const _ZoomLabel({
    required this.controller,
    required this.compact,
  });

  final ScoreController controller;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final percentage = (controller.zoom * 100).round();
    return PopupMenuButton<double>(
      tooltip: 'Zoom level',
      initialValue: controller.zoom,
      onSelected: (value) => controller.zoom = value,
      itemBuilder: (context) => [
        for (final step in ScoreController.zoomSteps)
          PopupMenuItem(value: step, child: Text('${(step * 100).round()}%')),
      ],
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: compact ? 4 : 8),
        child: SizedBox(
          width: 48,
          child: Text(
            '$percentage%',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ),
      ),
    );
  }
}

/// A slider for the zoom, for when a continuous control suits better than
/// buttons.
class ZoomSlider extends StatelessWidget {
  const ZoomSlider({
    super.key,
    required this.controller,
    this.width = 160,
  });

  final ScoreController controller;
  final double width;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => SizedBox(
      width: width,
      child: Slider(
        // A logarithmic scale keeps the control even: the same drag doubles
        // the size wherever it starts, instead of crawling at the small end.
        value: _toSlider(controller.zoom),
        onChanged: (value) => controller.zoom = _fromSlider(value),
      ),
    ),
  );

  /// A logarithmic mapping, so that the same drag doubles the size wherever
  /// it starts instead of crawling at the small end.
  double _toSlider(double zoom) {
    final span = math.log(controller.maxZoom / controller.minZoom);
    if (span <= 0) return 0;
    return (math.log(zoom / controller.minZoom) / span).clamp(0.0, 1.0);
  }

  double _fromSlider(double value) =>
      controller.minZoom *
      math.exp(value * math.log(controller.maxZoom / controller.minZoom));
}

/// Controls for moving a score into another key.
///
/// Offers the two things people actually ask for: nudge the whole score up or
/// down a semitone, and put it in a named key. Both are undoable.
class TransposeControls extends StatelessWidget {
  const TransposeControls({
    super.key,
    required this.controller,
    this.showKeyPicker = true,
    this.compact = false,
  });

  final ScoreController controller;

  /// Whether to offer a key signature to transpose to.
  final bool showKeyPicker;

  final bool compact;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        IconButton(
          icon: const Icon(Icons.arrow_downward),
          tooltip: 'Down a semitone',
          visualDensity: compact ? VisualDensity.compact : null,
          onPressed: () => controller.transposeBySemitones(-1),
        ),
        if (!compact)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              controller.transposition.isUnison
                  ? '${controller.currentKey ?? ''}'
                  : '${controller.currentKey ?? ''} (${controller.transposition})',
              style: Theme.of(context).textTheme.labelMedium,
            ),
          ),
        IconButton(
          icon: const Icon(Icons.arrow_upward),
          tooltip: 'Up a semitone',
          visualDensity: compact ? VisualDensity.compact : null,
          onPressed: () => controller.transposeBySemitones(1),
        ),
        if (showKeyPicker) _KeyPicker(controller: controller),
        if (!compact && !controller.transposition.isUnison)
          IconButton(
            icon: const Icon(Icons.undo),
            tooltip: 'Back to the original key',
            onPressed: controller.resetTransposition,
          ),
      ],
    ),
  );
}

class _KeyPicker extends StatelessWidget {
  const _KeyPicker({
    required this.controller,
  });

  final ScoreController controller;

  @override
  Widget build(BuildContext context) {
    final current = controller.currentKey;
    return PopupMenuButton<int>(
      tooltip: 'Transpose to key',
      icon: const Icon(Icons.piano),
      initialValue: current?.fifths,
      onSelected: (fifths) => controller.transposeToKey(
        KeySignature(fifths: fifths, mode: current?.mode ?? Mode.major),
      ),
      itemBuilder: (context) => [
        for (var fifths = -7; fifths <= 7; fifths++)
          PopupMenuItem(
            value: fifths,
            child: Text(
              _keyLabel(
                KeySignature(fifths: fifths, mode: current?.mode ?? Mode.major),
              ),
            ),
          ),
      ],
    );
  }

  static String _keyLabel(KeySignature key) {
    final tonic = key.tonic();
    final accidental = switch (tonic.alter) {
      1 => '♯',
      -1 => '♭',
      2 => '𝄪',
      -2 => '𝄫',
      _ => '',
    };
    final mode = key.mode == Mode.major ? 'major' : key.mode.name;
    final count = key.fifths == 0
        ? 'no accidentals'
        : key.fifths > 0
        ? '${key.fifths} ♯'
        : '${-key.fifths} ♭';
    return '${tonic.step.name}$accidental $mode  ·  $count';
  }
}

/// A toolbar bringing together zoom, transposition and undo.
/// A button that opens the list of parts, for choosing which are drawn.
///
/// A conductor's score is read a few staves at a time — the strings, or one
/// singer's line against the accompaniment — and thirty staves at once is
/// unreadable on a screen. Hiding a part changes nothing about the music: it
/// is still edited by the same commands, still transposed, and still written
/// out in full when the score is saved.
class PartFilterButton extends StatelessWidget {
  const PartFilterButton({
    super.key,
    required this.controller,
    this.compact = false,
  });

  final ScoreController controller;

  /// Shows only the icon, without the count beside it.
  final bool compact;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) {
      final total = controller.score.parts.length;
      final shown = controller.visibleParts.length;
      final filtered = shown != total;
      final button = IconButton(
        icon: Icon(filtered ? Icons.filter_alt : Icons.filter_alt_outlined),
        isSelected: filtered,
        tooltip: filtered
            ? 'Showing $shown of $total parts'
            : 'Choose which parts to show',
        onPressed: total == 0
            ? null
            : () => showDialog<void>(
                context: context,
                builder: (context) => _PartFilterDialog(controller: controller),
              ),
      );
      if (compact || !filtered) return button;
      return Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          button,
          Text('$shown/$total', style: Theme.of(context).textTheme.labelSmall),
        ],
      );
    },
  );
}

/// The list of parts, with a checkbox each.
///
/// Kept open while parts are ticked and unticked, because choosing what to
/// read is a handful of decisions rather than one: a menu that closed on every
/// tap would have to be reopened for each staff.
class _PartFilterDialog extends StatefulWidget {
  const _PartFilterDialog({
    required this.controller,
  });

  final ScoreController controller;

  @override
  State<_PartFilterDialog> createState() => _PartFilterDialogState();
}

class _PartFilterDialogState extends State<_PartFilterDialog> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.controller;
    final parts = controller.score.parts;
    final shown = controller.visibleParts.length;

    return AlertDialog(
      title: const Text('Parts'),
      content: SizedBox(
        width: 320,
        height: math.min(420, parts.length * 56 + 8),
        child: ListView.builder(
          itemCount: parts.length,
          itemBuilder: (context, index) {
            final part = parts[index];
            final visible = controller.isPartVisible(part);
            return CheckboxListTile(
              dense: true,
              value: visible,
              title: Text(part.name.isEmpty ? part.id : part.name),
              subtitle: part.abbreviation == null
                  ? null
                  : Text(part.abbreviation!),
              onChanged: (value) => setState(
                () => controller.setPartVisible(part, value ?? false),
              ),
            );
          },
        ),
      ),
      actions: [
        // Hiding everything and ticking one back on is how someone gets to a
        // single instrument out of thirty without unticking twenty-nine.
        TextButton(
          onPressed: shown == 0
              ? null
              : () => setState(() => controller.showOnlyParts(const [])),
          child: const Text('Hide all'),
        ),
        TextButton(
          onPressed: shown == parts.length
              ? null
              : () => setState(controller.showAllParts),
          child: const Text('Show all'),
        ),
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('Done'),
        ),
      ],
    );
  }
}

class ScoreToolbar extends StatelessWidget {
  const ScoreToolbar({
    super.key,
    required this.controller,
    this.showUndo = true,
    this.showTranspose = true,
    this.showZoom = true,
    this.showPartFilter = true,
    this.leading = const [],
    this.trailing = const [],
  });

  final ScoreController controller;
  final bool showUndo;
  final bool showTranspose;
  final bool showZoom;

  /// Whether to offer the part filter, which only appears for a score that has
  /// more than one part to choose between.
  final bool showPartFilter;

  /// Extra widgets before the built-in controls.
  final List<Widget> leading;

  /// Extra widgets after them.
  final List<Widget> trailing;

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: controller,
    builder: (context, _) => SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          ...leading,
          if (showUndo) ...[
            IconButton(
              icon: const Icon(Icons.undo),
              tooltip: controller.undoLabel == null
                  ? 'Undo'
                  : 'Undo ${controller.undoLabel}',
              onPressed: controller.canUndo ? controller.undo : null,
            ),
            IconButton(
              icon: const Icon(Icons.redo),
              tooltip: controller.redoLabel == null
                  ? 'Redo'
                  : 'Redo ${controller.redoLabel}',
              onPressed: controller.canRedo ? controller.redo : null,
            ),
          ],
          if (showUndo && (showTranspose || showZoom))
            const VerticalDivider(width: 16),
          if (showTranspose)
            TransposeControls(controller: controller, compact: true),
          if (showTranspose && showZoom) const VerticalDivider(width: 16),
          if (showZoom) ZoomControls(controller: controller, compact: true),
          if (showPartFilter && controller.score.parts.length > 1) ...[
            const VerticalDivider(width: 16),
            PartFilterButton(controller: controller),
          ],
          ...trailing,
        ],
      ),
    ),
  );
}
