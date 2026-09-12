import 'package:songbird_musicxml/src/document.dart';
import 'package:songbird_musicxml/src/dom/elements.g.dart' as dom;
import 'package:songbird_musicxml/src/dom/enums.g.dart' as dom;
import 'package:songbird_score/songbird_score.dart' as model;

/// Turns a [model.Score] back into MusicXML.
///
/// The model gives every event an absolute position; MusicXML wants a stream
/// with a cursor. Writing puts the cursor back: each voice is written in turn,
/// with `<backup>` to return to the start of the measure and `<forward>` to
/// skip a gap.
class MusicXmlWriter {
  const MusicXmlWriter({
    this.software = 'songbird_musicxml',
  });

  /// Recorded in `<encoding><software>`, so that a file can say what made it.
  final String software;

  /// Writes [score] as MusicXML text.
  String write(model.Score score, {bool pretty = true}) =>
      MusicXmlDocument.partwise(toPartwise(score)).toXmlString(pretty: pretty);

  /// Writes [score] as a compressed `.mxl` container.
  List<int> writeCompressed(model.Score score) =>
      MusicXmlDocument.partwise(toPartwise(score)).toCompressedBytes();

  /// Builds the partwise document model for [score].
  dom.ScorePartwise toPartwise(model.Score score) => dom.ScorePartwise(
    version: score.version,
    work: score.metadata.workTitle == null && score.metadata.workNumber == null
        ? null
        : dom.Work(
            workTitle: score.metadata.workTitle,
            workNumber: score.metadata.workNumber,
          ),
    movementTitle: score.metadata.movementTitle,
    movementNumber: score.metadata.movementNumber,
    identification: _identification(score),
    defaults: _defaults(score.defaults),
    partList: _partList(score),
    part: [for (final part in score.parts) _writePart(part)],
  );

  dom.Identification _identification(model.Score score) => dom.Identification(
    creator: [
      for (final creator in score.metadata.creators)
        dom.TypedText(value: creator.name, type: creator.type),
    ],
    rights: [
      for (final rights in score.metadata.rights) dom.TypedText(value: rights),
    ],
    source: score.metadata.source,
    encoding: dom.Encoding(
      items: [
        dom.EncodingItem(software: software),
        if (score.metadata.encodingDate != null)
          dom.EncodingItem(encodingDate: score.metadata.encodingDate),
      ],
    ),
  );

  dom.Defaults _defaults(model.ScoreDefaults defaults) => dom.Defaults(
    scaling: dom.Scaling(
      millimeters: defaults.scaling.millimeters,
      tenths: defaults.scaling.tenths,
    ),
    pageLayout: dom.PageLayout(
      pageWidth: defaults.pageLayout.pageWidth,
      pageHeight: defaults.pageLayout.pageHeight,
    ),
    systemLayout: dom.SystemLayout(
      systemDistance: defaults.systemLayout.systemDistance,
      topSystemDistance: defaults.systemLayout.topSystemDistance,
    ),
  );

  dom.PartList _partList(model.Score score) {
    final items = <dom.PartListItem>[];
    for (var index = 0; index < score.parts.length; index++) {
      for (final group in score.partGroups) {
        if (group.startPartIndex == index) {
          items.add(
            dom.PartListItem(
              partGroup: dom.PartGroup(
                type: dom.StartStop.start,
                number: group.number,
                groupName: group.name == null
                    ? null
                    : dom.GroupName(value: group.name!),
                groupAbbreviation: group.abbreviation == null
                    ? null
                    : dom.GroupName(value: group.abbreviation!),
                groupSymbol: dom.GroupSymbol(
                  value: switch (group.symbol) {
                    model.GroupSymbol.brace => dom.GroupSymbolValue.brace,
                    model.GroupSymbol.line => dom.GroupSymbolValue.line,
                    model.GroupSymbol.square => dom.GroupSymbolValue.square,
                    model.GroupSymbol.bracket => dom.GroupSymbolValue.bracket,
                    model.GroupSymbol.none => dom.GroupSymbolValue.none,
                  },
                ),
                groupBarline: dom.GroupBarline(
                  value: group.groupBarline
                      ? dom.GroupBarlineValue.yes
                      : dom.GroupBarlineValue.no,
                ),
              ),
            ),
          );
        }
      }

      final part = score.parts[index];
      items.add(
        dom.PartListItem(
          scorePart: dom.ScorePart(
            id: part.id,
            items: [
              dom.ScorePartItem(
                partName: dom.PartName(
                  value: part.name,
                  printObject: part.printName ? null : dom.YesNo.no,
                ),
              ),
              if (part.abbreviation != null)
                dom.ScorePartItem(
                  partAbbreviation: dom.PartName(value: part.abbreviation!),
                ),
              for (final instrument in part.instruments)
                dom.ScorePartItem(
                  scoreInstrument: dom.ScoreInstrument(
                    id: instrument.id,
                    instrumentName: instrument.name,
                    instrumentAbbreviation: instrument.abbreviation,
                    instrumentSound: instrument.sound,
                  ),
                ),
              for (final midi in part.midiInstruments)
                dom.ScorePartItem(
                  midiInstrument: dom.MidiInstrument(
                    id: midi.id,
                    midiChannel: midi.channel,
                    midiProgram: midi.program,
                    midiUnpitched: midi.unpitched,
                    midiName: midi.name,
                    midiBank: midi.bank,
                    volume: midi.volume,
                    pan: midi.pan,
                    elevation: midi.elevation,
                  ),
                ),
            ],
          ),
        ),
      );

      for (final group in score.partGroups.reversed) {
        if (group.endPartIndex == index) {
          items.add(
            dom.PartListItem(
              partGroup: dom.PartGroup(
                type: dom.StartStop.stop,
                number: group.number,
              ),
            ),
          );
        }
      }
    }
    return dom.PartList(items: items);
  }

