import 'package:songbird_musicxml/src/document.dart';
import 'package:songbird_musicxml/src/dom/elements.g.dart' as dom;
import 'package:songbird_musicxml/src/dom/enums.g.dart' as dom;
import 'package:songbird_score/songbird_score.dart' as model;

/// The outcome of reading a MusicXML file.
///
/// Real-world MusicXML is frequently a little wrong — a missing duration, a
/// tie that never stops, a clef on a staff the part does not have. Reading
/// recovers from all of those, and records what it had to paper over so that
/// an application can tell the user rather than silently showing something
/// slightly different from the file.
class MusicXmlReadResult {
  MusicXmlReadResult({
    required this.score,
    required this.warnings,
  });

  final model.Score score;

  /// What the reader had to work around, in the order it was found.
  final List<String> warnings;

  bool get isClean => warnings.isEmpty;
}

/// Turns a MusicXML document into a [model.Score].
///
/// MusicXML describes a measure as a stream of notes with a cursor that
/// `<backup>` and `<forward>` move around; the model gives every event an
/// absolute position instead. Resolving that here means nothing downstream has
/// to think about the cursor, and voices that overlap become plain to see.
class MusicXmlReader {
  const MusicXmlReader({
    this.deriveBeams = false,
    this.deriveStemDirections = true,
    this.deriveAccidentals = true,
  });

  /// Recompute beams instead of trusting the file's own.
  ///
  /// Off by default: a file that carries beaming knows better than a rule of
  /// thumb does. Turn it on for files exported without beams.
  final bool deriveBeams;

  /// Fill in stem directions where the file states none.
  final bool deriveStemDirections;

  /// Fill in accidentals where the file states none.
  ///
  /// A conforming file always states them, but exporters that write only
  /// pitches are common enough to be worth handling.
  final bool deriveAccidentals;

  /// Reads MusicXML source text.
  model.Score read(String source) =>
      readDocument(MusicXmlDocument.parse(source)).score;

  /// Reads MusicXML bytes, compressed or not.
  model.Score readBytes(List<int> bytes) =>
      readDocument(MusicXmlDocument.fromBytes(bytes)).score;

  /// Reads a parsed document, reporting anything that had to be worked around.
  MusicXmlReadResult readDocument(MusicXmlDocument document) {
    final warnings = <String>[];
    final source = document.toPartwise();
    final score = model.Score(version: source.version ?? '4.0');

    _readMetadata(source, score);
    score.defaults = _readDefaults(source.defaults);
    _readPartList(source.partList, score, warnings);

    for (final domPart in source.part) {
      final part = score.partById(domPart.id);
      if (part == null) {
        warnings.add(
          'part "${domPart.id}" has music but is not in the part list; '
          'it was skipped',
        );
        continue;
      }
      _PartReader(part, warnings, this).read(domPart);
    }

    return MusicXmlReadResult(score: score, warnings: warnings);
  }

  void _readMetadata(dom.ScorePartwise source, model.Score score) {
    final metadata = score.metadata;
    metadata
      ..workTitle = source.work?.workTitle
      ..workNumber = source.work?.workNumber
      ..movementTitle = source.movementTitle
      ..movementNumber = source.movementNumber;

    final identification = source.identification;
    if (identification != null) {
      for (final creator in identification.creator) {
        metadata.creators.add(
          model.Creator(type: creator.type ?? 'composer', name: creator.value),
        );
      }
      for (final rights in identification.rights) {
        metadata.rights.add(rights.value);
      }
      metadata.source = identification.source;
      final encoding = identification.encoding;
      if (encoding != null) {
        metadata
          ..software = encoding.softwareElements.firstOrNull
          ..encodingDate = encoding.encodingDateElements.firstOrNull;
      }
    }

    for (final credit in source.credit) {
      for (final words in credit.creditWordsElements) {
        if (words.value.trim().isNotEmpty) score.credits.add(words.value);
      }
    }
  }

  model.ScoreDefaults _readDefaults(dom.Defaults? defaults) {
    if (defaults == null) return const model.ScoreDefaults();
    final scaling = defaults.scaling;
    final page = defaults.pageLayout;
    final system = defaults.systemLayout;
    return model.ScoreDefaults(
      scaling: scaling == null
          ? const model.Scaling()
          : model.Scaling(
              millimeters: scaling.millimeters,
              tenths: scaling.tenths,
            ),
      pageLayout: model.PageLayout(
        pageWidth: page?.pageWidth,
        pageHeight: page?.pageHeight,
        oddMarginLeft: _margin(page, odd: true)?.leftMargin,
        oddMarginRight: _margin(page, odd: true)?.rightMargin,
        oddMarginTop: _margin(page, odd: true)?.topMargin,
        oddMarginBottom: _margin(page, odd: true)?.bottomMargin,
        evenMarginLeft: _margin(page, odd: false)?.leftMargin,
        evenMarginRight: _margin(page, odd: false)?.rightMargin,
        evenMarginTop: _margin(page, odd: false)?.topMargin,
        evenMarginBottom: _margin(page, odd: false)?.bottomMargin,
      ),
      systemLayout: model.SystemLayoutDefaults(
        leftMargin: system?.systemMargins?.leftMargin,
        rightMargin: system?.systemMargins?.rightMargin,
        systemDistance: system?.systemDistance,
        topSystemDistance: system?.topSystemDistance,
      ),
      staffDistance: defaults.staffLayout.firstOrNull?.staffDistance,
      musicFont: defaults.musicFont?.fontFamily,
      wordFont: defaults.wordFont?.fontFamily,
      lyricFont: defaults.lyricFont.firstOrNull?.fontFamily,
    );
  }

  dom.PageMargins? _margin(dom.PageLayout? layout, {required bool odd}) {
    final margins = layout?.pageMargins ?? const <dom.PageMargins>[];
    for (final margin in margins) {
      final type = margin.type;
      if (type == dom.MarginType.both) return margin;
      if (odd && type == dom.MarginType.odd) return margin;
      if (!odd && type == dom.MarginType.even) return margin;
    }
    return margins.firstOrNull;
  }

