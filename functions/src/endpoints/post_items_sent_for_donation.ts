import {Request, Response} from 'express';
import { Collections } from '../helper_components/db_collections';

export const sendItemsForDonation = async (req:Request, res:Response, db: FirebaseFirestore.Firestore) => {
    try {
        const {uid, ids} = req.body;
        const userRef = db.collection(Collections.Users).doc(uid);
        const toDonateRef = userRef.collection(Collections.ToDonate);
        const donatedRef = userRef.collection(Collections.Donated);

        for(var i = 0; i < ids.length; i++) {
            const clothingItem = await toDonateRef.doc(ids[i]).get();
            donatedRef.doc(clothingItem.id).set(clothingItem.data()!);
            await toDonateRef.doc(ids[i]).delete();
        }

        res.send(200);
    } catch (e) {
        console.log("post items for donation unsuccessful, request malformed");
        res.json(400);
    }
}