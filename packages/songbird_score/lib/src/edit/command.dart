import 'package:songbird_score/src/model/score.dart';

/// A single undoable change to a [Score].
///
/// Commands capture whatever they need to undo themselves when [apply] runs,
/// rather than the editor snapshotting the whole score. A score can be tens of
/// megabytes of objects; copying it on every keystroke is not viable, and the
/// inverse of an edit is almost always a few fields.
abstract class EditCommand {
  /// A short description for an undo menu, e.g. "Change pitch".
  String get label;

  /// Performs the change and records what is needed to reverse it.
  void apply(Score score);

  /// Puts the score back the way it was before [apply].
  void revert(Score score);

  /// Whether [next] can be folded into this command instead of being pushed
  /// separately, so that dragging a note produces one undo step and not fifty.
  bool mergeWith(EditCommand next) => false;
}

/// Several commands applied and undone as one.
class CompositeCommand extends EditCommand {
  CompositeCommand(
    this.label,
    this.commands,
  );

  @override
  final String label;

  final List<EditCommand> commands;

  @override
  void apply(Score score) {
    for (final command in commands) {
      command.apply(score);
    }
  }

  @override
  void revert(Score score) {
    for (final command in commands.reversed) {
      command.revert(score);
    }
  }
}