  dom.ScorePartwisePart _writePart(model.Part part) {
    final divisions = _divisionsFor(part);
    final writer = _PartWriter(part, divisions);
    return dom.ScorePartwisePart(id: part.id, measure: writer.write());
  }

  /// The smallest number of divisions per quarter note that makes every
  /// duration in [part] a whole number.
  ///
  /// MusicXML counts time in integers, so a part containing triplet eighths
  /// needs at least 6 divisions per quarter and one with sixteenth-note
  /// quintuplets needs 20.
  static int _divisionsFor(model.Part part) {
    var divisions = 1;
    void require(model.Fraction value) {
      if (value.isZero) return;
      final denominator = value.denominator;
      final needed = denominator ~/ _gcd(denominator, 4);
      divisions = divisions ~/ _gcd(divisions, needed) * needed;
    }

    for (final measure in part.measures) {
      for (final event in measure.events) {
        require(event.duration);
        require(event.position);
      }
    }
    // Keep the number sane for files with unusual nesting; anything beyond
    // this is more likely a rounding artefact than real music.
    return divisions.clamp(1, 30240);
  }

  static int _gcd(int a, int b) {
    var left = a;
    var right = b;
    while (right != 0) {
      final remainder = left % right;
      left = right;
      right = remainder;
    }
    return left == 0 ? 1 : left;
  }
}

/// Writes the measures of one part.
class _PartWriter {
  _PartWriter(
    this.part,
    this.divisions,
  ) {
    for (final spanner in part.spanners) {
      _startsAt.putIfAbsent(spanner.start, () => []).add(spanner);
      _endsAt.putIfAbsent(spanner.end, () => []).add(spanner);
    }
  }

  final model.Part part;

  /// Divisions per quarter note used throughout this part.
  final int divisions;

  final Map<model.MusicalEvent, List<model.Spanner>> _startsAt = {};
  final Map<model.MusicalEvent, List<model.Spanner>> _endsAt = {};

  List<dom.ScorePartwisePartMeasure> write() {
    final measures = <dom.ScorePartwisePartMeasure>[];
    for (var index = 0; index < part.measures.length; index++) {
      measures.add(_writeMeasure(part.measures[index], first: index == 0));
    }
    return measures;
  }

  dom.ScorePartwisePartMeasure _writeMeasure(
    model.Measure measure, {
    required bool first,
  }) {
    final items = <dom.MusicDataItem>[];

    if (measure.printHint != null && !measure.printHint!.isEmpty) {
      final hint = measure.printHint!;
      items.add(
        dom.MusicDataItem(
          print: dom.Print(
            newSystem: hint.newSystem ? dom.YesNo.yes : null,
            newPage: hint.newPage ? dom.YesNo.yes : null,
            blankPage: hint.blankPage,
            pageNumber: hint.pageNumber,
          ),
        ),
      );
    }

    // The first measure always states divisions, even when the source did not,
    // because everything after it is measured in them.
    final opening = measure.attributesOrNull;
    if (first || (opening != null && !opening.isEmpty)) {
      items.add(
        dom.MusicDataItem(
          attributes: _writeAttributes(
            opening ?? model.MeasureAttributes(),
            includeDivisions: first,
          ),
        ),
      );
    }

    if (measure.leftBarline != null) {
      items.add(
        dom.MusicDataItem(barline: _writeBarline(measure.leftBarline!)),
      );
    }

    final laterChanges = [
      for (final change in measure.attributeChanges)
        if (!change.position.isZero) change,
    ]..sort((a, b) => a.position.compareTo(b.position));

    final groups = _voiceGroups(measure);
    var cursor = model.Fraction.zero;
    var pendingChanges = [...laterChanges];

    for (var groupIndex = 0; groupIndex < groups.length; groupIndex++) {
      final group = groups[groupIndex];
      if (group.events.isEmpty) continue;

      if (!cursor.isZero) {
        items.add(
          dom.MusicDataItem(backup: dom.Backup(duration: _divisions(cursor))),
        );
        cursor = model.Fraction.zero;
      }

      for (final event in group.events) {
        // Mid-measure attribute changes are written once, in the first voice
        // that reaches them.
        if (groupIndex == 0) {
          while (pendingChanges.isNotEmpty &&
              pendingChanges.first.position <= event.position) {
            final change = pendingChanges.removeAt(0);
            if (change.position > cursor) {
              items.add(
                dom.MusicDataItem(
                  forward: dom.Forward(
                    duration: _divisions(change.position - cursor),
                  ),
                ),
              );
              cursor = change.position;
            }
            items.add(
              dom.MusicDataItem(
                attributes: _writeAttributes(
                  change.attributes,
                  includeDivisions: false,
                ),
              ),
            );
          }
        }

        if (event.position > cursor) {
          items.add(
            dom.MusicDataItem(
              forward: dom.Forward(
                duration: _divisions(event.position - cursor),
                voice: '${group.voice}',
                staff: group.staff,
              ),
            ),
          );
          cursor = event.position;
        }

        switch (event) {
          case final model.Chord chord:
            items.addAll(_writeChord(chord));
          case final model.Rest rest:
            items.add(dom.MusicDataItem(note: _writeRest(rest)));
          case final model.Direction direction:
            items.add(dom.MusicDataItem(direction: _writeDirection(direction)));
          case final model.Harmony harmony:
            items.add(dom.MusicDataItem(harmony: _writeHarmony(harmony)));
          default:
            continue;
        }
        cursor = cursor + event.duration;
      }

      if (groupIndex == 0) {
        for (final change in pendingChanges) {
          items.add(
            dom.MusicDataItem(
              attributes: _writeAttributes(
                change.attributes,
                includeDivisions: false,
              ),
            ),
          );
        }
        pendingChanges = [];
      }
    }

    if (measure.rightBarline != null) {
      items.add(
        dom.MusicDataItem(barline: _writeBarline(measure.rightBarline!)),
      );
    }

    return dom.ScorePartwisePartMeasure(
      number: measure.number,
      items: items,
      implicit: measure.implicit ? dom.YesNo.yes : null,
      nonControlling: measure.nonControlling ? dom.YesNo.yes : null,
      width: measure.width,
    );
  }