  void _readPartList(
    dom.PartList partList,
    model.Score score,
    List<String> warnings,
  ) {
    final openGroups = <String, _OpenGroup>{};
    for (final item in partList.items) {
      final group = item.partGroup;
      if (group != null) {
        final number = group.number ?? '1';
        if (group.type == dom.StartStop.start) {
          openGroups[number] = _OpenGroup(
            number: number,
            startPartIndex: score.parts.length,
            name: group.groupName?.value,
            abbreviation: group.groupAbbreviation?.value,
            symbol: _groupSymbol(group.groupSymbol?.value),
            barline: group.groupBarline?.value != dom.GroupBarlineValue.no,
          );
        } else {
          final open = openGroups.remove(number);
          if (open == null) {
            warnings.add('part group "$number" ends without starting');
            continue;
          }
          score.partGroups.add(
            model.PartGroup(
              number: open.number,
              startPartIndex: open.startPartIndex,
              endPartIndex: score.parts.length - 1,
              name: open.name,
              abbreviation: open.abbreviation,
              symbol: open.symbol,
              groupBarline: open.barline,
            ),
          );
        }
        continue;
      }

      final scorePart = item.scorePart;
      if (scorePart == null) continue;
      final part = model.Part(
        id: scorePart.id,
        name: scorePart.partNameElements.firstOrNull?.value ?? '',
        abbreviation: scorePart.partAbbreviationElements.firstOrNull?.value,
      );
      part.printName =
          scorePart.partNameElements.firstOrNull?.printObject != dom.YesNo.no;
      for (final instrument in scorePart.scoreInstrumentElements) {
        part.instruments.add(
          model.ScoreInstrument(
            id: instrument.id,
            name: instrument.instrumentName,
            abbreviation: instrument.instrumentAbbreviation,
            sound: instrument.instrumentSound,
          ),
        );
      }
      for (final midi in scorePart.midiInstrumentElements) {
        part.midiInstruments.add(
          model.MidiInstrument(
            id: midi.id,
            channel: midi.midiChannel,
            program: midi.midiProgram,
            unpitched: midi.midiUnpitched,
            volume: midi.volume,
            pan: midi.pan,
            elevation: midi.elevation,
            name: midi.midiName,
            bank: midi.midiBank,
          ),
        );
      }
      score.parts.add(part);
    }

    for (final open in openGroups.values) {
      warnings.add('part group "${open.number}" is never closed');
      score.partGroups.add(
        model.PartGroup(
          number: open.number,
          startPartIndex: open.startPartIndex,
          endPartIndex: score.parts.length - 1,
          name: open.name,
          abbreviation: open.abbreviation,
          symbol: open.symbol,
          groupBarline: open.barline,
        ),
      );
    }
  }

  static model.GroupSymbol _groupSymbol(dom.GroupSymbolValue? value) =>
      switch (value) {
        dom.GroupSymbolValue.brace => model.GroupSymbol.brace,
        dom.GroupSymbolValue.line => model.GroupSymbol.line,
        dom.GroupSymbolValue.bracket => model.GroupSymbol.bracket,
        dom.GroupSymbolValue.square => model.GroupSymbol.square,
        _ => model.GroupSymbol.none,
      };
}

class _OpenGroup {
  _OpenGroup({
    required this.number,
    required this.startPartIndex,
    required this.name,
    required this.abbreviation,
    required this.symbol,
    required this.barline,
  });

  final String number;
  final int startPartIndex;
  final String? name;
  final String? abbreviation;
  final model.GroupSymbol symbol;
  final bool barline;
}

/// Reads the measures of one part.
///
/// Kept separate from [MusicXmlReader] because a part carries a lot of running
/// state — the divisions currently in force, where the cursor is, which slurs
/// are open — and threading all of it through free functions would be worse
/// than holding it in one object for the length of one part.
class _PartReader {
  _PartReader(
    this.part,
    this.warnings,
    this.options,
  );

  final model.Part part;
  final List<String> warnings;
  final MusicXmlReader options;

  /// Divisions per quarter note, as most recently declared.
  int divisions = 1;

  /// Slurs, ties and tuplets waiting for their other end, keyed by kind,
  /// number and voice.
  final Map<String, _PendingSpanner> _pending = {};

  /// Ends waiting for their beginning, keyed the same way.
  ///
  /// A part is written a voice at a time, so a slur from a note in one voice
  /// to a note in another can be closed on the page before it is opened in the
  /// file: the slur that ends on the right hand's first note begins on a left
  /// hand note written further down the same measure. Such an end waits until
  /// the measure has been read out.
  final Map<String, model.MusicalEvent> _pendingEnds = {};

  /// Noteheads waiting to be tied to, keyed by voice and sounding pitch.
  final Map<String, _PendingTie> _pendingTies = {};

  void read(dom.ScorePartwisePart source) {
    for (final domMeasure in source.measure) {
      part.measures.add(_readMeasure(domMeasure));
    }
    _finishSpanners();
    _applyDerivedNotation();
  }

  model.Measure _readMeasure(dom.ScorePartwisePartMeasure source) {
    final measure = model.Measure(
      number: source.number,
      implicit: source.implicit == dom.YesNo.yes,
      nonControlling: source.nonControlling == dom.YesNo.yes,
      width: source.width,
    );

    var cursor = model.Fraction.zero;
    var furthest = model.Fraction.zero;
    model.Chord? previousChord;
    var currentVoice = 1;
    var currentStaff = 1;

    for (final item in source.items) {
      final attributes = item.attributes;
      if (attributes != null) {
        measure.attributeChanges.add(
          model.AttributeChange(
            position: cursor,
            attributes: _readAttributes(attributes),
          ),
        );
        continue;
      }

      final note = item.note;
      if (note != null) {
        final read = _readNote(note, cursor, previousChord);
        if (read == null) continue;
        if (read.isChordMember) {
          // A <chord/> note joins the note before it rather than following it,
          // so the cursor stays where it was.
          continue;
        }
        measure.add(read.event);
        cursor = cursor + read.event.duration;
        if (cursor > furthest) furthest = cursor;
        previousChord = read.event is model.Chord
            ? read.event as model.Chord
            : null;
        currentVoice = read.event.voice;
        currentStaff = read.event.staff;
        continue;
      }

      final backup = item.backup;
      if (backup != null) {
        cursor = cursor - _duration(backup.duration);
        if (cursor.isNegative) {
          warnings.add(
            'measure ${source.number}: <backup> reaches before the start of '
            'the measure; clamped',
          );
          cursor = model.Fraction.zero;
        }
        previousChord = null;
        continue;
      }

      final forward = item.forward;
      if (forward != null) {
        cursor = cursor + _duration(forward.duration);
        if (cursor > furthest) furthest = cursor;
        currentVoice = _voiceNumber(forward.voice) ?? currentVoice;
        currentStaff = forward.staff ?? currentStaff;
        previousChord = null;
        continue;
      }

      final direction = item.direction;
      if (direction != null) {
        final event = _readDirection(
          direction,
          cursor,
          currentVoice,
          currentStaff,
        );
        if (event != null) measure.add(event);
        continue;
      }

      final harmony = item.harmony;
      if (harmony != null) {
        final event = _readHarmony(harmony, cursor, currentStaff);
        if (event != null) measure.add(event);
        continue;
      }

      final barline = item.barline;
      if (barline != null) {
        _readBarline(barline, measure);
        continue;
      }

      final print = item.print;
      if (print != null) {
        measure.printHint = model.PrintHint(
          newSystem: print.newSystem == dom.YesNo.yes,
          newPage: print.newPage == dom.YesNo.yes,
          blankPage: print.blankPage,
          pageNumber: print.pageNumber,
          staffSpacing: print.staffSpacing,
          systemDistance: print.systemLayout?.systemDistance,
          topSystemDistance: print.systemLayout?.topSystemDistance,
        );
        continue;
      }

      final sound = item.sound;
      if (sound != null) {
        measure.add(
          model.Direction(
            position: cursor,
            types: const [],
            voice: currentVoice,
            staff: currentStaff,
            sound: _readSound(sound),
          ),
        );
      }
    }

    _finishMeasureSpanners();
    return measure;
  }

