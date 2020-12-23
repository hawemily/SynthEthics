import {Request, Response} from "express";
import {Collections} from "../helper_components/db_collections";

export const updateClothingItem = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    
    try {
        const {
            id, 
            timesWorn, 
            lastWorn
        } = req.body;

        // const userRef = db.collection(Collections.Users).doc(uid);

         const closetRef = db.collection(Collections.Closet);

         
        const clothingItem = await closetRef.doc(id).get();
        await closetRef.doc(id).delete();
        clothingItem.lastWorn = lastWorn;
        clothingItem.currentTimesWorn = timesWorn;
        clothingItem.cF = clothingItem.carmaPerWear * timesWorn;

        const updatedClothingItem = await closetRef.add(clothingItem);

        const result = { clothingID: updatedClothingItem.id};
        res.json(result);

    } catch (e) {
        console.log(e);
        // res.status(400).send(`Could not remove items from clothing to be donated, malformed request`);
    }

}