  /// The events of a measure split by staff and voice, in the order they
  /// should be written.
  List<_VoiceGroup> _voiceGroups(model.Measure measure) {
    final groups = <String, _VoiceGroup>{};
    for (final event in measure.eventsInOrder) {
      final key = '${event.staff}:${event.voice}';
      groups
          .putIfAbsent(key, () => _VoiceGroup(event.staff, event.voice))
          .events
          .add(event);
    }
    final result = groups.values.toList()
      ..sort((a, b) {
        final byStaff = a.staff.compareTo(b.staff);
        return byStaff != 0 ? byStaff : a.voice.compareTo(b.voice);
      });
    return result;
  }

  // ------------------------------------------------------------- attributes

  dom.Attributes _writeAttributes(
    model.MeasureAttributes attributes, {
    required bool includeDivisions,
  }) => dom.Attributes(
    divisions: includeDivisions ? divisions.toDouble() : null,
    key: [
      for (final entry in attributes.keys.entries)
        dom.Key(
          number: entry.key == model.allStaves ? null : entry.key,
          items: [
            dom.KeyItem(fifths: entry.value.fifths),
            if (entry.value.mode != model.Mode.none)
              dom.KeyItem(mode: entry.value.mode.name),
          ],
        ),
    ],
    time: [
      if (attributes.time != null)
        _writeTime(attributes.time!, printed: attributes.printTime),
    ],
    staves: attributes.staves,
    instruments: attributes.instruments,
    clef: [
      for (final entry in attributes.clefs.entries)
        dom.Clef(
          sign: _clefSign(entry.value.sign),
          line: entry.value.line,
          clefOctaveChange: entry.value.octaveChange == 0
              ? null
              : entry.value.octaveChange,
          number: entry.key == model.allStaves ? null : entry.key,
        ),
    ],
    transpose: [
      for (final entry in attributes.transposes.entries)
        dom.Transpose(
          diatonic: entry.value.interval.diatonicSteps % 7,
          chromatic: (entry.value.interval.chromaticSemitones % 12).toDouble(),
          octaveChange: (entry.value.interval.diatonicSteps / 7).floor(),
          doubleValue: entry.value.doubled ? dom.Double() : null,
          number: entry.key == model.allStaves ? null : entry.key,
        ),
    ],
    staffDetails: [
      for (final entry in attributes.staffDetails.entries)
        dom.StaffDetails(
          number: entry.key == model.allStaves ? null : entry.key,
          staffLines: entry.value.staffLines,
          capo: entry.value.capo,
          printObject: entry.value.printObject ? null : dom.YesNo.no,
        ),
    ],
  );

  dom.Time _writeTime(model.TimeSignature time, {required bool printed}) =>
      dom.Time(
        printObject: printed ? null : dom.YesNo.no,
        symbol: switch (time.symbol) {
          model.TimeSymbol.common => dom.TimeSymbol.common,
          model.TimeSymbol.cut => dom.TimeSymbol.cut,
          model.TimeSymbol.singleNumber => dom.TimeSymbol.singleNumber,
          model.TimeSymbol.note => dom.TimeSymbol.note,
          model.TimeSymbol.dottedNote => dom.TimeSymbol.dottedNote,
          model.TimeSymbol.normal || model.TimeSymbol.none => null,
        },
        items: [
          for (final component in time.components) ...[
            dom.TimeItem(beats: component.beats.join('+')),
            dom.TimeItem(beatType: '${component.beatType}'),
          ],
        ],
      );

  dom.Barline _writeBarline(model.Barline barline) => dom.Barline(
    location: switch (barline.location) {
      model.BarlineLocation.left => dom.RightLeftMiddle.left,
      model.BarlineLocation.middle => dom.RightLeftMiddle.middle,
      model.BarlineLocation.right => dom.RightLeftMiddle.right,
    },
    barStyle: dom.BarStyleColor(value: _barStyle(barline.style)),
    repeat: barline.repeat == null
        ? null
        : dom.Repeat(
            direction:
                barline.repeat!.direction == model.RepeatDirection.forward
                ? dom.BackwardForward.forward
                : dom.BackwardForward.backward,
            times: barline.repeat!.times,
          ),
    ending: barline.ending == null
        ? null
        : dom.Ending(
            value: barline.ending!.text ?? '',
            number: barline.ending!.numbers.join(', '),
            type: switch (barline.ending!.type) {
              model.EndingType.start => dom.StartStopDiscontinue.start,
              model.EndingType.stop => dom.StartStopDiscontinue.stop,
              model.EndingType.discontinue =>
                dom.StartStopDiscontinue.discontinue,
            },
          ),
    segno: barline.segno ? dom.Segno() : null,
    coda: barline.coda ? dom.Coda() : null,
  );

  // ------------------------------------------------------------------ notes

  List<dom.MusicDataItem> _writeChord(model.Chord chord) {
    final notes = <dom.MusicDataItem>[];
    final ordered = chord.sortedNotes;
    for (var index = 0; index < ordered.length; index++) {
      notes.add(
        dom.MusicDataItem(
          note: _writeNote(
            chord,
            ordered[index],
            isChordMember: index > 0,
            // Notations belong on the first note of a chord only.
            includeNotations: index == 0,
          ),
        ),
      );
    }
    return notes;
  }

