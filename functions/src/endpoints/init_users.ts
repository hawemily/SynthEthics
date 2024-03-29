// import { addNewUser } from "./post_new_user";
import { Collections } from "../helper_components/db_collections";
import { Request, Response } from "express";
import { User } from "../models/users";

export const initUsers = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  try {
    const {uid} = req.body;
    const userRef = db.collection(Collections.Users);
    const userSnapshot = await userRef.where("userId", "==", uid).get();
    if (userSnapshot.empty) {
      // addNewUser(req, res, db);
      const user: User = {
        userId: uid,
        lastName: "Random",
        firstName: "user",
        carmaPoints: 0,
        itemsDonated: 1,
        itemsWorn: 5,
        itemsBought: 1,
        achieved: [2],
        carmaRecord: {days: [{day: "MON", value:23}], months: [], years: []}
      }
      await userRef.doc(uid).set(user);
      res.status(200);
    }
  } catch (e) {
    console.log(e);
    res.status(400);
  }
}
