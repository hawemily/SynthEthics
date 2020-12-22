import { Request, Response } from "express";
import { Collections } from "../helper_components/db_collections";

export const getAllOutfits = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const uid = req.params.uid;
  
  const userRef = db.collection(Collections.Users).doc(uid);
  const outfitQuerySnapshot = await userRef.collection(Collections.Outfit).get();
  const outfits: any[] = [];

  outfitQuerySnapshot.forEach((doc) => {
    outfits.push({ id: doc.id, data: doc.data() });
  });

  res.status(200).json({ outfits: outfits });
};
