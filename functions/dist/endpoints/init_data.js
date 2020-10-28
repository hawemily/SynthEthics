"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.initData = void 0;
const clothing_item_schema_1 = require("../models/clothing_item_schema");
exports.initData = async (res, db) => {
    const closetRef = db.collection("closet");
    const ap1 = {
        name: "black crop",
        materials: ["cotton", "polyester"],
        cF: 1000,
        maxNoOfTimesToBeWorn: 10,
        clothingType: clothing_item_schema_1.ClothingType["tops"],
        lastWornDate: "25/03/2020",
    };
    const ap2 = {
        name: "black pants",
        materials: ["cotton", "polyester"],
        cF: 1500,
        maxNoOfTimesToBeWorn: 13,
        clothingType: clothing_item_schema_1.ClothingType["bottoms"],
        lastWornDate: "25/06/2020",
    };
    const awaitap1 = await closetRef.add(ap1);
    const awaitap2 = await closetRef.add(ap2);
    console.log(`id: ${awaitap1.id}`);
    console.log(`id: ${awaitap2.id}`);
    res.json({
        ap1: awaitap1.id,
        ap2: awaitap2.id,
    });
};
//# sourceMappingURL=init_data.js.map