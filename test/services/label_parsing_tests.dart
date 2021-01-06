import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:synthetics/services/country/country_data.dart';
import 'package:synthetics/services/label_parser/label_parser.dart';

void main() {
  group("tests", () {

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

    group("VisionText label parser tests", () {
      var source = TestLabelSource();
      var testLabelData = ["irrelevant info",
        "this is MADE IN china",
        "100% cotton"];
      var testDataIndex = 0;
      when(source.nextBlock()).thenAnswer((_) {
        if (testDataIndex == testLabelData.length) return null;
        return testLabelData[testDataIndex++];
      });

      test("Regex parser tries to look for origin and material", () {
        testDataIndex = 0;

        var parser = RegexLabelParser(source);
        var labelProperties = parser.parseLabel();
        expect(labelProperties.containsKey("origin"), true);
        expect(labelProperties.containsKey("material"), true);
      });

      test("Regex parser identifies the first country origin", () {
        testDataIndex = 0;

        var parser = RegexLabelParser(source);
        var labelProperties = parser.parseLabel();
        expect(labelProperties.containsKey("origin"), true);
        expect(labelProperties["origin"].toUpperCase(), "MADE IN CHINA");
      });

      test("Regex parser identifies the first material", () {
        testDataIndex = 0;

        var parser = RegexLabelParser(source);
        var labelProperties = parser.parseLabel();
        expect(labelProperties.containsKey("material"), true);
        expect(labelProperties["material"].toUpperCase(), "% COTTON");
      });
    });
  });
}

// Class for testing parsers that use LabelSource
class TestLabelSource extends Mock implements LabelSource {
}