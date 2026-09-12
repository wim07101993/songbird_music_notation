import 'dart:async';

import 'package:songbird_score/src/edit/command.dart';
import 'package:songbird_score/src/model/score.dart';

/// Why the score changed, so that listeners can react proportionally: a
/// selection change needs no relayout, an edit does.
enum ScoreChangeKind { edit, undo, redo, reset }

/// Describes one change to the edited score.
class ScoreChange {
  const ScoreChange({
    required this.kind,
    this.command,
  });

  final ScoreChangeKind kind;

  /// The command responsible, absent for a wholesale reset.
  final EditCommand? command;

  @override
  String toString() => 'ScoreChange(${kind.name}, ${command?.label})';
}

/// Owns a [Score] and the history of changes made to it.
///
/// Every mutation goes through [execute] so that undo always has an inverse to
/// run. Editing the score directly is allowed but silently breaks the history,
/// so prefer a command even for one-off changes.
class ScoreEditor {
  ScoreEditor(
    this._score, {
    this.historyLimit = 200,
  });

  Score _score;

  /// How many commands to keep before dropping the oldest.
  final int historyLimit;

  final List<EditCommand> _undoStack = [];
  final List<EditCommand> _redoStack = [];
  final StreamController<ScoreChange> _changes =
      StreamController<ScoreChange>.broadcast();

  /// The score being edited.
  Score get score => _score;

  /// Emits once for every change, after it has been applied.
  Stream<ScoreChange> get changes => _changes.stream;

  bool get canUndo => _undoStack.isNotEmpty;
  bool get canRedo => _redoStack.isNotEmpty;

  /// The label of the change [undo] would reverse.
  String? get undoLabel => _undoStack.isEmpty ? null : _undoStack.last.label;

  /// The label of the change [redo] would reapply.
  String? get redoLabel => _redoStack.isEmpty ? null : _redoStack.last.label;

  /// The commands applied so far, oldest first.
  List<EditCommand> get history => List.unmodifiable(_undoStack);

  /// Applies [command] and pushes it onto the undo stack.
  ///
  /// Set [merge] when the command continues a gesture already in progress — a
  /// drag, a held arrow key — so that the whole gesture undoes at once.
  void execute(EditCommand command, {bool merge = false}) {
    command.apply(_score);
    _redoStack.clear();

    if (merge && _undoStack.isNotEmpty && _undoStack.last.mergeWith(command)) {
      // The earlier command already captured the state to restore, and the
      // newer one has just overwritten the score, so keeping the older command
      // on the stack gives the correct inverse for the whole gesture.
    } else {
      _undoStack.add(command);
      if (_undoStack.length > historyLimit) _undoStack.removeAt(0);
    }
    _changes.add(ScoreChange(kind: ScoreChangeKind.edit, command: command));
  }

  /// Applies several commands as a single undoable step.
  void executeAll(String label, List<EditCommand> commands) {
    if (commands.isEmpty) return;
    execute(CompositeCommand(label, commands));
  }

  /// Reverses the most recent command.
  bool undo() {
    if (_undoStack.isEmpty) return false;
    final command = _undoStack.removeLast();
    command.revert(_score);
    _redoStack.add(command);
    _changes.add(ScoreChange(kind: ScoreChangeKind.undo, command: command));
    return true;
  }

  /// Reapplies the most recently undone command.
  bool redo() {
    if (_redoStack.isEmpty) return false;
    final command = _redoStack.removeLast();
    command.apply(_score);
    _undoStack.add(command);
    _changes.add(ScoreChange(kind: ScoreChangeKind.redo, command: command));
    return true;
  }

  /// Replaces the score and throws the history away.
  void replaceScore(Score score) {
    _score = score;
    _undoStack.clear();
    _redoStack.clear();
    _changes.add(const ScoreChange(kind: ScoreChangeKind.reset));
  }

  /// Forgets the history without touching the score, as after a save.
  void clearHistory() {
    _undoStack.clear();
    _redoStack.clear();
  }

  Future<void> dispose() => _changes.close();
}
