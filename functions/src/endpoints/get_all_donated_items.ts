import {Request, Response} from "express";
import { Collections } from "../helper_components/db_collections";

export const getAllDonatedItems = async(req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    const uid = req.params.uid;

    console.log("in get all donated items!!!!");
    const userRef = db.collection(Collections.Users).doc(uid);
    const toDonateSnapshot = await userRef.collection(Collections.ToDonate).get();

    const clothingItems: any[] = [];
    
    toDonateSnapshot.forEach((doc) => {
        clothingItems.push({id: doc.id, data: doc.data()});
    })

    res.status(200).json({clothingItems : clothingItems});
}