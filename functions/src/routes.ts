import { Request, Response, Router } from "express";

import { addNewUser } from "./endpoints/post_new_user";
import { addCarmaPoints } from "./endpoints/post_add_carma_points";

import { getAllClothes } from "./endpoints/get_all_clothes";
import { getCarmaValue } from "./endpoints/get_carma_value";
import { getAllClothingTypes } from "./endpoints/get_all_types";
import { getAllDonatedItems } from "./endpoints/get_all_donated_items";
import { getAllOutfits } from "./endpoints/get_all_outfits";
import { getAchievements } from "./endpoints/get_achievements";
import { getCarmaRecords } from "./endpoints/get_carma_records";
import { getUserRecords } from "./endpoints/get_user_record";

import { postClothingItem } from "./endpoints/post_clothing_item";
import { postOutfit } from "./endpoints/post_outfit";

import { markItemsAsDonate } from "./endpoints/post_items_to_donate";

import { initCloset } from "./endpoints/init_closet";
import { initUsers } from "./endpoints/init_users";
import { initOutfits } from "./endpoints/init_outfits";
import { initAchievementTypes } from "./endpoints/init_achievement_types";
import { unmarkItemsAsDonate } from "./endpoints/post_items_not_to_donate";
import { updateClothingItem } from "./endpoints/update_clothing_item";
import { deleteUser } from "./endpoints/delete_user";
import { updateOutfit } from "./endpoints/update_outfit";
import { getAClothingItem } from "./endpoints/get_a_clothing_item";
import { getItemsSentForDonation } from "./endpoints/get_items_sent_for_donation";
import { sendItemsForDonation } from "./endpoints/post_items_sent_for_donation";
import { unmarkItemsAccidentallyDonated } from "./endpoints/post_items_accidentally_marked_as_donated";
import { getTotalNumberOfDonatedItems } from "./endpoints/get_total_donated_items";
import { deleteOutfit } from "./endpoints/delete_outfit";


export const routes = (app: Router, db: FirebaseFirestore.Firestore) => {

  // ===========================================================================
  //      *** GET REQUESTS
  // ===========================================================================
  app.get("/initCloset", (req: Request, res: Response) => {
    initCloset(res, db);
    return;
  });

  app.get("/initOutfits", (req: Request, res: Response) => {
    initOutfits(res, db);
    return;
  });

  app.get("/initAchievements", (req: Request, res: Response) => {
    initAchievementTypes(res, db);
    return;
  });

  app.get("/getCarmaRecords/:uid", (req: Request, res: Response) => {
    getCarmaRecords(req, res, db);
    return;
  });

  app.get("/getUserRecords/:uid", (req: Request, res: Response) => {
      getUserRecords(req, res, db);
      return;
  })

  app.get("/getAchievements/:uid", (req: Request, res: Response) => {
    getAchievements(req, res, db);
    return;
  })

  app.get("/closet/allClothes/:uid", (req: Request, res: Response) => {
    getAllClothes(req, res, db);
    return;
  });

  app.get("/closet/allClothes/:itemId/:uid", (req: Request, res: Response) => {
    getAClothingItem(req, res, db);
    return;
  });

  app.get("/getAllClothingTypes", (req: Request, res: Response) => {
    getAllClothingTypes(res);
    return;
  });

  app.get("/closet/allDonatedItems/:uid", (req: Request, res: Response)=> {
    getAllDonatedItems(req, res, db);
    return;
  });

  app.get("/outfits/:uid", (req: Request, res: Response) => {
    getAllOutfits(req, res, db);
    return;
  })

  app.get("/dummy", (req: Request, res: Response) => {
    console.log("called dummy");
    res.status(200).json({ data: "dsfdf" });
    return;
  });

  app.get("/closet/allItemsSentToDonation/:uid", (req: Request, res:Response) => {
    getItemsSentForDonation(req, res, db);
    return;
  });

  app.get("/closet/allDonatedItems/:uid", (req: Request, res: Response)=> {
    getAllDonatedItems(req, res, db);
    return;
  });

  app.get("/getNumberOfDonatedItems/:uid", (req:Request, res: Response) => {
    getTotalNumberOfDonatedItems(req, res, db);
    return;
  })


  // ===========================================================================
  //      *** POST REQUESTS
  // ===========================================================================

  app.post("/initUsers", (req: Request, res: Response) => {
    initUsers(req, res, db);
    return;
  });

  app.post("/carma", (req: Request, res: Response) => {
    getCarmaValue(req, res);
    return;
  });

  app.post("/carma/add", (req: Request, res:Response) => {
    addCarmaPoints(req, res, db);
    return;
  });

  app.post("/closet/addItem", (req: Request, res: Response) => {
    postClothingItem(req, res, db);
    return;
  });

  app.post("/addUser", (req:Request, res: Response) => {
    addNewUser(req, res, db);
    return;
  });
  app.post("/markForDonation", (req: Request, res:Response) => {
    markItemsAsDonate(req, res, db);
    return;
  });

  app.post("/unmarkForDonation", (req: Request, res:Response) => {
    unmarkItemsAsDonate(req, res, db);
    return;
  });

  app.post("/postOutfit", (req: Request, res:Response) => {
    postOutfit(req, res, db);
    return;
  });

  app.post("/updateOutfit", (req: Request, res:Response) => {
    updateOutfit(req, res, db);
    return;
  })
  //TODO: post outfit
  app.post("/markDonated", (req: Request, res:Response) => {
    sendItemsForDonation(req, res, db);
    return;
  });


  app.post("/markUndoDonated", (req: Request, res:Response) => {
    unmarkItemsAccidentallyDonated(req, res, db);
    return;
  });
  
  app.post("/closet/updateItem", (req: Request, res:Response) => {
    updateClothingItem(req, res, db);
    return;
  });

  app.post("/deleteOutfit", (req: Request, res:Response) => {
    deleteOutfit(req, res, db);
    return;
  });

  app.post("/deleteUser", (req: Request, res: Response) => {
    deleteUser(req, res, db);
    return;
  })
}
