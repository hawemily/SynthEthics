"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postClothingItem = void 0;
const clothing_item_schema_1 = require("../models/clothing_item_schema");
const get_carma_value_1 = require("./get_carma_value");
const max = 30;
const min = 5;
const c = Math.random() * (max - min) + min;
const calcTimesToBeWorn = (cf) => {
    return Math.ceil(cf / c);
};
exports.postClothingItem = async (req, res, db) => {
    try {
        const { name, brand, materials, clothingType, currLocation, origin, lastWornDate, purchaseDate, } = req.body;
        const cf = await get_carma_value_1.calculateCarma(materials, currLocation, origin, clothingType);
        const timesToBeWorn = Math.round(calcTimesToBeWorn(cf));
        const cPerWear = Math.round(cf / timesToBeWorn);
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