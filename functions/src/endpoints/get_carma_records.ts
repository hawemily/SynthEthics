import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";
import { cleanCarmaRecord } from "../helper_components/update_carma_record";
import { User } from "../models/users";

export const getCarmaRecords = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const userID: any = req.headers["uid"];
  const userRef = await db.collection(Collections.Users);

  try {
    const user = await userRef.doc(userID).get();
    if (user.exists) {
      const userData = user.data();

      // First we clean it in case of stale data
      cleanCarmaRecord(userData as User);

      // Then we update the backend with cleaned data
      await userRef.doc(userID).set(userData!);

      // Return carma record
      res.status(200).send({carmaRecord : userData!["carmaRecord"]});
    }
  } catch (e) {
      console.log(e);
      res.status(400).send("Could not retrieve get carma record from user");
  }
}