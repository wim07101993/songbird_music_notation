import 'package:flutter/material.dart' hide Step;
import 'package:songbird_music_notation/songbird_music_notation.dart';

/// One adjustable number in the score's theme.
///
/// Written as a list of these rather than as thirty hand-built sliders,
/// because the interesting part of each is only its name and its range: what
/// it does is [EngravingStyle]'s business, and this is a window onto it.
class _Measure {
  const _Measure(
    this.label,
    this.read,
    this.write, {
    required this.min,
    required this.max,
    this.description,
  });

  final String label;
  final String? description;
  final double Function(EngravingStyle style) read;
  final EngravingStyle Function(EngravingStyle style, double value) write;
  final double min;
  final double max;
}

const _measures = <_Measure>[
  _Measure(
    'Staff distance',
    _staffDistance,
    _setStaffDistance,
    min: 4,
    max: 20,
    description: 'Between the two staves of one instrument',
  ),
  _Measure(
    'System distance',
    _systemDistance,
    _setSystemDistance,
    min: 4,
    max: 30,
  ),
  _Measure('Part distance', _partDistance, _setPartDistance, min: 4, max: 24),
  _Measure('Page margin', _pageMargin, _setPageMargin, min: 0, max: 20),
  _Measure(
    'Note spacing',
    _spacingWidth,
    _setSpacingWidth,
    min: 2,
    max: 10,
    description: 'Room a quarter note is given before the curve is applied',
  ),
  _Measure(
    'Spacing curve',
    _spacingExponent,
    _setSpacingExponent,
    min: 0.2,
    max: 1,
    description: '1 gives a half note twice a quarter; engravers use about 0.6',
  ),
  _Measure(
    'Least note spacing',
    _minimumNoteSpacing,
    _setMinimumNoteSpacing,
    min: 0.5,
    max: 5,
  ),
  _Measure(
    'Between rows of marks',
    _directionGap,
    _setDirectionGap,
    min: 0,
    max: 3,
    description: 'A tempo mark under a rehearsal letter, a coda under that',
  ),
  _Measure('Stem length', _stemLength, _setStemLength, min: 2, max: 6),
  _Measure('Slur height', _slurHeight, _setSlurHeight, min: 0.4, max: 4),
  _Measure('Air around a slur', _slurGap, _setSlurGap, min: 0, max: 2),
  _Measure(
    'Air before an arpeggio',
    _arpeggioGap,
    _setArpeggioGap,
    min: 0,
    max: 2,
  ),
  _Measure('Air before a barline', _barlineGap, _setBarlineGap, min: 0, max: 4),
  _Measure(
    'Air after a barline',
    _measureLeftPadding,
    _setMeasureLeftPadding,
    min: 0,
    max: 4,
  ),
  _Measure('Gap after a clef', _clefGap, _setClefGap, min: 0, max: 4),
  _Measure('Gap after a time signature', _timeGap, _setTimeGap, min: 0, max: 4),
  _Measure('Lyric size', _lyricFontSize, _setLyricFontSize, min: 0.8, max: 4),
  _Measure('Text size', _textFontSize, _setTextFontSize, min: 0.8, max: 4),
  _Measure(
    'Chord symbol size',
    _chordFontSize,
    _setChordFontSize,
    min: 0.8,
    max: 5,
  ),
  _Measure('Fret number size', _tabFontSize, _setTabFontSize, min: 0.6, max: 3),
  _Measure(
    'Repeat ending number size',
    _endingFontSize,
    _setEndingFontSize,
    min: 0.8,
    max: 4,
  ),
  _Measure(
    'Repeat ending hook length',
    _endingHookLength,
    _setEndingHookLength,
    min: 0.5,
    max: 4,
  ),
  _Measure('Title size', _titleFontSize, _setTitleFontSize, min: 1, max: 8),
  _Measure(
    'Part name size',
    _partNameFontSize,
    _setPartNameFontSize,
    min: 0.8,
    max: 4,
  ),
  _Measure(
    'Grace note size',
    _graceNoteScale,
    _setGraceNoteScale,
    min: 0.3,
    max: 1,
  ),
  _Measure('Cue note size', _cueNoteScale, _setCueNoteScale, min: 0.3, max: 1),
  _Measure(
    'Clef change size',
    _clefChangeScale,
    _setClefChangeScale,
    min: 0.4,
    max: 1,
  ),
];

