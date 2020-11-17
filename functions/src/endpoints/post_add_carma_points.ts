import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const addCarmaPoints = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {

    try {
        const userID = req.body["uid"];
        const carmaAmount = req.body["carma"];

        const userRef = await db.collection(Collections.Users);

        // Body consists of user ID and carma value
        // We want to update user's carma
        const user = await userRef.doc(userID).get();
        if (user.exists) {
          const userData = user.data();
          var currentCarmaPoints = userData!['carmaPoints'];
          currentCarmaPoints += carmaAmount;
          userData!['carmaPoints'] = currentCarmaPoints;

          // 

          await userRef.doc(userID).set(userData!);
        }
        // Update user's carma records for graph
        // Check for carma earnt

    } catch (e) {
        console.log(e);
        res.status(400).send("Could not add carma points to user's clothing item");
    }
};