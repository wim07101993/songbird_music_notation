import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart';
import 'package:songbird_music_notation/src/interaction/edit_actions.dart';
import 'package:songbird_music_notation/src/layout/layout_elements.dart';
import 'package:songbird_music_notation/src/layout/score_layout.dart';
import 'package:songbird_music_notation/src/widgets/score_canvas.dart';
import 'package:songbird_music_notation/src/widgets/score_controller.dart';
import 'package:songbird_score/songbird_score.dart';

/// What clicking the score does.
enum EditTool {
  /// Click to select, drag a note to change its pitch.
  select,

  /// Click an empty spot to write a note there.
  writeNotes,

  /// Click a note to erase it, leaving a rest.
  erase,
}

/// Shows a score and lets it be edited.
///
/// Everything it changes goes through the controller's command stack, so any
/// edit made here can be undone, and an application's own buttons can make the
/// same edits through [ScoreEditActions].
///
/// Keyboard shortcuts, when focused:
///
/// | Key | Effect |
/// | --- | --- |
/// | Arrow up/down | move the selected notes by a step |
/// | Shift + arrow up/down | move them by an octave |
/// | Arrow left/right | select the next or previous note |
/// | `+` / `-` | raise or lower by a semitone |
/// | 1 … 7 | set the duration, whole through 64th |
/// | `.` | toggle a dot |
/// | Delete / Backspace | replace with a rest |
/// | `L` | type lyrics under the selected note |
/// | `K` | type a chord symbol above it |
/// | Ctrl/Cmd + Z, Ctrl/Cmd + Shift + Z | undo, redo |
/// | Ctrl/Cmd + `+` / `-` / `0` | zoom in, out, reset |
///
/// Double-clicking a word or a chord symbol already in the score opens it for
/// editing, which is also the way to reach a verse other than [lyricVerse].
///
/// While typing lyrics or a chord symbol, space or Enter stores what has been
/// typed and moves to the next note; in lyrics a hyphen does the same and
/// marks the syllable as part of a word, so `hap-py` lands as two syllables
/// joined by a hyphen. Escape stops. Anything typed is stored when the field
/// loses the caret, so clicking away or leaving the editor keeps the words.
class MusicScoreEditor extends StatefulWidget {
  const MusicScoreEditor({
    super.key,
    required this.controller,
    this.padding = const EdgeInsets.all(16),
    this.backgroundColor,
    this.tool = EditTool.select,
    this.entryDuration = const RhythmicDuration(NoteType.quarter),
    this.autofocus = true,
    this.onSelectionChanged,
    this.scrollController,
    this.lyricVerse = 1,
  });

  final ScoreController controller;
  final EdgeInsets padding;
  final Color? backgroundColor;

  /// What a click does.
  final EditTool tool;

  /// The duration written by [EditTool.writeNotes].
  final RhythmicDuration entryDuration;

  final bool autofocus;

  final void Function(ScoreSelection selection)? onSelectionChanged;

  final ScrollController? scrollController;

  /// Which verse lyric typing writes into, counting from 1.
  final int lyricVerse;

  @override
  State<MusicScoreEditor> createState() => _MusicScoreEditorState();
}

class _MusicScoreEditorState extends State<MusicScoreEditor> {
  final FocusNode _focus = FocusNode(debugLabel: 'MusicScoreEditor');

  ScoreLayout? _layout;
  Note? _draggingNote;
  int? _dragStartPosition;
  Pitch? _dragStartPitch;
  _TextEntry? _entry;

  /// Where the second tap of a double tap landed, in staff spaces.
  Offset? _doubleTapPoint;

  /// Whether the syllable being typed continues a word the previous one
  /// started, which is what turns `hap-` then `py` into one hyphenated word
  /// rather than two separate ones.
  bool _continuingWord = false;

  ScoreEditActions get _actions => ScoreEditActions(widget.controller);

