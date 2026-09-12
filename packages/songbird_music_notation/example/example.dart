// A score on screen, with the toolbar that drives it.
//
// `ScoreController` owns everything that outlives a frame — the score, the
// zoom, the transposition, the selection, the undo history — so the toolbar,
// a keyboard shortcut and a pinch gesture all move the same state. Swap
// `MusicScoreEditor` for `MusicScoreView` for a score that is only read.
import 'package:flutter/material.dart' hide Step;

import 'package:songbird_music_notation/songbird_music_notation.dart';
import 'package:songbird_score/demo.dart';

void main() => runApp(const ExampleApp());

class ExampleApp extends StatefulWidget {
  const ExampleApp({
    super.key,
  });

  @override
  State<ExampleApp> createState() => _ExampleAppState();
}

class _ExampleAppState extends State<ExampleApp> {
  // A score built on demand, so the example needs no MusicXML file.
  final ScoreController _controller = ScoreController(
    score: buildShowcaseScore(),
  );

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => MaterialApp(
    home: Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            ScoreToolbar(controller: _controller),
            Expanded(child: MusicScoreEditor(controller: _controller)),
          ],
        ),
      ),
    ),
  );
}
