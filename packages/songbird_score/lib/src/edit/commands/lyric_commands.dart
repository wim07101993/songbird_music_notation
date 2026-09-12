import 'package:songbird_score/src/edit/command.dart';
import 'package:songbird_score/src/model/event.dart';
import 'package:songbird_score/src/model/notations.dart';
import 'package:songbird_score/src/model/score.dart';

/// Sets or clears the text of one verse under a chord.
class SetLyricCommand extends EditCommand {
  SetLyricCommand({
    required this.chord,
    required this.verse,
    required this.text,
    this.syllabic = Syllabic.single,
  });

  final Chord chord;

  /// Which verse, counting from 1.
  final int verse;

  /// The syllable, or an empty string to remove it.
  final String text;

  final Syllabic syllabic;

  List<Lyric>? _previous;

  @override
  String get label => 'Edit lyric';

  @override
  void apply(Score score) {
    _previous ??= [for (final lyric in chord.lyrics) lyric.copy()];
    final updated = [...chord.lyrics];
    updated.removeWhere((lyric) => lyric.number == verse);
    if (text.isNotEmpty) {
      updated.add(Lyric(text: text, number: verse, syllabic: syllabic));
    }
    updated.sort((a, b) => a.number.compareTo(b.number));
    chord.lyrics = updated;
  }

  @override
  void revert(Score score) {
    final previous = _previous;
    if (previous != null) chord.lyrics = previous;
  }
}
