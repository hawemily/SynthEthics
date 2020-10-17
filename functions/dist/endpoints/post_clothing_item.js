"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postClothingItem = void 0;
exports.postClothingItem = async (req, res, db) => {
    try {
        const { name, brand, materials, clothingType } = req.body;
        const apparel = {
            name: name,
            brand: brand,
            materials: materials,
            clothingType: clothingType
        };
        const newClothingItem = await db.collection("closet").add(apparel);
        res.status(201).send(`Created new clothing item: ${newClothingItem.id}`);
    }
    catch (error) {
        res.status(400).send(`Apparel should contain name, brand, materials, type`);
    }
};
//# sourceMappingURL=post_clothing_item.js.map