  dom.Note _writeNote(
    model.Chord chord,
    model.Note note, {
    required bool isChordMember,
    required bool includeNotations,
  }) {
    final items = <dom.NoteItem>[];
    final grace = chord.grace;
    if (grace != null) {
      items.add(
        dom.NoteItem(
          grace: dom.Grace(
            slash: grace.slash ? dom.YesNo.yes : null,
            stealTimePrevious: grace.stealTimePrevious,
            stealTimeFollowing: grace.stealTimeFollowing,
            makeTime: grace.makeTime,
          ),
        ),
      );
    }
    if (chord.cue) items.add(dom.NoteItem(cue: dom.Empty()));
    if (isChordMember) items.add(dom.NoteItem(chord: dom.Empty()));

    final pitch = note.pitch;
    if (pitch != null) {
      items.add(
        dom.NoteItem(
          pitch: dom.Pitch(
            step: _step(pitch.step),
            alter: pitch.alter == 0 ? null : pitch.alter,
            octave: pitch.octave,
          ),
        ),
      );
    } else {
      final display = note.unpitchedPosition;
      items.add(
        dom.NoteItem(
          unpitched: dom.Unpitched(
            displayStep: display == null ? null : _step(display.step),
            displayOctave: display?.octave,
          ),
        ),
      );
    }

    if (!chord.isGrace) {
      items.add(dom.NoteItem(duration: _divisions(chord.rhythm.value)));
    }
    for (final tie in _tieTypes(note.tie)) {
      items.add(dom.NoteItem(tie: dom.Tie(type: tie)));
    }
    items.add(dom.NoteItem(voice: '${chord.voice}'));
    items.add(
      dom.NoteItem(
        type: dom.NoteType(value: _noteTypeValue(chord.rhythm.type)),
      ),
    );
    for (var i = 0; i < chord.rhythm.dots; i++) {
      items.add(dom.NoteItem(dot: dom.EmptyPlacement()));
    }
    final accidental = note.accidental;
    if (accidental != null) {
      final value = dom.AccidentalValue.parse(accidental.type.xmlName);
      if (value != null) {
        items.add(
          dom.NoteItem(
            accidental: dom.Accidental(
              value: value,
              cautionary: accidental.cautionary ? dom.YesNo.yes : null,
              editorial: accidental.editorial ? dom.YesNo.yes : null,
              parentheses: accidental.parentheses ? dom.YesNo.yes : null,
              bracket: accidental.bracket ? dom.YesNo.yes : null,
            ),
          ),
        );
      }
    }
    if (chord.rhythm.isTuplet) {
      items.add(
        dom.NoteItem(
          timeModification: dom.TimeModification(
            actualNotes: chord.rhythm.timeModification.actualNotes,
            normalNotes: chord.rhythm.timeModification.normalNotes,
          ),
        ),
      );
    }
    if (chord.stem != model.StemDirection.none) {
      items.add(dom.NoteItem(stem: dom.Stem(value: _stemValue(chord.stem))));
    }
    final notehead = note.notehead;
    if (notehead != null) {
      final value = dom.NoteheadValue.parse(notehead.xmlName);
      if (value != null) {
        items.add(
          dom.NoteItem(
            notehead: dom.Notehead(
              value: value,
              filled: switch (note.filledNotehead) {
                true => dom.YesNo.yes,
                false => dom.YesNo.no,
                null => null,
              },
            ),
          ),
        );
      }
    }
    items.add(dom.NoteItem(staff: chord.staff));
    for (final beam in chord.beams) {
      items.add(
        dom.NoteItem(
          beam: dom.Beam(value: _beamValue(beam.state), number: beam.level),
        ),
      );
    }

    if (includeNotations) {
      final notations = _writeNotations(chord, note);
      if (notations != null) items.add(dom.NoteItem(notations: notations));
      for (final lyric in chord.lyrics) {
        items.add(dom.NoteItem(lyric: _writeLyric(lyric)));
      }
    } else {
      final tied = _writeTiedOnly(chord, note);
      if (tied != null) items.add(dom.NoteItem(notations: tied));
    }

    return dom.Note(
      items: items,
      color: note.color,
      printObject: note.printObject ? null : dom.YesNo.no,
      printSpacing: note.printSpacing ? null : dom.YesNo.no,
    );
  }

  dom.Note _writeRest(model.Rest rest) {
    final display = rest.displayPitch;
    return dom.Note(
      items: [
        if (rest.cue) dom.NoteItem(cue: dom.Empty()),
        dom.NoteItem(
          rest: dom.Rest(
            measure: rest.isMeasureRest ? dom.YesNo.yes : null,
            displayStep: display == null ? null : _step(display.step),
            displayOctave: display?.octave,
          ),
        ),
        dom.NoteItem(duration: _divisions(rest.duration)),
        dom.NoteItem(voice: '${rest.voice}'),
        if (!rest.isMeasureRest)
          dom.NoteItem(
            type: dom.NoteType(value: _noteTypeValue(rest.rhythm.type)),
          ),
        for (var i = 0; i < (rest.isMeasureRest ? 0 : rest.rhythm.dots); i++)
          dom.NoteItem(dot: dom.EmptyPlacement()),
        dom.NoteItem(staff: rest.staff),
      ],
      printObject: rest.printObject ? null : dom.YesNo.no,
      printSpacing: rest.printSpacing ? null : dom.YesNo.no,
    );
  }