double _staffDistance(EngravingStyle s) => s.staffDistance;
EngravingStyle _setStaffDistance(EngravingStyle s, double v) =>
    s.copyWith(staffDistance: v);
double _systemDistance(EngravingStyle s) => s.systemDistance;
EngravingStyle _setSystemDistance(EngravingStyle s, double v) =>
    s.copyWith(systemDistance: v);
double _partDistance(EngravingStyle s) => s.partDistance;
EngravingStyle _setPartDistance(EngravingStyle s, double v) =>
    s.copyWith(partDistance: v);
double _pageMargin(EngravingStyle s) => s.pageMargin;
EngravingStyle _setPageMargin(EngravingStyle s, double v) =>
    s.copyWith(pageMargin: v);
double _spacingWidth(EngravingStyle s) => s.spacingWidth;
EngravingStyle _setSpacingWidth(EngravingStyle s, double v) =>
    s.copyWith(spacingWidth: v);
double _spacingExponent(EngravingStyle s) => s.spacingExponent;
EngravingStyle _setSpacingExponent(EngravingStyle s, double v) =>
    s.copyWith(spacingExponent: v);
double _minimumNoteSpacing(EngravingStyle s) => s.minimumNoteSpacing;
EngravingStyle _setMinimumNoteSpacing(EngravingStyle s, double v) =>
    s.copyWith(minimumNoteSpacing: v);
double _directionGap(EngravingStyle s) => s.directionGap;
EngravingStyle _setDirectionGap(EngravingStyle s, double v) =>
    s.copyWith(directionGap: v);
double _stemLength(EngravingStyle s) => s.stemLength;
EngravingStyle _setStemLength(EngravingStyle s, double v) =>
    s.copyWith(stemLength: v);
double _arpeggioGap(EngravingStyle s) => s.arpeggioGap;
EngravingStyle _setArpeggioGap(EngravingStyle s, double v) =>
    s.copyWith(arpeggioGap: v);
double _slurGap(EngravingStyle s) => s.slurGap;
EngravingStyle _setSlurGap(EngravingStyle s, double v) =>
    s.copyWith(slurGap: v);
double _slurHeight(EngravingStyle s) => s.slurHeight;
EngravingStyle _setSlurHeight(EngravingStyle s, double v) =>
    s.copyWith(slurHeight: v);
double _barlineGap(EngravingStyle s) => s.barlineGap;
EngravingStyle _setBarlineGap(EngravingStyle s, double v) =>
    s.copyWith(barlineGap: v);
double _measureLeftPadding(EngravingStyle s) => s.measureLeftPadding;
EngravingStyle _setMeasureLeftPadding(EngravingStyle s, double v) =>
    s.copyWith(measureLeftPadding: v);
double _clefGap(EngravingStyle s) => s.clefGap;
EngravingStyle _setClefGap(EngravingStyle s, double v) =>
    s.copyWith(clefGap: v);
double _timeGap(EngravingStyle s) => s.timeGap;
EngravingStyle _setTimeGap(EngravingStyle s, double v) =>
    s.copyWith(timeGap: v);
double _lyricFontSize(EngravingStyle s) => s.lyricFontSize;
EngravingStyle _setLyricFontSize(EngravingStyle s, double v) =>
    s.copyWith(lyricFontSize: v);
double _textFontSize(EngravingStyle s) => s.textFontSize;
EngravingStyle _setTextFontSize(EngravingStyle s, double v) =>
    s.copyWith(textFontSize: v);
double _tabFontSize(EngravingStyle s) => s.tabFontSize;
EngravingStyle _setTabFontSize(EngravingStyle s, double v) =>
    s.copyWith(tabFontSize: v);
double _endingFontSize(EngravingStyle s) => s.endingFontSize;
EngravingStyle _setEndingFontSize(EngravingStyle s, double v) =>
    s.copyWith(endingFontSize: v);
double _endingHookLength(EngravingStyle s) => s.endingHookLength;
EngravingStyle _setEndingHookLength(EngravingStyle s, double v) =>
    s.copyWith(endingHookLength: v);
double _chordFontSize(EngravingStyle s) => s.chordFontSize;
EngravingStyle _setChordFontSize(EngravingStyle s, double v) =>
    s.copyWith(chordFontSize: v);
