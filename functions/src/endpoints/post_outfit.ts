import {
    Request,
    Response
} from "express";
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
            id,
            name,
            clothing
        } = req.body;

        const outfit: Outfit = {
            name: name,
            clothing: clothing
        }

        const outfitRef = db.collection('outfits').doc(id);

        outfitRef.get()
            .then(async (docSnapshot) => {
                if (docSnapshot.exists) {
                    outfitRef.update(outfit);
                } else {
                    const newOutfit = await db.collection('outfits').add(outfit);
                    res.json({
                        outfitID: newOutfit.id
                    });
                }
            });
    } catch (error) {
        res.status(400).send('Failed to post outfit');
    }
}