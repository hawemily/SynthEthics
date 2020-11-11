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

  Achievement({this.id = 0, this.name = "f", this.description = "f",
      this.type, this.achieved, this.level,
      this.previousTarget, this.nextTarget, this.progressToTarget});
}

enum AchievementType {
  Unlock, Tiered
}