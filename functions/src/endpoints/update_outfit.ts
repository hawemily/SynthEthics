import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";
import { addToCarmaRecord } from "../helper_components/update_carma_record";
import { User } from "../models/users";


export const updateOutfit = async (
    req: Request,
    res: Response,
    db: FirebaseFirestore.Firestore
) => {
    try {
        const {
            uid,
            clothingIds,
            lastWorn,
            timesWorns,
            carmaGains
        } = req.body;

        const userRef = db.collection(Collections.Users).doc(uid);
        const closetRef = userRef.collection(Collections.Closet);
        const user = await userRef.get();

        var totalGain = 0;
        var totalWorn = 0;
        for (var i = 0; i < clothingIds.length; i++) {
            
             // updating fields in each clothing item
            const clothingItem = await closetRef.doc(clothingIds[i]).get();

            console.log(clothingItem.data.name);

            if (clothingItem.exists) {
                const itemData = clothingItem.data();
                itemData!['lastWornDate'] = lastWorn;
                itemData!['currentTimesWorn'] = timesWorns[i];
                await closetRef.doc(clothingIds[i]).set(itemData!);
            }

            totalGain += carmaGains[i];
            totalWorn++;
        }


        // updating user's carma points
        if (user.exists) {
            const userData = user.data();
            var currentCarmaPoints = userData!['carmaPoints'];
            currentCarmaPoints += totalGain;
            userData!['carmaPoints'] = currentCarmaPoints;
            userData!['itemsWorn'] = userData!['itemsWorn'] + totalWorn;
            addToCarmaRecord(userData as User, totalGain)
            await userRef.set(userData!);
      }
      res.status(200).send("Outfit updated");
    } catch (error) {
        res.status(400).send('Failed to post outfit');
    }
}