import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const getAClothingItem = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  // TODO: uncomment the uids when user is implemented
  const uid = req.params.uid;
  const itemId = req.params.itemId;

  console.log("INSIDE GET A CLOTHING ITEM");
  console.log("printing uid then itemID");
  console.log(uid);
  console.log(itemId);

  try {
    const closetRef = await db.collection(Collections.Users).doc(uid).collection(Collections.Closet);
    const clothingItem = await closetRef.doc(itemId).get();

    console.log("printing clothingItem");
    console.log(clothingItem);
  
    
    const obj = { id : itemId, data: clothingItem.data() };

    console.log("printing obj");
    console.log(obj);
    
    res.status(200).json(obj);
  } catch (e) {
    console.log(e);
    res.status(400);
  }
 
};