import 'dart:io';

import 'package:test/test.dart';
import 'package:xml/xml.dart';

import '../tool/generate_dom.dart';

/// What `dart run tool/generate_dom.dart` writes is committed, so nothing has
/// to run at build time. This is the other half of that bargain: the committed
/// files have to be what the schema actually generates, or a hand edit to them
/// — or a change to the generator without a regeneration — goes unnoticed.
void main() {
  /// Resolves [path] whether the tests were started from the package
  /// directory or from the workspace root.
  String resolve(String path) {
    for (final prefix in const ['', 'packages/songbird_musicxml/']) {
      if (File('$prefix$path').existsSync()) return '$prefix$path';
    }
    throw StateError('"$path" not found');
  }

  test('the committed document model is what the schema generates', () {
    final schema = XmlDocument.parse(
      File(resolve('tool/musicxml.xsd')).readAsStringSync(),
    );
    final generator = DomGenerator(schema.rootElement)..run();

    for (final (path, generated) in [
      ('lib/src/dom/enums.g.dart', generator.emitEnums()),
      ('lib/src/dom/elements.g.dart', generator.emitClasses()),
    ]) {
      expectGenerated(
        File(resolve(path)).readAsStringSync(),
        generated,
        path: path,
      );
    }
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
