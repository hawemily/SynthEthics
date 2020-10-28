"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAllClothingTypes = void 0;
const clothing_item_schema_1 = require("../models/clothing_item_schema");
exports.getAllClothingTypes = (res) => {
    const types = [];
    Object.keys(clothing_item_schema_1.ClothingType).forEach((key) => {
        types.push(key);
    });
    res.sendStatus(200).json({ clothingTypes: types });
};
//# sourceMappingURL=get_all_types.js.map