  dom.Notations? _writeNotations(model.Chord chord, model.Note note) {
    final items = <dom.NotationsItem>[];

    if (note.tied) {
      // The side the tie is bowed to is written on the note it starts from,
      // which is where a reader looks for it.
      final tie = _startsAt[chord]
          ?.whereType<model.Tie>()
          .where((tie) => identical(chord.notes[tie.startNoteIndex], note))
          .firstOrNull;
      for (final type in _tiedTypes(note.tie)) {
        items.add(
          dom.NotationsItem(
            tied: dom.Tied(
              type: type,
              orientation: switch (tie?.orientation) {
                model.LineOrientation.over => dom.OverUnder.over,
                model.LineOrientation.under => dom.OverUnder.under,
                _ => null,
              },
              placement: switch (tie?.placement) {
                model.Placement.above => dom.AboveBelow.above,
                model.Placement.below => dom.AboveBelow.below,
                null => null,
              },
            ),
          ),
        );
      }
    }

    for (final spanner in _startsAt[chord] ?? const <model.Spanner>[]) {
      if (spanner is model.Slur) {
        items.add(
          dom.NotationsItem(
            // The side the slur is bowed to goes on the note it starts from,
            // which is where a reader looks for it.
            slur: dom.Slur(
              type: dom.StartStopContinue.start,
              number: spanner.number,
              placement: switch (spanner.placement) {
                model.Placement.above => dom.AboveBelow.above,
                model.Placement.below => dom.AboveBelow.below,
                null => null,
              },
              orientation: switch (spanner.orientation) {
                model.LineOrientation.over => dom.OverUnder.over,
                model.LineOrientation.under => dom.OverUnder.under,
                model.LineOrientation.auto => null,
              },
            ),
          ),
        );
      } else if (spanner is model.Tuplet) {
        items.add(
          dom.NotationsItem(
            tuplet: dom.Tuplet(
              type: dom.StartStop.start,
              number: spanner.number,
              bracket: switch (spanner.bracket) {
                true => dom.YesNo.yes,
                false => dom.YesNo.no,
                null => null,
              },
            ),
          ),
        );
      }
    }
    for (final spanner in _endsAt[chord] ?? const <model.Spanner>[]) {
      if (spanner is model.Slur) {
        items.add(
          dom.NotationsItem(
            slur: dom.Slur(
              type: dom.StartStopContinue.stop,
              number: spanner.number,
            ),
          ),
        );
      } else if (spanner is model.Tuplet) {
        items.add(
          dom.NotationsItem(
            tuplet: dom.Tuplet(
              type: dom.StartStop.stop,
              number: spanner.number,
            ),
          ),
        );
      }
    }

    // The string and fret a note is played at, which is what a tablature staff
    // is written from and the only technique this writes: the rest live on the
    // chord and would be repeated once per notehead.
    if (note.string != null || note.fret != null) {
      items.add(
        dom.NotationsItem(
          technical: dom.Technical(
            items: [
              if (note.string != null)
                dom.TechnicalItem(
                  string: dom.StringElement(value: note.string!),
                ),
              if (note.fret != null)
                dom.TechnicalItem(fret: dom.Fret(value: note.fret!)),
            ],
          ),
        ),
      );
    }

    if (chord.articulations.isNotEmpty) {
      items.add(
        dom.NotationsItem(
          articulations: dom.Articulations(
            items: [
              for (final articulation in chord.articulations)
                _articulationItem(articulation),
            ],
          ),
        ),
      );
    }
    if (chord.ornaments.isNotEmpty || chord.tremolo != null) {
      items.add(
        dom.NotationsItem(
          ornaments: dom.Ornaments(
            items: [
              for (final ornament in chord.ornaments) _ornamentItem(ornament),
              if (chord.tremolo != null)
                dom.OrnamentsItem(
                  tremolo: dom.Tremolo(
                    value: chord.tremolo!.marks,
                    type: switch (chord.tremolo!.kind) {
                      model.TremoloKind.start => dom.TremoloType.start,
                      model.TremoloKind.stop => dom.TremoloType.stop,
                      model.TremoloKind.unmeasured =>
                        dom.TremoloType.unmeasured,
                      model.TremoloKind.single => dom.TremoloType.single,
                    },
                  ),
                ),
            ],
          ),
        ),
      );
    }
    for (final fermata in chord.fermatas) {
      items.add(
        dom.NotationsItem(
          fermata: dom.Fermata(
            value: _fermataShape(fermata.shape),
            type: fermata.placement == model.Placement.below
                ? dom.UprightInverted.inverted
                : dom.UprightInverted.upright,
          ),
        ),
      );
    }
    if (chord.arpeggiate) {
      items.add(dom.NotationsItem(arpeggiate: dom.Arpeggiate()));
    }

    return items.isEmpty ? null : dom.Notations(items: items);
  }

  /// The `<notations>` of a chord note other than the first, which carries
  /// nothing but its own tie.
  dom.Notations? _writeTiedOnly(model.Chord chord, model.Note note) {
    if (!note.tied) return null;
    final items = [
      for (final type in _tiedTypes(note.tie))
        dom.NotationsItem(tied: dom.Tied(type: type)),
    ];
    return items.isEmpty ? null : dom.Notations(items: items);
  }

  dom.Lyric _writeLyric(model.Lyric lyric) => dom.Lyric(
    number: '${lyric.number}',
    name: lyric.name,
    placement: lyric.placement == model.Placement.above
        ? dom.AboveBelow.above
        : dom.AboveBelow.below,
    items: [
      dom.LyricItem(
        syllabic: switch (lyric.syllabic) {
          model.Syllabic.single => dom.Syllabic.single,
          model.Syllabic.begin => dom.Syllabic.begin,
          model.Syllabic.end => dom.Syllabic.end,
          model.Syllabic.middle => dom.Syllabic.middle,
        },
      ),
      dom.LyricItem(text: dom.TextElementData(value: lyric.text)),
      if (lyric.extend) dom.LyricItem(extend: dom.Extend()),
    ],
  );

  // ---------------------------------------------------------------- harmony

