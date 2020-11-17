import {Request, Response} from "express";
import {Collections} from "../helper_components/db_collections";

export const unmarkItemsAsDonate = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    
    try {
        const {ids} = req.body;

        // const userRef = db.collection(Collections.Users).doc(uid);

         const closetRef = db.collection(Collections.Closet);
         const toDonateRef = db.collection(Collections.ToDonate);

         for (var i = 0; i < ids.length; i++) {
            const toDonateItem = await toDonateRef.doc(ids[i]).get();
            closetRef.doc(toDonateItem.id).set(toDonateItem.data()!);
            await toDonateRef.doc(ids[i]).delete();
         }
        res.send(200);

    } catch (e) {
        console.log(e);
        res.status(400).send(`Could not remove items from clothing to be donated, malformed request`);
    }

}