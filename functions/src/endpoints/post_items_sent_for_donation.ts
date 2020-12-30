import {Request, Response} from 'express';
import { Collections } from '../helper_components/db_collections';

export const sendItemsForDonation = async (req:Request, res:Response, db: FirebaseFirestore.Firestore) => {
    try {
        const {uid, ids} = req.body;
        const userRef = db.collection(Collections.Users).doc(uid);
        const toDonateRef = userRef.collection(Collections.ToDonate);

        for(var i = 0; i < ids.length; i++) {
            await toDonateRef.doc(ids[i]).update({
                donated: true
            });
        }

        res.send(200);
    } catch (e) {
        console.log("post items for donation unsuccessful, request malformed");
        res.json(400);
    }
}