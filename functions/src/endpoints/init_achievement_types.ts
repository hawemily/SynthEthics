import { AchievementType } from "../models/achievements";
import { Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const initAchievementTypes = async (
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const achievementsRef = db.collection(Collections.Achievements);
  const content = achievementsRef.get();

  if ((await content).empty) {
    const achievements = [
      {
        achievementId: 0,
        achievementName: "Zen Master",
        achievementDescription: "Collect Carma by making sustainable fashion choices",
        AchievementType: AchievementType.Tiered,
        achievementTiers: [100, 500, 1000, 1750, 2500],
        achievementAttribute: "carmaPoints"
      },
      {
        achievementId: 1,
        achievementName: "Charitable",
        achievementDescription: "Collect Carma by making sustainable fashion choices",
        AchievementType: AchievementType.Tiered,
        achievementTiers: [2, 5, 10, 20, 50],
        achievementAttribute: "itemsDonated"
      },
      {
        achievementId: 2,
        achievementName: "A Good Start",
        achievementDescription: "Donate your first item of clothing",
        AchievementType: AchievementType.Binary,
      },
      // {
      //   achievementId: 3,
      //   achievementName: "Hats Off to You",
      //   achievementDescription: "Wear Hats a certain amount of time",
      //   AchievementType: AchievementType.ClothingTiered,
      //   achievementTiers: [2, 5, 10, 20, 50],
      //   achievementAttribute: "Headgear"
      // }
    ];

    const result =  await achievementsRef.add(achievements[0]);
    for (let i = 1; i < achievements.length; i++) {
      await achievementsRef.add(achievements[i])
    }
    res.json({success: (result.id != null)});
  }
  res.json({success: false});
};