double _titleFontSize(EngravingStyle s) => s.titleFontSize;
EngravingStyle _setTitleFontSize(EngravingStyle s, double v) =>
    s.copyWith(titleFontSize: v);
double _partNameFontSize(EngravingStyle s) => s.partNameFontSize;
EngravingStyle _setPartNameFontSize(EngravingStyle s, double v) =>
    s.copyWith(partNameFontSize: v);
double _graceNoteScale(EngravingStyle s) => s.graceNoteScale;
EngravingStyle _setGraceNoteScale(EngravingStyle s, double v) =>
    s.copyWith(graceNoteScale: v);
double _cueNoteScale(EngravingStyle s) => s.cueNoteScale;
EngravingStyle _setCueNoteScale(EngravingStyle s, double v) =>
    s.copyWith(cueNoteScale: v);
double _clefChangeScale(EngravingStyle s) => s.clefChangeScale;
EngravingStyle _setClefChangeScale(EngravingStyle s, double v) =>
    s.copyWith(clefChangeScale: v);

/// One colour of the palette.
class _Ink {
  const _Ink(
    this.label,
    this.read,
    this.write, {
    this.description,
  });

  final String label;
  final String? description;
  final Color Function(NotationColors colors) read;
  final NotationColors Function(NotationColors colors, Color value) write;
}

const _inks = <_Ink>[
  _Ink('Ink', _ink, _setInk, description: 'Notes, stems, beams and text'),
  _Ink('Staff lines', _staffLines, _setStaffLines),
  _Ink('Background', _background, _setBackground),
  _Ink('Selection', _selection, _setSelection),
  _Ink('Cursor', _cursor, _setCursor),
  _Ink('Editorial', _editorial, _setEditorial, description: 'Cautionary marks'),
];

Color _ink(NotationColors c) => c.ink;
NotationColors _setInk(NotationColors c, Color v) => c.copyWith(ink: v);
Color _staffLines(NotationColors c) => c.staffLines;
NotationColors _setStaffLines(NotationColors c, Color v) =>
    c.copyWith(staffLines: v);
Color _background(NotationColors c) => c.background;
NotationColors _setBackground(NotationColors c, Color v) =>
    c.copyWith(background: v);
Color _selection(NotationColors c) => c.selection;
NotationColors _setSelection(NotationColors c, Color v) =>
    c.copyWith(selection: v);
Color _cursor(NotationColors c) => c.cursor;
NotationColors _setCursor(NotationColors c, Color v) => c.copyWith(cursor: v);
Color _editorial(NotationColors c) => c.editorial;
NotationColors _setEditorial(NotationColors c, Color v) =>
    c.copyWith(editorial: v);

/// Every value of the score's theme, in one place, applied as it is changed.
///
/// A theme is only worth having if it can be seen: the score behind this
/// redraws on every move of a slider, so what a value does is a matter of
/// looking rather than of reading a doc comment.
class ThemeDialog extends StatefulWidget {
  const ThemeDialog({
    super.key,
    required this.controller,
  });

  final ScoreController controller;

  @override
  State<ThemeDialog> createState() => _ThemeDialogState();
}

class _ThemeDialogState extends State<ThemeDialog> {
  /// Captured when the dialog opens, not when the undo button is first read:
  /// a `late final` initialised on access would have recorded whatever the
  /// theme had already been changed to.
  late final EngravingStyle _startedWith;

  @override
  void initState() {
    super.initState();
    _startedWith = widget.controller.style;
  }

  EngravingStyle get _style => widget.controller.style;
  set _style(EngravingStyle value) =>
      setState(() => widget.controller.style = value);

