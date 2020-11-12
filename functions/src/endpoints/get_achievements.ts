import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const getAchievements = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  try {
    const achievementsRef = await db.collection(Collections.Achievements);
    const userRef = await db.collection(Collections.Users);
    console.log(req.headers);
    console.log(req.headers['uid']);
    if (req.headers['uid'] != null) {
      const currentUserSnapshot = await userRef.where("userId", "==", req.headers["uid"]).get();
      const result: any[] = [];
      if (!currentUserSnapshot.empty) {
        var achieved: any[] = [];
        currentUserSnapshot.forEach((user) => {
          achieved = user.data()['achieved'];
        });

        const achievementsSnapshot = await achievementsRef.get();

        if (!achievementsSnapshot.empty) {
          achievementsSnapshot.forEach((achievement) => {
            result.push({
              id: achievement.id,
              data: achievement.data(),
              status: achieved.includes(achievement.data()['achievementId'])
            });
          });
        }
      }
      res.status(200).json(result);
    }
    res.status(204).json();
  } catch (e) {
    console.log(e);
    res.status(400);
  }
};