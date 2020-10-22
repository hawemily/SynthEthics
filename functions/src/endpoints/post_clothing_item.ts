import { Request, Response } from "express";
import { clothingItem } from "../models/clothing_item_schema";
import { calculateCarma } from "./calculate_carma";

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
    } = req.body;

    const cf = calculateCarma(materials, currLocation, origin);
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
      clothingType: clothingType,
    };

    const newClothingItem = await db.collection("closet").add(apparel);
    res.status(201).send(`Created new clothing item: ${newClothingItem.id}`);
  } catch (error) {
    res.status(400).send(`Apparel should contain name, brand, materials, type`);
  }
};
