import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:file_selector/file_selector.dart';
import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart' show rootBundle;
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_notation_example/theme_dialog.dart';
import 'package:songbird_score/demo.dart';
import 'package:songbird_score/songbird_score.dart';

/// A small application around the notation widgets: open a MusicXML file, read
/// it, edit it, transpose it, and save it back.
class ScoreWorkbench extends StatefulWidget {
  const ScoreWorkbench({
    super.key,
  });

  @override
  State<ScoreWorkbench> createState() => _ScoreWorkbenchState();
}

class _ScoreWorkbenchState extends State<ScoreWorkbench> {
  ScoreController? _controller;
  String _fileName = 'greensleeves.musicxml';
  bool _editing = false;
  EditTool _tool = EditTool.select;
  RhythmicDuration _entryDuration = const RhythmicDuration(NoteType.quarter);
  List<String> _warnings = const [];
  bool _building = false;
  // Sepia rather than the application's own light or dark: it is the one that
  // reads like a printed score, which is what the workbench is for looking at.
  ScorePalette _palette = ScorePalette.sepia;
  bool _colourVoices = false;
  List<File> _samples = const [];

  @override
  void initState() {
    super.initState();
    _samples = _findSamples();
    _loadBundledScore();
  }

  /// The MusicXML sample set, if it has been fetched.
  ///
  /// The files are not in the repository — the licence on them is to host them
  /// where they came from, not to pass them on — so this is empty until
  /// `tool/fetch_musicxml_samples.sh` has been run, and the menu simply does
  /// not offer them.
  List<File> _findSamples() {
    for (final path in const ['samples', '../samples', '../../samples']) {
      final directory = Directory(path);
      if (!directory.existsSync()) continue;
      final files =
          directory
              .listSync()
              .whereType<File>()
              .where(
                (file) =>
                    file.path.toLowerCase().endsWith('.musicxml') ||
                    file.path.toLowerCase().endsWith('.mxl'),
              )
              .toList()
            ..sort((a, b) => a.path.compareTo(b.path));
      if (files.isNotEmpty) return files;
    }
    return const [];
  }

