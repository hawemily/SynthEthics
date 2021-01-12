import 'dart:math';

import 'package:flutter/widgets.dart';

class AchievementImages {
  static Map<int, List<Image>> imageMap = {
    0: [
      Image.asset("lib/assets/zen0.png"),
      Image.asset("lib/assets/zen1.png"),
      Image.asset("lib/assets/zen2.png"),
      Image.asset("lib/assets/zen3.png"),
      Image.asset("lib/assets/zen4.png"),
      Image.asset("lib/assets/zen5.png")
    ],
    1: [
      Image.asset("lib/assets/charitable0.png"),
      Image.asset("lib/assets/charitable1.png"),
      Image.asset("lib/assets/charitable2.png"),
      Image.asset("lib/assets/charitable3.png"),
      Image.asset("lib/assets/charitable4.png"),
      Image.asset("lib/assets/charitable5.png")
    ],
    2: [Image.asset("lib/assets/agoodstart.png")]
  };

  static retrieveLevelImage(int id, int level) {
    if (imageMap.containsKey(id)) {
      var achievementImages = imageMap[id];
      var cappedLevel = min(level, achievementImages.length - 1);
      return achievementImages[cappedLevel];
    }
    throw ("Achievement Image not found for ID " + id.toString());
  }

  static retrieveOneTimeImage(int id) {
    if (imageMap.containsKey(id)) {
      return imageMap[id][0];
    }
    throw ("Achievement Image not found for ID " + id.toString());
  }
}
