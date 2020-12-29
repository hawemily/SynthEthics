import {Request, Response} from "express";
import { Collections } from "../helper_components/db_collections";

export const deleteUser = async (req: Request, res: Response, db: FirebaseFirestore.Firestore) => {
    const uid = req.params.uid;

    const userRef = db.collection(Collections.Users).doc(uid);
    const subCollections: String[] = [Collections.Closet, Collections.ToDonate, Collections.Donated]

    subCollections.forEach((col) => {
        const path = "/" + Collections.Users + "/" + uid + col;
        deleteSubCollection(db, path, 100);
    })

    await userRef.delete();
    res.status(200);
}

async function deleteSubCollection(db: FirebaseFirestore.Firestore, collectionPath: any, batchSize: number) {
    const collectionRef = db.collection(collectionPath);
    const query = collectionRef.orderBy('__name__').limit(batchSize);

    return new Promise((resolve, reject) => {
        deleteQueryBatch(db, query, resolve).catch(reject);
    })
}

async function deleteQueryBatch(db: FirebaseFirestore.Firestore, query: any, resolve: any) {
    const snapshot = await query.get();
    
    const batchSize = snapshot.size;
    if(batchSize == 0) {
        resolve();
        return;
    }

    const batch = db.batch();
    snapshot.docs.forEach((doc: any) => {
        batch.delete(doc.ref);
    });
    await batch.commit();

    process.nextTick(() => {
        deleteQueryBatch(db, query, resolve);
    });
}