import { Outfit } from "../models/outfit_schema";
import {ClothingType, clothingItem} from "../models/clothing_item_schema"
import { Response } from "express";

export const initOutfits = async (
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const outfitRef = db.collection("outfit");
 
  const ap1: clothingItem = {
    name: "black crop",
    materials: ["cotton", "polyester"],
    cF: 1000,
    maxNoOfTimesToBeWorn: 10,
    clothingType: ClothingType["Tops"],
    lastWornDate: "25/03/2020",
  };

  const jsonObject1 = {id: "4", data: ap1};

  const ap2: clothingItem = {
    name: "black pants",
    materials: ["cotton", "polyester"],
    cF: 1500,
    maxNoOfTimesToBeWorn: 13,
    clothingType: ClothingType["Bottoms"],
    lastWornDate: "25/06/2020",
  };

  const jsonObject2 = {id: "6", data: ap2};

  const o1: Outfit = {name: "Outfit 1", clothing: [jsonObject1, jsonObject2]};
  const o2: Outfit = {name: "Outfit 2", clothing: [jsonObject1, jsonObject2]};
  const o3: Outfit = {name: "Outfit 3", clothing: [jsonObject1, jsonObject2]};


  const awaitap1 = await outfitRef.add(o1);
  const awaitap2 = await outfitRef.add(o2);
  const awaitap3 = await outfitRef.add(o3);

  console.log(`id: ${awaitap1.id}`);
  console.log(`id: ${awaitap2.id}`);
  console.log(`id: ${awaitap3.id}`);

  res.json({
    o1: awaitap1.id,
    o2: awaitap2.id,
    o3: awaitap3.id,
  });
};
