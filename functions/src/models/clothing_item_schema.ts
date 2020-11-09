export enum ClothingType {
  "Tops",
  "Bottoms",
  "Dresses",
  "Skirts",
  "Outerwear",
  "Headgear",
}

export interface clothingItem {
  name?: string;
  brand?: string;
  placeOfOrigin?: string;
  materials?: string[];
  cF?: number;
  maxNoOfTimesToBeWorn?: number;
  carmaPerWear?: number;
  currentTimesWorn?: number;
  clothingType?: ClothingType;
  lastWornDate?: string;
  purchaseDate?: string;
}
