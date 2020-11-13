import { clothingItem, ClothingType } from "../models/clothing_item_schema";
import { Response } from "express";

export const initCloset = async (
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const closetRef = db.collection("closet");
  const ap1: clothingItem = {
    name: "black crop",
    materials: ["cotton", "polyester"],
    cF: 1000,
    maxNoOfTimesToBeWorn: 10,
    clothingType: ClothingType["Tops"],
    lastWornDate: "25/03/2020",
  };
  const ap2: clothingItem = {
    name: "black pants",
    materials: ["cotton", "polyester"],
    cF: 1500,
    maxNoOfTimesToBeWorn: 13,
    clothingType: ClothingType["Bottoms"],
    lastWornDate: "25/06/2020",
  };

  const awaitap1 = await closetRef.add(ap1);
  const awaitap2 = await closetRef.add(ap2);
  console.log(`id: ${awaitap1.id}`);
  console.log(`id: ${awaitap2.id}`);
  res.json({
    ap1: awaitap1.id,
    ap2: awaitap2.id,
  });
};
