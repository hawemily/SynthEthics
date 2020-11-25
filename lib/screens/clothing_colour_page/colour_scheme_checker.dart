import 'dart:math';
import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';

class ColourSchemeChecker {
  final Set<OutfitColor> neutrals = <OutfitColor>{
    OutfitColor.Black,
    OutfitColor.Grey,
    OutfitColor.White
  };
  final List<Set<OutfitColor>> clashes = <Set<OutfitColor>>[
    {OutfitColor.Green, OutfitColor.Red},
    {OutfitColor.Magenta, OutfitColor.Yellow},
    {OutfitColor.Red, OutfitColor.Brown},
    {OutfitColor.Blue, OutfitColor.Orange}
  ];

  bool isValid(List<OutfitColor> colors) {
    if (colors.length > 4) return false;
    print("================= colours =================");

    print("colous :               $colors");
    for (int i = 0; i < colors.length - 1; i++) {
      if (neutrals.contains(colors[i])) continue;
      for (int j = i + 1; j < colors.length; j++) {
        if (neutrals.contains(colors[j])) continue;
        for (int k = 0; k < clashes.length; k++) {
          if (clashes[k].contains(colors[i]) &&
              clashes[k].contains(colors[j])) {
            return false;
          }
        }
      }
    }

    return true;
  }
}
