import {Request, Response} from 'express';
import { Collections } from '../helper_components/db_collections';

export const getItemsSentForDonation = async (req:Request, res:Response, db: FirebaseFirestore.Firestore) => {
    try {
        console.log("in get all items sent for donation!!!!");
        const uid = req.params.uid;

        const userRef = db.collection(Collections.Users).doc(uid);
        const toDonateSnapshot = await userRef.collection(Collections.ToDonate).get();

        const clothingItems: any[] = [];
        
        toDonateSnapshot.forEach((doc) => {
            clothingItems.push({id: doc.id, data: doc.data()});
        })

        res.status(200).json({clothingItems : clothingItems});

    } catch (e) {
        console.log("post items for donation unsuccessful, request malformed");
        res.json(400);
    }
}