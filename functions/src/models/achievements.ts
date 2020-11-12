export enum AchievementType {
  Binary,
  Tiered,
  ClothingTiered
}

export interface Achievements {
  achievementId: number;
  achievementName: string;
  achievementDescription: string;
  achievementType: AchievementType,
  achievementTiers?: number[],
  achievementAttribute?: String,
}