  // ------------------------------------------------------------- attributes

  model.MeasureAttributes _readAttributes(dom.Attributes source) {
    final attributes = model.MeasureAttributes();

    final declaredDivisions = source.divisions;
    if (declaredDivisions != null && declaredDivisions > 0) {
      divisions = declaredDivisions.round();
      attributes.divisions = divisions;
    }
    attributes.staves = source.staves;
    attributes.instruments = source.instruments;

    for (final key in source.key) {
      final staff = key.number ?? model.allStaves;
      attributes.keys[staff] = _readKey(key);
    }
    for (final time in source.time) {
      attributes.time = _readTime(time);
      // A file may state a metre without showing it, which is how an excerpt
      // from the middle of a movement is written.
      attributes.printTime = time.printObject != dom.YesNo.no;
    }
    for (final clef in source.clef) {
      final staff = clef.number ?? 1;
      attributes.clefs[staff] = model.Clef(
        sign: _clefSign(clef.sign),
        line: clef.line ?? _defaultClefLine(clef.sign),
        octaveChange: clef.clefOctaveChange ?? 0,
      );
    }
    for (final transpose in source.transpose) {
      final staff = transpose.number ?? model.allStaves;
      attributes.transposes[staff] = model.Transpose(
        interval:
            model.Interval(
              transpose.diatonic ?? 0,
              transpose.chromatic.round(),
            ) +
            model.Interval.octaves(transpose.octaveChange ?? 0),
        doubled: transpose.doubleValue != null,
      );
    }
    for (final details in source.staffDetails) {
      final staff = details.number ?? model.allStaves;
      attributes.staffDetails[staff] = model.StaffDetails(
        staffLines: details.staffLines ?? 5,
        tunings: [
          for (final tuning in details.staffTuning)
            model.StaffTuning(
              line: tuning.line,
              step: tuning.tuningStep.xmlValue,
              octave: tuning.tuningOctave,
              alter: tuning.tuningAlter ?? 0,
            ),
        ],
        capo: details.capo,
        staffSize: details.staffSize?.value,
        showFrets: details.showFrets?.xmlValue,
        printObject: details.printObject != dom.YesNo.no,
        printSpacing: details.printSpacing != dom.YesNo.no,
        staffType: details.staffType?.xmlValue,
      );
    }
    for (final style in source.measureStyle) {
      attributes.measureStyles.add(
        model.MeasureStyle(
          staffNumber: style.number,
          multipleRest: style.multipleRest?.value,
          multipleRestUseSymbols:
              style.multipleRest?.useSymbols == dom.YesNo.yes,
          measureRepeatSlashes: style.measureRepeat?.slashes,
          measureRepeatType: style.measureRepeat?.type.xmlValue,
          beatRepeatSlashes: style.beatRepeat?.slashes,
          beatRepeatType: style.beatRepeat?.type.xmlValue,
          slashType: style.slash?.slashType?.xmlValue,
          slashStart: style.slash?.type.xmlValue,
        ),
      );
    }
    return attributes;
  }

  model.KeySignature _readKey(dom.Key source) {
    var fifths = 0;
    String? mode;
    for (final item in source.items) {
      if (item.fifths != null) fifths = item.fifths!;
      if (item.mode != null) mode = item.mode;
    }
    return model.KeySignature(fifths: fifths, mode: _mode(mode));
  }

  model.TimeSignature _readTime(dom.Time source) {
    final components = <model.TimeSignatureComponent>[];
    String? pendingBeats;
    for (final item in source.items) {
      if (item.beats != null) {
        pendingBeats = item.beats;
        continue;
      }
      final beatType = item.beatType;
      if (beatType != null && pendingBeats != null) {
        components.add(
          model.TimeSignatureComponent([
            for (final part in pendingBeats.split('+'))
              int.tryParse(part.trim()) ?? 4,
          ], int.tryParse(beatType.trim()) ?? 4),
        );
        pendingBeats = null;
      }
    }
    if (components.isEmpty) {
      // <senza-misura> and anything unreadable: treat the measure as free, but
      // give downstream code a length it can lay out.
      components.add(const model.TimeSignatureComponent([4], 4));
    }
    return model.TimeSignature(components, symbol: _timeSymbol(source.symbol));
  }

  // ------------------------------------------------------------------ notes

