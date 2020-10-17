"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = void 0;
const get_all_clothes_1 = require("./endpoints/get_all_clothes");
const post_clothing_item_1 = require("./endpoints/post_clothing_item");
exports.routes = (app, db) => {
    // GET /clothes
    app.get('/closet/allClothes', (req, res) => {
        get_all_clothes_1.getAllClothes(req, res, db);
        return;
    });
    app.get('/hello', (req, res) => {
        res.send(200);
        return;
    });
    app.post('/posting/double', (req, res) => {
        res.status(200).send("checking if this works");
        return;
    });
    app.post('/closet/addItem', (req, res) => {
        post_clothing_item_1.postClothingItem(req, res, db);
        //        res.status(200).send("checking if this api works");
        return;
    });
};
//# sourceMappingURL=routes.js.map