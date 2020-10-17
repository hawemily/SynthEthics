import {Request, Response} from 'express';
import {clothingItem} from '../models/clothing_item_schema';

export const postClothingItem = async (req:Request, res:Response, db: FirebaseFirestore.Firestore) => {
    try {
        const { name, brand, materials, clothingType } = req.body;
        const apparel : clothingItem = {
            name: name,
            brand: brand,
            materials: materials,
            clothingType: clothingType
        }

        const newClothingItem = await db.collection("closet").add(apparel);
        res.status(201).send(`Created new clothing item: ${newClothingItem.id}`);
    } catch(error) {
        res.status(400).send(`Apparel should contain name, brand, materials, type`);
    }

};