  dom.Harmony _writeHarmony(model.Harmony harmony) => dom.Harmony(
    items: [
      dom.HarmonyItem(
        root: dom.Root(
          rootStep: dom.RootStep(value: _step(harmony.root.step)),
          rootAlter: harmony.root.alter == 0
              ? null
              : dom.HarmonyAlter(value: harmony.root.alter),
        ),
      ),
      dom.HarmonyItem(
        kind: dom.Kind(
          value:
              dom.KindValue.parse(harmony.kind.xmlName) ?? dom.KindValue.other,
          // Only when the file's own wording is being kept; a kind that reads
          // the same either way is left for the reader to spell.
          text: harmony.text,
        ),
      ),
      if (harmony.bass != null)
        dom.HarmonyItem(
          bass: dom.Bass(
            bassStep: dom.BassStep(value: _step(harmony.bass!.step)),
            bassAlter: harmony.bass!.alter == 0
                ? null
                : dom.HarmonyAlter(value: harmony.bass!.alter),
          ),
        ),
    ],
  );

  // ------------------------------------------------------------- directions

  dom.Direction _writeDirection(model.Direction direction) => dom.Direction(
    placement: direction.placement == model.Placement.above
        ? dom.AboveBelow.above
        : dom.AboveBelow.below,
    voice: '${direction.voice}',
    staff: direction.staff,
    directionType: [
      for (final type in direction.types)
        if (_writeDirectionType(type) case final item?)
          dom.DirectionType(items: [item]),
    ],
    sound: direction.sound == null ? null : _writeSound(direction.sound!),
  );

  dom.DirectionTypeItem? _writeDirectionType(model.DirectionType type) {
    switch (type) {
      case final model.DynamicsDirection dynamics:
        return dom.DirectionTypeItem(
          dynamics: dom.Dynamics(
            items: [
              for (final mark in dynamics.marks) _dynamicsItem(mark),
              if (dynamics.otherText != null)
                dom.DynamicsItem(
                  otherDynamics: dom.OtherText(value: dynamics.otherText!),
                ),
            ],
          ),
        );
      case final model.WordsDirection words:
        return dom.DirectionTypeItem(
          words: dom.FormattedTextId(value: words.text),
        );
      case final model.WedgeDirection wedge:
        return dom.DirectionTypeItem(
          wedge: dom.Wedge(
            type: switch (wedge.type) {
              model.WedgeType.crescendo => dom.WedgeType.crescendo,
              model.WedgeType.diminuendo => dom.WedgeType.diminuendo,
              model.WedgeType.stop => dom.WedgeType.stop,
              model.WedgeType.wedgeContinue => dom.WedgeType.continueValue,
            },
            number: wedge.number,
            spread: wedge.spread,
          ),
        );
      case final model.MetronomeDirection metronome:
        final beatUnit = dom.NoteTypeValue.parse(metronome.beatUnit);
        if (beatUnit == null) return null;
        return dom.DirectionTypeItem(
          metronome: dom.Metronome(
            parentheses: metronome.parentheses ? dom.YesNo.yes : null,
            items: [
              dom.MetronomeItem(beatUnit: beatUnit),
              for (var i = 0; i < metronome.beatUnitDots; i++)
                dom.MetronomeItem(beatUnitDot: dom.Empty()),
              if (metronome.perMinute != null)
                dom.MetronomeItem(
                  perMinute: dom.PerMinute(
                    value: _number(metronome.perMinute!),
                  ),
                ),
              if (metronome.secondBeatUnit != null &&
                  dom.NoteTypeValue.parse(metronome.secondBeatUnit) != null)
                dom.MetronomeItem(
                  beatUnit: dom.NoteTypeValue.parse(metronome.secondBeatUnit),
                ),
            ],
          ),
        );
      case final model.OctaveShiftDirection shift:
        return dom.DirectionTypeItem(
          octaveShift: dom.OctaveShift(
            type: switch (shift.type) {
              model.OctaveShiftType.up => dom.UpDownStopContinue.up,
              model.OctaveShiftType.down => dom.UpDownStopContinue.down,
              model.OctaveShiftType.stop => dom.UpDownStopContinue.stop,
              model.OctaveShiftType.octaveContinue =>
                dom.UpDownStopContinue.continueValue,
            },
            size: shift.size,
            number: shift.number,
          ),
        );
      case final model.PedalDirection pedal:
        return dom.DirectionTypeItem(
          pedal: dom.Pedal(
            type: switch (pedal.type) {
              model.PedalType.start => dom.PedalType.start,
              model.PedalType.stop => dom.PedalType.stop,
              model.PedalType.sostenuto => dom.PedalType.sostenuto,
              model.PedalType.change => dom.PedalType.change,
              model.PedalType.pedalContinue => dom.PedalType.continueValue,
              model.PedalType.discontinue => dom.PedalType.discontinue,
              model.PedalType.resume => dom.PedalType.resume,
            },
            line: pedal.line ? dom.YesNo.yes : null,
            sign: pedal.sign ? dom.YesNo.yes : null,
          ),
        );
      case final model.RehearsalDirection rehearsal:
        return dom.DirectionTypeItem(
          rehearsal: dom.FormattedTextId(value: rehearsal.text),
        );
      case model.SegnoDirection():
        return dom.DirectionTypeItem(segno: dom.Segno());
      case model.CodaDirection():
        return dom.DirectionTypeItem(coda: dom.Coda());
      case model.UnknownDirection():
        return null;
    }
  }

  dom.Sound _writeSound(model.SoundInfo sound) => dom.Sound(
    tempo: sound.tempo,
    dynamics: sound.dynamics,
    dacapo: sound.dacapo ? dom.YesNo.yes : null,
    segno: sound.segno,
    dalsegno: sound.dalsegno,
    coda: sound.coda,
    tocoda: sound.tocoda,
    fine: sound.fine,
    forwardRepeat: sound.forwardRepeat ? dom.YesNo.yes : null,
    pizzicato: switch (sound.pizzicato) {
      true => dom.YesNo.yes,
      false => dom.YesNo.no,
      null => null,
    },
  );

