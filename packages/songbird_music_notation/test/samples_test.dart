import 'dart:io';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_musicxml/songbird_musicxml.dart';
import 'package:songbird_smufl/songbird_smufl.dart';

/// The official MusicXML sample set, when it has been fetched.
///
/// These are the files the format was demonstrated with — Dichterliebe, the
/// Mozart quintet, a Binchois Magnificat, an orchestral prelude — and they
/// reach into corners of MusicXML that a score written to test a reader never
/// does. They are also not in this repository: the page they come from carries
/// MakeMusic's copyright and grants permission to host them there, which is
/// not permission to pass them on. `tool/fetch_musicxml_samples.sh` puts them
/// in `samples/`, which git ignores, and these tests run when it finds them.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final directory = _samplesDirectory();
  if (directory == null) {
    test('the MusicXML sample set is not here', () {
      // Not a failure: fetch them with tool/fetch_musicxml_samples.sh.
    }, skip: 'run tool/fetch_musicxml_samples.sh to fetch the sample set');
    return;
  }

  late SmuflFont font;

  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
    font = await loadBravura();
  });

  final files =
      directory
          .listSync()
          .whereType<File>()
          .where((file) => file.path.toLowerCase().endsWith('.musicxml'))
          .toList()
        ..sort((a, b) => a.path.compareTo(b.path));

  test('there are samples to read', () => expect(files, isNotEmpty));

  for (final file in files) {
    final name = file.uri.pathSegments.last;
    test('$name reads and engraves', () {
      // Through fromBytes rather than as a string: several of these are not
      // UTF-8, and the encoding is the document's own business.
      final document = MusicXmlDocument.fromBytes(file.readAsBytesSync());
      final result = const MusicXmlReader().readDocument(document);
      expect(result.score.parts, isNotEmpty, reason: 'nothing was read');

      final layout = LayoutEngine(
        font: font,
        style: EngravingStyle.fromFont(font),
      ).layout(result.score, width: 150);
      expect(layout.systems, isNotEmpty);
      for (final system in layout.systems) {
        expect(system.staves, isNotEmpty);
        expect(
          system.staves.every((staff) => staff.elements.isNotEmpty),
          isTrue,
          reason: 'a staff came out empty',
        );
      }
    }, timeout: const Timeout(Duration(minutes: 2)));
  }
}

/// Where the fetched samples live, or null if they have not been fetched.
Directory? _samplesDirectory() {
  for (final path in const ['samples', '../../samples']) {
    final directory = Directory(path);
    if (directory.existsSync()) return directory;
  }
  return null;
}
