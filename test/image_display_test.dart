import 'package:flutter_test/flutter_test.dart';
import 'package:synthetics/services/country/country_data.dart';
import 'package:synthetics/services/label_parser/label_parser.dart';

void main() {
  group("Country data match tests", () {
    var countryNames = ["united kingdom", "jamaica",
      "rwandA", "CHINA", "noRwaY"];
    test("Match returns index if country is in list", () {
      int value = CountryData.containsCountry(countryNames, "chInA");

      expect(value, 3);
    });

    test("Match returns -1 if country is not in list", () {
      int value = CountryData.containsCountry(countryNames, "chayna");

      expect(value, -1);
    });
  });

  group("Label Source tests", () {
    test("Empty label source returns no next", () {
      var source = TestLabelSource([]);
      expect(source.nextBlock(), null);
    });

    test("Label source with 1 item returns once correctly", () {
      var source = TestLabelSource(["item1"]);
      expect(source.nextBlock(), "item1");
      expect(source.nextBlock(), null);
      expect(source.nextBlock(), null);
    });
  });

  group("VisionText label parser tests", () {
    test("Regex parser tries to look for origin and material", () {
      var source = TestLabelSource(["irrelevant info",
        "this is MADE IN china",
        "100% cotton"]);
      var parser = RegexLabelParser(source);
      var labelProperties = parser.parseLabel();
      expect(labelProperties.containsKey("origin"), true);
      expect(labelProperties.containsKey("material"), true);
    });

    test("Regex parser identifies the first country origin", () {
      var testLabelSource = TestLabelSource(["irrelevant info",
        "this is MADE IN china",
        "100% cotton"]);
      var parser = RegexLabelParser(testLabelSource);
      var labelProperties = parser.parseLabel();
      expect(labelProperties.containsKey("origin"), true);
      expect(labelProperties["origin"].toUpperCase(), "MADE IN CHINA");
    });

    test("Regex parser identifies the first material", () {
      var testLabelSource = TestLabelSource(["irrelevant info",
        "this is made in china",
        "100% cotton"]);
      var parser = RegexLabelParser(testLabelSource);
      var labelProperties = parser.parseLabel();
      expect(labelProperties.containsKey("material"), true);
      expect(labelProperties["material"].toUpperCase(), "% COTTON");
    });
  });
}

// Class for testing parsers that use LabelSource
class TestLabelSource implements LabelSource {
  final List<String> _data;
  int position = 0;

  TestLabelSource(this._data);

  @override
  String nextBlock() {
    if (position >= _data.length) return null;

    String block = _data[position];
    position++;
    return block;
  }

}