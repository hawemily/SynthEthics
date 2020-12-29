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
    if (req.params.uid != null) {
      const currentUserSnapshot = await userRef.where("userId", "==", req.params.uid).get();
      const result: any[] = [];
      if (!currentUserSnapshot.empty) {
        var userData: FirebaseFirestore.DocumentData;
        currentUserSnapshot.forEach((user) => {
          userData = user.data();
        });

        const achievementsSnapshot = await achievementsRef.get();

        if (!achievementsSnapshot.empty) {
          achievementsSnapshot.forEach((achievement) => {
            result.push({
              data: achievement.data(),
              user: userData,
              achievedStatus: userData['achieved'].includes(achievement.data()['achievementId'])
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