import 'package:songbird_score/songbird_score.dart';
import 'package:test/test.dart';

Part _part(String id) => Part(
  id: id,
  name: id,
  measures: [
    Measure(number: '1')..add(
      Chord(
        position: Fraction.zero,
        notes: [Note(pitch: const Pitch(Step.c, 4))],
        rhythm: const RhythmicDuration(NoteType.whole),
      ),
    ),
  ],
);

void main() {
  group('withParts', () {
    late Score score;
    late List<Part> parts;

    setUp(() {
      parts = [
        for (final id in ['A', 'B', 'C', 'D']) _part(id),
      ];
      score = Score(
        parts: parts,
        partGroups: [
          // B and C are bracketed together; D stands alone in a second group.
          PartGroup(number: '1', startPartIndex: 1, endPartIndex: 2),
          PartGroup(number: '2', startPartIndex: 3, endPartIndex: 3),
        ],
      )..metadata.movementTitle = 'Quartet';
    });

    test('keeps the parts themselves, not copies of them', () {
      final filtered = score.withParts([parts[0], parts[2]]);
      expect(filtered.parts, hasLength(2));
      expect(identical(filtered.parts.first, parts[0]), isTrue);
      expect(identical(filtered.parts.last, parts[2]), isTrue);
      // Which is what lets an edit made through a filtered view reach the
      // score it was filtered from.
      final note = filtered.parts.first.measures.first.events
          .whereType<Chord>()
          .first
          .notes
          .first;
      note.pitch = const Pitch(Step.g, 4);
      expect(
        parts[0].measures.first.events
            .whereType<Chord>()
            .first
            .notes
            .first
            .pitch,
        const Pitch(Step.g, 4),
      );
    });

    test('asks for the parts in score order, however they are given', () {
      final filtered = score.withParts([parts[3], parts[1]]);
      expect(filtered.parts.map((p) => p.id), ['B', 'D']);
    });

    test('keeps the metadata, so the title still prints', () {
      expect(score.withParts([parts[0]]).metadata.movementTitle, 'Quartet');
    });

    test('moves a group onto the parts that survive', () {
      // A is dropped, so B and C shift down one and their bracket has to
      // follow them or it will be drawn around the wrong staves.
      final filtered = score.withParts([parts[1], parts[2], parts[3]]);
      final group = filtered.partGroups.first;
      expect(group.startPartIndex, 0);
      expect(group.endPartIndex, 1);
    });

    test('shrinks a group to the members it has left', () {
      final filtered = score.withParts([parts[0], parts[2], parts[3]]);
      final group = filtered.partGroups.firstWhere((g) => g.number == '1');
      expect(group.startPartIndex, 1);
      expect(group.endPartIndex, 1);
    });

    test('drops a group with nothing left in it', () {
      final filtered = score.withParts([parts[0], parts[1], parts[2]]);
      expect(filtered.partGroups.map((g) => g.number), ['1']);
    });

    test('an empty selection is a score with no parts', () {
      expect(score.withParts(const []).parts, isEmpty);
      expect(score.withParts(const []).partGroups, isEmpty);
    });
  });
}
