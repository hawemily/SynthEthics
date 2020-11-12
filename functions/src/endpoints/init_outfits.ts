import { Outfit } from "../models/outfit_schema";
import {ClothingType, clothingItem} from "../models/clothing_item_schema"
import { Response } from "express";

export const initOutfits = async (
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const outfitRef = db.collection("outfits");
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

  const o1: Outfit = {name: "Outfit 1", clothing: [ap1, ap2]};

  const awaitap1 = await outfitRef.add(o1);
  console.log(`id: ${awaitap1.id}`);
  res.json({
    o1: awaitap1.id,
  });
};
