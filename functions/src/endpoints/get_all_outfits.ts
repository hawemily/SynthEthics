import { Request, Response } from "express";

export const getAllOutfits = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const outfitQuerySnapshot = await db.collection("outfit").get();
  const outfits: any[] = [];

  outfitQuerySnapshot.forEach((doc) => {
    outfits.push({ id: doc.id, data: doc.data() });
  });

  res.status(200).json({ outfits: outfits });
};
