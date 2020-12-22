import {Request, Response} from "express";
import {Collections} from "../helper_components/db_collections";

export const unmarkItemsAccidentallyDonated = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    
    try {
        const {uid, ids} = req.body;

         const userRef = db.collection(Collections.Users).doc(uid);

         const toDonateRef = userRef.collection(Collections.ToDonate);
         const donatedRef = userRef.collection(Collections.Donated);

         for (var i = 0; i < ids.length; i++) {
            const donatedItem = await donatedRef.doc(ids[i]).get();
            toDonateRef.doc(donatedItem.id).set(donatedItem.data()!);
            await donatedRef.doc(ids[i]).delete();
         }
        res.send(200);

    } catch (e) {
        console.log(e);
        res.status(400).send(`Could not remove items from clothing donated, malformed request`);
    }

}