  /// A scroll controller of our own when the caller did not supply one, so the
  /// canvas can always be told what is on screen.
  ScrollController? _ownScroll;
  ScrollController get _scroll =>
      widget.scrollController ?? (_ownScroll ??= ScrollController());

  @override
  void dispose() {
    // Whatever was being typed is stored rather than dropped: leaving the
    // editor is not a way of cancelling, and finding the words gone would be
    // the worst reading of it.
    _closeEntry();
    _focus.dispose();
    _ownScroll?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final background =
        widget.backgroundColor ?? widget.controller.style.colors.background;

    return Focus(
      focusNode: _focus,
      autofocus: widget.autofocus,
      onKeyEvent: _handleKey,
      child: GestureDetector(
        onTap: _focus.requestFocus,
        child: ColoredBox(
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
                _layout = layout;

                final staffSpace = widget.controller.staffSpace;
                final size = Size(
                  layout.size.width * staffSpace,
                  layout.size.height * staffSpace,
                );

                return SingleChildScrollView(
                  controller: _scroll,
                  padding: widget.padding,
                  child: _buildInteractiveCanvas(layout, size, staffSpace),
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInteractiveCanvas(
    ScoreLayout layout,
    Size size,
    double staffSpace,
  ) {
    final canvas = ScoreCanvas(
      layout: layout,
      controller: widget.controller,
      size: size,
      onHover: _handleHover,
      hidden: _hiddenWhileTyping(),
      scrollController: _scroll,
      padding: widget.padding,
    );

    final interactive = GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapUp: (details) => _handleTap(details.localPosition / staffSpace),
      onDoubleTapDown: (details) =>
          _doubleTapPoint = details.localPosition / staffSpace,
      onDoubleTap: _handleDoubleTap,
      onVerticalDragStart: (details) =>
          _handleDragStart(details.localPosition / staffSpace),
      onVerticalDragUpdate: (details) =>
          _handleDragUpdate(details.localPosition / staffSpace),
      onVerticalDragEnd: (_) => _endDrag(),
      onVerticalDragCancel: _endDrag,
      child: canvas,
    );

    final entry = _buildTextEntry(layout, staffSpace);
    if (entry == null) return interactive;
    return SizedBox.fromSize(
      size: size,
      child: Stack(children: [interactive, entry]),
    );
  }

  // ------------------------------------------------------------ text entry

  /// The text being typed, drawn where the score prints it.
  ///
  /// Nothing is drawn around it — no box, no border, no placeholder — because
  /// this stands in for engraved text, and a form control in the middle of a
  /// stave reads as something else entirely. The caret is the only sign that
  /// the words are being typed rather than printed.
  Widget? _buildTextEntry(ScoreLayout layout, double staffSpace) {
    final entry = _entry;
    if (entry == null) return null;

    final anchor = _entryAnchor(layout, entry);
    if (anchor == null) {
      // The note being written over is no longer drawn — undone, or in a part
      // that has just been hidden. There is nowhere to put the field, and
      // leaving it open would swallow the keyboard, so it closes itself once
      // this frame is out of the way.
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted && identical(_entry, entry)) _endEntry();
      });
      return null;
    }

    final style = widget.controller.style;
    final fontSize =
        (entry.kind == _EntryKind.lyric
            ? style.lyricFontSize
            : style.chordFontSize) *
        staffSpace;

    // Lyrics are engraved centred under the note and chord symbols from the
    // left, so the field follows each of them; otherwise the words would jump
    // sideways the moment they were stored.
    final centred = entry.kind == _EntryKind.lyric;

    // Enough room for a long word, so the field does not resize under the
    // caret as it is typed.
    final width = 14 * staffSpace;

    return Positioned(
      left: centred
          ? anchor.center.dx * staffSpace - width / 2
          : anchor.left * staffSpace,
      top: anchor.top * staffSpace - fontSize * 0.2,
      width: width,
      child: Material(
        type: MaterialType.transparency,
        child: TextField(
          key: ValueKey(entry),
          controller: entry.text,
          focusNode: entry.focus,
          autofocus: true,
          decoration: null,
          textAlign: centred ? TextAlign.center : TextAlign.start,
          cursorColor: style.colors.ink,
          cursorWidth: 1.2,
          style: TextStyle(fontSize: fontSize, color: style.colors.ink),
          onChanged: _handleEntryChanged,
          onSubmitted: (_) => _advanceEntry(hyphen: false),
        ),
      ),
    );
  }

  /// The engraved text the open field stands in for.
  ///
  /// It is left undrawn while the field is open, because a field with no box
  /// and no background of its own would otherwise print the new words directly
  /// over the old ones.
  Set<Object> _hiddenWhileTyping() {
    final entry = _entry;
    if (entry == null) return const {};
    final event = entry.event;
    final engraved = switch (entry.kind) {
      _EntryKind.lyric =>
        event is Chord ? _actions.lyricOf(event, verse: entry.verse) : null,
      _EntryKind.chord => _chordSymbolOf(event),
    };
    return engraved == null ? const {} : {engraved};
  }

  /// Where on the page the text being edited is printed.
  ///
  /// The element it replaces is the first choice, because typing over the
  /// words already there is what makes the field feel attached to the music. A
  /// note with nothing written at it yet has no such element, so the note
  /// stands in and the field is offset to where the text would go.
  Rect? _entryAnchor(ScoreLayout layout, _TextEntry entry) {
    final existing = switch (entry.kind) {
      _EntryKind.lyric => layout.boundsWhere(
        (element) =>
            element.role == ElementRole.lyric &&
            identical(element.owner, entry.event) &&
            element.source is Lyric &&
            (element.source! as Lyric).number == entry.verse,
      ),
      _EntryKind.chord => switch (_chordSymbolOf(entry.event)) {
        final Harmony harmony => layout.boundsOfEvent(
          harmony,
          role: ElementRole.chordSymbol,
        ),
        _ => null,
      },
    };
    if (existing != null) return existing;

    final fallback = layout.boundsOfEvent(entry.event);
    if (fallback == null) return null;
    return entry.kind == _EntryKind.lyric
        ? Rect.fromLTWH(fallback.left, fallback.bottom + 1, fallback.width, 2)
        : Rect.fromLTWH(fallback.left, fallback.top - 3.5, fallback.width, 2);
  }

  /// Starts typing at the selected note, or stops if that is already what is
  /// happening.
  void _beginEntry(_EntryKind kind, {MusicalEvent? event, int? verse}) {
    final target =
        event ??
        (kind == _EntryKind.lyric
            ? _actions.selectedChord
            : widget.controller.selection.events.firstOrNull);
    if (target == null) return;

    final onVerse = verse ?? widget.lyricVerse;
    final current = _entry;
    if (current != null &&
        current.kind == kind &&
        current.verse == onVerse &&
        identical(current.event, target)) {
      _endEntry();
      return;
    }

    _closeEntry();
    final started = _TextEntry(kind: kind, event: target, verse: onVerse);
    started.watchFocus(() => _entryFocusChanged(started));
    setState(() {
      _entry = started;
      _continuingWord = false;
    });
    _loadEntryText();
    // Autofocus only fires for a field that is newly inserted, and moving from
    // one piece of text to another reuses the one already on screen, so the
    // caret is asked for explicitly.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted && identical(_entry, started)) started.focus.requestFocus();
    });
  }

  /// Opens the text under the pointer for editing, if there is any.
  ///
  /// Double-clicking a word or a chord symbol is how people expect to correct
  /// one, and it is the only way to reach a verse other than the one the
  /// keyboard writes into.
  void _editTextAt(Offset point) {
    final layout = _layout;
    if (layout == null) return;

    for (final hit in layout.hitTestAll(point)) {
      final element = hit.element;
      switch (element.role) {
        case ElementRole.lyric:
          final lyric = element.source;
          final chord = element.owner;
          if (lyric is! Lyric || chord is! Chord) continue;
          widget.controller.selectEvent(chord);
          _beginEntry(_EntryKind.lyric, event: chord, verse: lyric.number);
          return;
        case ElementRole.chordSymbol:
          final harmony = element.owner ?? element.source;
          if (harmony is! Harmony) continue;
          final beat = _eventUnder(harmony);
          if (beat == null) continue;
          widget.controller.selectEvent(beat);
          _beginEntry(_EntryKind.chord, event: beat);
          return;
        default:
          continue;
      }
    }
  }

  /// The note or rest a chord symbol stands over, which is the beat an edit to
  /// it works from.
  MusicalEvent? _eventUnder(Harmony harmony) {
    final measure = _actions.measureOf(harmony);
    if (measure == null) return null;
    for (final event in measure.eventsInOrder) {
      if ((event is Chord || event is Rest) &&
          event.position == harmony.position &&
          event.staff == harmony.staff) {
        return event;
      }
    }
    return null;
  }

  /// Fills the field with whatever is already written at this note.
  void _loadEntryText() {
    final entry = _entry;
    if (entry == null) return;
    final event = entry.event;

    final text = switch (entry.kind) {
      _EntryKind.lyric =>
        event is Chord
            ? _actions.lyricOf(event, verse: entry.verse)?.text ?? ''
            : '',
      _EntryKind.chord => _chordSymbolOf(event)?.symbol ?? '',
    };
    entry.text.value = TextEditingValue(
      text: text,
      selection: TextSelection(baseOffset: 0, extentOffset: text.length),
    );
  }

  Harmony? _chordSymbolOf(MusicalEvent event) {
    final measure = _actions.measureOf(event);
    if (measure == null) return null;
    return _actions.chordSymbolAt(measure, event.position, staff: event.staff);
  }

  /// Space ends a word and a hyphen ends a syllable, so neither belongs in the
  /// text itself; seeing one arrive is the signal to store and move on.
  void _handleEntryChanged(String value) {
    final entry = _entry;
    if (entry == null) return;
    if (value.endsWith(' ')) {
      entry.text.text = value.substring(0, value.length - 1);
      _advanceEntry(hyphen: false);
      return;
    }
    if (entry.kind == _EntryKind.lyric && value.endsWith('-')) {
      entry.text.text = value.substring(0, value.length - 1);
      _advanceEntry(hyphen: true);
    }
  }

  /// Stores what has been typed and moves to the next note.
  void _advanceEntry({required bool hyphen}) {
    final entry = _entry;
    if (entry == null) return;
    _commitEntry(entry, hyphen: hyphen);

    final next = _neighbour(
      entry.event,
      1,
      chordsOnly: entry.kind == _EntryKind.lyric,
    );
    if (next == null) {
      _endEntry();
      return;
    }
    widget.controller.selectEvent(next);
    widget.onSelectionChanged?.call(widget.controller.selection);
    setState(() => entry.event = next);
    _loadEntryText();
    entry.focus.requestFocus();
  }

  /// Writes the field's contents into the score.
  ///
  /// Takes the entry rather than reading the field, so that it can also be
  /// called while the entry is being torn down — which is what saves the words
  /// when the view is disposed or the focus moves to a toolbar, instead of
  /// throwing away what was typed.
  void _commitEntry(_TextEntry entry, {required bool hyphen}) {
    final text = entry.text.text.trim();
    final event = entry.event;

    switch (entry.kind) {
      case _EntryKind.lyric:
        if (event is! Chord) return;
        final existing = _actions.lyricOf(event, verse: entry.verse);
        if (text == (existing?.text ?? '')) return;
        _actions.setLyric(
          text,
          verse: entry.verse,
          syllabic: _syllabicFor(hyphen: hyphen),
          chord: event,
        );
        _continuingWord = hyphen;
      case _EntryKind.chord:
        final existing = _chordSymbolOf(event);
        if (text == (existing?.symbol ?? '')) return;
        final measure = _actions.measureOf(event);
        if (measure == null) return;
        _actions.setChordSymbol(
          text,
          measure: measure,
          position: event.position,
          staff: event.staff,
          voice: event.voice,
        );
    }
  }

  /// Where the syllable being stored sits within its word.
  Syllabic _syllabicFor({required bool hyphen}) {
    if (hyphen) return _continuingWord ? Syllabic.middle : Syllabic.begin;
    return _continuingWord ? Syllabic.end : Syllabic.single;
  }

  /// Anything typed is stored when the field loses the caret, so that clicking
  /// on the music or on a toolbar keeps the words rather than dropping them.
  void _entryFocusChanged(_TextEntry entry) {
    if (entry.focus.hasFocus) {
      entry.hadFocus = true;
      return;
    }
    // A node reports a change as it is attached, before it has ever held the
    // caret; closing on that would shut the field the moment it opened.
    if (!entry.hadFocus || !identical(_entry, entry)) return;

    // Tearing a focus node down from inside its own notification leaves the
    // focus manager iterating a list that is being changed underneath it, so
    // the field closes once the frame that moved the caret away is done.
    WidgetsBinding.instance
      ..addPostFrameCallback((_) {
        if (mounted && identical(_entry, entry)) {
          _endEntry(restoreFocus: false);
        }
      })
      ..scheduleFrame();
  }

  void _endEntry({bool restoreFocus = true}) {
    if (_entry == null) return;
    _closeEntry();
    setState(() => _continuingWord = false);
    if (restoreFocus) _focus.requestFocus();
  }

  /// Stores and tears down the open entry, without touching focus or asking
  /// for a rebuild, so that it is safe from [dispose] as well.
  void _closeEntry() {
    final entry = _entry;
    if (entry == null) return;
    _entry = null;
    _commitEntry(entry, hyphen: false);
    entry.dispose();
  }

  // -------------------------------------------------------------- pointing

  void _handleDoubleTap() {
    final point = _doubleTapPoint;
    if (point == null) return;
    _focus.requestFocus();
    _editTextAt(point);
  }

  void _handleHover(LayoutHit? hit) {
    widget.controller.hovered = hit?.note ?? hit?.event;
  }

  void _handleTap(Offset point) {
    _focus.requestFocus();
    final layout = _layout;
    if (layout == null) return;
    final hit = layout.hitTest(point);

    switch (widget.tool) {
      case EditTool.select:
        _selectAt(hit);
      case EditTool.erase:
        if (hit == null) return;
        final event = hit.event;
        if (event == null) return;
        widget.controller.selectEvent(event);
        _actions.deleteSelection();
      case EditTool.writeNotes:
        _writeNoteAt(point, hit);
    }
    widget.onSelectionChanged?.call(widget.controller.selection);
  }

  void _selectAt(LayoutHit? hit) {
    final controller = widget.controller;
    if (hit == null) {
      controller.clearSelection();
      return;
    }
    final add = HardwareKeyboard.instance.isShiftPressed;
    final note = hit.note;
    if (note != null) {
      controller.selectNote(note, owner: hit.event, add: add);
      return;
    }
    final event = hit.event;
    if (event != null) {
      controller.selectEvent(event, add: add);
    } else {
      controller.clearSelection();
    }
  }

  void _writeNoteAt(Offset point, LayoutHit? hit) {
    // Clicking an existing note adds to its chord; clicking empty staff writes
    // a new note there.
    final layout = _layout;
    if (layout == null) return;
    final target = resolvePointer(layout: layout, point: point);
    if (target == null) return;
    _actions.insertNote(
      measure: target.measure,
      position: hit?.event?.position ?? target.position,
      pitch: target.pitch,
      rhythm: widget.entryDuration,
      voice: hit?.event?.voice ?? 1,
      staff: target.staffNumber,
    );
  }

  // ------------------------------------------------------------- dragging

  void _handleDragStart(Offset point) {
    if (widget.tool != EditTool.select) return;
    final layout = _layout;
    if (layout == null) return;
    final hit = layout.hitTest(point);
    final note = hit?.note;
    if (note == null || note.pitch == null) return;

    final staff = hit!.staff;
    if (staff == null) return;
    _draggingNote = note;
    _dragStartPitch = note.pitch;
    _dragStartPosition = staff.staffPositionAtPage(point.dy);
    widget.controller.selectNote(note, owner: hit.event);
  }

  void _handleDragUpdate(Offset point) {
    final note = _draggingNote;
    final startPosition = _dragStartPosition;
    final startPitch = _dragStartPitch;
    if (note == null || startPosition == null || startPitch == null) return;
    final layout = _layout;
    if (layout == null) return;

    final system = layout.systemAtY(point.dy);
    if (system == null) return;
    StaffLayout? staff;
    var best = double.infinity;
    for (final candidate in system.staves) {
      final distance = (point.dy - candidate.pageMiddle).abs();
      if (distance < best) {
        best = distance;
        staff = candidate;
      }
    }
    if (staff == null) return;

    final steps = staff.staffPositionAtPage(point.dy) - startPosition;
    if (steps == 0) return;
    final diatonic = startPitch.diatonicValue + steps;
    final target = Pitch(
      Step.fromDiatonicIndex(diatonic % 7),
      (diatonic / 7).floor(),
      alter: startPitch.alter,
    );
    if (target == note.pitch) return;

    // Every frame of the drag merges into one undo step.
    widget.controller.execute(
      SetPitchCommand(note: note, pitch: target),
      merge: true,
    );
  }

  void _endDrag() {
    _draggingNote = null;
    _dragStartPosition = null;
    _dragStartPitch = null;
  }

  // ------------------------------------------------------------- keyboard

  KeyEventResult _handleKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent && event is! KeyRepeatEvent) {
      return KeyEventResult.ignored;
    }
    final keys = HardwareKeyboard.instance;
    final command = keys.isControlPressed || keys.isMetaPressed;

    // While a field is open the keys belong to it; only the one that closes it
    // is ours, and everything else the field has not already handled — arrow
    // keys at the ends of the text, say — is left alone rather than being read
    // as a score shortcut.
    if (_entry != null) {
      if (event.logicalKey == LogicalKeyboardKey.escape) {
        _endEntry();
        return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }
    final shift = keys.isShiftPressed;
    final repeat = event is KeyRepeatEvent;
    final controller = widget.controller;

    if (command) {
      switch (event.logicalKey) {
        case LogicalKeyboardKey.keyZ:
          shift ? controller.redo() : controller.undo();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.keyY:
          controller.redo();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.equal:
        case LogicalKeyboardKey.add:
          controller.zoomIn();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.minus:
          controller.zoomOut();
          return KeyEventResult.handled;
        case LogicalKeyboardKey.digit0:
          controller.resetZoom();
          return KeyEventResult.handled;
      }
      return KeyEventResult.ignored;
    }

    switch (event.logicalKey) {
      case LogicalKeyboardKey.arrowUp:
        _actions.nudgeSelection(shift ? 7 : 1, merge: repeat);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowDown:
        _actions.nudgeSelection(shift ? -7 : -1, merge: repeat);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowRight:
        _moveSelection(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.arrowLeft:
        _moveSelection(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.equal:
      case LogicalKeyboardKey.add:
        _actions.alterSelection(1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.minus:
        _actions.alterSelection(-1);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.period:
        _actions.toggleDot();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.delete:
      case LogicalKeyboardKey.backspace:
        _actions.deleteSelection();
        return KeyEventResult.handled;
      case LogicalKeyboardKey.keyL:
        _beginEntry(_EntryKind.lyric);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.keyK:
        _beginEntry(_EntryKind.chord);
        return KeyEventResult.handled;
      case LogicalKeyboardKey.escape:
        controller.clearSelection();
        return KeyEventResult.handled;
    }

    final duration = _durationForDigit(event.logicalKey);
    if (duration != null) {
      _actions.setDuration(duration);
      return KeyEventResult.handled;
    }
    return KeyEventResult.ignored;
  }

  /// The number row picks a duration, longest at 1, as notation editors do.
  NoteType? _durationForDigit(LogicalKeyboardKey key) => switch (key) {
    LogicalKeyboardKey.digit1 => NoteType.whole,
    LogicalKeyboardKey.digit2 => NoteType.half,
    LogicalKeyboardKey.digit3 => NoteType.quarter,
    LogicalKeyboardKey.digit4 => NoteType.eighth,
    LogicalKeyboardKey.digit5 => NoteType.sixteenth,
    LogicalKeyboardKey.digit6 => NoteType.thirtySecond,
    LogicalKeyboardKey.digit7 => NoteType.sixtyFourth,
    _ => null,
  };

  /// Moves the selection to the neighbouring note in the same voice.
  void _moveSelection(int direction) {
    final controller = widget.controller;
    final current = controller.selection.events.firstOrNull;
    if (current == null) {
      final first = _firstEvent();
      if (first != null) controller.selectEvent(first);
      return;
    }
    final next = _neighbour(current, direction);
    if (next == null) return;
    controller.selectEvent(next);
    widget.onSelectionChanged?.call(controller.selection);
  }

  /// The note [direction] away from [from] in the same voice, across measures.
  ///
  /// Lyrics go under notes and not under rests, so typing them skips the
  /// rests; moving the selection with the arrow keys does not.
  MusicalEvent? _neighbour(
    MusicalEvent from,
    int direction, {
    bool chordsOnly = false,
  }) {
    final measure = _actions.measureOf(from);
    if (measure == null) return null;
    final part = _actions.partOf(measure);
    if (part == null) return null;

    final sequence = <MusicalEvent>[];
    for (final candidate in part.measures) {
      sequence.addAll(
        candidate.eventsInOrder.where(
          (e) =>
              e.voice == from.voice &&
              (chordsOnly ? e is Chord : e is Chord || e is Rest),
        ),
      );
    }
    final index = sequence.indexOf(from);
    if (index < 0) return null;
    final next = index + direction;
    if (next < 0 || next >= sequence.length) return null;
    return sequence[next];
  }

  MusicalEvent? _firstEvent() {
    for (final part in widget.controller.score.parts) {
      for (final measure in part.measures) {
        for (final event in measure.eventsInOrder) {
          if (event is Chord) return event;
        }
      }
    }
    return null;
  }
}

/// What a text field opened over the score is editing.
enum _EntryKind { lyric, chord }

/// One run of typing: the field, where it is anchored, and what it writes.
///
/// The controller and focus node live here rather than in the widget state so
/// that moving from note to note keeps the same field — the caret does not
/// jump away and the keyboard does not close — while the note it writes to
/// changes under it.
class _TextEntry {
  _TextEntry({
    required this.kind,
    required this.event,
    required this.verse,
  });

  final _EntryKind kind;

  /// The note being written at, which changes as typing advances.
  MusicalEvent event;

  /// Which verse of lyrics is being written; unused for a chord symbol.
  final int verse;

  final TextEditingController text = TextEditingController();
  final FocusNode focus = FocusNode(debugLabel: 'ScoreTextEntry');

  /// Whether the field has ever held the caret.
  bool hadFocus = false;

  VoidCallback? _watcher;

  /// Watches the caret coming and going, keeping hold of the listener so that
  /// it can be taken off again before the node is disposed — a node that
  /// notifies a listener which then disposes it corrupts the focus manager.
  void watchFocus(VoidCallback listener) {
    _watcher = listener;
    focus.addListener(listener);
  }

  void dispose() {
    final watcher = _watcher;
    if (watcher != null) focus.removeListener(watcher);
    text.dispose();
    focus.dispose();
  }
}
