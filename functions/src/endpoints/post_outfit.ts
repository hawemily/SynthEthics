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
            clothing: ids
        }
        
        const userRef = db.collection(Collections.Users).doc(uid);

        const outfitRef = await userRef.collection(Collections.Outfit).add(outfit);
        const result = { clothingIDs: outfitRef.id};
        res.json(result);
        res.send(200);
    } catch (error) {
        res.status(400).send('Failed to post outfit');
    }
}