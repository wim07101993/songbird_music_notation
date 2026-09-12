// dart format off
//
// GENERATED FILE - do not edit by hand.
//
// Regenerate with:
//   dart run tool/generate_dom.dart
//
// Source: the MusicXML 4.0 XSD, tool/musicxml.xsd.
//
// Every complex type in the schema becomes a class that can read
// itself from an XmlElement and write itself back. The classes
// mirror the schema exactly, so a document read and written
// unchanged comes back the same; the musical meaning is added by
// the mapping layer, not here.

// ignore_for_file: unnecessary_this, lines_longer_than_80_chars

import 'package:xml/xml.dart';

import 'enums.g.dart';
import 'xml_support.dart';

/// The accidental type represents actual notated accidentals. Editorial and
/// cautionary indications are indicated by attributes. Values for these
/// attributes are "no" if not present. Specific graphic display such as
/// parentheses, brackets, and size are controlled by the level-display
/// attribute group.
class Accidental {
  Accidental({
    required this.value,
    this.cautionary,
    this.editorial,
    this.parentheses,
    this.bracket,
    this.size,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Accidental.fromXml(XmlElement element) =>
      Accidental(
        value: xmlRequiredValue(AccidentalValue.parse(element.innerText), 'value', element),
        cautionary: YesNo.parse(element.getAttribute('cautionary')),
        editorial: YesNo.parse(element.getAttribute('editorial')),
        parentheses: YesNo.parse(element.getAttribute('parentheses')),
        bracket: YesNo.parse(element.getAttribute('bracket')),
        size: SymbolSize.parse(element.getAttribute('size')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  AccidentalValue value;

  YesNo? cautionary;

  YesNo? editorial;

  YesNo? parentheses;

  YesNo? bracket;

  SymbolSize? size;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (cautionary != null) {
      node.setAttribute('cautionary', cautionary!.xmlValue);
    }
    if (editorial != null) {
      node.setAttribute('editorial', editorial!.xmlValue);
    }
    if (parentheses != null) {
      node.setAttribute('parentheses', parentheses!.xmlValue);
    }
    if (bracket != null) {
      node.setAttribute('bracket', bracket!.xmlValue);
    }
    if (size != null) {
      node.setAttribute('size', size!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// An accidental-mark can be used as a separate notation or as part of an
/// ornament. When used in an ornament, position and placement are relative to
/// the ornament, not relative to the note.
class AccidentalMark {
  AccidentalMark({
    required this.value,
    this.parentheses,
    this.bracket,
    this.size,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.smufl,
    this.id,
  });

  /// Reads an instance from [element].
  factory AccidentalMark.fromXml(XmlElement element) =>
      AccidentalMark(
        value: xmlRequiredValue(AccidentalValue.parse(element.innerText), 'value', element),
        parentheses: YesNo.parse(element.getAttribute('parentheses')),
        bracket: YesNo.parse(element.getAttribute('bracket')),
        size: SymbolSize.parse(element.getAttribute('size')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        smufl: element.getAttribute('smufl'),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  AccidentalValue value;

  YesNo? parentheses;

  YesNo? bracket;

  SymbolSize? size;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  String? smufl;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (parentheses != null) {
      node.setAttribute('parentheses', parentheses!.xmlValue);
    }
    if (bracket != null) {
      node.setAttribute('bracket', bracket!.xmlValue);
    }
    if (size != null) {
      node.setAttribute('size', size!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The accidental-text type represents an element with an accidental value
/// and text-formatting attributes.
class AccidentalText {
  AccidentalText({
    required this.value,
    this.justify,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.underline,
    this.overline,
    this.lineThrough,
    this.rotation,
    this.letterSpacing,
    this.lineHeight,
    this.xmlLang,
    this.xmlSpace,
    this.dir,
    this.enclosure,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory AccidentalText.fromXml(XmlElement element) =>
      AccidentalText(
        value: xmlRequiredValue(AccidentalValue.parse(element.innerText), 'value', element),
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        underline: xmlInt(element.getAttribute('underline')),
        overline: xmlInt(element.getAttribute('overline')),
        lineThrough: xmlInt(element.getAttribute('line-through')),
        rotation: xmlDouble(element.getAttribute('rotation')),
        letterSpacing: element.getAttribute('letter-spacing'),
        lineHeight: element.getAttribute('line-height'),
        xmlLang: element.getAttribute('xml:lang'),
        xmlSpace: element.getAttribute('xml:space'),
        dir: TextDirection.parse(element.getAttribute('dir')),
        enclosure: EnclosureShape.parse(element.getAttribute('enclosure')),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  AccidentalValue value;

  LeftCenterRight? justify;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  int? underline;

  int? overline;

  int? lineThrough;

  double? rotation;

  String? letterSpacing;

  String? lineHeight;

  /// The `xml:lang` attribute.
  String? xmlLang;

  /// The `xml:space` attribute.
  String? xmlSpace;

  TextDirection? dir;

  EnclosureShape? enclosure;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (underline != null) {
      node.setAttribute('underline', xmlNumberText(underline!));
    }
    if (overline != null) {
      node.setAttribute('overline', xmlNumberText(overline!));
    }
    if (lineThrough != null) {
      node.setAttribute('line-through', xmlNumberText(lineThrough!));
    }
    if (rotation != null) {
      node.setAttribute('rotation', xmlNumberText(rotation!));
    }
    if (letterSpacing != null) {
      node.setAttribute('letter-spacing', letterSpacing!);
    }
    if (lineHeight != null) {
      node.setAttribute('line-height', lineHeight!);
    }
    if (xmlLang != null) {
      node.setAttribute('xml:lang', xmlLang!);
    }
    if (xmlSpace != null) {
      node.setAttribute('xml:space', xmlSpace!);
    }
    if (dir != null) {
      node.setAttribute('dir', dir!.xmlValue);
    }
    if (enclosure != null) {
      node.setAttribute('enclosure', enclosure!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The accord type represents the tuning of a single string in the scordatura
/// element. It uses the same group of elements as the staff-tuning element.
/// Strings are numbered from high to low.
class Accord {
  Accord({
    required this.tuningStep,
    this.tuningAlter,
    required this.tuningOctave,
    this.string,
  });

  /// Reads an instance from [element].
  factory Accord.fromXml(XmlElement element) =>
      Accord(
        tuningStep: xmlRequiredValue(Step.parse(xmlElementText(element, 'tuning-step')), 'tuning-step', element),
        tuningAlter: xmlDouble(xmlElementText(element, 'tuning-alter')),
        tuningOctave: xmlInt(xmlElementText(element, 'tuning-octave')) ?? 0,
        string: xmlInt(element.getAttribute('string')),
      );

  /// The tuning-step element is represented like the step element, with a
  /// different name to reflect its different function in string tuning.
  Step tuningStep;

  /// The tuning-alter element is represented like the alter element, with a
  /// different name to reflect its different function in string tuning.
  double? tuningAlter;

  /// The tuning-octave element is represented like the octave element, with a
  /// different name to reflect its different function in string tuning.
  int tuningOctave;

  int? string;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (string != null) {
      node.setAttribute('string', xmlNumberText(string!));
    }
    node.children.add(xmlTextElement('tuning-step', tuningStep.xmlValue));
    if (tuningAlter != null) {
      node.children.add(xmlTextElement('tuning-alter', xmlNumberText(tuningAlter!)));
    }
    node.children.add(xmlTextElement('tuning-octave', xmlNumberText(tuningOctave)));
    return node;
  }
}

/// The accordion-registration type is used for accordion registration
/// symbols. These are circular symbols divided horizontally into high,
/// middle, and low sections that correspond to 4', 8', and 16' pipes. Each
/// accordion-high, accordion-middle, and accordion-low element represents the
/// presence of one or more dots in the registration diagram. An
/// accordion-registration element needs to have at least one of the child
/// elements present.
class AccordionRegistration {
  AccordionRegistration({
    this.accordionHigh,
    this.accordionMiddle,
    this.accordionLow,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
  });

  /// Reads an instance from [element].
  factory AccordionRegistration.fromXml(XmlElement element) =>
      AccordionRegistration(
        accordionHigh: switch (xmlElement(element, 'accordion-high')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        accordionMiddle: xmlInt(xmlElementText(element, 'accordion-middle')),
        accordionLow: switch (xmlElement(element, 'accordion-low')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  /// The accordion-high element indicates the presence of a dot in the high
  /// (4') section of the registration symbol. This element is omitted if no
  /// dot is present.
  Empty? accordionHigh;

  /// The accordion-middle element indicates the presence of 1 to 3 dots in
  /// the middle (8') section of the registration symbol. This element is
  /// omitted if no dots are present.
  int? accordionMiddle;

  /// The accordion-low element indicates the presence of a dot in the low
  /// (16') section of the registration symbol. This element is omitted if no
  /// dot is present.
  Empty? accordionLow;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (accordionHigh != null) {
      node.children.add(accordionHigh!.toXml('accordion-high'));
    }
    if (accordionMiddle != null) {
      node.children.add(xmlTextElement('accordion-middle', xmlNumberText(accordionMiddle!)));
    }
    if (accordionLow != null) {
      node.children.add(accordionLow!.toXml('accordion-low'));
    }
    return node;
  }
}

/// The appearance type controls general graphical settings for the music's
/// final form appearance on a printed page of display. This includes support
/// for line widths, definitions for note sizes, and standard distances
/// between notation elements, plus an extension element for other aspects of
/// appearance.
class Appearance {
  Appearance({
    List<LineWidth>? lineWidth,
    List<NoteSize>? noteSize,
    List<Distance>? distance,
    List<Glyph>? glyph,
    List<OtherAppearance>? otherAppearance,
  })  : lineWidth = lineWidth ?? <LineWidth>[],
        noteSize = noteSize ?? <NoteSize>[],
        distance = distance ?? <Distance>[],
        glyph = glyph ?? <Glyph>[],
        otherAppearance = otherAppearance ?? <OtherAppearance>[];

  /// Reads an instance from [element].
  factory Appearance.fromXml(XmlElement element) =>
      Appearance(
        lineWidth: xmlElements(element, 'line-width')
            .map(LineWidth.fromXml)
            .toList(),
        noteSize: xmlElements(element, 'note-size')
            .map(NoteSize.fromXml)
            .toList(),
        distance: xmlElements(element, 'distance')
            .map(Distance.fromXml)
            .toList(),
        glyph: xmlElements(element, 'glyph')
            .map(Glyph.fromXml)
            .toList(),
        otherAppearance: xmlElements(element, 'other-appearance')
            .map(OtherAppearance.fromXml)
            .toList(),
      );

  List<LineWidth> lineWidth;

  List<NoteSize> noteSize;

  List<Distance> distance;

  List<Glyph> glyph;

  List<OtherAppearance> otherAppearance;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in lineWidth) {
      node.children.add(item.toXml('line-width'));
    }
    for (final item in noteSize) {
      node.children.add(item.toXml('note-size'));
    }
    for (final item in distance) {
      node.children.add(item.toXml('distance'));
    }
    for (final item in glyph) {
      node.children.add(item.toXml('glyph'));
    }
    for (final item in otherAppearance) {
      node.children.add(item.toXml('other-appearance'));
    }
    return node;
  }
}

/// The arpeggiate type indicates that this note is part of an arpeggiated
/// chord. The number attribute can be used to distinguish between two
/// simultaneous chords arpeggiated separately (different numbers) or together
/// (same number). The direction attribute is used if there is an arrow on the
/// arpeggio sign. By default, arpeggios go from the lowest to highest note.
/// The length of the sign can be determined from the position attributes for
/// the arpeggiate elements used with the top and bottom notes of the
/// arpeggiated chord. If the unbroken attribute is set to yes, it indicates
/// that the arpeggio continues onto another staff within the part. This
/// serves as a hint to applications and is not required for cross-staff
/// arpeggios.
class Arpeggiate {
  Arpeggiate({
    this.number,
    this.direction,
    this.unbroken,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.placement,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Arpeggiate.fromXml(XmlElement element) =>
      Arpeggiate(
        number: xmlInt(element.getAttribute('number')),
        direction: UpDown.parse(element.getAttribute('direction')),
        unbroken: YesNo.parse(element.getAttribute('unbroken')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  int? number;

  UpDown? direction;

  YesNo? unbroken;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  AboveBelow? placement;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (direction != null) {
      node.setAttribute('direction', direction!.xmlValue);
    }
    if (unbroken != null) {
      node.setAttribute('unbroken', unbroken!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The arrow element represents an arrow used for a musical technical
/// indication. It can represent both Unicode and SMuFL arrows. The presence
/// of an arrowhead element indicates that only the arrowhead is displayed,
/// not the arrow stem. The smufl attribute distinguishes different SMuFL
/// glyphs that have an arrow appearance such as arrowBlackUp, guitarStrumUp,
/// or handbellsSwingUp. The specified glyph should match the descriptive
/// representation.
class Arrow {
  Arrow({
    this.arrowDirection,
    this.arrowStyle,
    this.arrowhead,
    this.circularArrow,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Arrow.fromXml(XmlElement element) =>
      Arrow(
        arrowDirection: ArrowDirection.parse(xmlElementText(element, 'arrow-direction')),
        arrowStyle: ArrowStyle.parse(xmlElementText(element, 'arrow-style')),
        arrowhead: switch (xmlElement(element, 'arrowhead')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        circularArrow: CircularArrow.parse(xmlElementText(element, 'circular-arrow')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        smufl: element.getAttribute('smufl'),
      );

  ArrowDirection? arrowDirection;

  ArrowStyle? arrowStyle;

  Empty? arrowhead;

  CircularArrow? circularArrow;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    if (arrowDirection != null) {
      node.children.add(xmlTextElement('arrow-direction', arrowDirection!.xmlValue));
    }
    if (arrowStyle != null) {
      node.children.add(xmlTextElement('arrow-style', arrowStyle!.xmlValue));
    }
    if (arrowhead != null) {
      node.children.add(arrowhead!.toXml('arrowhead'));
    }
    if (circularArrow != null) {
      node.children.add(xmlTextElement('circular-arrow', circularArrow!.xmlValue));
    }
    return node;
  }
}

/// Articulations and accents are grouped together here.
class Articulations {
  Articulations({
    this.id,
    List<ArticulationsItem>? items,
  })  : items = items ?? <ArticulationsItem>[];

  /// Reads an instance from [element].
  factory Articulations.fromXml(XmlElement element) =>
      Articulations(
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(ArticulationsItem.tryFromXml)
            .whereType<ArticulationsItem>()
            .toList(),
      );

  String? id;

  /// The element content, in document order.
  List<ArticulationsItem> items;

  /// Every `accent` child, in document order.
  List<EmptyPlacement> get accentElements => [
    for (final item in items)
      if (item.accent != null) item.accent!,
  ];

  /// Every `strong-accent` child, in document order.
  List<StrongAccent> get strongAccentElements => [
    for (final item in items)
      if (item.strongAccent != null) item.strongAccent!,
  ];

  /// Every `staccato` child, in document order.
  List<EmptyPlacement> get staccatoElements => [
    for (final item in items)
      if (item.staccato != null) item.staccato!,
  ];

  /// Every `tenuto` child, in document order.
  List<EmptyPlacement> get tenutoElements => [
    for (final item in items)
      if (item.tenuto != null) item.tenuto!,
  ];

  /// Every `detached-legato` child, in document order.
  List<EmptyPlacement> get detachedLegatoElements => [
    for (final item in items)
      if (item.detachedLegato != null) item.detachedLegato!,
  ];

  /// Every `staccatissimo` child, in document order.
  List<EmptyPlacement> get staccatissimoElements => [
    for (final item in items)
      if (item.staccatissimo != null) item.staccatissimo!,
  ];

  /// Every `spiccato` child, in document order.
  List<EmptyPlacement> get spiccatoElements => [
    for (final item in items)
      if (item.spiccato != null) item.spiccato!,
  ];

  /// Every `scoop` child, in document order.
  List<EmptyLine> get scoopElements => [
    for (final item in items)
      if (item.scoop != null) item.scoop!,
  ];

  /// Every `plop` child, in document order.
  List<EmptyLine> get plopElements => [
    for (final item in items)
      if (item.plop != null) item.plop!,
  ];

  /// Every `doit` child, in document order.
  List<EmptyLine> get doitElements => [
    for (final item in items)
      if (item.doit != null) item.doit!,
  ];

  /// Every `falloff` child, in document order.
  List<EmptyLine> get falloffElements => [
    for (final item in items)
      if (item.falloff != null) item.falloff!,
  ];

  /// Every `breath-mark` child, in document order.
  List<BreathMark> get breathMarkElements => [
    for (final item in items)
      if (item.breathMark != null) item.breathMark!,
  ];

  /// Every `caesura` child, in document order.
  List<Caesura> get caesuraElements => [
    for (final item in items)
      if (item.caesura != null) item.caesura!,
  ];

  /// Every `stress` child, in document order.
  List<EmptyPlacement> get stressElements => [
    for (final item in items)
      if (item.stress != null) item.stress!,
  ];

  /// Every `unstress` child, in document order.
  List<EmptyPlacement> get unstressElements => [
    for (final item in items)
      if (item.unstress != null) item.unstress!,
  ];

  /// Every `soft-accent` child, in document order.
  List<EmptyPlacement> get softAccentElements => [
    for (final item in items)
      if (item.softAccent != null) item.softAccent!,
  ];

  /// Every `other-articulation` child, in document order.
  List<OtherPlacementText> get otherArticulationElements => [
    for (final item in items)
      if (item.otherArticulation != null) item.otherArticulation!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `articulations`. Exactly one field is set, naming
/// which element it was. Holding the content as a list of these keeps the
/// order the document had, which the music depends on.
class ArticulationsItem {
  ArticulationsItem({
    this.accent,
    this.strongAccent,
    this.staccato,
    this.tenuto,
    this.detachedLegato,
    this.staccatissimo,
    this.spiccato,
    this.scoop,
    this.plop,
    this.doit,
    this.falloff,
    this.breathMark,
    this.caesura,
    this.stress,
    this.unstress,
    this.softAccent,
    this.otherArticulation,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static ArticulationsItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'accent':
        return ArticulationsItem(accent: EmptyPlacement.fromXml(element));
      case 'strong-accent':
        return ArticulationsItem(strongAccent: StrongAccent.fromXml(element));
      case 'staccato':
        return ArticulationsItem(staccato: EmptyPlacement.fromXml(element));
      case 'tenuto':
        return ArticulationsItem(tenuto: EmptyPlacement.fromXml(element));
      case 'detached-legato':
        return ArticulationsItem(detachedLegato: EmptyPlacement.fromXml(element));
      case 'staccatissimo':
        return ArticulationsItem(staccatissimo: EmptyPlacement.fromXml(element));
      case 'spiccato':
        return ArticulationsItem(spiccato: EmptyPlacement.fromXml(element));
      case 'scoop':
        return ArticulationsItem(scoop: EmptyLine.fromXml(element));
      case 'plop':
        return ArticulationsItem(plop: EmptyLine.fromXml(element));
      case 'doit':
        return ArticulationsItem(doit: EmptyLine.fromXml(element));
      case 'falloff':
        return ArticulationsItem(falloff: EmptyLine.fromXml(element));
      case 'breath-mark':
        return ArticulationsItem(breathMark: BreathMark.fromXml(element));
      case 'caesura':
        return ArticulationsItem(caesura: Caesura.fromXml(element));
      case 'stress':
        return ArticulationsItem(stress: EmptyPlacement.fromXml(element));
      case 'unstress':
        return ArticulationsItem(unstress: EmptyPlacement.fromXml(element));
      case 'soft-accent':
        return ArticulationsItem(softAccent: EmptyPlacement.fromXml(element));
      case 'other-articulation':
        return ArticulationsItem(otherArticulation: OtherPlacementText.fromXml(element));
    }
    return null;
  }

  /// The accent element indicates a regular horizontal accent mark.
  EmptyPlacement? accent;

  /// The strong-accent element indicates a vertical accent mark.
  StrongAccent? strongAccent;

  /// The staccato element is used for a dot articulation, as opposed to a
  /// stroke or a wedge.
  EmptyPlacement? staccato;

  /// The tenuto element indicates a tenuto line symbol.
  EmptyPlacement? tenuto;

  /// The detached-legato element indicates the combination of a tenuto line
  /// and staccato dot symbol.
  EmptyPlacement? detachedLegato;

  /// The staccatissimo element is used for a wedge articulation, as opposed
  /// to a dot or a stroke.
  EmptyPlacement? staccatissimo;

  /// The spiccato element is used for a stroke articulation, as opposed to a
  /// dot or a wedge.
  EmptyPlacement? spiccato;

  /// The scoop element is an indeterminate slide attached to a single note.
  /// The scoop appears before the main note and comes from below the main
  /// pitch.
  EmptyLine? scoop;

  /// The plop element is an indeterminate slide attached to a single note.
  /// The plop appears before the main note and comes from above the main
  /// pitch.
  EmptyLine? plop;

  /// The doit element is an indeterminate slide attached to a single note.
  /// The doit appears after the main note and goes above the main pitch.
  EmptyLine? doit;

  /// The falloff element is an indeterminate slide attached to a single note.
  /// The falloff appears after the main note and goes below the main pitch.
  EmptyLine? falloff;

  BreathMark? breathMark;

  Caesura? caesura;

  /// The stress element indicates a stressed note.
  EmptyPlacement? stress;

  /// The unstress element indicates an unstressed note. It is often notated
  /// using a u-shaped symbol.
  EmptyPlacement? unstress;

  /// The soft-accent element indicates a soft accent that is not as heavy as
  /// a normal accent. It is often notated as <>. It can be combined with
  /// other articulations to implement the first eight symbols in the SMuFL
  /// Articulation supplement range.
  EmptyPlacement? softAccent;

  /// The other-articulation element is used to define any articulations not
  /// yet in the MusicXML format. The smufl attribute can be used to specify a
  /// particular articulation, allowing application interoperability without
  /// requiring every SMuFL articulation to have a MusicXML element
  /// equivalent. Using the other-articulation element without the smufl
  /// attribute allows for extended representation, though without application
  /// interoperability.
  OtherPlacementText? otherArticulation;

  /// The name of the element this item holds.
  String? get elementName {
    if (accent != null) return 'accent';
    if (strongAccent != null) return 'strong-accent';
    if (staccato != null) return 'staccato';
    if (tenuto != null) return 'tenuto';
    if (detachedLegato != null) return 'detached-legato';
    if (staccatissimo != null) return 'staccatissimo';
    if (spiccato != null) return 'spiccato';
    if (scoop != null) return 'scoop';
    if (plop != null) return 'plop';
    if (doit != null) return 'doit';
    if (falloff != null) return 'falloff';
    if (breathMark != null) return 'breath-mark';
    if (caesura != null) return 'caesura';
    if (stress != null) return 'stress';
    if (unstress != null) return 'unstress';
    if (softAccent != null) return 'soft-accent';
    if (otherArticulation != null) return 'other-articulation';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (accent != null) return accent!.toXml('accent');
    if (strongAccent != null) return strongAccent!.toXml('strong-accent');
    if (staccato != null) return staccato!.toXml('staccato');
    if (tenuto != null) return tenuto!.toXml('tenuto');
    if (detachedLegato != null) return detachedLegato!.toXml('detached-legato');
    if (staccatissimo != null) return staccatissimo!.toXml('staccatissimo');
    if (spiccato != null) return spiccato!.toXml('spiccato');
    if (scoop != null) return scoop!.toXml('scoop');
    if (plop != null) return plop!.toXml('plop');
    if (doit != null) return doit!.toXml('doit');
    if (falloff != null) return falloff!.toXml('falloff');
    if (breathMark != null) return breathMark!.toXml('breath-mark');
    if (caesura != null) return caesura!.toXml('caesura');
    if (stress != null) return stress!.toXml('stress');
    if (unstress != null) return unstress!.toXml('unstress');
    if (softAccent != null) return softAccent!.toXml('soft-accent');
    if (otherArticulation != null) return otherArticulation!.toXml('other-articulation');
    return null;
  }
}

/// By default, an assessment application should assess all notes without a
/// cue child element, and not assess any note with a cue child element. The
/// assess type allows this default assessment to be overridden for individual
/// notes. The optional player and time-only attributes restrict the type to
/// apply to a single player or set of times through a repeated section,
/// respectively. If missing, the type applies to all players or all times
/// through the repeated section, respectively. The player attribute
/// references the id attribute of a player element defined within the
/// matching score-part.
class Assess {
  Assess({
    required this.type,
    this.player,
    this.timeOnly,
  });

  /// Reads an instance from [element].
  factory Assess.fromXml(XmlElement element) =>
      Assess(
        type: xmlRequiredValue(YesNo.parse(element.getAttribute('type')), 'type', element),
        player: element.getAttribute('player'),
        timeOnly: element.getAttribute('time-only'),
      );

  YesNo type;

  String? player;

  String? timeOnly;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (player != null) {
      node.setAttribute('player', player!);
    }
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    return node;
  }
}

/// The attributes element contains musical information that typically changes
/// on measure boundaries. This includes key and time signatures, clefs,
/// transpositions, and staving. When attributes are changed mid-measure, it
/// affects the music in score order, not in MusicXML document order.
class Attributes {
  Attributes({
    this.footnote,
    this.level,
    this.divisions,
    List<Key>? key,
    List<Time>? time,
    this.staves,
    this.partSymbol,
    this.instruments,
    List<Clef>? clef,
    List<StaffDetails>? staffDetails,
    List<Transpose>? transpose,
    List<ForPart>? forPart,
    List<AttributesDirective>? directive,
    List<MeasureStyle>? measureStyle,
  })  : key = key ?? <Key>[],
        time = time ?? <Time>[],
        clef = clef ?? <Clef>[],
        staffDetails = staffDetails ?? <StaffDetails>[],
        transpose = transpose ?? <Transpose>[],
        forPart = forPart ?? <ForPart>[],
        directive = directive ?? <AttributesDirective>[],
        measureStyle = measureStyle ?? <MeasureStyle>[];

  /// Reads an instance from [element].
  factory Attributes.fromXml(XmlElement element) =>
      Attributes(
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
        divisions: xmlDouble(xmlElementText(element, 'divisions')),
        key: xmlElements(element, 'key')
            .map(Key.fromXml)
            .toList(),
        time: xmlElements(element, 'time')
            .map(Time.fromXml)
            .toList(),
        staves: xmlInt(xmlElementText(element, 'staves')),
        partSymbol: switch (xmlElement(element, 'part-symbol')) {
          final child? => PartSymbol.fromXml(child),
          _ => null,
        },
        instruments: xmlInt(xmlElementText(element, 'instruments')),
        clef: xmlElements(element, 'clef')
            .map(Clef.fromXml)
            .toList(),
        staffDetails: xmlElements(element, 'staff-details')
            .map(StaffDetails.fromXml)
            .toList(),
        transpose: xmlElements(element, 'transpose')
            .map(Transpose.fromXml)
            .toList(),
        forPart: xmlElements(element, 'for-part')
            .map(ForPart.fromXml)
            .toList(),
        directive: xmlElements(element, 'directive')
            .map(AttributesDirective.fromXml)
            .toList(),
        measureStyle: xmlElements(element, 'measure-style')
            .map(MeasureStyle.fromXml)
            .toList(),
      );

  FormattedText? footnote;

  Level? level;

  /// Musical notation duration is commonly represented as fractions. The
  /// divisions element indicates how many divisions per quarter note are used
  /// to indicate a note's duration. For example, if duration = 1 and
  /// divisions = 2, this is an eighth note duration. Duration and divisions
  /// are used directly for generating sound output, so they must be chosen to
  /// take tuplets into account. Using a divisions element lets us use just
  /// one number to represent a duration for each note in the score, while
  /// retaining the full power of a fractional representation. If maximum
  /// compatibility with Standard MIDI 1.0 files is important, do not have the
  /// divisions value exceed 16383.
  double? divisions;

  /// The key element represents a key signature. Both traditional and
  /// non-traditional key signatures are supported. The optional number
  /// attribute refers to staff numbers. If absent, the key signature applies
  /// to all staves in the part.
  List<Key> key;

  /// Time signatures are represented by the beats element for the numerator
  /// and the beat-type element for the denominator.
  List<Time> time;

  /// The staves element is used if there is more than one staff represented
  /// in the given part (e.g., 2 staves for typical piano parts). If absent, a
  /// value of 1 is assumed. Staves are ordered from top to bottom in a part
  /// in numerical order, with staff 1 above staff 2.
  int? staves;

  /// The part-symbol element indicates how a symbol for a multi-staff part is
  /// indicated in the score.
  PartSymbol? partSymbol;

  /// The instruments element is only used if more than one instrument is
  /// represented in the part (e.g., oboe I and II where they play together
  /// most of the time). If absent, a value of 1 is assumed.
  int? instruments;

  /// Clefs are represented by a combination of sign, line, and
  /// clef-octave-change elements.
  List<Clef> clef;

  /// The staff-details element is used to indicate different types of staves.
  List<StaffDetails> staffDetails;

  /// If the part is being encoded for a transposing instrument in written vs.
  /// concert pitch, the transposition must be encoded in the transpose
  /// element using the transpose type.
  List<Transpose> transpose;

  /// The for-part element is used in a concert score to indicate the
  /// transposition for a transposed part created from that score. It is only
  /// used in score files that contain a concert-score element in the
  /// defaults. This allows concert scores with transposed parts to be
  /// represented in a single uncompressed MusicXML file.
  List<ForPart> forPart;

  /// Directives are like directions, but can be grouped together with
  /// attributes for convenience. This is typically used for tempo markings at
  /// the beginning of a piece of music. This element was deprecated in
  /// Version 2.0 in favor of the direction element's directive attribute.
  /// Language names come from ISO 639, with optional country subcodes from
  /// ISO 3166.
  List<AttributesDirective> directive;

  /// A measure-style indicates a special way to print partial to multiple
  /// measures within a part. This includes multiple rests over several
  /// measures, repeats of beats, single, or multiple measures, and use of
  /// slash notation.
  List<MeasureStyle> measureStyle;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    if (divisions != null) {
      node.children.add(xmlTextElement('divisions', xmlNumberText(divisions!)));
    }
    for (final item in key) {
      node.children.add(item.toXml('key'));
    }
    for (final item in time) {
      node.children.add(item.toXml('time'));
    }
    if (staves != null) {
      node.children.add(xmlTextElement('staves', xmlNumberText(staves!)));
    }
    if (partSymbol != null) {
      node.children.add(partSymbol!.toXml('part-symbol'));
    }
    if (instruments != null) {
      node.children.add(xmlTextElement('instruments', xmlNumberText(instruments!)));
    }
    for (final item in clef) {
      node.children.add(item.toXml('clef'));
    }
    for (final item in staffDetails) {
      node.children.add(item.toXml('staff-details'));
    }
    for (final item in transpose) {
      node.children.add(item.toXml('transpose'));
    }
    for (final item in forPart) {
      node.children.add(item.toXml('for-part'));
    }
    for (final item in directive) {
      node.children.add(item.toXml('directive'));
    }
    for (final item in measureStyle) {
      node.children.add(item.toXml('measure-style'));
    }
    return node;
  }
}

/// Directives are like directions, but can be grouped together with
/// attributes for convenience. This is typically used for tempo markings at
/// the beginning of a piece of music. This element was deprecated in Version
/// 2.0 in favor of the direction element's directive attribute. Language
/// names come from ISO 639, with optional country subcodes from ISO 3166.
class AttributesDirective {
  AttributesDirective({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.xmlLang,
  });

  /// Reads an instance from [element].
  factory AttributesDirective.fromXml(XmlElement element) =>
      AttributesDirective(
        value: element.innerText,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        xmlLang: element.getAttribute('xml:lang'),
      );

  /// The element's text content.
  String value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// The `xml:lang` attribute.
  String? xmlLang;

  /// Writes this value as an element named [name].
  XmlElement toXml([String elementName = 'directive']) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (xmlLang != null) {
      node.setAttribute('xml:lang', xmlLang!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The backup and forward elements are required to coordinate multiple voices
/// in one part, including music on multiple staves. The backup type is
/// generally used to move between voices and staves. Thus the backup element
/// does not include voice or staff elements. Duration values should always be
/// positive, and should not cross measure boundaries or mid-measure changes
/// in the divisions value.
class Backup {
  Backup({
    required this.duration,
    this.footnote,
    this.level,
  });

  /// Reads an instance from [element].
  factory Backup.fromXml(XmlElement element) =>
      Backup(
        duration: xmlDouble(xmlElementText(element, 'duration')) ?? 0,
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
      );

  /// Duration is a positive number specified in division units. This is the
  /// intended duration vs. notated duration (for instance, differences in
  /// dotted notes in Baroque-era music). Differences in duration specific to
  /// an interpretation or performance should be represented using the note
  /// element's attack and release attributes.
  ///
  /// The duration element moves the musical position when used in backup
  /// elements, forward elements, and note elements that do not contain a
  /// chord child element.
  double duration;

  FormattedText? footnote;

  Level? level;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('duration', xmlNumberText(duration)));
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    return node;
  }
}

/// The bar-style-color type contains barline style and color information.
class BarStyleColor {
  BarStyleColor({
    required this.value,
    this.color,
  });

  /// Reads an instance from [element].
  factory BarStyleColor.fromXml(XmlElement element) =>
      BarStyleColor(
        value: xmlRequiredValue(BarStyle.parse(element.innerText), 'value', element),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  BarStyle value;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// If a barline is other than a normal single barline, it should be
/// represented by a barline type that describes it. This includes information
/// about repeats and multiple endings, as well as line style. Barline data is
/// on the same level as the other musical data in a score - a child of a
/// measure in a partwise score, or a part in a timewise score. This allows
/// for barlines within measures, as in dotted barlines that subdivide
/// measures in complex meters. The two fermata elements allow for fermatas on
/// both sides of the barline (the lower one inverted).
///
/// Barlines have a location attribute to make it easier to process barlines
/// independently of the other musical data in a score. It is often easier to
/// set up measures separately from entering notes. The location attribute
/// must match where the barline element occurs within the rest of the musical
/// data in the score. If location is left, it should be the first element in
/// the measure, aside from the print, bookmark, and link elements. If
/// location is right, it should be the last element, again with the possible
/// exception of the print, bookmark, and link elements. If no location is
/// specified, the right barline is the default. The segno, coda, and
/// divisions attributes work the same way as in the sound element. They are
/// used for playback when barline elements contain segno or coda child
/// elements.
class Barline {
  Barline({
    this.barStyle,
    this.footnote,
    this.level,
    this.wavyLine,
    this.segno,
    this.coda,
    List<Fermata>? fermata,
    this.ending,
    this.repeat,
    this.location,
    this.segnoAttribute,
    this.codaAttribute,
    this.divisions,
    this.id,
  })  : fermata = fermata ?? <Fermata>[];

  /// Reads an instance from [element].
  factory Barline.fromXml(XmlElement element) =>
      Barline(
        barStyle: switch (xmlElement(element, 'bar-style')) {
          final child? => BarStyleColor.fromXml(child),
          _ => null,
        },
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
        wavyLine: switch (xmlElement(element, 'wavy-line')) {
          final child? => WavyLine.fromXml(child),
          _ => null,
        },
        segno: switch (xmlElement(element, 'segno')) {
          final child? => Segno.fromXml(child),
          _ => null,
        },
        coda: switch (xmlElement(element, 'coda')) {
          final child? => Coda.fromXml(child),
          _ => null,
        },
        fermata: xmlElements(element, 'fermata')
            .map(Fermata.fromXml)
            .toList(),
        ending: switch (xmlElement(element, 'ending')) {
          final child? => Ending.fromXml(child),
          _ => null,
        },
        repeat: switch (xmlElement(element, 'repeat')) {
          final child? => Repeat.fromXml(child),
          _ => null,
        },
        location: RightLeftMiddle.parse(element.getAttribute('location')) ?? RightLeftMiddle.right,
        segnoAttribute: element.getAttribute('segno'),
        codaAttribute: element.getAttribute('coda'),
        divisions: xmlDouble(element.getAttribute('divisions')),
        id: element.getAttribute('id'),
      );

  BarStyleColor? barStyle;

  FormattedText? footnote;

  Level? level;

  WavyLine? wavyLine;

  Segno? segno;

  Coda? coda;

  List<Fermata> fermata;

  Ending? ending;

  Repeat? repeat;

  RightLeftMiddle? location;

  String? segnoAttribute;

  String? codaAttribute;

  double? divisions;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (location != null) {
      node.setAttribute('location', location!.xmlValue);
    }
    if (segnoAttribute != null) {
      node.setAttribute('segno', segnoAttribute!);
    }
    if (codaAttribute != null) {
      node.setAttribute('coda', codaAttribute!);
    }
    if (divisions != null) {
      node.setAttribute('divisions', xmlNumberText(divisions!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (barStyle != null) {
      node.children.add(barStyle!.toXml('bar-style'));
    }
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    if (wavyLine != null) {
      node.children.add(wavyLine!.toXml('wavy-line'));
    }
    if (segno != null) {
      node.children.add(segno!.toXml('segno'));
    }
    if (coda != null) {
      node.children.add(coda!.toXml('coda'));
    }
    for (final item in fermata) {
      node.children.add(item.toXml('fermata'));
    }
    if (ending != null) {
      node.children.add(ending!.toXml('ending'));
    }
    if (repeat != null) {
      node.children.add(repeat!.toXml('repeat'));
    }
    return node;
  }
}

/// The barre element indicates placing a finger over multiple strings on a
/// single fret. The type is "start" for the lowest pitched string (e.g., the
/// string with the highest MusicXML number) and is "stop" for the highest
/// pitched string.
class Barre {
  Barre({
    required this.type,
    this.color,
  });

  /// Reads an instance from [element].
  factory Barre.fromXml(XmlElement element) =>
      Barre(
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        color: element.getAttribute('color'),
      );

  StartStop type;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (color != null) {
      node.setAttribute('color', color!);
    }
    return node;
  }
}

/// The bass type is used to indicate a bass note in popular music chord
/// symbols, e.g. G/C. It is generally not used in functional harmony, as
/// inversion is generally not used in pop chord symbols. As with root, it is
/// divided into step and alter elements, similar to pitches. The arrangement
/// attribute specifies where the bass is displayed relative to what precedes
/// it.
class Bass {
  Bass({
    this.bassSeparator,
    required this.bassStep,
    this.bassAlter,
    this.arrangement,
  });

  /// Reads an instance from [element].
  factory Bass.fromXml(XmlElement element) =>
      Bass(
        bassSeparator: switch (xmlElement(element, 'bass-separator')) {
          final child? => StyleText.fromXml(child),
          _ => null,
        },
        bassStep: BassStep.fromXml(xmlRequiredElement(element, 'bass-step')),
        bassAlter: switch (xmlElement(element, 'bass-alter')) {
          final child? => HarmonyAlter.fromXml(child),
          _ => null,
        },
        arrangement: HarmonyArrangement.parse(element.getAttribute('arrangement')),
      );

  /// The optional bass-separator element indicates that text, rather than a
  /// line or slash, separates the bass from what precedes it.
  StyleText? bassSeparator;

  BassStep bassStep;

  /// The bass-alter element represents the chromatic alteration of the bass
  /// of the current chord within the harmony element. In some chord styles,
  /// the text for the bass-step element may include bass-alter information.
  /// In that case, the print-object attribute of the bass-alter element can
  /// be set to no. The location attribute indicates whether the alteration
  /// should appear to the left or the right of the bass-step; it is right if
  /// not specified.
  HarmonyAlter? bassAlter;

  HarmonyArrangement? arrangement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (arrangement != null) {
      node.setAttribute('arrangement', arrangement!.xmlValue);
    }
    if (bassSeparator != null) {
      node.children.add(bassSeparator!.toXml('bass-separator'));
    }
    node.children.add(bassStep.toXml('bass-step'));
    if (bassAlter != null) {
      node.children.add(bassAlter!.toXml('bass-alter'));
    }
    return node;
  }
}

/// The bass-step type represents the pitch step of the bass of the current
/// chord within the harmony element. The text attribute indicates how the
/// bass should appear in a score if not using the element contents.
class BassStep {
  BassStep({
    required this.value,
    this.text,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory BassStep.fromXml(XmlElement element) =>
      BassStep(
        value: xmlRequiredValue(Step.parse(element.innerText), 'value', element),
        text: element.getAttribute('text'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  Step value;

  String? text;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// Beam values include begin, continue, end, forward hook, and backward hook.
/// Up to eight concurrent beams are available to cover up to 1024th notes.
/// Each beam in a note is represented with a separate beam element, starting
/// with the eighth note beam using a number attribute of 1.
///
/// Note that the beam number does not distinguish sets of beams that overlap,
/// as it does for slur and other elements. Beaming groups are distinguished
/// by being in different voices and/or the presence or absence of grace and
/// cue elements.
///
/// Beams that have a begin value can also have a fan attribute to indicate
/// accelerandos and ritardandos using fanned beams. The fan attribute may
/// also be used with a continue value if the fanning direction changes on
/// that note. The value is "none" if not specified.
///
/// The repeater attribute has been deprecated in MusicXML 3.0. Formerly used
/// for tremolos, it needs to be specified with a "yes" value for each beam
/// using it.
class Beam {
  Beam({
    required this.value,
    this.number,
    this.repeater,
    this.fan,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Beam.fromXml(XmlElement element) =>
      Beam(
        value: xmlRequiredValue(BeamValue.parse(element.innerText), 'value', element),
        number: xmlInt(element.getAttribute('number')) ?? 1,
        repeater: YesNo.parse(element.getAttribute('repeater')),
        fan: Fan.parse(element.getAttribute('fan')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  BeamValue value;

  int? number;

  YesNo? repeater;

  Fan? fan;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (repeater != null) {
      node.setAttribute('repeater', repeater!.xmlValue);
    }
    if (fan != null) {
      node.setAttribute('fan', fan!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The beat-repeat type is used to indicate that a single beat (but possibly
/// many notes) is repeated. The slashes attribute specifies the number of
/// slashes to use in the symbol. The use-dots attribute indicates whether or
/// not to use dots as well (for instance, with mixed rhythm patterns). The
/// value for slashes is 1 and the value for use-dots is no if not specified.
///
/// The stop type indicates the first beat where the repeats are no longer
/// displayed. Both the start and stop of the beat being repeated should be
/// specified unless the repeats are displayed through the end of the part.
///
/// The beat-repeat element specifies a notation style for repetitions. The
/// actual music being repeated needs to be repeated within the MusicXML file.
/// This element specifies the notation that indicates the repeat.
class BeatRepeat {
  BeatRepeat({
    this.slashType,
    List<Empty>? slashDot,
    List<String>? exceptVoice,
    required this.type,
    this.slashes,
    this.useDots,
  })  : slashDot = slashDot ?? <Empty>[],
        exceptVoice = exceptVoice ?? <String>[];

  /// Reads an instance from [element].
  factory BeatRepeat.fromXml(XmlElement element) =>
      BeatRepeat(
        slashType: NoteTypeValue.parse(xmlElementText(element, 'slash-type')),
        slashDot: xmlElements(element, 'slash-dot')
            .map(Empty.fromXml)
            .toList(),
        exceptVoice: xmlElements(element, 'except-voice')
            .map((e) => e.innerText)
            .toList(),
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        slashes: xmlInt(element.getAttribute('slashes')),
        useDots: YesNo.parse(element.getAttribute('use-dots')),
      );

  /// The slash-type element indicates the graphical note type to use for the
  /// display of repetition marks.
  NoteTypeValue? slashType;

  /// The slash-dot element is used to specify any augmentation dots in the
  /// note type used to display repetition marks.
  List<Empty> slashDot;

  /// The except-voice element is used to specify a combination of slash
  /// notation and regular notation. Any note elements that are in voices
  /// specified by the except-voice elements are displayed in normal notation,
  /// in addition to the slash notation that is always displayed.
  List<String> exceptVoice;

  StartStop type;

  int? slashes;

  YesNo? useDots;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (slashes != null) {
      node.setAttribute('slashes', xmlNumberText(slashes!));
    }
    if (useDots != null) {
      node.setAttribute('use-dots', useDots!.xmlValue);
    }
    if (slashType != null) {
      node.children.add(xmlTextElement('slash-type', slashType!.xmlValue));
    }
    for (final item in slashDot) {
      node.children.add(item.toXml('slash-dot'));
    }
    for (final item in exceptVoice) {
      node.children.add(xmlTextElement('except-voice', item));
    }
    return node;
  }
}

/// The beat-unit-tied type indicates a beat-unit within a metronome mark that
/// is tied to the preceding beat-unit. This allows two or more tied notes to
/// be associated with a per-minute value in a metronome mark, whereas the
/// metronome-tied element is restricted to metric relationship marks.
class BeatUnitTied {
  BeatUnitTied({
    required this.beatUnit,
    List<Empty>? beatUnitDot,
  })  : beatUnitDot = beatUnitDot ?? <Empty>[];

  /// Reads an instance from [element].
  factory BeatUnitTied.fromXml(XmlElement element) =>
      BeatUnitTied(
        beatUnit: xmlRequiredValue(NoteTypeValue.parse(xmlElementText(element, 'beat-unit')), 'beat-unit', element),
        beatUnitDot: xmlElements(element, 'beat-unit-dot')
            .map(Empty.fromXml)
            .toList(),
      );

  /// The beat-unit element indicates the graphical note type to use in a
  /// metronome mark.
  NoteTypeValue beatUnit;

  /// The beat-unit-dot element is used to specify any augmentation dots for a
  /// metronome mark note.
  List<Empty> beatUnitDot;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('beat-unit', beatUnit.xmlValue));
    for (final item in beatUnitDot) {
      node.children.add(item.toXml('beat-unit-dot'));
    }
    return node;
  }
}

/// The beater type represents pictograms for beaters, mallets, and sticks
/// that do not have different materials represented in the pictogram.
class Beater {
  Beater({
    required this.value,
    this.tip,
  });

  /// Reads an instance from [element].
  factory Beater.fromXml(XmlElement element) =>
      Beater(
        value: xmlRequiredValue(BeaterValue.parse(element.innerText), 'value', element),
        tip: TipDirection.parse(element.getAttribute('tip')),
      );

  /// The element's text content.
  BeaterValue value;

  TipDirection? tip;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (tip != null) {
      node.setAttribute('tip', tip!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The bend type is used in guitar notation and tablature. A single note with
/// a bend and release will contain two bend elements: the first to represent
/// the bend and the second to represent the release. The shape attribute
/// distinguishes between the angled bend symbols commonly used in standard
/// notation and the curved bend symbols commonly used in both tablature and
/// standard notation.
class Bend {
  Bend({
    required this.bendAlter,
    this.preBend,
    this.release,
    this.withBar,
    this.shape,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.accelerate,
    this.beats,
    this.firstBeat,
    this.lastBeat,
  });

  /// Reads an instance from [element].
  factory Bend.fromXml(XmlElement element) =>
      Bend(
        bendAlter: xmlDouble(xmlElementText(element, 'bend-alter')) ?? 0,
        preBend: switch (xmlElement(element, 'pre-bend')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        release: switch (xmlElement(element, 'release')) {
          final child? => Release.fromXml(child),
          _ => null,
        },
        withBar: switch (xmlElement(element, 'with-bar')) {
          final child? => PlacementText.fromXml(child),
          _ => null,
        },
        shape: BendShape.parse(element.getAttribute('shape')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        accelerate: YesNo.parse(element.getAttribute('accelerate')),
        beats: xmlDouble(element.getAttribute('beats')),
        firstBeat: xmlDouble(element.getAttribute('first-beat')),
        lastBeat: xmlDouble(element.getAttribute('last-beat')),
      );

  /// The bend-alter element indicates the number of semitones in the bend,
  /// similar to the alter element. As with the alter element, numbers like
  /// 0.5 can be used to indicate microtones. Negative values indicate
  /// pre-bends or releases. The pre-bend and release elements are used to
  /// distinguish what is intended. Because the bend-alter element represents
  /// the number of steps in the bend, a release after a bend has a negative
  /// bend-alter value, not a zero value.
  double bendAlter;

  /// The pre-bend element indicates that a bend is a pre-bend rather than a
  /// normal bend or a release.
  Empty? preBend;

  Release? release;

  /// The with-bar element indicates that the bend is to be done at the bridge
  /// with a whammy or vibrato bar. The content of the element indicates how
  /// this should be notated. Content values of "scoop" and "dip" refer to the
  /// SMuFL guitarVibratoBarScoop and guitarVibratoBarDip glyphs.
  PlacementText? withBar;

  BendShape? shape;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  YesNo? accelerate;

  double? beats;

  double? firstBeat;

  double? lastBeat;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (shape != null) {
      node.setAttribute('shape', shape!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (accelerate != null) {
      node.setAttribute('accelerate', accelerate!.xmlValue);
    }
    if (beats != null) {
      node.setAttribute('beats', xmlNumberText(beats!));
    }
    if (firstBeat != null) {
      node.setAttribute('first-beat', xmlNumberText(firstBeat!));
    }
    if (lastBeat != null) {
      node.setAttribute('last-beat', xmlNumberText(lastBeat!));
    }
    node.children.add(xmlTextElement('bend-alter', xmlNumberText(bendAlter)));
    if (preBend != null) {
      node.children.add(preBend!.toXml('pre-bend'));
    }
    if (release != null) {
      node.children.add(release!.toXml('release'));
    }
    if (withBar != null) {
      node.children.add(withBar!.toXml('with-bar'));
    }
    return node;
  }
}

/// The bookmark type serves as a well-defined target for an incoming simple
/// XLink.
class Bookmark {
  Bookmark({
    required this.id,
    this.name,
    this.element,
    this.position,
  });

  /// Reads an instance from [element].
  factory Bookmark.fromXml(XmlElement element) =>
      Bookmark(
        id: element.getAttribute('id') ?? '',
        name: element.getAttribute('name'),
        element: element.getAttribute('element'),
        position: xmlInt(element.getAttribute('position')),
      );

  String id;

  String? name;

  String? element;

  int? position;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    if (name != null) {
      node.setAttribute('name', name!);
    }
    if (element != null) {
      node.setAttribute('element', element!);
    }
    if (position != null) {
      node.setAttribute('position', xmlNumberText(position!));
    }
    return node;
  }
}

/// Brackets are combined with words in a variety of modern directions. The
/// line-end attribute specifies if there is a jog up or down (or both), an
/// arrow, or nothing at the start or end of the bracket. If the line-end is
/// up or down, the length of the jog can be specified using the end-length
/// attribute. The line-type is solid if not specified.
class Bracket {
  Bracket({
    required this.type,
    this.number,
    required this.lineEnd,
    this.endLength,
    this.lineType,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Bracket.fromXml(XmlElement element) =>
      Bracket(
        type: xmlRequiredValue(StartStopContinue.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        lineEnd: xmlRequiredValue(LineEnd.parse(element.getAttribute('line-end')), 'line-end', element),
        endLength: xmlDouble(element.getAttribute('end-length')),
        lineType: LineType.parse(element.getAttribute('line-type')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  StartStopContinue type;

  int? number;

  LineEnd lineEnd;

  double? endLength;

  LineType? lineType;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    node.setAttribute('line-end', lineEnd.xmlValue);
    if (endLength != null) {
      node.setAttribute('end-length', xmlNumberText(endLength!));
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The breath-mark element indicates a place to take a breath.
class BreathMark {
  BreathMark({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory BreathMark.fromXml(XmlElement element) =>
      BreathMark(
        value: xmlRequiredValue(BreathMarkValue.parse(element.innerText), 'value', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  BreathMarkValue value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The caesura element indicates a slight pause. It is notated using a
/// "railroad tracks" symbol or other variations specified in the element
/// content.
class Caesura {
  Caesura({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory Caesura.fromXml(XmlElement element) =>
      Caesura(
        value: xmlRequiredValue(CaesuraValue.parse(element.innerText), 'value', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  CaesuraValue value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// A cancel element indicates that the old key signature should be cancelled
/// before the new one appears. This will always happen when changing to C
/// major or A minor and need not be specified then. The cancel value matches
/// the fifths value of the cancelled key signature (e.g., a cancel of -2 will
/// provide an explicit cancellation for changing from B flat major to F
/// major). The optional location attribute indicates where the cancellation
/// appears relative to the new key signature.
class Cancel {
  Cancel({
    required this.value,
    this.location,
  });

  /// Reads an instance from [element].
  factory Cancel.fromXml(XmlElement element) =>
      Cancel(
        value: xmlInt(element.innerText) ?? 0,
        location: CancelLocation.parse(element.getAttribute('location')),
      );

  /// The element's text content.
  int value;

  CancelLocation? location;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (location != null) {
      node.setAttribute('location', location!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// Clefs are represented by a combination of sign, line, and
/// clef-octave-change elements. The optional number attribute refers to staff
/// numbers within the part. A value of 1 is assumed if not present.
///
/// Sometimes clefs are added to the staff in non-standard line positions,
/// either to indicate cue passages, or when there are multiple clefs present
/// simultaneously on one staff. In this situation, the additional attribute
/// is set to "yes" and the line value is ignored. The size attribute is used
/// for clefs where the additional attribute is "yes". It is typically used to
/// indicate cue clefs.
///
/// Sometimes clefs at the start of a measure need to appear after the barline
/// rather than before, as for cues or for use after a repeated section. The
/// after-barline attribute is set to "yes" in this situation. The attribute
/// is ignored for mid-measure clefs.
///
/// Clefs appear at the start of each system unless the print-object attribute
/// has been set to "no" or the additional attribute has been set to "yes".
class Clef {
  Clef({
    required this.sign,
    this.line,
    this.clefOctaveChange,
    this.number,
    this.additional,
    this.size,
    this.afterBarline,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.printObject,
    this.id,
  });

  /// Reads an instance from [element].
  factory Clef.fromXml(XmlElement element) =>
      Clef(
        sign: xmlRequiredValue(ClefSign.parse(xmlElementText(element, 'sign')), 'sign', element),
        line: xmlInt(xmlElementText(element, 'line')),
        clefOctaveChange: xmlInt(xmlElementText(element, 'clef-octave-change')),
        number: xmlInt(element.getAttribute('number')),
        additional: YesNo.parse(element.getAttribute('additional')),
        size: SymbolSize.parse(element.getAttribute('size')),
        afterBarline: YesNo.parse(element.getAttribute('after-barline')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        id: element.getAttribute('id'),
      );

  /// The sign element represents the clef symbol.
  ClefSign sign;

  /// Line numbers are counted from the bottom of the staff. They are only
  /// needed with the G, F, and C signs in order to position a pitch correctly
  /// on the staff. Standard values are 2 for the G sign (treble clef), 4 for
  /// the F sign (bass clef), and 3 for the C sign (alto clef). Line values
  /// can be used to specify positions outside the staff, such as a C clef
  /// positioned in the middle of a grand staff.
  int? line;

  /// The clef-octave-change element is used for transposing clefs. A treble
  /// clef for tenors would have a value of -1.
  int? clefOctaveChange;

  int? number;

  YesNo? additional;

  SymbolSize? size;

  YesNo? afterBarline;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  YesNo? printObject;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (additional != null) {
      node.setAttribute('additional', additional!.xmlValue);
    }
    if (size != null) {
      node.setAttribute('size', size!.xmlValue);
    }
    if (afterBarline != null) {
      node.setAttribute('after-barline', afterBarline!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(xmlTextElement('sign', sign.xmlValue));
    if (line != null) {
      node.children.add(xmlTextElement('line', xmlNumberText(line!)));
    }
    if (clefOctaveChange != null) {
      node.children.add(xmlTextElement('clef-octave-change', xmlNumberText(clefOctaveChange!)));
    }
    return node;
  }
}

/// The coda type is the visual indicator of a coda sign. The exact glyph can
/// be specified with the smufl attribute. A sound element is also needed to
/// guide playback applications reliably.
class Coda {
  Coda({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Coda.fromXml(XmlElement element) =>
      Coda(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
        smufl: element.getAttribute('smufl'),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    return node;
  }
}

/// The credit type represents the appearance of the title, composer,
/// arranger, lyricist, copyright, dedication, and other text, symbols, and
/// graphics that commonly appear on the first page of a score. The
/// credit-words, credit-symbol, and credit-image elements are similar to the
/// words, symbol, and image elements for directions. However, since the
/// credit is not part of a measure, the default-x and default-y attributes
/// adjust the origin relative to the bottom left-hand corner of the page. The
/// enclosure for credit-words and credit-symbol is none by default.
///
/// By default, a series of credit-words and credit-symbol elements within a
/// single credit element follow one another in sequence visually.
/// Non-positional formatting attributes are carried over from the previous
/// element by default.
///
/// The page attribute for the credit element specifies the page number where
/// the credit should appear. This is an integer value that starts with 1 for
/// the first page. Its value is 1 by default. Since credits occur before the
/// music, these page numbers do not refer to the page numbering specified by
/// the print element's page-number attribute.
///
/// The credit-type element indicates the purpose behind a credit. Multiple
/// types of data may be combined in a single credit, so multiple elements may
/// be used. Standard values include page number, title, subtitle, composer,
/// arranger, lyricist, rights, and part name.
class Credit {
  Credit({
    this.page,
    this.id,
    List<CreditItem>? items,
  })  : items = items ?? <CreditItem>[];

  /// Reads an instance from [element].
  factory Credit.fromXml(XmlElement element) =>
      Credit(
        page: xmlInt(element.getAttribute('page')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(CreditItem.tryFromXml)
            .whereType<CreditItem>()
            .toList(),
      );

  int? page;

  String? id;

  /// The element content, in document order.
  List<CreditItem> items;

  /// Every `credit-type` child, in document order.
  List<String> get creditTypeElements => [
    for (final item in items)
      if (item.creditType != null) item.creditType!,
  ];

  /// Every `link` child, in document order.
  List<Link> get linkElements => [
    for (final item in items)
      if (item.link != null) item.link!,
  ];

  /// Every `bookmark` child, in document order.
  List<Bookmark> get bookmarkElements => [
    for (final item in items)
      if (item.bookmark != null) item.bookmark!,
  ];

  /// Every `credit-image` child, in document order.
  List<Image> get creditImageElements => [
    for (final item in items)
      if (item.creditImage != null) item.creditImage!,
  ];

  /// Every `credit-words` child, in document order.
  List<FormattedTextId> get creditWordsElements => [
    for (final item in items)
      if (item.creditWords != null) item.creditWords!,
  ];

  /// Every `credit-symbol` child, in document order.
  List<FormattedSymbolId> get creditSymbolElements => [
    for (final item in items)
      if (item.creditSymbol != null) item.creditSymbol!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (page != null) {
      node.setAttribute('page', xmlNumberText(page!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `credit`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class CreditItem {
  CreditItem({
    this.creditType,
    this.link,
    this.bookmark,
    this.creditImage,
    this.creditWords,
    this.creditSymbol,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static CreditItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'credit-type':
        return CreditItem(creditType: element.innerText);
      case 'link':
        return CreditItem(link: Link.fromXml(element));
      case 'bookmark':
        return CreditItem(bookmark: Bookmark.fromXml(element));
      case 'credit-image':
        return CreditItem(creditImage: Image.fromXml(element));
      case 'credit-words':
        return CreditItem(creditWords: FormattedTextId.fromXml(element));
      case 'credit-symbol':
        return CreditItem(creditSymbol: FormattedSymbolId.fromXml(element));
    }
    return null;
  }

  String? creditType;

  Link? link;

  Bookmark? bookmark;

  Image? creditImage;

  FormattedTextId? creditWords;

  FormattedSymbolId? creditSymbol;

  /// The name of the element this item holds.
  String? get elementName {
    if (creditType != null) return 'credit-type';
    if (link != null) return 'link';
    if (bookmark != null) return 'bookmark';
    if (creditImage != null) return 'credit-image';
    if (creditWords != null) return 'credit-words';
    if (creditSymbol != null) return 'credit-symbol';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (creditType != null) return xmlTextElement('credit-type', creditType!);
    if (link != null) return link!.toXml('link');
    if (bookmark != null) return bookmark!.toXml('bookmark');
    if (creditImage != null) return creditImage!.toXml('credit-image');
    if (creditWords != null) return creditWords!.toXml('credit-words');
    if (creditSymbol != null) return creditSymbol!.toXml('credit-symbol');
    return null;
  }
}

/// The dashes type represents dashes, used for instance with cresc. and dim.
/// marks.
class Dashes {
  Dashes({
    required this.type,
    this.number,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Dashes.fromXml(XmlElement element) =>
      Dashes(
        type: xmlRequiredValue(StartStopContinue.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  StartStopContinue type;

  int? number;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The defaults type specifies score-wide defaults for scaling; whether or
/// not the file is a concert score; layout; and default values for the music
/// font, word font, lyric font, and lyric language. Except for the
/// concert-score element, if any defaults are missing, the choice of what to
/// use is determined by the application.
class Defaults {
  Defaults({
    this.scaling,
    this.concertScore,
    this.pageLayout,
    this.systemLayout,
    List<StaffLayout>? staffLayout,
    this.appearance,
    this.musicFont,
    this.wordFont,
    List<LyricFont>? lyricFont,
    List<LyricLanguage>? lyricLanguage,
  })  : staffLayout = staffLayout ?? <StaffLayout>[],
        lyricFont = lyricFont ?? <LyricFont>[],
        lyricLanguage = lyricLanguage ?? <LyricLanguage>[];

  /// Reads an instance from [element].
  factory Defaults.fromXml(XmlElement element) =>
      Defaults(
        scaling: switch (xmlElement(element, 'scaling')) {
          final child? => Scaling.fromXml(child),
          _ => null,
        },
        concertScore: switch (xmlElement(element, 'concert-score')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        pageLayout: switch (xmlElement(element, 'page-layout')) {
          final child? => PageLayout.fromXml(child),
          _ => null,
        },
        systemLayout: switch (xmlElement(element, 'system-layout')) {
          final child? => SystemLayout.fromXml(child),
          _ => null,
        },
        staffLayout: xmlElements(element, 'staff-layout')
            .map(StaffLayout.fromXml)
            .toList(),
        appearance: switch (xmlElement(element, 'appearance')) {
          final child? => Appearance.fromXml(child),
          _ => null,
        },
        musicFont: switch (xmlElement(element, 'music-font')) {
          final child? => EmptyFont.fromXml(child),
          _ => null,
        },
        wordFont: switch (xmlElement(element, 'word-font')) {
          final child? => EmptyFont.fromXml(child),
          _ => null,
        },
        lyricFont: xmlElements(element, 'lyric-font')
            .map(LyricFont.fromXml)
            .toList(),
        lyricLanguage: xmlElements(element, 'lyric-language')
            .map(LyricLanguage.fromXml)
            .toList(),
      );

  Scaling? scaling;

  /// The presence of a concert-score element indicates that a score is
  /// displayed in concert pitch. It is used for scores that contain parts for
  /// transposing instruments.
  ///
  /// A document with a concert-score element may not contain any transpose
  /// elements that have non-zero values for either the diatonic or chromatic
  /// elements. Concert scores may include octave transpositions, so transpose
  /// elements with a double element or a non-zero octave-change element value
  /// are permitted.
  Empty? concertScore;

  PageLayout? pageLayout;

  SystemLayout? systemLayout;

  List<StaffLayout> staffLayout;

  Appearance? appearance;

  EmptyFont? musicFont;

  EmptyFont? wordFont;

  List<LyricFont> lyricFont;

  List<LyricLanguage> lyricLanguage;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (scaling != null) {
      node.children.add(scaling!.toXml('scaling'));
    }
    if (concertScore != null) {
      node.children.add(concertScore!.toXml('concert-score'));
    }
    if (pageLayout != null) {
      node.children.add(pageLayout!.toXml('page-layout'));
    }
    if (systemLayout != null) {
      node.children.add(systemLayout!.toXml('system-layout'));
    }
    for (final item in staffLayout) {
      node.children.add(item.toXml('staff-layout'));
    }
    if (appearance != null) {
      node.children.add(appearance!.toXml('appearance'));
    }
    if (musicFont != null) {
      node.children.add(musicFont!.toXml('music-font'));
    }
    if (wordFont != null) {
      node.children.add(wordFont!.toXml('word-font'));
    }
    for (final item in lyricFont) {
      node.children.add(item.toXml('lyric-font'));
    }
    for (final item in lyricLanguage) {
      node.children.add(item.toXml('lyric-language'));
    }
    return node;
  }
}

/// The degree type is used to add, alter, or subtract individual notes in the
/// chord. The print-object attribute can be used to keep the degree from
/// printing separately when it has already taken into account in the text
/// attribute of the kind element. The degree-value and degree-type text
/// attributes specify how the value and type of the degree should be
/// displayed.
///
/// A harmony of kind "other" can be spelled explicitly by using a series of
/// degree elements together with a root.
class Degree {
  Degree({
    required this.degreeValue,
    required this.degreeAlter,
    required this.degreeType,
    this.printObject,
  });

  /// Reads an instance from [element].
  factory Degree.fromXml(XmlElement element) =>
      Degree(
        degreeValue: DegreeValue.fromXml(xmlRequiredElement(element, 'degree-value')),
        degreeAlter: DegreeAlter.fromXml(xmlRequiredElement(element, 'degree-alter')),
        degreeType: DegreeType.fromXml(xmlRequiredElement(element, 'degree-type')),
        printObject: YesNo.parse(element.getAttribute('print-object')),
      );

  DegreeValue degreeValue;

  DegreeAlter degreeAlter;

  DegreeType degreeType;

  YesNo? printObject;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    node.children.add(degreeValue.toXml('degree-value'));
    node.children.add(degreeAlter.toXml('degree-alter'));
    node.children.add(degreeType.toXml('degree-type'));
    return node;
  }
}

/// The degree-alter type represents the chromatic alteration for the current
/// degree. If the degree-type value is alter or subtract, the degree-alter
/// value is relative to the degree already in the chord based on its kind
/// element. If the degree-type value is add, the degree-alter is relative to
/// a dominant chord (major and perfect intervals except for a minor seventh).
/// The plus-minus attribute is used to indicate if plus and minus symbols
/// should be used instead of sharp and flat symbols to display the degree
/// alteration. It is no if not specified.
class DegreeAlter {
  DegreeAlter({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.plusMinus,
  });

  /// Reads an instance from [element].
  factory DegreeAlter.fromXml(XmlElement element) =>
      DegreeAlter(
        value: xmlDouble(element.innerText) ?? 0,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        plusMinus: YesNo.parse(element.getAttribute('plus-minus')),
      );

  /// The element's text content.
  double value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  YesNo? plusMinus;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (plusMinus != null) {
      node.setAttribute('plus-minus', plusMinus!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The degree-type type indicates if this degree is an addition, alteration,
/// or subtraction relative to the kind of the current chord. The value of the
/// degree-type element affects the interpretation of the value of the
/// degree-alter element. The text attribute specifies how the type of the
/// degree should be displayed.
class DegreeType {
  DegreeType({
    required this.value,
    this.text,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory DegreeType.fromXml(XmlElement element) =>
      DegreeType(
        value: xmlRequiredValue(DegreeTypeValue.parse(element.innerText), 'value', element),
        text: element.getAttribute('text'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  DegreeTypeValue value;

  String? text;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The content of the degree-value type is a number indicating the degree of
/// the chord (1 for the root, 3 for third, etc). The text attribute specifies
/// how the value of the degree should be displayed. The symbol attribute
/// indicates that a symbol should be used in specifying the degree. If the
/// symbol attribute is present, the value of the text attribute follows the
/// symbol.
class DegreeValue {
  DegreeValue({
    required this.value,
    this.symbol,
    this.text,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory DegreeValue.fromXml(XmlElement element) =>
      DegreeValue(
        value: xmlInt(element.innerText) ?? 0,
        symbol: DegreeSymbolValue.parse(element.getAttribute('symbol')),
        text: element.getAttribute('text'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  int value;

  DegreeSymbolValue? symbol;

  String? text;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (symbol != null) {
      node.setAttribute('symbol', symbol!.xmlValue);
    }
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// A direction is a musical indication that is not necessarily attached to a
/// specific note. Two or more may be combined to indicate words followed by
/// the start of a dashed line, the end of a wedge followed by dynamics, etc.
/// For applications where a specific direction is indeed attached to a
/// specific note, the direction element can be associated with the first note
/// element that follows it in score order that is not in a different voice.
///
/// By default, a series of direction-type elements and a series of child
/// elements of a direction-type within a single direction element follow one
/// another in sequence visually. For a series of direction-type children,
/// non-positional formatting attributes are carried over from the previous
/// element by default.
class Direction {
  Direction({
    List<DirectionType>? directionType,
    this.offset,
    this.footnote,
    this.level,
    this.voice,
    this.staff,
    this.sound,
    this.listening,
    this.placement,
    this.directive,
    this.system,
    this.id,
  })  : directionType = directionType ?? <DirectionType>[];

  /// Reads an instance from [element].
  factory Direction.fromXml(XmlElement element) =>
      Direction(
        directionType: xmlElements(element, 'direction-type')
            .map(DirectionType.fromXml)
            .toList(),
        offset: switch (xmlElement(element, 'offset')) {
          final child? => Offset.fromXml(child),
          _ => null,
        },
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
        voice: xmlElementText(element, 'voice'),
        staff: xmlInt(xmlElementText(element, 'staff')),
        sound: switch (xmlElement(element, 'sound')) {
          final child? => Sound.fromXml(child),
          _ => null,
        },
        listening: switch (xmlElement(element, 'listening')) {
          final child? => Listening.fromXml(child),
          _ => null,
        },
        placement: AboveBelow.parse(element.getAttribute('placement')),
        directive: YesNo.parse(element.getAttribute('directive')),
        system: SystemRelation.parse(element.getAttribute('system')),
        id: element.getAttribute('id'),
      );

  List<DirectionType> directionType;

  Offset? offset;

  FormattedText? footnote;

  Level? level;

  String? voice;

  /// Staff assignment is only needed for music notated on multiple staves.
  /// Used by both notes and directions. Staff values are numbers, with 1
  /// referring to the top-most staff in a part.
  int? staff;

  Sound? sound;

  Listening? listening;

  AboveBelow? placement;

  YesNo? directive;

  SystemRelation? system;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (directive != null) {
      node.setAttribute('directive', directive!.xmlValue);
    }
    if (system != null) {
      node.setAttribute('system', system!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in directionType) {
      node.children.add(item.toXml('direction-type'));
    }
    if (offset != null) {
      node.children.add(offset!.toXml('offset'));
    }
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    if (voice != null) {
      node.children.add(xmlTextElement('voice', voice!));
    }
    if (staff != null) {
      node.children.add(xmlTextElement('staff', xmlNumberText(staff!)));
    }
    if (sound != null) {
      node.children.add(sound!.toXml('sound'));
    }
    if (listening != null) {
      node.children.add(listening!.toXml('listening'));
    }
    return node;
  }
}

/// Textual direction types may have more than 1 component due to multiple
/// fonts. The dynamics element may also be used in the notations element.
/// Attribute groups related to print suggestions apply to the individual
/// direction-type, not to the overall direction.
class DirectionType {
  DirectionType({
    this.id,
    List<DirectionTypeItem>? items,
  })  : items = items ?? <DirectionTypeItem>[];

  /// Reads an instance from [element].
  factory DirectionType.fromXml(XmlElement element) =>
      DirectionType(
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(DirectionTypeItem.tryFromXml)
            .whereType<DirectionTypeItem>()
            .toList(),
      );

  String? id;

  /// The element content, in document order.
  List<DirectionTypeItem> items;

  /// Every `rehearsal` child, in document order.
  List<FormattedTextId> get rehearsalElements => [
    for (final item in items)
      if (item.rehearsal != null) item.rehearsal!,
  ];

  /// Every `segno` child, in document order.
  List<Segno> get segnoElements => [
    for (final item in items)
      if (item.segno != null) item.segno!,
  ];

  /// Every `coda` child, in document order.
  List<Coda> get codaElements => [
    for (final item in items)
      if (item.coda != null) item.coda!,
  ];

  /// Every `words` child, in document order.
  List<FormattedTextId> get wordsElements => [
    for (final item in items)
      if (item.words != null) item.words!,
  ];

  /// Every `symbol` child, in document order.
  List<FormattedSymbolId> get symbolElements => [
    for (final item in items)
      if (item.symbol != null) item.symbol!,
  ];

  /// Every `wedge` child, in document order.
  List<Wedge> get wedgeElements => [
    for (final item in items)
      if (item.wedge != null) item.wedge!,
  ];

  /// Every `dynamics` child, in document order.
  List<Dynamics> get dynamicsElements => [
    for (final item in items)
      if (item.dynamics != null) item.dynamics!,
  ];

  /// Every `dashes` child, in document order.
  List<Dashes> get dashesElements => [
    for (final item in items)
      if (item.dashes != null) item.dashes!,
  ];

  /// Every `bracket` child, in document order.
  List<Bracket> get bracketElements => [
    for (final item in items)
      if (item.bracket != null) item.bracket!,
  ];

  /// Every `pedal` child, in document order.
  List<Pedal> get pedalElements => [
    for (final item in items)
      if (item.pedal != null) item.pedal!,
  ];

  /// Every `metronome` child, in document order.
  List<Metronome> get metronomeElements => [
    for (final item in items)
      if (item.metronome != null) item.metronome!,
  ];

  /// Every `octave-shift` child, in document order.
  List<OctaveShift> get octaveShiftElements => [
    for (final item in items)
      if (item.octaveShift != null) item.octaveShift!,
  ];

  /// Every `harp-pedals` child, in document order.
  List<HarpPedals> get harpPedalsElements => [
    for (final item in items)
      if (item.harpPedals != null) item.harpPedals!,
  ];

  /// Every `damp` child, in document order.
  List<EmptyPrintStyleAlignId> get dampElements => [
    for (final item in items)
      if (item.damp != null) item.damp!,
  ];

  /// Every `damp-all` child, in document order.
  List<EmptyPrintStyleAlignId> get dampAllElements => [
    for (final item in items)
      if (item.dampAll != null) item.dampAll!,
  ];

  /// Every `eyeglasses` child, in document order.
  List<EmptyPrintStyleAlignId> get eyeglassesElements => [
    for (final item in items)
      if (item.eyeglasses != null) item.eyeglasses!,
  ];

  /// Every `string-mute` child, in document order.
  List<StringMute> get stringMuteElements => [
    for (final item in items)
      if (item.stringMute != null) item.stringMute!,
  ];

  /// Every `scordatura` child, in document order.
  List<Scordatura> get scordaturaElements => [
    for (final item in items)
      if (item.scordatura != null) item.scordatura!,
  ];

  /// Every `image` child, in document order.
  List<Image> get imageElements => [
    for (final item in items)
      if (item.image != null) item.image!,
  ];

  /// Every `principal-voice` child, in document order.
  List<PrincipalVoice> get principalVoiceElements => [
    for (final item in items)
      if (item.principalVoice != null) item.principalVoice!,
  ];

  /// Every `percussion` child, in document order.
  List<Percussion> get percussionElements => [
    for (final item in items)
      if (item.percussion != null) item.percussion!,
  ];

  /// Every `accordion-registration` child, in document order.
  List<AccordionRegistration> get accordionRegistrationElements => [
    for (final item in items)
      if (item.accordionRegistration != null) item.accordionRegistration!,
  ];

  /// Every `staff-divide` child, in document order.
  List<StaffDivide> get staffDivideElements => [
    for (final item in items)
      if (item.staffDivide != null) item.staffDivide!,
  ];

  /// Every `other-direction` child, in document order.
  List<OtherDirection> get otherDirectionElements => [
    for (final item in items)
      if (item.otherDirection != null) item.otherDirection!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `direction-type`. Exactly one field is set, naming
/// which element it was. Holding the content as a list of these keeps the
/// order the document had, which the music depends on.
class DirectionTypeItem {
  DirectionTypeItem({
    this.rehearsal,
    this.segno,
    this.coda,
    this.words,
    this.symbol,
    this.wedge,
    this.dynamics,
    this.dashes,
    this.bracket,
    this.pedal,
    this.metronome,
    this.octaveShift,
    this.harpPedals,
    this.damp,
    this.dampAll,
    this.eyeglasses,
    this.stringMute,
    this.scordatura,
    this.image,
    this.principalVoice,
    this.percussion,
    this.accordionRegistration,
    this.staffDivide,
    this.otherDirection,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static DirectionTypeItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'rehearsal':
        return DirectionTypeItem(rehearsal: FormattedTextId.fromXml(element));
      case 'segno':
        return DirectionTypeItem(segno: Segno.fromXml(element));
      case 'coda':
        return DirectionTypeItem(coda: Coda.fromXml(element));
      case 'words':
        return DirectionTypeItem(words: FormattedTextId.fromXml(element));
      case 'symbol':
        return DirectionTypeItem(symbol: FormattedSymbolId.fromXml(element));
      case 'wedge':
        return DirectionTypeItem(wedge: Wedge.fromXml(element));
      case 'dynamics':
        return DirectionTypeItem(dynamics: Dynamics.fromXml(element));
      case 'dashes':
        return DirectionTypeItem(dashes: Dashes.fromXml(element));
      case 'bracket':
        return DirectionTypeItem(bracket: Bracket.fromXml(element));
      case 'pedal':
        return DirectionTypeItem(pedal: Pedal.fromXml(element));
      case 'metronome':
        return DirectionTypeItem(metronome: Metronome.fromXml(element));
      case 'octave-shift':
        return DirectionTypeItem(octaveShift: OctaveShift.fromXml(element));
      case 'harp-pedals':
        return DirectionTypeItem(harpPedals: HarpPedals.fromXml(element));
      case 'damp':
        return DirectionTypeItem(damp: EmptyPrintStyleAlignId.fromXml(element));
      case 'damp-all':
        return DirectionTypeItem(dampAll: EmptyPrintStyleAlignId.fromXml(element));
      case 'eyeglasses':
        return DirectionTypeItem(eyeglasses: EmptyPrintStyleAlignId.fromXml(element));
      case 'string-mute':
        return DirectionTypeItem(stringMute: StringMute.fromXml(element));
      case 'scordatura':
        return DirectionTypeItem(scordatura: Scordatura.fromXml(element));
      case 'image':
        return DirectionTypeItem(image: Image.fromXml(element));
      case 'principal-voice':
        return DirectionTypeItem(principalVoice: PrincipalVoice.fromXml(element));
      case 'percussion':
        return DirectionTypeItem(percussion: Percussion.fromXml(element));
      case 'accordion-registration':
        return DirectionTypeItem(accordionRegistration: AccordionRegistration.fromXml(element));
      case 'staff-divide':
        return DirectionTypeItem(staffDivide: StaffDivide.fromXml(element));
      case 'other-direction':
        return DirectionTypeItem(otherDirection: OtherDirection.fromXml(element));
    }
    return null;
  }

  /// The rehearsal element specifies letters, numbers, and section names that
  /// are notated in the score for reference during rehearsal. The enclosure
  /// is square if not specified. The language is Italian ("it") if not
  /// specified. Left justification is used if not specified.
  FormattedTextId? rehearsal;

  Segno? segno;

  Coda? coda;

  /// The words element specifies a standard text direction. The enclosure is
  /// none if not specified. The language is Italian ("it") if not specified.
  /// Left justification is used if not specified.
  FormattedTextId? words;

  /// The symbol element specifies a musical symbol using a canonical SMuFL
  /// glyph name. It is used when an occasional musical symbol is interspersed
  /// into text. It should not be used in place of semantic markup, such as
  /// metronome marks that mix text and symbols. Left justification is used if
  /// not specified. Enclosure is none if not specified.
  FormattedSymbolId? symbol;

  Wedge? wedge;

  Dynamics? dynamics;

  Dashes? dashes;

  Bracket? bracket;

  Pedal? pedal;

  Metronome? metronome;

  OctaveShift? octaveShift;

  HarpPedals? harpPedals;

  /// The damp element specifies a harp damping mark.
  EmptyPrintStyleAlignId? damp;

  /// The damp-all element specifies a harp damping mark for all strings.
  EmptyPrintStyleAlignId? dampAll;

  /// The eyeglasses element represents the eyeglasses symbol, common in
  /// commercial music.
  EmptyPrintStyleAlignId? eyeglasses;

  StringMute? stringMute;

  Scordatura? scordatura;

  Image? image;

  PrincipalVoice? principalVoice;

  Percussion? percussion;

  AccordionRegistration? accordionRegistration;

  StaffDivide? staffDivide;

  OtherDirection? otherDirection;

  /// The name of the element this item holds.
  String? get elementName {
    if (rehearsal != null) return 'rehearsal';
    if (segno != null) return 'segno';
    if (coda != null) return 'coda';
    if (words != null) return 'words';
    if (symbol != null) return 'symbol';
    if (wedge != null) return 'wedge';
    if (dynamics != null) return 'dynamics';
    if (dashes != null) return 'dashes';
    if (bracket != null) return 'bracket';
    if (pedal != null) return 'pedal';
    if (metronome != null) return 'metronome';
    if (octaveShift != null) return 'octave-shift';
    if (harpPedals != null) return 'harp-pedals';
    if (damp != null) return 'damp';
    if (dampAll != null) return 'damp-all';
    if (eyeglasses != null) return 'eyeglasses';
    if (stringMute != null) return 'string-mute';
    if (scordatura != null) return 'scordatura';
    if (image != null) return 'image';
    if (principalVoice != null) return 'principal-voice';
    if (percussion != null) return 'percussion';
    if (accordionRegistration != null) return 'accordion-registration';
    if (staffDivide != null) return 'staff-divide';
    if (otherDirection != null) return 'other-direction';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (rehearsal != null) return rehearsal!.toXml('rehearsal');
    if (segno != null) return segno!.toXml('segno');
    if (coda != null) return coda!.toXml('coda');
    if (words != null) return words!.toXml('words');
    if (symbol != null) return symbol!.toXml('symbol');
    if (wedge != null) return wedge!.toXml('wedge');
    if (dynamics != null) return dynamics!.toXml('dynamics');
    if (dashes != null) return dashes!.toXml('dashes');
    if (bracket != null) return bracket!.toXml('bracket');
    if (pedal != null) return pedal!.toXml('pedal');
    if (metronome != null) return metronome!.toXml('metronome');
    if (octaveShift != null) return octaveShift!.toXml('octave-shift');
    if (harpPedals != null) return harpPedals!.toXml('harp-pedals');
    if (damp != null) return damp!.toXml('damp');
    if (dampAll != null) return dampAll!.toXml('damp-all');
    if (eyeglasses != null) return eyeglasses!.toXml('eyeglasses');
    if (stringMute != null) return stringMute!.toXml('string-mute');
    if (scordatura != null) return scordatura!.toXml('scordatura');
    if (image != null) return image!.toXml('image');
    if (principalVoice != null) return principalVoice!.toXml('principal-voice');
    if (percussion != null) return percussion!.toXml('percussion');
    if (accordionRegistration != null) return accordionRegistration!.toXml('accordion-registration');
    if (staffDivide != null) return staffDivide!.toXml('staff-divide');
    if (otherDirection != null) return otherDirection!.toXml('other-direction');
    return null;
  }
}

/// The distance element represents standard distances between notation
/// elements in tenths. The type attribute defines what type of distance is
/// being defined. Valid values include hyphen (for hyphens in lyrics) and
/// beam.
class Distance {
  Distance({
    required this.value,
    required this.type,
  });

  /// Reads an instance from [element].
  factory Distance.fromXml(XmlElement element) =>
      Distance(
        value: xmlDouble(element.innerText) ?? 0,
        type: element.getAttribute('type') ?? '',
      );

  /// The element's text content.
  double value;

  String type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type);
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The double type indicates that the music is doubled one octave from what
/// is currently written. If the above attribute is set to yes, the doubling
/// is one octave above what is written, as for mixed flute / piccolo parts in
/// band literature. Otherwise the doubling is one octave below what is
/// written, as for mixed cello / bass parts in orchestral literature.
class Double {
  Double({
    this.above,
  });

  /// Reads an instance from [element].
  factory Double.fromXml(XmlElement element) =>
      Double(
        above: YesNo.parse(element.getAttribute('above')),
      );

  YesNo? above;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (above != null) {
      node.setAttribute('above', above!.xmlValue);
    }
    return node;
  }
}

/// Dynamics can be associated either with a note or a general musical
/// direction. To avoid inconsistencies between and amongst the letter
/// abbreviations for dynamics (what is sf vs. sfz, standing alone or with a
/// trailing dynamic that is not always piano), we use the actual letters as
/// the names of these dynamic elements. The other-dynamics element allows
/// other dynamic marks that are not covered here. Dynamics elements may also
/// be combined to create marks not covered by a single element, such as sfmp.
///
/// These letter dynamic symbols are separated from crescendo, decrescendo,
/// and wedge indications. Dynamic representation is inconsistent in scores.
/// Many things are assumed by the composer and left out, such as returns to
/// original dynamics. The MusicXML format captures what is in the score, but
/// does not try to be optimal for analysis or synthesis of dynamics.
///
/// The placement attribute is used when the dynamics are associated with a
/// note. It is ignored when the dynamics are associated with a direction. In
/// that case the direction element's placement attribute is used instead.
class Dynamics {
  Dynamics({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.placement,
    this.underline,
    this.overline,
    this.lineThrough,
    this.enclosure,
    this.id,
    List<DynamicsItem>? items,
  })  : items = items ?? <DynamicsItem>[];

  /// Reads an instance from [element].
  factory Dynamics.fromXml(XmlElement element) =>
      Dynamics(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        underline: xmlInt(element.getAttribute('underline')),
        overline: xmlInt(element.getAttribute('overline')),
        lineThrough: xmlInt(element.getAttribute('line-through')),
        enclosure: EnclosureShape.parse(element.getAttribute('enclosure')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(DynamicsItem.tryFromXml)
            .whereType<DynamicsItem>()
            .toList(),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  AboveBelow? placement;

  int? underline;

  int? overline;

  int? lineThrough;

  EnclosureShape? enclosure;

  String? id;

  /// The element content, in document order.
  List<DynamicsItem> items;

  /// Every `p` child, in document order.
  List<Empty> get pElements => [
    for (final item in items)
      if (item.p != null) item.p!,
  ];

  /// Every `pp` child, in document order.
  List<Empty> get ppElements => [
    for (final item in items)
      if (item.pp != null) item.pp!,
  ];

  /// Every `ppp` child, in document order.
  List<Empty> get pppElements => [
    for (final item in items)
      if (item.ppp != null) item.ppp!,
  ];

  /// Every `pppp` child, in document order.
  List<Empty> get ppppElements => [
    for (final item in items)
      if (item.pppp != null) item.pppp!,
  ];

  /// Every `ppppp` child, in document order.
  List<Empty> get pppppElements => [
    for (final item in items)
      if (item.ppppp != null) item.ppppp!,
  ];

  /// Every `pppppp` child, in document order.
  List<Empty> get ppppppElements => [
    for (final item in items)
      if (item.pppppp != null) item.pppppp!,
  ];

  /// Every `f` child, in document order.
  List<Empty> get fElements => [
    for (final item in items)
      if (item.f != null) item.f!,
  ];

  /// Every `ff` child, in document order.
  List<Empty> get ffElements => [
    for (final item in items)
      if (item.ff != null) item.ff!,
  ];

  /// Every `fff` child, in document order.
  List<Empty> get fffElements => [
    for (final item in items)
      if (item.fff != null) item.fff!,
  ];

  /// Every `ffff` child, in document order.
  List<Empty> get ffffElements => [
    for (final item in items)
      if (item.ffff != null) item.ffff!,
  ];

  /// Every `fffff` child, in document order.
  List<Empty> get fffffElements => [
    for (final item in items)
      if (item.fffff != null) item.fffff!,
  ];

  /// Every `ffffff` child, in document order.
  List<Empty> get ffffffElements => [
    for (final item in items)
      if (item.ffffff != null) item.ffffff!,
  ];

  /// Every `mp` child, in document order.
  List<Empty> get mpElements => [
    for (final item in items)
      if (item.mp != null) item.mp!,
  ];

  /// Every `mf` child, in document order.
  List<Empty> get mfElements => [
    for (final item in items)
      if (item.mf != null) item.mf!,
  ];

  /// Every `sf` child, in document order.
  List<Empty> get sfElements => [
    for (final item in items)
      if (item.sf != null) item.sf!,
  ];

  /// Every `sfp` child, in document order.
  List<Empty> get sfpElements => [
    for (final item in items)
      if (item.sfp != null) item.sfp!,
  ];

  /// Every `sfpp` child, in document order.
  List<Empty> get sfppElements => [
    for (final item in items)
      if (item.sfpp != null) item.sfpp!,
  ];

  /// Every `fp` child, in document order.
  List<Empty> get fpElements => [
    for (final item in items)
      if (item.fp != null) item.fp!,
  ];

  /// Every `rf` child, in document order.
  List<Empty> get rfElements => [
    for (final item in items)
      if (item.rf != null) item.rf!,
  ];

  /// Every `rfz` child, in document order.
  List<Empty> get rfzElements => [
    for (final item in items)
      if (item.rfz != null) item.rfz!,
  ];

  /// Every `sfz` child, in document order.
  List<Empty> get sfzElements => [
    for (final item in items)
      if (item.sfz != null) item.sfz!,
  ];

  /// Every `sffz` child, in document order.
  List<Empty> get sffzElements => [
    for (final item in items)
      if (item.sffz != null) item.sffz!,
  ];

  /// Every `fz` child, in document order.
  List<Empty> get fzElements => [
    for (final item in items)
      if (item.fz != null) item.fz!,
  ];

  /// Every `n` child, in document order.
  List<Empty> get nElements => [
    for (final item in items)
      if (item.n != null) item.n!,
  ];

  /// Every `pf` child, in document order.
  List<Empty> get pfElements => [
    for (final item in items)
      if (item.pf != null) item.pf!,
  ];

  /// Every `sfzp` child, in document order.
  List<Empty> get sfzpElements => [
    for (final item in items)
      if (item.sfzp != null) item.sfzp!,
  ];

  /// Every `other-dynamics` child, in document order.
  List<OtherText> get otherDynamicsElements => [
    for (final item in items)
      if (item.otherDynamics != null) item.otherDynamics!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (underline != null) {
      node.setAttribute('underline', xmlNumberText(underline!));
    }
    if (overline != null) {
      node.setAttribute('overline', xmlNumberText(overline!));
    }
    if (lineThrough != null) {
      node.setAttribute('line-through', xmlNumberText(lineThrough!));
    }
    if (enclosure != null) {
      node.setAttribute('enclosure', enclosure!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `dynamics`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class DynamicsItem {
  DynamicsItem({
    this.p,
    this.pp,
    this.ppp,
    this.pppp,
    this.ppppp,
    this.pppppp,
    this.f,
    this.ff,
    this.fff,
    this.ffff,
    this.fffff,
    this.ffffff,
    this.mp,
    this.mf,
    this.sf,
    this.sfp,
    this.sfpp,
    this.fp,
    this.rf,
    this.rfz,
    this.sfz,
    this.sffz,
    this.fz,
    this.n,
    this.pf,
    this.sfzp,
    this.otherDynamics,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static DynamicsItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'p':
        return DynamicsItem(p: Empty.fromXml(element));
      case 'pp':
        return DynamicsItem(pp: Empty.fromXml(element));
      case 'ppp':
        return DynamicsItem(ppp: Empty.fromXml(element));
      case 'pppp':
        return DynamicsItem(pppp: Empty.fromXml(element));
      case 'ppppp':
        return DynamicsItem(ppppp: Empty.fromXml(element));
      case 'pppppp':
        return DynamicsItem(pppppp: Empty.fromXml(element));
      case 'f':
        return DynamicsItem(f: Empty.fromXml(element));
      case 'ff':
        return DynamicsItem(ff: Empty.fromXml(element));
      case 'fff':
        return DynamicsItem(fff: Empty.fromXml(element));
      case 'ffff':
        return DynamicsItem(ffff: Empty.fromXml(element));
      case 'fffff':
        return DynamicsItem(fffff: Empty.fromXml(element));
      case 'ffffff':
        return DynamicsItem(ffffff: Empty.fromXml(element));
      case 'mp':
        return DynamicsItem(mp: Empty.fromXml(element));
      case 'mf':
        return DynamicsItem(mf: Empty.fromXml(element));
      case 'sf':
        return DynamicsItem(sf: Empty.fromXml(element));
      case 'sfp':
        return DynamicsItem(sfp: Empty.fromXml(element));
      case 'sfpp':
        return DynamicsItem(sfpp: Empty.fromXml(element));
      case 'fp':
        return DynamicsItem(fp: Empty.fromXml(element));
      case 'rf':
        return DynamicsItem(rf: Empty.fromXml(element));
      case 'rfz':
        return DynamicsItem(rfz: Empty.fromXml(element));
      case 'sfz':
        return DynamicsItem(sfz: Empty.fromXml(element));
      case 'sffz':
        return DynamicsItem(sffz: Empty.fromXml(element));
      case 'fz':
        return DynamicsItem(fz: Empty.fromXml(element));
      case 'n':
        return DynamicsItem(n: Empty.fromXml(element));
      case 'pf':
        return DynamicsItem(pf: Empty.fromXml(element));
      case 'sfzp':
        return DynamicsItem(sfzp: Empty.fromXml(element));
      case 'other-dynamics':
        return DynamicsItem(otherDynamics: OtherText.fromXml(element));
    }
    return null;
  }

  Empty? p;

  Empty? pp;

  Empty? ppp;

  Empty? pppp;

  Empty? ppppp;

  Empty? pppppp;

  Empty? f;

  Empty? ff;

  Empty? fff;

  Empty? ffff;

  Empty? fffff;

  Empty? ffffff;

  Empty? mp;

  Empty? mf;

  Empty? sf;

  Empty? sfp;

  Empty? sfpp;

  Empty? fp;

  Empty? rf;

  Empty? rfz;

  Empty? sfz;

  Empty? sffz;

  Empty? fz;

  Empty? n;

  Empty? pf;

  Empty? sfzp;

  OtherText? otherDynamics;

  /// The name of the element this item holds.
  String? get elementName {
    if (p != null) return 'p';
    if (pp != null) return 'pp';
    if (ppp != null) return 'ppp';
    if (pppp != null) return 'pppp';
    if (ppppp != null) return 'ppppp';
    if (pppppp != null) return 'pppppp';
    if (f != null) return 'f';
    if (ff != null) return 'ff';
    if (fff != null) return 'fff';
    if (ffff != null) return 'ffff';
    if (fffff != null) return 'fffff';
    if (ffffff != null) return 'ffffff';
    if (mp != null) return 'mp';
    if (mf != null) return 'mf';
    if (sf != null) return 'sf';
    if (sfp != null) return 'sfp';
    if (sfpp != null) return 'sfpp';
    if (fp != null) return 'fp';
    if (rf != null) return 'rf';
    if (rfz != null) return 'rfz';
    if (sfz != null) return 'sfz';
    if (sffz != null) return 'sffz';
    if (fz != null) return 'fz';
    if (n != null) return 'n';
    if (pf != null) return 'pf';
    if (sfzp != null) return 'sfzp';
    if (otherDynamics != null) return 'other-dynamics';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (p != null) return p!.toXml('p');
    if (pp != null) return pp!.toXml('pp');
    if (ppp != null) return ppp!.toXml('ppp');
    if (pppp != null) return pppp!.toXml('pppp');
    if (ppppp != null) return ppppp!.toXml('ppppp');
    if (pppppp != null) return pppppp!.toXml('pppppp');
    if (f != null) return f!.toXml('f');
    if (ff != null) return ff!.toXml('ff');
    if (fff != null) return fff!.toXml('fff');
    if (ffff != null) return ffff!.toXml('ffff');
    if (fffff != null) return fffff!.toXml('fffff');
    if (ffffff != null) return ffffff!.toXml('ffffff');
    if (mp != null) return mp!.toXml('mp');
    if (mf != null) return mf!.toXml('mf');
    if (sf != null) return sf!.toXml('sf');
    if (sfp != null) return sfp!.toXml('sfp');
    if (sfpp != null) return sfpp!.toXml('sfpp');
    if (fp != null) return fp!.toXml('fp');
    if (rf != null) return rf!.toXml('rf');
    if (rfz != null) return rfz!.toXml('rfz');
    if (sfz != null) return sfz!.toXml('sfz');
    if (sffz != null) return sffz!.toXml('sffz');
    if (fz != null) return fz!.toXml('fz');
    if (n != null) return n!.toXml('n');
    if (pf != null) return pf!.toXml('pf');
    if (sfzp != null) return sfzp!.toXml('sfzp');
    if (otherDynamics != null) return otherDynamics!.toXml('other-dynamics');
    return null;
  }
}

/// The effect type represents pictograms for sound effect percussion
/// instruments. The smufl attribute is used to distinguish different SMuFL
/// stylistic alternates.
class Effect {
  Effect({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Effect.fromXml(XmlElement element) =>
      Effect(
        value: xmlRequiredValue(EffectValue.parse(element.innerText), 'value', element),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  EffectValue value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The elision type represents an elision between lyric syllables. The text
/// content specifies the symbol used to display the elision. Common values
/// are a no-break space (Unicode 00A0), an underscore (Unicode 005F), or an
/// undertie (Unicode 203F). If the text content is empty, the smufl attribute
/// is used to specify the symbol to use. Its value is a SMuFL canonical glyph
/// name that starts with lyrics. The SMuFL attribute is ignored if the
/// elision glyph is already specified by the text content. If neither text
/// content nor a smufl attribute are present, the elision glyph is
/// application-specific.
class Elision {
  Elision({
    required this.value,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Elision.fromXml(XmlElement element) =>
      Elision(
        value: element.innerText,
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  String value;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The empty type represents an empty element with no attributes.
class Empty {
  Empty();

  /// Reads an instance from [element].
  factory Empty.fromXml(XmlElement element) =>
      Empty();

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    return node;
  }
}

/// The empty-font type represents an empty element with font attributes.
class EmptyFont {
  EmptyFont({
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
  });

  /// Reads an instance from [element].
  factory EmptyFont.fromXml(XmlElement element) =>
      EmptyFont(
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
      );

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    return node;
  }
}

/// The empty-line type represents an empty element with line-shape,
/// line-type, line-length, dashed-formatting, print-style and placement
/// attributes.
class EmptyLine {
  EmptyLine({
    this.lineShape,
    this.lineType,
    this.lineLength,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory EmptyLine.fromXml(XmlElement element) =>
      EmptyLine(
        lineShape: LineShape.parse(element.getAttribute('line-shape')),
        lineType: LineType.parse(element.getAttribute('line-type')),
        lineLength: LineLength.parse(element.getAttribute('line-length')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  LineShape? lineShape;

  LineType? lineType;

  LineLength? lineLength;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (lineShape != null) {
      node.setAttribute('line-shape', lineShape!.xmlValue);
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (lineLength != null) {
      node.setAttribute('line-length', lineLength!.xmlValue);
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    return node;
  }
}

/// The empty-placement type represents an empty element with print-style and
/// placement attributes.
class EmptyPlacement {
  EmptyPlacement({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory EmptyPlacement.fromXml(XmlElement element) =>
      EmptyPlacement(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    return node;
  }
}

/// The empty-placement-smufl type represents an empty element with
/// print-style, placement, and smufl attributes.
class EmptyPlacementSmufl {
  EmptyPlacementSmufl({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory EmptyPlacementSmufl.fromXml(XmlElement element) =>
      EmptyPlacementSmufl(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        smufl: element.getAttribute('smufl'),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    return node;
  }
}

/// The empty-print-style-align-object type represents an empty element with
/// print-object and print-style-align attribute groups.
class EmptyPrintObjectStyleAlign {
  EmptyPrintObjectStyleAlign({
    this.printObject,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
  });

  /// Reads an instance from [element].
  factory EmptyPrintObjectStyleAlign.fromXml(XmlElement element) =>
      EmptyPrintObjectStyleAlign(
        printObject: YesNo.parse(element.getAttribute('print-object')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
      );

  YesNo? printObject;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    return node;
  }
}

/// The empty-print-style type represents an empty element with print-style
/// attribute group.
class EmptyPrintStyle {
  EmptyPrintStyle({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory EmptyPrintStyle.fromXml(XmlElement element) =>
      EmptyPrintStyle(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    return node;
  }
}

/// The empty-print-style-align type represents an empty element with
/// print-style-align attribute group.
class EmptyPrintStyleAlign {
  EmptyPrintStyleAlign({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
  });

  /// Reads an instance from [element].
  factory EmptyPrintStyleAlign.fromXml(XmlElement element) =>
      EmptyPrintStyleAlign(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    return node;
  }
}

/// The empty-print-style-align-id type represents an empty element with
/// print-style-align and optional-unique-id attribute groups.
class EmptyPrintStyleAlignId {
  EmptyPrintStyleAlignId({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
  });

  /// Reads an instance from [element].
  factory EmptyPrintStyleAlignId.fromXml(XmlElement element) =>
      EmptyPrintStyleAlignId(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The empty-trill-sound type represents an empty element with print-style,
/// placement, and trill-sound attributes.
class EmptyTrillSound {
  EmptyTrillSound({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.startNote,
    this.trillStep,
    this.twoNoteTurn,
    this.accelerate,
    this.beats,
    this.secondBeat,
    this.lastBeat,
  });

  /// Reads an instance from [element].
  factory EmptyTrillSound.fromXml(XmlElement element) =>
      EmptyTrillSound(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        startNote: StartNote.parse(element.getAttribute('start-note')),
        trillStep: TrillStep.parse(element.getAttribute('trill-step')),
        twoNoteTurn: TwoNoteTurn.parse(element.getAttribute('two-note-turn')),
        accelerate: YesNo.parse(element.getAttribute('accelerate')),
        beats: xmlDouble(element.getAttribute('beats')),
        secondBeat: xmlDouble(element.getAttribute('second-beat')),
        lastBeat: xmlDouble(element.getAttribute('last-beat')),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  StartNote? startNote;

  TrillStep? trillStep;

  TwoNoteTurn? twoNoteTurn;

  YesNo? accelerate;

  double? beats;

  double? secondBeat;

  double? lastBeat;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (startNote != null) {
      node.setAttribute('start-note', startNote!.xmlValue);
    }
    if (trillStep != null) {
      node.setAttribute('trill-step', trillStep!.xmlValue);
    }
    if (twoNoteTurn != null) {
      node.setAttribute('two-note-turn', twoNoteTurn!.xmlValue);
    }
    if (accelerate != null) {
      node.setAttribute('accelerate', accelerate!.xmlValue);
    }
    if (beats != null) {
      node.setAttribute('beats', xmlNumberText(beats!));
    }
    if (secondBeat != null) {
      node.setAttribute('second-beat', xmlNumberText(secondBeat!));
    }
    if (lastBeat != null) {
      node.setAttribute('last-beat', xmlNumberText(lastBeat!));
    }
    return node;
  }
}

/// The encoding element contains information about who did the digital
/// encoding, when, with what software, and in what aspects. Standard type
/// values for the encoder element are music, words, and arrangement, but
/// other types may be used. The type attribute is only needed when there are
/// multiple encoder elements.
class Encoding {
  Encoding({
    List<EncodingItem>? items,
  })  : items = items ?? <EncodingItem>[];

  /// Reads an instance from [element].
  factory Encoding.fromXml(XmlElement element) =>
      Encoding(
        items: xmlChildren(element)
            .map(EncodingItem.tryFromXml)
            .whereType<EncodingItem>()
            .toList(),
      );

  /// The element content, in document order.
  List<EncodingItem> items;

  /// Every `encoding-date` child, in document order.
  List<String> get encodingDateElements => [
    for (final item in items)
      if (item.encodingDate != null) item.encodingDate!,
  ];

  /// Every `encoder` child, in document order.
  List<TypedText> get encoderElements => [
    for (final item in items)
      if (item.encoder != null) item.encoder!,
  ];

  /// Every `software` child, in document order.
  List<String> get softwareElements => [
    for (final item in items)
      if (item.software != null) item.software!,
  ];

  /// Every `encoding-description` child, in document order.
  List<String> get encodingDescriptionElements => [
    for (final item in items)
      if (item.encodingDescription != null) item.encodingDescription!,
  ];

  /// Every `supports` child, in document order.
  List<Supports> get supportsElements => [
    for (final item in items)
      if (item.supports != null) item.supports!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `encoding`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class EncodingItem {
  EncodingItem({
    this.encodingDate,
    this.encoder,
    this.software,
    this.encodingDescription,
    this.supports,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static EncodingItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'encoding-date':
        return EncodingItem(encodingDate: element.innerText);
      case 'encoder':
        return EncodingItem(encoder: TypedText.fromXml(element));
      case 'software':
        return EncodingItem(software: element.innerText);
      case 'encoding-description':
        return EncodingItem(encodingDescription: element.innerText);
      case 'supports':
        return EncodingItem(supports: Supports.fromXml(element));
    }
    return null;
  }

  String? encodingDate;

  TypedText? encoder;

  String? software;

  String? encodingDescription;

  Supports? supports;

  /// The name of the element this item holds.
  String? get elementName {
    if (encodingDate != null) return 'encoding-date';
    if (encoder != null) return 'encoder';
    if (software != null) return 'software';
    if (encodingDescription != null) return 'encoding-description';
    if (supports != null) return 'supports';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (encodingDate != null) return xmlTextElement('encoding-date', encodingDate!);
    if (encoder != null) return encoder!.toXml('encoder');
    if (software != null) return xmlTextElement('software', software!);
    if (encodingDescription != null) return xmlTextElement('encoding-description', encodingDescription!);
    if (supports != null) return supports!.toXml('supports');
    return null;
  }
}

/// The ending type represents multiple (e.g. first and second) endings.
/// Typically, the start type is associated with the left barline of the first
/// measure in an ending. The stop and discontinue types are associated with
/// the right barline of the last measure in an ending. Stop is used when the
/// ending mark concludes with a downward jog, as is typical for first
/// endings. Discontinue is used when there is no downward jog, as is typical
/// for second endings that do not conclude a piece. The length of the jog can
/// be specified using the end-length attribute. The text-x and text-y
/// attributes are offsets that specify where the baseline of the start of the
/// ending text appears, relative to the start of the ending line.
///
/// The number attribute indicates which times the ending is played, similar
/// to the time-only attribute used by other elements. While this often
/// represents the numeric values for what is under the ending line, it can
/// also indicate whether an ending is played during a larger dal segno or da
/// capo repeat. Single endings such as "1" or comma-separated multiple
/// endings such as "1,2" may be used. The ending element text is used when
/// the text displayed in the ending is different than what appears in the
/// number attribute. The print-object attribute is used to indicate when an
/// ending is present but not printed, as is often the case for many parts in
/// a full score.
class Ending {
  Ending({
    required this.value,
    required this.number,
    required this.type,
    this.printObject,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.system,
    this.endLength,
    this.textX,
    this.textY,
  });

  /// Reads an instance from [element].
  factory Ending.fromXml(XmlElement element) =>
      Ending(
        value: element.innerText,
        number: element.getAttribute('number') ?? '',
        type: xmlRequiredValue(StartStopDiscontinue.parse(element.getAttribute('type')), 'type', element),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        system: SystemRelation.parse(element.getAttribute('system')),
        endLength: xmlDouble(element.getAttribute('end-length')),
        textX: xmlDouble(element.getAttribute('text-x')),
        textY: xmlDouble(element.getAttribute('text-y')),
      );

  /// The element's text content.
  String value;

  String number;

  StartStopDiscontinue type;

  YesNo? printObject;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  SystemRelation? system;

  double? endLength;

  double? textX;

  double? textY;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('number', number);
    node.setAttribute('type', type.xmlValue);
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (system != null) {
      node.setAttribute('system', system!.xmlValue);
    }
    if (endLength != null) {
      node.setAttribute('end-length', xmlNumberText(endLength!));
    }
    if (textX != null) {
      node.setAttribute('text-x', xmlNumberText(textX!));
    }
    if (textY != null) {
      node.setAttribute('text-y', xmlNumberText(textY!));
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The extend type represents lyric word extension / melisma lines as well as
/// figured bass extensions. The optional type and position attributes are
/// added in Version 3.0 to provide better formatting control.
class Extend {
  Extend({
    this.type,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
  });

  /// Reads an instance from [element].
  factory Extend.fromXml(XmlElement element) =>
      Extend(
        type: StartStopContinue.parse(element.getAttribute('type')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
      );

  StartStopContinue? type;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (type != null) {
      node.setAttribute('type', type!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    return node;
  }
}

/// The feature type is a part of the grouping element used for musical
/// analysis. The type attribute represents the type of the feature and the
/// element content represents its value. This type is flexible to allow for
/// different analyses.
class Feature {
  Feature({
    required this.value,
    this.type,
  });

  /// Reads an instance from [element].
  factory Feature.fromXml(XmlElement element) =>
      Feature(
        value: element.innerText,
        type: element.getAttribute('type'),
      );

  /// The element's text content.
  String value;

  String? type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (type != null) {
      node.setAttribute('type', type!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The fermata text content represents the shape of the fermata sign. An
/// empty fermata element represents a normal fermata. The fermata type is
/// upright if not specified.
class Fermata {
  Fermata({
    required this.value,
    this.type,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Fermata.fromXml(XmlElement element) =>
      Fermata(
        value: xmlRequiredValue(FermataShape.parse(element.innerText), 'value', element),
        type: UprightInverted.parse(element.getAttribute('type')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  FermataShape value;

  UprightInverted? type;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (type != null) {
      node.setAttribute('type', type!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The figure type represents a single figure within a figured-bass element.
class Figure {
  Figure({
    this.prefix,
    this.figureNumber,
    this.suffix,
    this.extend,
    this.footnote,
    this.level,
  });

  /// Reads an instance from [element].
  factory Figure.fromXml(XmlElement element) =>
      Figure(
        prefix: switch (xmlElement(element, 'prefix')) {
          final child? => StyleText.fromXml(child),
          _ => null,
        },
        figureNumber: switch (xmlElement(element, 'figure-number')) {
          final child? => StyleText.fromXml(child),
          _ => null,
        },
        suffix: switch (xmlElement(element, 'suffix')) {
          final child? => StyleText.fromXml(child),
          _ => null,
        },
        extend: switch (xmlElement(element, 'extend')) {
          final child? => Extend.fromXml(child),
          _ => null,
        },
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
      );

  /// Values for the prefix element include plus and the accidental values
  /// sharp, flat, natural, double-sharp, flat-flat, and sharp-sharp. The
  /// prefix element may contain additional values for symbols specific to
  /// particular figured bass styles.
  StyleText? prefix;

  /// A figure-number is a number. Overstrikes of the figure number are
  /// represented in the suffix element.
  StyleText? figureNumber;

  /// Values for the suffix element include plus and the accidental values
  /// sharp, flat, natural, double-sharp, flat-flat, and sharp-sharp. Suffixes
  /// include both symbols that come after the figure number and those that
  /// overstrike the figure number. The suffix values slash, back-slash, and
  /// vertical are used for slashed numbers indicating chromatic alteration.
  /// The orientation and display of the slash usually depends on the figure
  /// number. The suffix element may contain additional values for symbols
  /// specific to particular figured bass styles.
  StyleText? suffix;

  Extend? extend;

  FormattedText? footnote;

  Level? level;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (prefix != null) {
      node.children.add(prefix!.toXml('prefix'));
    }
    if (figureNumber != null) {
      node.children.add(figureNumber!.toXml('figure-number'));
    }
    if (suffix != null) {
      node.children.add(suffix!.toXml('suffix'));
    }
    if (extend != null) {
      node.children.add(extend!.toXml('extend'));
    }
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    return node;
  }
}

/// The figured-bass element represents figured bass notation. Figured bass
/// elements take their position from the first regular note (not a grace note
/// or chord note) that follows in score order. The optional duration element
/// is used to indicate changes of figures under a note.
///
/// Figures are ordered from top to bottom. The value of parentheses is "no"
/// if not present.
class FiguredBass {
  FiguredBass({
    List<Figure>? figure,
    this.duration,
    this.footnote,
    this.level,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.placement,
    this.printObject,
    this.printDot,
    this.printSpacing,
    this.printLyric,
    this.parentheses,
    this.id,
  })  : figure = figure ?? <Figure>[];

  /// Reads an instance from [element].
  factory FiguredBass.fromXml(XmlElement element) =>
      FiguredBass(
        figure: xmlElements(element, 'figure')
            .map(Figure.fromXml)
            .toList(),
        duration: xmlDouble(xmlElementText(element, 'duration')),
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        printDot: YesNo.parse(element.getAttribute('print-dot')),
        printSpacing: YesNo.parse(element.getAttribute('print-spacing')),
        printLyric: YesNo.parse(element.getAttribute('print-lyric')),
        parentheses: YesNo.parse(element.getAttribute('parentheses')),
        id: element.getAttribute('id'),
      );

  List<Figure> figure;

  /// Duration is a positive number specified in division units. This is the
  /// intended duration vs. notated duration (for instance, differences in
  /// dotted notes in Baroque-era music). Differences in duration specific to
  /// an interpretation or performance should be represented using the note
  /// element's attack and release attributes.
  ///
  /// The duration element moves the musical position when used in backup
  /// elements, forward elements, and note elements that do not contain a
  /// chord child element.
  double? duration;

  FormattedText? footnote;

  Level? level;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  AboveBelow? placement;

  YesNo? printObject;

  YesNo? printDot;

  YesNo? printSpacing;

  YesNo? printLyric;

  YesNo? parentheses;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (printDot != null) {
      node.setAttribute('print-dot', printDot!.xmlValue);
    }
    if (printSpacing != null) {
      node.setAttribute('print-spacing', printSpacing!.xmlValue);
    }
    if (printLyric != null) {
      node.setAttribute('print-lyric', printLyric!.xmlValue);
    }
    if (parentheses != null) {
      node.setAttribute('parentheses', parentheses!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in figure) {
      node.children.add(item.toXml('figure'));
    }
    if (duration != null) {
      node.children.add(xmlTextElement('duration', xmlNumberText(duration!)));
    }
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    return node;
  }
}

/// Fingering is typically indicated 1,2,3,4,5. Multiple fingerings may be
/// given, typically to substitute fingerings in the middle of a note. The
/// substitution and alternate values are "no" if the attribute is not
/// present. For guitar and other fretted instruments, the fingering element
/// represents the fretting finger; the pluck element represents the plucking
/// finger.
class Fingering {
  Fingering({
    required this.value,
    this.substitution,
    this.alternate,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory Fingering.fromXml(XmlElement element) =>
      Fingering(
        value: element.innerText,
        substitution: YesNo.parse(element.getAttribute('substitution')),
        alternate: YesNo.parse(element.getAttribute('alternate')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  String value;

  YesNo? substitution;

  YesNo? alternate;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (substitution != null) {
      node.setAttribute('substitution', substitution!.xmlValue);
    }
    if (alternate != null) {
      node.setAttribute('alternate', alternate!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The first-fret type indicates which fret is shown in the top space of the
/// frame; it is fret 1 if the element is not present. The optional text
/// attribute indicates how this is represented in the fret diagram, while the
/// location attribute indicates whether the text appears to the left or right
/// of the frame.
class FirstFret {
  FirstFret({
    required this.value,
    this.text,
    this.location,
  });

  /// Reads an instance from [element].
  factory FirstFret.fromXml(XmlElement element) =>
      FirstFret(
        value: xmlInt(element.innerText) ?? 0,
        text: element.getAttribute('text'),
        location: LeftRight.parse(element.getAttribute('location')),
      );

  /// The element's text content.
  int value;

  String? text;

  LeftRight? location;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (location != null) {
      node.setAttribute('location', location!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The for-part type is used in a concert score to indicate the transposition
/// for a transposed part created from that score. It is only used in score
/// files that contain a concert-score element in the defaults. This allows
/// concert scores with transposed parts to be represented in a single
/// uncompressed MusicXML file.
///
/// The optional number attribute refers to staff numbers, from top to bottom
/// on the system. If absent, the child elements apply to all staves in the
/// created part.
class ForPart {
  ForPart({
    this.partClef,
    required this.partTranspose,
    this.number,
    this.id,
  });

  /// Reads an instance from [element].
  factory ForPart.fromXml(XmlElement element) =>
      ForPart(
        partClef: switch (xmlElement(element, 'part-clef')) {
          final child? => PartClef.fromXml(child),
          _ => null,
        },
        partTranspose: PartTranspose.fromXml(xmlRequiredElement(element, 'part-transpose')),
        number: xmlInt(element.getAttribute('number')),
        id: element.getAttribute('id'),
      );

  /// The part-clef element is used for transpositions that also include a
  /// change of clef, as for instruments such as bass clarinet.
  PartClef? partClef;

  /// The chromatic element in a part-transpose element will usually have a
  /// non-zero value, since octave transpositions can be represented in
  /// concert scores using the transpose element.
  PartTranspose partTranspose;

  int? number;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (partClef != null) {
      node.children.add(partClef!.toXml('part-clef'));
    }
    node.children.add(partTranspose.toXml('part-transpose'));
    return node;
  }
}

/// The formatted-symbol type represents a SMuFL musical symbol element with
/// formatting attributes.
class FormattedSymbol {
  FormattedSymbol({
    required this.value,
    this.justify,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.underline,
    this.overline,
    this.lineThrough,
    this.rotation,
    this.letterSpacing,
    this.lineHeight,
    this.dir,
    this.enclosure,
  });

  /// Reads an instance from [element].
  factory FormattedSymbol.fromXml(XmlElement element) =>
      FormattedSymbol(
        value: element.innerText,
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        underline: xmlInt(element.getAttribute('underline')),
        overline: xmlInt(element.getAttribute('overline')),
        lineThrough: xmlInt(element.getAttribute('line-through')),
        rotation: xmlDouble(element.getAttribute('rotation')),
        letterSpacing: element.getAttribute('letter-spacing'),
        lineHeight: element.getAttribute('line-height'),
        dir: TextDirection.parse(element.getAttribute('dir')),
        enclosure: EnclosureShape.parse(element.getAttribute('enclosure')),
      );

  /// The element's text content.
  String value;

  LeftCenterRight? justify;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  int? underline;

  int? overline;

  int? lineThrough;

  double? rotation;

  String? letterSpacing;

  String? lineHeight;

  TextDirection? dir;

  EnclosureShape? enclosure;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (underline != null) {
      node.setAttribute('underline', xmlNumberText(underline!));
    }
    if (overline != null) {
      node.setAttribute('overline', xmlNumberText(overline!));
    }
    if (lineThrough != null) {
      node.setAttribute('line-through', xmlNumberText(lineThrough!));
    }
    if (rotation != null) {
      node.setAttribute('rotation', xmlNumberText(rotation!));
    }
    if (letterSpacing != null) {
      node.setAttribute('letter-spacing', letterSpacing!);
    }
    if (lineHeight != null) {
      node.setAttribute('line-height', lineHeight!);
    }
    if (dir != null) {
      node.setAttribute('dir', dir!.xmlValue);
    }
    if (enclosure != null) {
      node.setAttribute('enclosure', enclosure!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The formatted-symbol-id type represents a SMuFL musical symbol element
/// with formatting and id attributes.
class FormattedSymbolId {
  FormattedSymbolId({
    required this.value,
    this.justify,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.underline,
    this.overline,
    this.lineThrough,
    this.rotation,
    this.letterSpacing,
    this.lineHeight,
    this.dir,
    this.enclosure,
    this.id,
  });

  /// Reads an instance from [element].
  factory FormattedSymbolId.fromXml(XmlElement element) =>
      FormattedSymbolId(
        value: element.innerText,
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        underline: xmlInt(element.getAttribute('underline')),
        overline: xmlInt(element.getAttribute('overline')),
        lineThrough: xmlInt(element.getAttribute('line-through')),
        rotation: xmlDouble(element.getAttribute('rotation')),
        letterSpacing: element.getAttribute('letter-spacing'),
        lineHeight: element.getAttribute('line-height'),
        dir: TextDirection.parse(element.getAttribute('dir')),
        enclosure: EnclosureShape.parse(element.getAttribute('enclosure')),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  LeftCenterRight? justify;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  int? underline;

  int? overline;

  int? lineThrough;

  double? rotation;

  String? letterSpacing;

  String? lineHeight;

  TextDirection? dir;

  EnclosureShape? enclosure;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (underline != null) {
      node.setAttribute('underline', xmlNumberText(underline!));
    }
    if (overline != null) {
      node.setAttribute('overline', xmlNumberText(overline!));
    }
    if (lineThrough != null) {
      node.setAttribute('line-through', xmlNumberText(lineThrough!));
    }
    if (rotation != null) {
      node.setAttribute('rotation', xmlNumberText(rotation!));
    }
    if (letterSpacing != null) {
      node.setAttribute('letter-spacing', letterSpacing!);
    }
    if (lineHeight != null) {
      node.setAttribute('line-height', lineHeight!);
    }
    if (dir != null) {
      node.setAttribute('dir', dir!.xmlValue);
    }
    if (enclosure != null) {
      node.setAttribute('enclosure', enclosure!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The formatted-text type represents a text element with text-formatting
/// attributes.
class FormattedText {
  FormattedText({
    required this.value,
    this.justify,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.underline,
    this.overline,
    this.lineThrough,
    this.rotation,
    this.letterSpacing,
    this.lineHeight,
    this.xmlLang,
    this.xmlSpace,
    this.dir,
    this.enclosure,
  });

  /// Reads an instance from [element].
  factory FormattedText.fromXml(XmlElement element) =>
      FormattedText(
        value: element.innerText,
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        underline: xmlInt(element.getAttribute('underline')),
        overline: xmlInt(element.getAttribute('overline')),
        lineThrough: xmlInt(element.getAttribute('line-through')),
        rotation: xmlDouble(element.getAttribute('rotation')),
        letterSpacing: element.getAttribute('letter-spacing'),
        lineHeight: element.getAttribute('line-height'),
        xmlLang: element.getAttribute('xml:lang'),
        xmlSpace: element.getAttribute('xml:space'),
        dir: TextDirection.parse(element.getAttribute('dir')),
        enclosure: EnclosureShape.parse(element.getAttribute('enclosure')),
      );

  /// The element's text content.
  String value;

  LeftCenterRight? justify;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  int? underline;

  int? overline;

  int? lineThrough;

  double? rotation;

  String? letterSpacing;

  String? lineHeight;

  /// The `xml:lang` attribute.
  String? xmlLang;

  /// The `xml:space` attribute.
  String? xmlSpace;

  TextDirection? dir;

  EnclosureShape? enclosure;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (underline != null) {
      node.setAttribute('underline', xmlNumberText(underline!));
    }
    if (overline != null) {
      node.setAttribute('overline', xmlNumberText(overline!));
    }
    if (lineThrough != null) {
      node.setAttribute('line-through', xmlNumberText(lineThrough!));
    }
    if (rotation != null) {
      node.setAttribute('rotation', xmlNumberText(rotation!));
    }
    if (letterSpacing != null) {
      node.setAttribute('letter-spacing', letterSpacing!);
    }
    if (lineHeight != null) {
      node.setAttribute('line-height', lineHeight!);
    }
    if (xmlLang != null) {
      node.setAttribute('xml:lang', xmlLang!);
    }
    if (xmlSpace != null) {
      node.setAttribute('xml:space', xmlSpace!);
    }
    if (dir != null) {
      node.setAttribute('dir', dir!.xmlValue);
    }
    if (enclosure != null) {
      node.setAttribute('enclosure', enclosure!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The formatted-text-id type represents a text element with text-formatting
/// and id attributes.
class FormattedTextId {
  FormattedTextId({
    required this.value,
    this.justify,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.underline,
    this.overline,
    this.lineThrough,
    this.rotation,
    this.letterSpacing,
    this.lineHeight,
    this.xmlLang,
    this.xmlSpace,
    this.dir,
    this.enclosure,
    this.id,
  });

  /// Reads an instance from [element].
  factory FormattedTextId.fromXml(XmlElement element) =>
      FormattedTextId(
        value: element.innerText,
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        underline: xmlInt(element.getAttribute('underline')),
        overline: xmlInt(element.getAttribute('overline')),
        lineThrough: xmlInt(element.getAttribute('line-through')),
        rotation: xmlDouble(element.getAttribute('rotation')),
        letterSpacing: element.getAttribute('letter-spacing'),
        lineHeight: element.getAttribute('line-height'),
        xmlLang: element.getAttribute('xml:lang'),
        xmlSpace: element.getAttribute('xml:space'),
        dir: TextDirection.parse(element.getAttribute('dir')),
        enclosure: EnclosureShape.parse(element.getAttribute('enclosure')),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  LeftCenterRight? justify;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  int? underline;

  int? overline;

  int? lineThrough;

  double? rotation;

  String? letterSpacing;

  String? lineHeight;

  /// The `xml:lang` attribute.
  String? xmlLang;

  /// The `xml:space` attribute.
  String? xmlSpace;

  TextDirection? dir;

  EnclosureShape? enclosure;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (underline != null) {
      node.setAttribute('underline', xmlNumberText(underline!));
    }
    if (overline != null) {
      node.setAttribute('overline', xmlNumberText(overline!));
    }
    if (lineThrough != null) {
      node.setAttribute('line-through', xmlNumberText(lineThrough!));
    }
    if (rotation != null) {
      node.setAttribute('rotation', xmlNumberText(rotation!));
    }
    if (letterSpacing != null) {
      node.setAttribute('letter-spacing', letterSpacing!);
    }
    if (lineHeight != null) {
      node.setAttribute('line-height', lineHeight!);
    }
    if (xmlLang != null) {
      node.setAttribute('xml:lang', xmlLang!);
    }
    if (xmlSpace != null) {
      node.setAttribute('xml:space', xmlSpace!);
    }
    if (dir != null) {
      node.setAttribute('dir', dir!.xmlValue);
    }
    if (enclosure != null) {
      node.setAttribute('enclosure', enclosure!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The backup and forward elements are required to coordinate multiple voices
/// in one part, including music on multiple staves. The forward element is
/// generally used within voices and staves. Duration values should always be
/// positive, and should not cross measure boundaries or mid-measure changes
/// in the divisions value.
class Forward {
  Forward({
    required this.duration,
    this.footnote,
    this.level,
    this.voice,
    this.staff,
  });

  /// Reads an instance from [element].
  factory Forward.fromXml(XmlElement element) =>
      Forward(
        duration: xmlDouble(xmlElementText(element, 'duration')) ?? 0,
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
        voice: xmlElementText(element, 'voice'),
        staff: xmlInt(xmlElementText(element, 'staff')),
      );

  /// Duration is a positive number specified in division units. This is the
  /// intended duration vs. notated duration (for instance, differences in
  /// dotted notes in Baroque-era music). Differences in duration specific to
  /// an interpretation or performance should be represented using the note
  /// element's attack and release attributes.
  ///
  /// The duration element moves the musical position when used in backup
  /// elements, forward elements, and note elements that do not contain a
  /// chord child element.
  double duration;

  FormattedText? footnote;

  Level? level;

  String? voice;

  /// Staff assignment is only needed for music notated on multiple staves.
  /// Used by both notes and directions. Staff values are numbers, with 1
  /// referring to the top-most staff in a part.
  int? staff;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('duration', xmlNumberText(duration)));
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    if (voice != null) {
      node.children.add(xmlTextElement('voice', voice!));
    }
    if (staff != null) {
      node.children.add(xmlTextElement('staff', xmlNumberText(staff!)));
    }
    return node;
  }
}

/// The frame type represents a frame or fretboard diagram used together with
/// a chord symbol. The representation is based on the NIFF guitar grid with
/// additional information. The frame type's unplayed attribute indicates what
/// to display above a string that has no associated frame-note element.
/// Typical values are x and the empty string. If the attribute is not
/// present, the display of the unplayed string is application-defined.
class Frame {
  Frame({
    required this.frameStrings,
    required this.frameFrets,
    this.firstFret,
    List<FrameNote>? frameNote,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
    this.halign,
    this.valign,
    this.height,
    this.width,
    this.unplayed,
    this.id,
  })  : frameNote = frameNote ?? <FrameNote>[];

  /// Reads an instance from [element].
  factory Frame.fromXml(XmlElement element) =>
      Frame(
        frameStrings: xmlInt(xmlElementText(element, 'frame-strings')) ?? 0,
        frameFrets: xmlInt(xmlElementText(element, 'frame-frets')) ?? 0,
        firstFret: switch (xmlElement(element, 'first-fret')) {
          final child? => FirstFret.fromXml(child),
          _ => null,
        },
        frameNote: xmlElements(element, 'frame-note')
            .map(FrameNote.fromXml)
            .toList(),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: ValignImage.parse(element.getAttribute('valign')),
        height: xmlDouble(element.getAttribute('height')),
        width: xmlDouble(element.getAttribute('width')),
        unplayed: element.getAttribute('unplayed'),
        id: element.getAttribute('id'),
      );

  /// The frame-strings element gives the overall size of the frame in
  /// vertical lines (strings).
  int frameStrings;

  /// The frame-frets element gives the overall size of the frame in
  /// horizontal spaces (frets).
  int frameFrets;

  FirstFret? firstFret;

  List<FrameNote> frameNote;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  LeftCenterRight? halign;

  ValignImage? valign;

  double? height;

  double? width;

  String? unplayed;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (height != null) {
      node.setAttribute('height', xmlNumberText(height!));
    }
    if (width != null) {
      node.setAttribute('width', xmlNumberText(width!));
    }
    if (unplayed != null) {
      node.setAttribute('unplayed', unplayed!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(xmlTextElement('frame-strings', xmlNumberText(frameStrings)));
    node.children.add(xmlTextElement('frame-frets', xmlNumberText(frameFrets)));
    if (firstFret != null) {
      node.children.add(firstFret!.toXml('first-fret'));
    }
    for (final item in frameNote) {
      node.children.add(item.toXml('frame-note'));
    }
    return node;
  }
}

/// The frame-note type represents each note included in the frame. An open
/// string will have a fret value of 0, while a muted string will not be
/// associated with a frame-note element.
class FrameNote {
  FrameNote({
    required this.string,
    required this.fret,
    this.fingering,
    this.barre,
  });

  /// Reads an instance from [element].
  factory FrameNote.fromXml(XmlElement element) =>
      FrameNote(
        string: StringElement.fromXml(xmlRequiredElement(element, 'string')),
        fret: Fret.fromXml(xmlRequiredElement(element, 'fret')),
        fingering: switch (xmlElement(element, 'fingering')) {
          final child? => Fingering.fromXml(child),
          _ => null,
        },
        barre: switch (xmlElement(element, 'barre')) {
          final child? => Barre.fromXml(child),
          _ => null,
        },
      );

  StringElement string;

  Fret fret;

  Fingering? fingering;

  Barre? barre;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(string.toXml('string'));
    node.children.add(fret.toXml('fret'));
    if (fingering != null) {
      node.children.add(fingering!.toXml('fingering'));
    }
    if (barre != null) {
      node.children.add(barre!.toXml('barre'));
    }
    return node;
  }
}

/// The fret element is used with tablature notation and chord diagrams. Fret
/// numbers start with 0 for an open string and 1 for the first fret.
class Fret {
  Fret({
    required this.value,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory Fret.fromXml(XmlElement element) =>
      Fret(
        value: xmlInt(element.innerText) ?? 0,
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  int value;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The glass type represents pictograms for glass percussion instruments. The
/// smufl attribute is used to distinguish different SMuFL glyphs for wind
/// chimes in the Chimes pictograms range, including those made of materials
/// other than glass.
class Glass {
  Glass({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Glass.fromXml(XmlElement element) =>
      Glass(
        value: xmlRequiredValue(GlassValue.parse(element.innerText), 'value', element),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  GlassValue value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// Glissando and slide types both indicate rapidly moving from one pitch to
/// the other so that individual notes are not discerned. A glissando sounds
/// the distinct notes in between the two pitches and defaults to a wavy line.
/// The optional text is printed alongside the line.
class Glissando {
  Glissando({
    required this.value,
    required this.type,
    this.number,
    this.lineType,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Glissando.fromXml(XmlElement element) =>
      Glissando(
        value: element.innerText,
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')) ?? 1,
        lineType: LineType.parse(element.getAttribute('line-type')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  StartStop type;

  int? number;

  LineType? lineType;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The glyph element represents what SMuFL glyph should be used for different
/// variations of symbols that are semantically identical. The type attribute
/// specifies what type of glyph is being defined. The element value specifies
/// what SMuFL glyph to use, including recommended stylistic alternates. The
/// SMuFL glyph name should match the type. For instance, a type of
/// quarter-rest would use values restQuarter, restQuarterOld, or
/// restQuarterZ. A type of g-clef-ottava-bassa would use values gClef8vb,
/// gClef8vbOld, or gClef8vbCClef. A type of octave-shift-up-8 would use
/// values ottava, ottavaBassa, ottavaBassaBa, ottavaBassaVb, or octaveBassa.
class Glyph {
  Glyph({
    required this.value,
    required this.type,
  });

  /// Reads an instance from [element].
  factory Glyph.fromXml(XmlElement element) =>
      Glyph(
        value: element.innerText,
        type: element.getAttribute('type') ?? '',
      );

  /// The element's text content.
  String value;

  String type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type);
    node.children.add(XmlText(value));
    return node;
  }
}

/// The grace type indicates the presence of a grace note. The slash attribute
/// for a grace note is yes for slashed grace notes. The steal-time-previous
/// attribute indicates the percentage of time to steal from the previous note
/// for the grace note. The steal-time-following attribute indicates the
/// percentage of time to steal from the following note for the grace note, as
/// for appoggiaturas. The make-time attribute indicates to make time, not
/// steal time; the units are in real-time divisions for the grace note.
class Grace {
  Grace({
    this.stealTimePrevious,
    this.stealTimeFollowing,
    this.makeTime,
    this.slash,
  });

  /// Reads an instance from [element].
  factory Grace.fromXml(XmlElement element) =>
      Grace(
        stealTimePrevious: xmlDouble(element.getAttribute('steal-time-previous')),
        stealTimeFollowing: xmlDouble(element.getAttribute('steal-time-following')),
        makeTime: xmlDouble(element.getAttribute('make-time')),
        slash: YesNo.parse(element.getAttribute('slash')),
      );

  double? stealTimePrevious;

  double? stealTimeFollowing;

  double? makeTime;

  YesNo? slash;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (stealTimePrevious != null) {
      node.setAttribute('steal-time-previous', xmlNumberText(stealTimePrevious!));
    }
    if (stealTimeFollowing != null) {
      node.setAttribute('steal-time-following', xmlNumberText(stealTimeFollowing!));
    }
    if (makeTime != null) {
      node.setAttribute('make-time', xmlNumberText(makeTime!));
    }
    if (slash != null) {
      node.setAttribute('slash', slash!.xmlValue);
    }
    return node;
  }
}

/// The group-barline type indicates if the group should have common barlines.
class GroupBarline {
  GroupBarline({
    required this.value,
    this.color,
  });

  /// Reads an instance from [element].
  factory GroupBarline.fromXml(XmlElement element) =>
      GroupBarline(
        value: xmlRequiredValue(GroupBarlineValue.parse(element.innerText), 'value', element),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  GroupBarlineValue value;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The group-name type describes the name or abbreviation of a part-group
/// element. Formatting attributes in the group-name type are deprecated in
/// Version 2.0 in favor of the new group-name-display and
/// group-abbreviation-display elements.
class GroupName {
  GroupName({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.justify,
  });

  /// Reads an instance from [element].
  factory GroupName.fromXml(XmlElement element) =>
      GroupName(
        value: element.innerText,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
      );

  /// The element's text content.
  String value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? justify;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The group-symbol type indicates how the symbol for a group is indicated in
/// the score. It is none if not specified.
class GroupSymbol {
  GroupSymbol({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
  });

  /// Reads an instance from [element].
  factory GroupSymbol.fromXml(XmlElement element) =>
      GroupSymbol(
        value: xmlRequiredValue(GroupSymbolValue.parse(element.innerText), 'value', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  GroupSymbolValue value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The grouping type is used for musical analysis. When the type attribute is
/// "start" or "single", it usually contains one or more feature elements. The
/// number attribute is used for distinguishing between overlapping and
/// hierarchical groupings. The member-of attribute allows for easy
/// distinguishing of what grouping elements are in what hierarchy. Feature
/// elements contained within a "stop" type of grouping may be ignored.
///
/// This element is flexible to allow for different types of analyses. Future
/// versions of the MusicXML format may add elements that can represent more
/// standardized categories of analysis data, allowing for easier data
/// sharing.
class Grouping {
  Grouping({
    List<Feature>? feature,
    required this.type,
    this.number,
    this.memberOf,
    this.id,
  })  : feature = feature ?? <Feature>[];

  /// Reads an instance from [element].
  factory Grouping.fromXml(XmlElement element) =>
      Grouping(
        feature: xmlElements(element, 'feature')
            .map(Feature.fromXml)
            .toList(),
        type: xmlRequiredValue(StartStopSingle.parse(element.getAttribute('type')), 'type', element),
        number: element.getAttribute('number') ?? '1',
        memberOf: element.getAttribute('member-of'),
        id: element.getAttribute('id'),
      );

  List<Feature> feature;

  StartStopSingle type;

  String? number;

  String? memberOf;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', number!);
    }
    if (memberOf != null) {
      node.setAttribute('member-of', memberOf!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in feature) {
      node.children.add(item.toXml('feature'));
    }
    return node;
  }
}

/// The hammer-on and pull-off elements are used in guitar and fretted
/// instrument notation. Since a single slur can be marked over many notes,
/// the hammer-on and pull-off elements are separate so the individual pair of
/// notes can be specified. The element content can be used to specify how the
/// hammer-on or pull-off should be notated. An empty element leaves this
/// choice up to the application.
class HammerOnPullOff {
  HammerOnPullOff({
    required this.value,
    required this.type,
    this.number,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory HammerOnPullOff.fromXml(XmlElement element) =>
      HammerOnPullOff(
        value: element.innerText,
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')) ?? 1,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  String value;

  StartStop type;

  int? number;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The handbell element represents notation for various techniques used in
/// handbell and handchime music.
class Handbell {
  Handbell({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory Handbell.fromXml(XmlElement element) =>
      Handbell(
        value: xmlRequiredValue(HandbellValue.parse(element.innerText), 'value', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  HandbellValue value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The harmon-closed type represents whether the harmon mute is closed, open,
/// or half-open. The optional location attribute indicates which portion of
/// the symbol is filled in when the element value is half.
class HarmonClosed {
  HarmonClosed({
    required this.value,
    this.location,
  });

  /// Reads an instance from [element].
  factory HarmonClosed.fromXml(XmlElement element) =>
      HarmonClosed(
        value: xmlRequiredValue(HarmonClosedValue.parse(element.innerText), 'value', element),
        location: HarmonClosedLocation.parse(element.getAttribute('location')),
      );

  /// The element's text content.
  HarmonClosedValue value;

  HarmonClosedLocation? location;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (location != null) {
      node.setAttribute('location', location!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The harmon-mute type represents the symbols used for harmon mutes in brass
/// notation.
class HarmonMute {
  HarmonMute({
    required this.harmonClosed,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory HarmonMute.fromXml(XmlElement element) =>
      HarmonMute(
        harmonClosed: HarmonClosed.fromXml(xmlRequiredElement(element, 'harmon-closed')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  HarmonClosed harmonClosed;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(harmonClosed.toXml('harmon-closed'));
    return node;
  }
}

/// The harmonic type indicates natural and artificial harmonics. Allowing the
/// type of pitch to be specified, combined with controls for
/// appearance/playback differences, allows both the notation and the sound to
/// be represented. Artificial harmonics can add a notated touching pitch;
/// artificial pinch harmonics will usually not notate a touching pitch. The
/// attributes for the harmonic element refer to the use of the circular
/// harmonic symbol, typically but not always used with natural harmonics.
class Harmonic {
  Harmonic({
    this.natural,
    this.artificial,
    this.basePitch,
    this.touchingPitch,
    this.soundingPitch,
    this.printObject,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory Harmonic.fromXml(XmlElement element) =>
      Harmonic(
        natural: switch (xmlElement(element, 'natural')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        artificial: switch (xmlElement(element, 'artificial')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        basePitch: switch (xmlElement(element, 'base-pitch')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        touchingPitch: switch (xmlElement(element, 'touching-pitch')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        soundingPitch: switch (xmlElement(element, 'sounding-pitch')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        printObject: YesNo.parse(element.getAttribute('print-object')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The natural element indicates that this is a natural harmonic. These are
  /// usually notated at base pitch rather than sounding pitch.
  Empty? natural;

  /// The artificial element indicates that this is an artificial harmonic.
  Empty? artificial;

  /// The base pitch is the pitch at which the string is played before
  /// touching to create the harmonic.
  Empty? basePitch;

  /// The touching-pitch is the pitch at which the string is touched lightly
  /// to produce the harmonic.
  Empty? touchingPitch;

  /// The sounding-pitch is the pitch which is heard when playing the
  /// harmonic.
  Empty? soundingPitch;

  YesNo? printObject;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (natural != null) {
      node.children.add(natural!.toXml('natural'));
    }
    if (artificial != null) {
      node.children.add(artificial!.toXml('artificial'));
    }
    if (basePitch != null) {
      node.children.add(basePitch!.toXml('base-pitch'));
    }
    if (touchingPitch != null) {
      node.children.add(touchingPitch!.toXml('touching-pitch'));
    }
    if (soundingPitch != null) {
      node.children.add(soundingPitch!.toXml('sounding-pitch'));
    }
    return node;
  }
}

/// The harmony type represents harmony analysis, including chord symbols in
/// popular music as well as functional harmony analysis in classical music.
///
/// If there are alternate harmonies possible, this can be specified using
/// multiple harmony elements differentiated by type. Explicit harmonies have
/// all note present in the music; implied have some notes missing but
/// implied; alternate represents alternate analyses.
///
/// The print-object attribute controls whether or not anything is printed due
/// to the harmony element. The print-frame attribute controls printing of a
/// frame or fretboard diagram. The print-style attribute group sets the
/// default for the harmony, but individual elements can override this with
/// their own print-style values. The arrangement attribute specifies how
/// multiple harmony-chord groups are arranged relative to each other.
/// Harmony-chords with vertical arrangement are separated by horizontal
/// lines. Harmony-chords with diagonal or horizontal arrangement are
/// separated by diagonal lines or slashes.
class Harmony {
  Harmony({
    this.type,
    this.printObject,
    this.printFrame,
    this.arrangement,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.system,
    this.id,
    List<HarmonyItem>? items,
  })  : items = items ?? <HarmonyItem>[];

  /// Reads an instance from [element].
  factory Harmony.fromXml(XmlElement element) =>
      Harmony(
        type: HarmonyType.parse(element.getAttribute('type')),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        printFrame: YesNo.parse(element.getAttribute('print-frame')),
        arrangement: HarmonyArrangement.parse(element.getAttribute('arrangement')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        system: SystemRelation.parse(element.getAttribute('system')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(HarmonyItem.tryFromXml)
            .whereType<HarmonyItem>()
            .toList(),
      );

  HarmonyType? type;

  YesNo? printObject;

  YesNo? printFrame;

  HarmonyArrangement? arrangement;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  SystemRelation? system;

  String? id;

  /// The element content, in document order.
  List<HarmonyItem> items;

  /// Every `root` child, in document order.
  List<Root> get rootElements => [
    for (final item in items)
      if (item.root != null) item.root!,
  ];

  /// Every `numeral` child, in document order.
  List<Numeral> get numeralElements => [
    for (final item in items)
      if (item.numeral != null) item.numeral!,
  ];

  /// Every `function` child, in document order.
  List<StyleText> get functionElements => [
    for (final item in items)
      if (item.function != null) item.function!,
  ];

  /// Every `kind` child, in document order.
  List<Kind> get kindElements => [
    for (final item in items)
      if (item.kind != null) item.kind!,
  ];

  /// Every `inversion` child, in document order.
  List<Inversion> get inversionElements => [
    for (final item in items)
      if (item.inversion != null) item.inversion!,
  ];

  /// Every `bass` child, in document order.
  List<Bass> get bassElements => [
    for (final item in items)
      if (item.bass != null) item.bass!,
  ];

  /// Every `degree` child, in document order.
  List<Degree> get degreeElements => [
    for (final item in items)
      if (item.degree != null) item.degree!,
  ];

  /// Every `frame` child, in document order.
  List<Frame> get frameElements => [
    for (final item in items)
      if (item.frame != null) item.frame!,
  ];

  /// Every `offset` child, in document order.
  List<Offset> get offsetElements => [
    for (final item in items)
      if (item.offset != null) item.offset!,
  ];

  /// Every `footnote` child, in document order.
  List<FormattedText> get footnoteElements => [
    for (final item in items)
      if (item.footnote != null) item.footnote!,
  ];

  /// Every `level` child, in document order.
  List<Level> get levelElements => [
    for (final item in items)
      if (item.level != null) item.level!,
  ];

  /// Every `staff` child, in document order.
  List<int> get staffElements => [
    for (final item in items)
      if (item.staff != null) item.staff!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (type != null) {
      node.setAttribute('type', type!.xmlValue);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (printFrame != null) {
      node.setAttribute('print-frame', printFrame!.xmlValue);
    }
    if (arrangement != null) {
      node.setAttribute('arrangement', arrangement!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (system != null) {
      node.setAttribute('system', system!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// The harmony-alter type represents the chromatic alteration of the root,
/// numeral, or bass of the current harmony-chord group within the harmony
/// element. In some chord styles, the text of the preceding element may
/// include alteration information. In that case, the print-object attribute
/// of this type can be set to no. The location attribute indicates whether
/// the alteration should appear to the left or the right of the preceding
/// element. Its default value varies by element.
class HarmonyAlter {
  HarmonyAlter({
    required this.value,
    this.printObject,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.location,
  });

  /// Reads an instance from [element].
  factory HarmonyAlter.fromXml(XmlElement element) =>
      HarmonyAlter(
        value: xmlDouble(element.innerText) ?? 0,
        printObject: YesNo.parse(element.getAttribute('print-object')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        location: LeftRight.parse(element.getAttribute('location')),
      );

  /// The element's text content.
  double value;

  YesNo? printObject;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftRight? location;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (location != null) {
      node.setAttribute('location', location!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// One child element of `harmony`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class HarmonyItem {
  HarmonyItem({
    this.root,
    this.numeral,
    this.function,
    this.kind,
    this.inversion,
    this.bass,
    this.degree,
    this.frame,
    this.offset,
    this.footnote,
    this.level,
    this.staff,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static HarmonyItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'root':
        return HarmonyItem(root: Root.fromXml(element));
      case 'numeral':
        return HarmonyItem(numeral: Numeral.fromXml(element));
      case 'function':
        return HarmonyItem(function: StyleText.fromXml(element));
      case 'kind':
        return HarmonyItem(kind: Kind.fromXml(element));
      case 'inversion':
        return HarmonyItem(inversion: Inversion.fromXml(element));
      case 'bass':
        return HarmonyItem(bass: Bass.fromXml(element));
      case 'degree':
        return HarmonyItem(degree: Degree.fromXml(element));
      case 'frame':
        return HarmonyItem(frame: Frame.fromXml(element));
      case 'offset':
        return HarmonyItem(offset: Offset.fromXml(element));
      case 'footnote':
        return HarmonyItem(footnote: FormattedText.fromXml(element));
      case 'level':
        return HarmonyItem(level: Level.fromXml(element));
      case 'staff':
        return HarmonyItem(staff: xmlInt(element.innerText) ?? 0);
    }
    return null;
  }

  Root? root;

  Numeral? numeral;

  /// The function element represents classical functional harmony with an
  /// indication like I, II, III rather than C, D, E. It represents the Roman
  /// numeral part of a functional harmony rather than the complete function
  /// itself. It has been deprecated as of MusicXML 4.0 in favor of the
  /// numeral element.
  StyleText? function;

  Kind? kind;

  Inversion? inversion;

  Bass? bass;

  Degree? degree;

  Frame? frame;

  Offset? offset;

  FormattedText? footnote;

  Level? level;

  /// Staff assignment is only needed for music notated on multiple staves.
  /// Used by both notes and directions. Staff values are numbers, with 1
  /// referring to the top-most staff in a part.
  int? staff;

  /// The name of the element this item holds.
  String? get elementName {
    if (root != null) return 'root';
    if (numeral != null) return 'numeral';
    if (function != null) return 'function';
    if (kind != null) return 'kind';
    if (inversion != null) return 'inversion';
    if (bass != null) return 'bass';
    if (degree != null) return 'degree';
    if (frame != null) return 'frame';
    if (offset != null) return 'offset';
    if (footnote != null) return 'footnote';
    if (level != null) return 'level';
    if (staff != null) return 'staff';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (root != null) return root!.toXml('root');
    if (numeral != null) return numeral!.toXml('numeral');
    if (function != null) return function!.toXml('function');
    if (kind != null) return kind!.toXml('kind');
    if (inversion != null) return inversion!.toXml('inversion');
    if (bass != null) return bass!.toXml('bass');
    if (degree != null) return degree!.toXml('degree');
    if (frame != null) return frame!.toXml('frame');
    if (offset != null) return offset!.toXml('offset');
    if (footnote != null) return footnote!.toXml('footnote');
    if (level != null) return level!.toXml('level');
    if (staff != null) return xmlTextElement('staff', xmlNumberText(staff!));
    return null;
  }
}

/// The harp-pedals type is used to create harp pedal diagrams. The pedal-step
/// and pedal-alter elements use the same values as the step and alter
/// elements. For easiest reading, the pedal-tuning elements should follow
/// standard harp pedal order, with pedal-step values of D, C, B, E, F, G, and
/// A.
class HarpPedals {
  HarpPedals({
    List<PedalTuning>? pedalTuning,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
  })  : pedalTuning = pedalTuning ?? <PedalTuning>[];

  /// Reads an instance from [element].
  factory HarpPedals.fromXml(XmlElement element) =>
      HarpPedals(
        pedalTuning: xmlElements(element, 'pedal-tuning')
            .map(PedalTuning.fromXml)
            .toList(),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  List<PedalTuning> pedalTuning;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in pedalTuning) {
      node.children.add(item.toXml('pedal-tuning'));
    }
    return node;
  }
}

/// The heel and toe elements are used with organ pedals. The substitution
/// value is "no" if the attribute is not present.
class HeelToe {
  HeelToe({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.substitution,
  });

  /// Reads an instance from [element].
  factory HeelToe.fromXml(XmlElement element) =>
      HeelToe(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        substitution: YesNo.parse(element.getAttribute('substitution')),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  YesNo? substitution;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (substitution != null) {
      node.setAttribute('substitution', substitution!.xmlValue);
    }
    return node;
  }
}

/// The hole type represents the symbols used for woodwind and brass
/// fingerings as well as other notations.
class Hole {
  Hole({
    this.holeType,
    required this.holeClosed,
    this.holeShape,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory Hole.fromXml(XmlElement element) =>
      Hole(
        holeType: xmlElementText(element, 'hole-type'),
        holeClosed: HoleClosed.fromXml(xmlRequiredElement(element, 'hole-closed')),
        holeShape: xmlElementText(element, 'hole-shape'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The content of the optional hole-type element indicates what the hole
  /// symbol represents in terms of instrument fingering or other techniques.
  String? holeType;

  HoleClosed holeClosed;

  /// The optional hole-shape element indicates the shape of the hole symbol;
  /// the default is a circle.
  String? holeShape;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (holeType != null) {
      node.children.add(xmlTextElement('hole-type', holeType!));
    }
    node.children.add(holeClosed.toXml('hole-closed'));
    if (holeShape != null) {
      node.children.add(xmlTextElement('hole-shape', holeShape!));
    }
    return node;
  }
}

/// The hole-closed type represents whether the hole is closed, open, or
/// half-open. The optional location attribute indicates which portion of the
/// hole is filled in when the element value is half.
class HoleClosed {
  HoleClosed({
    required this.value,
    this.location,
  });

  /// Reads an instance from [element].
  factory HoleClosed.fromXml(XmlElement element) =>
      HoleClosed(
        value: xmlRequiredValue(HoleClosedValue.parse(element.innerText), 'value', element),
        location: HoleClosedLocation.parse(element.getAttribute('location')),
      );

  /// The element's text content.
  HoleClosedValue value;

  HoleClosedLocation? location;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (location != null) {
      node.setAttribute('location', location!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The horizontal-turn type represents turn elements that are horizontal
/// rather than vertical. These are empty elements with print-style,
/// placement, trill-sound, and slash attributes. If the slash attribute is
/// yes, then a vertical line is used to slash the turn. It is no if not
/// specified.
class HorizontalTurn {
  HorizontalTurn({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.startNote,
    this.trillStep,
    this.twoNoteTurn,
    this.accelerate,
    this.beats,
    this.secondBeat,
    this.lastBeat,
    this.slash,
  });

  /// Reads an instance from [element].
  factory HorizontalTurn.fromXml(XmlElement element) =>
      HorizontalTurn(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        startNote: StartNote.parse(element.getAttribute('start-note')),
        trillStep: TrillStep.parse(element.getAttribute('trill-step')),
        twoNoteTurn: TwoNoteTurn.parse(element.getAttribute('two-note-turn')),
        accelerate: YesNo.parse(element.getAttribute('accelerate')),
        beats: xmlDouble(element.getAttribute('beats')),
        secondBeat: xmlDouble(element.getAttribute('second-beat')),
        lastBeat: xmlDouble(element.getAttribute('last-beat')),
        slash: YesNo.parse(element.getAttribute('slash')),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  StartNote? startNote;

  TrillStep? trillStep;

  TwoNoteTurn? twoNoteTurn;

  YesNo? accelerate;

  double? beats;

  double? secondBeat;

  double? lastBeat;

  YesNo? slash;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (startNote != null) {
      node.setAttribute('start-note', startNote!.xmlValue);
    }
    if (trillStep != null) {
      node.setAttribute('trill-step', trillStep!.xmlValue);
    }
    if (twoNoteTurn != null) {
      node.setAttribute('two-note-turn', twoNoteTurn!.xmlValue);
    }
    if (accelerate != null) {
      node.setAttribute('accelerate', accelerate!.xmlValue);
    }
    if (beats != null) {
      node.setAttribute('beats', xmlNumberText(beats!));
    }
    if (secondBeat != null) {
      node.setAttribute('second-beat', xmlNumberText(secondBeat!));
    }
    if (lastBeat != null) {
      node.setAttribute('last-beat', xmlNumberText(lastBeat!));
    }
    if (slash != null) {
      node.setAttribute('slash', slash!.xmlValue);
    }
    return node;
  }
}

/// Identification contains basic metadata about the score. It includes
/// information that may apply at a score-wide, movement-wide, or part-wide
/// level. The creator, rights, source, and relation elements are based on
/// Dublin Core.
class Identification {
  Identification({
    List<TypedText>? creator,
    List<TypedText>? rights,
    this.encoding,
    this.source,
    List<TypedText>? relation,
    this.miscellaneous,
  })  : creator = creator ?? <TypedText>[],
        rights = rights ?? <TypedText>[],
        relation = relation ?? <TypedText>[];

  /// Reads an instance from [element].
  factory Identification.fromXml(XmlElement element) =>
      Identification(
        creator: xmlElements(element, 'creator')
            .map(TypedText.fromXml)
            .toList(),
        rights: xmlElements(element, 'rights')
            .map(TypedText.fromXml)
            .toList(),
        encoding: switch (xmlElement(element, 'encoding')) {
          final child? => Encoding.fromXml(child),
          _ => null,
        },
        source: xmlElementText(element, 'source'),
        relation: xmlElements(element, 'relation')
            .map(TypedText.fromXml)
            .toList(),
        miscellaneous: switch (xmlElement(element, 'miscellaneous')) {
          final child? => Miscellaneous.fromXml(child),
          _ => null,
        },
      );

  /// The creator element is borrowed from Dublin Core. It is used for the
  /// creators of the score. The type attribute is used to distinguish
  /// different creative contributions. Thus, there can be multiple creators
  /// within an identification. Standard type values are composer, lyricist,
  /// and arranger. Other type values may be used for different types of
  /// creative roles. The type attribute should usually be used even if there
  /// is just a single creator element. The MusicXML format does not use the
  /// creator / contributor distinction from Dublin Core.
  List<TypedText> creator;

  /// The rights element is borrowed from Dublin Core. It contains copyright
  /// and other intellectual property notices. Words, music, and derivatives
  /// can have different types, so multiple rights elements with different
  /// type attributes are supported. Standard type values are music, words,
  /// and arrangement, but other types may be used. The type attribute is only
  /// needed when there are multiple rights elements.
  List<TypedText> rights;

  Encoding? encoding;

  /// The source for the music that is encoded. This is similar to the Dublin
  /// Core source element.
  String? source;

  /// A related resource for the music that is encoded. This is similar to the
  /// Dublin Core relation element. Standard type values are music, words, and
  /// arrangement, but other types may be used.
  List<TypedText> relation;

  Miscellaneous? miscellaneous;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in creator) {
      node.children.add(item.toXml('creator'));
    }
    for (final item in rights) {
      node.children.add(item.toXml('rights'));
    }
    if (encoding != null) {
      node.children.add(encoding!.toXml('encoding'));
    }
    if (source != null) {
      node.children.add(xmlTextElement('source', source!));
    }
    for (final item in relation) {
      node.children.add(item.toXml('relation'));
    }
    if (miscellaneous != null) {
      node.children.add(miscellaneous!.toXml('miscellaneous'));
    }
    return node;
  }
}

/// The image type is used to include graphical images in a score.
class Image {
  Image({
    required this.source,
    required this.type,
    this.height,
    this.width,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.halign,
    this.valign,
    this.id,
  });

  /// Reads an instance from [element].
  factory Image.fromXml(XmlElement element) =>
      Image(
        source: element.getAttribute('source') ?? '',
        type: element.getAttribute('type') ?? '',
        height: xmlDouble(element.getAttribute('height')),
        width: xmlDouble(element.getAttribute('width')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: ValignImage.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  String source;

  String type;

  double? height;

  double? width;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  LeftCenterRight? halign;

  ValignImage? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('source', source);
    node.setAttribute('type', type);
    if (height != null) {
      node.setAttribute('height', xmlNumberText(height!));
    }
    if (width != null) {
      node.setAttribute('width', xmlNumberText(width!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The instrument type distinguishes between score-instrument elements in a
/// score-part. The id attribute is an IDREF back to the score-instrument ID.
/// If multiple score-instruments are specified in a score-part, there should
/// be an instrument element for each note in the part. Notes that are shared
/// between multiple score-instruments can have more than one instrument
/// element.
class Instrument {
  Instrument({
    required this.id,
  });

  /// Reads an instance from [element].
  factory Instrument.fromXml(XmlElement element) =>
      Instrument(
        id: element.getAttribute('id') ?? '',
      );

  String id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    return node;
  }
}

/// The instrument-change element type represents a change to the virtual
/// instrument sound for a given score-instrument. The id attribute refers to
/// the score-instrument affected by the change. All instrument-change child
/// elements can also be initially specified within the score-instrument
/// element.
class InstrumentChange {
  InstrumentChange({
    this.instrumentSound,
    this.solo,
    this.ensemble,
    this.virtualInstrument,
    required this.id,
  });

  /// Reads an instance from [element].
  factory InstrumentChange.fromXml(XmlElement element) =>
      InstrumentChange(
        instrumentSound: xmlElementText(element, 'instrument-sound'),
        solo: switch (xmlElement(element, 'solo')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        ensemble: xmlElementText(element, 'ensemble'),
        virtualInstrument: switch (xmlElement(element, 'virtual-instrument')) {
          final child? => VirtualInstrument.fromXml(child),
          _ => null,
        },
        id: element.getAttribute('id') ?? '',
      );

  /// The instrument-sound element describes the default timbre of the
  /// score-instrument. This description is independent of a particular
  /// virtual or MIDI instrument specification and allows playback to be
  /// shared more easily between applications and libraries.
  String? instrumentSound;

  /// The solo element is present if performance is intended by a solo
  /// instrument.
  Empty? solo;

  /// The ensemble element is present if performance is intended by an
  /// ensemble such as an orchestral section. The text of the ensemble element
  /// contains the size of the section, or is empty if the ensemble size is
  /// not specified.
  String? ensemble;

  VirtualInstrument? virtualInstrument;

  String id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    if (instrumentSound != null) {
      node.children.add(xmlTextElement('instrument-sound', instrumentSound!));
    }
    if (solo != null) {
      node.children.add(solo!.toXml('solo'));
    }
    if (ensemble != null) {
      node.children.add(xmlTextElement('ensemble', ensemble!));
    }
    if (virtualInstrument != null) {
      node.children.add(virtualInstrument!.toXml('virtual-instrument'));
    }
    return node;
  }
}

/// Multiple part-link elements can link a condensed part within a score file
/// to multiple MusicXML parts files. For example, a "Clarinet 1 and 2" part
/// in a score file could link to separate "Clarinet 1" and "Clarinet 2" part
/// files. The instrument-link type distinguish which of the score-instruments
/// within a score-part are in which part file. The instrument-link id
/// attribute refers to a score-instrument id attribute.
class InstrumentLink {
  InstrumentLink({
    required this.id,
  });

  /// Reads an instance from [element].
  factory InstrumentLink.fromXml(XmlElement element) =>
      InstrumentLink(
        id: element.getAttribute('id') ?? '',
      );

  String id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    return node;
  }
}

/// The interchangeable type is used to represent the second in a pair of
/// interchangeable dual time signatures, such as the 6/8 in 3/4 (6/8). A
/// separate symbol attribute value is available compared to the time
/// element's symbol attribute, which applies to the first of the dual time
/// signatures.
class Interchangeable {
  Interchangeable({
    this.symbol,
    this.separator,
    List<InterchangeableItem>? items,
  })  : items = items ?? <InterchangeableItem>[];

  /// Reads an instance from [element].
  factory Interchangeable.fromXml(XmlElement element) =>
      Interchangeable(
        symbol: TimeSymbol.parse(element.getAttribute('symbol')),
        separator: TimeSeparator.parse(element.getAttribute('separator')),
        items: xmlChildren(element)
            .map(InterchangeableItem.tryFromXml)
            .whereType<InterchangeableItem>()
            .toList(),
      );

  TimeSymbol? symbol;

  TimeSeparator? separator;

  /// The element content, in document order.
  List<InterchangeableItem> items;

  /// Every `time-relation` child, in document order.
  List<TimeRelation> get timeRelationElements => [
    for (final item in items)
      if (item.timeRelation != null) item.timeRelation!,
  ];

  /// Every `beats` child, in document order.
  List<String> get beatsElements => [
    for (final item in items)
      if (item.beats != null) item.beats!,
  ];

  /// Every `beat-type` child, in document order.
  List<String> get beatTypeElements => [
    for (final item in items)
      if (item.beatType != null) item.beatType!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (symbol != null) {
      node.setAttribute('symbol', symbol!.xmlValue);
    }
    if (separator != null) {
      node.setAttribute('separator', separator!.xmlValue);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `interchangeable`. Exactly one field is set, naming
/// which element it was. Holding the content as a list of these keeps the
/// order the document had, which the music depends on.
class InterchangeableItem {
  InterchangeableItem({
    this.timeRelation,
    this.beats,
    this.beatType,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static InterchangeableItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'time-relation':
        return InterchangeableItem(timeRelation: xmlRequiredValue(TimeRelation.parse(element.innerText), 'time-relation', element));
      case 'beats':
        return InterchangeableItem(beats: element.innerText);
      case 'beat-type':
        return InterchangeableItem(beatType: element.innerText);
    }
    return null;
  }

  TimeRelation? timeRelation;

  /// The beats element indicates the number of beats, as found in the
  /// numerator of a time signature.
  String? beats;

  /// The beat-type element indicates the beat unit, as found in the
  /// denominator of a time signature.
  String? beatType;

  /// The name of the element this item holds.
  String? get elementName {
    if (timeRelation != null) return 'time-relation';
    if (beats != null) return 'beats';
    if (beatType != null) return 'beat-type';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (timeRelation != null) return xmlTextElement('time-relation', timeRelation!.xmlValue);
    if (beats != null) return xmlTextElement('beats', beats!);
    if (beatType != null) return xmlTextElement('beat-type', beatType!);
    return null;
  }
}

/// The inversion type represents harmony inversions. The value is a number
/// indicating which inversion is used: 0 for root position, 1 for first
/// inversion, etc. The text attribute indicates how the inversion should be
/// displayed in a score.
class Inversion {
  Inversion({
    required this.value,
    this.text,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory Inversion.fromXml(XmlElement element) =>
      Inversion(
        value: xmlInt(element.innerText) ?? 0,
        text: element.getAttribute('text'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  int value;

  String? text;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The key type represents a key signature. Both traditional and
/// non-traditional key signatures are supported. The optional number
/// attribute refers to staff numbers. If absent, the key signature applies to
/// all staves in the part. Key signatures appear at the start of each system
/// unless the print-object attribute has been set to "no".
class Key {
  Key({
    this.number,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.printObject,
    this.id,
    List<KeyItem>? items,
  })  : items = items ?? <KeyItem>[];

  /// Reads an instance from [element].
  factory Key.fromXml(XmlElement element) =>
      Key(
        number: xmlInt(element.getAttribute('number')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(KeyItem.tryFromXml)
            .whereType<KeyItem>()
            .toList(),
      );

  int? number;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  YesNo? printObject;

  String? id;

  /// The element content, in document order.
  List<KeyItem> items;

  /// Every `cancel` child, in document order.
  List<Cancel> get cancelElements => [
    for (final item in items)
      if (item.cancel != null) item.cancel!,
  ];

  /// Every `fifths` child, in document order.
  List<int> get fifthsElements => [
    for (final item in items)
      if (item.fifths != null) item.fifths!,
  ];

  /// Every `mode` child, in document order.
  List<String> get modeElements => [
    for (final item in items)
      if (item.mode != null) item.mode!,
  ];

  /// Every `key-step` child, in document order.
  List<Step> get keyStepElements => [
    for (final item in items)
      if (item.keyStep != null) item.keyStep!,
  ];

  /// Every `key-alter` child, in document order.
  List<double> get keyAlterElements => [
    for (final item in items)
      if (item.keyAlter != null) item.keyAlter!,
  ];

  /// Every `key-accidental` child, in document order.
  List<KeyAccidental> get keyAccidentalElements => [
    for (final item in items)
      if (item.keyAccidental != null) item.keyAccidental!,
  ];

  /// Every `key-octave` child, in document order.
  List<KeyOctave> get keyOctaveElements => [
    for (final item in items)
      if (item.keyOctave != null) item.keyOctave!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// The key-accidental type indicates the accidental to be displayed in a
/// non-traditional key signature, represented in the same manner as the
/// accidental type without the formatting attributes.
class KeyAccidental {
  KeyAccidental({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory KeyAccidental.fromXml(XmlElement element) =>
      KeyAccidental(
        value: xmlRequiredValue(AccidentalValue.parse(element.innerText), 'value', element),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  AccidentalValue value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// One child element of `key`. Exactly one field is set, naming which element
/// it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class KeyItem {
  KeyItem({
    this.cancel,
    this.fifths,
    this.mode,
    this.keyStep,
    this.keyAlter,
    this.keyAccidental,
    this.keyOctave,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static KeyItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'cancel':
        return KeyItem(cancel: Cancel.fromXml(element));
      case 'fifths':
        return KeyItem(fifths: xmlInt(element.innerText) ?? 0);
      case 'mode':
        return KeyItem(mode: element.innerText);
      case 'key-step':
        return KeyItem(keyStep: xmlRequiredValue(Step.parse(element.innerText), 'key-step', element));
      case 'key-alter':
        return KeyItem(keyAlter: xmlDouble(element.innerText) ?? 0);
      case 'key-accidental':
        return KeyItem(keyAccidental: KeyAccidental.fromXml(element));
      case 'key-octave':
        return KeyItem(keyOctave: KeyOctave.fromXml(element));
    }
    return null;
  }

  Cancel? cancel;

  int? fifths;

  String? mode;

  /// Non-traditional key signatures are represented using a list of altered
  /// tones. The key-step element indicates the pitch step to be altered,
  /// represented using the same names as in the step element.
  Step? keyStep;

  /// Non-traditional key signatures are represented using a list of altered
  /// tones. The key-alter element represents the alteration for a given pitch
  /// step, represented with semitones in the same manner as the alter
  /// element.
  double? keyAlter;

  /// Non-traditional key signatures are represented using a list of altered
  /// tones. The key-accidental element indicates the accidental to be
  /// displayed in the key signature, represented in the same manner as the
  /// accidental element. It is used for disambiguating microtonal
  /// accidentals.
  KeyAccidental? keyAccidental;

  /// The optional list of key-octave elements is used to specify in which
  /// octave each element of the key signature appears.
  KeyOctave? keyOctave;

  /// The name of the element this item holds.
  String? get elementName {
    if (cancel != null) return 'cancel';
    if (fifths != null) return 'fifths';
    if (mode != null) return 'mode';
    if (keyStep != null) return 'key-step';
    if (keyAlter != null) return 'key-alter';
    if (keyAccidental != null) return 'key-accidental';
    if (keyOctave != null) return 'key-octave';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (cancel != null) return cancel!.toXml('cancel');
    if (fifths != null) return xmlTextElement('fifths', xmlNumberText(fifths!));
    if (mode != null) return xmlTextElement('mode', mode!);
    if (keyStep != null) return xmlTextElement('key-step', keyStep!.xmlValue);
    if (keyAlter != null) return xmlTextElement('key-alter', xmlNumberText(keyAlter!));
    if (keyAccidental != null) return keyAccidental!.toXml('key-accidental');
    if (keyOctave != null) return keyOctave!.toXml('key-octave');
    return null;
  }
}

/// The key-octave type specifies in which octave an element of a key
/// signature appears. The content specifies the octave value using the same
/// values as the display-octave element. The number attribute is a positive
/// integer that refers to the key signature element in left-to-right order.
/// If the cancel attribute is set to yes, then this number refers to the
/// canceling key signature specified by the cancel element in the parent key
/// element. The cancel attribute cannot be set to yes if there is no
/// corresponding cancel element within the parent key element. It is no by
/// default.
class KeyOctave {
  KeyOctave({
    required this.value,
    required this.number,
    this.cancel,
  });

  /// Reads an instance from [element].
  factory KeyOctave.fromXml(XmlElement element) =>
      KeyOctave(
        value: xmlInt(element.innerText) ?? 0,
        number: xmlInt(element.getAttribute('number')) ?? 0,
        cancel: YesNo.parse(element.getAttribute('cancel')),
      );

  /// The element's text content.
  int value;

  int number;

  YesNo? cancel;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('number', xmlNumberText(number));
    if (cancel != null) {
      node.setAttribute('cancel', cancel!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// Kind indicates the type of chord. Degree elements can then add, subtract,
/// or alter from these starting points
///
/// The attributes are used to indicate the formatting of the symbol. Since
/// the kind element is the constant in all the harmony-chord groups that can
/// make up a polychord, many formatting attributes are here.
///
/// The use-symbols attribute is yes if the kind should be represented when
/// possible with harmony symbols rather than letters and numbers. These
/// symbols include:
///
/// major: a triangle, like Unicode 25B3 minor: -, like Unicode 002D
/// augmented: +, like Unicode 002B diminished: °, like Unicode 00B0
/// half-diminished: ø, like Unicode 00F8
///
/// For the major-minor kind, only the minor symbol is used when use-symbols
/// is yes. The major symbol is set using the symbol attribute in the
/// degree-value element. The corresponding degree-alter value will usually be
/// 0 in this case.
///
/// The text attribute describes how the kind should be spelled in a score. If
/// use-symbols is yes, the value of the text attribute follows the symbol.
/// The stack-degrees attribute is yes if the degree elements should be
/// stacked above each other. The parentheses-degrees attribute is yes if all
/// the degrees should be in parentheses. The bracket-degrees attribute is yes
/// if all the degrees should be in a bracket. If not specified, these values
/// are implementation-specific. The alignment attributes are for the entire
/// harmony-chord group of which this kind element is a part.
///
/// The text attribute may use strings such as "13sus" that refer to both the
/// kind and one or more degree elements. In this case, the corresponding
/// degree elements should have the print-object attribute set to "no" to keep
/// redundant alterations from being displayed.
class Kind {
  Kind({
    required this.value,
    this.useSymbols,
    this.text,
    this.stackDegrees,
    this.parenthesesDegrees,
    this.bracketDegrees,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
  });

  /// Reads an instance from [element].
  factory Kind.fromXml(XmlElement element) =>
      Kind(
        value: xmlRequiredValue(KindValue.parse(element.innerText), 'value', element),
        useSymbols: YesNo.parse(element.getAttribute('use-symbols')),
        text: element.getAttribute('text'),
        stackDegrees: YesNo.parse(element.getAttribute('stack-degrees')),
        parenthesesDegrees: YesNo.parse(element.getAttribute('parentheses-degrees')),
        bracketDegrees: YesNo.parse(element.getAttribute('bracket-degrees')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
      );

  /// The element's text content.
  KindValue value;

  YesNo? useSymbols;

  String? text;

  YesNo? stackDegrees;

  YesNo? parenthesesDegrees;

  YesNo? bracketDegrees;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (useSymbols != null) {
      node.setAttribute('use-symbols', useSymbols!.xmlValue);
    }
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (stackDegrees != null) {
      node.setAttribute('stack-degrees', stackDegrees!.xmlValue);
    }
    if (parenthesesDegrees != null) {
      node.setAttribute('parentheses-degrees', parenthesesDegrees!.xmlValue);
    }
    if (bracketDegrees != null) {
      node.setAttribute('bracket-degrees', bracketDegrees!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The level type is used to specify editorial information for different
/// MusicXML elements. The content contains identifying and/or descriptive
/// text about the editorial status of the parent element.
///
/// If the reference attribute is yes, this indicates editorial information
/// that is for display only and should not affect playback. For instance, a
/// modern edition of older music may set reference="yes" on the attributes
/// containing the music's original clef, key, and time signature. It is no if
/// not specified.
///
/// The type attribute indicates whether the editorial information applies to
/// the start of a series of symbols, the end of a series of symbols, or a
/// single symbol. It is single if not specified for compatibility with
/// earlier MusicXML versions.
class Level {
  Level({
    required this.value,
    this.reference,
    this.type,
    this.parentheses,
    this.bracket,
    this.size,
  });

  /// Reads an instance from [element].
  factory Level.fromXml(XmlElement element) =>
      Level(
        value: element.innerText,
        reference: YesNo.parse(element.getAttribute('reference')),
        type: StartStopSingle.parse(element.getAttribute('type')),
        parentheses: YesNo.parse(element.getAttribute('parentheses')),
        bracket: YesNo.parse(element.getAttribute('bracket')),
        size: SymbolSize.parse(element.getAttribute('size')),
      );

  /// The element's text content.
  String value;

  YesNo? reference;

  StartStopSingle? type;

  YesNo? parentheses;

  YesNo? bracket;

  SymbolSize? size;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (reference != null) {
      node.setAttribute('reference', reference!.xmlValue);
    }
    if (type != null) {
      node.setAttribute('type', type!.xmlValue);
    }
    if (parentheses != null) {
      node.setAttribute('parentheses', parentheses!.xmlValue);
    }
    if (bracket != null) {
      node.setAttribute('bracket', bracket!.xmlValue);
    }
    if (size != null) {
      node.setAttribute('size', size!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// If the staff-lines element is present, the appearance of each line may be
/// individually specified with a line-detail type. Staff lines are numbered
/// from bottom to top. The print-object attribute allows lines to be hidden
/// within a staff. This is used in special situations such as a widely-spaced
/// percussion staff where a note placed below the higher line is distinct
/// from a note placed above the lower line. Hidden staff lines are included
/// when specifying clef lines and determining display-step / display-octave
/// values, but are not counted as lines for the purposes of the system-layout
/// and staff-layout elements.
class LineDetail {
  LineDetail({
    required this.line,
    this.width,
    this.color,
    this.lineType,
    this.printObject,
  });

  /// Reads an instance from [element].
  factory LineDetail.fromXml(XmlElement element) =>
      LineDetail(
        line: xmlInt(element.getAttribute('line')) ?? 0,
        width: xmlDouble(element.getAttribute('width')),
        color: element.getAttribute('color'),
        lineType: LineType.parse(element.getAttribute('line-type')),
        printObject: YesNo.parse(element.getAttribute('print-object')),
      );

  int line;

  double? width;

  String? color;

  LineType? lineType;

  YesNo? printObject;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('line', xmlNumberText(line));
    if (width != null) {
      node.setAttribute('width', xmlNumberText(width!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    return node;
  }
}

/// The line-width type indicates the width of a line type in tenths. The type
/// attribute defines what type of line is being defined. Values include beam,
/// bracket, dashes, enclosure, ending, extend, heavy barline, leger, light
/// barline, octave shift, pedal, slur middle, slur tip, staff, stem, tie
/// middle, tie tip, tuplet bracket, and wedge. The text content is expressed
/// in tenths.
class LineWidth {
  LineWidth({
    required this.value,
    required this.type,
  });

  /// Reads an instance from [element].
  factory LineWidth.fromXml(XmlElement element) =>
      LineWidth(
        value: xmlDouble(element.innerText) ?? 0,
        type: element.getAttribute('type') ?? '',
      );

  /// The element's text content.
  double value;

  String type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type);
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The link type serves as an outgoing simple XLink. If a relative link is
/// used within a document that is part of a compressed MusicXML file, the
/// link is relative to the root folder of the zip file.
class Link {
  Link({
    this.xlinkHref,
    this.xlinkType,
    this.xlinkRole,
    this.xlinkTitle,
    this.xlinkShow,
    this.xlinkActuate,
    this.name,
    this.element,
    this.position,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
  });

  /// Reads an instance from [element].
  factory Link.fromXml(XmlElement element) =>
      Link(
        xlinkHref: element.getAttribute('xlink:href'),
        xlinkType: element.getAttribute('xlink:type'),
        xlinkRole: element.getAttribute('xlink:role'),
        xlinkTitle: element.getAttribute('xlink:title'),
        xlinkShow: element.getAttribute('xlink:show'),
        xlinkActuate: element.getAttribute('xlink:actuate'),
        name: element.getAttribute('name'),
        element: element.getAttribute('element'),
        position: xmlInt(element.getAttribute('position')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
      );

  /// The `xlink:href` attribute.
  String? xlinkHref;

  /// The `xlink:type` attribute.
  String? xlinkType;

  /// The `xlink:role` attribute.
  String? xlinkRole;

  /// The `xlink:title` attribute.
  String? xlinkTitle;

  /// The `xlink:show` attribute.
  String? xlinkShow;

  /// The `xlink:actuate` attribute.
  String? xlinkActuate;

  String? name;

  String? element;

  int? position;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (xlinkHref != null) {
      node.setAttribute('xlink:href', xlinkHref!);
    }
    if (xlinkType != null) {
      node.setAttribute('xlink:type', xlinkType!);
    }
    if (xlinkRole != null) {
      node.setAttribute('xlink:role', xlinkRole!);
    }
    if (xlinkTitle != null) {
      node.setAttribute('xlink:title', xlinkTitle!);
    }
    if (xlinkShow != null) {
      node.setAttribute('xlink:show', xlinkShow!);
    }
    if (xlinkActuate != null) {
      node.setAttribute('xlink:actuate', xlinkActuate!);
    }
    if (name != null) {
      node.setAttribute('name', name!);
    }
    if (element != null) {
      node.setAttribute('element', element!);
    }
    if (position != null) {
      node.setAttribute('position', xmlNumberText(position!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    return node;
  }
}

/// The listen and listening types, new in Version 4.0, specify different ways
/// that a score following or machine listening application can interact with
/// a performer. The listen type handles interactions that are specific to a
/// note. If multiple child elements of the same type are present, they should
/// have distinct player and/or time-only attributes.
class Listen {
  Listen({
    List<ListenItem>? items,
  })  : items = items ?? <ListenItem>[];

  /// Reads an instance from [element].
  factory Listen.fromXml(XmlElement element) =>
      Listen(
        items: xmlChildren(element)
            .map(ListenItem.tryFromXml)
            .whereType<ListenItem>()
            .toList(),
      );

  /// The element content, in document order.
  List<ListenItem> items;

  /// Every `assess` child, in document order.
  List<Assess> get assessElements => [
    for (final item in items)
      if (item.assess != null) item.assess!,
  ];

  /// Every `wait` child, in document order.
  List<Wait> get waitElements => [
    for (final item in items)
      if (item.wait != null) item.wait!,
  ];

  /// Every `other-listen` child, in document order.
  List<OtherListening> get otherListenElements => [
    for (final item in items)
      if (item.otherListen != null) item.otherListen!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `listen`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class ListenItem {
  ListenItem({
    this.assess,
    this.wait,
    this.otherListen,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static ListenItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'assess':
        return ListenItem(assess: Assess.fromXml(element));
      case 'wait':
        return ListenItem(wait: Wait.fromXml(element));
      case 'other-listen':
        return ListenItem(otherListen: OtherListening.fromXml(element));
    }
    return null;
  }

  Assess? assess;

  Wait? wait;

  OtherListening? otherListen;

  /// The name of the element this item holds.
  String? get elementName {
    if (assess != null) return 'assess';
    if (wait != null) return 'wait';
    if (otherListen != null) return 'other-listen';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (assess != null) return assess!.toXml('assess');
    if (wait != null) return wait!.toXml('wait');
    if (otherListen != null) return otherListen!.toXml('other-listen');
    return null;
  }
}

/// The listen and listening types, new in Version 4.0, specify different ways
/// that a score following or machine listening application can interact with
/// a performer. The listening type handles interactions that change the state
/// of the listening application from the specified point in the performance
/// onward. If multiple child elements of the same type are present, they
/// should have distinct player and/or time-only attributes.
///
/// The offset element is used to indicate that the listening change takes
/// place offset from the current score position. If the listening element is
/// a child of a direction element, the listening offset element overrides the
/// direction offset element if both elements are present. Note that the
/// offset reflects the intended musical position for the change in state. It
/// should not be used to compensate for latency issues in particular hardware
/// configurations.
class Listening {
  Listening({
    List<ListeningItem>? items,
  })  : items = items ?? <ListeningItem>[];

  /// Reads an instance from [element].
  factory Listening.fromXml(XmlElement element) =>
      Listening(
        items: xmlChildren(element)
            .map(ListeningItem.tryFromXml)
            .whereType<ListeningItem>()
            .toList(),
      );

  /// The element content, in document order.
  List<ListeningItem> items;

  /// Every `sync` child, in document order.
  List<Sync> get syncElements => [
    for (final item in items)
      if (item.sync != null) item.sync!,
  ];

  /// Every `other-listening` child, in document order.
  List<OtherListening> get otherListeningElements => [
    for (final item in items)
      if (item.otherListening != null) item.otherListening!,
  ];

  /// Every `offset` child, in document order.
  List<Offset> get offsetElements => [
    for (final item in items)
      if (item.offset != null) item.offset!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `listening`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class ListeningItem {
  ListeningItem({
    this.sync,
    this.otherListening,
    this.offset,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static ListeningItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'sync':
        return ListeningItem(sync: Sync.fromXml(element));
      case 'other-listening':
        return ListeningItem(otherListening: OtherListening.fromXml(element));
      case 'offset':
        return ListeningItem(offset: Offset.fromXml(element));
    }
    return null;
  }

  Sync? sync;

  OtherListening? otherListening;

  Offset? offset;

  /// The name of the element this item holds.
  String? get elementName {
    if (sync != null) return 'sync';
    if (otherListening != null) return 'other-listening';
    if (offset != null) return 'offset';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (sync != null) return sync!.toXml('sync');
    if (otherListening != null) return otherListening!.toXml('other-listening');
    if (offset != null) return offset!.toXml('offset');
    return null;
  }
}

/// The lyric type represents text underlays for lyrics. Two text elements
/// that are not separated by an elision element are part of the same
/// syllable, but may have different text formatting. The MusicXML XSD is more
/// strict than the DTD in enforcing this by disallowing a second syllabic
/// element unless preceded by an elision element. The lyric number indicates
/// multiple lines, though a name can be used as well. Common name examples
/// are verse and chorus.
///
/// Justification is center by default; placement is below by default.
/// Vertical alignment is to the baseline of the text and horizontal alignment
/// matches justification. The print-object attribute can override a note's
/// print-lyric attribute in cases where only some lyrics on a note are
/// printed, as when lyrics for later verses are printed in a block of text
/// rather than with each note. The time-only attribute precisely specifies
/// which lyrics are to be sung which time through a repeated section.
class Lyric {
  Lyric({
    this.number,
    this.name,
    this.justify,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.placement,
    this.color,
    this.printObject,
    this.timeOnly,
    this.id,
    List<LyricItem>? items,
  })  : items = items ?? <LyricItem>[];

  /// Reads an instance from [element].
  factory Lyric.fromXml(XmlElement element) =>
      Lyric(
        number: element.getAttribute('number'),
        name: element.getAttribute('name'),
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        color: element.getAttribute('color'),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        timeOnly: element.getAttribute('time-only'),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(LyricItem.tryFromXml)
            .whereType<LyricItem>()
            .toList(),
      );

  String? number;

  String? name;

  LeftCenterRight? justify;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  AboveBelow? placement;

  String? color;

  YesNo? printObject;

  String? timeOnly;

  String? id;

  /// The element content, in document order.
  List<LyricItem> items;

  /// Every `syllabic` child, in document order.
  List<Syllabic> get syllabicElements => [
    for (final item in items)
      if (item.syllabic != null) item.syllabic!,
  ];

  /// Every `text` child, in document order.
  List<TextElementData> get textElements => [
    for (final item in items)
      if (item.text != null) item.text!,
  ];

  /// Every `elision` child, in document order.
  List<Elision> get elisionElements => [
    for (final item in items)
      if (item.elision != null) item.elision!,
  ];

  /// Every `extend` child, in document order.
  List<Extend> get extendElements => [
    for (final item in items)
      if (item.extend != null) item.extend!,
  ];

  /// Every `laughing` child, in document order.
  List<Empty> get laughingElements => [
    for (final item in items)
      if (item.laughing != null) item.laughing!,
  ];

  /// Every `humming` child, in document order.
  List<Empty> get hummingElements => [
    for (final item in items)
      if (item.humming != null) item.humming!,
  ];

  /// Every `end-line` child, in document order.
  List<Empty> get endLineElements => [
    for (final item in items)
      if (item.endLine != null) item.endLine!,
  ];

  /// Every `end-paragraph` child, in document order.
  List<Empty> get endParagraphElements => [
    for (final item in items)
      if (item.endParagraph != null) item.endParagraph!,
  ];

  /// Every `footnote` child, in document order.
  List<FormattedText> get footnoteElements => [
    for (final item in items)
      if (item.footnote != null) item.footnote!,
  ];

  /// Every `level` child, in document order.
  List<Level> get levelElements => [
    for (final item in items)
      if (item.level != null) item.level!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', number!);
    }
    if (name != null) {
      node.setAttribute('name', name!);
    }
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// The lyric-font type specifies the default font for a particular name and
/// number of lyric.
class LyricFont {
  LyricFont({
    this.number,
    this.name,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
  });

  /// Reads an instance from [element].
  factory LyricFont.fromXml(XmlElement element) =>
      LyricFont(
        number: element.getAttribute('number'),
        name: element.getAttribute('name'),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
      );

  String? number;

  String? name;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', number!);
    }
    if (name != null) {
      node.setAttribute('name', name!);
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    return node;
  }
}

/// One child element of `lyric`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class LyricItem {
  LyricItem({
    this.syllabic,
    this.text,
    this.elision,
    this.extend,
    this.laughing,
    this.humming,
    this.endLine,
    this.endParagraph,
    this.footnote,
    this.level,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static LyricItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'syllabic':
        return LyricItem(syllabic: xmlRequiredValue(Syllabic.parse(element.innerText), 'syllabic', element));
      case 'text':
        return LyricItem(text: TextElementData.fromXml(element));
      case 'elision':
        return LyricItem(elision: Elision.fromXml(element));
      case 'extend':
        return LyricItem(extend: Extend.fromXml(element));
      case 'laughing':
        return LyricItem(laughing: Empty.fromXml(element));
      case 'humming':
        return LyricItem(humming: Empty.fromXml(element));
      case 'end-line':
        return LyricItem(endLine: Empty.fromXml(element));
      case 'end-paragraph':
        return LyricItem(endParagraph: Empty.fromXml(element));
      case 'footnote':
        return LyricItem(footnote: FormattedText.fromXml(element));
      case 'level':
        return LyricItem(level: Level.fromXml(element));
    }
    return null;
  }

  Syllabic? syllabic;

  TextElementData? text;

  Elision? elision;

  Extend? extend;

  /// The laughing element represents a laughing voice.
  Empty? laughing;

  /// The humming element represents a humming voice.
  Empty? humming;

  /// The end-line element comes from RP-017 for Standard MIDI File Lyric
  /// meta-events. It facilitates lyric display for Karaoke and similar
  /// applications.
  Empty? endLine;

  /// The end-paragraph element comes from RP-017 for Standard MIDI File Lyric
  /// meta-events. It facilitates lyric display for Karaoke and similar
  /// applications.
  Empty? endParagraph;

  FormattedText? footnote;

  Level? level;

  /// The name of the element this item holds.
  String? get elementName {
    if (syllabic != null) return 'syllabic';
    if (text != null) return 'text';
    if (elision != null) return 'elision';
    if (extend != null) return 'extend';
    if (laughing != null) return 'laughing';
    if (humming != null) return 'humming';
    if (endLine != null) return 'end-line';
    if (endParagraph != null) return 'end-paragraph';
    if (footnote != null) return 'footnote';
    if (level != null) return 'level';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (syllabic != null) return xmlTextElement('syllabic', syllabic!.xmlValue);
    if (text != null) return text!.toXml('text');
    if (elision != null) return elision!.toXml('elision');
    if (extend != null) return extend!.toXml('extend');
    if (laughing != null) return laughing!.toXml('laughing');
    if (humming != null) return humming!.toXml('humming');
    if (endLine != null) return endLine!.toXml('end-line');
    if (endParagraph != null) return endParagraph!.toXml('end-paragraph');
    if (footnote != null) return footnote!.toXml('footnote');
    if (level != null) return level!.toXml('level');
    return null;
  }
}

/// The lyric-language type specifies the default language for a particular
/// name and number of lyric.
class LyricLanguage {
  LyricLanguage({
    this.number,
    this.name,
    this.xmlLang,
  });

  /// Reads an instance from [element].
  factory LyricLanguage.fromXml(XmlElement element) =>
      LyricLanguage(
        number: element.getAttribute('number'),
        name: element.getAttribute('name'),
        xmlLang: element.getAttribute('xml:lang'),
      );

  String? number;

  String? name;

  /// The `xml:lang` attribute.
  String? xmlLang;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', number!);
    }
    if (name != null) {
      node.setAttribute('name', name!);
    }
    if (xmlLang != null) {
      node.setAttribute('xml:lang', xmlLang!);
    }
    return node;
  }
}

/// The measure-layout type includes the horizontal distance from the previous
/// measure. It applies to the current measure only.
class MeasureLayout {
  MeasureLayout({
    this.measureDistance,
  });

  /// Reads an instance from [element].
  factory MeasureLayout.fromXml(XmlElement element) =>
      MeasureLayout(
        measureDistance: xmlDouble(xmlElementText(element, 'measure-distance')),
      );

  /// The measure-distance element specifies the horizontal distance from the
  /// previous measure. This value is only used for systems where there is
  /// horizontal whitespace in the middle of a system, as in systems with
  /// codas. To specify the measure width, use the width attribute of the
  /// measure element.
  double? measureDistance;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (measureDistance != null) {
      node.children.add(xmlTextElement('measure-distance', xmlNumberText(measureDistance!)));
    }
    return node;
  }
}

/// The measure-numbering type describes how frequently measure numbers are
/// displayed on this part. The text attribute from the measure element is
/// used for display, or the number attribute if the text attribute is not
/// present. Measures with an implicit attribute set to "yes" never display a
/// measure number, regardless of the measure-numbering setting.
///
/// The optional staff attribute refers to staff numbers within the part, from
/// top to bottom on the system. It indicates which staff is used as the
/// reference point for vertical positioning. A value of 1 is assumed if not
/// present.
///
/// The optional multiple-rest-always and multiple-rest-range attributes
/// describe how measure numbers are shown on multiple rests when the
/// measure-numbering value is not set to none. The multiple-rest-always
/// attribute is set to yes when the measure number should always be shown,
/// even if the multiple rest starts midway through a system when measure
/// numbering is set to system level. The multiple-rest-range attribute is set
/// to yes when measure numbers on multiple rests display the range of numbers
/// for the first and last measure, rather than just the number of the first
/// measure.
class MeasureNumbering {
  MeasureNumbering({
    required this.value,
    this.system,
    this.staff,
    this.multipleRestAlways,
    this.multipleRestRange,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
  });

  /// Reads an instance from [element].
  factory MeasureNumbering.fromXml(XmlElement element) =>
      MeasureNumbering(
        value: xmlRequiredValue(MeasureNumberingValue.parse(element.innerText), 'value', element),
        system: SystemRelationNumber.parse(element.getAttribute('system')),
        staff: xmlInt(element.getAttribute('staff')),
        multipleRestAlways: YesNo.parse(element.getAttribute('multiple-rest-always')),
        multipleRestRange: YesNo.parse(element.getAttribute('multiple-rest-range')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
      );

  /// The element's text content.
  MeasureNumberingValue value;

  SystemRelationNumber? system;

  int? staff;

  YesNo? multipleRestAlways;

  YesNo? multipleRestRange;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (system != null) {
      node.setAttribute('system', system!.xmlValue);
    }
    if (staff != null) {
      node.setAttribute('staff', xmlNumberText(staff!));
    }
    if (multipleRestAlways != null) {
      node.setAttribute('multiple-rest-always', multipleRestAlways!.xmlValue);
    }
    if (multipleRestRange != null) {
      node.setAttribute('multiple-rest-range', multipleRestRange!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The measure-repeat type is used for both single and multiple measure
/// repeats. The text of the element indicates the number of measures to be
/// repeated in a single pattern. The slashes attribute specifies the number
/// of slashes to use in the repeat sign. It is 1 if not specified. The text
/// of the element is ignored when the type is stop.
///
/// The stop type indicates the first measure where the repeats are no longer
/// displayed. Both the start and the stop of the measure-repeat should be
/// specified unless the repeats are displayed through the end of the part.
///
/// The measure-repeat element specifies a notation style for repetitions. The
/// actual music being repeated needs to be repeated within each measure of
/// the MusicXML file. This element specifies the notation that indicates the
/// repeat.
class MeasureRepeat {
  MeasureRepeat({
    required this.value,
    required this.type,
    this.slashes,
  });

  /// Reads an instance from [element].
  factory MeasureRepeat.fromXml(XmlElement element) =>
      MeasureRepeat(
        value: element.innerText,
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        slashes: xmlInt(element.getAttribute('slashes')),
      );

  /// The element's text content.
  String value;

  StartStop type;

  int? slashes;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (slashes != null) {
      node.setAttribute('slashes', xmlNumberText(slashes!));
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// A measure-style indicates a special way to print partial to multiple
/// measures within a part. This includes multiple rests over several
/// measures, repeats of beats, single, or multiple measures, and use of slash
/// notation.
///
/// The multiple-rest and measure-repeat elements indicate the number of
/// measures covered in the element content. The beat-repeat and slash
/// elements can cover partial measures. All but the multiple-rest element use
/// a type attribute to indicate starting and stopping the use of the style.
/// The optional number attribute specifies the staff number from top to
/// bottom on the system, as with clef.
class MeasureStyle {
  MeasureStyle({
    this.multipleRest,
    this.measureRepeat,
    this.beatRepeat,
    this.slash,
    this.number,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory MeasureStyle.fromXml(XmlElement element) =>
      MeasureStyle(
        multipleRest: switch (xmlElement(element, 'multiple-rest')) {
          final child? => MultipleRest.fromXml(child),
          _ => null,
        },
        measureRepeat: switch (xmlElement(element, 'measure-repeat')) {
          final child? => MeasureRepeat.fromXml(child),
          _ => null,
        },
        beatRepeat: switch (xmlElement(element, 'beat-repeat')) {
          final child? => BeatRepeat.fromXml(child),
          _ => null,
        },
        slash: switch (xmlElement(element, 'slash')) {
          final child? => Slash.fromXml(child),
          _ => null,
        },
        number: xmlInt(element.getAttribute('number')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  MultipleRest? multipleRest;

  MeasureRepeat? measureRepeat;

  BeatRepeat? beatRepeat;

  Slash? slash;

  int? number;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (multipleRest != null) {
      node.children.add(multipleRest!.toXml('multiple-rest'));
    }
    if (measureRepeat != null) {
      node.children.add(measureRepeat!.toXml('measure-repeat'));
    }
    if (beatRepeat != null) {
      node.children.add(beatRepeat!.toXml('beat-repeat'));
    }
    if (slash != null) {
      node.children.add(slash!.toXml('slash'));
    }
    return node;
  }
}

/// The membrane type represents pictograms for membrane percussion
/// instruments. The smufl attribute is used to distinguish different SMuFL
/// stylistic alternates.
class Membrane {
  Membrane({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Membrane.fromXml(XmlElement element) =>
      Membrane(
        value: xmlRequiredValue(MembraneValue.parse(element.innerText), 'value', element),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  MembraneValue value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The metal type represents pictograms for metal percussion instruments. The
/// smufl attribute is used to distinguish different SMuFL stylistic
/// alternates.
class Metal {
  Metal({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Metal.fromXml(XmlElement element) =>
      Metal(
        value: xmlRequiredValue(MetalValue.parse(element.innerText), 'value', element),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  MetalValue value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The metronome type represents metronome marks and other metric
/// relationships. The beat-unit group and per-minute element specify regular
/// metronome marks. The metronome-note and metronome-relation elements allow
/// for the specification of metric modulations and other metric
/// relationships, such as swing tempo marks where two eighths are equated to
/// a quarter note / eighth note triplet. Tied notes can be represented in
/// both types of metronome marks by using the beat-unit-tied and
/// metronome-tied elements. The parentheses attribute indicates whether or
/// not to put the metronome mark in parentheses; its value is no if not
/// specified. The print-object attribute is set to no in cases where the
/// metronome element represents a relationship or range that is not displayed
/// in the music notation.
class Metronome {
  Metronome({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.printObject,
    this.justify,
    this.parentheses,
    this.id,
    List<MetronomeItem>? items,
  })  : items = items ?? <MetronomeItem>[];

  /// Reads an instance from [element].
  factory Metronome.fromXml(XmlElement element) =>
      Metronome(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
        parentheses: YesNo.parse(element.getAttribute('parentheses')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(MetronomeItem.tryFromXml)
            .whereType<MetronomeItem>()
            .toList(),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  YesNo? printObject;

  LeftCenterRight? justify;

  YesNo? parentheses;

  String? id;

  /// The element content, in document order.
  List<MetronomeItem> items;

  /// Every `beat-unit` child, in document order.
  List<NoteTypeValue> get beatUnitElements => [
    for (final item in items)
      if (item.beatUnit != null) item.beatUnit!,
  ];

  /// Every `beat-unit-dot` child, in document order.
  List<Empty> get beatUnitDotElements => [
    for (final item in items)
      if (item.beatUnitDot != null) item.beatUnitDot!,
  ];

  /// Every `beat-unit-tied` child, in document order.
  List<BeatUnitTied> get beatUnitTiedElements => [
    for (final item in items)
      if (item.beatUnitTied != null) item.beatUnitTied!,
  ];

  /// Every `per-minute` child, in document order.
  List<PerMinute> get perMinuteElements => [
    for (final item in items)
      if (item.perMinute != null) item.perMinute!,
  ];

  /// Every `metronome-arrows` child, in document order.
  List<Empty> get metronomeArrowsElements => [
    for (final item in items)
      if (item.metronomeArrows != null) item.metronomeArrows!,
  ];

  /// Every `metronome-note` child, in document order.
  List<MetronomeNote> get metronomeNoteElements => [
    for (final item in items)
      if (item.metronomeNote != null) item.metronomeNote!,
  ];

  /// Every `metronome-relation` child, in document order.
  List<String> get metronomeRelationElements => [
    for (final item in items)
      if (item.metronomeRelation != null) item.metronomeRelation!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    if (parentheses != null) {
      node.setAttribute('parentheses', parentheses!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// The metronome-beam type works like the beam type in defining metric
/// relationships, but does not include all the attributes available in the
/// beam type.
class MetronomeBeam {
  MetronomeBeam({
    required this.value,
    this.number,
  });

  /// Reads an instance from [element].
  factory MetronomeBeam.fromXml(XmlElement element) =>
      MetronomeBeam(
        value: xmlRequiredValue(BeamValue.parse(element.innerText), 'value', element),
        number: xmlInt(element.getAttribute('number')) ?? 1,
      );

  /// The element's text content.
  BeamValue value;

  int? number;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// One child element of `metronome`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class MetronomeItem {
  MetronomeItem({
    this.beatUnit,
    this.beatUnitDot,
    this.beatUnitTied,
    this.perMinute,
    this.metronomeArrows,
    this.metronomeNote,
    this.metronomeRelation,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static MetronomeItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'beat-unit':
        return MetronomeItem(beatUnit: xmlRequiredValue(NoteTypeValue.parse(element.innerText), 'beat-unit', element));
      case 'beat-unit-dot':
        return MetronomeItem(beatUnitDot: Empty.fromXml(element));
      case 'beat-unit-tied':
        return MetronomeItem(beatUnitTied: BeatUnitTied.fromXml(element));
      case 'per-minute':
        return MetronomeItem(perMinute: PerMinute.fromXml(element));
      case 'metronome-arrows':
        return MetronomeItem(metronomeArrows: Empty.fromXml(element));
      case 'metronome-note':
        return MetronomeItem(metronomeNote: MetronomeNote.fromXml(element));
      case 'metronome-relation':
        return MetronomeItem(metronomeRelation: element.innerText);
    }
    return null;
  }

  /// The beat-unit element indicates the graphical note type to use in a
  /// metronome mark.
  NoteTypeValue? beatUnit;

  /// The beat-unit-dot element is used to specify any augmentation dots for a
  /// metronome mark note.
  Empty? beatUnitDot;

  BeatUnitTied? beatUnitTied;

  PerMinute? perMinute;

  /// If the metronome-arrows element is present, it indicates that metric
  /// modulation arrows are displayed on both sides of the metronome mark.
  Empty? metronomeArrows;

  MetronomeNote? metronomeNote;

  /// The metronome-relation element describes the relationship symbol that
  /// goes between the two sets of metronome-note elements. The currently
  /// allowed value is equals, but this may expand in future versions. If the
  /// element is empty, the equals value is used.
  String? metronomeRelation;

  /// The name of the element this item holds.
  String? get elementName {
    if (beatUnit != null) return 'beat-unit';
    if (beatUnitDot != null) return 'beat-unit-dot';
    if (beatUnitTied != null) return 'beat-unit-tied';
    if (perMinute != null) return 'per-minute';
    if (metronomeArrows != null) return 'metronome-arrows';
    if (metronomeNote != null) return 'metronome-note';
    if (metronomeRelation != null) return 'metronome-relation';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (beatUnit != null) return xmlTextElement('beat-unit', beatUnit!.xmlValue);
    if (beatUnitDot != null) return beatUnitDot!.toXml('beat-unit-dot');
    if (beatUnitTied != null) return beatUnitTied!.toXml('beat-unit-tied');
    if (perMinute != null) return perMinute!.toXml('per-minute');
    if (metronomeArrows != null) return metronomeArrows!.toXml('metronome-arrows');
    if (metronomeNote != null) return metronomeNote!.toXml('metronome-note');
    if (metronomeRelation != null) return xmlTextElement('metronome-relation', metronomeRelation!);
    return null;
  }
}

/// The metronome-note type defines the appearance of a note within a metric
/// relationship mark.
class MetronomeNote {
  MetronomeNote({
    required this.metronomeType,
    List<Empty>? metronomeDot,
    List<MetronomeBeam>? metronomeBeam,
    this.metronomeTied,
    this.metronomeTuplet,
  })  : metronomeDot = metronomeDot ?? <Empty>[],
        metronomeBeam = metronomeBeam ?? <MetronomeBeam>[];

  /// Reads an instance from [element].
  factory MetronomeNote.fromXml(XmlElement element) =>
      MetronomeNote(
        metronomeType: xmlRequiredValue(NoteTypeValue.parse(xmlElementText(element, 'metronome-type')), 'metronome-type', element),
        metronomeDot: xmlElements(element, 'metronome-dot')
            .map(Empty.fromXml)
            .toList(),
        metronomeBeam: xmlElements(element, 'metronome-beam')
            .map(MetronomeBeam.fromXml)
            .toList(),
        metronomeTied: switch (xmlElement(element, 'metronome-tied')) {
          final child? => MetronomeTied.fromXml(child),
          _ => null,
        },
        metronomeTuplet: switch (xmlElement(element, 'metronome-tuplet')) {
          final child? => MetronomeTuplet.fromXml(child),
          _ => null,
        },
      );

  /// The metronome-type element works like the type element in defining
  /// metric relationships.
  NoteTypeValue metronomeType;

  /// The metronome-dot element works like the dot element in defining metric
  /// relationships.
  List<Empty> metronomeDot;

  List<MetronomeBeam> metronomeBeam;

  MetronomeTied? metronomeTied;

  MetronomeTuplet? metronomeTuplet;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('metronome-type', metronomeType.xmlValue));
    for (final item in metronomeDot) {
      node.children.add(item.toXml('metronome-dot'));
    }
    for (final item in metronomeBeam) {
      node.children.add(item.toXml('metronome-beam'));
    }
    if (metronomeTied != null) {
      node.children.add(metronomeTied!.toXml('metronome-tied'));
    }
    if (metronomeTuplet != null) {
      node.children.add(metronomeTuplet!.toXml('metronome-tuplet'));
    }
    return node;
  }
}

/// The metronome-tied indicates the presence of a tie within a metric
/// relationship mark. As with the tied element, both the start and stop of
/// the tie should be specified, in this case within separate metronome-note
/// elements.
class MetronomeTied {
  MetronomeTied({
    required this.type,
  });

  /// Reads an instance from [element].
  factory MetronomeTied.fromXml(XmlElement element) =>
      MetronomeTied(
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
      );

  StartStop type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    return node;
  }
}

/// The metronome-tuplet type uses the same element structure as the
/// time-modification element along with some attributes from the tuplet
/// element.
class MetronomeTuplet {
  MetronomeTuplet({
    required this.actualNotes,
    required this.normalNotes,
    this.normalType,
    List<Empty>? normalDot,
    required this.type,
    this.bracket,
    this.showNumber,
  })  : normalDot = normalDot ?? <Empty>[];

  /// Reads an instance from [element].
  factory MetronomeTuplet.fromXml(XmlElement element) =>
      MetronomeTuplet(
        actualNotes: xmlInt(xmlElementText(element, 'actual-notes')) ?? 0,
        normalNotes: xmlInt(xmlElementText(element, 'normal-notes')) ?? 0,
        normalType: NoteTypeValue.parse(xmlElementText(element, 'normal-type')),
        normalDot: xmlElements(element, 'normal-dot')
            .map(Empty.fromXml)
            .toList(),
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        bracket: YesNo.parse(element.getAttribute('bracket')),
        showNumber: ShowTuplet.parse(element.getAttribute('show-number')),
      );

  /// The actual-notes element describes how many notes are played in the time
  /// usually occupied by the number in the normal-notes element.
  int actualNotes;

  /// The normal-notes element describes how many notes are usually played in
  /// the time occupied by the number in the actual-notes element.
  int normalNotes;

  /// If the type associated with the number in the normal-notes element is
  /// different than the current note type (e.g., a quarter note within an
  /// eighth note triplet), then the normal-notes type (e.g. eighth) is
  /// specified in the normal-type and normal-dot elements.
  NoteTypeValue? normalType;

  /// The normal-dot element is used to specify dotted normal tuplet types.
  List<Empty> normalDot;

  StartStop type;

  YesNo? bracket;

  ShowTuplet? showNumber;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (bracket != null) {
      node.setAttribute('bracket', bracket!.xmlValue);
    }
    if (showNumber != null) {
      node.setAttribute('show-number', showNumber!.xmlValue);
    }
    node.children.add(xmlTextElement('actual-notes', xmlNumberText(actualNotes)));
    node.children.add(xmlTextElement('normal-notes', xmlNumberText(normalNotes)));
    if (normalType != null) {
      node.children.add(xmlTextElement('normal-type', normalType!.xmlValue));
    }
    for (final item in normalDot) {
      node.children.add(item.toXml('normal-dot'));
    }
    return node;
  }
}

/// The midi-device type corresponds to the DeviceName meta event in Standard
/// MIDI Files. The optional port attribute is a number from 1 to 16 that can
/// be used with the unofficial MIDI 1.0 port (or cable) meta event. Unlike
/// the DeviceName meta event, there can be multiple midi-device elements per
/// MusicXML part. The optional id attribute refers to the score-instrument
/// assigned to this device. If missing, the device assignment affects all
/// score-instrument elements in the score-part.
class MidiDevice {
  MidiDevice({
    required this.value,
    this.port,
    this.id,
  });

  /// Reads an instance from [element].
  factory MidiDevice.fromXml(XmlElement element) =>
      MidiDevice(
        value: element.innerText,
        port: xmlInt(element.getAttribute('port')),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  int? port;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (port != null) {
      node.setAttribute('port', xmlNumberText(port!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The midi-instrument type defines MIDI 1.0 instrument playback. The
/// midi-instrument element can be a part of either the score-instrument
/// element at the start of a part, or the sound element within a part. The id
/// attribute refers to the score-instrument affected by the change.
class MidiInstrument {
  MidiInstrument({
    this.midiChannel,
    this.midiName,
    this.midiBank,
    this.midiProgram,
    this.midiUnpitched,
    this.volume,
    this.pan,
    this.elevation,
    required this.id,
  });

  /// Reads an instance from [element].
  factory MidiInstrument.fromXml(XmlElement element) =>
      MidiInstrument(
        midiChannel: xmlInt(xmlElementText(element, 'midi-channel')),
        midiName: xmlElementText(element, 'midi-name'),
        midiBank: xmlInt(xmlElementText(element, 'midi-bank')),
        midiProgram: xmlInt(xmlElementText(element, 'midi-program')),
        midiUnpitched: xmlInt(xmlElementText(element, 'midi-unpitched')),
        volume: xmlDouble(xmlElementText(element, 'volume')),
        pan: xmlDouble(xmlElementText(element, 'pan')),
        elevation: xmlDouble(xmlElementText(element, 'elevation')),
        id: element.getAttribute('id') ?? '',
      );

  /// The midi-channel element specifies a MIDI 1.0 channel numbers ranging
  /// from 1 to 16.
  int? midiChannel;

  /// The midi-name element corresponds to a ProgramName meta-event within a
  /// Standard MIDI File.
  String? midiName;

  /// The midi-bank element specifies a MIDI 1.0 bank number ranging from 1 to
  /// 16,384.
  int? midiBank;

  /// The midi-program element specifies a MIDI 1.0 program number ranging
  /// from 1 to 128.
  int? midiProgram;

  /// For unpitched instruments, the midi-unpitched element specifies a MIDI
  /// 1.0 note number ranging from 1 to 128. It is usually used with MIDI
  /// banks for percussion. Note that MIDI 1.0 note numbers are generally
  /// specified from 0 to 127 rather than the 1 to 128 numbering used in this
  /// element.
  int? midiUnpitched;

  /// The volume element value is a percentage of the maximum ranging from 0
  /// to 100, with decimal values allowed. This corresponds to a scaling value
  /// for the MIDI 1.0 channel volume controller.
  double? volume;

  /// The pan and elevation elements allow placing of sound in a 3-D space
  /// relative to the listener. Both are expressed in degrees ranging from
  /// -180 to 180. For pan, 0 is straight ahead, -90 is hard left, 90 is hard
  /// right, and -180 and 180 are directly behind the listener.
  double? pan;

  /// The elevation and pan elements allow placing of sound in a 3-D space
  /// relative to the listener. Both are expressed in degrees ranging from
  /// -180 to 180. For elevation, 0 is level with the listener, 90 is directly
  /// above, and -90 is directly below.
  double? elevation;

  String id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    if (midiChannel != null) {
      node.children.add(xmlTextElement('midi-channel', xmlNumberText(midiChannel!)));
    }
    if (midiName != null) {
      node.children.add(xmlTextElement('midi-name', midiName!));
    }
    if (midiBank != null) {
      node.children.add(xmlTextElement('midi-bank', xmlNumberText(midiBank!)));
    }
    if (midiProgram != null) {
      node.children.add(xmlTextElement('midi-program', xmlNumberText(midiProgram!)));
    }
    if (midiUnpitched != null) {
      node.children.add(xmlTextElement('midi-unpitched', xmlNumberText(midiUnpitched!)));
    }
    if (volume != null) {
      node.children.add(xmlTextElement('volume', xmlNumberText(volume!)));
    }
    if (pan != null) {
      node.children.add(xmlTextElement('pan', xmlNumberText(pan!)));
    }
    if (elevation != null) {
      node.children.add(xmlTextElement('elevation', xmlNumberText(elevation!)));
    }
    return node;
  }
}

/// If a program has other metadata not yet supported in the MusicXML format,
/// it can go in the miscellaneous element. The miscellaneous type puts each
/// separate part of metadata into its own miscellaneous-field type.
class Miscellaneous {
  Miscellaneous({
    List<MiscellaneousField>? miscellaneousField,
  })  : miscellaneousField = miscellaneousField ?? <MiscellaneousField>[];

  /// Reads an instance from [element].
  factory Miscellaneous.fromXml(XmlElement element) =>
      Miscellaneous(
        miscellaneousField: xmlElements(element, 'miscellaneous-field')
            .map(MiscellaneousField.fromXml)
            .toList(),
      );

  List<MiscellaneousField> miscellaneousField;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in miscellaneousField) {
      node.children.add(item.toXml('miscellaneous-field'));
    }
    return node;
  }
}

/// If a program has other metadata not yet supported in the MusicXML format,
/// each type of metadata can go in a miscellaneous-field element. The
/// required name attribute indicates the type of metadata the element content
/// represents.
class MiscellaneousField {
  MiscellaneousField({
    required this.value,
    required this.name,
  });

  /// Reads an instance from [element].
  factory MiscellaneousField.fromXml(XmlElement element) =>
      MiscellaneousField(
        value: element.innerText,
        name: element.getAttribute('name') ?? '',
      );

  /// The element's text content.
  String value;

  String name;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('name', name);
    node.children.add(XmlText(value));
    return node;
  }
}

/// The mordent type is used for both represents the mordent sign with the
/// vertical line and the inverted-mordent sign without the line. The long
/// attribute is "no" by default. The approach and departure attributes are
/// used for compound ornaments, indicating how the beginning and ending of
/// the ornament look relative to the main part of the mordent.
class Mordent {
  Mordent({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.startNote,
    this.trillStep,
    this.twoNoteTurn,
    this.accelerate,
    this.beats,
    this.secondBeat,
    this.lastBeat,
    this.long,
    this.approach,
    this.departure,
  });

  /// Reads an instance from [element].
  factory Mordent.fromXml(XmlElement element) =>
      Mordent(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        startNote: StartNote.parse(element.getAttribute('start-note')),
        trillStep: TrillStep.parse(element.getAttribute('trill-step')),
        twoNoteTurn: TwoNoteTurn.parse(element.getAttribute('two-note-turn')),
        accelerate: YesNo.parse(element.getAttribute('accelerate')),
        beats: xmlDouble(element.getAttribute('beats')),
        secondBeat: xmlDouble(element.getAttribute('second-beat')),
        lastBeat: xmlDouble(element.getAttribute('last-beat')),
        long: YesNo.parse(element.getAttribute('long')),
        approach: AboveBelow.parse(element.getAttribute('approach')),
        departure: AboveBelow.parse(element.getAttribute('departure')),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  StartNote? startNote;

  TrillStep? trillStep;

  TwoNoteTurn? twoNoteTurn;

  YesNo? accelerate;

  double? beats;

  double? secondBeat;

  double? lastBeat;

  YesNo? long;

  AboveBelow? approach;

  AboveBelow? departure;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (startNote != null) {
      node.setAttribute('start-note', startNote!.xmlValue);
    }
    if (trillStep != null) {
      node.setAttribute('trill-step', trillStep!.xmlValue);
    }
    if (twoNoteTurn != null) {
      node.setAttribute('two-note-turn', twoNoteTurn!.xmlValue);
    }
    if (accelerate != null) {
      node.setAttribute('accelerate', accelerate!.xmlValue);
    }
    if (beats != null) {
      node.setAttribute('beats', xmlNumberText(beats!));
    }
    if (secondBeat != null) {
      node.setAttribute('second-beat', xmlNumberText(secondBeat!));
    }
    if (lastBeat != null) {
      node.setAttribute('last-beat', xmlNumberText(lastBeat!));
    }
    if (long != null) {
      node.setAttribute('long', long!.xmlValue);
    }
    if (approach != null) {
      node.setAttribute('approach', approach!.xmlValue);
    }
    if (departure != null) {
      node.setAttribute('departure', departure!.xmlValue);
    }
    return node;
  }
}

/// The text of the multiple-rest type indicates the number of measures in the
/// multiple rest. Multiple rests may use the 1-bar / 2-bar / 4-bar rest
/// symbols, or a single shape. The use-symbols attribute indicates which to
/// use; it is no if not specified.
class MultipleRest {
  MultipleRest({
    required this.value,
    this.useSymbols,
  });

  /// Reads an instance from [element].
  factory MultipleRest.fromXml(XmlElement element) =>
      MultipleRest(
        value: xmlInt(element.innerText) ?? 0,
        useSymbols: YesNo.parse(element.getAttribute('use-symbols')),
      );

  /// The element's text content.
  int value;

  YesNo? useSymbols;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (useSymbols != null) {
      node.setAttribute('use-symbols', useSymbols!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// One child element of `music-data`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class MusicDataItem {
  MusicDataItem({
    this.note,
    this.backup,
    this.forward,
    this.direction,
    this.attributes,
    this.harmony,
    this.figuredBass,
    this.print,
    this.sound,
    this.listening,
    this.barline,
    this.grouping,
    this.link,
    this.bookmark,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static MusicDataItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'note':
        return MusicDataItem(note: Note.fromXml(element));
      case 'backup':
        return MusicDataItem(backup: Backup.fromXml(element));
      case 'forward':
        return MusicDataItem(forward: Forward.fromXml(element));
      case 'direction':
        return MusicDataItem(direction: Direction.fromXml(element));
      case 'attributes':
        return MusicDataItem(attributes: Attributes.fromXml(element));
      case 'harmony':
        return MusicDataItem(harmony: Harmony.fromXml(element));
      case 'figured-bass':
        return MusicDataItem(figuredBass: FiguredBass.fromXml(element));
      case 'print':
        return MusicDataItem(print: Print.fromXml(element));
      case 'sound':
        return MusicDataItem(sound: Sound.fromXml(element));
      case 'listening':
        return MusicDataItem(listening: Listening.fromXml(element));
      case 'barline':
        return MusicDataItem(barline: Barline.fromXml(element));
      case 'grouping':
        return MusicDataItem(grouping: Grouping.fromXml(element));
      case 'link':
        return MusicDataItem(link: Link.fromXml(element));
      case 'bookmark':
        return MusicDataItem(bookmark: Bookmark.fromXml(element));
    }
    return null;
  }

  Note? note;

  Backup? backup;

  Forward? forward;

  Direction? direction;

  Attributes? attributes;

  Harmony? harmony;

  FiguredBass? figuredBass;

  Print? print;

  Sound? sound;

  Listening? listening;

  Barline? barline;

  Grouping? grouping;

  Link? link;

  Bookmark? bookmark;

  /// The name of the element this item holds.
  String? get elementName {
    if (note != null) return 'note';
    if (backup != null) return 'backup';
    if (forward != null) return 'forward';
    if (direction != null) return 'direction';
    if (attributes != null) return 'attributes';
    if (harmony != null) return 'harmony';
    if (figuredBass != null) return 'figured-bass';
    if (print != null) return 'print';
    if (sound != null) return 'sound';
    if (listening != null) return 'listening';
    if (barline != null) return 'barline';
    if (grouping != null) return 'grouping';
    if (link != null) return 'link';
    if (bookmark != null) return 'bookmark';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (note != null) return note!.toXml('note');
    if (backup != null) return backup!.toXml('backup');
    if (forward != null) return forward!.toXml('forward');
    if (direction != null) return direction!.toXml('direction');
    if (attributes != null) return attributes!.toXml('attributes');
    if (harmony != null) return harmony!.toXml('harmony');
    if (figuredBass != null) return figuredBass!.toXml('figured-bass');
    if (print != null) return print!.toXml('print');
    if (sound != null) return sound!.toXml('sound');
    if (listening != null) return listening!.toXml('listening');
    if (barline != null) return barline!.toXml('barline');
    if (grouping != null) return grouping!.toXml('grouping');
    if (link != null) return link!.toXml('link');
    if (bookmark != null) return bookmark!.toXml('bookmark');
    return null;
  }
}

/// The name-display type is used for exact formatting of multi-font text in
/// part and group names to the left of the system. The print-object attribute
/// can be used to determine what, if anything, is printed at the start of
/// each system. Enclosure for the display-text element is none by default.
/// Language for the display-text element is Italian ("it") by default.
class NameDisplay {
  NameDisplay({
    this.printObject,
    List<NameDisplayItem>? items,
  })  : items = items ?? <NameDisplayItem>[];

  /// Reads an instance from [element].
  factory NameDisplay.fromXml(XmlElement element) =>
      NameDisplay(
        printObject: YesNo.parse(element.getAttribute('print-object')),
        items: xmlChildren(element)
            .map(NameDisplayItem.tryFromXml)
            .whereType<NameDisplayItem>()
            .toList(),
      );

  YesNo? printObject;

  /// The element content, in document order.
  List<NameDisplayItem> items;

  /// Every `display-text` child, in document order.
  List<FormattedText> get displayTextElements => [
    for (final item in items)
      if (item.displayText != null) item.displayText!,
  ];

  /// Every `accidental-text` child, in document order.
  List<AccidentalText> get accidentalTextElements => [
    for (final item in items)
      if (item.accidentalText != null) item.accidentalText!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `name-display`. Exactly one field is set, naming
/// which element it was. Holding the content as a list of these keeps the
/// order the document had, which the music depends on.
class NameDisplayItem {
  NameDisplayItem({
    this.displayText,
    this.accidentalText,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static NameDisplayItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'display-text':
        return NameDisplayItem(displayText: FormattedText.fromXml(element));
      case 'accidental-text':
        return NameDisplayItem(accidentalText: AccidentalText.fromXml(element));
    }
    return null;
  }

  FormattedText? displayText;

  AccidentalText? accidentalText;

  /// The name of the element this item holds.
  String? get elementName {
    if (displayText != null) return 'display-text';
    if (accidentalText != null) return 'accidental-text';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (displayText != null) return displayText!.toXml('display-text');
    if (accidentalText != null) return accidentalText!.toXml('accidental-text');
    return null;
  }
}

/// The non-arpeggiate type indicates that this note is at the top or bottom
/// of a bracket indicating to not arpeggiate these notes. Since this does not
/// involve playback, it is only used on the top or bottom notes, not on each
/// note as for the arpeggiate type.
class NonArpeggiate {
  NonArpeggiate({
    required this.type,
    this.number,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.placement,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory NonArpeggiate.fromXml(XmlElement element) =>
      NonArpeggiate(
        type: xmlRequiredValue(TopBottom.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  TopBottom type;

  int? number;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  AboveBelow? placement;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// Notations refer to musical notations, not XML notations. Multiple
/// notations are allowed in order to represent multiple editorial levels. The
/// print-object attribute, added in Version 3.0, allows notations to
/// represent details of performance technique, such as fingerings, without
/// having them appear in the score.
class Notations {
  Notations({
    this.printObject,
    this.id,
    List<NotationsItem>? items,
  })  : items = items ?? <NotationsItem>[];

  /// Reads an instance from [element].
  factory Notations.fromXml(XmlElement element) =>
      Notations(
        printObject: YesNo.parse(element.getAttribute('print-object')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(NotationsItem.tryFromXml)
            .whereType<NotationsItem>()
            .toList(),
      );

  YesNo? printObject;

  String? id;

  /// The element content, in document order.
  List<NotationsItem> items;

  /// Every `footnote` child, in document order.
  List<FormattedText> get footnoteElements => [
    for (final item in items)
      if (item.footnote != null) item.footnote!,
  ];

  /// Every `level` child, in document order.
  List<Level> get levelElements => [
    for (final item in items)
      if (item.level != null) item.level!,
  ];

  /// Every `tied` child, in document order.
  List<Tied> get tiedElements => [
    for (final item in items)
      if (item.tied != null) item.tied!,
  ];

  /// Every `slur` child, in document order.
  List<Slur> get slurElements => [
    for (final item in items)
      if (item.slur != null) item.slur!,
  ];

  /// Every `tuplet` child, in document order.
  List<Tuplet> get tupletElements => [
    for (final item in items)
      if (item.tuplet != null) item.tuplet!,
  ];

  /// Every `glissando` child, in document order.
  List<Glissando> get glissandoElements => [
    for (final item in items)
      if (item.glissando != null) item.glissando!,
  ];

  /// Every `slide` child, in document order.
  List<Slide> get slideElements => [
    for (final item in items)
      if (item.slide != null) item.slide!,
  ];

  /// Every `ornaments` child, in document order.
  List<Ornaments> get ornamentsElements => [
    for (final item in items)
      if (item.ornaments != null) item.ornaments!,
  ];

  /// Every `technical` child, in document order.
  List<Technical> get technicalElements => [
    for (final item in items)
      if (item.technical != null) item.technical!,
  ];

  /// Every `articulations` child, in document order.
  List<Articulations> get articulationsElements => [
    for (final item in items)
      if (item.articulations != null) item.articulations!,
  ];

  /// Every `dynamics` child, in document order.
  List<Dynamics> get dynamicsElements => [
    for (final item in items)
      if (item.dynamics != null) item.dynamics!,
  ];

  /// Every `fermata` child, in document order.
  List<Fermata> get fermataElements => [
    for (final item in items)
      if (item.fermata != null) item.fermata!,
  ];

  /// Every `arpeggiate` child, in document order.
  List<Arpeggiate> get arpeggiateElements => [
    for (final item in items)
      if (item.arpeggiate != null) item.arpeggiate!,
  ];

  /// Every `non-arpeggiate` child, in document order.
  List<NonArpeggiate> get nonArpeggiateElements => [
    for (final item in items)
      if (item.nonArpeggiate != null) item.nonArpeggiate!,
  ];

  /// Every `accidental-mark` child, in document order.
  List<AccidentalMark> get accidentalMarkElements => [
    for (final item in items)
      if (item.accidentalMark != null) item.accidentalMark!,
  ];

  /// Every `other-notation` child, in document order.
  List<OtherNotation> get otherNotationElements => [
    for (final item in items)
      if (item.otherNotation != null) item.otherNotation!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `notations`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class NotationsItem {
  NotationsItem({
    this.footnote,
    this.level,
    this.tied,
    this.slur,
    this.tuplet,
    this.glissando,
    this.slide,
    this.ornaments,
    this.technical,
    this.articulations,
    this.dynamics,
    this.fermata,
    this.arpeggiate,
    this.nonArpeggiate,
    this.accidentalMark,
    this.otherNotation,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static NotationsItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'footnote':
        return NotationsItem(footnote: FormattedText.fromXml(element));
      case 'level':
        return NotationsItem(level: Level.fromXml(element));
      case 'tied':
        return NotationsItem(tied: Tied.fromXml(element));
      case 'slur':
        return NotationsItem(slur: Slur.fromXml(element));
      case 'tuplet':
        return NotationsItem(tuplet: Tuplet.fromXml(element));
      case 'glissando':
        return NotationsItem(glissando: Glissando.fromXml(element));
      case 'slide':
        return NotationsItem(slide: Slide.fromXml(element));
      case 'ornaments':
        return NotationsItem(ornaments: Ornaments.fromXml(element));
      case 'technical':
        return NotationsItem(technical: Technical.fromXml(element));
      case 'articulations':
        return NotationsItem(articulations: Articulations.fromXml(element));
      case 'dynamics':
        return NotationsItem(dynamics: Dynamics.fromXml(element));
      case 'fermata':
        return NotationsItem(fermata: Fermata.fromXml(element));
      case 'arpeggiate':
        return NotationsItem(arpeggiate: Arpeggiate.fromXml(element));
      case 'non-arpeggiate':
        return NotationsItem(nonArpeggiate: NonArpeggiate.fromXml(element));
      case 'accidental-mark':
        return NotationsItem(accidentalMark: AccidentalMark.fromXml(element));
      case 'other-notation':
        return NotationsItem(otherNotation: OtherNotation.fromXml(element));
    }
    return null;
  }

  FormattedText? footnote;

  Level? level;

  Tied? tied;

  Slur? slur;

  Tuplet? tuplet;

  Glissando? glissando;

  Slide? slide;

  Ornaments? ornaments;

  Technical? technical;

  Articulations? articulations;

  Dynamics? dynamics;

  Fermata? fermata;

  Arpeggiate? arpeggiate;

  NonArpeggiate? nonArpeggiate;

  AccidentalMark? accidentalMark;

  OtherNotation? otherNotation;

  /// The name of the element this item holds.
  String? get elementName {
    if (footnote != null) return 'footnote';
    if (level != null) return 'level';
    if (tied != null) return 'tied';
    if (slur != null) return 'slur';
    if (tuplet != null) return 'tuplet';
    if (glissando != null) return 'glissando';
    if (slide != null) return 'slide';
    if (ornaments != null) return 'ornaments';
    if (technical != null) return 'technical';
    if (articulations != null) return 'articulations';
    if (dynamics != null) return 'dynamics';
    if (fermata != null) return 'fermata';
    if (arpeggiate != null) return 'arpeggiate';
    if (nonArpeggiate != null) return 'non-arpeggiate';
    if (accidentalMark != null) return 'accidental-mark';
    if (otherNotation != null) return 'other-notation';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (footnote != null) return footnote!.toXml('footnote');
    if (level != null) return level!.toXml('level');
    if (tied != null) return tied!.toXml('tied');
    if (slur != null) return slur!.toXml('slur');
    if (tuplet != null) return tuplet!.toXml('tuplet');
    if (glissando != null) return glissando!.toXml('glissando');
    if (slide != null) return slide!.toXml('slide');
    if (ornaments != null) return ornaments!.toXml('ornaments');
    if (technical != null) return technical!.toXml('technical');
    if (articulations != null) return articulations!.toXml('articulations');
    if (dynamics != null) return dynamics!.toXml('dynamics');
    if (fermata != null) return fermata!.toXml('fermata');
    if (arpeggiate != null) return arpeggiate!.toXml('arpeggiate');
    if (nonArpeggiate != null) return nonArpeggiate!.toXml('non-arpeggiate');
    if (accidentalMark != null) return accidentalMark!.toXml('accidental-mark');
    if (otherNotation != null) return otherNotation!.toXml('other-notation');
    return null;
  }
}

/// Notes are the most common type of MusicXML data. The MusicXML format
/// distinguishes between elements used for sound information and elements
/// used for notation information (e.g., tie is used for sound, tied for
/// notation). Thus grace notes do not have a duration element. Cue notes have
/// a duration element, as do forward elements, but no tie elements. Having
/// these two types of information available can make interchange easier, as
/// some programs handle one type of information more readily than the other.
///
/// The print-leger attribute is used to indicate whether leger lines are
/// printed. Notes without leger lines are used to indicate indeterminate high
/// and low notes. By default, it is set to yes. If print-object is set to no,
/// print-leger is interpreted to also be set to no if not present. This
/// attribute is ignored for rests.
///
/// The dynamics and end-dynamics attributes correspond to MIDI 1.0's Note On
/// and Note Off velocities, respectively. They are expressed in terms of
/// percentages of the default forte value (90 for MIDI 1.0).
///
/// The attack and release attributes are used to alter the starting and
/// stopping time of the note from when it would otherwise occur based on the
/// flow of durations - information that is specific to a performance. They
/// are expressed in terms of divisions, either positive or negative. A note
/// that starts a tie should not have a release attribute, and a note that
/// stops a tie should not have an attack attribute. The attack and release
/// attributes are independent of each other. The attack attribute only
/// changes the starting time of a note, and the release attribute only
/// changes the stopping time of a note.
///
/// If a note is played only particular times through a repeat, the time-only
/// attribute shows which times to play the note.
///
/// The pizzicato attribute is used when just this note is sounded pizzicato,
/// vs. the pizzicato element which changes overall playback between pizzicato
/// and arco.
class Note {
  Note({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.printObject,
    this.printDot,
    this.printSpacing,
    this.printLyric,
    this.printLeger,
    this.dynamics,
    this.endDynamics,
    this.attack,
    this.release,
    this.timeOnly,
    this.pizzicato,
    this.id,
    List<NoteItem>? items,
  })  : items = items ?? <NoteItem>[];

  /// Reads an instance from [element].
  factory Note.fromXml(XmlElement element) =>
      Note(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        printDot: YesNo.parse(element.getAttribute('print-dot')),
        printSpacing: YesNo.parse(element.getAttribute('print-spacing')),
        printLyric: YesNo.parse(element.getAttribute('print-lyric')),
        printLeger: YesNo.parse(element.getAttribute('print-leger')),
        dynamics: xmlDouble(element.getAttribute('dynamics')),
        endDynamics: xmlDouble(element.getAttribute('end-dynamics')),
        attack: xmlDouble(element.getAttribute('attack')),
        release: xmlDouble(element.getAttribute('release')),
        timeOnly: element.getAttribute('time-only'),
        pizzicato: YesNo.parse(element.getAttribute('pizzicato')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(NoteItem.tryFromXml)
            .whereType<NoteItem>()
            .toList(),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  YesNo? printObject;

  YesNo? printDot;

  YesNo? printSpacing;

  YesNo? printLyric;

  YesNo? printLeger;

  double? dynamics;

  double? endDynamics;

  double? attack;

  double? release;

  String? timeOnly;

  YesNo? pizzicato;

  String? id;

  /// The element content, in document order.
  List<NoteItem> items;

  /// Every `grace` child, in document order.
  List<Grace> get graceElements => [
    for (final item in items)
      if (item.grace != null) item.grace!,
  ];

  /// Every `chord` child, in document order.
  List<Empty> get chordElements => [
    for (final item in items)
      if (item.chord != null) item.chord!,
  ];

  /// Every `pitch` child, in document order.
  List<Pitch> get pitchElements => [
    for (final item in items)
      if (item.pitch != null) item.pitch!,
  ];

  /// Every `unpitched` child, in document order.
  List<Unpitched> get unpitchedElements => [
    for (final item in items)
      if (item.unpitched != null) item.unpitched!,
  ];

  /// Every `rest` child, in document order.
  List<Rest> get restElements => [
    for (final item in items)
      if (item.rest != null) item.rest!,
  ];

  /// Every `tie` child, in document order.
  List<Tie> get tieElements => [
    for (final item in items)
      if (item.tie != null) item.tie!,
  ];

  /// Every `cue` child, in document order.
  List<Empty> get cueElements => [
    for (final item in items)
      if (item.cue != null) item.cue!,
  ];

  /// Every `duration` child, in document order.
  List<double> get durationElements => [
    for (final item in items)
      if (item.duration != null) item.duration!,
  ];

  /// Every `instrument` child, in document order.
  List<Instrument> get instrumentElements => [
    for (final item in items)
      if (item.instrument != null) item.instrument!,
  ];

  /// Every `footnote` child, in document order.
  List<FormattedText> get footnoteElements => [
    for (final item in items)
      if (item.footnote != null) item.footnote!,
  ];

  /// Every `level` child, in document order.
  List<Level> get levelElements => [
    for (final item in items)
      if (item.level != null) item.level!,
  ];

  /// Every `voice` child, in document order.
  List<String> get voiceElements => [
    for (final item in items)
      if (item.voice != null) item.voice!,
  ];

  /// Every `type` child, in document order.
  List<NoteType> get typeElements => [
    for (final item in items)
      if (item.type != null) item.type!,
  ];

  /// Every `dot` child, in document order.
  List<EmptyPlacement> get dotElements => [
    for (final item in items)
      if (item.dot != null) item.dot!,
  ];

  /// Every `accidental` child, in document order.
  List<Accidental> get accidentalElements => [
    for (final item in items)
      if (item.accidental != null) item.accidental!,
  ];

  /// Every `time-modification` child, in document order.
  List<TimeModification> get timeModificationElements => [
    for (final item in items)
      if (item.timeModification != null) item.timeModification!,
  ];

  /// Every `stem` child, in document order.
  List<Stem> get stemElements => [
    for (final item in items)
      if (item.stem != null) item.stem!,
  ];

  /// Every `notehead` child, in document order.
  List<Notehead> get noteheadElements => [
    for (final item in items)
      if (item.notehead != null) item.notehead!,
  ];

  /// Every `notehead-text` child, in document order.
  List<NoteheadText> get noteheadTextElements => [
    for (final item in items)
      if (item.noteheadText != null) item.noteheadText!,
  ];

  /// Every `staff` child, in document order.
  List<int> get staffElements => [
    for (final item in items)
      if (item.staff != null) item.staff!,
  ];

  /// Every `beam` child, in document order.
  List<Beam> get beamElements => [
    for (final item in items)
      if (item.beam != null) item.beam!,
  ];

  /// Every `notations` child, in document order.
  List<Notations> get notationsElements => [
    for (final item in items)
      if (item.notations != null) item.notations!,
  ];

  /// Every `lyric` child, in document order.
  List<Lyric> get lyricElements => [
    for (final item in items)
      if (item.lyric != null) item.lyric!,
  ];

  /// Every `play` child, in document order.
  List<Play> get playElements => [
    for (final item in items)
      if (item.play != null) item.play!,
  ];

  /// Every `listen` child, in document order.
  List<Listen> get listenElements => [
    for (final item in items)
      if (item.listen != null) item.listen!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (printDot != null) {
      node.setAttribute('print-dot', printDot!.xmlValue);
    }
    if (printSpacing != null) {
      node.setAttribute('print-spacing', printSpacing!.xmlValue);
    }
    if (printLyric != null) {
      node.setAttribute('print-lyric', printLyric!.xmlValue);
    }
    if (printLeger != null) {
      node.setAttribute('print-leger', printLeger!.xmlValue);
    }
    if (dynamics != null) {
      node.setAttribute('dynamics', xmlNumberText(dynamics!));
    }
    if (endDynamics != null) {
      node.setAttribute('end-dynamics', xmlNumberText(endDynamics!));
    }
    if (attack != null) {
      node.setAttribute('attack', xmlNumberText(attack!));
    }
    if (release != null) {
      node.setAttribute('release', xmlNumberText(release!));
    }
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    if (pizzicato != null) {
      node.setAttribute('pizzicato', pizzicato!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `note`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class NoteItem {
  NoteItem({
    this.grace,
    this.chord,
    this.pitch,
    this.unpitched,
    this.rest,
    this.tie,
    this.cue,
    this.duration,
    this.instrument,
    this.footnote,
    this.level,
    this.voice,
    this.type,
    this.dot,
    this.accidental,
    this.timeModification,
    this.stem,
    this.notehead,
    this.noteheadText,
    this.staff,
    this.beam,
    this.notations,
    this.lyric,
    this.play,
    this.listen,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static NoteItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'grace':
        return NoteItem(grace: Grace.fromXml(element));
      case 'chord':
        return NoteItem(chord: Empty.fromXml(element));
      case 'pitch':
        return NoteItem(pitch: Pitch.fromXml(element));
      case 'unpitched':
        return NoteItem(unpitched: Unpitched.fromXml(element));
      case 'rest':
        return NoteItem(rest: Rest.fromXml(element));
      case 'tie':
        return NoteItem(tie: Tie.fromXml(element));
      case 'cue':
        return NoteItem(cue: Empty.fromXml(element));
      case 'duration':
        return NoteItem(duration: xmlDouble(element.innerText) ?? 0);
      case 'instrument':
        return NoteItem(instrument: Instrument.fromXml(element));
      case 'footnote':
        return NoteItem(footnote: FormattedText.fromXml(element));
      case 'level':
        return NoteItem(level: Level.fromXml(element));
      case 'voice':
        return NoteItem(voice: element.innerText);
      case 'type':
        return NoteItem(type: NoteType.fromXml(element));
      case 'dot':
        return NoteItem(dot: EmptyPlacement.fromXml(element));
      case 'accidental':
        return NoteItem(accidental: Accidental.fromXml(element));
      case 'time-modification':
        return NoteItem(timeModification: TimeModification.fromXml(element));
      case 'stem':
        return NoteItem(stem: Stem.fromXml(element));
      case 'notehead':
        return NoteItem(notehead: Notehead.fromXml(element));
      case 'notehead-text':
        return NoteItem(noteheadText: NoteheadText.fromXml(element));
      case 'staff':
        return NoteItem(staff: xmlInt(element.innerText) ?? 0);
      case 'beam':
        return NoteItem(beam: Beam.fromXml(element));
      case 'notations':
        return NoteItem(notations: Notations.fromXml(element));
      case 'lyric':
        return NoteItem(lyric: Lyric.fromXml(element));
      case 'play':
        return NoteItem(play: Play.fromXml(element));
      case 'listen':
        return NoteItem(listen: Listen.fromXml(element));
    }
    return null;
  }

  Grace? grace;

  /// The chord element indicates that this note is an additional chord tone
  /// with the preceding note.
  ///
  /// The duration of a chord note does not move the musical position within a
  /// measure. That is done by the duration of the first preceding note
  /// without a chord element. Thus the duration of a chord note cannot be
  /// longer than the preceding note.
  ///
  /// In most cases the duration will be the same as the preceding note.
  /// However it can be shorter in situations such as multiple stops for
  /// string instruments.
  Empty? chord;

  Pitch? pitch;

  Unpitched? unpitched;

  Rest? rest;

  Tie? tie;

  Empty? cue;

  /// Duration is a positive number specified in division units. This is the
  /// intended duration vs. notated duration (for instance, differences in
  /// dotted notes in Baroque-era music). Differences in duration specific to
  /// an interpretation or performance should be represented using the note
  /// element's attack and release attributes.
  ///
  /// The duration element moves the musical position when used in backup
  /// elements, forward elements, and note elements that do not contain a
  /// chord child element.
  double? duration;

  Instrument? instrument;

  FormattedText? footnote;

  Level? level;

  String? voice;

  NoteType? type;

  /// One dot element is used for each dot of prolongation. The placement
  /// attribute is used to specify whether the dot should appear above or
  /// below the staff line. It is ignored for notes that appear on a staff
  /// space.
  EmptyPlacement? dot;

  Accidental? accidental;

  TimeModification? timeModification;

  Stem? stem;

  Notehead? notehead;

  NoteheadText? noteheadText;

  /// Staff assignment is only needed for music notated on multiple staves.
  /// Used by both notes and directions. Staff values are numbers, with 1
  /// referring to the top-most staff in a part.
  int? staff;

  Beam? beam;

  Notations? notations;

  Lyric? lyric;

  Play? play;

  Listen? listen;

  /// The name of the element this item holds.
  String? get elementName {
    if (grace != null) return 'grace';
    if (chord != null) return 'chord';
    if (pitch != null) return 'pitch';
    if (unpitched != null) return 'unpitched';
    if (rest != null) return 'rest';
    if (tie != null) return 'tie';
    if (cue != null) return 'cue';
    if (duration != null) return 'duration';
    if (instrument != null) return 'instrument';
    if (footnote != null) return 'footnote';
    if (level != null) return 'level';
    if (voice != null) return 'voice';
    if (type != null) return 'type';
    if (dot != null) return 'dot';
    if (accidental != null) return 'accidental';
    if (timeModification != null) return 'time-modification';
    if (stem != null) return 'stem';
    if (notehead != null) return 'notehead';
    if (noteheadText != null) return 'notehead-text';
    if (staff != null) return 'staff';
    if (beam != null) return 'beam';
    if (notations != null) return 'notations';
    if (lyric != null) return 'lyric';
    if (play != null) return 'play';
    if (listen != null) return 'listen';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (grace != null) return grace!.toXml('grace');
    if (chord != null) return chord!.toXml('chord');
    if (pitch != null) return pitch!.toXml('pitch');
    if (unpitched != null) return unpitched!.toXml('unpitched');
    if (rest != null) return rest!.toXml('rest');
    if (tie != null) return tie!.toXml('tie');
    if (cue != null) return cue!.toXml('cue');
    if (duration != null) return xmlTextElement('duration', xmlNumberText(duration!));
    if (instrument != null) return instrument!.toXml('instrument');
    if (footnote != null) return footnote!.toXml('footnote');
    if (level != null) return level!.toXml('level');
    if (voice != null) return xmlTextElement('voice', voice!);
    if (type != null) return type!.toXml('type');
    if (dot != null) return dot!.toXml('dot');
    if (accidental != null) return accidental!.toXml('accidental');
    if (timeModification != null) return timeModification!.toXml('time-modification');
    if (stem != null) return stem!.toXml('stem');
    if (notehead != null) return notehead!.toXml('notehead');
    if (noteheadText != null) return noteheadText!.toXml('notehead-text');
    if (staff != null) return xmlTextElement('staff', xmlNumberText(staff!));
    if (beam != null) return beam!.toXml('beam');
    if (notations != null) return notations!.toXml('notations');
    if (lyric != null) return lyric!.toXml('lyric');
    if (play != null) return play!.toXml('play');
    if (listen != null) return listen!.toXml('listen');
    return null;
  }
}

/// The note-size type indicates the percentage of the regular note size to
/// use for notes with a cue and large size as defined in the type element.
/// The grace type is used for notes of cue size that that include a grace
/// element. The cue type is used for all other notes with cue size, whether
/// defined explicitly or implicitly via a cue element. The large type is used
/// for notes of large size. The text content represent the numeric
/// percentage. A value of 100 would be identical to the size of a regular
/// note as defined by the music font.
class NoteSize {
  NoteSize({
    required this.value,
    required this.type,
  });

  /// Reads an instance from [element].
  factory NoteSize.fromXml(XmlElement element) =>
      NoteSize(
        value: xmlDouble(element.innerText) ?? 0,
        type: xmlRequiredValue(NoteSizeType.parse(element.getAttribute('type')), 'type', element),
      );

  /// The element's text content.
  double value;

  NoteSizeType type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The note-type type indicates the graphic note type. Values range from
/// 1024th to maxima. The size attribute indicates full, cue, grace-cue, or
/// large size. The default is full for regular notes, grace-cue for notes
/// that contain both grace and cue elements, and cue for notes that contain
/// either a cue or a grace element, but not both.
class NoteType {
  NoteType({
    required this.value,
    this.size,
  });

  /// Reads an instance from [element].
  factory NoteType.fromXml(XmlElement element) =>
      NoteType(
        value: xmlRequiredValue(NoteTypeValue.parse(element.innerText), 'value', element),
        size: SymbolSize.parse(element.getAttribute('size')),
      );

  /// The element's text content.
  NoteTypeValue value;

  SymbolSize? size;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (size != null) {
      node.setAttribute('size', size!.xmlValue);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The notehead type indicates shapes other than the open and closed ovals
/// associated with note durations.
///
/// The smufl attribute can be used to specify a particular notehead, allowing
/// application interoperability without requiring every SMuFL glyph to have a
/// MusicXML element equivalent. This attribute can be used either with the
/// "other" value, or to refine a specific notehead value such as "cluster".
/// Noteheads in the SMuFL Note name noteheads and Note name noteheads
/// supplement ranges (U+E150–U+E1AF and U+EEE0–U+EEFF) should not use the
/// smufl attribute or the "other" value, but instead use the notehead-text
/// element.
///
/// For the enclosed shapes, the default is to be hollow for half notes and
/// longer, and filled otherwise. The filled attribute can be set to change
/// this if needed.
///
/// If the parentheses attribute is set to yes, the notehead is parenthesized.
/// It is no by default.
class Notehead {
  Notehead({
    required this.value,
    this.filled,
    this.parentheses,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Notehead.fromXml(XmlElement element) =>
      Notehead(
        value: xmlRequiredValue(NoteheadValue.parse(element.innerText), 'value', element),
        filled: YesNo.parse(element.getAttribute('filled')),
        parentheses: YesNo.parse(element.getAttribute('parentheses')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  NoteheadValue value;

  YesNo? filled;

  YesNo? parentheses;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (filled != null) {
      node.setAttribute('filled', filled!.xmlValue);
    }
    if (parentheses != null) {
      node.setAttribute('parentheses', parentheses!.xmlValue);
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The notehead-text type represents text that is displayed inside a
/// notehead, as is done in some educational music. It is not needed for the
/// numbers used in tablature or jianpu notation. The presence of a TAB or
/// jianpu clefs is sufficient to indicate that numbers are used. The
/// display-text and accidental-text elements allow display of fully formatted
/// text and accidentals.
class NoteheadText {
  NoteheadText({
    List<NameDisplayItem>? items,
  })  : items = items ?? <NameDisplayItem>[];

  /// Reads an instance from [element].
  factory NoteheadText.fromXml(XmlElement element) =>
      NoteheadText(
        items: xmlChildren(element)
            .map(NameDisplayItem.tryFromXml)
            .whereType<NameDisplayItem>()
            .toList(),
      );

  /// The element content, in document order.
  List<NameDisplayItem> items;

  /// Every `display-text` child, in document order.
  List<FormattedText> get displayTextElements => [
    for (final item in items)
      if (item.displayText != null) item.displayText!,
  ];

  /// Every `accidental-text` child, in document order.
  List<AccidentalText> get accidentalTextElements => [
    for (final item in items)
      if (item.accidentalText != null) item.accidentalText!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// The numeral type represents the Roman numeral or Nashville number part of
/// a harmony. It requires that the key be specified in the encoding, either
/// with a key or numeral-key element.
class Numeral {
  Numeral({
    required this.numeralRoot,
    this.numeralAlter,
    this.numeralKey,
  });

  /// Reads an instance from [element].
  factory Numeral.fromXml(XmlElement element) =>
      Numeral(
        numeralRoot: NumeralRoot.fromXml(xmlRequiredElement(element, 'numeral-root')),
        numeralAlter: switch (xmlElement(element, 'numeral-alter')) {
          final child? => HarmonyAlter.fromXml(child),
          _ => null,
        },
        numeralKey: switch (xmlElement(element, 'numeral-key')) {
          final child? => NumeralKey.fromXml(child),
          _ => null,
        },
      );

  NumeralRoot numeralRoot;

  /// The numeral-alter element represents an alteration to the numeral-root,
  /// similar to the alter element for a pitch. The print-object attribute can
  /// be used to hide an alteration in cases such as when the MusicXML
  /// encoding of a 6 or 7 numeral-root in a minor key requires an alteration
  /// that is not displayed. The location attribute indicates whether the
  /// alteration should appear to the left or the right of the numeral-root.
  /// It is left by default.
  HarmonyAlter? numeralAlter;

  NumeralKey? numeralKey;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(numeralRoot.toXml('numeral-root'));
    if (numeralAlter != null) {
      node.children.add(numeralAlter!.toXml('numeral-alter'));
    }
    if (numeralKey != null) {
      node.children.add(numeralKey!.toXml('numeral-key'));
    }
    return node;
  }
}

/// The numeral-key type is used when the key for the numeral is different
/// than the key specified by the key signature. The numeral-fifths element
/// specifies the key in the same way as the fifths element. The numeral-mode
/// element specifies the mode similar to the mode element, but with a
/// restricted set of values
class NumeralKey {
  NumeralKey({
    required this.numeralFifths,
    required this.numeralMode,
    this.printObject,
  });

  /// Reads an instance from [element].
  factory NumeralKey.fromXml(XmlElement element) =>
      NumeralKey(
        numeralFifths: xmlInt(xmlElementText(element, 'numeral-fifths')) ?? 0,
        numeralMode: xmlRequiredValue(NumeralMode.parse(xmlElementText(element, 'numeral-mode')), 'numeral-mode', element),
        printObject: YesNo.parse(element.getAttribute('print-object')),
      );

  int numeralFifths;

  NumeralMode numeralMode;

  YesNo? printObject;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    node.children.add(xmlTextElement('numeral-fifths', xmlNumberText(numeralFifths)));
    node.children.add(xmlTextElement('numeral-mode', numeralMode.xmlValue));
    return node;
  }
}

/// The numeral-root type represents the Roman numeral or Nashville number as
/// a positive integer from 1 to 7. The text attribute indicates how the
/// numeral should appear in the score. A numeral-root value of 5 with a kind
/// of major would have a text attribute of "V" if displayed as a Roman
/// numeral, and "5" if displayed as a Nashville number. If the text attribute
/// is not specified, the display is application-dependent.
class NumeralRoot {
  NumeralRoot({
    required this.value,
    this.text,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory NumeralRoot.fromXml(XmlElement element) =>
      NumeralRoot(
        value: xmlInt(element.innerText) ?? 0,
        text: element.getAttribute('text'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  int value;

  String? text;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The octave shift type indicates where notes are shifted up or down from
/// their true pitched values because of printing difficulty. Thus a treble
/// clef line noted with 8va will be indicated with an octave-shift down from
/// the pitch data indicated in the notes. A size of 8 indicates one octave; a
/// size of 15 indicates two octaves.
class OctaveShift {
  OctaveShift({
    required this.type,
    this.number,
    this.size,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory OctaveShift.fromXml(XmlElement element) =>
      OctaveShift(
        type: xmlRequiredValue(UpDownStopContinue.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        size: xmlInt(element.getAttribute('size')) ?? 8,
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  UpDownStopContinue type;

  int? number;

  int? size;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (size != null) {
      node.setAttribute('size', xmlNumberText(size!));
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// An offset is represented in terms of divisions, and indicates where the
/// direction will appear relative to the current musical location. The
/// current musical location is always within the current measure, even at the
/// end of a measure.
///
/// The offset affects the visual appearance of the direction. If the sound
/// attribute is "yes", then the offset affects playback and listening too. If
/// the sound attribute is "no", then any sound or listening associated with
/// the direction takes effect at the current location. The sound attribute is
/// "no" by default for compatibility with earlier versions of the MusicXML
/// format. If an element within a direction includes a default-x attribute,
/// the offset value will be ignored when determining the appearance of that
/// element.
class Offset {
  Offset({
    required this.value,
    this.sound,
  });

  /// Reads an instance from [element].
  factory Offset.fromXml(XmlElement element) =>
      Offset(
        value: xmlDouble(element.innerText) ?? 0,
        sound: YesNo.parse(element.getAttribute('sound')),
      );

  /// The element's text content.
  double value;

  YesNo? sound;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (sound != null) {
      node.setAttribute('sound', sound!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The opus type represents a link to a MusicXML opus document that composes
/// multiple MusicXML scores into a collection.
class Opus {
  Opus({
    this.xlinkHref,
    this.xlinkType,
    this.xlinkRole,
    this.xlinkTitle,
    this.xlinkShow,
    this.xlinkActuate,
  });

  /// Reads an instance from [element].
  factory Opus.fromXml(XmlElement element) =>
      Opus(
        xlinkHref: element.getAttribute('xlink:href'),
        xlinkType: element.getAttribute('xlink:type'),
        xlinkRole: element.getAttribute('xlink:role'),
        xlinkTitle: element.getAttribute('xlink:title'),
        xlinkShow: element.getAttribute('xlink:show'),
        xlinkActuate: element.getAttribute('xlink:actuate'),
      );

  /// The `xlink:href` attribute.
  String? xlinkHref;

  /// The `xlink:type` attribute.
  String? xlinkType;

  /// The `xlink:role` attribute.
  String? xlinkRole;

  /// The `xlink:title` attribute.
  String? xlinkTitle;

  /// The `xlink:show` attribute.
  String? xlinkShow;

  /// The `xlink:actuate` attribute.
  String? xlinkActuate;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (xlinkHref != null) {
      node.setAttribute('xlink:href', xlinkHref!);
    }
    if (xlinkType != null) {
      node.setAttribute('xlink:type', xlinkType!);
    }
    if (xlinkRole != null) {
      node.setAttribute('xlink:role', xlinkRole!);
    }
    if (xlinkTitle != null) {
      node.setAttribute('xlink:title', xlinkTitle!);
    }
    if (xlinkShow != null) {
      node.setAttribute('xlink:show', xlinkShow!);
    }
    if (xlinkActuate != null) {
      node.setAttribute('xlink:actuate', xlinkActuate!);
    }
    return node;
  }
}

/// Ornaments can be any of several types, followed optionally by accidentals.
/// The accidental-mark element's content is represented the same as an
/// accidental element, but with a different name to reflect the different
/// musical meaning.
class Ornaments {
  Ornaments({
    this.id,
    List<OrnamentsItem>? items,
  })  : items = items ?? <OrnamentsItem>[];

  /// Reads an instance from [element].
  factory Ornaments.fromXml(XmlElement element) =>
      Ornaments(
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(OrnamentsItem.tryFromXml)
            .whereType<OrnamentsItem>()
            .toList(),
      );

  String? id;

  /// The element content, in document order.
  List<OrnamentsItem> items;

  /// Every `trill-mark` child, in document order.
  List<EmptyTrillSound> get trillMarkElements => [
    for (final item in items)
      if (item.trillMark != null) item.trillMark!,
  ];

  /// Every `turn` child, in document order.
  List<HorizontalTurn> get turnElements => [
    for (final item in items)
      if (item.turn != null) item.turn!,
  ];

  /// Every `delayed-turn` child, in document order.
  List<HorizontalTurn> get delayedTurnElements => [
    for (final item in items)
      if (item.delayedTurn != null) item.delayedTurn!,
  ];

  /// Every `inverted-turn` child, in document order.
  List<HorizontalTurn> get invertedTurnElements => [
    for (final item in items)
      if (item.invertedTurn != null) item.invertedTurn!,
  ];

  /// Every `delayed-inverted-turn` child, in document order.
  List<HorizontalTurn> get delayedInvertedTurnElements => [
    for (final item in items)
      if (item.delayedInvertedTurn != null) item.delayedInvertedTurn!,
  ];

  /// Every `vertical-turn` child, in document order.
  List<EmptyTrillSound> get verticalTurnElements => [
    for (final item in items)
      if (item.verticalTurn != null) item.verticalTurn!,
  ];

  /// Every `inverted-vertical-turn` child, in document order.
  List<EmptyTrillSound> get invertedVerticalTurnElements => [
    for (final item in items)
      if (item.invertedVerticalTurn != null) item.invertedVerticalTurn!,
  ];

  /// Every `shake` child, in document order.
  List<EmptyTrillSound> get shakeElements => [
    for (final item in items)
      if (item.shake != null) item.shake!,
  ];

  /// Every `wavy-line` child, in document order.
  List<WavyLine> get wavyLineElements => [
    for (final item in items)
      if (item.wavyLine != null) item.wavyLine!,
  ];

  /// Every `mordent` child, in document order.
  List<Mordent> get mordentElements => [
    for (final item in items)
      if (item.mordent != null) item.mordent!,
  ];

  /// Every `inverted-mordent` child, in document order.
  List<Mordent> get invertedMordentElements => [
    for (final item in items)
      if (item.invertedMordent != null) item.invertedMordent!,
  ];

  /// Every `schleifer` child, in document order.
  List<EmptyPlacement> get schleiferElements => [
    for (final item in items)
      if (item.schleifer != null) item.schleifer!,
  ];

  /// Every `tremolo` child, in document order.
  List<Tremolo> get tremoloElements => [
    for (final item in items)
      if (item.tremolo != null) item.tremolo!,
  ];

  /// Every `haydn` child, in document order.
  List<EmptyTrillSound> get haydnElements => [
    for (final item in items)
      if (item.haydn != null) item.haydn!,
  ];

  /// Every `other-ornament` child, in document order.
  List<OtherPlacementText> get otherOrnamentElements => [
    for (final item in items)
      if (item.otherOrnament != null) item.otherOrnament!,
  ];

  /// Every `accidental-mark` child, in document order.
  List<AccidentalMark> get accidentalMarkElements => [
    for (final item in items)
      if (item.accidentalMark != null) item.accidentalMark!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `ornaments`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class OrnamentsItem {
  OrnamentsItem({
    this.trillMark,
    this.turn,
    this.delayedTurn,
    this.invertedTurn,
    this.delayedInvertedTurn,
    this.verticalTurn,
    this.invertedVerticalTurn,
    this.shake,
    this.wavyLine,
    this.mordent,
    this.invertedMordent,
    this.schleifer,
    this.tremolo,
    this.haydn,
    this.otherOrnament,
    this.accidentalMark,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static OrnamentsItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'trill-mark':
        return OrnamentsItem(trillMark: EmptyTrillSound.fromXml(element));
      case 'turn':
        return OrnamentsItem(turn: HorizontalTurn.fromXml(element));
      case 'delayed-turn':
        return OrnamentsItem(delayedTurn: HorizontalTurn.fromXml(element));
      case 'inverted-turn':
        return OrnamentsItem(invertedTurn: HorizontalTurn.fromXml(element));
      case 'delayed-inverted-turn':
        return OrnamentsItem(delayedInvertedTurn: HorizontalTurn.fromXml(element));
      case 'vertical-turn':
        return OrnamentsItem(verticalTurn: EmptyTrillSound.fromXml(element));
      case 'inverted-vertical-turn':
        return OrnamentsItem(invertedVerticalTurn: EmptyTrillSound.fromXml(element));
      case 'shake':
        return OrnamentsItem(shake: EmptyTrillSound.fromXml(element));
      case 'wavy-line':
        return OrnamentsItem(wavyLine: WavyLine.fromXml(element));
      case 'mordent':
        return OrnamentsItem(mordent: Mordent.fromXml(element));
      case 'inverted-mordent':
        return OrnamentsItem(invertedMordent: Mordent.fromXml(element));
      case 'schleifer':
        return OrnamentsItem(schleifer: EmptyPlacement.fromXml(element));
      case 'tremolo':
        return OrnamentsItem(tremolo: Tremolo.fromXml(element));
      case 'haydn':
        return OrnamentsItem(haydn: EmptyTrillSound.fromXml(element));
      case 'other-ornament':
        return OrnamentsItem(otherOrnament: OtherPlacementText.fromXml(element));
      case 'accidental-mark':
        return OrnamentsItem(accidentalMark: AccidentalMark.fromXml(element));
    }
    return null;
  }

  /// The trill-mark element represents the trill-mark symbol.
  EmptyTrillSound? trillMark;

  /// The turn element is the normal turn shape which goes up then down.
  HorizontalTurn? turn;

  /// The delayed-turn element indicates a normal turn that is delayed until
  /// the end of the current note.
  HorizontalTurn? delayedTurn;

  /// The inverted-turn element has the shape which goes down and then up.
  HorizontalTurn? invertedTurn;

  /// The delayed-inverted-turn element indicates an inverted turn that is
  /// delayed until the end of the current note.
  HorizontalTurn? delayedInvertedTurn;

  /// The vertical-turn element has the turn symbol shape arranged vertically
  /// going from upper left to lower right.
  EmptyTrillSound? verticalTurn;

  /// The inverted-vertical-turn element has the turn symbol shape arranged
  /// vertically going from upper right to lower left.
  EmptyTrillSound? invertedVerticalTurn;

  /// The shake element has a similar appearance to an inverted-mordent
  /// element.
  EmptyTrillSound? shake;

  WavyLine? wavyLine;

  /// The mordent element represents the sign with the vertical line. The
  /// choice of which mordent sign is inverted differs between MusicXML and
  /// SMuFL. The long attribute is "no" by default.
  Mordent? mordent;

  /// The inverted-mordent element represents the sign without the vertical
  /// line. The choice of which mordent is inverted differs between MusicXML
  /// and SMuFL. The long attribute is "no" by default.
  Mordent? invertedMordent;

  /// The name for this ornament is based on the German, to avoid confusion
  /// with the more common slide element defined earlier.
  EmptyPlacement? schleifer;

  Tremolo? tremolo;

  /// The haydn element represents the Haydn ornament. This is defined in
  /// SMuFL as ornamentHaydn.
  EmptyTrillSound? haydn;

  /// The other-ornament element is used to define any ornaments not yet in
  /// the MusicXML format. The smufl attribute can be used to specify a
  /// particular ornament, allowing application interoperability without
  /// requiring every SMuFL ornament to have a MusicXML element equivalent.
  /// Using the other-ornament element without the smufl attribute allows for
  /// extended representation, though without application interoperability.
  OtherPlacementText? otherOrnament;

  AccidentalMark? accidentalMark;

  /// The name of the element this item holds.
  String? get elementName {
    if (trillMark != null) return 'trill-mark';
    if (turn != null) return 'turn';
    if (delayedTurn != null) return 'delayed-turn';
    if (invertedTurn != null) return 'inverted-turn';
    if (delayedInvertedTurn != null) return 'delayed-inverted-turn';
    if (verticalTurn != null) return 'vertical-turn';
    if (invertedVerticalTurn != null) return 'inverted-vertical-turn';
    if (shake != null) return 'shake';
    if (wavyLine != null) return 'wavy-line';
    if (mordent != null) return 'mordent';
    if (invertedMordent != null) return 'inverted-mordent';
    if (schleifer != null) return 'schleifer';
    if (tremolo != null) return 'tremolo';
    if (haydn != null) return 'haydn';
    if (otherOrnament != null) return 'other-ornament';
    if (accidentalMark != null) return 'accidental-mark';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (trillMark != null) return trillMark!.toXml('trill-mark');
    if (turn != null) return turn!.toXml('turn');
    if (delayedTurn != null) return delayedTurn!.toXml('delayed-turn');
    if (invertedTurn != null) return invertedTurn!.toXml('inverted-turn');
    if (delayedInvertedTurn != null) return delayedInvertedTurn!.toXml('delayed-inverted-turn');
    if (verticalTurn != null) return verticalTurn!.toXml('vertical-turn');
    if (invertedVerticalTurn != null) return invertedVerticalTurn!.toXml('inverted-vertical-turn');
    if (shake != null) return shake!.toXml('shake');
    if (wavyLine != null) return wavyLine!.toXml('wavy-line');
    if (mordent != null) return mordent!.toXml('mordent');
    if (invertedMordent != null) return invertedMordent!.toXml('inverted-mordent');
    if (schleifer != null) return schleifer!.toXml('schleifer');
    if (tremolo != null) return tremolo!.toXml('tremolo');
    if (haydn != null) return haydn!.toXml('haydn');
    if (otherOrnament != null) return otherOrnament!.toXml('other-ornament');
    if (accidentalMark != null) return accidentalMark!.toXml('accidental-mark');
    return null;
  }
}

/// The other-appearance type is used to define any graphical settings not yet
/// in the current version of the MusicXML format. This allows extended
/// representation, though without application interoperability.
class OtherAppearance {
  OtherAppearance({
    required this.value,
    required this.type,
  });

  /// Reads an instance from [element].
  factory OtherAppearance.fromXml(XmlElement element) =>
      OtherAppearance(
        value: element.innerText,
        type: element.getAttribute('type') ?? '',
      );

  /// The element's text content.
  String value;

  String type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type);
    node.children.add(XmlText(value));
    return node;
  }
}

/// The other-direction type is used to define any direction symbols not yet
/// in the MusicXML format. The smufl attribute can be used to specify a
/// particular direction symbol, allowing application interoperability without
/// requiring every SMuFL glyph to have a MusicXML element equivalent. Using
/// the other-direction type without the smufl attribute allows for extended
/// representation, though without application interoperability.
class OtherDirection {
  OtherDirection({
    required this.value,
    this.printObject,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.smufl,
    this.id,
  });

  /// Reads an instance from [element].
  factory OtherDirection.fromXml(XmlElement element) =>
      OtherDirection(
        value: element.innerText,
        printObject: YesNo.parse(element.getAttribute('print-object')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        smufl: element.getAttribute('smufl'),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  YesNo? printObject;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? smufl;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The other-listening type represents other types of listening control and
/// interaction. The required type attribute indicates the type of listening
/// to which the element content applies. The optional player and time-only
/// attributes restrict the element to apply to a single player or set of
/// times through a repeated section, respectively.
class OtherListening {
  OtherListening({
    required this.value,
    required this.type,
    this.player,
    this.timeOnly,
  });

  /// Reads an instance from [element].
  factory OtherListening.fromXml(XmlElement element) =>
      OtherListening(
        value: element.innerText,
        type: element.getAttribute('type') ?? '',
        player: element.getAttribute('player'),
        timeOnly: element.getAttribute('time-only'),
      );

  /// The element's text content.
  String value;

  String type;

  String? player;

  String? timeOnly;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type);
    if (player != null) {
      node.setAttribute('player', player!);
    }
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The other-notation type is used to define any notations not yet in the
/// MusicXML format. It handles notations where more specific extension
/// elements such as other-dynamics and other-technical are not appropriate.
/// The smufl attribute can be used to specify a particular notation, allowing
/// application interoperability without requiring every SMuFL glyph to have a
/// MusicXML element equivalent. Using the other-notation type without the
/// smufl attribute allows for extended representation, though without
/// application interoperability.
class OtherNotation {
  OtherNotation({
    required this.value,
    required this.type,
    this.number,
    this.printObject,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.smufl,
    this.id,
  });

  /// Reads an instance from [element].
  factory OtherNotation.fromXml(XmlElement element) =>
      OtherNotation(
        value: element.innerText,
        type: xmlRequiredValue(StartStopSingle.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')) ?? 1,
        printObject: YesNo.parse(element.getAttribute('print-object')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        smufl: element.getAttribute('smufl'),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  StartStopSingle type;

  int? number;

  YesNo? printObject;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  String? smufl;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The other-placement-text type represents a text element with print-style,
/// placement, and smufl attribute groups. This type is used by MusicXML
/// notation extension elements to allow specification of specific SMuFL
/// glyphs without needed to add every glyph as a MusicXML element.
class OtherPlacementText {
  OtherPlacementText({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory OtherPlacementText.fromXml(XmlElement element) =>
      OtherPlacementText(
        value: element.innerText,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  String value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The other-play element represents other types of playback. The required
/// type attribute indicates the type of playback to which the element content
/// applies.
class OtherPlay {
  OtherPlay({
    required this.value,
    required this.type,
  });

  /// Reads an instance from [element].
  factory OtherPlay.fromXml(XmlElement element) =>
      OtherPlay(
        value: element.innerText,
        type: element.getAttribute('type') ?? '',
      );

  /// The element's text content.
  String value;

  String type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type);
    node.children.add(XmlText(value));
    return node;
  }
}

/// The other-text type represents a text element with a smufl attribute
/// group. This type is used by MusicXML direction extension elements to allow
/// specification of specific SMuFL glyphs without needed to add every glyph
/// as a MusicXML element.
class OtherText {
  OtherText({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory OtherText.fromXml(XmlElement element) =>
      OtherText(
        value: element.innerText,
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  String value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// Page layout can be defined both in score-wide defaults and in the print
/// element. Page margins are specified either for both even and odd pages, or
/// via separate odd and even page number values. The type is not needed when
/// used as part of a print element. If omitted when used in the defaults
/// element, "both" is the default.
///
/// If no page-layout element is present in the defaults element, default page
/// layout values are chosen by the application.
///
/// When used in the print element, the page-layout element affects the
/// appearance of the current page only. All other pages use the default
/// values as determined by the defaults element. If any child elements are
/// missing from the page-layout element in a print element, the values
/// determined by the defaults element are used there as well.
class PageLayout {
  PageLayout({
    this.pageHeight,
    this.pageWidth,
    List<PageMargins>? pageMargins,
  })  : pageMargins = pageMargins ?? <PageMargins>[];

  /// Reads an instance from [element].
  factory PageLayout.fromXml(XmlElement element) =>
      PageLayout(
        pageHeight: xmlDouble(xmlElementText(element, 'page-height')),
        pageWidth: xmlDouble(xmlElementText(element, 'page-width')),
        pageMargins: xmlElements(element, 'page-margins')
            .map(PageMargins.fromXml)
            .toList(),
      );

  double? pageHeight;

  double? pageWidth;

  List<PageMargins> pageMargins;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (pageHeight != null) {
      node.children.add(xmlTextElement('page-height', xmlNumberText(pageHeight!)));
    }
    if (pageWidth != null) {
      node.children.add(xmlTextElement('page-width', xmlNumberText(pageWidth!)));
    }
    for (final item in pageMargins) {
      node.children.add(item.toXml('page-margins'));
    }
    return node;
  }
}

/// Page margins are specified either for both even and odd pages, or via
/// separate odd and even page number values. The type attribute is not needed
/// when used as part of a print element. If omitted when the page-margins
/// type is used in the defaults element, "both" is the default value.
class PageMargins {
  PageMargins({
    required this.leftMargin,
    required this.rightMargin,
    required this.topMargin,
    required this.bottomMargin,
    this.type,
  });

  /// Reads an instance from [element].
  factory PageMargins.fromXml(XmlElement element) =>
      PageMargins(
        leftMargin: xmlDouble(xmlElementText(element, 'left-margin')) ?? 0,
        rightMargin: xmlDouble(xmlElementText(element, 'right-margin')) ?? 0,
        topMargin: xmlDouble(xmlElementText(element, 'top-margin')) ?? 0,
        bottomMargin: xmlDouble(xmlElementText(element, 'bottom-margin')) ?? 0,
        type: MarginType.parse(element.getAttribute('type')),
      );

  double leftMargin;

  double rightMargin;

  double topMargin;

  double bottomMargin;

  MarginType? type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (type != null) {
      node.setAttribute('type', type!.xmlValue);
    }
    node.children.add(xmlTextElement('left-margin', xmlNumberText(leftMargin)));
    node.children.add(xmlTextElement('right-margin', xmlNumberText(rightMargin)));
    node.children.add(xmlTextElement('top-margin', xmlNumberText(topMargin)));
    node.children.add(xmlTextElement('bottom-margin', xmlNumberText(bottomMargin)));
    return node;
  }
}

/// The child elements of the part-clef type have the same meaning as for the
/// clef type. However that meaning applies to a transposed part created from
/// the existing score file.
class PartClef {
  PartClef({
    required this.sign,
    this.line,
    this.clefOctaveChange,
  });

  /// Reads an instance from [element].
  factory PartClef.fromXml(XmlElement element) =>
      PartClef(
        sign: xmlRequiredValue(ClefSign.parse(xmlElementText(element, 'sign')), 'sign', element),
        line: xmlInt(xmlElementText(element, 'line')),
        clefOctaveChange: xmlInt(xmlElementText(element, 'clef-octave-change')),
      );

  /// The sign element represents the clef symbol.
  ClefSign sign;

  /// Line numbers are counted from the bottom of the staff. They are only
  /// needed with the G, F, and C signs in order to position a pitch correctly
  /// on the staff. Standard values are 2 for the G sign (treble clef), 4 for
  /// the F sign (bass clef), and 3 for the C sign (alto clef). Line values
  /// can be used to specify positions outside the staff, such as a C clef
  /// positioned in the middle of a grand staff.
  int? line;

  /// The clef-octave-change element is used for transposing clefs. A treble
  /// clef for tenors would have a value of -1.
  int? clefOctaveChange;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('sign', sign.xmlValue));
    if (line != null) {
      node.children.add(xmlTextElement('line', xmlNumberText(line!)));
    }
    if (clefOctaveChange != null) {
      node.children.add(xmlTextElement('clef-octave-change', xmlNumberText(clefOctaveChange!)));
    }
    return node;
  }
}

/// The part-group element indicates groupings of parts in the score, usually
/// indicated by braces and brackets. Braces that are used for multi-staff
/// parts should be defined in the attributes element for that part. The
/// part-group start element appears before the first score-part in the group.
/// The part-group stop element appears after the last score-part in the
/// group.
///
/// The number attribute is used to distinguish overlapping and nested
/// part-groups, not the sequence of groups. As with parts, groups can have a
/// name and abbreviation. Values for the child elements are ignored at the
/// stop of a group.
///
/// A part-group element is not needed for a single multi-staff part. By
/// default, multi-staff parts include a brace symbol and (if appropriate
/// given the bar-style) common barlines. The symbol formatting for a
/// multi-staff part can be more fully specified using the part-symbol
/// element.
class PartGroup {
  PartGroup({
    this.groupName,
    this.groupNameDisplay,
    this.groupAbbreviation,
    this.groupAbbreviationDisplay,
    this.groupSymbol,
    this.groupBarline,
    this.groupTime,
    this.footnote,
    this.level,
    required this.type,
    this.number,
  });

  /// Reads an instance from [element].
  factory PartGroup.fromXml(XmlElement element) =>
      PartGroup(
        groupName: switch (xmlElement(element, 'group-name')) {
          final child? => GroupName.fromXml(child),
          _ => null,
        },
        groupNameDisplay: switch (xmlElement(element, 'group-name-display')) {
          final child? => NameDisplay.fromXml(child),
          _ => null,
        },
        groupAbbreviation: switch (xmlElement(element, 'group-abbreviation')) {
          final child? => GroupName.fromXml(child),
          _ => null,
        },
        groupAbbreviationDisplay: switch (xmlElement(element, 'group-abbreviation-display')) {
          final child? => NameDisplay.fromXml(child),
          _ => null,
        },
        groupSymbol: switch (xmlElement(element, 'group-symbol')) {
          final child? => GroupSymbol.fromXml(child),
          _ => null,
        },
        groupBarline: switch (xmlElement(element, 'group-barline')) {
          final child? => GroupBarline.fromXml(child),
          _ => null,
        },
        groupTime: switch (xmlElement(element, 'group-time')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        footnote: switch (xmlElement(element, 'footnote')) {
          final child? => FormattedText.fromXml(child),
          _ => null,
        },
        level: switch (xmlElement(element, 'level')) {
          final child? => Level.fromXml(child),
          _ => null,
        },
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        number: element.getAttribute('number') ?? '1',
      );

  GroupName? groupName;

  /// Formatting specified in the group-name-display element overrides
  /// formatting specified in the group-name element.
  NameDisplay? groupNameDisplay;

  GroupName? groupAbbreviation;

  /// Formatting specified in the group-abbreviation-display element overrides
  /// formatting specified in the group-abbreviation element.
  NameDisplay? groupAbbreviationDisplay;

  GroupSymbol? groupSymbol;

  GroupBarline? groupBarline;

  /// The group-time element indicates that the displayed time signatures
  /// should stretch across all parts and staves in the group.
  Empty? groupTime;

  FormattedText? footnote;

  Level? level;

  StartStop type;

  String? number;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', number!);
    }
    if (groupName != null) {
      node.children.add(groupName!.toXml('group-name'));
    }
    if (groupNameDisplay != null) {
      node.children.add(groupNameDisplay!.toXml('group-name-display'));
    }
    if (groupAbbreviation != null) {
      node.children.add(groupAbbreviation!.toXml('group-abbreviation'));
    }
    if (groupAbbreviationDisplay != null) {
      node.children.add(groupAbbreviationDisplay!.toXml('group-abbreviation-display'));
    }
    if (groupSymbol != null) {
      node.children.add(groupSymbol!.toXml('group-symbol'));
    }
    if (groupBarline != null) {
      node.children.add(groupBarline!.toXml('group-barline'));
    }
    if (groupTime != null) {
      node.children.add(groupTime!.toXml('group-time'));
    }
    if (footnote != null) {
      node.children.add(footnote!.toXml('footnote'));
    }
    if (level != null) {
      node.children.add(level!.toXml('level'));
    }
    return node;
  }
}

/// The part-link type allows MusicXML data for both score and parts to be
/// contained within a single compressed MusicXML file. It links a score-part
/// from a score document to MusicXML documents that contain parts data. In
/// the case of a single compressed MusicXML file, the link href values are
/// paths that are relative to the root folder of the zip file.
class PartLink {
  PartLink({
    List<InstrumentLink>? instrumentLink,
    List<String>? groupLink,
    this.xlinkHref,
    this.xlinkType,
    this.xlinkRole,
    this.xlinkTitle,
    this.xlinkShow,
    this.xlinkActuate,
  })  : instrumentLink = instrumentLink ?? <InstrumentLink>[],
        groupLink = groupLink ?? <String>[];

  /// Reads an instance from [element].
  factory PartLink.fromXml(XmlElement element) =>
      PartLink(
        instrumentLink: xmlElements(element, 'instrument-link')
            .map(InstrumentLink.fromXml)
            .toList(),
        groupLink: xmlElements(element, 'group-link')
            .map((e) => e.innerText)
            .toList(),
        xlinkHref: element.getAttribute('xlink:href'),
        xlinkType: element.getAttribute('xlink:type'),
        xlinkRole: element.getAttribute('xlink:role'),
        xlinkTitle: element.getAttribute('xlink:title'),
        xlinkShow: element.getAttribute('xlink:show'),
        xlinkActuate: element.getAttribute('xlink:actuate'),
      );

  List<InstrumentLink> instrumentLink;

  /// Multiple part-link elements can reference different types of linked
  /// documents, such as parts and condensed score. The optional group-link
  /// elements identify the groups used in the linked document. The content of
  /// a group-link element should match the content of a group element in the
  /// linked document.
  List<String> groupLink;

  /// The `xlink:href` attribute.
  String? xlinkHref;

  /// The `xlink:type` attribute.
  String? xlinkType;

  /// The `xlink:role` attribute.
  String? xlinkRole;

  /// The `xlink:title` attribute.
  String? xlinkTitle;

  /// The `xlink:show` attribute.
  String? xlinkShow;

  /// The `xlink:actuate` attribute.
  String? xlinkActuate;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (xlinkHref != null) {
      node.setAttribute('xlink:href', xlinkHref!);
    }
    if (xlinkType != null) {
      node.setAttribute('xlink:type', xlinkType!);
    }
    if (xlinkRole != null) {
      node.setAttribute('xlink:role', xlinkRole!);
    }
    if (xlinkTitle != null) {
      node.setAttribute('xlink:title', xlinkTitle!);
    }
    if (xlinkShow != null) {
      node.setAttribute('xlink:show', xlinkShow!);
    }
    if (xlinkActuate != null) {
      node.setAttribute('xlink:actuate', xlinkActuate!);
    }
    for (final item in instrumentLink) {
      node.children.add(item.toXml('instrument-link'));
    }
    for (final item in groupLink) {
      node.children.add(xmlTextElement('group-link', item));
    }
    return node;
  }
}

/// The part-list identifies the different musical parts in this document.
/// Each part has an ID that is used later within the musical data. Since
/// parts may be encoded separately and combined later, identification
/// elements are present at both the score and score-part levels. There must
/// be at least one score-part, combined as desired with part-group elements
/// that indicate braces and brackets. Parts are ordered from top to bottom in
/// a score based on the order in which they appear in the part-list.
class PartList {
  PartList({
    List<PartListItem>? items,
  })  : items = items ?? <PartListItem>[];

  /// Reads an instance from [element].
  factory PartList.fromXml(XmlElement element) =>
      PartList(
        items: xmlChildren(element)
            .map(PartListItem.tryFromXml)
            .whereType<PartListItem>()
            .toList(),
      );

  /// The element content, in document order.
  List<PartListItem> items;

  /// Every `part-group` child, in document order.
  List<PartGroup> get partGroupElements => [
    for (final item in items)
      if (item.partGroup != null) item.partGroup!,
  ];

  /// Every `score-part` child, in document order.
  List<ScorePart> get scorePartElements => [
    for (final item in items)
      if (item.scorePart != null) item.scorePart!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `part-list`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class PartListItem {
  PartListItem({
    this.partGroup,
    this.scorePart,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static PartListItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'part-group':
        return PartListItem(partGroup: PartGroup.fromXml(element));
      case 'score-part':
        return PartListItem(scorePart: ScorePart.fromXml(element));
    }
    return null;
  }

  PartGroup? partGroup;

  /// Each MusicXML part corresponds to a track in a Standard MIDI Format 1
  /// file. The score-instrument elements are used when there are multiple
  /// instruments per track. The midi-device element is used to make a MIDI
  /// device or port assignment for the given track. Initial midi-instrument
  /// assignments may be made here as well.
  ScorePart? scorePart;

  /// The name of the element this item holds.
  String? get elementName {
    if (partGroup != null) return 'part-group';
    if (scorePart != null) return 'score-part';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (partGroup != null) return partGroup!.toXml('part-group');
    if (scorePart != null) return scorePart!.toXml('score-part');
    return null;
  }
}

/// The part-name type describes the name or abbreviation of a score-part
/// element. Formatting attributes for the part-name element are deprecated in
/// Version 2.0 in favor of the new part-name-display and
/// part-abbreviation-display elements.
class PartName {
  PartName({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.printObject,
    this.justify,
  });

  /// Reads an instance from [element].
  factory PartName.fromXml(XmlElement element) =>
      PartName(
        value: element.innerText,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        justify: LeftCenterRight.parse(element.getAttribute('justify')),
      );

  /// The element's text content.
  String value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  YesNo? printObject;

  LeftCenterRight? justify;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (justify != null) {
      node.setAttribute('justify', justify!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The part-symbol type indicates how a symbol for a multi-staff part is
/// indicated in the score; brace is the default value. The top-staff and
/// bottom-staff attributes are used when the brace does not extend across the
/// entire part. For example, in a 3-staff organ part, the top-staff will
/// typically be 1 for the right hand, while the bottom-staff will typically
/// be 2 for the left hand. Staff 3 for the pedals is usually outside the
/// brace. By default, the presence of a part-symbol element that does not
/// extend across the entire part also indicates a corresponding change in the
/// common barlines within a part.
class PartSymbol {
  PartSymbol({
    required this.value,
    this.topStaff,
    this.bottomStaff,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
  });

  /// Reads an instance from [element].
  factory PartSymbol.fromXml(XmlElement element) =>
      PartSymbol(
        value: xmlRequiredValue(GroupSymbolValue.parse(element.innerText), 'value', element),
        topStaff: xmlInt(element.getAttribute('top-staff')),
        bottomStaff: xmlInt(element.getAttribute('bottom-staff')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  GroupSymbolValue value;

  int? topStaff;

  int? bottomStaff;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (topStaff != null) {
      node.setAttribute('top-staff', xmlNumberText(topStaff!));
    }
    if (bottomStaff != null) {
      node.setAttribute('bottom-staff', xmlNumberText(bottomStaff!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The child elements of the part-transpose type have the same meaning as for
/// the transpose type. However that meaning applies to a transposed part
/// created from the existing score file.
class PartTranspose {
  PartTranspose({
    this.diatonic,
    required this.chromatic,
    this.octaveChange,
    this.doubleValue,
  });

  /// Reads an instance from [element].
  factory PartTranspose.fromXml(XmlElement element) =>
      PartTranspose(
        diatonic: xmlInt(xmlElementText(element, 'diatonic')),
        chromatic: xmlDouble(xmlElementText(element, 'chromatic')) ?? 0,
        octaveChange: xmlInt(xmlElementText(element, 'octave-change')),
        doubleValue: switch (xmlElement(element, 'double')) {
          final child? => Double.fromXml(child),
          _ => null,
        },
      );

  /// The diatonic element specifies the number of pitch steps needed to go
  /// from written to sounding pitch. This allows for correct spelling of
  /// enharmonic transpositions. This value does not include octave-change
  /// values; the values for both elements need to be added to the written
  /// pitch to get the correct sounding pitch.
  int? diatonic;

  /// The chromatic element represents the number of semitones needed to get
  /// from written to sounding pitch. This value does not include
  /// octave-change values; the values for both elements need to be added to
  /// the written pitch to get the correct sounding pitch.
  double chromatic;

  /// The octave-change element indicates how many octaves to add to get from
  /// written pitch to sounding pitch. The octave-change element should be
  /// included when using transposition intervals of an octave or more, and
  /// should not be present for intervals of less than an octave.
  int? octaveChange;

  /// If the double element is present, it indicates that the music is doubled
  /// one octave from what is currently written.
  Double? doubleValue;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (diatonic != null) {
      node.children.add(xmlTextElement('diatonic', xmlNumberText(diatonic!)));
    }
    node.children.add(xmlTextElement('chromatic', xmlNumberText(chromatic)));
    if (octaveChange != null) {
      node.children.add(xmlTextElement('octave-change', xmlNumberText(octaveChange!)));
    }
    if (doubleValue != null) {
      node.children.add(doubleValue!.toXml('double'));
    }
    return node;
  }
}

/// The pedal type represents piano pedal marks, including damper and
/// sostenuto pedal marks. The line attribute is yes if pedal lines are used.
/// The sign attribute is yes if Ped, Sost, and * signs are used. For
/// compatibility with older versions, the sign attribute is yes by default if
/// the line attribute is no, and is no by default if the line attribute is
/// yes. If the sign attribute is set to yes and the type is start or
/// sostenuto, the abbreviated attribute is yes if the short P and S signs are
/// used, and no if the full Ped and Sost signs are used. It is no by default.
/// Otherwise the abbreviated attribute is ignored. The alignment attributes
/// are ignored if the sign attribute is no.
class Pedal {
  Pedal({
    required this.type,
    this.number,
    this.line,
    this.sign,
    this.abbreviated,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
  });

  /// Reads an instance from [element].
  factory Pedal.fromXml(XmlElement element) =>
      Pedal(
        type: xmlRequiredValue(PedalType.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        line: YesNo.parse(element.getAttribute('line')),
        sign: YesNo.parse(element.getAttribute('sign')),
        abbreviated: YesNo.parse(element.getAttribute('abbreviated')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  PedalType type;

  int? number;

  YesNo? line;

  YesNo? sign;

  YesNo? abbreviated;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (line != null) {
      node.setAttribute('line', line!.xmlValue);
    }
    if (sign != null) {
      node.setAttribute('sign', sign!.xmlValue);
    }
    if (abbreviated != null) {
      node.setAttribute('abbreviated', abbreviated!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The pedal-tuning type specifies the tuning of a single harp pedal.
class PedalTuning {
  PedalTuning({
    required this.pedalStep,
    required this.pedalAlter,
  });

  /// Reads an instance from [element].
  factory PedalTuning.fromXml(XmlElement element) =>
      PedalTuning(
        pedalStep: xmlRequiredValue(Step.parse(xmlElementText(element, 'pedal-step')), 'pedal-step', element),
        pedalAlter: xmlDouble(xmlElementText(element, 'pedal-alter')) ?? 0,
      );

  /// The pedal-step element defines the pitch step for a single harp pedal.
  Step pedalStep;

  /// The pedal-alter element defines the chromatic alteration for a single
  /// harp pedal.
  double pedalAlter;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('pedal-step', pedalStep.xmlValue));
    node.children.add(xmlTextElement('pedal-alter', xmlNumberText(pedalAlter)));
    return node;
  }
}

/// The per-minute type can be a number, or a text description including
/// numbers. If a font is specified, it overrides the font specified for the
/// overall metronome element. This allows separate specification of a music
/// font for the beat-unit and a text font for the numeric value, in cases
/// where a single metronome font is not used.
class PerMinute {
  PerMinute({
    required this.value,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
  });

  /// Reads an instance from [element].
  factory PerMinute.fromXml(XmlElement element) =>
      PerMinute(
        value: element.innerText,
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
      );

  /// The element's text content.
  String value;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The percussion element is used to define percussion pictogram symbols.
/// Definitions for these symbols can be found in Kurt Stone's "Music Notation
/// in the Twentieth Century" on pages 206-212 and 223. Some values are added
/// to these based on how usage has evolved in the 30 years since Stone's book
/// was published.
class Percussion {
  Percussion({
    this.glass,
    this.metal,
    this.wood,
    this.pitched,
    this.membrane,
    this.effect,
    this.timpani,
    this.beater,
    this.stick,
    this.stickLocation,
    this.otherPercussion,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.enclosure,
    this.id,
  });

  /// Reads an instance from [element].
  factory Percussion.fromXml(XmlElement element) =>
      Percussion(
        glass: switch (xmlElement(element, 'glass')) {
          final child? => Glass.fromXml(child),
          _ => null,
        },
        metal: switch (xmlElement(element, 'metal')) {
          final child? => Metal.fromXml(child),
          _ => null,
        },
        wood: switch (xmlElement(element, 'wood')) {
          final child? => Wood.fromXml(child),
          _ => null,
        },
        pitched: switch (xmlElement(element, 'pitched')) {
          final child? => Pitched.fromXml(child),
          _ => null,
        },
        membrane: switch (xmlElement(element, 'membrane')) {
          final child? => Membrane.fromXml(child),
          _ => null,
        },
        effect: switch (xmlElement(element, 'effect')) {
          final child? => Effect.fromXml(child),
          _ => null,
        },
        timpani: switch (xmlElement(element, 'timpani')) {
          final child? => Timpani.fromXml(child),
          _ => null,
        },
        beater: switch (xmlElement(element, 'beater')) {
          final child? => Beater.fromXml(child),
          _ => null,
        },
        stick: switch (xmlElement(element, 'stick')) {
          final child? => Stick.fromXml(child),
          _ => null,
        },
        stickLocation: StickLocation.parse(xmlElementText(element, 'stick-location')),
        otherPercussion: switch (xmlElement(element, 'other-percussion')) {
          final child? => OtherText.fromXml(child),
          _ => null,
        },
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        enclosure: EnclosureShape.parse(element.getAttribute('enclosure')),
        id: element.getAttribute('id'),
      );

  Glass? glass;

  Metal? metal;

  Wood? wood;

  Pitched? pitched;

  Membrane? membrane;

  Effect? effect;

  Timpani? timpani;

  Beater? beater;

  Stick? stick;

  StickLocation? stickLocation;

  /// The other-percussion element represents percussion pictograms not
  /// defined elsewhere.
  OtherText? otherPercussion;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  EnclosureShape? enclosure;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (enclosure != null) {
      node.setAttribute('enclosure', enclosure!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (glass != null) {
      node.children.add(glass!.toXml('glass'));
    }
    if (metal != null) {
      node.children.add(metal!.toXml('metal'));
    }
    if (wood != null) {
      node.children.add(wood!.toXml('wood'));
    }
    if (pitched != null) {
      node.children.add(pitched!.toXml('pitched'));
    }
    if (membrane != null) {
      node.children.add(membrane!.toXml('membrane'));
    }
    if (effect != null) {
      node.children.add(effect!.toXml('effect'));
    }
    if (timpani != null) {
      node.children.add(timpani!.toXml('timpani'));
    }
    if (beater != null) {
      node.children.add(beater!.toXml('beater'));
    }
    if (stick != null) {
      node.children.add(stick!.toXml('stick'));
    }
    if (stickLocation != null) {
      node.children.add(xmlTextElement('stick-location', stickLocation!.xmlValue));
    }
    if (otherPercussion != null) {
      node.children.add(otherPercussion!.toXml('other-percussion'));
    }
    return node;
  }
}

/// Pitch is represented as a combination of the step of the diatonic scale,
/// the chromatic alteration, and the octave.
class Pitch {
  Pitch({
    required this.step,
    this.alter,
    required this.octave,
  });

  /// Reads an instance from [element].
  factory Pitch.fromXml(XmlElement element) =>
      Pitch(
        step: xmlRequiredValue(Step.parse(xmlElementText(element, 'step')), 'step', element),
        alter: xmlDouble(xmlElementText(element, 'alter')),
        octave: xmlInt(xmlElementText(element, 'octave')) ?? 0,
      );

  Step step;

  double? alter;

  int octave;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('step', step.xmlValue));
    if (alter != null) {
      node.children.add(xmlTextElement('alter', xmlNumberText(alter!)));
    }
    node.children.add(xmlTextElement('octave', xmlNumberText(octave)));
    return node;
  }
}

/// The pitched-value type represents pictograms for pitched percussion
/// instruments. The smufl attribute is used to distinguish different SMuFL
/// glyphs for a particular pictogram within the Tuned mallet percussion
/// pictograms range.
class Pitched {
  Pitched({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Pitched.fromXml(XmlElement element) =>
      Pitched(
        value: xmlRequiredValue(PitchedValue.parse(element.innerText), 'value', element),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  PitchedValue value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The placement-text type represents a text element with print-style and
/// placement attribute groups.
class PlacementText {
  PlacementText({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory PlacementText.fromXml(XmlElement element) =>
      PlacementText(
        value: element.innerText,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  String value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The play type specifies playback techniques to be used in conjunction with
/// the instrument-sound element. When used as part of a sound element, it
/// applies to all notes going forward in score order. In multi-instrument
/// parts, the affected instrument should be specified using the id attribute.
/// When used as part of a note element, it applies to the current note only.
class Play {
  Play({
    this.id,
    List<PlayItem>? items,
  })  : items = items ?? <PlayItem>[];

  /// Reads an instance from [element].
  factory Play.fromXml(XmlElement element) =>
      Play(
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(PlayItem.tryFromXml)
            .whereType<PlayItem>()
            .toList(),
      );

  String? id;

  /// The element content, in document order.
  List<PlayItem> items;

  /// Every `ipa` child, in document order.
  List<String> get ipaElements => [
    for (final item in items)
      if (item.ipa != null) item.ipa!,
  ];

  /// Every `mute` child, in document order.
  List<Mute> get muteElements => [
    for (final item in items)
      if (item.mute != null) item.mute!,
  ];

  /// Every `semi-pitched` child, in document order.
  List<SemiPitched> get semiPitchedElements => [
    for (final item in items)
      if (item.semiPitched != null) item.semiPitched!,
  ];

  /// Every `other-play` child, in document order.
  List<OtherPlay> get otherPlayElements => [
    for (final item in items)
      if (item.otherPlay != null) item.otherPlay!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `play`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class PlayItem {
  PlayItem({
    this.ipa,
    this.mute,
    this.semiPitched,
    this.otherPlay,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static PlayItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'ipa':
        return PlayItem(ipa: element.innerText);
      case 'mute':
        return PlayItem(mute: xmlRequiredValue(Mute.parse(element.innerText), 'mute', element));
      case 'semi-pitched':
        return PlayItem(semiPitched: xmlRequiredValue(SemiPitched.parse(element.innerText), 'semi-pitched', element));
      case 'other-play':
        return PlayItem(otherPlay: OtherPlay.fromXml(element));
    }
    return null;
  }

  /// The ipa element represents International Phonetic Alphabet (IPA) sounds
  /// for vocal music. String content is limited to IPA 2015 symbols
  /// represented in Unicode 13.0.
  String? ipa;

  Mute? mute;

  SemiPitched? semiPitched;

  OtherPlay? otherPlay;

  /// The name of the element this item holds.
  String? get elementName {
    if (ipa != null) return 'ipa';
    if (mute != null) return 'mute';
    if (semiPitched != null) return 'semi-pitched';
    if (otherPlay != null) return 'other-play';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (ipa != null) return xmlTextElement('ipa', ipa!);
    if (mute != null) return xmlTextElement('mute', mute!.xmlValue);
    if (semiPitched != null) return xmlTextElement('semi-pitched', semiPitched!.xmlValue);
    if (otherPlay != null) return otherPlay!.toXml('other-play');
    return null;
  }
}

/// The player type allows for multiple players per score-part for use in
/// listening applications. One player may play multiple instruments, while a
/// single instrument may include multiple players in divisi sections.
class Player {
  Player({
    required this.playerName,
    required this.id,
  });

  /// Reads an instance from [element].
  factory Player.fromXml(XmlElement element) =>
      Player(
        playerName: xmlElementText(element, 'player-name') ?? '',
        id: element.getAttribute('id') ?? '',
      );

  /// The player-name element is typically used within a software application,
  /// rather than appearing on the printed page of a score.
  String playerName;

  String id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    node.children.add(xmlTextElement('player-name', playerName));
    return node;
  }
}

/// The principal-voice type represents principal and secondary voices in a
/// score, either for analysis or for square bracket symbols that appear in a
/// score. The element content is used for analysis and may be any text value.
/// The symbol attribute indicates the type of symbol used. When used for
/// analysis separate from any printed score markings, it should be set to
/// none. Otherwise if the type is stop it should be set to plain.
class PrincipalVoice {
  PrincipalVoice({
    required this.value,
    required this.type,
    required this.symbol,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
  });

  /// Reads an instance from [element].
  factory PrincipalVoice.fromXml(XmlElement element) =>
      PrincipalVoice(
        value: element.innerText,
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        symbol: xmlRequiredValue(PrincipalVoiceSymbol.parse(element.getAttribute('symbol')), 'symbol', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  StartStop type;

  PrincipalVoiceSymbol symbol;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    node.setAttribute('symbol', symbol.xmlValue);
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The print type contains general printing parameters, including layout
/// elements. The part-name-display and part-abbreviation-display elements may
/// also be used here to change how a part name or abbreviation is displayed
/// over the course of a piece. They take effect when the current measure or a
/// succeeding measure starts a new system.
///
/// Layout group elements in a print element only apply to the current page,
/// system, or staff. Music that follows continues to take the default values
/// from the layout determined by the defaults element.
class Print {
  Print({
    this.pageLayout,
    this.systemLayout,
    List<StaffLayout>? staffLayout,
    this.measureLayout,
    this.measureNumbering,
    this.partNameDisplay,
    this.partAbbreviationDisplay,
    this.staffSpacing,
    this.newSystem,
    this.newPage,
    this.blankPage,
    this.pageNumber,
    this.id,
  })  : staffLayout = staffLayout ?? <StaffLayout>[];

  /// Reads an instance from [element].
  factory Print.fromXml(XmlElement element) =>
      Print(
        pageLayout: switch (xmlElement(element, 'page-layout')) {
          final child? => PageLayout.fromXml(child),
          _ => null,
        },
        systemLayout: switch (xmlElement(element, 'system-layout')) {
          final child? => SystemLayout.fromXml(child),
          _ => null,
        },
        staffLayout: xmlElements(element, 'staff-layout')
            .map(StaffLayout.fromXml)
            .toList(),
        measureLayout: switch (xmlElement(element, 'measure-layout')) {
          final child? => MeasureLayout.fromXml(child),
          _ => null,
        },
        measureNumbering: switch (xmlElement(element, 'measure-numbering')) {
          final child? => MeasureNumbering.fromXml(child),
          _ => null,
        },
        partNameDisplay: switch (xmlElement(element, 'part-name-display')) {
          final child? => NameDisplay.fromXml(child),
          _ => null,
        },
        partAbbreviationDisplay: switch (xmlElement(element, 'part-abbreviation-display')) {
          final child? => NameDisplay.fromXml(child),
          _ => null,
        },
        staffSpacing: xmlDouble(element.getAttribute('staff-spacing')),
        newSystem: YesNo.parse(element.getAttribute('new-system')),
        newPage: YesNo.parse(element.getAttribute('new-page')),
        blankPage: xmlInt(element.getAttribute('blank-page')),
        pageNumber: element.getAttribute('page-number'),
        id: element.getAttribute('id'),
      );

  PageLayout? pageLayout;

  SystemLayout? systemLayout;

  List<StaffLayout> staffLayout;

  MeasureLayout? measureLayout;

  MeasureNumbering? measureNumbering;

  NameDisplay? partNameDisplay;

  NameDisplay? partAbbreviationDisplay;

  double? staffSpacing;

  YesNo? newSystem;

  YesNo? newPage;

  int? blankPage;

  String? pageNumber;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (staffSpacing != null) {
      node.setAttribute('staff-spacing', xmlNumberText(staffSpacing!));
    }
    if (newSystem != null) {
      node.setAttribute('new-system', newSystem!.xmlValue);
    }
    if (newPage != null) {
      node.setAttribute('new-page', newPage!.xmlValue);
    }
    if (blankPage != null) {
      node.setAttribute('blank-page', xmlNumberText(blankPage!));
    }
    if (pageNumber != null) {
      node.setAttribute('page-number', pageNumber!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (pageLayout != null) {
      node.children.add(pageLayout!.toXml('page-layout'));
    }
    if (systemLayout != null) {
      node.children.add(systemLayout!.toXml('system-layout'));
    }
    for (final item in staffLayout) {
      node.children.add(item.toXml('staff-layout'));
    }
    if (measureLayout != null) {
      node.children.add(measureLayout!.toXml('measure-layout'));
    }
    if (measureNumbering != null) {
      node.children.add(measureNumbering!.toXml('measure-numbering'));
    }
    if (partNameDisplay != null) {
      node.children.add(partNameDisplay!.toXml('part-name-display'));
    }
    if (partAbbreviationDisplay != null) {
      node.children.add(partAbbreviationDisplay!.toXml('part-abbreviation-display'));
    }
    return node;
  }
}

/// The release type indicates that a bend is a release rather than a normal
/// bend or pre-bend. The offset attribute specifies where the release starts
/// in terms of divisions relative to the current note. The first-beat and
/// last-beat attributes of the parent bend element are relative to the
/// original note position, not this offset value.
class Release {
  Release({
    this.offset,
  });

  /// Reads an instance from [element].
  factory Release.fromXml(XmlElement element) =>
      Release(
        offset: xmlDouble(element.getAttribute('offset')),
      );

  double? offset;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (offset != null) {
      node.setAttribute('offset', xmlNumberText(offset!));
    }
    return node;
  }
}

/// The repeat type represents repeat marks. The start of the repeat has a
/// forward direction while the end of the repeat has a backward direction.
/// The times and after-jump attributes are only used with backward repeats
/// that are not part of an ending. The times attribute indicates the number
/// of times the repeated section is played. The after-jump attribute
/// indicates if the repeats are played after a jump due to a da capo or dal
/// segno.
class Repeat {
  Repeat({
    required this.direction,
    this.times,
    this.afterJump,
    this.winged,
  });

  /// Reads an instance from [element].
  factory Repeat.fromXml(XmlElement element) =>
      Repeat(
        direction: xmlRequiredValue(BackwardForward.parse(element.getAttribute('direction')), 'direction', element),
        times: xmlInt(element.getAttribute('times')),
        afterJump: YesNo.parse(element.getAttribute('after-jump')),
        winged: Winged.parse(element.getAttribute('winged')),
      );

  BackwardForward direction;

  int? times;

  YesNo? afterJump;

  Winged? winged;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('direction', direction.xmlValue);
    if (times != null) {
      node.setAttribute('times', xmlNumberText(times!));
    }
    if (afterJump != null) {
      node.setAttribute('after-jump', afterJump!.xmlValue);
    }
    if (winged != null) {
      node.setAttribute('winged', winged!.xmlValue);
    }
    return node;
  }
}

/// The rest element indicates notated rests or silences. Rest elements are
/// usually empty, but placement on the staff can be specified using
/// display-step and display-octave elements. If the measure attribute is set
/// to yes, this indicates this is a complete measure rest.
class Rest {
  Rest({
    this.displayStep,
    this.displayOctave,
    this.measure,
  });

  /// Reads an instance from [element].
  factory Rest.fromXml(XmlElement element) =>
      Rest(
        displayStep: Step.parse(xmlElementText(element, 'display-step')),
        displayOctave: xmlInt(xmlElementText(element, 'display-octave')),
        measure: YesNo.parse(element.getAttribute('measure')),
      );

  Step? displayStep;

  int? displayOctave;

  YesNo? measure;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (measure != null) {
      node.setAttribute('measure', measure!.xmlValue);
    }
    if (displayStep != null) {
      node.children.add(xmlTextElement('display-step', displayStep!.xmlValue));
    }
    if (displayOctave != null) {
      node.children.add(xmlTextElement('display-octave', xmlNumberText(displayOctave!)));
    }
    return node;
  }
}

/// The root type indicates a pitch like C, D, E vs. a scale degree like 1, 2,
/// 3. It is used with chord symbols in popular music. The root element has a
/// root-step and optional root-alter element similar to the step and alter
/// elements, but renamed to distinguish the different musical meanings.
class Root {
  Root({
    required this.rootStep,
    this.rootAlter,
  });

  /// Reads an instance from [element].
  factory Root.fromXml(XmlElement element) =>
      Root(
        rootStep: RootStep.fromXml(xmlRequiredElement(element, 'root-step')),
        rootAlter: switch (xmlElement(element, 'root-alter')) {
          final child? => HarmonyAlter.fromXml(child),
          _ => null,
        },
      );

  RootStep rootStep;

  /// The root-alter element represents the chromatic alteration of the root
  /// of the current chord within the harmony element. In some chord styles,
  /// the text for the root-step element may include root-alter information.
  /// In that case, the print-object attribute of the root-alter element can
  /// be set to no. The location attribute indicates whether the alteration
  /// should appear to the left or the right of the root-step; it is right by
  /// default.
  HarmonyAlter? rootAlter;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(rootStep.toXml('root-step'));
    if (rootAlter != null) {
      node.children.add(rootAlter!.toXml('root-alter'));
    }
    return node;
  }
}

/// The root-step type represents the pitch step of the root of the current
/// chord within the harmony element. The text attribute indicates how the
/// root should appear in a score if not using the element contents.
class RootStep {
  RootStep({
    required this.value,
    this.text,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory RootStep.fromXml(XmlElement element) =>
      RootStep(
        value: xmlRequiredValue(Step.parse(element.innerText), 'value', element),
        text: element.getAttribute('text'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  Step value;

  String? text;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// Margins, page sizes, and distances are all measured in tenths to keep
/// MusicXML data in a consistent coordinate system as much as possible. The
/// translation to absolute units is done with the scaling type, which
/// specifies how many millimeters are equal to how many tenths. For a staff
/// height of 7 mm, millimeters would be set to 7 while tenths is set to 40.
/// The ability to set a formula rather than a single scaling factor helps
/// avoid roundoff errors.
class Scaling {
  Scaling({
    required this.millimeters,
    required this.tenths,
  });

  /// Reads an instance from [element].
  factory Scaling.fromXml(XmlElement element) =>
      Scaling(
        millimeters: xmlDouble(xmlElementText(element, 'millimeters')) ?? 0,
        tenths: xmlDouble(xmlElementText(element, 'tenths')) ?? 0,
      );

  double millimeters;

  double tenths;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('millimeters', xmlNumberText(millimeters)));
    node.children.add(xmlTextElement('tenths', xmlNumberText(tenths)));
    return node;
  }
}

/// Scordatura string tunings are represented by a series of accord elements,
/// similar to the staff-tuning elements. Strings are numbered from high to
/// low.
class Scordatura {
  Scordatura({
    List<Accord>? accord,
    this.id,
  })  : accord = accord ?? <Accord>[];

  /// Reads an instance from [element].
  factory Scordatura.fromXml(XmlElement element) =>
      Scordatura(
        accord: xmlElements(element, 'accord')
            .map(Accord.fromXml)
            .toList(),
        id: element.getAttribute('id'),
      );

  List<Accord> accord;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in accord) {
      node.children.add(item.toXml('accord'));
    }
    return node;
  }
}

/// The score-instrument type represents a single instrument within a
/// score-part. As with the score-part type, each score-instrument has a
/// required ID attribute, a name, and an optional abbreviation.
///
/// A score-instrument type is also required if the score specifies MIDI 1.0
/// channels, banks, or programs. An initial midi-instrument assignment can
/// also be made here. MusicXML software should be able to automatically
/// assign reasonable channels and instruments without these elements in
/// simple cases, such as where part names match General MIDI instrument
/// names.
///
/// The score-instrument element can also distinguish multiple instruments of
/// the same type that are on the same part, such as Clarinet 1 and Clarinet 2
/// instruments within a Clarinets 1 and 2 part.
class ScoreInstrument {
  ScoreInstrument({
    required this.instrumentName,
    this.instrumentAbbreviation,
    this.instrumentSound,
    this.solo,
    this.ensemble,
    this.virtualInstrument,
    required this.id,
  });

  /// Reads an instance from [element].
  factory ScoreInstrument.fromXml(XmlElement element) =>
      ScoreInstrument(
        instrumentName: xmlElementText(element, 'instrument-name') ?? '',
        instrumentAbbreviation: xmlElementText(element, 'instrument-abbreviation'),
        instrumentSound: xmlElementText(element, 'instrument-sound'),
        solo: switch (xmlElement(element, 'solo')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        ensemble: xmlElementText(element, 'ensemble'),
        virtualInstrument: switch (xmlElement(element, 'virtual-instrument')) {
          final child? => VirtualInstrument.fromXml(child),
          _ => null,
        },
        id: element.getAttribute('id') ?? '',
      );

  /// The instrument-name element is typically used within a software
  /// application, rather than appearing on the printed page of a score.
  String instrumentName;

  /// The optional instrument-abbreviation element is typically used within a
  /// software application, rather than appearing on the printed page of a
  /// score.
  String? instrumentAbbreviation;

  /// The instrument-sound element describes the default timbre of the
  /// score-instrument. This description is independent of a particular
  /// virtual or MIDI instrument specification and allows playback to be
  /// shared more easily between applications and libraries.
  String? instrumentSound;

  /// The solo element is present if performance is intended by a solo
  /// instrument.
  Empty? solo;

  /// The ensemble element is present if performance is intended by an
  /// ensemble such as an orchestral section. The text of the ensemble element
  /// contains the size of the section, or is empty if the ensemble size is
  /// not specified.
  String? ensemble;

  VirtualInstrument? virtualInstrument;

  String id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    node.children.add(xmlTextElement('instrument-name', instrumentName));
    if (instrumentAbbreviation != null) {
      node.children.add(xmlTextElement('instrument-abbreviation', instrumentAbbreviation!));
    }
    if (instrumentSound != null) {
      node.children.add(xmlTextElement('instrument-sound', instrumentSound!));
    }
    if (solo != null) {
      node.children.add(solo!.toXml('solo'));
    }
    if (ensemble != null) {
      node.children.add(xmlTextElement('ensemble', ensemble!));
    }
    if (virtualInstrument != null) {
      node.children.add(virtualInstrument!.toXml('virtual-instrument'));
    }
    return node;
  }
}

/// The score-part type collects part-wide information for each part in a
/// score. Often, each MusicXML part corresponds to a track in a Standard MIDI
/// Format 1 file. In this case, the midi-device element is used to make a
/// MIDI device or port assignment for the given track or specific MIDI
/// instruments. Initial midi-instrument assignments may be made here as well.
/// The score-instrument elements are used when there are multiple instruments
/// per track.
class ScorePart {
  ScorePart({
    required this.id,
    List<ScorePartItem>? items,
  })  : items = items ?? <ScorePartItem>[];

  /// Reads an instance from [element].
  factory ScorePart.fromXml(XmlElement element) =>
      ScorePart(
        id: element.getAttribute('id') ?? '',
        items: xmlChildren(element)
            .map(ScorePartItem.tryFromXml)
            .whereType<ScorePartItem>()
            .toList(),
      );

  String id;

  /// The element content, in document order.
  List<ScorePartItem> items;

  /// Every `identification` child, in document order.
  List<Identification> get identificationElements => [
    for (final item in items)
      if (item.identification != null) item.identification!,
  ];

  /// Every `part-link` child, in document order.
  List<PartLink> get partLinkElements => [
    for (final item in items)
      if (item.partLink != null) item.partLink!,
  ];

  /// Every `part-name` child, in document order.
  List<PartName> get partNameElements => [
    for (final item in items)
      if (item.partName != null) item.partName!,
  ];

  /// Every `part-name-display` child, in document order.
  List<NameDisplay> get partNameDisplayElements => [
    for (final item in items)
      if (item.partNameDisplay != null) item.partNameDisplay!,
  ];

  /// Every `part-abbreviation` child, in document order.
  List<PartName> get partAbbreviationElements => [
    for (final item in items)
      if (item.partAbbreviation != null) item.partAbbreviation!,
  ];

  /// Every `part-abbreviation-display` child, in document order.
  List<NameDisplay> get partAbbreviationDisplayElements => [
    for (final item in items)
      if (item.partAbbreviationDisplay != null) item.partAbbreviationDisplay!,
  ];

  /// Every `group` child, in document order.
  List<String> get groupElements => [
    for (final item in items)
      if (item.group != null) item.group!,
  ];

  /// Every `score-instrument` child, in document order.
  List<ScoreInstrument> get scoreInstrumentElements => [
    for (final item in items)
      if (item.scoreInstrument != null) item.scoreInstrument!,
  ];

  /// Every `player` child, in document order.
  List<Player> get playerElements => [
    for (final item in items)
      if (item.player != null) item.player!,
  ];

  /// Every `midi-device` child, in document order.
  List<MidiDevice> get midiDeviceElements => [
    for (final item in items)
      if (item.midiDevice != null) item.midiDevice!,
  ];

  /// Every `midi-instrument` child, in document order.
  List<MidiInstrument> get midiInstrumentElements => [
    for (final item in items)
      if (item.midiInstrument != null) item.midiInstrument!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `score-part`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class ScorePartItem {
  ScorePartItem({
    this.identification,
    this.partLink,
    this.partName,
    this.partNameDisplay,
    this.partAbbreviation,
    this.partAbbreviationDisplay,
    this.group,
    this.scoreInstrument,
    this.player,
    this.midiDevice,
    this.midiInstrument,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static ScorePartItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'identification':
        return ScorePartItem(identification: Identification.fromXml(element));
      case 'part-link':
        return ScorePartItem(partLink: PartLink.fromXml(element));
      case 'part-name':
        return ScorePartItem(partName: PartName.fromXml(element));
      case 'part-name-display':
        return ScorePartItem(partNameDisplay: NameDisplay.fromXml(element));
      case 'part-abbreviation':
        return ScorePartItem(partAbbreviation: PartName.fromXml(element));
      case 'part-abbreviation-display':
        return ScorePartItem(partAbbreviationDisplay: NameDisplay.fromXml(element));
      case 'group':
        return ScorePartItem(group: element.innerText);
      case 'score-instrument':
        return ScorePartItem(scoreInstrument: ScoreInstrument.fromXml(element));
      case 'player':
        return ScorePartItem(player: Player.fromXml(element));
      case 'midi-device':
        return ScorePartItem(midiDevice: MidiDevice.fromXml(element));
      case 'midi-instrument':
        return ScorePartItem(midiInstrument: MidiInstrument.fromXml(element));
    }
    return null;
  }

  Identification? identification;

  PartLink? partLink;

  PartName? partName;

  NameDisplay? partNameDisplay;

  PartName? partAbbreviation;

  NameDisplay? partAbbreviationDisplay;

  /// The group element allows the use of different versions of the part for
  /// different purposes. Typical values include score, parts, sound, and
  /// data. Ordering information can be derived from the ordering within a
  /// MusicXML score or opus.
  String? group;

  ScoreInstrument? scoreInstrument;

  Player? player;

  MidiDevice? midiDevice;

  MidiInstrument? midiInstrument;

  /// The name of the element this item holds.
  String? get elementName {
    if (identification != null) return 'identification';
    if (partLink != null) return 'part-link';
    if (partName != null) return 'part-name';
    if (partNameDisplay != null) return 'part-name-display';
    if (partAbbreviation != null) return 'part-abbreviation';
    if (partAbbreviationDisplay != null) return 'part-abbreviation-display';
    if (group != null) return 'group';
    if (scoreInstrument != null) return 'score-instrument';
    if (player != null) return 'player';
    if (midiDevice != null) return 'midi-device';
    if (midiInstrument != null) return 'midi-instrument';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (identification != null) return identification!.toXml('identification');
    if (partLink != null) return partLink!.toXml('part-link');
    if (partName != null) return partName!.toXml('part-name');
    if (partNameDisplay != null) return partNameDisplay!.toXml('part-name-display');
    if (partAbbreviation != null) return partAbbreviation!.toXml('part-abbreviation');
    if (partAbbreviationDisplay != null) return partAbbreviationDisplay!.toXml('part-abbreviation-display');
    if (group != null) return xmlTextElement('group', group!);
    if (scoreInstrument != null) return scoreInstrument!.toXml('score-instrument');
    if (player != null) return player!.toXml('player');
    if (midiDevice != null) return midiDevice!.toXml('midi-device');
    if (midiInstrument != null) return midiInstrument!.toXml('midi-instrument');
    return null;
  }
}

/// The score-partwise element is the root element for a partwise MusicXML
/// score. It includes a score-header group followed by a series of parts with
/// measures inside. The document-attributes attribute group includes the
/// version attribute.
class ScorePartwise {
  ScorePartwise({
    this.work,
    this.movementNumber,
    this.movementTitle,
    this.identification,
    this.defaults,
    List<Credit>? credit,
    required this.partList,
    List<ScorePartwisePart>? part,
    this.version,
  })  : credit = credit ?? <Credit>[],
        part = part ?? <ScorePartwisePart>[];

  /// Reads an instance from [element].
  factory ScorePartwise.fromXml(XmlElement element) =>
      ScorePartwise(
        work: switch (xmlElement(element, 'work')) {
          final child? => Work.fromXml(child),
          _ => null,
        },
        movementNumber: xmlElementText(element, 'movement-number'),
        movementTitle: xmlElementText(element, 'movement-title'),
        identification: switch (xmlElement(element, 'identification')) {
          final child? => Identification.fromXml(child),
          _ => null,
        },
        defaults: switch (xmlElement(element, 'defaults')) {
          final child? => Defaults.fromXml(child),
          _ => null,
        },
        credit: xmlElements(element, 'credit')
            .map(Credit.fromXml)
            .toList(),
        partList: PartList.fromXml(xmlRequiredElement(element, 'part-list')),
        part: xmlElements(element, 'part')
            .map(ScorePartwisePart.fromXml)
            .toList(),
        version: element.getAttribute('version') ?? '1.0',
      );

  Work? work;

  /// The movement-number element specifies the number of a movement.
  String? movementNumber;

  /// The movement-title element specifies the title of a movement, not
  /// including its number.
  String? movementTitle;

  Identification? identification;

  Defaults? defaults;

  List<Credit> credit;

  PartList partList;

  List<ScorePartwisePart> part;

  String? version;

  /// Writes this value as an element named [name].
  XmlElement toXml([String elementName = 'score-partwise']) {
    final node = XmlElement(XmlName(elementName));
    if (version != null) {
      node.setAttribute('version', version!);
    }
    if (work != null) {
      node.children.add(work!.toXml('work'));
    }
    if (movementNumber != null) {
      node.children.add(xmlTextElement('movement-number', movementNumber!));
    }
    if (movementTitle != null) {
      node.children.add(xmlTextElement('movement-title', movementTitle!));
    }
    if (identification != null) {
      node.children.add(identification!.toXml('identification'));
    }
    if (defaults != null) {
      node.children.add(defaults!.toXml('defaults'));
    }
    for (final item in credit) {
      node.children.add(item.toXml('credit'));
    }
    node.children.add(partList.toXml('part-list'));
    for (final item in part) {
      node.children.add(item.toXml('part'));
    }
    return node;
  }
}

class ScorePartwisePart {
  ScorePartwisePart({
    List<ScorePartwisePartMeasure>? measure,
    required this.id,
  })  : measure = measure ?? <ScorePartwisePartMeasure>[];

  /// Reads an instance from [element].
  factory ScorePartwisePart.fromXml(XmlElement element) =>
      ScorePartwisePart(
        measure: xmlElements(element, 'measure')
            .map(ScorePartwisePartMeasure.fromXml)
            .toList(),
        id: element.getAttribute('id') ?? '',
      );

  List<ScorePartwisePartMeasure> measure;

  String id;

  /// Writes this value as an element named [name].
  XmlElement toXml([String elementName = 'part']) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    for (final item in measure) {
      node.children.add(item.toXml('measure'));
    }
    return node;
  }
}

class ScorePartwisePartMeasure {
  ScorePartwisePartMeasure({
    required this.number,
    this.text,
    this.implicit,
    this.nonControlling,
    this.width,
    this.id,
    List<MusicDataItem>? items,
  })  : items = items ?? <MusicDataItem>[];

  /// Reads an instance from [element].
  factory ScorePartwisePartMeasure.fromXml(XmlElement element) =>
      ScorePartwisePartMeasure(
        number: element.getAttribute('number') ?? '',
        text: element.getAttribute('text'),
        implicit: YesNo.parse(element.getAttribute('implicit')),
        nonControlling: YesNo.parse(element.getAttribute('non-controlling')),
        width: xmlDouble(element.getAttribute('width')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(MusicDataItem.tryFromXml)
            .whereType<MusicDataItem>()
            .toList(),
      );

  String number;

  String? text;

  YesNo? implicit;

  YesNo? nonControlling;

  double? width;

  String? id;

  /// The element content, in document order.
  List<MusicDataItem> items;

  /// Every `note` child, in document order.
  List<Note> get noteElements => [
    for (final item in items)
      if (item.note != null) item.note!,
  ];

  /// Every `backup` child, in document order.
  List<Backup> get backupElements => [
    for (final item in items)
      if (item.backup != null) item.backup!,
  ];

  /// Every `forward` child, in document order.
  List<Forward> get forwardElements => [
    for (final item in items)
      if (item.forward != null) item.forward!,
  ];

  /// Every `direction` child, in document order.
  List<Direction> get directionElements => [
    for (final item in items)
      if (item.direction != null) item.direction!,
  ];

  /// Every `attributes` child, in document order.
  List<Attributes> get attributesElements => [
    for (final item in items)
      if (item.attributes != null) item.attributes!,
  ];

  /// Every `harmony` child, in document order.
  List<Harmony> get harmonyElements => [
    for (final item in items)
      if (item.harmony != null) item.harmony!,
  ];

  /// Every `figured-bass` child, in document order.
  List<FiguredBass> get figuredBassElements => [
    for (final item in items)
      if (item.figuredBass != null) item.figuredBass!,
  ];

  /// Every `print` child, in document order.
  List<Print> get printElements => [
    for (final item in items)
      if (item.print != null) item.print!,
  ];

  /// Every `sound` child, in document order.
  List<Sound> get soundElements => [
    for (final item in items)
      if (item.sound != null) item.sound!,
  ];

  /// Every `listening` child, in document order.
  List<Listening> get listeningElements => [
    for (final item in items)
      if (item.listening != null) item.listening!,
  ];

  /// Every `barline` child, in document order.
  List<Barline> get barlineElements => [
    for (final item in items)
      if (item.barline != null) item.barline!,
  ];

  /// Every `grouping` child, in document order.
  List<Grouping> get groupingElements => [
    for (final item in items)
      if (item.grouping != null) item.grouping!,
  ];

  /// Every `link` child, in document order.
  List<Link> get linkElements => [
    for (final item in items)
      if (item.link != null) item.link!,
  ];

  /// Every `bookmark` child, in document order.
  List<Bookmark> get bookmarkElements => [
    for (final item in items)
      if (item.bookmark != null) item.bookmark!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml([String elementName = 'measure']) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('number', number);
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (implicit != null) {
      node.setAttribute('implicit', implicit!.xmlValue);
    }
    if (nonControlling != null) {
      node.setAttribute('non-controlling', nonControlling!.xmlValue);
    }
    if (width != null) {
      node.setAttribute('width', xmlNumberText(width!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// The score-timewise element is the root element for a timewise MusicXML
/// score. It includes a score-header group followed by a series of measures
/// with parts inside. The document-attributes attribute group includes the
/// version attribute.
class ScoreTimewise {
  ScoreTimewise({
    this.work,
    this.movementNumber,
    this.movementTitle,
    this.identification,
    this.defaults,
    List<Credit>? credit,
    required this.partList,
    List<ScoreTimewiseMeasure>? measure,
    this.version,
  })  : credit = credit ?? <Credit>[],
        measure = measure ?? <ScoreTimewiseMeasure>[];

  /// Reads an instance from [element].
  factory ScoreTimewise.fromXml(XmlElement element) =>
      ScoreTimewise(
        work: switch (xmlElement(element, 'work')) {
          final child? => Work.fromXml(child),
          _ => null,
        },
        movementNumber: xmlElementText(element, 'movement-number'),
        movementTitle: xmlElementText(element, 'movement-title'),
        identification: switch (xmlElement(element, 'identification')) {
          final child? => Identification.fromXml(child),
          _ => null,
        },
        defaults: switch (xmlElement(element, 'defaults')) {
          final child? => Defaults.fromXml(child),
          _ => null,
        },
        credit: xmlElements(element, 'credit')
            .map(Credit.fromXml)
            .toList(),
        partList: PartList.fromXml(xmlRequiredElement(element, 'part-list')),
        measure: xmlElements(element, 'measure')
            .map(ScoreTimewiseMeasure.fromXml)
            .toList(),
        version: element.getAttribute('version') ?? '1.0',
      );

  Work? work;

  /// The movement-number element specifies the number of a movement.
  String? movementNumber;

  /// The movement-title element specifies the title of a movement, not
  /// including its number.
  String? movementTitle;

  Identification? identification;

  Defaults? defaults;

  List<Credit> credit;

  PartList partList;

  List<ScoreTimewiseMeasure> measure;

  String? version;

  /// Writes this value as an element named [name].
  XmlElement toXml([String elementName = 'score-timewise']) {
    final node = XmlElement(XmlName(elementName));
    if (version != null) {
      node.setAttribute('version', version!);
    }
    if (work != null) {
      node.children.add(work!.toXml('work'));
    }
    if (movementNumber != null) {
      node.children.add(xmlTextElement('movement-number', movementNumber!));
    }
    if (movementTitle != null) {
      node.children.add(xmlTextElement('movement-title', movementTitle!));
    }
    if (identification != null) {
      node.children.add(identification!.toXml('identification'));
    }
    if (defaults != null) {
      node.children.add(defaults!.toXml('defaults'));
    }
    for (final item in credit) {
      node.children.add(item.toXml('credit'));
    }
    node.children.add(partList.toXml('part-list'));
    for (final item in measure) {
      node.children.add(item.toXml('measure'));
    }
    return node;
  }
}

class ScoreTimewiseMeasure {
  ScoreTimewiseMeasure({
    List<ScoreTimewiseMeasurePart>? part,
    required this.number,
    this.text,
    this.implicit,
    this.nonControlling,
    this.width,
    this.id,
  })  : part = part ?? <ScoreTimewiseMeasurePart>[];

  /// Reads an instance from [element].
  factory ScoreTimewiseMeasure.fromXml(XmlElement element) =>
      ScoreTimewiseMeasure(
        part: xmlElements(element, 'part')
            .map(ScoreTimewiseMeasurePart.fromXml)
            .toList(),
        number: element.getAttribute('number') ?? '',
        text: element.getAttribute('text'),
        implicit: YesNo.parse(element.getAttribute('implicit')),
        nonControlling: YesNo.parse(element.getAttribute('non-controlling')),
        width: xmlDouble(element.getAttribute('width')),
        id: element.getAttribute('id'),
      );

  List<ScoreTimewiseMeasurePart> part;

  String number;

  String? text;

  YesNo? implicit;

  YesNo? nonControlling;

  double? width;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml([String elementName = 'measure']) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('number', number);
    if (text != null) {
      node.setAttribute('text', text!);
    }
    if (implicit != null) {
      node.setAttribute('implicit', implicit!.xmlValue);
    }
    if (nonControlling != null) {
      node.setAttribute('non-controlling', nonControlling!.xmlValue);
    }
    if (width != null) {
      node.setAttribute('width', xmlNumberText(width!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in part) {
      node.children.add(item.toXml('part'));
    }
    return node;
  }
}

class ScoreTimewiseMeasurePart {
  ScoreTimewiseMeasurePart({
    required this.id,
    List<MusicDataItem>? items,
  })  : items = items ?? <MusicDataItem>[];

  /// Reads an instance from [element].
  factory ScoreTimewiseMeasurePart.fromXml(XmlElement element) =>
      ScoreTimewiseMeasurePart(
        id: element.getAttribute('id') ?? '',
        items: xmlChildren(element)
            .map(MusicDataItem.tryFromXml)
            .whereType<MusicDataItem>()
            .toList(),
      );

  String id;

  /// The element content, in document order.
  List<MusicDataItem> items;

  /// Every `note` child, in document order.
  List<Note> get noteElements => [
    for (final item in items)
      if (item.note != null) item.note!,
  ];

  /// Every `backup` child, in document order.
  List<Backup> get backupElements => [
    for (final item in items)
      if (item.backup != null) item.backup!,
  ];

  /// Every `forward` child, in document order.
  List<Forward> get forwardElements => [
    for (final item in items)
      if (item.forward != null) item.forward!,
  ];

  /// Every `direction` child, in document order.
  List<Direction> get directionElements => [
    for (final item in items)
      if (item.direction != null) item.direction!,
  ];

  /// Every `attributes` child, in document order.
  List<Attributes> get attributesElements => [
    for (final item in items)
      if (item.attributes != null) item.attributes!,
  ];

  /// Every `harmony` child, in document order.
  List<Harmony> get harmonyElements => [
    for (final item in items)
      if (item.harmony != null) item.harmony!,
  ];

  /// Every `figured-bass` child, in document order.
  List<FiguredBass> get figuredBassElements => [
    for (final item in items)
      if (item.figuredBass != null) item.figuredBass!,
  ];

  /// Every `print` child, in document order.
  List<Print> get printElements => [
    for (final item in items)
      if (item.print != null) item.print!,
  ];

  /// Every `sound` child, in document order.
  List<Sound> get soundElements => [
    for (final item in items)
      if (item.sound != null) item.sound!,
  ];

  /// Every `listening` child, in document order.
  List<Listening> get listeningElements => [
    for (final item in items)
      if (item.listening != null) item.listening!,
  ];

  /// Every `barline` child, in document order.
  List<Barline> get barlineElements => [
    for (final item in items)
      if (item.barline != null) item.barline!,
  ];

  /// Every `grouping` child, in document order.
  List<Grouping> get groupingElements => [
    for (final item in items)
      if (item.grouping != null) item.grouping!,
  ];

  /// Every `link` child, in document order.
  List<Link> get linkElements => [
    for (final item in items)
      if (item.link != null) item.link!,
  ];

  /// Every `bookmark` child, in document order.
  List<Bookmark> get bookmarkElements => [
    for (final item in items)
      if (item.bookmark != null) item.bookmark!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml([String elementName = 'part']) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('id', id);
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// The segno type is the visual indicator of a segno sign. The exact glyph
/// can be specified with the smufl attribute. A sound element is also needed
/// to guide playback applications reliably.
class Segno {
  Segno({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Segno.fromXml(XmlElement element) =>
      Segno(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
        smufl: element.getAttribute('smufl'),
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    return node;
  }
}

/// The slash type is used to indicate that slash notation is to be used. If
/// the slash is on every beat, use-stems is no (the default). To indicate
/// rhythms but not pitches, use-stems is set to yes. The type attribute
/// indicates whether this is the start or stop of a slash notation style. The
/// use-dots attribute works as for the beat-repeat element, and only has
/// effect if use-stems is no.
class Slash {
  Slash({
    this.slashType,
    List<Empty>? slashDot,
    List<String>? exceptVoice,
    required this.type,
    this.useDots,
    this.useStems,
  })  : slashDot = slashDot ?? <Empty>[],
        exceptVoice = exceptVoice ?? <String>[];

  /// Reads an instance from [element].
  factory Slash.fromXml(XmlElement element) =>
      Slash(
        slashType: NoteTypeValue.parse(xmlElementText(element, 'slash-type')),
        slashDot: xmlElements(element, 'slash-dot')
            .map(Empty.fromXml)
            .toList(),
        exceptVoice: xmlElements(element, 'except-voice')
            .map((e) => e.innerText)
            .toList(),
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        useDots: YesNo.parse(element.getAttribute('use-dots')),
        useStems: YesNo.parse(element.getAttribute('use-stems')),
      );

  /// The slash-type element indicates the graphical note type to use for the
  /// display of repetition marks.
  NoteTypeValue? slashType;

  /// The slash-dot element is used to specify any augmentation dots in the
  /// note type used to display repetition marks.
  List<Empty> slashDot;

  /// The except-voice element is used to specify a combination of slash
  /// notation and regular notation. Any note elements that are in voices
  /// specified by the except-voice elements are displayed in normal notation,
  /// in addition to the slash notation that is always displayed.
  List<String> exceptVoice;

  StartStop type;

  YesNo? useDots;

  YesNo? useStems;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (useDots != null) {
      node.setAttribute('use-dots', useDots!.xmlValue);
    }
    if (useStems != null) {
      node.setAttribute('use-stems', useStems!.xmlValue);
    }
    if (slashType != null) {
      node.children.add(xmlTextElement('slash-type', slashType!.xmlValue));
    }
    for (final item in slashDot) {
      node.children.add(item.toXml('slash-dot'));
    }
    for (final item in exceptVoice) {
      node.children.add(xmlTextElement('except-voice', item));
    }
    return node;
  }
}

/// Glissando and slide types both indicate rapidly moving from one pitch to
/// the other so that individual notes are not discerned. A slide is
/// continuous between the two pitches and defaults to a solid line. The
/// optional text for a is printed alongside the line.
class Slide {
  Slide({
    required this.value,
    required this.type,
    this.number,
    this.lineType,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.accelerate,
    this.beats,
    this.firstBeat,
    this.lastBeat,
    this.id,
  });

  /// Reads an instance from [element].
  factory Slide.fromXml(XmlElement element) =>
      Slide(
        value: element.innerText,
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')) ?? 1,
        lineType: LineType.parse(element.getAttribute('line-type')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        accelerate: YesNo.parse(element.getAttribute('accelerate')),
        beats: xmlDouble(element.getAttribute('beats')),
        firstBeat: xmlDouble(element.getAttribute('first-beat')),
        lastBeat: xmlDouble(element.getAttribute('last-beat')),
        id: element.getAttribute('id'),
      );

  /// The element's text content.
  String value;

  StartStop type;

  int? number;

  LineType? lineType;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  YesNo? accelerate;

  double? beats;

  double? firstBeat;

  double? lastBeat;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (accelerate != null) {
      node.setAttribute('accelerate', accelerate!.xmlValue);
    }
    if (beats != null) {
      node.setAttribute('beats', xmlNumberText(beats!));
    }
    if (firstBeat != null) {
      node.setAttribute('first-beat', xmlNumberText(firstBeat!));
    }
    if (lastBeat != null) {
      node.setAttribute('last-beat', xmlNumberText(lastBeat!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// Slur types are empty. Most slurs are represented with two elements: one
/// with a start type, and one with a stop type. Slurs can add more elements
/// using a continue type. This is typically used to specify the formatting of
/// cross-system slurs, or to specify the shape of very complex slurs.
class Slur {
  Slur({
    required this.type,
    this.number,
    this.lineType,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.placement,
    this.orientation,
    this.bezierX,
    this.bezierY,
    this.bezierX2,
    this.bezierY2,
    this.bezierOffset,
    this.bezierOffset2,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Slur.fromXml(XmlElement element) =>
      Slur(
        type: xmlRequiredValue(StartStopContinue.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')) ?? 1,
        lineType: LineType.parse(element.getAttribute('line-type')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        orientation: OverUnder.parse(element.getAttribute('orientation')),
        bezierX: xmlDouble(element.getAttribute('bezier-x')),
        bezierY: xmlDouble(element.getAttribute('bezier-y')),
        bezierX2: xmlDouble(element.getAttribute('bezier-x2')),
        bezierY2: xmlDouble(element.getAttribute('bezier-y2')),
        bezierOffset: xmlDouble(element.getAttribute('bezier-offset')),
        bezierOffset2: xmlDouble(element.getAttribute('bezier-offset2')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  StartStopContinue type;

  int? number;

  LineType? lineType;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  AboveBelow? placement;

  OverUnder? orientation;

  double? bezierX;

  double? bezierY;

  double? bezierX2;

  double? bezierY2;

  double? bezierOffset;

  double? bezierOffset2;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (orientation != null) {
      node.setAttribute('orientation', orientation!.xmlValue);
    }
    if (bezierX != null) {
      node.setAttribute('bezier-x', xmlNumberText(bezierX!));
    }
    if (bezierY != null) {
      node.setAttribute('bezier-y', xmlNumberText(bezierY!));
    }
    if (bezierX2 != null) {
      node.setAttribute('bezier-x2', xmlNumberText(bezierX2!));
    }
    if (bezierY2 != null) {
      node.setAttribute('bezier-y2', xmlNumberText(bezierY2!));
    }
    if (bezierOffset != null) {
      node.setAttribute('bezier-offset', xmlNumberText(bezierOffset!));
    }
    if (bezierOffset2 != null) {
      node.setAttribute('bezier-offset2', xmlNumberText(bezierOffset2!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The sound element contains general playback parameters. They can stand
/// alone within a part/measure, or be a component element within a direction.
///
/// Tempo is expressed in quarter notes per minute. If 0, the sound-generating
/// program should prompt the user at the time of compiling a sound (MIDI)
/// file.
///
/// Dynamics (or MIDI velocity) are expressed as a percentage of the default
/// forte value (90 for MIDI 1.0).
///
/// Dacapo indicates to go back to the beginning of the movement. When used it
/// always has the value "yes".
///
/// Segno and dalsegno are used for backwards jumps to a segno sign; coda and
/// tocoda are used for forward jumps to a coda sign. If there are multiple
/// jumps, the value of these parameters can be used to name and distinguish
/// them. If segno or coda is used, the divisions attribute can also be used
/// to indicate the number of divisions per quarter note. Otherwise sound and
/// MIDI generating programs may have to recompute this.
///
/// By default, a dalsegno or dacapo attribute indicates that the jump should
/// occur the first time through, while a tocoda attribute indicates the jump
/// should occur the second time through. The time that jumps occur can be
/// changed by using the time-only attribute.
///
/// The forward-repeat attribute indicates that a forward repeat sign is
/// implied but not displayed. It is used for example in two-part forms with
/// repeats, such as a minuet and trio where no repeat is displayed at the
/// start of the trio. This usually occurs after a barline. When used it
/// always has the value of "yes".
///
/// The fine attribute follows the final note or rest in a movement with a da
/// capo or dal segno direction. If numeric, the value represents the actual
/// duration of the final note or rest, which can be ambiguous in written
/// notation and different among parts and voices. The value may also be "yes"
/// to indicate no change to the final duration.
///
/// If the sound element applies only particular times through a repeat, the
/// time-only attribute indicates which times to apply the sound element.
///
/// Pizzicato in a sound element effects all following notes. Yes indicates
/// pizzicato, no indicates arco.
///
/// The pan and elevation attributes are deprecated in Version 2.0. The pan
/// and elevation elements in the midi-instrument element should be used
/// instead. The meaning of the pan and elevation attributes is the same as
/// for the pan and elevation elements. If both are present, the
/// mid-instrument elements take priority.
///
/// The damper-pedal, soft-pedal, and sostenuto-pedal attributes effect
/// playback of the three common piano pedals and their MIDI controller
/// equivalents. The yes value indicates the pedal is depressed; no indicates
/// the pedal is released. A numeric value from 0 to 100 may also be used for
/// half pedaling. This value is the percentage that the pedal is depressed. A
/// value of 0 is equivalent to no, and a value of 100 is equivalent to yes.
///
/// Instrument changes, MIDI devices, MIDI instruments, and playback
/// techniques are changed using the instrument-change, midi-device,
/// midi-instrument, and play elements. When there are multiple instances of
/// these elements, they should be grouped together by instrument using the id
/// attribute values.
///
/// The offset element is used to indicate that the sound takes place offset
/// from the current score position. If the sound element is a child of a
/// direction element, the sound offset element overrides the direction offset
/// element if both elements are present. Note that the offset reflects the
/// intended musical position for the change in sound. It should not be used
/// to compensate for latency issues in particular hardware configurations.
class Sound {
  Sound({
    this.tempo,
    this.dynamics,
    this.dacapo,
    this.segno,
    this.dalsegno,
    this.coda,
    this.tocoda,
    this.divisions,
    this.forwardRepeat,
    this.fine,
    this.timeOnly,
    this.pizzicato,
    this.pan,
    this.elevation,
    this.damperPedal,
    this.softPedal,
    this.sostenutoPedal,
    this.id,
    List<SoundItem>? items,
  })  : items = items ?? <SoundItem>[];

  /// Reads an instance from [element].
  factory Sound.fromXml(XmlElement element) =>
      Sound(
        tempo: xmlDouble(element.getAttribute('tempo')),
        dynamics: xmlDouble(element.getAttribute('dynamics')),
        dacapo: YesNo.parse(element.getAttribute('dacapo')),
        segno: element.getAttribute('segno'),
        dalsegno: element.getAttribute('dalsegno'),
        coda: element.getAttribute('coda'),
        tocoda: element.getAttribute('tocoda'),
        divisions: xmlDouble(element.getAttribute('divisions')),
        forwardRepeat: YesNo.parse(element.getAttribute('forward-repeat')),
        fine: element.getAttribute('fine'),
        timeOnly: element.getAttribute('time-only'),
        pizzicato: YesNo.parse(element.getAttribute('pizzicato')),
        pan: xmlDouble(element.getAttribute('pan')),
        elevation: xmlDouble(element.getAttribute('elevation')),
        damperPedal: element.getAttribute('damper-pedal'),
        softPedal: element.getAttribute('soft-pedal'),
        sostenutoPedal: element.getAttribute('sostenuto-pedal'),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(SoundItem.tryFromXml)
            .whereType<SoundItem>()
            .toList(),
      );

  double? tempo;

  double? dynamics;

  YesNo? dacapo;

  String? segno;

  String? dalsegno;

  String? coda;

  String? tocoda;

  double? divisions;

  YesNo? forwardRepeat;

  String? fine;

  String? timeOnly;

  YesNo? pizzicato;

  double? pan;

  double? elevation;

  String? damperPedal;

  String? softPedal;

  String? sostenutoPedal;

  String? id;

  /// The element content, in document order.
  List<SoundItem> items;

  /// Every `instrument-change` child, in document order.
  List<InstrumentChange> get instrumentChangeElements => [
    for (final item in items)
      if (item.instrumentChange != null) item.instrumentChange!,
  ];

  /// Every `midi-device` child, in document order.
  List<MidiDevice> get midiDeviceElements => [
    for (final item in items)
      if (item.midiDevice != null) item.midiDevice!,
  ];

  /// Every `midi-instrument` child, in document order.
  List<MidiInstrument> get midiInstrumentElements => [
    for (final item in items)
      if (item.midiInstrument != null) item.midiInstrument!,
  ];

  /// Every `play` child, in document order.
  List<Play> get playElements => [
    for (final item in items)
      if (item.play != null) item.play!,
  ];

  /// Every `swing` child, in document order.
  List<Swing> get swingElements => [
    for (final item in items)
      if (item.swing != null) item.swing!,
  ];

  /// Every `offset` child, in document order.
  List<Offset> get offsetElements => [
    for (final item in items)
      if (item.offset != null) item.offset!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (tempo != null) {
      node.setAttribute('tempo', xmlNumberText(tempo!));
    }
    if (dynamics != null) {
      node.setAttribute('dynamics', xmlNumberText(dynamics!));
    }
    if (dacapo != null) {
      node.setAttribute('dacapo', dacapo!.xmlValue);
    }
    if (segno != null) {
      node.setAttribute('segno', segno!);
    }
    if (dalsegno != null) {
      node.setAttribute('dalsegno', dalsegno!);
    }
    if (coda != null) {
      node.setAttribute('coda', coda!);
    }
    if (tocoda != null) {
      node.setAttribute('tocoda', tocoda!);
    }
    if (divisions != null) {
      node.setAttribute('divisions', xmlNumberText(divisions!));
    }
    if (forwardRepeat != null) {
      node.setAttribute('forward-repeat', forwardRepeat!.xmlValue);
    }
    if (fine != null) {
      node.setAttribute('fine', fine!);
    }
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    if (pizzicato != null) {
      node.setAttribute('pizzicato', pizzicato!.xmlValue);
    }
    if (pan != null) {
      node.setAttribute('pan', xmlNumberText(pan!));
    }
    if (elevation != null) {
      node.setAttribute('elevation', xmlNumberText(elevation!));
    }
    if (damperPedal != null) {
      node.setAttribute('damper-pedal', damperPedal!);
    }
    if (softPedal != null) {
      node.setAttribute('soft-pedal', softPedal!);
    }
    if (sostenutoPedal != null) {
      node.setAttribute('sostenuto-pedal', sostenutoPedal!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `sound`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class SoundItem {
  SoundItem({
    this.instrumentChange,
    this.midiDevice,
    this.midiInstrument,
    this.play,
    this.swing,
    this.offset,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static SoundItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'instrument-change':
        return SoundItem(instrumentChange: InstrumentChange.fromXml(element));
      case 'midi-device':
        return SoundItem(midiDevice: MidiDevice.fromXml(element));
      case 'midi-instrument':
        return SoundItem(midiInstrument: MidiInstrument.fromXml(element));
      case 'play':
        return SoundItem(play: Play.fromXml(element));
      case 'swing':
        return SoundItem(swing: Swing.fromXml(element));
      case 'offset':
        return SoundItem(offset: Offset.fromXml(element));
    }
    return null;
  }

  InstrumentChange? instrumentChange;

  MidiDevice? midiDevice;

  MidiInstrument? midiInstrument;

  Play? play;

  Swing? swing;

  Offset? offset;

  /// The name of the element this item holds.
  String? get elementName {
    if (instrumentChange != null) return 'instrument-change';
    if (midiDevice != null) return 'midi-device';
    if (midiInstrument != null) return 'midi-instrument';
    if (play != null) return 'play';
    if (swing != null) return 'swing';
    if (offset != null) return 'offset';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (instrumentChange != null) return instrumentChange!.toXml('instrument-change');
    if (midiDevice != null) return midiDevice!.toXml('midi-device');
    if (midiInstrument != null) return midiInstrument!.toXml('midi-instrument');
    if (play != null) return play!.toXml('play');
    if (swing != null) return swing!.toXml('swing');
    if (offset != null) return offset!.toXml('offset');
    return null;
  }
}

/// The staff-details element is used to indicate different types of staves.
/// The optional number attribute specifies the staff number from top to
/// bottom on the system, as with clef. The print-object attribute is used to
/// indicate when a staff is not printed in a part, usually in large scores
/// where empty parts are omitted. It is yes by default. If print-spacing is
/// yes while print-object is no, the score is printed in cutaway format where
/// vertical space is left for the empty part.
class StaffDetails {
  StaffDetails({
    this.staffType,
    this.staffLines,
    List<LineDetail>? lineDetail,
    List<StaffTuning>? staffTuning,
    this.capo,
    this.staffSize,
    this.number,
    this.showFrets,
    this.printObject,
    this.printSpacing,
  })  : lineDetail = lineDetail ?? <LineDetail>[],
        staffTuning = staffTuning ?? <StaffTuning>[];

  /// Reads an instance from [element].
  factory StaffDetails.fromXml(XmlElement element) =>
      StaffDetails(
        staffType: StaffType.parse(xmlElementText(element, 'staff-type')),
        staffLines: xmlInt(xmlElementText(element, 'staff-lines')),
        lineDetail: xmlElements(element, 'line-detail')
            .map(LineDetail.fromXml)
            .toList(),
        staffTuning: xmlElements(element, 'staff-tuning')
            .map(StaffTuning.fromXml)
            .toList(),
        capo: xmlInt(xmlElementText(element, 'capo')),
        staffSize: switch (xmlElement(element, 'staff-size')) {
          final child? => StaffSize.fromXml(child),
          _ => null,
        },
        number: xmlInt(element.getAttribute('number')),
        showFrets: ShowFrets.parse(element.getAttribute('show-frets')),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        printSpacing: YesNo.parse(element.getAttribute('print-spacing')),
      );

  StaffType? staffType;

  /// The staff-lines element specifies the number of lines and is usually
  /// used for a non 5-line staff. If the staff-lines element is present, the
  /// appearance of each line may be individually specified with a line-detail
  /// element.
  int? staffLines;

  List<LineDetail> lineDetail;

  List<StaffTuning> staffTuning;

  /// The capo element indicates at which fret a capo should be placed on a
  /// fretted instrument. This changes the open tuning of the strings
  /// specified by staff-tuning by the specified number of half-steps.
  int? capo;

  StaffSize? staffSize;

  int? number;

  ShowFrets? showFrets;

  YesNo? printObject;

  YesNo? printSpacing;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (showFrets != null) {
      node.setAttribute('show-frets', showFrets!.xmlValue);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (printSpacing != null) {
      node.setAttribute('print-spacing', printSpacing!.xmlValue);
    }
    if (staffType != null) {
      node.children.add(xmlTextElement('staff-type', staffType!.xmlValue));
    }
    if (staffLines != null) {
      node.children.add(xmlTextElement('staff-lines', xmlNumberText(staffLines!)));
    }
    for (final item in lineDetail) {
      node.children.add(item.toXml('line-detail'));
    }
    for (final item in staffTuning) {
      node.children.add(item.toXml('staff-tuning'));
    }
    if (capo != null) {
      node.children.add(xmlTextElement('capo', xmlNumberText(capo!)));
    }
    if (staffSize != null) {
      node.children.add(staffSize!.toXml('staff-size'));
    }
    return node;
  }
}

/// The staff-divide element represents the staff division arrow symbols found
/// at SMuFL code points U+E00B, U+E00C, and U+E00D.
class StaffDivide {
  StaffDivide({
    required this.type,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
  });

  /// Reads an instance from [element].
  factory StaffDivide.fromXml(XmlElement element) =>
      StaffDivide(
        type: xmlRequiredValue(StaffDivideSymbol.parse(element.getAttribute('type')), 'type', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  StaffDivideSymbol type;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// Staff layout includes the vertical distance from the bottom line of the
/// previous staff in this system to the top line of the staff specified by
/// the number attribute. The optional number attribute refers to staff
/// numbers within the part, from top to bottom on the system. A value of 1 is
/// used if not present.
///
/// When used in the defaults element, the values apply to all systems in all
/// parts. When used in the print element, the values apply to the current
/// system only. This value is ignored for the first staff in a system.
class StaffLayout {
  StaffLayout({
    this.staffDistance,
    this.number,
  });

  /// Reads an instance from [element].
  factory StaffLayout.fromXml(XmlElement element) =>
      StaffLayout(
        staffDistance: xmlDouble(xmlElementText(element, 'staff-distance')),
        number: xmlInt(element.getAttribute('number')),
      );

  double? staffDistance;

  int? number;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (staffDistance != null) {
      node.children.add(xmlTextElement('staff-distance', xmlNumberText(staffDistance!)));
    }
    return node;
  }
}

/// The staff-size element indicates how large a staff space is on this staff,
/// expressed as a percentage of the work's default scaling. Values less than
/// 100 make the staff space smaller while values over 100 make the staff
/// space larger. A staff-type of cue, ossia, or editorial implies a
/// staff-size of less than 100, but the exact value is
/// implementation-dependent unless specified here. Staff size affects staff
/// height only, not the relationship of the staff to the left and right
/// margins.
///
/// In some cases, a staff-size different than 100 also scales the notation on
/// the staff, such as with a cue staff. In other cases, such as percussion
/// staves, the lines may be more widely spaced without scaling the notation
/// on the staff. The scaling attribute allows these two cases to be
/// distinguished. It specifies the percentage scaling that applies to the
/// notation. Values less that 100 make the notation smaller while values over
/// 100 make the notation larger. The staff-size content and scaling attribute
/// are both non-negative decimal values.
class StaffSize {
  StaffSize({
    required this.value,
    this.scaling,
  });

  /// Reads an instance from [element].
  factory StaffSize.fromXml(XmlElement element) =>
      StaffSize(
        value: xmlDouble(element.innerText) ?? 0,
        scaling: xmlDouble(element.getAttribute('scaling')),
      );

  /// The element's text content.
  double value;

  double? scaling;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (scaling != null) {
      node.setAttribute('scaling', xmlNumberText(scaling!));
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The staff-tuning type specifies the open, non-capo tuning of the lines on
/// a tablature staff.
class StaffTuning {
  StaffTuning({
    required this.tuningStep,
    this.tuningAlter,
    required this.tuningOctave,
    required this.line,
  });

  /// Reads an instance from [element].
  factory StaffTuning.fromXml(XmlElement element) =>
      StaffTuning(
        tuningStep: xmlRequiredValue(Step.parse(xmlElementText(element, 'tuning-step')), 'tuning-step', element),
        tuningAlter: xmlDouble(xmlElementText(element, 'tuning-alter')),
        tuningOctave: xmlInt(xmlElementText(element, 'tuning-octave')) ?? 0,
        line: xmlInt(element.getAttribute('line')) ?? 0,
      );

  /// The tuning-step element is represented like the step element, with a
  /// different name to reflect its different function in string tuning.
  Step tuningStep;

  /// The tuning-alter element is represented like the alter element, with a
  /// different name to reflect its different function in string tuning.
  double? tuningAlter;

  /// The tuning-octave element is represented like the octave element, with a
  /// different name to reflect its different function in string tuning.
  int tuningOctave;

  int line;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('line', xmlNumberText(line));
    node.children.add(xmlTextElement('tuning-step', tuningStep.xmlValue));
    if (tuningAlter != null) {
      node.children.add(xmlTextElement('tuning-alter', xmlNumberText(tuningAlter!)));
    }
    node.children.add(xmlTextElement('tuning-octave', xmlNumberText(tuningOctave)));
    return node;
  }
}

/// Stems can be down, up, none, or double. For down and up stems, the
/// position attributes can be used to specify stem length. The relative
/// values specify the end of the stem relative to the program default.
/// Default values specify an absolute end stem position. Negative values of
/// relative-y that would flip a stem instead of shortening it are ignored. A
/// stem element associated with a rest refers to a stemlet.
class Stem {
  Stem({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
  });

  /// Reads an instance from [element].
  factory Stem.fromXml(XmlElement element) =>
      Stem(
        value: xmlRequiredValue(StemValue.parse(element.innerText), 'value', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  StemValue value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The stick type represents pictograms where the material of the stick,
/// mallet, or beater is included.The parentheses and dashed-circle attributes
/// indicate the presence of these marks around the round beater part of a
/// pictogram. Values for these attributes are "no" if not present.
class Stick {
  Stick({
    required this.stickType,
    required this.stickMaterial,
    this.tip,
    this.parentheses,
    this.dashedCircle,
  });

  /// Reads an instance from [element].
  factory Stick.fromXml(XmlElement element) =>
      Stick(
        stickType: xmlRequiredValue(StickType.parse(xmlElementText(element, 'stick-type')), 'stick-type', element),
        stickMaterial: xmlRequiredValue(StickMaterial.parse(xmlElementText(element, 'stick-material')), 'stick-material', element),
        tip: TipDirection.parse(element.getAttribute('tip')),
        parentheses: YesNo.parse(element.getAttribute('parentheses')),
        dashedCircle: YesNo.parse(element.getAttribute('dashed-circle')),
      );

  StickType stickType;

  StickMaterial stickMaterial;

  TipDirection? tip;

  YesNo? parentheses;

  YesNo? dashedCircle;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (tip != null) {
      node.setAttribute('tip', tip!.xmlValue);
    }
    if (parentheses != null) {
      node.setAttribute('parentheses', parentheses!.xmlValue);
    }
    if (dashedCircle != null) {
      node.setAttribute('dashed-circle', dashedCircle!.xmlValue);
    }
    node.children.add(xmlTextElement('stick-type', stickType.xmlValue));
    node.children.add(xmlTextElement('stick-material', stickMaterial.xmlValue));
    return node;
  }
}

/// The string type is used with tablature notation, regular notation (where
/// it is often circled), and chord diagrams. String numbers start with 1 for
/// the highest pitched full-length string.
class StringElement {
  StringElement({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory StringElement.fromXml(XmlElement element) =>
      StringElement(
        value: xmlInt(element.innerText) ?? 0,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  int value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The string-mute type represents string mute on and mute off symbols.
class StringMute {
  StringMute({
    required this.type,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.id,
  });

  /// Reads an instance from [element].
  factory StringMute.fromXml(XmlElement element) =>
      StringMute(
        type: xmlRequiredValue(OnOff.parse(element.getAttribute('type')), 'type', element),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        id: element.getAttribute('id'),
      );

  OnOff type;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The strong-accent type indicates a vertical accent mark. The type
/// attribute indicates if the point of the accent is down or up.
class StrongAccent {
  StrongAccent({
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.type,
  });

  /// Reads an instance from [element].
  factory StrongAccent.fromXml(XmlElement element) =>
      StrongAccent(
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        type: UpDown.parse(element.getAttribute('type')) ?? UpDown.up,
      );

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  UpDown? type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (type != null) {
      node.setAttribute('type', type!.xmlValue);
    }
    return node;
  }
}

/// The style-text type represents a text element with a print-style attribute
/// group.
class StyleText {
  StyleText({
    required this.value,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory StyleText.fromXml(XmlElement element) =>
      StyleText(
        value: element.innerText,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  String value;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The supports type indicates if a MusicXML encoding supports a particular
/// MusicXML element. This is recommended for elements like beam, stem, and
/// accidental, where the absence of an element is ambiguous if you do not
/// know if the encoding supports that element. For Version 2.0, the supports
/// element is expanded to allow programs to indicate support for particular
/// attributes or particular values. This lets applications communicate, for
/// example, that all system and/or page breaks are contained in the MusicXML
/// file.
class Supports {
  Supports({
    required this.type,
    required this.element,
    this.attribute,
    this.value,
  });

  /// Reads an instance from [element].
  factory Supports.fromXml(XmlElement element) =>
      Supports(
        type: xmlRequiredValue(YesNo.parse(element.getAttribute('type')), 'type', element),
        element: element.getAttribute('element') ?? '',
        attribute: element.getAttribute('attribute'),
        value: element.getAttribute('value'),
      );

  YesNo type;

  String element;

  String? attribute;

  String? value;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    node.setAttribute('element', element);
    if (attribute != null) {
      node.setAttribute('attribute', attribute!);
    }
    if (value != null) {
      node.setAttribute('value', value!);
    }
    return node;
  }
}

/// The swing element specifies whether or not to use swing playback, where
/// consecutive on-beat / off-beat eighth or 16th notes are played with
/// unequal nominal durations.
///
/// The straight element specifies that no swing is present, so consecutive
/// notes have equal durations.
///
/// The first and second elements are positive integers that specify the ratio
/// between durations of consecutive notes. For example, a first element with
/// a value of 2 and a second element with a value of 1 applied to eighth
/// notes specifies a quarter note / eighth note tuplet playback, where the
/// first note is twice as long as the second note. Ratios should be specified
/// with the smallest integers possible. For example, a ratio of 6 to 4 should
/// be specified as 3 to 2 instead.
///
/// The optional swing-type element specifies the note type, either eighth or
/// 16th, to which the ratio is applied. The value is eighth if this element
/// is not present.
///
/// The optional swing-style element is a string describing the style of swing
/// used.
///
/// The swing element has no effect for playback of grace notes, notes where a
/// type element is not present, and notes where the specified duration is
/// different than the nominal value associated with the specified type. If a
/// swung note has attack and release attributes, those values modify the
/// swung playback.
class Swing {
  Swing({
    this.straight,
    this.first,
    this.second,
    this.swingType,
    this.swingStyle,
  });

  /// Reads an instance from [element].
  factory Swing.fromXml(XmlElement element) =>
      Swing(
        straight: switch (xmlElement(element, 'straight')) {
          final child? => Empty.fromXml(child),
          _ => null,
        },
        first: xmlInt(xmlElementText(element, 'first')),
        second: xmlInt(xmlElementText(element, 'second')),
        swingType: SwingTypeValue.parse(xmlElementText(element, 'swing-type')),
        swingStyle: xmlElementText(element, 'swing-style'),
      );

  Empty? straight;

  int? first;

  int? second;

  SwingTypeValue? swingType;

  String? swingStyle;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (straight != null) {
      node.children.add(straight!.toXml('straight'));
    }
    if (first != null) {
      node.children.add(xmlTextElement('first', xmlNumberText(first!)));
    }
    if (second != null) {
      node.children.add(xmlTextElement('second', xmlNumberText(second!)));
    }
    if (swingType != null) {
      node.children.add(xmlTextElement('swing-type', swingType!.xmlValue));
    }
    if (swingStyle != null) {
      node.children.add(xmlTextElement('swing-style', swingStyle!));
    }
    return node;
  }
}

/// The sync type specifies the style that a score following application
/// should use the synchronize an accompaniment with a performer. If this type
/// is not included in a score, default synchronization depends on the
/// application.
///
/// The optional latency attribute specifies a time in milliseconds that the
/// listening application should expect from the performer. The optional
/// player and time-only attributes restrict the element to apply to a single
/// player or set of times through a repeated section, respectively.
class Sync {
  Sync({
    required this.type,
    this.latency,
    this.player,
    this.timeOnly,
  });

  /// Reads an instance from [element].
  factory Sync.fromXml(XmlElement element) =>
      Sync(
        type: xmlRequiredValue(SyncType.parse(element.getAttribute('type')), 'type', element),
        latency: xmlInt(element.getAttribute('latency')),
        player: element.getAttribute('player'),
        timeOnly: element.getAttribute('time-only'),
      );

  SyncType type;

  int? latency;

  String? player;

  String? timeOnly;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (latency != null) {
      node.setAttribute('latency', xmlNumberText(latency!));
    }
    if (player != null) {
      node.setAttribute('player', player!);
    }
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    return node;
  }
}

/// The system-dividers element indicates the presence or absence of system
/// dividers (also known as system separation marks) between systems displayed
/// on the same page. Dividers on the left and right side of the page are
/// controlled by the left-divider and right-divider elements respectively.
/// The default vertical position is half the system-distance value from the
/// top of the system that is below the divider. The default horizontal
/// position is the left and right system margin, respectively.
///
/// When used in the print element, the system-dividers element affects the
/// dividers that would appear between the current system and the previous
/// system.
class SystemDividers {
  SystemDividers({
    required this.leftDivider,
    required this.rightDivider,
  });

  /// Reads an instance from [element].
  factory SystemDividers.fromXml(XmlElement element) =>
      SystemDividers(
        leftDivider: EmptyPrintObjectStyleAlign.fromXml(xmlRequiredElement(element, 'left-divider')),
        rightDivider: EmptyPrintObjectStyleAlign.fromXml(xmlRequiredElement(element, 'right-divider')),
      );

  EmptyPrintObjectStyleAlign leftDivider;

  EmptyPrintObjectStyleAlign rightDivider;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(leftDivider.toXml('left-divider'));
    node.children.add(rightDivider.toXml('right-divider'));
    return node;
  }
}

/// A system is a group of staves that are read and played simultaneously.
/// System layout includes left and right margins and the vertical distance
/// from the previous system. The system distance is measured from the bottom
/// line of the previous system to the top line of the current system. It is
/// ignored for the first system on a page. The top system distance is
/// measured from the page's top margin to the top line of the first system.
/// It is ignored for all but the first system on a page.
///
/// Sometimes the sum of measure widths in a system may not equal the system
/// width specified by the layout elements due to roundoff or other errors.
/// The behavior when reading MusicXML files in these cases is
/// application-dependent. For instance, applications may find that the system
/// layout data is more reliable than the sum of the measure widths, and
/// adjust the measure widths accordingly.
///
/// When used in the defaults element, the system-layout element defines a
/// default appearance for all systems in the score. If no system-layout
/// element is present in the defaults element, default system layout values
/// are chosen by the application.
///
/// When used in the print element, the system-layout element affects the
/// appearance of the current system only. All other systems use the default
/// values as determined by the defaults element. If any child elements are
/// missing from the system-layout element in a print element, the values
/// determined by the defaults element are used there as well. This type of
/// system-layout element need only be read from or written to the first
/// visible part in the score.
class SystemLayout {
  SystemLayout({
    this.systemMargins,
    this.systemDistance,
    this.topSystemDistance,
    this.systemDividers,
  });

  /// Reads an instance from [element].
  factory SystemLayout.fromXml(XmlElement element) =>
      SystemLayout(
        systemMargins: switch (xmlElement(element, 'system-margins')) {
          final child? => SystemMargins.fromXml(child),
          _ => null,
        },
        systemDistance: xmlDouble(xmlElementText(element, 'system-distance')),
        topSystemDistance: xmlDouble(xmlElementText(element, 'top-system-distance')),
        systemDividers: switch (xmlElement(element, 'system-dividers')) {
          final child? => SystemDividers.fromXml(child),
          _ => null,
        },
      );

  SystemMargins? systemMargins;

  double? systemDistance;

  double? topSystemDistance;

  SystemDividers? systemDividers;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (systemMargins != null) {
      node.children.add(systemMargins!.toXml('system-margins'));
    }
    if (systemDistance != null) {
      node.children.add(xmlTextElement('system-distance', xmlNumberText(systemDistance!)));
    }
    if (topSystemDistance != null) {
      node.children.add(xmlTextElement('top-system-distance', xmlNumberText(topSystemDistance!)));
    }
    if (systemDividers != null) {
      node.children.add(systemDividers!.toXml('system-dividers'));
    }
    return node;
  }
}

/// System margins are relative to the page margins. Positive values indent
/// and negative values reduce the margin size.
class SystemMargins {
  SystemMargins({
    required this.leftMargin,
    required this.rightMargin,
  });

  /// Reads an instance from [element].
  factory SystemMargins.fromXml(XmlElement element) =>
      SystemMargins(
        leftMargin: xmlDouble(xmlElementText(element, 'left-margin')) ?? 0,
        rightMargin: xmlDouble(xmlElementText(element, 'right-margin')) ?? 0,
      );

  double leftMargin;

  double rightMargin;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('left-margin', xmlNumberText(leftMargin)));
    node.children.add(xmlTextElement('right-margin', xmlNumberText(rightMargin)));
    return node;
  }
}

/// The tap type indicates a tap on the fretboard. The text content allows
/// specification of the notation; + and T are common choices. If the element
/// is empty, the hand attribute is used to specify the symbol to use. The
/// hand attribute is ignored if the tap glyph is already specified by the
/// text content. If neither text content nor the hand attribute are present,
/// the display is application-specific.
class Tap {
  Tap({
    required this.value,
    this.hand,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
  });

  /// Reads an instance from [element].
  factory Tap.fromXml(XmlElement element) =>
      Tap(
        value: element.innerText,
        hand: TapHand.parse(element.getAttribute('hand')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
      );

  /// The element's text content.
  String value;

  TapHand? hand;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (hand != null) {
      node.setAttribute('hand', hand!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// Technical indications give performance information for individual
/// instruments.
class Technical {
  Technical({
    this.id,
    List<TechnicalItem>? items,
  })  : items = items ?? <TechnicalItem>[];

  /// Reads an instance from [element].
  factory Technical.fromXml(XmlElement element) =>
      Technical(
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(TechnicalItem.tryFromXml)
            .whereType<TechnicalItem>()
            .toList(),
      );

  String? id;

  /// The element content, in document order.
  List<TechnicalItem> items;

  /// Every `up-bow` child, in document order.
  List<EmptyPlacement> get upBowElements => [
    for (final item in items)
      if (item.upBow != null) item.upBow!,
  ];

  /// Every `down-bow` child, in document order.
  List<EmptyPlacement> get downBowElements => [
    for (final item in items)
      if (item.downBow != null) item.downBow!,
  ];

  /// Every `harmonic` child, in document order.
  List<Harmonic> get harmonicElements => [
    for (final item in items)
      if (item.harmonic != null) item.harmonic!,
  ];

  /// Every `open-string` child, in document order.
  List<EmptyPlacement> get openStringElements => [
    for (final item in items)
      if (item.openString != null) item.openString!,
  ];

  /// Every `thumb-position` child, in document order.
  List<EmptyPlacement> get thumbPositionElements => [
    for (final item in items)
      if (item.thumbPosition != null) item.thumbPosition!,
  ];

  /// Every `fingering` child, in document order.
  List<Fingering> get fingeringElements => [
    for (final item in items)
      if (item.fingering != null) item.fingering!,
  ];

  /// Every `pluck` child, in document order.
  List<PlacementText> get pluckElements => [
    for (final item in items)
      if (item.pluck != null) item.pluck!,
  ];

  /// Every `double-tongue` child, in document order.
  List<EmptyPlacement> get doubleTongueElements => [
    for (final item in items)
      if (item.doubleTongue != null) item.doubleTongue!,
  ];

  /// Every `triple-tongue` child, in document order.
  List<EmptyPlacement> get tripleTongueElements => [
    for (final item in items)
      if (item.tripleTongue != null) item.tripleTongue!,
  ];

  /// Every `stopped` child, in document order.
  List<EmptyPlacementSmufl> get stoppedElements => [
    for (final item in items)
      if (item.stopped != null) item.stopped!,
  ];

  /// Every `snap-pizzicato` child, in document order.
  List<EmptyPlacement> get snapPizzicatoElements => [
    for (final item in items)
      if (item.snapPizzicato != null) item.snapPizzicato!,
  ];

  /// Every `fret` child, in document order.
  List<Fret> get fretElements => [
    for (final item in items)
      if (item.fret != null) item.fret!,
  ];

  /// Every `string` child, in document order.
  List<StringElement> get stringElements => [
    for (final item in items)
      if (item.string != null) item.string!,
  ];

  /// Every `hammer-on` child, in document order.
  List<HammerOnPullOff> get hammerOnElements => [
    for (final item in items)
      if (item.hammerOn != null) item.hammerOn!,
  ];

  /// Every `pull-off` child, in document order.
  List<HammerOnPullOff> get pullOffElements => [
    for (final item in items)
      if (item.pullOff != null) item.pullOff!,
  ];

  /// Every `bend` child, in document order.
  List<Bend> get bendElements => [
    for (final item in items)
      if (item.bend != null) item.bend!,
  ];

  /// Every `tap` child, in document order.
  List<Tap> get tapElements => [
    for (final item in items)
      if (item.tap != null) item.tap!,
  ];

  /// Every `heel` child, in document order.
  List<HeelToe> get heelElements => [
    for (final item in items)
      if (item.heel != null) item.heel!,
  ];

  /// Every `toe` child, in document order.
  List<HeelToe> get toeElements => [
    for (final item in items)
      if (item.toe != null) item.toe!,
  ];

  /// Every `fingernails` child, in document order.
  List<EmptyPlacement> get fingernailsElements => [
    for (final item in items)
      if (item.fingernails != null) item.fingernails!,
  ];

  /// Every `hole` child, in document order.
  List<Hole> get holeElements => [
    for (final item in items)
      if (item.hole != null) item.hole!,
  ];

  /// Every `arrow` child, in document order.
  List<Arrow> get arrowElements => [
    for (final item in items)
      if (item.arrow != null) item.arrow!,
  ];

  /// Every `handbell` child, in document order.
  List<Handbell> get handbellElements => [
    for (final item in items)
      if (item.handbell != null) item.handbell!,
  ];

  /// Every `brass-bend` child, in document order.
  List<EmptyPlacement> get brassBendElements => [
    for (final item in items)
      if (item.brassBend != null) item.brassBend!,
  ];

  /// Every `flip` child, in document order.
  List<EmptyPlacement> get flipElements => [
    for (final item in items)
      if (item.flip != null) item.flip!,
  ];

  /// Every `smear` child, in document order.
  List<EmptyPlacement> get smearElements => [
    for (final item in items)
      if (item.smear != null) item.smear!,
  ];

  /// Every `open` child, in document order.
  List<EmptyPlacementSmufl> get openElements => [
    for (final item in items)
      if (item.open != null) item.open!,
  ];

  /// Every `half-muted` child, in document order.
  List<EmptyPlacementSmufl> get halfMutedElements => [
    for (final item in items)
      if (item.halfMuted != null) item.halfMuted!,
  ];

  /// Every `harmon-mute` child, in document order.
  List<HarmonMute> get harmonMuteElements => [
    for (final item in items)
      if (item.harmonMute != null) item.harmonMute!,
  ];

  /// Every `golpe` child, in document order.
  List<EmptyPlacement> get golpeElements => [
    for (final item in items)
      if (item.golpe != null) item.golpe!,
  ];

  /// Every `other-technical` child, in document order.
  List<OtherPlacementText> get otherTechnicalElements => [
    for (final item in items)
      if (item.otherTechnical != null) item.otherTechnical!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `technical`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class TechnicalItem {
  TechnicalItem({
    this.upBow,
    this.downBow,
    this.harmonic,
    this.openString,
    this.thumbPosition,
    this.fingering,
    this.pluck,
    this.doubleTongue,
    this.tripleTongue,
    this.stopped,
    this.snapPizzicato,
    this.fret,
    this.string,
    this.hammerOn,
    this.pullOff,
    this.bend,
    this.tap,
    this.heel,
    this.toe,
    this.fingernails,
    this.hole,
    this.arrow,
    this.handbell,
    this.brassBend,
    this.flip,
    this.smear,
    this.open,
    this.halfMuted,
    this.harmonMute,
    this.golpe,
    this.otherTechnical,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static TechnicalItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'up-bow':
        return TechnicalItem(upBow: EmptyPlacement.fromXml(element));
      case 'down-bow':
        return TechnicalItem(downBow: EmptyPlacement.fromXml(element));
      case 'harmonic':
        return TechnicalItem(harmonic: Harmonic.fromXml(element));
      case 'open-string':
        return TechnicalItem(openString: EmptyPlacement.fromXml(element));
      case 'thumb-position':
        return TechnicalItem(thumbPosition: EmptyPlacement.fromXml(element));
      case 'fingering':
        return TechnicalItem(fingering: Fingering.fromXml(element));
      case 'pluck':
        return TechnicalItem(pluck: PlacementText.fromXml(element));
      case 'double-tongue':
        return TechnicalItem(doubleTongue: EmptyPlacement.fromXml(element));
      case 'triple-tongue':
        return TechnicalItem(tripleTongue: EmptyPlacement.fromXml(element));
      case 'stopped':
        return TechnicalItem(stopped: EmptyPlacementSmufl.fromXml(element));
      case 'snap-pizzicato':
        return TechnicalItem(snapPizzicato: EmptyPlacement.fromXml(element));
      case 'fret':
        return TechnicalItem(fret: Fret.fromXml(element));
      case 'string':
        return TechnicalItem(string: StringElement.fromXml(element));
      case 'hammer-on':
        return TechnicalItem(hammerOn: HammerOnPullOff.fromXml(element));
      case 'pull-off':
        return TechnicalItem(pullOff: HammerOnPullOff.fromXml(element));
      case 'bend':
        return TechnicalItem(bend: Bend.fromXml(element));
      case 'tap':
        return TechnicalItem(tap: Tap.fromXml(element));
      case 'heel':
        return TechnicalItem(heel: HeelToe.fromXml(element));
      case 'toe':
        return TechnicalItem(toe: HeelToe.fromXml(element));
      case 'fingernails':
        return TechnicalItem(fingernails: EmptyPlacement.fromXml(element));
      case 'hole':
        return TechnicalItem(hole: Hole.fromXml(element));
      case 'arrow':
        return TechnicalItem(arrow: Arrow.fromXml(element));
      case 'handbell':
        return TechnicalItem(handbell: Handbell.fromXml(element));
      case 'brass-bend':
        return TechnicalItem(brassBend: EmptyPlacement.fromXml(element));
      case 'flip':
        return TechnicalItem(flip: EmptyPlacement.fromXml(element));
      case 'smear':
        return TechnicalItem(smear: EmptyPlacement.fromXml(element));
      case 'open':
        return TechnicalItem(open: EmptyPlacementSmufl.fromXml(element));
      case 'half-muted':
        return TechnicalItem(halfMuted: EmptyPlacementSmufl.fromXml(element));
      case 'harmon-mute':
        return TechnicalItem(harmonMute: HarmonMute.fromXml(element));
      case 'golpe':
        return TechnicalItem(golpe: EmptyPlacement.fromXml(element));
      case 'other-technical':
        return TechnicalItem(otherTechnical: OtherPlacementText.fromXml(element));
    }
    return null;
  }

  /// The up-bow element represents the symbol that is used both for up-bowing
  /// on bowed instruments, and up-stroke on plucked instruments.
  EmptyPlacement? upBow;

  /// The down-bow element represents the symbol that is used both for
  /// down-bowing on bowed instruments, and down-stroke on plucked
  /// instruments.
  EmptyPlacement? downBow;

  Harmonic? harmonic;

  /// The open-string element represents the zero-shaped open string symbol.
  EmptyPlacement? openString;

  /// The thumb-position element represents the thumb position symbol. This is
  /// a circle with a line, where the line does not come within the circle. It
  /// is distinct from the snap pizzicato symbol, where the line comes inside
  /// the circle.
  EmptyPlacement? thumbPosition;

  Fingering? fingering;

  /// The pluck element is used to specify the plucking fingering on a fretted
  /// instrument, where the fingering element refers to the fretting
  /// fingering. Typical values are p, i, m, a for pulgar/thumb,
  /// indicio/index, medio/middle, and anular/ring fingers.
  PlacementText? pluck;

  /// The double-tongue element represents the double tongue symbol (two dots
  /// arranged horizontally).
  EmptyPlacement? doubleTongue;

  /// The triple-tongue element represents the triple tongue symbol (three
  /// dots arranged horizontally).
  EmptyPlacement? tripleTongue;

  /// The stopped element represents the stopped symbol, which looks like a
  /// plus sign. The smufl attribute distinguishes different SMuFL glyphs that
  /// have a similar appearance such as handbellsMalletBellSuspended and
  /// guitarClosePedal. If not present, the default glyph is brassMuteClosed.
  EmptyPlacementSmufl? stopped;

  /// The snap-pizzicato element represents the snap pizzicato symbol. This is
  /// a circle with a line, where the line comes inside the circle. It is
  /// distinct from the thumb-position symbol, where the line does not come
  /// inside the circle.
  EmptyPlacement? snapPizzicato;

  Fret? fret;

  StringElement? string;

  HammerOnPullOff? hammerOn;

  HammerOnPullOff? pullOff;

  Bend? bend;

  Tap? tap;

  HeelToe? heel;

  HeelToe? toe;

  /// The fingernails element is used in notation for harp and other plucked
  /// string instruments.
  EmptyPlacement? fingernails;

  Hole? hole;

  Arrow? arrow;

  Handbell? handbell;

  /// The brass-bend element represents the u-shaped bend symbol used in brass
  /// notation, distinct from the bend element used in guitar music.
  EmptyPlacement? brassBend;

  /// The flip element represents the flip symbol used in brass notation.
  EmptyPlacement? flip;

  /// The smear element represents the tilde-shaped smear symbol used in brass
  /// notation.
  EmptyPlacement? smear;

  /// The open element represents the open symbol, which looks like a circle.
  /// The smufl attribute can be used to distinguish different SMuFL glyphs
  /// that have a similar appearance such as brassMuteOpen and
  /// guitarOpenPedal. If not present, the default glyph is brassMuteOpen.
  EmptyPlacementSmufl? open;

  /// The half-muted element represents the half-muted symbol, which looks
  /// like a circle with a plus sign inside. The smufl attribute can be used
  /// to distinguish different SMuFL glyphs that have a similar appearance
  /// such as brassMuteHalfClosed and guitarHalfOpenPedal. If not present, the
  /// default glyph is brassMuteHalfClosed.
  EmptyPlacementSmufl? halfMuted;

  HarmonMute? harmonMute;

  /// The golpe element represents the golpe symbol that is used for tapping
  /// the pick guard in guitar music.
  EmptyPlacement? golpe;

  /// The other-technical element is used to define any technical indications
  /// not yet in the MusicXML format. The smufl attribute can be used to
  /// specify a particular glyph, allowing application interoperability
  /// without requiring every SMuFL technical indication to have a MusicXML
  /// element equivalent. Using the other-technical element without the smufl
  /// attribute allows for extended representation, though without application
  /// interoperability.
  OtherPlacementText? otherTechnical;

  /// The name of the element this item holds.
  String? get elementName {
    if (upBow != null) return 'up-bow';
    if (downBow != null) return 'down-bow';
    if (harmonic != null) return 'harmonic';
    if (openString != null) return 'open-string';
    if (thumbPosition != null) return 'thumb-position';
    if (fingering != null) return 'fingering';
    if (pluck != null) return 'pluck';
    if (doubleTongue != null) return 'double-tongue';
    if (tripleTongue != null) return 'triple-tongue';
    if (stopped != null) return 'stopped';
    if (snapPizzicato != null) return 'snap-pizzicato';
    if (fret != null) return 'fret';
    if (string != null) return 'string';
    if (hammerOn != null) return 'hammer-on';
    if (pullOff != null) return 'pull-off';
    if (bend != null) return 'bend';
    if (tap != null) return 'tap';
    if (heel != null) return 'heel';
    if (toe != null) return 'toe';
    if (fingernails != null) return 'fingernails';
    if (hole != null) return 'hole';
    if (arrow != null) return 'arrow';
    if (handbell != null) return 'handbell';
    if (brassBend != null) return 'brass-bend';
    if (flip != null) return 'flip';
    if (smear != null) return 'smear';
    if (open != null) return 'open';
    if (halfMuted != null) return 'half-muted';
    if (harmonMute != null) return 'harmon-mute';
    if (golpe != null) return 'golpe';
    if (otherTechnical != null) return 'other-technical';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (upBow != null) return upBow!.toXml('up-bow');
    if (downBow != null) return downBow!.toXml('down-bow');
    if (harmonic != null) return harmonic!.toXml('harmonic');
    if (openString != null) return openString!.toXml('open-string');
    if (thumbPosition != null) return thumbPosition!.toXml('thumb-position');
    if (fingering != null) return fingering!.toXml('fingering');
    if (pluck != null) return pluck!.toXml('pluck');
    if (doubleTongue != null) return doubleTongue!.toXml('double-tongue');
    if (tripleTongue != null) return tripleTongue!.toXml('triple-tongue');
    if (stopped != null) return stopped!.toXml('stopped');
    if (snapPizzicato != null) return snapPizzicato!.toXml('snap-pizzicato');
    if (fret != null) return fret!.toXml('fret');
    if (string != null) return string!.toXml('string');
    if (hammerOn != null) return hammerOn!.toXml('hammer-on');
    if (pullOff != null) return pullOff!.toXml('pull-off');
    if (bend != null) return bend!.toXml('bend');
    if (tap != null) return tap!.toXml('tap');
    if (heel != null) return heel!.toXml('heel');
    if (toe != null) return toe!.toXml('toe');
    if (fingernails != null) return fingernails!.toXml('fingernails');
    if (hole != null) return hole!.toXml('hole');
    if (arrow != null) return arrow!.toXml('arrow');
    if (handbell != null) return handbell!.toXml('handbell');
    if (brassBend != null) return brassBend!.toXml('brass-bend');
    if (flip != null) return flip!.toXml('flip');
    if (smear != null) return smear!.toXml('smear');
    if (open != null) return open!.toXml('open');
    if (halfMuted != null) return halfMuted!.toXml('half-muted');
    if (harmonMute != null) return harmonMute!.toXml('harmon-mute');
    if (golpe != null) return golpe!.toXml('golpe');
    if (otherTechnical != null) return otherTechnical!.toXml('other-technical');
    return null;
  }
}

/// The text-element-data type represents a syllable or portion of a syllable
/// for lyric text underlay. A hyphen in the string content should only be
/// used for an actual hyphenated word. Language names for text elements come
/// from ISO 639, with optional country subcodes from ISO 3166.
class TextElementData {
  TextElementData({
    required this.value,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.underline,
    this.overline,
    this.lineThrough,
    this.rotation,
    this.letterSpacing,
    this.xmlLang,
    this.dir,
  });

  /// Reads an instance from [element].
  factory TextElementData.fromXml(XmlElement element) =>
      TextElementData(
        value: element.innerText,
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        underline: xmlInt(element.getAttribute('underline')),
        overline: xmlInt(element.getAttribute('overline')),
        lineThrough: xmlInt(element.getAttribute('line-through')),
        rotation: xmlDouble(element.getAttribute('rotation')),
        letterSpacing: element.getAttribute('letter-spacing'),
        xmlLang: element.getAttribute('xml:lang'),
        dir: TextDirection.parse(element.getAttribute('dir')),
      );

  /// The element's text content.
  String value;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  int? underline;

  int? overline;

  int? lineThrough;

  double? rotation;

  String? letterSpacing;

  /// The `xml:lang` attribute.
  String? xmlLang;

  TextDirection? dir;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (underline != null) {
      node.setAttribute('underline', xmlNumberText(underline!));
    }
    if (overline != null) {
      node.setAttribute('overline', xmlNumberText(overline!));
    }
    if (lineThrough != null) {
      node.setAttribute('line-through', xmlNumberText(lineThrough!));
    }
    if (rotation != null) {
      node.setAttribute('rotation', xmlNumberText(rotation!));
    }
    if (letterSpacing != null) {
      node.setAttribute('letter-spacing', letterSpacing!);
    }
    if (xmlLang != null) {
      node.setAttribute('xml:lang', xmlLang!);
    }
    if (dir != null) {
      node.setAttribute('dir', dir!.xmlValue);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The tie element indicates that a tie begins or ends with this note. If the
/// tie element applies only particular times through a repeat, the time-only
/// attribute indicates which times to apply it. The tie element indicates
/// sound; the tied element indicates notation.
class Tie {
  Tie({
    required this.type,
    this.timeOnly,
  });

  /// Reads an instance from [element].
  factory Tie.fromXml(XmlElement element) =>
      Tie(
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        timeOnly: element.getAttribute('time-only'),
      );

  StartStop type;

  String? timeOnly;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    return node;
  }
}

/// The tied element represents the notated tie. The tie element represents
/// the tie sound.
///
/// The number attribute is rarely needed to disambiguate ties, since note
/// pitches will usually suffice. The attribute is implied rather than
/// defaulting to 1 as with most elements. It is available for use in more
/// complex tied notation situations.
///
/// Ties that join two notes of the same pitch together should be represented
/// with a tied element on the first note with type="start" and a tied element
/// on the second note with type="stop". This can also be done if the two
/// notes being tied are enharmonically equivalent, but have different step
/// values. It is not recommended to use tied elements to join two notes with
/// enharmonically inequivalent pitches.
///
/// Ties that indicate that an instrument should be undamped are specified
/// with a single tied element with type="let-ring".
///
/// Ties that are visually attached to only one note, other than undamped
/// ties, should be specified with two tied elements on the same note, first
/// type="start" then type="stop". This can be used to represent ties into or
/// out of repeated sections or codas.
class Tied {
  Tied({
    required this.type,
    this.number,
    this.lineType,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.placement,
    this.orientation,
    this.bezierX,
    this.bezierY,
    this.bezierX2,
    this.bezierY2,
    this.bezierOffset,
    this.bezierOffset2,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Tied.fromXml(XmlElement element) =>
      Tied(
        type: xmlRequiredValue(TiedType.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        lineType: LineType.parse(element.getAttribute('line-type')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        orientation: OverUnder.parse(element.getAttribute('orientation')),
        bezierX: xmlDouble(element.getAttribute('bezier-x')),
        bezierY: xmlDouble(element.getAttribute('bezier-y')),
        bezierX2: xmlDouble(element.getAttribute('bezier-x2')),
        bezierY2: xmlDouble(element.getAttribute('bezier-y2')),
        bezierOffset: xmlDouble(element.getAttribute('bezier-offset')),
        bezierOffset2: xmlDouble(element.getAttribute('bezier-offset2')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  TiedType type;

  int? number;

  LineType? lineType;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  AboveBelow? placement;

  OverUnder? orientation;

  double? bezierX;

  double? bezierY;

  double? bezierX2;

  double? bezierY2;

  double? bezierOffset;

  double? bezierOffset2;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (orientation != null) {
      node.setAttribute('orientation', orientation!.xmlValue);
    }
    if (bezierX != null) {
      node.setAttribute('bezier-x', xmlNumberText(bezierX!));
    }
    if (bezierY != null) {
      node.setAttribute('bezier-y', xmlNumberText(bezierY!));
    }
    if (bezierX2 != null) {
      node.setAttribute('bezier-x2', xmlNumberText(bezierX2!));
    }
    if (bezierY2 != null) {
      node.setAttribute('bezier-y2', xmlNumberText(bezierY2!));
    }
    if (bezierOffset != null) {
      node.setAttribute('bezier-offset', xmlNumberText(bezierOffset!));
    }
    if (bezierOffset2 != null) {
      node.setAttribute('bezier-offset2', xmlNumberText(bezierOffset2!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// Time signatures are represented by the beats element for the numerator and
/// the beat-type element for the denominator. The symbol attribute is used to
/// indicate common and cut time symbols as well as a single number display.
/// Multiple pairs of beat and beat-type elements are used for composite time
/// signatures with multiple denominators, such as 2/4 + 3/8. A composite such
/// as 3+2/8 requires only one beat/beat-type pair.
///
/// The print-object attribute allows a time signature to be specified but not
/// printed, as is the case for excerpts from the middle of a score. The value
/// is "yes" if not present. The optional number attribute refers to staff
/// numbers within the part. If absent, the time signature applies to all
/// staves in the part.
class Time {
  Time({
    this.number,
    this.symbol,
    this.separator,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.halign,
    this.valign,
    this.printObject,
    this.id,
    List<TimeItem>? items,
  })  : items = items ?? <TimeItem>[];

  /// Reads an instance from [element].
  factory Time.fromXml(XmlElement element) =>
      Time(
        number: xmlInt(element.getAttribute('number')),
        symbol: TimeSymbol.parse(element.getAttribute('symbol')),
        separator: TimeSeparator.parse(element.getAttribute('separator')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        halign: LeftCenterRight.parse(element.getAttribute('halign')),
        valign: Valign.parse(element.getAttribute('valign')),
        printObject: YesNo.parse(element.getAttribute('print-object')),
        id: element.getAttribute('id'),
        items: xmlChildren(element)
            .map(TimeItem.tryFromXml)
            .whereType<TimeItem>()
            .toList(),
      );

  int? number;

  TimeSymbol? symbol;

  TimeSeparator? separator;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  LeftCenterRight? halign;

  Valign? valign;

  YesNo? printObject;

  String? id;

  /// The element content, in document order.
  List<TimeItem> items;

  /// Every `beats` child, in document order.
  List<String> get beatsElements => [
    for (final item in items)
      if (item.beats != null) item.beats!,
  ];

  /// Every `beat-type` child, in document order.
  List<String> get beatTypeElements => [
    for (final item in items)
      if (item.beatType != null) item.beatType!,
  ];

  /// Every `interchangeable` child, in document order.
  List<Interchangeable> get interchangeableElements => [
    for (final item in items)
      if (item.interchangeable != null) item.interchangeable!,
  ];

  /// Every `senza-misura` child, in document order.
  List<String> get senzaMisuraElements => [
    for (final item in items)
      if (item.senzaMisura != null) item.senzaMisura!,
  ];

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (symbol != null) {
      node.setAttribute('symbol', symbol!.xmlValue);
    }
    if (separator != null) {
      node.setAttribute('separator', separator!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (halign != null) {
      node.setAttribute('halign', halign!.xmlValue);
    }
    if (valign != null) {
      node.setAttribute('valign', valign!.xmlValue);
    }
    if (printObject != null) {
      node.setAttribute('print-object', printObject!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    for (final item in items) {
      final child = item.toXmlOrNull();
      if (child != null) node.children.add(child);
    }
    return node;
  }
}

/// One child element of `time`. Exactly one field is set, naming which
/// element it was. Holding the content as a list of these keeps the order the
/// document had, which the music depends on.
class TimeItem {
  TimeItem({
    this.beats,
    this.beatType,
    this.interchangeable,
    this.senzaMisura,
  });

  /// Reads [element] if its name is one this content model
  /// allows, and returns `null` otherwise.
  static TimeItem? tryFromXml(XmlElement element) {
    switch (element.name.local) {
      case 'beats':
        return TimeItem(beats: element.innerText);
      case 'beat-type':
        return TimeItem(beatType: element.innerText);
      case 'interchangeable':
        return TimeItem(interchangeable: Interchangeable.fromXml(element));
      case 'senza-misura':
        return TimeItem(senzaMisura: element.innerText);
    }
    return null;
  }

  /// The beats element indicates the number of beats, as found in the
  /// numerator of a time signature.
  String? beats;

  /// The beat-type element indicates the beat unit, as found in the
  /// denominator of a time signature.
  String? beatType;

  Interchangeable? interchangeable;

  /// A senza-misura element explicitly indicates that no time signature is
  /// present. The optional element content indicates the symbol to be used,
  /// if any, such as an X. The time element's symbol attribute is not used
  /// when a senza-misura element is present.
  String? senzaMisura;

  /// The name of the element this item holds.
  String? get elementName {
    if (beats != null) return 'beats';
    if (beatType != null) return 'beat-type';
    if (interchangeable != null) return 'interchangeable';
    if (senzaMisura != null) return 'senza-misura';
    return null;
  }

  /// Writes the element this item holds, or `null` when it
  /// holds nothing.
  XmlElement? toXmlOrNull() {
    if (beats != null) return xmlTextElement('beats', beats!);
    if (beatType != null) return xmlTextElement('beat-type', beatType!);
    if (interchangeable != null) return interchangeable!.toXml('interchangeable');
    if (senzaMisura != null) return xmlTextElement('senza-misura', senzaMisura!);
    return null;
  }
}

/// Time modification indicates tuplets, double-note tremolos, and other
/// durational changes. A time-modification element shows how the cumulative,
/// sounding effect of tuplets and double-note tremolos compare to the written
/// note type represented by the type and dot elements. Nested tuplets and
/// other notations that use more detailed information need both the
/// time-modification and tuplet elements to be represented accurately.
class TimeModification {
  TimeModification({
    required this.actualNotes,
    required this.normalNotes,
    this.normalType,
    List<Empty>? normalDot,
  })  : normalDot = normalDot ?? <Empty>[];

  /// Reads an instance from [element].
  factory TimeModification.fromXml(XmlElement element) =>
      TimeModification(
        actualNotes: xmlInt(xmlElementText(element, 'actual-notes')) ?? 0,
        normalNotes: xmlInt(xmlElementText(element, 'normal-notes')) ?? 0,
        normalType: NoteTypeValue.parse(xmlElementText(element, 'normal-type')),
        normalDot: xmlElements(element, 'normal-dot')
            .map(Empty.fromXml)
            .toList(),
      );

  /// The actual-notes element describes how many notes are played in the time
  /// usually occupied by the number in the normal-notes element.
  int actualNotes;

  /// The normal-notes element describes how many notes are usually played in
  /// the time occupied by the number in the actual-notes element.
  int normalNotes;

  /// If the type associated with the number in the normal-notes element is
  /// different than the current note type (e.g., a quarter note within an
  /// eighth note triplet), then the normal-notes type (e.g. eighth) is
  /// specified in the normal-type and normal-dot elements.
  NoteTypeValue? normalType;

  /// The normal-dot element is used to specify dotted normal tuplet types.
  List<Empty> normalDot;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.children.add(xmlTextElement('actual-notes', xmlNumberText(actualNotes)));
    node.children.add(xmlTextElement('normal-notes', xmlNumberText(normalNotes)));
    if (normalType != null) {
      node.children.add(xmlTextElement('normal-type', normalType!.xmlValue));
    }
    for (final item in normalDot) {
      node.children.add(item.toXml('normal-dot'));
    }
    return node;
  }
}

/// The timpani type represents the timpani pictogram. The smufl attribute is
/// used to distinguish different SMuFL stylistic alternates.
class Timpani {
  Timpani({
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Timpani.fromXml(XmlElement element) =>
      Timpani(
        smufl: element.getAttribute('smufl'),
      );

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    return node;
  }
}

/// The transpose type represents what must be added to a written pitch to get
/// a correct sounding pitch. The optional number attribute refers to staff
/// numbers, from top to bottom on the system. If absent, the transposition
/// applies to all staves in the part. Per-staff transposition is most often
/// used in parts that represent multiple instruments.
class Transpose {
  Transpose({
    this.diatonic,
    required this.chromatic,
    this.octaveChange,
    this.doubleValue,
    this.number,
    this.id,
  });

  /// Reads an instance from [element].
  factory Transpose.fromXml(XmlElement element) =>
      Transpose(
        diatonic: xmlInt(xmlElementText(element, 'diatonic')),
        chromatic: xmlDouble(xmlElementText(element, 'chromatic')) ?? 0,
        octaveChange: xmlInt(xmlElementText(element, 'octave-change')),
        doubleValue: switch (xmlElement(element, 'double')) {
          final child? => Double.fromXml(child),
          _ => null,
        },
        number: xmlInt(element.getAttribute('number')),
        id: element.getAttribute('id'),
      );

  /// The diatonic element specifies the number of pitch steps needed to go
  /// from written to sounding pitch. This allows for correct spelling of
  /// enharmonic transpositions. This value does not include octave-change
  /// values; the values for both elements need to be added to the written
  /// pitch to get the correct sounding pitch.
  int? diatonic;

  /// The chromatic element represents the number of semitones needed to get
  /// from written to sounding pitch. This value does not include
  /// octave-change values; the values for both elements need to be added to
  /// the written pitch to get the correct sounding pitch.
  double chromatic;

  /// The octave-change element indicates how many octaves to add to get from
  /// written pitch to sounding pitch. The octave-change element should be
  /// included when using transposition intervals of an octave or more, and
  /// should not be present for intervals of less than an octave.
  int? octaveChange;

  /// If the double element is present, it indicates that the music is doubled
  /// one octave from what is currently written.
  Double? doubleValue;

  int? number;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (diatonic != null) {
      node.children.add(xmlTextElement('diatonic', xmlNumberText(diatonic!)));
    }
    node.children.add(xmlTextElement('chromatic', xmlNumberText(chromatic)));
    if (octaveChange != null) {
      node.children.add(xmlTextElement('octave-change', xmlNumberText(octaveChange!)));
    }
    if (doubleValue != null) {
      node.children.add(doubleValue!.toXml('double'));
    }
    return node;
  }
}

/// The tremolo ornament can be used to indicate single-note, double-note, or
/// unmeasured tremolos. Single-note tremolos use the single type, double-note
/// tremolos use the start and stop types, and unmeasured tremolos use the
/// unmeasured type. The default is "single" for compatibility with Version
/// 1.1. The text of the element indicates the number of tremolo marks and is
/// an integer from 0 to 8. Note that the number of attached beams is not
/// included in this value, but is represented separately using the beam
/// element. The value should be 0 for unmeasured tremolos.
///
/// When using double-note tremolos, the duration of each note in the tremolo
/// should correspond to half of the notated type value. A time-modification
/// element should also be added with an actual-notes value of 2 and a
/// normal-notes value of 1. If used within a tuplet, this 2/1 ratio should be
/// multiplied by the existing tuplet ratio.
///
/// The smufl attribute specifies the glyph to use from the SMuFL Tremolos
/// range for an unmeasured tremolo. It is ignored for other tremolo types.
/// The SMuFL buzzRoll glyph is used by default if the attribute is missing.
///
/// Using repeater beams for indicating tremolos is deprecated as of MusicXML
/// 3.0.
class Tremolo {
  Tremolo({
    required this.value,
    this.type,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
    this.placement,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Tremolo.fromXml(XmlElement element) =>
      Tremolo(
        value: xmlInt(element.innerText) ?? 0,
        type: TremoloType.parse(element.getAttribute('type')) ?? TremoloType.single,
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  int value;

  TremoloType? type;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  AboveBelow? placement;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (type != null) {
      node.setAttribute('type', type!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// A tuplet element is present when a tuplet is to be displayed graphically,
/// in addition to the sound data provided by the time-modification elements.
/// The number attribute is used to distinguish nested tuplets. The bracket
/// attribute is used to indicate the presence of a bracket. If unspecified,
/// the results are implementation-dependent. The line-shape attribute is used
/// to specify whether the bracket is straight or in the older curved or
/// slurred style. It is straight by default.
///
/// Whereas a time-modification element shows how the cumulative, sounding
/// effect of tuplets and double-note tremolos compare to the written note
/// type, the tuplet element describes how this is displayed. The tuplet
/// element also provides more detailed representation information than the
/// time-modification element, and is needed to represent nested tuplets and
/// other complex tuplets accurately.
///
/// The show-number attribute is used to display either the number of actual
/// notes, the number of both actual and normal notes, or neither. It is
/// actual by default. The show-type attribute is used to display either the
/// actual type, both the actual and normal types, or neither. It is none by
/// default.
class Tuplet {
  Tuplet({
    this.tupletActual,
    this.tupletNormal,
    required this.type,
    this.number,
    this.bracket,
    this.showNumber,
    this.showType,
    this.lineShape,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.placement,
    this.id,
  });

  /// Reads an instance from [element].
  factory Tuplet.fromXml(XmlElement element) =>
      Tuplet(
        tupletActual: switch (xmlElement(element, 'tuplet-actual')) {
          final child? => TupletPortion.fromXml(child),
          _ => null,
        },
        tupletNormal: switch (xmlElement(element, 'tuplet-normal')) {
          final child? => TupletPortion.fromXml(child),
          _ => null,
        },
        type: xmlRequiredValue(StartStop.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        bracket: YesNo.parse(element.getAttribute('bracket')),
        showNumber: ShowTuplet.parse(element.getAttribute('show-number')),
        showType: ShowTuplet.parse(element.getAttribute('show-type')),
        lineShape: LineShape.parse(element.getAttribute('line-shape')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        id: element.getAttribute('id'),
      );

  /// The tuplet-actual element provide optional full control over how the
  /// actual part of the tuplet is displayed, including number and note type
  /// (with dots). If any of these elements are absent, their values are based
  /// on the time-modification element.
  TupletPortion? tupletActual;

  /// The tuplet-normal element provide optional full control over how the
  /// normal part of the tuplet is displayed, including number and note type
  /// (with dots). If any of these elements are absent, their values are based
  /// on the time-modification element.
  TupletPortion? tupletNormal;

  StartStop type;

  int? number;

  YesNo? bracket;

  ShowTuplet? showNumber;

  ShowTuplet? showType;

  LineShape? lineShape;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  AboveBelow? placement;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (bracket != null) {
      node.setAttribute('bracket', bracket!.xmlValue);
    }
    if (showNumber != null) {
      node.setAttribute('show-number', showNumber!.xmlValue);
    }
    if (showType != null) {
      node.setAttribute('show-type', showType!.xmlValue);
    }
    if (lineShape != null) {
      node.setAttribute('line-shape', lineShape!.xmlValue);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    if (tupletActual != null) {
      node.children.add(tupletActual!.toXml('tuplet-actual'));
    }
    if (tupletNormal != null) {
      node.children.add(tupletNormal!.toXml('tuplet-normal'));
    }
    return node;
  }
}

/// The tuplet-dot type is used to specify dotted tuplet types.
class TupletDot {
  TupletDot({
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory TupletDot.fromXml(XmlElement element) =>
      TupletDot(
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    return node;
  }
}

/// The tuplet-number type indicates the number of notes for this portion of
/// the tuplet.
class TupletNumber {
  TupletNumber({
    required this.value,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory TupletNumber.fromXml(XmlElement element) =>
      TupletNumber(
        value: xmlInt(element.innerText) ?? 0,
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  int value;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(xmlNumberText(value)));
    return node;
  }
}

/// The tuplet-portion type provides optional full control over tuplet
/// specifications. It allows the number and note type (including dots) to be
/// set for the actual and normal portions of a single tuplet. If any of these
/// elements are absent, their values are based on the time-modification
/// element.
class TupletPortion {
  TupletPortion({
    this.tupletNumber,
    this.tupletType,
    List<TupletDot>? tupletDot,
  })  : tupletDot = tupletDot ?? <TupletDot>[];

  /// Reads an instance from [element].
  factory TupletPortion.fromXml(XmlElement element) =>
      TupletPortion(
        tupletNumber: switch (xmlElement(element, 'tuplet-number')) {
          final child? => TupletNumber.fromXml(child),
          _ => null,
        },
        tupletType: switch (xmlElement(element, 'tuplet-type')) {
          final child? => TupletType.fromXml(child),
          _ => null,
        },
        tupletDot: xmlElements(element, 'tuplet-dot')
            .map(TupletDot.fromXml)
            .toList(),
      );

  TupletNumber? tupletNumber;

  TupletType? tupletType;

  List<TupletDot> tupletDot;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (tupletNumber != null) {
      node.children.add(tupletNumber!.toXml('tuplet-number'));
    }
    if (tupletType != null) {
      node.children.add(tupletType!.toXml('tuplet-type'));
    }
    for (final item in tupletDot) {
      node.children.add(item.toXml('tuplet-dot'));
    }
    return node;
  }
}

/// The tuplet-type type indicates the graphical note type of the notes for
/// this portion of the tuplet.
class TupletType {
  TupletType({
    required this.value,
    this.fontFamily,
    this.fontStyle,
    this.fontSize,
    this.fontWeight,
    this.color,
  });

  /// Reads an instance from [element].
  factory TupletType.fromXml(XmlElement element) =>
      TupletType(
        value: xmlRequiredValue(NoteTypeValue.parse(element.innerText), 'value', element),
        fontFamily: element.getAttribute('font-family'),
        fontStyle: FontStyle.parse(element.getAttribute('font-style')),
        fontSize: element.getAttribute('font-size'),
        fontWeight: FontWeight.parse(element.getAttribute('font-weight')),
        color: element.getAttribute('color'),
      );

  /// The element's text content.
  NoteTypeValue value;

  String? fontFamily;

  FontStyle? fontStyle;

  String? fontSize;

  FontWeight? fontWeight;

  String? color;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (fontFamily != null) {
      node.setAttribute('font-family', fontFamily!);
    }
    if (fontStyle != null) {
      node.setAttribute('font-style', fontStyle!.xmlValue);
    }
    if (fontSize != null) {
      node.setAttribute('font-size', fontSize!);
    }
    if (fontWeight != null) {
      node.setAttribute('font-weight', fontWeight!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// The typed-text type represents a text element with a type attribute.
class TypedText {
  TypedText({
    required this.value,
    this.type,
  });

  /// Reads an instance from [element].
  factory TypedText.fromXml(XmlElement element) =>
      TypedText(
        value: element.innerText,
        type: element.getAttribute('type'),
      );

  /// The element's text content.
  String value;

  String? type;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (type != null) {
      node.setAttribute('type', type!);
    }
    node.children.add(XmlText(value));
    return node;
  }
}

/// The unpitched type represents musical elements that are notated on the
/// staff but lack definite pitch, such as unpitched percussion and speaking
/// voice. If the child elements are not present, the note is placed on the
/// middle line of the staff. This is generally used with a one-line staff.
/// Notes in percussion clef should always use an unpitched element rather
/// than a pitch element.
class Unpitched {
  Unpitched({
    this.displayStep,
    this.displayOctave,
  });

  /// Reads an instance from [element].
  factory Unpitched.fromXml(XmlElement element) =>
      Unpitched(
        displayStep: Step.parse(xmlElementText(element, 'display-step')),
        displayOctave: xmlInt(xmlElementText(element, 'display-octave')),
      );

  Step? displayStep;

  int? displayOctave;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (displayStep != null) {
      node.children.add(xmlTextElement('display-step', displayStep!.xmlValue));
    }
    if (displayOctave != null) {
      node.children.add(xmlTextElement('display-octave', xmlNumberText(displayOctave!)));
    }
    return node;
  }
}

/// The virtual-instrument element defines a specific virtual instrument used
/// for an instrument sound.
class VirtualInstrument {
  VirtualInstrument({
    this.virtualLibrary,
    this.virtualName,
  });

  /// Reads an instance from [element].
  factory VirtualInstrument.fromXml(XmlElement element) =>
      VirtualInstrument(
        virtualLibrary: xmlElementText(element, 'virtual-library'),
        virtualName: xmlElementText(element, 'virtual-name'),
      );

  /// The virtual-library element indicates the virtual instrument library
  /// name.
  String? virtualLibrary;

  /// The virtual-name element indicates the library-specific name for the
  /// virtual instrument.
  String? virtualName;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (virtualLibrary != null) {
      node.children.add(xmlTextElement('virtual-library', virtualLibrary!));
    }
    if (virtualName != null) {
      node.children.add(xmlTextElement('virtual-name', virtualName!));
    }
    return node;
  }
}

/// The wait type specifies a point where the accompaniment should wait for a
/// performer event before continuing. This typically happens at the start of
/// new sections or after a held note or indeterminate music. These waiting
/// points cannot always be inferred reliably from the contents of the
/// displayed score. The optional player and time-only attributes restrict the
/// type to apply to a single player or set of times through a repeated
/// section, respectively.
class Wait {
  Wait({
    this.player,
    this.timeOnly,
  });

  /// Reads an instance from [element].
  factory Wait.fromXml(XmlElement element) =>
      Wait(
        player: element.getAttribute('player'),
        timeOnly: element.getAttribute('time-only'),
      );

  String? player;

  String? timeOnly;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (player != null) {
      node.setAttribute('player', player!);
    }
    if (timeOnly != null) {
      node.setAttribute('time-only', timeOnly!);
    }
    return node;
  }
}

/// Wavy lines are one way to indicate trills and vibrato. When used with a
/// barline element, they should always have type="continue" set. The smufl
/// attribute specifies a particular wavy line glyph from the SMuFL
/// Multi-segment lines range.
class WavyLine {
  WavyLine({
    required this.type,
    this.number,
    this.smufl,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.placement,
    this.color,
    this.startNote,
    this.trillStep,
    this.twoNoteTurn,
    this.accelerate,
    this.beats,
    this.secondBeat,
    this.lastBeat,
  });

  /// Reads an instance from [element].
  factory WavyLine.fromXml(XmlElement element) =>
      WavyLine(
        type: xmlRequiredValue(StartStopContinue.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        smufl: element.getAttribute('smufl'),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        placement: AboveBelow.parse(element.getAttribute('placement')),
        color: element.getAttribute('color'),
        startNote: StartNote.parse(element.getAttribute('start-note')),
        trillStep: TrillStep.parse(element.getAttribute('trill-step')),
        twoNoteTurn: TwoNoteTurn.parse(element.getAttribute('two-note-turn')),
        accelerate: YesNo.parse(element.getAttribute('accelerate')),
        beats: xmlDouble(element.getAttribute('beats')),
        secondBeat: xmlDouble(element.getAttribute('second-beat')),
        lastBeat: xmlDouble(element.getAttribute('last-beat')),
      );

  StartStopContinue type;

  int? number;

  String? smufl;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  AboveBelow? placement;

  String? color;

  StartNote? startNote;

  TrillStep? trillStep;

  TwoNoteTurn? twoNoteTurn;

  YesNo? accelerate;

  double? beats;

  double? secondBeat;

  double? lastBeat;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (placement != null) {
      node.setAttribute('placement', placement!.xmlValue);
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (startNote != null) {
      node.setAttribute('start-note', startNote!.xmlValue);
    }
    if (trillStep != null) {
      node.setAttribute('trill-step', trillStep!.xmlValue);
    }
    if (twoNoteTurn != null) {
      node.setAttribute('two-note-turn', twoNoteTurn!.xmlValue);
    }
    if (accelerate != null) {
      node.setAttribute('accelerate', accelerate!.xmlValue);
    }
    if (beats != null) {
      node.setAttribute('beats', xmlNumberText(beats!));
    }
    if (secondBeat != null) {
      node.setAttribute('second-beat', xmlNumberText(secondBeat!));
    }
    if (lastBeat != null) {
      node.setAttribute('last-beat', xmlNumberText(lastBeat!));
    }
    return node;
  }
}

/// The wedge type represents crescendo and diminuendo wedge symbols. The type
/// attribute is crescendo for the start of a wedge that is closed at the left
/// side, and diminuendo for the start of a wedge that is closed on the right
/// side. Spread values are measured in tenths; those at the start of a
/// crescendo wedge or end of a diminuendo wedge are ignored. The niente
/// attribute is yes if a circle appears at the point of the wedge, indicating
/// a crescendo from nothing or diminuendo to nothing. It is no by default,
/// and used only when the type is crescendo, or the type is stop for a wedge
/// that began with a diminuendo type. The line-type is solid if not
/// specified.
class Wedge {
  Wedge({
    required this.type,
    this.number,
    this.spread,
    this.niente,
    this.lineType,
    this.dashLength,
    this.spaceLength,
    this.defaultX,
    this.defaultY,
    this.relativeX,
    this.relativeY,
    this.color,
    this.id,
  });

  /// Reads an instance from [element].
  factory Wedge.fromXml(XmlElement element) =>
      Wedge(
        type: xmlRequiredValue(WedgeType.parse(element.getAttribute('type')), 'type', element),
        number: xmlInt(element.getAttribute('number')),
        spread: xmlDouble(element.getAttribute('spread')),
        niente: YesNo.parse(element.getAttribute('niente')),
        lineType: LineType.parse(element.getAttribute('line-type')),
        dashLength: xmlDouble(element.getAttribute('dash-length')),
        spaceLength: xmlDouble(element.getAttribute('space-length')),
        defaultX: xmlDouble(element.getAttribute('default-x')),
        defaultY: xmlDouble(element.getAttribute('default-y')),
        relativeX: xmlDouble(element.getAttribute('relative-x')),
        relativeY: xmlDouble(element.getAttribute('relative-y')),
        color: element.getAttribute('color'),
        id: element.getAttribute('id'),
      );

  WedgeType type;

  int? number;

  double? spread;

  YesNo? niente;

  LineType? lineType;

  double? dashLength;

  double? spaceLength;

  double? defaultX;

  double? defaultY;

  double? relativeX;

  double? relativeY;

  String? color;

  String? id;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    node.setAttribute('type', type.xmlValue);
    if (number != null) {
      node.setAttribute('number', xmlNumberText(number!));
    }
    if (spread != null) {
      node.setAttribute('spread', xmlNumberText(spread!));
    }
    if (niente != null) {
      node.setAttribute('niente', niente!.xmlValue);
    }
    if (lineType != null) {
      node.setAttribute('line-type', lineType!.xmlValue);
    }
    if (dashLength != null) {
      node.setAttribute('dash-length', xmlNumberText(dashLength!));
    }
    if (spaceLength != null) {
      node.setAttribute('space-length', xmlNumberText(spaceLength!));
    }
    if (defaultX != null) {
      node.setAttribute('default-x', xmlNumberText(defaultX!));
    }
    if (defaultY != null) {
      node.setAttribute('default-y', xmlNumberText(defaultY!));
    }
    if (relativeX != null) {
      node.setAttribute('relative-x', xmlNumberText(relativeX!));
    }
    if (relativeY != null) {
      node.setAttribute('relative-y', xmlNumberText(relativeY!));
    }
    if (color != null) {
      node.setAttribute('color', color!);
    }
    if (id != null) {
      node.setAttribute('id', id!);
    }
    return node;
  }
}

/// The wood type represents pictograms for wood percussion instruments. The
/// smufl attribute is used to distinguish different SMuFL stylistic
/// alternates.
class Wood {
  Wood({
    required this.value,
    this.smufl,
  });

  /// Reads an instance from [element].
  factory Wood.fromXml(XmlElement element) =>
      Wood(
        value: xmlRequiredValue(WoodValue.parse(element.innerText), 'value', element),
        smufl: element.getAttribute('smufl'),
      );

  /// The element's text content.
  WoodValue value;

  String? smufl;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (smufl != null) {
      node.setAttribute('smufl', smufl!);
    }
    node.children.add(XmlText(value.xmlValue));
    return node;
  }
}

/// Works are optionally identified by number and title. The work type also
/// may indicate a link to the opus document that composes multiple scores
/// into a collection.
class Work {
  Work({
    this.workNumber,
    this.workTitle,
    this.opus,
  });

  /// Reads an instance from [element].
  factory Work.fromXml(XmlElement element) =>
      Work(
        workNumber: xmlElementText(element, 'work-number'),
        workTitle: xmlElementText(element, 'work-title'),
        opus: switch (xmlElement(element, 'opus')) {
          final child? => Opus.fromXml(child),
          _ => null,
        },
      );

  /// The work-number element specifies the number of a work, such as its opus
  /// number.
  String? workNumber;

  /// The work-title element specifies the title of a work, not including its
  /// opus or other work number.
  String? workTitle;

  Opus? opus;

  /// Writes this value as an element named [name].
  XmlElement toXml(String elementName) {
    final node = XmlElement(XmlName(elementName));
    if (workNumber != null) {
      node.children.add(xmlTextElement('work-number', workNumber!));
    }
    if (workTitle != null) {
      node.children.add(xmlTextElement('work-title', workTitle!));
    }
    if (opus != null) {
      node.children.add(opus!.toXml('opus'));
    }
    return node;
  }
}

