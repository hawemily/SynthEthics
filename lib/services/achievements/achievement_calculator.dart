class AchievementLevelCalculator {
  static calculate(dynamic tiers, dynamic value) {
    value = value.round();
    int currentLevel = 0;
    int previousAmount = 0;
    int targetAmount = 0;

    for (int i = 0; i < tiers.length; i++) {
      if (tiers[i] > value) {
        targetAmount = tiers[i];
        if (i > 0) {
          previousAmount = tiers[i - 1];
          value -= tiers[i - 1];
        }
        break;
      } else {
        currentLevel++;
      }
    }

    // If value is greater than the higher amount for a level we
    // specify, keep adding levels per amount exceeding the difference
    // between the last level amount and its previous
    if (value >= tiers[tiers.length - 1]) {
      int amountPerLevel = (tiers.length == 1) ? tiers[0] :
        tiers[tiers.length - 1] - tiers[tiers.length - 2];
      int excess = value - tiers[tiers.length - 1];
      int extraLevels = excess ~/ amountPerLevel;

      currentLevel += extraLevels;
      previousAmount = tiers[tiers.length - 1] + extraLevels * amountPerLevel;
      targetAmount = previousAmount + amountPerLevel;
      value -= previousAmount;
    }

    return {"level" : currentLevel, "previousAmount" : previousAmount,
      "targetAmount" : targetAmount, "progress" : value};
  }
}
