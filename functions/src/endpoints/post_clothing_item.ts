import { Request, Response } from "express";
import { clothingItem, ClothingType } from "../models/clothing_item_schema";
import { calculateCarma } from "./get_carma_value";

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
      // userId,
      name,
      Brand,
      Materials,
      clothingType,
      currLocation,
      origin,
      lastWorn,
      dateOfpurchase,
    } = req.body;
    
    console.log(" in add item!")
    const cf = await calculateCarma(
      Materials,
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
      brand: Brand,
      materials: Materials,
      cF: cf,
      maxNoOfTimesToBeWorn: timesToBeWorn,
      carmaPerWear: cPerWear,
      currentTimesWorn: 0,
      clothingType: ClothingType[clothingType as keyof typeof ClothingType],
      lastWornDate: lastWorn,
      purchaseDate: dateOfpurchase,
    };

    // const closetRef = db.collection("closet");
    console.log(`apparel cf" ${apparel.cF}`)
    console.log(`apparel brand" ${apparel.brand}`)
    const newClothingItem = await db.collection("closet").add(apparel);
    // const newClothingItem = await db.collection(uid).add(apparel); 
    console.log(`apparel name" ${apparel.name}`)
    const result = { clothingID: newClothingItem.id};
    res.json(result);
  } catch (error) {
    res.status(400).send(`Apparel should contain name, brand, materials, type`);
  }
};