  Future<void> _loadSample(File file) async {
    final name = file.uri.pathSegments.last;
    setState(() => _building = true);
    await Future<void>.delayed(Duration.zero);
    try {
      final document = MusicXmlDocument.fromBytes(await file.readAsBytes());
      final result = const MusicXmlReader().readDocument(document);
      if (!mounted) return;
      setState(() => _building = false);
      _adopt(result.score, name, warnings: result.warnings);
    } on Exception catch (error) {
      if (!mounted) return;
      setState(() => _building = false);
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Could not read $name: $error')));
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _applyThemeColours();
  }

  /// Puts the chosen palette on the score.
  ///
  /// Done here rather than in `build` because changing the style notifies the
  /// controller's listeners, and notifying during a build is not allowed.
  void _applyThemeColours() {
    final controller = _controller;
    if (controller == null) return;
    var colours = _palette.colors(Theme.of(context).brightness);
    if (_colourVoices) {
      // Two voices sharing a staff are told apart by their stems, which takes
      // reading. Colour takes none.
      colours = colours.copyWith(
        voices: const {
          1: Color(0xFF1E6FE0),
          2: Color(0xFFCC5A1E),
          3: Color(0xFF2E9E5B),
          4: Color(0xFF8A4FBF),
        },
      );
    }
    controller.style = controller.style.copyWith(colors: colours);
  }

  @override
  void dispose() {
    _controller?.dispose();
    super.dispose();
  }

  Future<void> _loadBundledScore() async {
    final source = await rootBundle.loadString('assets/greensleeves.musicxml');
    final result = const MusicXmlReader().readDocument(
      MusicXmlDocument.parse(source),
    );
    _adopt(result.score, 'greensleeves.musicxml', warnings: result.warnings);
  }

  /// Builds one of the generated demo scores and shows it.
  ///
  /// Building a symphony's worth of measures takes a moment and happens on the
  /// UI thread, so the spinner is put up and given a frame to appear before the
  /// work starts — otherwise the application simply freezes with the old score
  /// on screen and nothing to say why.
  Future<void> _loadDemo(_DemoScore demo) async {
    if (demo.measures < 0) {
      await _loadBundledScore();
      return;
    }
    setState(() => _building = true);
    await Future<void>.delayed(Duration.zero);
    final score = demo.measures == 0
        ? buildShowcaseScore()
        : buildOrchestralScore(measures: demo.measures);
    if (!mounted) return;
    setState(() => _building = false);
    _adopt(score, demo.label);
  }

  void _adopt(Score score, String name, {List<String> warnings = const []}) {
    setState(() {
      _fileName = name;
      _warnings = warnings;
      final existing = _controller;
      if (existing == null) {
        _controller = ScoreController(
          score: score,
          // Dragging the window asks for a new width every frame, and a
          // symphony takes longer than a frame to engrave. Past this the last
          // engraving is redrawn while the edge is moving and another is made
          // once it settles, which is what keeps the shell from giving up on
          // the frame and saying so in the log.
          deferRelayoutSlowerThan: const Duration(milliseconds: 40),
        );
        _applyThemeColours();
      } else {
        existing.replaceScore(score);
      }
    });
  }

  Future<void> _open() async {
    final file = await openFile(
      acceptedTypeGroups: const [
        XTypeGroup(label: 'MusicXML', extensions: ['musicxml', 'xml', 'mxl']),
      ],
    );
    if (file == null) return;
    try {
      final bytes = await file.readAsBytes();
      final document = MusicXmlDocument.fromBytes(bytes);
      final result = const MusicXmlReader().readDocument(document);
      _adopt(result.score, file.name, warnings: result.warnings);
    } on Exception catch (error) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Could not read ${file.name}: $error')),
      );
    }
  }

  Future<void> _save() async {
    final controller = _controller;
    if (controller == null) return;
    final location = await getSaveLocation(
      suggestedName: _fileName.endsWith('.musicxml')
          ? _fileName
          : '$_fileName.musicxml',
    );
    if (location == null) return;
    final xml = const MusicXmlWriter().write(controller.score);
    await XFile.fromData(
      Uint8List.fromList(utf8.encode(xml)),
      mimeType: 'application/vnd.recordare.musicxml+xml',
    ).saveTo(location.path);
    if (!mounted) return;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text('Saved to ${location.path}')));
  }

  @override
  Widget build(BuildContext context) {
    final controller = _controller;
    if (controller == null || _building) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(_fileName),
        actions: [
          PopupMenuButton<Object>(
            icon: const Icon(Icons.library_music_outlined),
            tooltip: 'Load a demo score',
            onSelected: (choice) {
              if (choice is _DemoScore) {
                _loadDemo(choice);
              } else if (choice is File) {
                _loadSample(choice);
              }
            },
            itemBuilder: (context) => [
              for (final demo in _DemoScore.all)
                PopupMenuItem<Object>(
                  value: demo,
                  child: ListTile(
                    dense: true,
                    contentPadding: EdgeInsets.zero,
                    title: Text(demo.label),
                    subtitle: Text(demo.description),
                  ),
                ),
              if (_samples.isNotEmpty) ...[
                const PopupMenuDivider(),
                const PopupMenuItem<Object>(
                  enabled: false,
                  child: Text('MusicXML sample set'),
                ),
                for (final sample in _samples)
                  PopupMenuItem<Object>(
                    value: sample,
                    child: Text(
                      sample.uri.pathSegments.last.replaceAll(
                        RegExp(r'\.(musicxml|mxl)$'),
                        '',
                      ),
                    ),
                  ),
              ],
            ],
          ),
          PopupMenuButton<Object>(
            icon: const Icon(Icons.palette_outlined),
            tooltip: 'Colours',
            onSelected: (choice) => setState(() {
              if (choice is ScorePalette) {
                _palette = choice;
              } else {
                _colourVoices = !_colourVoices;
              }
              _applyThemeColours();
            }),
            itemBuilder: (context) => [
              for (final palette in ScorePalette.values)
                CheckedPopupMenuItem(
                  value: palette,
                  checked: _palette == palette,
                  child: Text(palette.label),
                ),
              const PopupMenuDivider(),
              CheckedPopupMenuItem(
                value: 'voices',
                checked: _colourVoices,
                child: const Text('Colour the voices apart'),
              ),
            ],
          ),
          IconButton(
            icon: const Icon(Icons.tune),
            tooltip: 'Every value of the score theme',
            onPressed: () => showDialog<void>(
              context: context,
              builder: (context) => ThemeDialog(controller: controller),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.folder_open),
            tooltip: 'Open a MusicXML file',
            onPressed: _open,
          ),
          IconButton(
            icon: const Icon(Icons.save_alt),
            tooltip: 'Save as MusicXML',
            onPressed: _save,
          ),
          const SizedBox(width: 8),
          SegmentedButton<bool>(
            segments: const [
              ButtonSegment(
                value: false,
                icon: Icon(Icons.visibility),
                label: Text('Read'),
              ),
              ButtonSegment(
                value: true,
                icon: Icon(Icons.edit),
                label: Text('Edit'),
              ),
            ],
            selected: {_editing},
            onSelectionChanged: (value) =>
                setState(() => _editing = value.first),
          ),
          const SizedBox(width: 12),
        ],
      ),
      body: Column(
        children: [
          Material(
            elevation: 1,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              child: ScoreToolbar(
                controller: controller,
                showUndo: _editing,
                trailing: [
                  if (_editing) ...[
                    const VerticalDivider(width: 16),
                    _ToolPicker(
                      tool: _tool,
                      onChanged: (tool) => setState(() => _tool = tool),
                    ),
                    const SizedBox(width: 8),
                    _DurationPicker(
                      duration: _entryDuration,
                      onChanged: (duration) =>
                          setState(() => _entryDuration = duration),
                    ),
                  ],
                ],
              ),
            ),
          ),
          if (_warnings.isNotEmpty) _WarningBanner(warnings: _warnings),
          Expanded(
            child: _editing
                ? MusicScoreEditor(
                    controller: controller,
                    tool: _tool,
                    entryDuration: _entryDuration,
                  )
                : MusicScoreView(controller: controller, selectable: true),
          ),
          _StatusBar(controller: controller),
        ],
      ),
    );
  }
}

