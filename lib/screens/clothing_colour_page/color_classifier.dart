import 'package:flutter/material.dart';

///
/// Class contains operations required for the classification of clothing items,
/// or rather, their dominant colours into a colour category
///
class ColorClassifier {
  final int MAX_PIXEL = 255;

  OutfitColor classifyColor(Color color) {
    Map<String, int> HSL = convertRGBToHSL(color);
    int hue = HSL["H"];
    int sat = HSL["S"];
    int lum = HSL["L"];

    print("H: $hue, S: $sat, L: $lum");

    if (lum < 20) {
      return OutfitColor.Black;
    }
    if (lum > 80) {
      return OutfitColor.White;
    }

    if (sat <= 8) {
      return OutfitColor.Grey;
    }

    if (hue < 15 && lum < 50 && sat < 50) {
      return OutfitColor.Brown;
    } else if (hue < 25) {
      return OutfitColor.Red;
    } else if (hue < 45) {
      return OutfitColor.Orange;
    } else if (hue < 65) {
      return OutfitColor.Yellow;
    } else if (hue < 150) {
      return OutfitColor.Green;
    } else if (hue < 210) {
      return OutfitColor.Cyan;
    } else if (hue < 240) {
      return OutfitColor.Blue;
    } else if (hue < 280) {
      return OutfitColor.Magenta;
    }

    return OutfitColor.Pink;
  }

  Map<String, int> convertRGBToHSL(Color color) {
    final hslColor = HSLColor.fromColor(color);
    final H = hslColor.hue.round();
    final S = (hslColor.saturation * 100).round();
    final L = (hslColor.lightness * 100).round();

    print("HSL: $H, $S, $L");
    Map<String, int> res = {'H': H, 'S': S, 'L': L};
    return res;
  }
}

/// Colour categories ==========================================================
enum OutfitColor {
  Black,
  White,
  Grey,
  Red,
  Yellow,
  Green,
  Cyan,
  Blue,
  Magenta,
  Brown,
  Orange,
  Pink
}

enum AccentColor { Red, Blue, Purple }

/// ============================================================================
