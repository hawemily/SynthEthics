// Achievement data class used to pass fetched achievement
// data between Flutter widgets

class Achievement {
  final int id;

  final String name;
  final String description;

  final AchievementType type;
  final bool achieved;

  final int level;
  final int previousTarget;
  final int nextTarget;
  final int progressToTarget;

  Achievement(
      {this.id = 0,
      this.name = "Items Donated",
      this.description = "How many of your clothes have you donated?",
      this.type = AchievementType.Unlock,
      this.achieved = true,
      this.level = 14,
      this.previousTarget = 50,
      this.nextTarget = 300,
      this.progressToTarget = 200});
}

enum AchievementType { Unlock, Tiered }
