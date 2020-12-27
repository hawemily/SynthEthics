import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const getUserRecords = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  try {
    console.log("Entered function")
    const userRef = await db.collection(Collections.Users);
    if (req.headers['uid'] != null) {
        const userID: any = req.headers["uid"];
        console.log("UID : " + userID);
        const user = await userRef.doc(userID).get();

        if (user.exists) {
            const userData = user.data();
            res.status(200).json(userData!);
        }
    }
    res.status(204).json();
  } catch (e) {
    console.log(e);
    res.status(400);
  }
};