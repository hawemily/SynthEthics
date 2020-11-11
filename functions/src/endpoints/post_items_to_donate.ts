import {Request, Response} from "express";
import {Collections} from "../helper_components/db_collections";

export const markItemsAsDonate = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    
    try {
        const {uid, items} = req.body;

        const userRef = db.collection(Collections.Users).doc(uid);

        const closetRef = userRef.collection(Collections.Closet);
    
        const donatedRef = userRef.collection(Collections.ToDonate);

        for(var item in items) {
        //TODO: change front end implementation
            const clothingItem = await closetRef.doc(item).get();
            donatedRef.doc(clothingItem.id).set(clothingItem);
            await closetRef.doc(item).delete();

        }
        res.send(200);

    } catch (e) {
        console.log(e);
        res.status(400).send(`Could not add donate items, malformed request`);
    }

}