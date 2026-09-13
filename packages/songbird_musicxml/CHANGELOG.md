## 0.1.1

- Moved to `xml` 7. `XmlName` is constructed through `XmlName.parts`
  and the schema tools ask for `namespaceUri` rather than the
  deprecated `namespace`.

## 0.1.0

- Initial release: MusicXML 4.0 reader and writer, a document model generated
  from the official XSD, and mapping to and from the songbird_score model.
