import 'package:flutter/foundation.dart' show visibleForTesting;
import 'package:flutter/services.dart' show rootBundle;
import 'package:songbird_smufl/songbird_smufl.dart';

/// Loads Bravura and its measurements from the SMuFL package's assets.
///
/// The font itself is pure Dart and knows nothing of asset bundles: reading
/// the metadata is Flutter's half of the job, and this is where it happens.
/// The result is cached, so calling this from a widget build is safe once the
/// first load has completed.
Future<SmuflFont> loadBravura() {
  final cached = _bravura;
  if (cached != null) return Future.value(cached);
  return _bravuraLoad ??= _load();
}

SmuflFont? _bravura;
Future<SmuflFont>? _bravuraLoad;

/// Forgets the cached font, so a test can watch it load again.
@visibleForTesting
void resetBravuraForTesting() {
  _bravura = null;
  _bravuraLoad = null;
}

Future<SmuflFont> _load() async {
  try {
    final source = await rootBundle.loadString(SmuflFont.bravuraMetadataAsset);
    final font = SmuflFont.bravuraFrom(source);
    _bravura = font;
    return font;
  } on Object {
    // Somewhere without an asset bundle — a plain unit test, a host that
    // strips assets. The glyphs are still right; only the measurements fall
    // back to the specification's defaults. Clearing the cached future lets a
    // later call try again.
    _bravuraLoad = null;
    return SmuflFont.bravuraFallback;
  }
}
