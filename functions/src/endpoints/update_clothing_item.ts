import {
    Request,
    Response
} from "express";
import { Collections } from "../helper_components/db_collections";


export const updateClothingItem = async (
    req: Request,
    res: Response,
    db: FirebaseFirestore.Firestore
) => {
    try {
        const {
            uid,
            clothingId,
            lastWorn,
            timesWorn
        } = req.body;

        console.log("-------------------Before -------------------");

       
        const userRef = db.collection(Collections.Users).doc(uid);
        const closetRef = userRef.collection(Collections.Closet);

        await closetRef.doc(clothingId).set({'lastWornDate': lastWorn, 'currentTimesWorn': timesWorn});
        
        console.log("-------------------AFTER -------------------");


        // const result = { clothingID: updatedItem.};
        // res.json(result);
        res.send(200);
    } catch (error) {
        res.status(400).send('Failed to post outfit');
    }
}