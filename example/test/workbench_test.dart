import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_notation_example/score_workbench.dart';

void main() {
  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
  });

  testWidgets('the demo menu loads a generated orchestral score', (
    tester,
  ) async {
    await tester.pumpWidget(const MaterialApp(home: ScoreWorkbench()));
    await tester.pumpAndSettle();

    // The bundled file is what opens first.
    expect(find.text('greensleeves.musicxml'), findsOneWidget);
    expect(find.textContaining('2 parts'), findsOneWidget);

    await tester.tap(find.byIcon(Icons.library_music_outlined));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Orchestra · short'));
    await tester.pumpAndSettle();

    expect(find.text('Orchestra · short'), findsOneWidget);
    expect(find.textContaining('33 parts'), findsOneWidget);
    expect(find.textContaining('16 measures'), findsOneWidget);
    // Measured while painting and read back after the frame, so it is only
    // there once a frame has actually been drawn.
    expect(find.textContaining('engraved in'), findsOneWidget);
  });
}
