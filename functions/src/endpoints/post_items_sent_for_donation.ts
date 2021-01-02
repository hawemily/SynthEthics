import {Request, Response} from 'express';
import { Collections } from '../helper_components/db_collections';
import { addToCarmaRecord } from '../helper_components/update_carma_record';
import { User } from '../models/users';

export const sendItemsForDonation = async (req:Request, res:Response, db: FirebaseFirestore.Firestore) => {
    try {
        const {uid, ids} = req.body;
        const userRef = db.collection(Collections.Users).doc(uid);
        const toDonateRef = userRef.collection(Collections.ToDonate);

        var userData = (await userRef.get()).data();
        var currentCarmaPoints = userData!["carmaPoints"];
        var currentItemsDonated = userData!["itemsDonated"];

        const DONATION_CONST = 0.1;

        var totalCarmaAddedFromDonatedItems = 0;

        for(var i = 0; i < ids.length; i++) {
            const donatedItemMetadata= (await toDonateRef.doc(ids[i]).get()).data();
            totalCarmaAddedFromDonatedItems += donatedItemMetadata!["cF"] * DONATION_CONST;

            await toDonateRef.doc(ids[i]).update({
                donated: true
            });
        }

        // Toggle "A Good Start" achievement if appropriate
        var newAchieved = userData!["achieved"];
        if (!newAchieved.includes(2)) {
            newAchieved.push(2);
        }
        
        addToCarmaRecord(userData as User, totalCarmaAddedFromDonatedItems)

        await userRef.update({
            carmaPoints: currentCarmaPoints + totalCarmaAddedFromDonatedItems,
            itemsDonated: currentItemsDonated + ids.length,
            achieved: newAchieved,
            carmaRecord: userData!["carmaRecord"]
        });

        res.send(200);
    } catch (e) {
        console.log("post items for donation unsuccessful, request malformed");
        res.json(400);
    }
}