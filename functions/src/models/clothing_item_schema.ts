type ClothingType = "top" | "bottom" | "dress" | "hat" | "outer" | "skirt";

export interface clothingItem {
  name: string;
  brand: string;
  placeOfOrigin?: string;
  materials?: string[];
  cF: number;
  maxNoOfTimesToBeWorn: number;
  carmaPerWear: number;
  currentTimesWorn: number;
  clothingType: ClothingType;
}
