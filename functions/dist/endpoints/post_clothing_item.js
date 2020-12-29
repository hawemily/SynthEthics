"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.postClothingItem = void 0;
const clothing_item_schema_1 = require("../models/clothing_item_schema");
const get_carma_value_1 = require("./get_carma_value");
const db_collections_1 = require("../helper_components/db_collections");
const max = 30;
const min = 5;
const c = Math.random() * (max - min) + min;
const calcTimesToBeWorn = (cf) => {
    console.log(`Calc Times To Be Worn: ${cf / c}`);
    return Math.ceil(cf / c);
};
exports.postClothingItem = async (req, res, db) => {
    try {
        const { uid, name, brand, materials, clothingType, currLocation, origin, lastWorn, dateOfpurchase, dominantColor, } = req.body;
        const cf = await get_carma_value_1.calculateCarma(materials, currLocation, origin, clothingType);
        console.log(`cf: ${cf}`);
        const timesToBeWorn = Math.round(calcTimesToBeWorn(cf));
        const cPerWear = Math.round(cf / timesToBeWorn);
        console.log(`cperewear: ${cPerWear}`);
        const apparel = {
            name: name,
            brand: brand,
            materials: materials,
            cF: cf,
            maxNoOfTimesToBeWorn: timesToBeWorn,
            carmaPerWear: cPerWear,
            currentTimesWorn: 0,
            clothingType: clothing_item_schema_1.ClothingType[clothingType],
            lastWornDate: lastWorn,
            purchaseDate: dateOfpurchase,
            dominantColor: dominantColor,
        };
        const userRef = db.collection(db_collections_1.Collections.Users).doc(uid);
        console.log(`apparel cf" ${apparel.cF}`);
        console.log(`apparel brand" ${apparel.brand}`);
        // const newClothingItem = await db.collection("closet").add(apparel);
        const newClothingItem = await userRef.collection(db_collections_1.Collections.Closet).add(apparel);
        console.log(`apparel name" ${apparel.name}`);
        const result = { clothingID: newClothingItem.id };
        res.json(result);
    }
    catch (error) {
        res.status(400).send(`Apparel should contain name, brand, materials, type`);
    }
};
//# sourceMappingURL=post_clothing_item.js.map