  _ReadNote? _readNote(
    dom.Note source,
    model.Fraction cursor,
    model.Chord? previousChord,
  ) {
    final isChordMember = source.chordElements.isNotEmpty;
    final grace = source.graceElements.firstOrNull;
    final voice = _voiceNumber(source.voiceElements.firstOrNull) ?? 1;
    final staff = source.staffElements.firstOrNull ?? 1;
    final restSource = source.restElements.firstOrNull;
    final durationValue = source.durationElements.firstOrNull;

    final rhythm = _rhythm(source, durationValue);

    if (restSource != null) {
      final rest = model.Rest(
        position: cursor,
        rhythm: rhythm,
        voice: voice,
        staff: staff,
        isMeasureRest: restSource.measure == dom.YesNo.yes,
        measureDuration: durationValue == null
            ? null
            : _duration(durationValue),
        cue: source.cueElements.isNotEmpty,
        fermatas: _readFermatas(source),
        printObject: source.printObject != dom.YesNo.no,
        printSpacing: source.printSpacing != dom.YesNo.no,
      );
      final step = restSource.displayStep;
      final octave = restSource.displayOctave;
      if (step != null && octave != null) {
        rest.displayPitch = model.Pitch(_step(step), octave);
      }
      return _ReadNote(rest, isChordMember: false);
    }

    final note = model.Note(
      pitch: _readPitch(source.pitchElements.firstOrNull),
      unpitchedPosition: _readUnpitched(source.unpitchedElements.firstOrNull),
      accidental: _readAccidental(source.accidentalElements.firstOrNull),
      notehead: model.NoteheadShape.fromXmlName(
        source.noteheadElements.firstOrNull?.value.xmlValue ?? '',
      ),
      filledNotehead: switch (source.noteheadElements.firstOrNull?.filled) {
        dom.YesNo.yes => true,
        dom.YesNo.no => false,
        null => null,
      },
      instrumentId: source.instrumentElements.firstOrNull?.id,
      color: source.color,
      // A file may write music that is played but not seen — the realisation
      // of a roll, a voice kept for playback — and says so on the note.
      printObject: source.printObject != dom.YesNo.no,
      printSpacing: source.printSpacing != dom.YesNo.no,
      // Which string and fret, for a note that will be written as tablature.
      // They belong to the notehead rather than to the chord: a chord on a
      // guitar is one number per string.
      string: [
        for (final notations in source.notationsElements)
          for (final item in notations.items)
            ...?item.technical?.stringElements,
      ].firstOrNull?.value,
      fret: [
        for (final notations in source.notationsElements)
          for (final item in notations.items) ...?item.technical?.fretElements,
      ].firstOrNull?.value,
    );

    for (final tie in source.tieElements) {
      note.tie = switch ((note.tie, tie.type)) {
        (model.TieState.start, dom.StartStop.stop) ||
        (model.TieState.stop, dom.StartStop.start) => model.TieState.stopStart,
        (_, dom.StartStop.start) => model.TieState.start,
        (_, dom.StartStop.stop) => model.TieState.stop,
      };
    }

    if (isChordMember) {
      if (previousChord == null) {
        warnings.add('a <chord/> note has no preceding note; it was dropped');
        return null;
      }
      previousChord.notes.add(note);
      _registerTies(previousChord, note, source, voice);
      return _ReadNote(previousChord, isChordMember: true);
    }

    final chord = model.Chord(
      position: cursor,
      notes: [note],
      rhythm: rhythm,
      voice: voice,
      staff: staff,
      stem: _stem(source.stemElements.firstOrNull?.value),
      beams: _readBeams(source),
      grace: grace == null
          ? null
          : model.GraceInfo(
              slash: grace.slash == dom.YesNo.yes,
              stealTimePrevious: grace.stealTimePrevious,
              stealTimeFollowing: grace.stealTimeFollowing,
              makeTime: grace.makeTime,
            ),
      cue: source.cueElements.isNotEmpty,
      lyrics: _readLyrics(source),
      fermatas: _readFermatas(source),
    );
    _readNotations(chord, source, voice);
    _registerTies(chord, note, source, voice);
    return _ReadNote(chord, isChordMember: false);
  }

  model.RhythmicDuration _rhythm(dom.Note source, double? durationValue) {
    final typeName = source.typeElements.firstOrNull?.value.xmlValue;
    final dots = source.dotElements.length;
    final modification = source.timeModificationElements.firstOrNull;
    final timeModification = modification == null
        ? model.TimeModification.none
        : model.TimeModification(
            actualNotes: modification.actualNotes,
            normalNotes: modification.normalNotes,
          );

    final declared = typeName == null
        ? null
        : model.NoteType.fromXmlName(typeName);
    if (declared != null) {
      return model.RhythmicDuration(
        declared,
        dots: dots,
        timeModification: timeModification,
      );
    }

    // No <type>: infer the written value from how long the note lasts. Files
    // exported for playback rather than for printing often look like this.
    if (durationValue != null) {
      final length = _duration(durationValue);
      final written = length / timeModification.ratio;
      final candidates = model.RhythmicDuration.decompose(written);
      if (candidates.isNotEmpty) {
        return candidates.first.copyWith(timeModification: timeModification);
      }
    }
    return model.RhythmicDuration(
      model.NoteType.quarter,
      dots: dots,
      timeModification: timeModification,
    );
  }

  model.Pitch? _readPitch(dom.Pitch? source) {
    if (source == null) return null;
    return model.Pitch(
      _step(source.step),
      source.octave,
      alter: source.alter ?? 0,
    );
  }

  model.Pitch? _readUnpitched(dom.Unpitched? source) {
    if (source == null) return null;
    final step = source.displayStep;
    final octave = source.displayOctave;
    if (step == null || octave == null) {
      return const model.Pitch(model.Step.b, 4);
    }
    return model.Pitch(_step(step), octave);
  }

  model.Accidental? _readAccidental(dom.Accidental? source) {
    if (source == null) return null;
    final type = model.AccidentalType.fromXmlName(source.value.xmlValue);
    if (type == null) return null;
    return model.Accidental(
      type,
      cautionary: source.cautionary == dom.YesNo.yes,
      editorial: source.editorial == dom.YesNo.yes,
      parentheses: source.parentheses == dom.YesNo.yes,
      bracket: source.bracket == dom.YesNo.yes,
    );
  }

  List<model.Beam> _readBeams(dom.Note source) => [
    for (final beam in source.beamElements)
      model.Beam(
        level: beam.number ?? 1,
        state: switch (beam.value) {
          dom.BeamValue.begin => model.BeamState.begin,
          dom.BeamValue.end => model.BeamState.end,
          dom.BeamValue.forwardHook => model.BeamState.forwardHook,
          dom.BeamValue.backwardHook => model.BeamState.backwardHook,
          dom.BeamValue.continueValue => model.BeamState.continueBeam,
        },
      ),
  ];

  List<model.Lyric> _readLyrics(dom.Note source) {
    final lyrics = <model.Lyric>[];
    for (final lyric in source.lyricElements) {
      final buffer = StringBuffer();
      var syllabic = model.Syllabic.single;
      String? elision;
      var extend = false;
      for (final item in lyric.items) {
        if (item.text != null) buffer.write(item.text!.value);
        if (item.syllabic != null) syllabic = _syllabic(item.syllabic!);
        if (item.elision != null) elision = item.elision!.value;
        if (item.extend != null) extend = true;
      }
      if (buffer.isEmpty && !extend) continue;
      lyrics.add(
        model.Lyric(
          text: buffer.toString(),
          number: int.tryParse(lyric.number ?? '') ?? lyrics.length + 1,
          syllabic: syllabic,
          name: lyric.name,
          extend: extend,
          elision: elision,
          placement: _placement(lyric.placement) ?? model.Placement.below,
        ),
      );
    }
    return lyrics;
  }

  List<model.Fermata> _readFermatas(dom.Note source) => [
    for (final notations in source.notationsElements)
      for (final item in notations.items)
        if (item.fermata != null)
          model.Fermata(
            shape: _fermataShape(item.fermata!.value),
            placement: item.fermata!.type == dom.UprightInverted.inverted
                ? model.Placement.below
                : model.Placement.above,
          ),
  ];

