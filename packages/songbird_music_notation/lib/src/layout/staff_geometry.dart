import 'package:songbird_score/songbird_score.dart';

/// Where one staff sits on the page and how to place pitches on it.
///
/// Staff positions in the model count half-spaces upward from the bottom line;
/// on the page y grows downward. This turns one into the other, and is the only
/// place that conversion happens.
class StaffGeometry {
  const StaffGeometry({
    required this.top,
    required this.lineCount,
    required this.part,
    required this.staffNumber,
    this.scale = 1,
  });

  /// Page y of the top staff line, in staff spaces.
  final double top;

  final int lineCount;

  final Part part;

  /// Which staff of the part this is, counting from 1.
  final int staffNumber;

  /// Size relative to a normal staff, for ossia and cue staves.
  final double scale;

  /// Height from the top line to the bottom line.
  double get height => (lineCount - 1).toDouble();

  /// Page y of the bottom staff line.
  double get bottom => top + height;

  /// Page y of the middle line, which decides default stem directions.
  double get middle => top + height / 2;

  /// Page y of staff line [index], counting the bottom line as 1.
  double lineY(int index) => bottom - (index - 1);

  /// Page y for a staff position, where 0 is the bottom line and each unit is
  /// half a space.
  double yForStaffPosition(int position) => bottom - position / 2;

  /// Page y for [pitch] as written in [clef].
  double yForPitch(Pitch pitch, Clef clef) =>
      yForStaffPosition(clef.staffPositionOf(pitch));

  /// The staff position closest to page position [y], which is what turns a
  /// click into a pitch.
  int staffPositionAt(double y) => ((bottom - y) * 2).round();

  /// The ledger line positions a note at [staffPosition] needs, if any.
  ///
  /// Ledger lines sit on the line positions past the staff, so only even
  /// positions get one; a note in the space between two ledger lines still
  /// needs the line below or above it.
  List<int> ledgerLinesFor(int staffPosition) {
    final topPosition = (lineCount - 1) * 2;
    if (staffPosition > topPosition) {
      return [for (var p = topPosition + 2; p <= staffPosition; p += 2) p];
    }
    if (staffPosition < 0) {
      return [for (var p = -2; p >= staffPosition; p -= 2) p];
    }
    return const [];
  }

  /// Whether a note at [staffPosition] sits on a line rather than in a space.
  static bool isOnLine(int staffPosition) => staffPosition.isEven;
}
