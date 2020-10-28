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

class RegexLabelParser implements LabelParser {

  final Map<String, RegExp> propertyRegExps = {
    "origin" : RegExp(r"MADE IN (\w+)"),
    "material" : RegExp(r"%\s?(\w+)")
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
      RegExpMatch propertyMatch = propertyRegExps[property].
        firstMatch(text.toUpperCase());
      if (propertyMatch != null) {
        data[property] = propertyMatch.group(0);
      }
    }
  }

}