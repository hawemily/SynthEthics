import {Request, Response} from "express";
import {Collections} from "../helper_components/db_collections";

export const unmarkItemsAccidentallyDonated = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    
    try {
        const {uid, ids} = req.body;

         const userRef = db.collection(Collections.Users).doc(uid);

         const toDonateRef = userRef.collection(Collections.ToDonate);

         for (var i = 0; i < ids.length; i++) {
            const donatedItemRef = toDonateRef.doc(ids[i]);
            await donatedItemRef.update({donated: false});
         }
        res.send(200);

    } catch (e) {
        console.log(e);
        res.status(400).send(`Could not remove items from clothing donated, malformed request`);
    }

}

