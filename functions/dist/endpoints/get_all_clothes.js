"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.getAllClothes = void 0;
const db_collections_1 = require("../helper_components/db_collections");
const clothing_item_schema_1 = require("../models/clothing_item_schema");
exports.getAllClothes = async (req, res, db) => {
    // TODO: uncomment the uids when user is implemented
    // const {uid} = req;
    try {
        const closetRef = await db.collection(db_collections_1.Collections.Closet);
        // const clothingUserQuerySnapshot = await db.collection(uid).get();
        const clothingItems = [];
        for (const type of Object.values(clothing_item_schema_1.ClothingType)) {
            const itemsByTypeSnapshot = await closetRef.where('clothingType', '==', type).get();
            const itemsJson = [];
            if (!itemsByTypeSnapshot.empty) {
                itemsByTypeSnapshot.forEach(doc => {
                    itemsJson.push({ id: doc.id, data: doc.data() });
                });
            }
            clothingItems.push({ clothingType: type, clothingItems: itemsJson });
            clothingItems.forEach((e) => {
                console.log(e);
            });
        }
        // clothingQuerySnapshot.forEach((doc) => {
        //   clothingItems.push({ id: doc.id, data: doc.data() });
        // });
        const obj = { clothingTypes: clothingItems };
        res.status(200).json(obj);
    }
    catch (e) {
        console.log(e);
        res.status(400);
    }
};
//# sourceMappingURL=get_all_clothes.js.map