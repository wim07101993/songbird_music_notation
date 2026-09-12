/// Exact rational arithmetic.
///
/// Musical time does not survive floating point: a triplet eighth inside a
/// dotted-quarter beat is `1/12` of a whole note, and comparing accumulated
/// `double`s for equality goes wrong within a few measures. Every position and
/// duration in the model is therefore a [Fraction].
class Fraction implements Comparable<Fraction> {
  /// Creates the fraction [numerator]/[denominator], reduced to lowest terms.
  factory Fraction(
    int numerator, [
    int denominator = 1,
  ]) {
    if (denominator == 0) {
      throw ArgumentError.value(denominator, 'denominator', 'must not be zero');
    }
    var n = numerator;
    var d = denominator;
    if (d < 0) {
      n = -n;
      d = -d;
    }
    final divisor = _gcd(n.abs(), d);
    if (divisor > 1) {
      n ~/= divisor;
      d ~/= divisor;
    }
    return Fraction._(n, d);
  }

  const Fraction._(
    this.numerator,
    this.denominator,
  );

  /// Parses `"3"`, `"3/4"` or `"-3/4"`.
  factory Fraction.parse(
    String source,
  ) {
    final slash = source.indexOf('/');
    if (slash < 0) return Fraction(int.parse(source.trim()));
    return Fraction(
      int.parse(source.substring(0, slash).trim()),
      int.parse(source.substring(slash + 1).trim()),
    );
  }

  static const Fraction zero = Fraction._(0, 1);
  static const Fraction one = Fraction._(1, 1);
  static const Fraction half = Fraction._(1, 2);
  static const Fraction two = Fraction._(2, 1);

  /// Always in lowest terms; carries the sign of the fraction.
  final int numerator;

  /// Always strictly positive.
  final int denominator;

  bool get isZero => numerator == 0;
  bool get isNegative => numerator < 0;
  bool get isPositive => numerator > 0;

  /// Lossy; use only for layout geometry, never for musical bookkeeping.
  double toDouble() => numerator / denominator;

  Fraction operator +(Fraction other) => Fraction(
    numerator * other.denominator + other.numerator * denominator,
    denominator * other.denominator,
  );

  Fraction operator -(Fraction other) => Fraction(
    numerator * other.denominator - other.numerator * denominator,
    denominator * other.denominator,
  );

  Fraction operator *(Fraction other) =>
      Fraction(numerator * other.numerator, denominator * other.denominator);

  Fraction operator /(Fraction other) {
    if (other.isZero) {
      throw ArgumentError.value(other, 'other', 'division by zero');
    }
    return Fraction(
      numerator * other.denominator,
      denominator * other.numerator,
    );
  }

  Fraction operator -() => Fraction._(-numerator, denominator);

  bool operator <(Fraction other) => compareTo(other) < 0;
  bool operator <=(Fraction other) => compareTo(other) <= 0;
  bool operator >(Fraction other) => compareTo(other) > 0;
  bool operator >=(Fraction other) => compareTo(other) >= 0;

  Fraction get abs => isNegative ? -this : this;

  /// Multiplies by the integer [factor].
  Fraction scaled(int factor) => Fraction(numerator * factor, denominator);

  /// The largest integer not greater than this fraction.
  int get floor => (numerator / denominator).floor();

  @override
  int compareTo(Fraction other) =>
      (numerator * other.denominator).compareTo(other.numerator * denominator);

  @override
  bool operator ==(Object other) =>
      other is Fraction &&
      numerator == other.numerator &&
      denominator == other.denominator;

  @override
  int get hashCode => Object.hash(numerator, denominator);

  @override
  String toString() =>
      denominator == 1 ? '$numerator' : '$numerator/$denominator';

  static int _gcd(int a, int b) {
    var left = a;
    var right = b;
    while (right != 0) {
      final remainder = left % right;
      left = right;
      right = remainder;
    }
    return left == 0 ? 1 : left;
  }
}