  void _readNotations(model.Chord chord, dom.Note source, int voice) {
    final articulations = <model.Articulation>[];
    final ornaments = <model.Ornament>[];
    final technicals = <model.Technical>[];

    for (final notations in source.notationsElements) {
      for (final item in notations.items) {
        final slur = item.slur;
        if (slur != null) {
          _handleSpanner(
            kind: 'slur',
            number: slur.number ?? 1,
            voice: voice,
            type: slur.type,
            event: chord,
            build: (start, end) => model.Slur(
              start: start,
              end: end,
              number: slur.number ?? 1,
              orientation: _orientation(slur.orientation),
              placement: _placement(slur.placement),
            ),
          );
        }

        final tuplet = item.tuplet;
        if (tuplet != null) {
          _handleSpanner(
            kind: 'tuplet',
            number: tuplet.number ?? 1,
            voice: voice,
            type: switch (tuplet.type) {
              dom.StartStop.start => dom.StartStopContinue.start,
              dom.StartStop.stop => dom.StartStopContinue.stop,
            },
            event: chord,
            build: (start, end) => model.Tuplet(
              start: start,
              end: end,
              number: tuplet.number ?? 1,
              actualNotes:
                  tuplet.tupletActual?.tupletNumber?.value ??
                  chord.rhythm.timeModification.actualNotes,
              normalNotes:
                  tuplet.tupletNormal?.tupletNumber?.value ??
                  chord.rhythm.timeModification.normalNotes,
              bracket: switch (tuplet.bracket) {
                dom.YesNo.yes => true,
                dom.YesNo.no => false,
                null => null,
              },
              showNumber: tuplet.showNumber != dom.ShowTuplet.none,
              placement: _placement(tuplet.placement) ?? model.Placement.above,
            ),
          );
        }

        final marks = item.articulations;
        if (marks != null) {
          for (final mark in marks.items) {
            final value = _articulation(mark.elementName);
            if (value != null) articulations.add(value);
          }
        }

        final ornamentGroup = item.ornaments;
        if (ornamentGroup != null) {
          for (final ornament in ornamentGroup.items) {
            final value = _ornament(ornament.elementName);
            if (value != null) ornaments.add(value);
            final tremolo = ornament.tremolo;
            if (tremolo != null) {
              chord.tremolo = model.Tremolo(
                marks: tremolo.value,
                kind: switch (tremolo.type) {
                  dom.TremoloType.start => model.TremoloKind.start,
                  dom.TremoloType.stop => model.TremoloKind.stop,
                  dom.TremoloType.unmeasured => model.TremoloKind.unmeasured,
                  dom.TremoloType.single || null => model.TremoloKind.single,
                },
              );
            }
          }
        }

        final technicalGroup = item.technical;
        if (technicalGroup != null) {
          for (final technical in technicalGroup.items) {
            final value = _technical(technical.elementName);
            if (value != null) technicals.add(value);
          }
        }

        if (item.arpeggiate != null) chord.arpeggiate = true;
        if (item.nonArpeggiate != null) chord.nonArpeggiate = true;
      }
    }

    chord.articulations = articulations;
    chord.ornaments = ornaments;
    chord.technicals = technicals;
  }

  /// Records a tie start, or joins one that is already open.
  ///
  /// Ties are matched on sounding pitch within a voice, which is what a reader
  /// does: the tie from a middle C goes to the next middle C in the same line,
  /// not to whatever note happens to come next.
  void _registerTies(
    model.Chord chord,
    model.Note note,
    dom.Note source,
    int voice,
  ) {
    final pitch = note.pitch;
    if (pitch == null) return;
    final key = '$voice:${pitch.midiNumber}';

    final startsTie =
        note.tie == model.TieState.start ||
        note.tie == model.TieState.stopStart;
    final stopsTie =
        note.tie == model.TieState.stop || note.tie == model.TieState.stopStart;
    final tied = [
      for (final notations in source.notationsElements)
        for (final item in notations.items)
          if (item.tied != null) item.tied!,
    ];
    final drawsTie = tied.isNotEmpty;

    if (stopsTie) {
      final open = _pendingTies.remove(key);
      if (open != null) {
        open.note.tied = drawsTie || open.drawsTie;
        note.tied = open.note.tied;
        part.spanners.add(
          model.Tie(
            start: open.chord,
            end: chord,
            startNoteIndex: open.chord.notes.indexOf(open.note),
            endNoteIndex: chord.notes.indexOf(note),
            // Which way the file bowed it, taken from either end: the side is
            // usually written on the note the tie starts from, but a file is
            // free to write it on the one it ends at.
            orientation: _orientation(
              open.orientation ?? tied.firstOrNull?.orientation,
            ),
            placement: _placement(
              open.placement ?? tied.firstOrNull?.placement,
            ),
          ),
        );
      } else {
        warnings.add('a tie ends on $pitch without starting');
      }
    }
    if (startsTie) {
      _pendingTies[key] = _PendingTie(
        chord,
        note,
        drawsTie,
        orientation: tied.firstOrNull?.orientation,
        placement: tied.firstOrNull?.placement,
      );
    }
  }

  void _handleSpanner({
    required String kind,
    required int number,
    required int voice,
    required dom.StartStopContinue type,
    required model.MusicalEvent event,
    required model.Spanner Function(
      model.MusicalEvent start,
      model.MusicalEvent end,
    )
    build,
  }) {
    // A slur's number tells it apart from the slurs it overlaps, and a slur
    // may run from one voice of an instrument to another — the two hands of a
    // piano are slurred together all the time — so the voice is only a
    // tie-breaker between two of the same number, never part of the identity.
    final exact = '$kind:$number:$voice';
    switch (type) {
      case dom.StartStopContinue.start:
        final waiting = _pendingEnds.remove(exact) ?? _looseEnd(kind, number);
        if (waiting != null) {
          part.spanners.add(build(event, waiting));
          return;
        }
        _pending[exact] = _PendingSpanner(event, build);
      case dom.StartStopContinue.stop:
        final open = _pending.remove(exact) ?? _looseOpen(kind, number);
        if (open == null) {
          // Held for a beginning still to be read out of a later voice of the
          // same measure; anything still waiting when the measure ends is an
          // end without a beginning.
          _pendingEnds[exact] = event;
          return;
        }
        part.spanners.add(open.build(open.start, event));
      case dom.StartStopContinue.continueValue:
        break;
    }
  }

  /// An end of this kind and number held from any voice of this measure.
  model.MusicalEvent? _looseEnd(String kind, int number) {
    final prefix = '$kind:$number:';
    for (final key in _pendingEnds.keys) {
      if (!key.startsWith(prefix)) continue;
      return _pendingEnds.remove(key);
    }
    return null;
  }

  /// An open spanner of this kind and number in any voice, longest open first.
  _PendingSpanner? _looseOpen(String kind, int number) {
    final prefix = '$kind:$number:';
    for (final key in _pending.keys) {
      if (!key.startsWith(prefix)) continue;
      return _pending.remove(key);
    }
    return null;
  }

  /// Reports the ends of the measure that never found a beginning.
  void _finishMeasureSpanners() {
    for (final key in _pendingEnds.keys) {
      warnings.add('a ${key.split(':').first} ends without starting');
    }
    _pendingEnds.clear();
  }

