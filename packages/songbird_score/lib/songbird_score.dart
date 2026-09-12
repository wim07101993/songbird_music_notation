/// A format-agnostic, editable model of a musical score.
///
/// The model describes music the way a reader sees it — parts, measures,
/// chords, rests, directions — and deliberately keeps no trace of the file it
/// came from, so that a MusicXML reader, a LilyPond reader and an editor can
/// all target the same structure.
///
/// Start at [Score]; edit through a [ScoreEditor] so that changes can be undone.
library;

export 'src/analysis/accidentals.dart';
export 'src/analysis/beaming.dart';
export 'src/edit/command.dart';
export 'src/edit/commands/harmony_commands.dart';
export 'src/edit/commands/lyric_commands.dart';
export 'src/edit/commands/pitch_commands.dart';
export 'src/edit/commands/structure_commands.dart';
export 'src/edit/score_editor.dart';
export 'src/edit/selection.dart';
export 'src/model/attributes.dart';
export 'src/model/barline.dart';
export 'src/model/direction.dart';
export 'src/model/event.dart';
export 'src/model/harmony.dart';
export 'src/model/measure.dart';
export 'src/model/notations.dart';
export 'src/model/part.dart';
export 'src/model/score.dart';
export 'src/model/spanner.dart';
export 'src/theory/clef.dart';
export 'src/theory/duration.dart';
export 'src/theory/fraction.dart';
export 'src/theory/interval.dart';
export 'src/theory/key.dart';
export 'src/theory/pitch.dart';
export 'src/theory/time_signature.dart';
