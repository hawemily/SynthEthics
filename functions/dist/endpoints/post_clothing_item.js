"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postClothingItem = void 0;
const calculate_carma_1 = require("./calculate_carma");
const calcTimesToBeWorn = (cf) => {
    const c = Math.random() * 20;
    return cf % c;
};
exports.postClothingItem = async (req, res, db) => {
    try {
        const { name, brand, materials, clothingType, currLocation, origin, } = req.body;
        const cf = calculate_carma_1.calculateCarma(materials, currLocation, origin);
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
            clothingType: clothingType,
        };
        const newClothingItem = await db.collection("closet").add(apparel);
        res.status(201).send(`Created new clothing item: ${newClothingItem.id}`);
    }
    catch (error) {
        res.status(400).send(`Apparel should contain name, brand, materials, type`);
    }
};
//# sourceMappingURL=post_clothing_item.js.map