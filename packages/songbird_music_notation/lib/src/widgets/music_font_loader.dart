import 'package:flutter/widgets.dart';
import 'package:songbird_music_notation/src/painting/bravura.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// Loads the music font and hands it to its child.
///
/// The font's metadata is an asset, so it arrives a frame or two after the
/// widget is first built. Rather than showing nothing until then, the builder
/// is called immediately with [SmuflFont.bravuraFallback] — the same glyphs at
/// the specification's default measurements — and again with the real
/// measurements once they load. The difference is a fraction of a staff space,
/// so the score does not visibly jump.
class MusicFontLoader extends StatefulWidget {
  const MusicFontLoader({
    super.key,
    required this.builder,
    this.font,
    this.loading,
  });

  /// Called with the font to draw with.
  final Widget Function(BuildContext context, SmuflFont font) builder;

  /// A font to use instead of the bundled Bravura.
  final SmuflFont? font;

  /// Shown instead of the fallback while the metadata loads. Leave this null
  /// to draw immediately with default measurements.
  final Widget? loading;

  @override
  State<MusicFontLoader> createState() => _MusicFontLoaderState();
}

class _MusicFontLoaderState extends State<MusicFontLoader> {
  SmuflFont? _font;

  @override
  void initState() {
    super.initState();
    _load();
  }

  @override
  void didUpdateWidget(MusicFontLoader oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.font != oldWidget.font) _load();
  }

  Future<void> _load() async {
    final provided = widget.font;
    if (provided != null) {
      setState(() => _font = provided);
      return;
    }
    final loaded = await loadBravura();
    if (mounted) setState(() => _font = loaded);
  }

  @override
  Widget build(BuildContext context) {
    final font = _font;
    if (font == null && widget.loading != null) return widget.loading!;
    return widget.builder(context, font ?? SmuflFont.bravuraFallback);
  }
}
