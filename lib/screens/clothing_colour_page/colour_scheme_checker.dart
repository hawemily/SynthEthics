import 'package:synthetics/screens/clothing_colour_page/color_classifier.dart';


///
/// Class checks whether given colour schemes contain clashes.
///
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
    for (int i = 0; i < clashes.length; i++) {
       
      if (colors.contains(clashes[i][0]) && colors.contains(clashes[i][1])) {
        return false;
      }
    }
    return true;
  }
}
