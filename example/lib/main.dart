import 'package:flutter/material.dart' hide Step;

import 'package:songbird_notation_example/score_workbench.dart';

void main() => runApp(const SongbirdExampleApp());

class SongbirdExampleApp extends StatelessWidget {
  const SongbirdExampleApp({
    super.key,
  });

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Songbird Music Notation',
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
      colorSchemeSeed: const Color(0xFF3F6FB5),
      useMaterial3: true,
    ),
    darkTheme: ThemeData(
      colorSchemeSeed: const Color(0xFF3F6FB5),
      brightness: Brightness.dark,
      useMaterial3: true,
    ),
    home: const ScoreWorkbench(),
  );
}