  NotationColors get _colors => _style.colors;
  set _colors(NotationColors value) => _style = _style.copyWith(colors: value);

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: const Text('Score theme'),
    content: SizedBox(
      width: 460,
      height: 560,
      child: ListView(
        children: [
          _heading(context, 'Colours'),
          for (final ink in _inks)
            _ColorRow(
              label: ink.label,
              description: ink.description,
              color: ink.read(_colors),
              onChanged: (value) => _colors = ink.write(_colors, value),
            ),
          SwitchListTile(
            dense: true,
            title: const Text('Use colours written into the file'),
            subtitle: const Text(
              'Off makes the palette win, which rescues a dark page from a '
              'file whose notes were exported black',
            ),
            value: _colors.honourSourceColors,
            onChanged: (value) =>
                _colors = _colors.copyWith(honourSourceColors: value),
          ),

          _heading(context, 'Fonts'),
          _FontRow(
            label: 'Lyrics',
            value: _style.fonts.lyrics,
            onChanged: (value) => _style = _style.copyWith(
              fonts: _style.fonts.copyWith(lyrics: value),
            ),
          ),
          _FontRow(
            label: 'Chord symbols',
            value: _style.fonts.chords,
            onChanged: (value) => _style = _style.copyWith(
              fonts: _style.fonts.copyWith(chords: value),
            ),
          ),
          _FontRow(
            label: 'Everything else',
            value: _style.fonts.text,
            onChanged: (value) => _style = _style.copyWith(
              fonts: _style.fonts.copyWith(text: value),
            ),
          ),
          const ListTile(
            dense: true,
            title: Text('Music'),
            subtitle: Text(
              'Comes from the SMuFL font the controller is given, so that the '
              'glyphs and the measurements that space them agree',
            ),
          ),

          _heading(context, 'Lines and numbering'),
          ListTile(
            dense: true,
            title: const Text('Measure numbers'),
            subtitle: const Text(
              'The first measure of a line is always numbered, so a line is '
              'never left unlabelled',
            ),
            trailing: DropdownButton<MeasureNumbering>(
              value: _numberingValue,
              onChanged: (value) {
                if (value != null) {
                  _style = _style.copyWith(measureNumbers: value);
                }
              },
              items: const [
                DropdownMenuItem(
                  value: MeasureNumbering.none,
                  child: Text('None'),
                ),
                DropdownMenuItem(
                  value: MeasureNumbering.everySystem,
                  child: Text('Each line only'),
                ),
                DropdownMenuItem(
                  value: MeasureNumbering.every(2),
                  child: Text('Every 2 measures'),
                ),
                DropdownMenuItem(
                  value: MeasureNumbering.every(5),
                  child: Text('Every 5 measures'),
                ),
                DropdownMenuItem(
                  value: MeasureNumbering.every(10),
                  child: Text('Every 10 measures'),
                ),
              ],
            ),
          ),
          ListTile(
            dense: true,
            title: const Text('Measures per line'),
            subtitle: const Text('Fill the line, or break to a fixed count'),
            trailing: DropdownButton<int>(
              value: _style.measuresPerSystem ?? 0,
              onChanged: (value) => _style = _style.copyWith(
                measuresPerSystem: value == 0 ? null : value,
              ),
              items: const [
                DropdownMenuItem(value: 0, child: Text('Fill the line')),
                DropdownMenuItem(value: 2, child: Text('2 a line')),
                DropdownMenuItem(value: 4, child: Text('4 a line')),
                DropdownMenuItem(value: 8, child: Text('8 a line')),
              ],
            ),
          ),

          _heading(context, 'Measurements'),
          const ListTile(
            dense: true,
            subtitle: Text(
              'All in staff spaces — the distance between two staff lines — so '
              'they hold at any zoom.',
            ),
          ),
          for (final measure in _measures)
            _MeasureRow(
              measure: measure,
              style: _style,
              onChanged: (value) => _style = measure.write(_style, value),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => _style = EngravingStyle(colors: _colors),
        child: const Text('Defaults'),
      ),
      TextButton(
        onPressed: () => _style = _startedWith,
        child: const Text('Undo my changes'),
      ),
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Done'),
      ),
    ],
  );

  /// The dropdown value, matched against the choices it offers so that a
  /// theme set from elsewhere still selects something.
  MeasureNumbering get _numberingValue {
    const offered = [
      MeasureNumbering.none,
      MeasureNumbering.everySystem,
      MeasureNumbering.every(2),
      MeasureNumbering.every(5),
      MeasureNumbering.every(10),
    ];
    return offered.firstWhere(
      (value) => value == _style.measureNumbers,
      orElse: () => MeasureNumbering.everySystem,
    );
  }

  Widget _heading(BuildContext context, String text) => Padding(
    padding: const EdgeInsets.fromLTRB(16, 20, 16, 4),
    child: Text(
      text,
      style: Theme.of(context).textTheme.titleSmall?.copyWith(
        color: Theme.of(context).colorScheme.primary,
      ),
    ),
  );
}

class _MeasureRow extends StatelessWidget {
  const _MeasureRow({
    required this.measure,
    required this.style,
    required this.onChanged,
  });

