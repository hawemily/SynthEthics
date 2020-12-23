import { Request, Response } from "express";
import { clothingItem, ClothingType } from "../models/clothing_item_schema";
import { calculateCarma } from "./get_carma_value";
import {Collections} from "../helper_components/db_collections";

const max = 30;
const min = 5;
const c = Math.random() * (max - min) + min;

const calcTimesToBeWorn = (cf: number) => {
  console.log(`Calc Times To Be Worn: ${cf/c}`)
  return Math.ceil(cf / c);
};

export const postClothingItem = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  try {
    const {
      uid,
      name,
      brand,
      materials,
      clothingType,
      currLocation,
      origin,
      lastWorn,
      dateOfpurchase,
      dominantColor,
    } = req.body;

    const cf = await calculateCarma(
      materials,
      currLocation,
      origin,
      clothingType
    );


    console.log(`cf: ${cf}`);
    const timesToBeWorn = Math.round(calcTimesToBeWorn(cf));
    const cPerWear = Math.round(cf / timesToBeWorn);
    console.log(`cperewear: ${cPerWear}`);

    const apparel: clothingItem = {
      name: name,
      brand: brand,
      materials: materials,
      cF: cf,
      maxNoOfTimesToBeWorn: timesToBeWorn,
      carmaPerWear: cPerWear,
      currentTimesWorn: 0,
      clothingType: ClothingType[clothingType as keyof typeof ClothingType],
      lastWornDate: lastWorn,
      purchaseDate: dateOfpurchase,
      dominantColor: dominantColor,
    };

    const userRef = db.collection(Collections.Users).doc(uid);
    console.log(`apparel cf" ${apparel.cF}`)
    console.log(`apparel brand" ${apparel.brand}`)

    // const newClothingItem = await db.collection("closet").add(apparel);
    const newClothingItem = await userRef.collection(Collections.Closet).add(apparel);

    console.log(`apparel name" ${apparel.name}`)
    const result = { clothingID: newClothingItem.id};
    res.json(result);
  } catch (error) {
    res.status(400).send(`Apparel should contain name, brand, materials, type`);
  }
};
