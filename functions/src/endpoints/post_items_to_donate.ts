import {Request, Response} from "express";
import {Collections} from "../helper_components/db_collections";

export const markItemsAsDonate = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    
    try {
        const {ids} = req.body;

        // const userRef = db.collection(Collections.Users).doc(uid);

         const closetRef = db.collection(Collections.Closet);
    
         const donatedRef = db.collection(Collections.ToDonate);

         for (var i = 0; i < ids.length; i++) {
            const clothingItem = await closetRef.doc(ids[i]).get();
            donatedRef.doc(clothingItem.id).set(clothingItem.data()!);
            await closetRef.doc(ids[i]).delete();
         }
        res.send(200);

    } catch (e) {
        console.log(e);
        res.status(400).send(`Could not add donate items, malformed request`);
    }

}