/// The palettes the example offers.
///
/// Between them they make the point that a palette is a pair of choices and
/// not a switch: [sepia] is neither the light one nor the dark one, and
/// [paper] on a dark application is perfectly reasonable if that is what
/// someone wants to read.
enum ScorePalette {
  followTheme('Follow the app'),
  paper('Ink on paper'),
  night('Light on dark'),
  sepia('Sepia');

  const ScorePalette(
    this.label,
  );

  final String label;

  NotationColors colors(Brightness brightness) => switch (this) {
    ScorePalette.followTheme =>
      brightness == Brightness.dark
          ? NotationColors.dark
          : const NotationColors(),
    ScorePalette.paper => const NotationColors(),
    ScorePalette.night => NotationColors.dark,
    // Background and ink set independently of each other, which is the whole
    // point: neither is derived from the other.
    ScorePalette.sepia => const NotationColors(
      background: Color(0xFFF6EEDC),
      ink: Color(0xFF4A3A28),
      staffLines: Color(0xFF8A7658),
      editorial: Color(0xFF9A8B72),
    ),
  };
}

/// One of the generated scores the demo menu offers.
///
/// Greensleeves is two parts and eight measures, which says nothing about how
/// the widgets behave with a real score in them. These are a full orchestra
/// with chorus — thirty-three parts, two of them on two staves — at three
/// lengths, so it is possible to feel where scrolling, zooming and transposing
/// start to cost something.
class _DemoScore {
  const _DemoScore(
    this.label,
    this.measures,
    this.description,
  );

  final String label;

  /// How many measures to generate; zero for the showcase, which is a fixed
  /// few measures rather than a length, and negative for the bundled file.
  final int measures;
  final String description;

  static const all = <_DemoScore>[
    _DemoScore(
      'Greensleeves',
      -1,
      'Two parts with lyrics and chord symbols, the one it opens with',
    ),
    _DemoScore(
      'Awkward marks',
      0,
      'Braces, C clefs, repeats, hairpins, a grand staff',
    ),
    _DemoScore('Orchestra · short', 16, '33 parts, a page or two'),
    _DemoScore('Orchestra · movement', 128, '33 parts, a short movement'),
    _DemoScore(
      'Orchestra · symphony',
      512,
      '33 parts, the length of a symphony',
    ),
  ];
}

class _ToolPicker extends StatelessWidget {
  const _ToolPicker({
    required this.tool,
    required this.onChanged,
  });

  final EditTool tool;
  final ValueChanged<EditTool> onChanged;

