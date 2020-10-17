import {Request, Response} from 'express';

export const getAllClothes = async (req: Request, res:Response, db: FirebaseFirestore.Firestore) => {

    const clothingQuerySnapshot = await db.collection("closet").get();
    const clothingItems: any[] = [];

    clothingQuerySnapshot.forEach(doc => {
        clothingItems.push({id: doc.id, data: doc.data()});
    });

    res.status(200).json(clothingItems);
}
