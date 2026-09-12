import 'package:songbird_score/src/edit/command.dart';
import 'package:songbird_score/src/model/harmony.dart';
import 'package:songbird_score/src/model/measure.dart';
import 'package:songbird_score/src/model/score.dart';
import 'package:songbird_score/src/theory/fraction.dart';

/// Writes the chord symbol above one beat, from the text someone typed.
///
/// One command covers all three things a text field can mean — there was no
/// symbol and now there is, there was one and the text changed, there was one
/// and the field was emptied — because from the typist's side they are the
/// same act, and splitting them would put two undo steps in the history for
/// what looked like one correction.
class SetChordSymbolCommand extends EditCommand {
  SetChordSymbolCommand({
    required this.measure,
    required this.position,
    required this.symbol,
    this.voice = 1,
    this.staff = 1,
  });

  final Measure measure;

  /// Where in the measure the symbol sits.
  final Fraction position;

  /// The symbol as typed, such as `F#m7` or `Cmaj7/E`. Empty removes it.
  final String symbol;

  final int voice;
  final int staff;

  /// The symbol as it stood before [apply], for putting back.
  Harmony? _before;

  /// The object [apply] added, so [revert] takes out the same one.
  Harmony? _added;

  /// The object [apply] changed in place.
  Harmony? _changed;

  /// The object [apply] took out.
  Harmony? _removed;

  @override
  String get label =>
      symbol.trim().isEmpty ? 'Remove chord symbol' : 'Edit chord symbol';

  /// Whether the text names a chord, so a caller can refuse a typo before
  /// putting the command on the undo stack.
  bool get isValid =>
      symbol.trim().isEmpty ||
      Harmony.parseSymbol(symbol, position: position) != null;

  @override
  void apply(Score score) {
    _added = null;
    _changed = null;
    _removed = null;

    final existing = _existing;
    _before = existing?.copy();

    final parsed = Harmony.parseSymbol(
      symbol,
      position: position,
      voice: voice,
      staff: staff,
    );

    if (parsed == null) {
      if (existing == null) return;
      measure.remove(existing);
      _removed = existing;
      return;
    }

    if (existing == null) {
      measure.add(parsed);
      _added = parsed;
      return;
    }

    existing
      ..root = parsed.root
      ..kind = parsed.kind
      ..text = parsed.text
      ..bass = parsed.bass;
    _changed = existing;
  }

  @override
  void revert(Score score) {
    final removed = _removed;
    if (removed != null) {
      measure.add(removed);
      _removed = null;
      return;
    }

    final added = _added;
    if (added != null) {
      measure.remove(added);
      _added = null;
      return;
    }

    final changed = _changed;
    final before = _before;
    if (changed != null && before != null) {
      changed
        ..root = before.root
        ..kind = before.kind
        ..text = before.text
        ..bass = before.bass;
      _changed = null;
    }
  }

  /// The symbol already written at this beat on this staff, if there is one.
  Harmony? get _existing {
    for (final event in measure.events) {
      if (event is Harmony &&
          event.position == position &&
          event.staff == staff) {
        return event;
      }
    }
    return null;
  }
}
