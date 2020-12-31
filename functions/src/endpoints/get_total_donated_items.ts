import {Request, Response} from "express";
import { Collections } from "../helper_components/db_collections";
 
export const getTotalNumberOfDonatedItems = async (req: Request, res: Response, db:FirebaseFirestore.Firestore) => {
    
    try {
        const uid = req.params.uid;

        const userDonationRef = db.collection(Collections.Users).doc(uid).collection(Collections.ToDonate);

        const totalDonatedItemsQuery = await userDonationRef.where("donated", "==", true).get();

        var totalDonatedItemsSum = 0;

        totalDonatedItemsQuery.forEach(_ => {
            totalDonatedItemsSum += 1;
        });

        res.status(200).json({donatedItems: totalDonatedItemsSum});
    
    } catch(e) {
        console.log("Unsuccessful get of total number of donated items, request malformed.");
        res.status(400);
    }
    
 }