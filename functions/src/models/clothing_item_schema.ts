type ClothingType = "top" | "bottom" | "dress" | "hat" | "outer"| "skirt";

export interface clothingItem {
    name: string,
    brand: string,
    materials?: string[],
    clothingType: ClothingType
}
