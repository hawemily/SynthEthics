import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";
import { ClothingType } from "../models/clothing_item_schema";

export const getAllClothes = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  // TODO: uncomment the uids when user is implemented
  const uid = req.params.uid;

  try {
    const closetRef = await db.collection(Collections.Users).doc(uid).collection(Collections.Closet);
    
    const clothingItems: any[] = [];
  
    for (const type of Object.values(ClothingType)) {
      
      const itemsByTypeSnapshot = await closetRef.where('clothingType', '==', type).get();
      
      const itemsJson: any[] = [];
      if (!itemsByTypeSnapshot.empty) {
        itemsByTypeSnapshot.forEach(doc => {
          itemsJson.push({id: doc.id, data: doc.data()});
        }); 
      }
  
      clothingItems.push({clothingType : type, clothingItems: itemsJson});
      clothingItems.forEach((e) => {
        console.log(e);
      });
    }
  
    // clothingQuerySnapshot.forEach((doc) => {
    //   clothingItems.push({ id: doc.id, data: doc.data() });
    // });
    const obj = {clothingTypes: clothingItems};
    res.status(200).json(obj);
  } catch (e) {
    console.log(e);
    res.status(400);
  }
 
};
