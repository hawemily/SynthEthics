export enum ClothingType {
  Tops = "Tops",
  Bottoms = "Bottoms",
  Dresses = "Dresses",
  Skirts = "Skirts",
  Outerwear = "Outerwear",
  Headgear = "Headgear",
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
  dominantColor?: number;
}
