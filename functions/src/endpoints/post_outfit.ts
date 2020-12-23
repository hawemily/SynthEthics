import {
    Request,
    Response
} from "express";
import { Collections } from "../helper_components/db_collections";
import {
    Outfit
} from "../models/outfit_schema";


export const postOutfit = async (
    req: Request,
    res: Response,
    db: FirebaseFirestore.Firestore
) => {
    try {
        const {
            uid,
            name,
            ids
        } = req.body;

        const outfit: Outfit = {
            name: name,
            clothing: []
        }
        
        const userRef = db.collection(Collections.Users).doc(uid);
        const closetRef = userRef.collection(Collections.Closet);

        for (var i = 0; i < ids.length; i++) {
            const clothingItem = await closetRef.doc(ids[i]).get();
            const jsonObj = {id: ids[i], data: clothingItem.data()};
            outfit.clothing.push(jsonObj);
         }


        const outfitRef = await userRef.collection(Collections.Outfit).add(outfit);
        const result = { clothingID: outfitRef.id};
        res.json(result);
        res.send(200);
    } catch (error) {
        res.status(400).send('Failed to post outfit');
    }
}