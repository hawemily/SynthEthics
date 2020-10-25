"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = void 0;
const get_all_clothes_1 = require("./endpoints/get_all_clothes");
const post_clothing_item_1 = require("./endpoints/post_clothing_item");
const get_carma_calc_1 = require("./endpoints/get_carma_calc");
exports.routes = (app, db) => {
    // GET /clothes
    app.get("/closet/allClothes", (req, res) => {
        get_all_clothes_1.getAllClothes(req, res, db);
        return;
    });
    app.post("/carma", (req, res) => {
        get_carma_calc_1.getCarmaValue(req, res);
        return;
    });
    app.post("/closet/addItem", (req, res) => {
        post_clothing_item_1.postClothingItem(req, res, db);
        return;
    });
    app.get("/dummy", (req, res) => {
        console.log('called dummy');
        res.status(200).json({ data: 'dsfdf' });
        return;
    });
};
//# sourceMappingURL=routes.js.map