  void _finishSpanners() {
    for (final entry in _pending.entries) {
      warnings.add('${entry.key.split(':').first} starts but never ends');
    }
    _pending.clear();
    for (final open in _pendingTies.values) {
      warnings.add('a tie starts on ${open.note.pitch} but never ends');
      open.note.tie = model.TieState.none;
    }
    _pendingTies.clear();
  }

  // ---------------------------------------------------------------- harmony

  /// Reads a chord symbol.
  ///
  /// A `<harmony>` is a list of items rather than a record with fields, since
  /// MusicXML allows a numeral or a function in place of a root; only the
  /// spelled-out kind is carried into the model, and anything else is passed
  /// over rather than guessed at.
  model.Harmony? _readHarmony(
    dom.Harmony harmony,
    model.Fraction at,
    int staff,
  ) {
    dom.Root? root;
    dom.Kind? kind;
    dom.Bass? bass;
    for (final item in harmony.items) {
      root ??= item.root;
      kind ??= item.kind;
      bass ??= item.bass;
    }
    if (root == null) {
      warnings.add('a chord symbol without a root was left out');
      return null;
    }

    model.Pitch pitchOf(dom.Step step, double? alter) =>
        model.Pitch(_step(step), 4, alter: alter ?? 0);

    return model.Harmony(
      position: at,
      staff:
          harmony.items
              .map((item) => item.staff)
              .whereType<int>()
              .firstOrNull ??
          staff,
      root: pitchOf(root.rootStep.value, root.rootAlter?.value),
      kind: model.ChordKind.fromXmlName(kind?.value.xmlValue),
      text: kind?.text,
      bass: bass == null
          ? null
          : pitchOf(bass.bassStep.value, bass.bassAlter?.value),
    );
  }

  // ------------------------------------------------------------- directions

  model.Direction? _readDirection(
    dom.Direction source,
    model.Fraction cursor,
    int voice,
    int staff,
  ) {
    final types = <model.DirectionType>[];
    for (final directionType in source.directionType) {
      for (final item in directionType.items) {
        final mapped = _readDirectionType(item);
        if (mapped != null) types.add(mapped);
      }
    }
    final sound = source.sound;
    if (types.isEmpty && sound == null) return null;

    var position = cursor;
    final offset = source.offset;
    if (offset != null) position = position + _duration(offset.value);
    if (position.isNegative) position = model.Fraction.zero;

    return model.Direction(
      position: position,
      types: types,
      voice: _voiceNumber(source.voice) ?? voice,
      staff: source.staff ?? staff,
      placement: _placement(source.placement) ?? model.Placement.below,
      sound: sound == null ? null : _readSound(sound),
    );
  }

  model.DirectionType? _readDirectionType(dom.DirectionTypeItem item) {
    final dynamics = item.dynamics;
    if (dynamics != null) {
      final marks = <model.DynamicMark>[];
      String? other;
      for (final entry in dynamics.items) {
        final name = entry.elementName;
        if (name == 'other-dynamics') {
          other = entry.otherDynamics?.value;
          continue;
        }
        final mark = _dynamicMark(name);
        if (mark != null) marks.add(mark);
      }
      return model.DynamicsDirection(marks, otherText: other);
    }

    final words = item.words;
    if (words != null) {
      return model.WordsDirection(
        words.value,
        fontStyle: words.fontStyle?.xmlValue,
        fontWeight: words.fontWeight?.xmlValue,
        fontSize: double.tryParse(words.fontSize ?? ''),
      );
    }

    final wedge = item.wedge;
    if (wedge != null) {
      return model.WedgeDirection(
        switch (wedge.type) {
          dom.WedgeType.crescendo => model.WedgeType.crescendo,
          dom.WedgeType.diminuendo => model.WedgeType.diminuendo,
          dom.WedgeType.stop => model.WedgeType.stop,
          dom.WedgeType.continueValue => model.WedgeType.wedgeContinue,
        },
        number: wedge.number ?? 1,
        spread: wedge.spread,
      );
    }

    final metronome = item.metronome;
    if (metronome != null) {
      String? beatUnit;
      var beatUnitDots = 0;
      String? secondBeatUnit;
      var secondBeatUnitDots = 0;
      double? perMinute;
      for (final entry in metronome.items) {
        if (entry.beatUnit != null) {
          if (beatUnit == null) {
            beatUnit = entry.beatUnit!.xmlValue;
          } else {
            secondBeatUnit = entry.beatUnit!.xmlValue;
          }
        }
        if (entry.beatUnitDot != null) {
          if (secondBeatUnit == null) {
            beatUnitDots++;
          } else {
            secondBeatUnitDots++;
          }
        }
        if (entry.perMinute != null) {
          perMinute = double.tryParse(entry.perMinute!.value.trim());
        }
      }
      if (beatUnit == null) return null;
      return model.MetronomeDirection(
        beatUnit: beatUnit,
        beatUnitDots: beatUnitDots,
        perMinute: perMinute,
        secondBeatUnit: secondBeatUnit,
        secondBeatUnitDots: secondBeatUnitDots,
        parentheses: metronome.parentheses == dom.YesNo.yes,
      );
    }

    final octaveShift = item.octaveShift;
    if (octaveShift != null) {
      return model.OctaveShiftDirection(
        switch (octaveShift.type) {
          dom.UpDownStopContinue.up => model.OctaveShiftType.up,
          dom.UpDownStopContinue.down => model.OctaveShiftType.down,
          dom.UpDownStopContinue.stop => model.OctaveShiftType.stop,
          dom.UpDownStopContinue.continueValue =>
            model.OctaveShiftType.octaveContinue,
        },
        size: octaveShift.size ?? 8,
        number: octaveShift.number ?? 1,
      );
    }

    final pedal = item.pedal;
    if (pedal != null) {
      return model.PedalDirection(
        switch (pedal.type) {
          dom.PedalType.start => model.PedalType.start,
          dom.PedalType.stop => model.PedalType.stop,
          dom.PedalType.sostenuto => model.PedalType.sostenuto,
          dom.PedalType.change => model.PedalType.change,
          dom.PedalType.continueValue => model.PedalType.pedalContinue,
          dom.PedalType.discontinue => model.PedalType.discontinue,
          dom.PedalType.resume => model.PedalType.resume,
        },
        line: pedal.line == dom.YesNo.yes,
        sign: pedal.sign != dom.YesNo.no,
      );
    }

    final rehearsal = item.rehearsal;
    if (rehearsal != null) {
      return model.RehearsalDirection(
        rehearsal.value,
        enclosure: rehearsal.enclosure?.xmlValue ?? 'square',
      );
    }

    if (item.segno != null) return const model.SegnoDirection();
    if (item.coda != null) return const model.CodaDirection();

    final name = item.elementName;
    return name == null ? null : model.UnknownDirection(name);
  }

