import 'package:firebase_ml_vision/firebase_ml_vision.dart';

abstract class LabelParser {
  Map<String, String> parseLabel();
}

// Label Source iterator
abstract class LabelSource {
  String nextBlock();
}

// VisionText Label Source is adapter for
// VisionText
class VisionTextLabelSource implements LabelSource {
  final VisionText _visionText;
  int position = 0;

  VisionTextLabelSource(this._visionText);

  @override
  String nextBlock() {
    if (position >= _visionText.blocks.length) return null;

    String block = _visionText.blocks[position].text;
    position++;
    return block;
  }
}

/// RegEx label parser for searching for an item's place of origin and material
/// on a given label
class RegexLabelParser implements LabelParser {
  final Map<String, RegExp> propertyRegExps = {
    "origin": RegExp(r"MADE IN\s?\n?\s?(\w+[^\n]*)"),
    "material": RegExp(
        r"%\s?((ORGANIC COTTON|SYNTHETIC LEATHER|RECYCLED POLYESTER)|((\w+\s)?(ACRYLIC|BAMBOO|COTTON|HEMP|JUTE|LEATHER|LINEN|LYOCELL|NYLON|POLYESTER|POLYPROPYLENE|SILK|SPANDEX|VISCOSE|WOOL)))")
  };
  final LabelSource _labelSource;

  RegexLabelParser(this._labelSource);

  @override
  Map<String, String> parseLabel() {
    var data = Map<String, String>();
    var nextBlock = _labelSource.nextBlock();
    while (nextBlock != null) {
      _matchProperty(data, nextBlock, "origin");
      _matchProperty(data, nextBlock, "material");

      if (data.containsKey("origin") && data.containsKey("material")) {
        return data;
      }

      nextBlock = _labelSource.nextBlock();
    }

    if (!data.containsKey("origin")) data["origin"] = "";
    if (!data.containsKey("material")) data["material"] = "";
    return data;
  }

  void _matchProperty(Map<String, String> data, String text, String property) {
    if (!data.containsKey(property)) {
      RegExpMatch propertyMatch =
          propertyRegExps[property].firstMatch(text.toUpperCase());
      if (propertyMatch != null) {
        if (property == "origin") {
          data[property] = _AbbrevMapping(propertyMatch.group(1));
        } else if (property == "material") {
          data[property] = propertyMatch.group(propertyMatch.groupCount);
        }
      }
    }
  }

  String _AbbrevMapping(String countryName) {
    switch (countryName) {
      case "UK":
      case "THE UK":
        return "UNITED KINGDOM";
      case "U.S.A.":
      case "USA":
        return "UNITED STATES";
      default:
        return countryName;
    }
  }
}
