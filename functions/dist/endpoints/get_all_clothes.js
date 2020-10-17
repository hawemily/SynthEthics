"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAllClothes = void 0;
exports.getAllClothes = async (req, res, db) => {
    const clothingQuerySnapshot = await db.collection("closet").get();
    const clothingItems = [];
    clothingQuerySnapshot.forEach(doc => {
        clothingItems.push({ id: doc.id, data: doc.data() });
    });
    res.status(200).json(clothingItems);
};
//# sourceMappingURL=get_all_clothes.js.map