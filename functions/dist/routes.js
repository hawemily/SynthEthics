"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = void 0;
const get_all_clothes_1 = require("./endpoints/get_all_clothes");
const post_clothing_item_1 = require("./endpoints/post_clothing_item");
const get_carma_value_1 = require("./endpoints/get_carma_value");
const init_data_1 = require("./endpoints/init_data");
const get_all_types_1 = require("./endpoints/get_all_types");
const post_outfit_1 = require("./endpoints/post_outfit");
const get_all_outfits_1 = require("./endpoints/get_all_outfits");
exports.routes = (app, db) => {
    // GET /clothes
    app.get("/closet/allClothes", (req, res) => {
        get_all_clothes_1.getAllClothes(req, res, db);
        return;
    });
    app.post("/carma", (req, res) => {
        get_carma_value_1.getCarmaValue(req, res);
        return;
    });
    app.post("/closet/addItem", (req, res) => {
        post_clothing_item_1.postClothingItem(req, res, db);
        return;
    });
    app.get("/initData", (req, res) => {
        init_data_1.initData(res, db);
        return;
    });
    app.get("/getAllClothingTypes", (req, res) => {
        get_all_types_1.getAllClothingTypes(res);
        return;
    });
    app.get("/outfits", (req, res) => {
        get_all_outfits_1.getAllOutfits(req, res, db);
        return;
    });
    app.post("/outfits/add", (req, res) => {
        post_outfit_1.postOutfit(req, res, db);
        return;
    });
    app.get("/dummy", (req, res) => {
        console.log("called dummy");
        res.status(200).json({ data: "dsfdf" });
        return;
    });
};
//# sourceMappingURL=routes.js.map