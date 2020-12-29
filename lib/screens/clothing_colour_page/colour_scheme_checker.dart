import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';

class ColourSchemeChecker {
  final Set<OutfitColor> neutrals = <OutfitColor>{
    OutfitColor.Black,
    OutfitColor.Grey,
    OutfitColor.White
  };
  final List<List<OutfitColor>> clashes = <List<OutfitColor>>[
    [OutfitColor.Green, OutfitColor.Red],
    [OutfitColor.Magenta, OutfitColor.Yellow],
    [OutfitColor.Red, OutfitColor.Brown],
    [OutfitColor.Blue, OutfitColor.Orange]
  ];

  bool isValid(Set<OutfitColor> colors) {
    if (colors.length > 4) return false;

    // for (int i = 0; i < colors.length - 1; i++) {
    //   if (neutrals.contains(colors[i])) continue;
    //   for (int j = i + 1; j < colors.length; j++) {
    //     if (neutrals.contains(colors[j])) continue;
    //     for (int k = 0; k < clashes.length; k++) {
    //       if (clashes[k].contains(colors[i]) &&
    //           clashes[k].contains(colors[j])) {
    //         return false;
    //       }
    //     }
    //   }
    // }

    for (int i = 0; i < clashes.length; i++) {
       
      if (colors.contains(clashes[i][0]) && colors.contains(clashes[i][1])) {
        return false;
      }
    
    }

    return true;
  }
}