  model.SoundInfo _readSound(dom.Sound source) => model.SoundInfo(
    tempo: source.tempo,
    dynamics: source.dynamics,
    dacapo: source.dacapo == dom.YesNo.yes,
    segno: source.segno,
    dalsegno: source.dalsegno,
    coda: source.coda,
    tocoda: source.tocoda,
    fine: source.fine,
    forwardRepeat: source.forwardRepeat == dom.YesNo.yes,
    pizzicato: switch (source.pizzicato) {
      dom.YesNo.yes => true,
      dom.YesNo.no => false,
      null => null,
    },
  );

  // --------------------------------------------------------------- barlines

  void _readBarline(dom.Barline source, model.Measure measure) {
    final location = switch (source.location) {
      dom.RightLeftMiddle.left => model.BarlineLocation.left,
      dom.RightLeftMiddle.middle => model.BarlineLocation.middle,
      dom.RightLeftMiddle.right || null => model.BarlineLocation.right,
    };
    final barline = model.Barline(
      location: location,
      style: _barStyle(source.barStyle?.value),
      segno: source.segno != null,
      coda: source.coda != null,
    );

    final repeat = source.repeat;
    if (repeat != null) {
      barline.repeat = model.Repeat(
        direction: repeat.direction == dom.BackwardForward.forward
            ? model.RepeatDirection.forward
            : model.RepeatDirection.backward,
        times: repeat.times,
        winged: repeat.winged?.xmlValue,
      );
      if (source.barStyle == null) {
        barline.style = repeat.direction == dom.BackwardForward.forward
            ? model.BarStyle.heavyLight
            : model.BarStyle.lightHeavy;
      }
    }

    final ending = source.ending;
    if (ending != null) {
      barline.ending = model.Ending(
        numbers: [
          for (final part in ending.number.split(','))
            if (int.tryParse(part.trim()) != null) int.parse(part.trim()),
        ],
        type: switch (ending.type) {
          dom.StartStopDiscontinue.start => model.EndingType.start,
          dom.StartStopDiscontinue.stop => model.EndingType.stop,
          dom.StartStopDiscontinue.discontinue => model.EndingType.discontinue,
        },
        text: ending.value.isEmpty ? null : ending.value,
      );
    }

    barline.fermatas = [
      for (final fermata in source.fermata)
        model.Fermata(
          shape: _fermataShape(fermata.value),
          placement: fermata.type == dom.UprightInverted.inverted
              ? model.Placement.below
              : model.Placement.above,
        ),
    ];

    switch (location) {
      case model.BarlineLocation.left:
        measure.leftBarline = barline;
      case model.BarlineLocation.right:
      case model.BarlineLocation.middle:
        measure.rightBarline = barline;
    }
  }

  // ------------------------------------------------------------- derivation

  /// Fills in the notation a file left implicit.
  void _applyDerivedNotation() {
    final contexts = part.contextsPerMeasure();
    for (var i = 0; i < part.measures.length; i++) {
      final measure = part.measures[i];
      final context = contexts[i];
      if (options.deriveAccidentals) {
        model.AccidentalResolver.applyTo(measure, context: context);
      }
      if (options.deriveBeams) {
        model.Beaming.applyTo(measure, time: context.time);
      }
      if (options.deriveStemDirections) {
        for (var staff = 1; staff <= context.staffCount; staff++) {
          final needsStems = measure.events.any(
            (event) =>
                event is model.Chord &&
                event.staff == staff &&
                event.stem == model.StemDirection.none,
          );
          if (!needsStems) continue;
          model.Beaming.applyStemDirections(
            measure,
            clef: context.clefFor(staff),
            staff: staff,
          );
        }
      }
    }
  }

  // ------------------------------------------------------------- conversion

  /// Converts a duration in divisions to whole notes.
  model.Fraction _duration(double durationInDivisions) {
    // Divisions can be fractional in principle; scaling by a thousand keeps
    // the arithmetic exact for anything a file actually contains.
    const scale = 1000;
    return model.Fraction(
      (durationInDivisions * scale).round(),
      divisions * 4 * scale,
    );
  }

  int? _voiceNumber(String? voice) =>
      voice == null ? null : int.tryParse(voice.trim());
}

class _ReadNote {
  _ReadNote(
    this.event, {
    required this.isChordMember,
  });

  final model.MusicalEvent event;

  /// True when the note joined the chord before it instead of starting a new
  /// event.
  final bool isChordMember;
}

class _PendingSpanner {
  _PendingSpanner(
    this.start,
    this.build,
  );

  final model.MusicalEvent start;
  final model.Spanner Function(model.MusicalEvent, model.MusicalEvent) build;
}

class _PendingTie {
  _PendingTie(
    this.chord,
    this.note,
    this.drawsTie, {
    this.orientation,
    this.placement,
  });

  final model.Chord chord;
  final model.Note note;
  final bool drawsTie;

  /// Which way the file bowed the tie, written on the note it starts from.
  final dom.OverUnder? orientation;
  final dom.AboveBelow? placement;
}

// ------------------------------------------------------------- enum mapping

model.Step _step(dom.Step step) => switch (step) {
  dom.Step.a => model.Step.a,
  dom.Step.b => model.Step.b,
  dom.Step.c => model.Step.c,
  dom.Step.d => model.Step.d,
  dom.Step.e => model.Step.e,
  dom.Step.f => model.Step.f,
  dom.Step.g => model.Step.g,
};

model.Mode _mode(String? mode) => switch (mode?.toLowerCase()) {
  'minor' => model.Mode.minor,
  'dorian' => model.Mode.dorian,
  'phrygian' => model.Mode.phrygian,
  'lydian' => model.Mode.lydian,
  'mixolydian' => model.Mode.mixolydian,
  'aeolian' => model.Mode.aeolian,
  'ionian' => model.Mode.ionian,
  'locrian' => model.Mode.locrian,
  'none' => model.Mode.none,
  _ => model.Mode.major,
};

model.ClefSign _clefSign(dom.ClefSign sign) => switch (sign) {
  dom.ClefSign.g => model.ClefSign.g,
  dom.ClefSign.f => model.ClefSign.f,
  dom.ClefSign.c => model.ClefSign.c,
  dom.ClefSign.percussion => model.ClefSign.percussion,
  dom.ClefSign.tAB => model.ClefSign.tab,
  dom.ClefSign.jianpu => model.ClefSign.jianpu,
  dom.ClefSign.none => model.ClefSign.none,
};

int _defaultClefLine(dom.ClefSign sign) => switch (sign) {
  dom.ClefSign.g => 2,
  dom.ClefSign.f => 4,
  dom.ClefSign.c => 3,
  _ => 3,
};

