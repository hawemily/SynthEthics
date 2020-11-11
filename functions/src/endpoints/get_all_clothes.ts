import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";
import { ClothingType } from "../models/clothing_item_schema";

export const getAllClothes = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  // TODO: uncomment the uids when user is implemented
  // const {uid} = req;
  
  const closetRef = await db.collection(Collections.Closet);
  // const clothingUserQuerySnapshot = await db.collection(uid).get();
  const clothingItems: any[] = [];

  for (const type in Object.values(ClothingType)) {
    const typeAsStr = type as keyof typeof ClothingType;
    const itemsByTypeSnapshot = await closetRef.where('clothingType', '==', ClothingType[typeAsStr]).get();
    
    const itemsJson: any[] = [];
    if (!itemsByTypeSnapshot.empty) {
      itemsByTypeSnapshot.forEach(doc => {
        itemsJson.push({id: doc.id, data: doc.data()});
      }); 
    }

    clothingItems.push({typeAsStr : itemsJson});
  }

  // clothingQuerySnapshot.forEach((doc) => {
  //   clothingItems.push({ id: doc.id, data: doc.data() });
  // });

  res.status(200).json({ clothingItems: clothingItems });
};
