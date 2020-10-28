import { Request, Response } from "express";
import { clothingItem, ClothingType } from "../models/clothing_item_schema";
import { calculateCarma } from "./get_carma_value";

const calcTimesToBeWorn = (cf: number) => {
  const c = Math.random() * 20;
  return cf % c;
};

export const postClothingItem = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  try {
    const {
      name,
      brand,
      materials,
      clothingType,
      currLocation,
      origin,
      lastWornDate,
      purchaseDate,
    } = req.body;

    const cf = await calculateCarma(materials, currLocation, origin);
    const timesToBeWorn = calcTimesToBeWorn(cf);
    const cPerWear = cf / timesToBeWorn;

    const apparel: clothingItem = {
      name: name,
      brand: brand,
      materials: materials,
      cF: cf,
      maxNoOfTimesToBeWorn: timesToBeWorn,
      carmaPerWear: cPerWear,
      currentTimesWorn: 0,
      clothingType: (<any>ClothingType)[clothingType],
      lastWornDate: lastWornDate,
      purchaseDate: purchaseDate,
    };

    const newClothingItem = await db.collection("closet").add(apparel);
    const result = { clothingID: newClothingItem.id };
    res.json(result);
  } catch (error) {
    res.status(400).send(`Apparel should contain name, brand, materials, type`);
  }
};
