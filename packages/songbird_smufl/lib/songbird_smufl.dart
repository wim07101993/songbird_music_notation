/// SMuFL music-font support: glyph names, font metadata and the bundled
/// Bravura font.
///
/// SMuFL — the Standard Music Font Layout — puts every notation symbol at a
/// known code point and publishes the measurements a renderer needs to place
/// them: how wide each glyph is, how far it extends, and where a stem attaches.
/// This package exposes those as Dart, so that drawing a notehead is a matter
/// of asking for [SmuflGlyphs.noteheadBlack] rather than hard-coding ``.
///
/// All measurements are in staff spaces, with y increasing upwards as the
/// specification defines it.
library;

export 'src/font.dart';
export 'src/glyph.dart' hide smuflAlternateCodePoints, smuflCodePoints;
export 'src/metadata.dart';
