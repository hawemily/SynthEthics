"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.routes = void 0;
const post_new_user_1 = require("./endpoints/post_new_user");
const post_add_carma_points_1 = require("./endpoints/post_add_carma_points");
const get_all_clothes_1 = require("./endpoints/get_all_clothes");
const get_carma_value_1 = require("./endpoints/get_carma_value");
const get_all_types_1 = require("./endpoints/get_all_types");
const get_all_donated_items_1 = require("./endpoints/get_all_donated_items");
const get_all_outfits_1 = require("./endpoints/get_all_outfits");
const get_achievements_1 = require("./endpoints/get_achievements");
const get_carma_records_1 = require("./endpoints/get_carma_records");
const get_user_record_1 = require("./endpoints/get_user_record");
const post_clothing_item_1 = require("./endpoints/post_clothing_item");
const post_outfit_1 = require("./endpoints/post_outfit");
const post_items_to_donate_1 = require("./endpoints/post_items_to_donate");
const init_closet_1 = require("./endpoints/init_closet");
const init_users_1 = require("./endpoints/init_users");
const init_outfits_1 = require("./endpoints/init_outfits");
const init_achievement_types_1 = require("./endpoints/init_achievement_types");
const post_items_not_to_donate_1 = require("./endpoints/post_items_not_to_donate");
const update_clothing_item_1 = require("./endpoints/update_clothing_item");
const delete_user_1 = require("./endpoints/delete_user");
const update_outfit_1 = require("./endpoints/update_outfit");
const get_a_clothing_item_1 = require("./endpoints/get_a_clothing_item");
const get_items_sent_for_donation_1 = require("./endpoints/get_items_sent_for_donation");
const post_items_sent_for_donation_1 = require("./endpoints/post_items_sent_for_donation");
const post_items_accidentally_marked_as_donated_1 = require("./endpoints/post_items_accidentally_marked_as_donated");
exports.routes = (app, db) => {
    // ===========================================================================
    //      *** GET REQUESTS
    // ===========================================================================
    app.get("/initCloset", (req, res) => {
        init_closet_1.initCloset(res, db);
        return;
    });
    app.get("/initOutfits", (req, res) => {
        init_outfits_1.initOutfits(res, db);
        return;
    });
    app.get("/initAchievements", (req, res) => {
        init_achievement_types_1.initAchievementTypes(res, db);
        return;
    });
    app.get("/getCarmaRecords/:uid", (req, res) => {
        get_carma_records_1.getCarmaRecords(req, res, db);
        return;
    });
    app.get("/getUserRecords/:uid", (req, res) => {
        get_user_record_1.getUserRecords(req, res, db);
        return;
    });
    app.get("/getAchievements/:uid", (req, res) => {
        get_achievements_1.getAchievements(req, res, db);
        return;
    });
    app.get("/closet/allClothes/:uid", (req, res) => {
        get_all_clothes_1.getAllClothes(req, res, db);
        return;
    });
    app.get("/closet/allClothes/:itemId/:uid", (req, res) => {
        get_a_clothing_item_1.getAClothingItem(req, res, db);
        return;
    });
    app.get("/getAllClothingTypes", (req, res) => {
        get_all_types_1.getAllClothingTypes(res);
        return;
    });
    app.get("/closet/allDonatedItems/:uid", (req, res) => {
        get_all_donated_items_1.getAllDonatedItems(req, res, db);
        return;
    });
    app.get("/outfits/:uid", (req, res) => {
        get_all_outfits_1.getAllOutfits(req, res, db);
        return;
    });
    app.get("/deleteUser/:uid", (req, res) => {
        delete_user_1.deleteUser(req, res, db);
        return;
    });
    app.get("/dummy", (req, res) => {
        console.log("called dummy");
        res.status(200).json({ data: "dsfdf" });
        return;
    });
    app.get("/closet/allItemsSentToDonation/:uid", (req, res) => {
        get_items_sent_for_donation_1.getItemsSentForDonation(req, res, db);
        return;
    });
    app.get("/closet/allDonatedItems/:uid", (req, res) => {
        get_all_donated_items_1.getAllDonatedItems(req, res, db);
        return;
    });
    // ===========================================================================
    //      *** POST REQUESTS
    // ===========================================================================
    app.post("/initUsers", (req, res) => {
        init_users_1.initUsers(req, res, db);
        return;
    });
    app.post("/carma", (req, res) => {
        get_carma_value_1.getCarmaValue(req, res);
        return;
    });
    app.post("/carma/add", (req, res) => {
        post_add_carma_points_1.addCarmaPoints(req, res, db);
        return;
    });
    app.post("/closet/addItem", (req, res) => {
        post_clothing_item_1.postClothingItem(req, res, db);
        return;
    });
    app.post("/addUser", (req, res) => {
        post_new_user_1.addNewUser(req, res, db);
        return;
    });
    app.post("/markForDonation", (req, res) => {
        post_items_to_donate_1.markItemsAsDonate(req, res, db);
        return;
    });
    app.post("/unmarkForDonation", (req, res) => {
        post_items_not_to_donate_1.unmarkItemsAsDonate(req, res, db);
        return;
    });
    app.post("/postOutfit", (req, res) => {
        post_outfit_1.postOutfit(req, res, db);
        return;
    });
    app.post("/updateOutfit", (req, res) => {
        update_outfit_1.updateOutfit(req, res, db);
        return;
    });
    //TODO: post outfit
    app.post("/markDonated", (req, res) => {
        post_items_sent_for_donation_1.sendItemsForDonation(req, res, db);
        return;
    });
    app.post("/markUndoDonated", (req, res) => {
        post_items_accidentally_marked_as_donated_1.unmarkItemsAccidentallyDonated(req, res, db);
        return;
    });
    app.post("/closet/updateItem", (req, res) => {
        update_clothing_item_1.updateClothingItem(req, res, db);
        return;
    });
};
//# sourceMappingURL=routes.js.map