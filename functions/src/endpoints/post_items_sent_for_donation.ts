import {Request, Response} from 'express';
import { Collections } from '../helper_components/db_collections';

export const sendItemsForDonation = async (req:Request, res:Response, db: FirebaseFirestore.Firestore) => {
    try {
        const {uid, ids} = req.body;
        const userRef = db.collection(Collections.Users).doc(uid);
        const toDonateRef = userRef.collection(Collections.ToDonate);

        var totalCarmaAddedFromDonatedItems = (await userRef.get()).data()!["cF"];

        const DONATION_CONST = 0.1;

        for(var i = 0; i < ids.length; i++) {
            const donatedItemMetadata= (await toDonateRef.doc(ids[i]).get()).data();
            totalCarmaAddedFromDonatedItems += donatedItemMetadata!["cF"] * DONATION_CONST;

            await toDonateRef.doc(ids[i]).update({
                donated: true
            });
        }

        await userRef.update({
            carmaPoints: totalCarmaAddedFromDonatedItems
        });

        res.send(200);
    } catch (e) {
        console.log("post items for donation unsuccessful, request malformed");
        res.json(400);
    }
}