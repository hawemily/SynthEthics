import { clothingItem } from "./clothing_item_schema";

export interface Outfit {
    name?: string;
    clothing: clothingItem[];
}
  