  // ------------------------------------------------------------- conversion

  /// A length in whole notes as a count of divisions.
  double _divisions(model.Fraction value) =>
      (value * model.Fraction(divisions * 4)).toDouble();

  static String _number(double value) =>
      value == value.roundToDouble() ? '${value.toInt()}' : '$value';

  /// The `<tied>` types drawn for a tie state. Separate from [_tieTypes]
  /// because `<tie>` records the sound and `<tied>` the drawn curve, and the
  /// two use different enumerations.
  static List<dom.TiedType> _tiedTypes(model.TieState tie) => switch (tie) {
    model.TieState.none => const [],
    model.TieState.start => const [dom.TiedType.start],
    model.TieState.stop => const [dom.TiedType.stop],
    model.TieState.stopStart => const [dom.TiedType.stop, dom.TiedType.start],
  };

  static List<dom.StartStop> _tieTypes(model.TieState tie) => switch (tie) {
    model.TieState.none => const [],
    model.TieState.start => const [dom.StartStop.start],
    model.TieState.stop => const [dom.StartStop.stop],
    model.TieState.stopStart => const [dom.StartStop.stop, dom.StartStop.start],
  };
}

class _VoiceGroup {
  _VoiceGroup(
    this.staff,
    this.voice,
  );

  final int staff;
  final int voice;
  final List<model.MusicalEvent> events = [];
}

// ------------------------------------------------------------- enum mapping

dom.Step _step(model.Step step) => switch (step) {
  model.Step.a => dom.Step.a,
  model.Step.b => dom.Step.b,
  model.Step.c => dom.Step.c,
  model.Step.d => dom.Step.d,
  model.Step.e => dom.Step.e,
  model.Step.f => dom.Step.f,
  model.Step.g => dom.Step.g,
};

dom.ClefSign _clefSign(model.ClefSign sign) => switch (sign) {
  model.ClefSign.g => dom.ClefSign.g,
  model.ClefSign.f => dom.ClefSign.f,
  model.ClefSign.c => dom.ClefSign.c,
  model.ClefSign.percussion => dom.ClefSign.percussion,
  model.ClefSign.tab => dom.ClefSign.tAB,
  model.ClefSign.jianpu => dom.ClefSign.jianpu,
  model.ClefSign.none => dom.ClefSign.none,
};

dom.BarStyle _barStyle(model.BarStyle style) => switch (style) {
  model.BarStyle.regular => dom.BarStyle.regular,
  model.BarStyle.dotted => dom.BarStyle.dotted,
  model.BarStyle.dashed => dom.BarStyle.dashed,
  model.BarStyle.heavy => dom.BarStyle.heavy,
  model.BarStyle.lightLight => dom.BarStyle.lightLight,
  model.BarStyle.lightHeavy => dom.BarStyle.lightHeavy,
  model.BarStyle.heavyLight => dom.BarStyle.heavyLight,
  model.BarStyle.heavyHeavy => dom.BarStyle.heavyHeavy,
  model.BarStyle.tick => dom.BarStyle.tick,
  model.BarStyle.short => dom.BarStyle.short,
  model.BarStyle.none => dom.BarStyle.none,
};

dom.NoteTypeValue _noteTypeValue(model.NoteType type) =>
    dom.NoteTypeValue.parse(type.xmlName) ?? dom.NoteTypeValue.quarter;

dom.StemValue _stemValue(model.StemDirection stem) => switch (stem) {
  model.StemDirection.up => dom.StemValue.up,
  model.StemDirection.down => dom.StemValue.down,
  model.StemDirection.double => dom.StemValue.doubleValue,
  model.StemDirection.none => dom.StemValue.none,
};

dom.BeamValue _beamValue(model.BeamState state) => switch (state) {
  model.BeamState.begin => dom.BeamValue.begin,
  model.BeamState.end => dom.BeamValue.end,
  model.BeamState.forwardHook => dom.BeamValue.forwardHook,
  model.BeamState.backwardHook => dom.BeamValue.backwardHook,
  model.BeamState.continueBeam => dom.BeamValue.continueValue,
};

dom.FermataShape _fermataShape(model.FermataShape shape) => switch (shape) {
  model.FermataShape.normal => dom.FermataShape.normal,
  model.FermataShape.angled => dom.FermataShape.angled,
  model.FermataShape.square => dom.FermataShape.square,
  model.FermataShape.doubleAngled => dom.FermataShape.doubleAngled,
  model.FermataShape.doubleSquare => dom.FermataShape.doubleSquare,
  model.FermataShape.doubleDot => dom.FermataShape.doubleDot,
  model.FermataShape.halfCurve => dom.FermataShape.halfCurve,
  model.FermataShape.curlew => dom.FermataShape.curlew,
};