  final _Measure measure;
  final EngravingStyle style;
  final ValueChanged<double> onChanged;

  @override
  Widget build(BuildContext context) {
    final value = measure.read(style).clamp(measure.min, measure.max);
    return ListTile(
      dense: true,
      title: Row(
        children: [
          Expanded(child: Text(measure.label)),
          Text(
            value.toStringAsFixed(2),
            style: Theme.of(context).textTheme.labelMedium,
          ),
        ],
      ),
      subtitle: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (measure.description != null)
            Text(
              measure.description!,
              style: Theme.of(context).textTheme.bodySmall,
            ),
          Slider(
            value: value,
            min: measure.min,
            max: measure.max,
            onChanged: onChanged,
          ),
        ],
      ),
    );
  }
}

class _FontRow extends StatelessWidget {
  const _FontRow({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  final String label;
  final String? value;
  final ValueChanged<String?> onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    title: Text(label),
    subtitle: TextFormField(
      initialValue: value ?? '',
      decoration: const InputDecoration(
        hintText: 'The platform default',
        isDense: true,
      ),
      onChanged: (text) => onChanged(text.trim().isEmpty ? null : text.trim()),
    ),
  );
}

class _ColorRow extends StatelessWidget {
  const _ColorRow({
    required this.label,
    required this.color,
    required this.onChanged,
    this.description,
  });

  final String label;
  final String? description;
  final Color color;
  final ValueChanged<Color> onChanged;

  @override
  Widget build(BuildContext context) => ListTile(
    dense: true,
    title: Text(label),
    subtitle: description == null ? null : Text(description!),
    trailing: InkWell(
      // Keyed so a test can reach the swatch rather than the row around it.
      key: ValueKey('swatch $label'),
      onTap: () async {
        final picked = await showDialog<Color>(
          context: context,
          builder: (context) => _ColorPicker(current: color, label: label),
        );
        if (picked != null) onChanged(picked);
      },
      child: Container(
        width: 44,
        height: 26,
        decoration: BoxDecoration(
          color: color,
          border: Border.all(color: Theme.of(context).dividerColor),
          borderRadius: BorderRadius.circular(4),
        ),
      ),
    ),
  );
}

/// A grid of colours to choose from.
///
/// Deliberately a fixed set rather than a wheel: the point of the dialog is to
/// see what each colour of a score does, and picking one out of twenty-eight
/// answers that as well as picking one out of sixteen million.
class _ColorPicker extends StatelessWidget {
  const _ColorPicker({
    required this.current,
    required this.label,
  });

  final Color current;
  final String label;

  static const _choices = <Color>[
    Color(0xFF000000),
    Color(0xFF1A1A1A),
    Color(0xFF444444),
    Color(0xFF7A7A7A),
    Color(0xFFAAAAAA),
    Color(0xFFE8E8E8),
    Color(0xFFF6EEDC),
    Color(0xFFFFFFFF),
    Color(0xFF15171A),
    Color(0xFF1E2430),
    Color(0xFF2B2118),
    Color(0xFF4A3A28),
    Color(0xFF8A7658),
    Color(0xFF9A8B72),
    Color(0xFFB08968),
    Color(0xFFD9C7A7),
    Color(0xFF8B1E1E),
    Color(0xFFCC2222),
    Color(0xFFE05A1E),
    Color(0xFFFFA366),
    Color(0xFF1E6FE0),
    Color(0xFF6FB4FF),
    Color(0xFF1B5E4A),
    Color(0xFF2E9E5B),
    Color(0xFF5C3D8A),
    Color(0xFF8A4FBF),
    Color(0xFF7A6A00),
    Color(0xFFC9B037),
  ];

  @override
  Widget build(BuildContext context) => AlertDialog(
    title: Text(label),
    content: SizedBox(
      width: 320,
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: [
          for (final choice in _choices)
            InkWell(
              // Keyed by the colour so a test can ask for one by name.
              key: ValueKey(choice),
              onTap: () => Navigator.of(context).pop(choice),
              child: Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: choice,
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: choice == current
                        ? Theme.of(context).colorScheme.primary
                        : Theme.of(context).dividerColor,
                    width: choice == current ? 3 : 1,
                  ),
                ),
              ),
            ),
        ],
      ),
    ),
    actions: [
      TextButton(
        onPressed: () => Navigator.of(context).pop(),
        child: const Text('Cancel'),
      ),
    ],
  );
}
