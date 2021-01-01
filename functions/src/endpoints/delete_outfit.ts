import {
    Request,
    Response
} from "express";
import { Collections } from "../helper_components/db_collections";


export const deleteOutfit = async (
    req: Request,
    res: Response,
    db: FirebaseFirestore.Firestore
) => {
    try {
        const {
            uid,
            oid,
        } = req.body;
        
        const userRef = db.collection(Collections.Users).doc(uid);
        const outfitRef = await userRef.collection(Collections.Outfit).doc(oid);
        console.log("Outfit reference");
        console.log(outfitRef);
        outfitRef.delete();
        console.log("Delete");

        // const result = { clothingIDs: outfitRef.id};
        // res.json(result);
        res.send(200);
    } catch (error) {
        res.status(400).send('Failed to delete outfit');
    }
}