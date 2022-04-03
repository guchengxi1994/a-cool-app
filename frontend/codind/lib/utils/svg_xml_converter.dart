import 'package:xml/xml.dart';

String svgConvert(String instr) {
  final document = XmlDocument.parse(instr);

  final fg = document.getElement('svg')?.getElement('g');

  if (fg == null) {
    return "";
  }

  final builder = XmlBuilder();

  builder.element('svg', attributes: {
    "xmlns:svg": "http://www.w3.org/2000/svg",
    "xmlns:dc": "http://purl.org/dc/elements/1.1/",
    "xmlns:cc": "http://creativecommons.org/ns#",
    "xmlns:rdf": "http://www.w3.org/1999/02/22-rdf-syntax-ns#",
    "xmlns": "http://www.w3.org/2000/svg",
    "viewBox": "0 0 280 280",
    "fill": "none",
  }, nest: () {
    builder.element('g', nest: () {
      var children = fg.children;
      for (var i in children) {
        builder.text(i.toXmlString());
      }
    });
  });

  return builder.buildDocument().toXmlString();
}