dom.ArticulationsItem _articulationItem(model.Articulation articulation) =>
    switch (articulation) {
      model.Articulation.accent => dom.ArticulationsItem(
        accent: dom.EmptyPlacement(),
      ),
      model.Articulation.strongAccent => dom.ArticulationsItem(
        strongAccent: dom.StrongAccent(),
      ),
      model.Articulation.staccato => dom.ArticulationsItem(
        staccato: dom.EmptyPlacement(),
      ),
      model.Articulation.tenuto => dom.ArticulationsItem(
        tenuto: dom.EmptyPlacement(),
      ),
      model.Articulation.detachedLegato => dom.ArticulationsItem(
        detachedLegato: dom.EmptyPlacement(),
      ),
      model.Articulation.staccatissimo => dom.ArticulationsItem(
        staccatissimo: dom.EmptyPlacement(),
      ),
      model.Articulation.spiccato => dom.ArticulationsItem(
        spiccato: dom.EmptyPlacement(),
      ),
      model.Articulation.scoop => dom.ArticulationsItem(scoop: dom.EmptyLine()),
      model.Articulation.plop => dom.ArticulationsItem(plop: dom.EmptyLine()),
      model.Articulation.doit => dom.ArticulationsItem(doit: dom.EmptyLine()),
      model.Articulation.falloff => dom.ArticulationsItem(
        falloff: dom.EmptyLine(),
      ),
      model.Articulation.breathMark => dom.ArticulationsItem(
        breathMark: dom.BreathMark(value: dom.BreathMarkValue.comma),
      ),
      model.Articulation.caesura => dom.ArticulationsItem(
        caesura: dom.Caesura(value: dom.CaesuraValue.normal),
      ),
      model.Articulation.stress => dom.ArticulationsItem(
        stress: dom.EmptyPlacement(),
      ),
      model.Articulation.unstress => dom.ArticulationsItem(
        unstress: dom.EmptyPlacement(),
      ),
      model.Articulation.softAccent => dom.ArticulationsItem(
        softAccent: dom.EmptyPlacement(),
      ),
      model.Articulation.otherArticulation => dom.ArticulationsItem(
        otherArticulation: dom.OtherPlacementText(value: ''),
      ),
    };

dom.OrnamentsItem _ornamentItem(model.Ornament ornament) => switch (ornament) {
  model.Ornament.trillMark => dom.OrnamentsItem(
    trillMark: dom.EmptyTrillSound(),
  ),
  model.Ornament.turn => dom.OrnamentsItem(turn: dom.HorizontalTurn()),
  model.Ornament.delayedTurn => dom.OrnamentsItem(
    delayedTurn: dom.HorizontalTurn(),
  ),
  model.Ornament.invertedTurn => dom.OrnamentsItem(
    invertedTurn: dom.HorizontalTurn(),
  ),
  model.Ornament.delayedInvertedTurn => dom.OrnamentsItem(
    delayedInvertedTurn: dom.HorizontalTurn(),
  ),
  model.Ornament.verticalTurn => dom.OrnamentsItem(
    verticalTurn: dom.EmptyTrillSound(),
  ),
  model.Ornament.invertedVerticalTurn => dom.OrnamentsItem(
    invertedVerticalTurn: dom.EmptyTrillSound(),
  ),
  model.Ornament.shake => dom.OrnamentsItem(shake: dom.EmptyTrillSound()),
  model.Ornament.wavyLine => dom.OrnamentsItem(
    wavyLine: dom.WavyLine(type: dom.StartStopContinue.start),
  ),
  model.Ornament.mordent => dom.OrnamentsItem(mordent: dom.Mordent()),
  model.Ornament.invertedMordent => dom.OrnamentsItem(
    invertedMordent: dom.Mordent(),
  ),
  model.Ornament.schleifer => dom.OrnamentsItem(
    schleifer: dom.EmptyPlacement(),
  ),
  model.Ornament.tremolo => dom.OrnamentsItem(tremolo: dom.Tremolo(value: 3)),
  model.Ornament.haydn => dom.OrnamentsItem(haydn: dom.EmptyTrillSound()),
  model.Ornament.otherOrnament => dom.OrnamentsItem(
    otherOrnament: dom.OtherPlacementText(value: ''),
  ),
};

dom.DynamicsItem _dynamicsItem(model.DynamicMark mark) => switch (mark) {
  model.DynamicMark.p => dom.DynamicsItem(p: dom.Empty()),
  model.DynamicMark.pp => dom.DynamicsItem(pp: dom.Empty()),
  model.DynamicMark.ppp => dom.DynamicsItem(ppp: dom.Empty()),
  model.DynamicMark.pppp => dom.DynamicsItem(pppp: dom.Empty()),
  model.DynamicMark.ppppp => dom.DynamicsItem(ppppp: dom.Empty()),
  model.DynamicMark.pppppp => dom.DynamicsItem(pppppp: dom.Empty()),
  model.DynamicMark.f => dom.DynamicsItem(f: dom.Empty()),
  model.DynamicMark.ff => dom.DynamicsItem(ff: dom.Empty()),
  model.DynamicMark.fff => dom.DynamicsItem(fff: dom.Empty()),
  model.DynamicMark.ffff => dom.DynamicsItem(ffff: dom.Empty()),
  model.DynamicMark.fffff => dom.DynamicsItem(fffff: dom.Empty()),
  model.DynamicMark.ffffff => dom.DynamicsItem(ffffff: dom.Empty()),
  model.DynamicMark.mp => dom.DynamicsItem(mp: dom.Empty()),
  model.DynamicMark.mf => dom.DynamicsItem(mf: dom.Empty()),
  model.DynamicMark.sf => dom.DynamicsItem(sf: dom.Empty()),
  model.DynamicMark.sfp => dom.DynamicsItem(sfp: dom.Empty()),
  model.DynamicMark.sfpp => dom.DynamicsItem(sfpp: dom.Empty()),
  model.DynamicMark.fp => dom.DynamicsItem(fp: dom.Empty()),
  model.DynamicMark.rf => dom.DynamicsItem(rf: dom.Empty()),
  model.DynamicMark.rfz => dom.DynamicsItem(rfz: dom.Empty()),
  model.DynamicMark.sfz => dom.DynamicsItem(sfz: dom.Empty()),
  model.DynamicMark.sffz => dom.DynamicsItem(sffz: dom.Empty()),
  model.DynamicMark.fz => dom.DynamicsItem(fz: dom.Empty()),
  model.DynamicMark.n => dom.DynamicsItem(n: dom.Empty()),
  model.DynamicMark.pf => dom.DynamicsItem(pf: dom.Empty()),
  model.DynamicMark.sfzp => dom.DynamicsItem(sfzp: dom.Empty()),
};
