import 'package:songbird_score/src/model/notations.dart';

/// The printed shape of a barline.
enum BarStyle {
  regular,
  dotted,
  dashed,
  heavy,
  lightLight,
  lightHeavy,
  heavyLight,
  heavyHeavy,
  tick,
  short,
  none,
}

/// Which side of the measure a barline sits on.
enum BarlineLocation { left, right, middle }

/// Which way a repeat sign faces.
enum RepeatDirection { forward, backward }

/// A repeat sign.
class Repeat {
  const Repeat({
    required this.direction,
    this.times,
    this.winged,
  });

  /// [RepeatDirection.forward] opens a repeated section, `backward` closes it.
  final RepeatDirection direction;

  /// How many times the section is played, when more than twice.
  final int? times;

  final String? winged;
}

/// A first- or second-time bracket.
class Ending {
  const Ending({
    required this.numbers,
    required this.type,
    this.text,
  });

  /// The pass numbers this bracket applies to.
  final List<int> numbers;

  final EndingType type;

  /// Text overriding the numbers, as in `1., 2.`
  final String? text;
}

enum EndingType { start, stop, discontinue }

/// A barline, together with anything printed on it.
class Barline {
  Barline({
    this.location = BarlineLocation.right,
    this.style = BarStyle.regular,
    this.repeat,
    this.ending,
    this.fermatas = const [],
    this.segno = false,
    this.coda = false,
  });

  BarlineLocation location;
  BarStyle style;
  Repeat? repeat;
  Ending? ending;
  List<Fermata> fermatas;
  bool segno;
  bool coda;

  bool get isRepeat => repeat != null;

  Barline copy() => Barline(
    location: location,
    style: style,
    repeat: repeat,
    ending: ending,
    fermatas: [...fermatas],
    segno: segno,
    coda: coda,
  );

  @override
  String toString() => 'Barline(${location.name}, ${style.name})';
}
