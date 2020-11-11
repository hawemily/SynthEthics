import { Response } from "express";
import { ClothingType } from "../models/clothing_item_schema";

export const getAllClothingTypes = (res: Response) => {
  const types: string[] = [];
  Object.keys(ClothingType).forEach((key) => {
    types.push(key);
  });

  res.send(200).json({ clothingTypes: types });
};
