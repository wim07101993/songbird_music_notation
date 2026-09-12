import 'dart:io';

import 'package:test/test.dart';

import '../tool/generate_glyph_names.dart';

/// What `dart run tool/generate_glyph_names.dart` writes is committed, so
/// nothing has to run at build time. This is the other half of that bargain:
/// the committed file has to be what the specification metadata actually
/// generates, or a hand edit to it — or a change to the generator without a
/// regeneration — goes unnoticed.
void main() {
  /// Resolves [path] whether the tests were started from the package
  /// directory or from the workspace root.
  String resolve(String path) {
    for (final prefix in const ['', 'packages/songbird_smufl/']) {
      if (File('$prefix$path').existsSync()) return '$prefix$path';
    }
    throw StateError('"$path" not found');
  }

  test('the committed glyph names are what the metadata generates', () {
    final generated = emitGlyphNames(
      glyphs: readMetadata(resolve('tool/glyphnames.json')),
      classes: readMetadata(resolve('tool/classes.json')),
    );
    final path = resolve('lib/src/generated/glyph_names.g.dart');

    expectGenerated(File(path).readAsStringSync(), generated, path: path);
  });
}

/// Fails with the first line on which [committed] and [generated] part company.
///
/// Generated files run to tens of thousands of lines, so handing the whole
/// thing to `expect` buries the difference in a page of output.
void expectGenerated(
  String committed,
  String generated, {
  required String path,
}) {
  if (committed == generated) return;

  final left = committed.split('\n');
  final right = generated.split('\n');
  var line = 0;
  while (line < left.length &&
      line < right.length &&
      left[line] == right[line]) {
    line++;
  }
  String at(List<String> lines) =>
      line < lines.length ? '"${lines[line]}"' : '<end of file>';

  fail(
    '$path is not what the generator produces; regenerate it.\n'
    'First difference at line ${line + 1}:\n'
    '  committed: ${at(left)}\n'
    '  generated: ${at(right)}',
  );
}
