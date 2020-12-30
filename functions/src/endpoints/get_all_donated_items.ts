import {Request, Response} from "express";
import { Collections } from "../helper_components/db_collections";

export const getAllDonatedItems = async(req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    const uid = req.params.uid;

    console.log("in get all donated items!!!!");
    const userToDonateRef = db.collection(Collections.Users).doc(uid).collection(Collections.ToDonate);

    const pendingDonationQuery = await userToDonateRef.where('donated', '==', false).get();
    const itemsDonatedQuery = await userToDonateRef.where('donated', '==', false).get();

    const clothingItems: any[] = [];
    
    pendingDonationQuery.forEach((doc) => {
        clothingItems.push({id: doc.id, data: doc.data()});
    })

    itemsDonatedQuery.forEach((doc) => {
        clothingItems.push({id: doc.id, data: doc.data()});
    })

    res.status(200).json({clothingItems : clothingItems});
}