model.StemDirection _stem(dom.StemValue? value) => switch (value) {
  dom.StemValue.up => model.StemDirection.up,
  dom.StemValue.down => model.StemDirection.down,
  dom.StemValue.doubleValue => model.StemDirection.double,
  dom.StemValue.none => model.StemDirection.none,
  null => model.StemDirection.none,
};

model.Placement? _placement(dom.AboveBelow? placement) => switch (placement) {
  dom.AboveBelow.above => model.Placement.above,
  dom.AboveBelow.below => model.Placement.below,
  null => null,
};

model.LineOrientation _orientation(dom.OverUnder? orientation) =>
    switch (orientation) {
      dom.OverUnder.over => model.LineOrientation.over,
      dom.OverUnder.under => model.LineOrientation.under,
      null => model.LineOrientation.auto,
    };

model.Syllabic _syllabic(dom.Syllabic syllabic) => switch (syllabic) {
  dom.Syllabic.single => model.Syllabic.single,
  dom.Syllabic.begin => model.Syllabic.begin,
  dom.Syllabic.end => model.Syllabic.end,
  dom.Syllabic.middle => model.Syllabic.middle,
};

model.TimeSymbol _timeSymbol(dom.TimeSymbol? symbol) => switch (symbol) {
  dom.TimeSymbol.common => model.TimeSymbol.common,
  dom.TimeSymbol.cut => model.TimeSymbol.cut,
  dom.TimeSymbol.singleNumber => model.TimeSymbol.singleNumber,
  dom.TimeSymbol.note => model.TimeSymbol.note,
  dom.TimeSymbol.dottedNote => model.TimeSymbol.dottedNote,
  dom.TimeSymbol.normal || null => model.TimeSymbol.normal,
};

model.BarStyle _barStyle(dom.BarStyle? style) => switch (style) {
  dom.BarStyle.dotted => model.BarStyle.dotted,
  dom.BarStyle.dashed => model.BarStyle.dashed,
  dom.BarStyle.heavy => model.BarStyle.heavy,
  dom.BarStyle.lightLight => model.BarStyle.lightLight,
  dom.BarStyle.lightHeavy => model.BarStyle.lightHeavy,
  dom.BarStyle.heavyLight => model.BarStyle.heavyLight,
  dom.BarStyle.heavyHeavy => model.BarStyle.heavyHeavy,
  dom.BarStyle.tick => model.BarStyle.tick,
  dom.BarStyle.short => model.BarStyle.short,
  dom.BarStyle.none => model.BarStyle.none,
  dom.BarStyle.regular || null => model.BarStyle.regular,
};

model.FermataShape _fermataShape(dom.FermataShape shape) => switch (shape) {
  dom.FermataShape.angled => model.FermataShape.angled,
  dom.FermataShape.square => model.FermataShape.square,
  dom.FermataShape.doubleAngled => model.FermataShape.doubleAngled,
  dom.FermataShape.doubleSquare => model.FermataShape.doubleSquare,
  dom.FermataShape.doubleDot => model.FermataShape.doubleDot,
  dom.FermataShape.halfCurve => model.FermataShape.halfCurve,
  dom.FermataShape.curlew => model.FermataShape.curlew,
  dom.FermataShape.normal ||
  dom.FermataShape.value => model.FermataShape.normal,
};

model.DynamicMark? _dynamicMark(String? name) {
  if (name == null) return null;
  for (final mark in model.DynamicMark.values) {
    if (mark.name == name) return mark;
  }
  return null;
}

model.Articulation? _articulation(String? name) => switch (name) {
  'accent' => model.Articulation.accent,
  'strong-accent' => model.Articulation.strongAccent,
  'staccato' => model.Articulation.staccato,
  'tenuto' => model.Articulation.tenuto,
  'detached-legato' => model.Articulation.detachedLegato,
  'staccatissimo' => model.Articulation.staccatissimo,
  'spiccato' => model.Articulation.spiccato,
  'scoop' => model.Articulation.scoop,
  'plop' => model.Articulation.plop,
  'doit' => model.Articulation.doit,
  'falloff' => model.Articulation.falloff,
  'breath-mark' => model.Articulation.breathMark,
  'caesura' => model.Articulation.caesura,
  'stress' => model.Articulation.stress,
  'unstress' => model.Articulation.unstress,
  'soft-accent' => model.Articulation.softAccent,
  'other-articulation' => model.Articulation.otherArticulation,
  _ => null,
};

model.Ornament? _ornament(String? name) => switch (name) {
  'trill-mark' => model.Ornament.trillMark,
  'turn' => model.Ornament.turn,
  'delayed-turn' => model.Ornament.delayedTurn,
  'inverted-turn' => model.Ornament.invertedTurn,
  'delayed-inverted-turn' => model.Ornament.delayedInvertedTurn,
  'vertical-turn' => model.Ornament.verticalTurn,
  'inverted-vertical-turn' => model.Ornament.invertedVerticalTurn,
  'shake' => model.Ornament.shake,
  'wavy-line' => model.Ornament.wavyLine,
  'mordent' => model.Ornament.mordent,
  'inverted-mordent' => model.Ornament.invertedMordent,
  'schleifer' => model.Ornament.schleifer,
  'tremolo' => model.Ornament.tremolo,
  'haydn' => model.Ornament.haydn,
  'other-ornament' => model.Ornament.otherOrnament,
  _ => null,
};

model.Technical? _technical(String? name) => switch (name) {
  'up-bow' => model.Technical.upBow,
  'down-bow' => model.Technical.downBow,
  'harmonic' => model.Technical.harmonic,
  'open-string' => model.Technical.openString,
  'thumb-position' => model.Technical.thumbPosition,
  'fingering' => model.Technical.fingering,
  'pluck' => model.Technical.pluck,
  'double-tongue' => model.Technical.doubleTongue,
  'triple-tongue' => model.Technical.tripleTongue,
  'stopped' => model.Technical.stopped,
  'snap-pizzicato' => model.Technical.snapPizzicato,
  'fret' => model.Technical.fret,
  'string' => model.Technical.string,
  'hammer-on' => model.Technical.hammerOn,
  'pull-off' => model.Technical.pullOff,
  'bend' => model.Technical.bend,
  'tap' => model.Technical.tap,
  'heel' => model.Technical.heel,
  'toe' => model.Technical.toe,
  'fingernails' => model.Technical.fingernails,
  'hole' => model.Technical.hole,
  'arrow' => model.Technical.arrow,
  'handbell' => model.Technical.handbell,
  'brass-bend' => model.Technical.brassBend,
  'flip' => model.Technical.flip,
  'smear' => model.Technical.smear,
  'open' => model.Technical.open,
  'half-muted' => model.Technical.halfMuted,
  'harmon-mute' => model.Technical.harmonMute,
  'golpe' => model.Technical.golpe,
  'other-technical' => model.Technical.otherTechnical,
  _ => null,
};
