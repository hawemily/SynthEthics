import {Request, Response} from "express";
import { Collections } from "../helper_components/db_collections";

export const getAllDonatedItems = async(req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    
    console.log("in get all donated items!!!!");
    const toDonateSnapshot = await db.collection(Collections.ToDonate).get();

    const clothingItems: any[] = [];
    
    toDonateSnapshot.forEach((doc) => {
        clothingItems.push({id: doc.id, data: doc.data()});
    })

    res.status(200).json({clothingItems : clothingItems});
}