  @override
  Widget build(BuildContext context) => SegmentedButton<EditTool>(
    showSelectedIcon: false,
    segments: const [
      ButtonSegment(
        value: EditTool.select,
        icon: Icon(Icons.pan_tool_alt),
        tooltip: 'Select and drag notes',
      ),
      ButtonSegment(
        value: EditTool.writeNotes,
        icon: Icon(Icons.edit_note),
        tooltip: 'Write notes',
      ),
      ButtonSegment(
        value: EditTool.erase,
        icon: Icon(Icons.backspace_outlined),
        tooltip: 'Erase',
      ),
    ],
    selected: {tool},
    onSelectionChanged: (value) => onChanged(value.first),
  );
}

class _DurationPicker extends StatelessWidget {
  const _DurationPicker({
    required this.duration,
    required this.onChanged,
  });

  final RhythmicDuration duration;
  final ValueChanged<RhythmicDuration> onChanged;

  static const List<(NoteType, String)> _options = [
    (NoteType.whole, '𝅝'),
    (NoteType.half, '𝅗𝅥'),
    (NoteType.quarter, '♩'),
    (NoteType.eighth, '♪'),
    (NoteType.sixteenth, '𝅘𝅥𝅯'),
  ];

  @override
  Widget build(BuildContext context) => Row(
    mainAxisSize: MainAxisSize.min,
    children: [
      DropdownButton<NoteType>(
        value: duration.type,
        underline: const SizedBox.shrink(),
        onChanged: (type) {
          if (type != null) onChanged(duration.copyWith(type: type));
        },
        items: [
          for (final (type, symbol) in _options)
            DropdownMenuItem(
              value: type,
              child: Text('$symbol  ${type.xmlName}'),
            ),
        ],
      ),
      IconButton(
        icon: const Icon(Icons.circle, size: 12),
        tooltip: 'Dotted',
        isSelected: duration.dots > 0,
        onPressed: () =>
            onChanged(duration.copyWith(dots: duration.dots > 0 ? 0 : 1)),
      ),
    ],
  );
}

class _WarningBanner extends StatelessWidget {
  const _WarningBanner({
    required this.warnings,
  });

  final List<String> warnings;

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Container(
      width: double.infinity,
      color: scheme.tertiaryContainer,
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: Text(
        warnings.length == 1
            ? warnings.single
            : '${warnings.length} things in this file needed working around: '
                  '${warnings.first}',
        style: TextStyle(color: scheme.onTertiaryContainer),
      ),
    );
  }
}

/// The line along the bottom: what is in the score, and what it last cost to
/// engrave.
///
/// The duration is measured while the score is being painted, which is after
/// this has been built, so it is read again once the frame is on screen.
/// Without that, resizing or zooming would always show the cost of the layout
/// before the one being looked at.
class _StatusBar extends StatefulWidget {
  const _StatusBar({
    required this.controller,
  });

  final ScoreController controller;

  @override
  State<_StatusBar> createState() => _StatusBarState();
}

class _StatusBarState extends State<_StatusBar> {
  Duration? _shown;

  void _catchUpAfterThisFrame() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final measured = widget.controller.lastLayoutDuration;
      // Only when it has actually changed, or this would schedule itself for
      // ever and never let the application go idle.
      if (measured == _shown) return;
      setState(() => _shown = measured);
    });
  }

  @override
  Widget build(BuildContext context) {
    _catchUpAfterThisFrame();
    final controller = widget.controller;
    return ListenableBuilder(
      listenable: controller,
      builder: (context, _) {
        final score = controller.score;
        final selection = controller.selection;
        final note = selection.affectedNotes.firstOrNull;
        final engraved = _shown;
        return Material(
          elevation: 2,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: DefaultTextStyle.merge(
              style: Theme.of(context).textTheme.bodySmall,
              child: Row(
                children: [
                  Text(
                    '${score.parts.length} '
                    '${score.parts.length == 1 ? 'part' : 'parts'} · '
                    '${score.measureCount} measures',
                  ),
                  if (engraved != null) ...[
                    const SizedBox(width: 16),
                    Text('engraved in ${engraved.inMilliseconds} ms'),
                  ],
                  const Spacer(),
                  if (note?.pitch != null) Text('${note!.pitch}'),
                  if (note?.pitch != null) const SizedBox(width: 16),
                  Text('Staff ${controller.staffHeight.round()} px'),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
