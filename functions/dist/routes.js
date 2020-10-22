"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = void 0;
const get_all_clothes_1 = require("./endpoints/get_all_clothes");
const post_clothing_item_1 = require("./endpoints/post_clothing_item");
const get_carma_calc_1 = require("./endpoints/get_carma_calc");
const cf_calculations_1 = require("./helper_components/cf_calculations");
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
    app.get("/calc", (req, res) => {
        cf_calculations_1.initCSVs().then((sicc) => {
            console.log(sicc);
            const code = cf_calculations_1.findCountryCode("China");
            res.sendStatus(200).send(code);
        });
    });
    app.post("/closet/addItem", (req, res) => {
        post_clothing_item_1.postClothingItem(req, res, db);
        return;
    });
};
//# sourceMappingURL=routes.js.map