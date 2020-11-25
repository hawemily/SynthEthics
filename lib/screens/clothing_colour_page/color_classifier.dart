import 'dart:math';

import 'package:flutter/material.dart';

class ColorClassifier {
  final int MAX_PIXEL = 255;

  OutfitColor classifyColor(Color color) {
    Map<String, int> HSL = convertRGBToHSL(color);
    int hue = HSL["H"];
    int sat = HSL["S"];
    int lum = HSL["L"];

    if (lum < 20) {return OutfitColor.Black;}
    if (lum > 80) {return OutfitColor.White;}

    if (sat < 25) {
      return OutfitColor.Grey;
    }

    if (hue < 30) {
      return OutfitColor.Red;
    } else if(hue < 90) {
      return OutfitColor.Yellow;
    } else if (hue < 150) {
      return OutfitColor.Green;
    } else if(hue < 210){
      return OutfitColor.Cyan;
    } else if(hue < 270) {
      return OutfitColor.Blue;
    } else if (hue < 330) {
      return OutfitColor.Magenta;
    }

    return OutfitColor.Red;
  }

  Map<String, int> convertRGBToHSL(Color color) {
    double r = color.red / MAX_PIXEL;
    double b = color.blue / MAX_PIXEL;
    double g = color.green / MAX_PIXEL;
    String maxColor = "";

    double minVal = min(min(r, g), b);
    double maxVal = max(max(r, g), b);
    if(maxVal == r) {
      maxColor = "R";
    } else if (maxVal == b){
      maxColor = "B";
    } else {
      maxColor = "G";
    }
    double range = maxVal - minVal;
    double sum = minVal + maxVal;

    int L = ((sum) / 2 * 100).round();

    int S = minVal == maxVal
        ? 0
        : (L <= 0.5
        ? (range / sum * 100).round()
        : (range / (2.0 - sum) * 100).round());

    double doubleH = 0;

    if(maxColor == "R") {
      doubleH = (g - b)/range;
    } else if (maxColor == "G") {
      doubleH = 2 + (b - r)/range;
    } else if (maxColor == "B") {
      doubleH = 4 + (r - g)/range;
    }

    double degree = doubleH * 60;

    int H = degree < 0 ? (degree + 360).round() : degree.round();

    Map<String, int> res = {};
    res["H"] = H;
    res["S"] = S;
    res["L"] = L;
    return res;
  }
}

enum OutfitColor { Black, White, Grey, Red, Yellow, Green, Cyan, Blue, Magenta }

enum AccentColor { Red, Blue, Purple }
