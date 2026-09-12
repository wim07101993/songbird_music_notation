# Songbird notation example

A small application around the notation widgets.

```sh
flutter run
```

It opens a MusicXML file, switches between reading and editing, writes and
erases notes, transposes, zooms, and saves back to MusicXML.

The score it starts with is built by `tool/make_demo_score.dart`, which uses
the packages themselves to construct Greensleeves and write it out — a
reasonable check that the model and the writer agree with the reader.

```sh
dart run tool/make_demo_score.dart
```
