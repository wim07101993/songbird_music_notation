import 'package:flutter/material.dart' hide Step;
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_notation_example/theme_dialog.dart';
import 'package:songbird_score/demo.dart';

void main() {
  setUpAll(() async {
    final bytes = await rootBundle.load(
      'packages/songbird_smufl/assets/fonts/Bravura.otf',
    );
    await (FontLoader(
      'packages/songbird_smufl/Bravura',
    )..addFont(Future.value(bytes))).load();
  });

  late ScoreController controller;

  setUp(() {
    controller = ScoreController(score: buildShowcaseScore());
  });

  tearDown(() => controller.dispose());

  Future<void> open(WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(body: ThemeDialog(controller: controller)),
      ),
    );
    await tester.pumpAndSettle();
  }

  /// The dialog is a lazy list, so anything below the fold has to be brought
  /// into view before it exists to be tapped.
  Future<Finder> reveal(WidgetTester tester, Finder target) async {
    await tester.scrollUntilVisible(
      target,
      120,
      scrollable: find.byType(Scrollable).first,
    );
    await tester.pumpAndSettle();
    return target;
  }

  testWidgets('a slider changes the score as it moves', (tester) async {
    await open(tester);
    final before = controller.style.staffDistance;

    await reveal(tester, find.widgetWithText(ListTile, 'Staff distance'));
    final slider = find.descendant(
      of: find.widgetWithText(ListTile, 'Staff distance'),
      matching: find.byType(Slider),
    );
    await tester.drag(slider, const Offset(60, 0));
    await tester.pumpAndSettle();

    expect(controller.style.staffDistance, isNot(before));
    // And only that one: a theme people cannot change one piece at a time is
    // not a theme.
    expect(controller.style.spacingWidth, const EngravingStyle().spacingWidth);
  });

  testWidgets('a colour can be picked without disturbing the others', (
    tester,
  ) async {
    await open(tester);
    final palette = controller.style.colors;

    await tester.tap(find.byKey(const ValueKey('swatch Ink')));
    await tester.pumpAndSettle();
    // The picker offers a fixed set, each keyed by its colour.
    const chosen = Color(0xFFCC2222);
    expect(palette.ink, isNot(chosen));
    await tester.tap(find.byKey(const ValueKey(chosen)));
    await tester.pumpAndSettle();

    expect(controller.style.colors.ink, chosen);
    expect(controller.style.colors.background, palette.background);
    expect(controller.style.colors.staffLines, palette.staffLines);
  });

  testWidgets('the line count can be fixed and let go again', (tester) async {
    await open(tester);
    expect(controller.style.measuresPerSystem, isNull);

    await reveal(tester, find.widgetWithText(ListTile, 'Measures per line'));
    await tester.tap(find.text('Fill the line').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('4 a line').last);
    await tester.pumpAndSettle();
    expect(controller.style.measuresPerSystem, 4);

    // Back to filling, which is a null and not a number: copyWith has to be
    // able to say so.
    await tester.tap(find.text('4 a line').last);
    await tester.pumpAndSettle();
    await tester.tap(find.text('Fill the line').last);
    await tester.pumpAndSettle();
    expect(controller.style.measuresPerSystem, isNull);
  });

  testWidgets('undo puts back the theme the dialog opened with', (
    tester,
  ) async {
    await open(tester);
    final before = controller.style;

    await reveal(tester, find.widgetWithText(ListTile, 'Staff distance'));
    await tester.drag(
      find.descendant(
        of: find.widgetWithText(ListTile, 'Staff distance'),
        matching: find.byType(Slider),
      ),
      const Offset(60, 0),
    );
    await tester.pumpAndSettle();
    expect(controller.style, isNot(before));

    await tester.tap(find.text('Undo my changes'));
    await tester.pumpAndSettle();
    expect(controller.style, before);
  });
}
