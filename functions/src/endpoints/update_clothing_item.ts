import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";
import { addToCarmaRecord } from "../helper_components/update_carma_record";
import { User } from "../models/users";

export const updateClothingItem = async (
    req: Request,
    res: Response,
    db: FirebaseFirestore.Firestore
) => {
    try {
        const {
            uid,
            clothingId,
            lastWorn,
            timesWorn,
            carmaGain,
            action
        } = req.body;

        const userRef = db.collection(Collections.Users).doc(uid);
        const closetRef = userRef.collection(Collections.Closet);

        // updating fields in clothing item
        const clothingItem = await closetRef.doc(clothingId).get();

        if (clothingItem.exists) {
            const itemData = clothingItem.data();
            itemData!['lastWornDate'] = lastWorn;
            itemData!['currentTimesWorn'] = timesWorn;
            await closetRef.doc(clothingId).set(itemData!);
        }

        // updating user's carma points
        const user = await userRef.get();
        if (user.exists) {
            const userData = user.data();
            var currentCarmaPoints = userData!['carmaPoints'];
            if (action != "INC" && currentCarmaPoints!= 0) {
                currentCarmaPoints -= carmaGain;
                // Add/Update entry in user's carma records, for graph
                addToCarmaRecord(userData as User, -carmaGain);
            } else if (action == "INC") {
                currentCarmaPoints += carmaGain;
                // Add/Update entry in user's carma records, for graph
                addToCarmaRecord(userData as User, carmaGain);
            }

            userData!['carmaPoints'] = currentCarmaPoints;
            userData!['itemsWorn'] = userData!['itemsWorn'] + 1;
            await userRef.set(userData!);
          }

        res.send(200);
    } catch (error) {
        res.status(400).send('Failed to post outfit');
    }
}