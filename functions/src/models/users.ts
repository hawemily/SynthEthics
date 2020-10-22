import { ClothingType, clothingItem } from "./clothing_item_schema";

export interface User {
  userId: string;
  closet: { [key in ClothingType]: clothingItem[] };
  carmaPoints: number;
}
