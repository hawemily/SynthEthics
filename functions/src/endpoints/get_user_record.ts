import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const getUserRecords = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  try {
    console.log("Entered function")
    const userRef = db.collection(Collections.Users);
    if (req.params.uid != null) {
        const userID: any = req.params.uid;
        console.log("UID : " + userID);
        const user = await userRef.doc(userID).get();

        if (user.exists) {
            const userData = user.data();
            res.status(200).json(userData!);
        }
        else {
          res.status(204).send("User does not exist");
        }
    }
    else {
      res.status(204).send("User does not exist");
    }
  } catch (e) {
    console.log(e);
    res.status(400).send("Error: Failed to fetch user records");
  }
};