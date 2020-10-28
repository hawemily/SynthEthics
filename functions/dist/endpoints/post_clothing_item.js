"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postClothingItem = void 0;
const clothing_item_schema_1 = require("../models/clothing_item_schema");
const get_carma_value_1 = require("./get_carma_value");
const calcTimesToBeWorn = (cf) => {
    const c = Math.random() * 20;
    return cf % c;
};
exports.postClothingItem = async (req, res, db) => {
    try {
        const { name, brand, materials, clothingType, currLocation, origin, lastWornDate, purchaseDate, } = req.body;
        const cf = await get_carma_value_1.calculateCarma(materials, currLocation, origin);
        const timesToBeWorn = calcTimesToBeWorn(cf);
        const cPerWear = cf / timesToBeWorn;
        const apparel = {
            name: name,
            brand: brand,
            materials: materials,
            cF: cf,
            maxNoOfTimesToBeWorn: timesToBeWorn,
            carmaPerWear: cPerWear,
            currentTimesWorn: 0,
            clothingType: clothing_item_schema_1.ClothingType[clothingType],
            lastWornDate: lastWornDate,
            purchaseDate: purchaseDate,
        };
        const newClothingItem = await db.collection("closet").add(apparel);
        const result = { clothingID: newClothingItem.id };
        res.json(result);
    }
    catch (error) {
        res.status(400).send(`Apparel should contain name, brand, materials, type`);
    }
};
//# sourceMappingURL=post_clothing_item.js.map