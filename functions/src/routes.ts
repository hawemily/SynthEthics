import { Request, Response, Router } from "express";

import { addNewUser } from "./endpoints/post_new_user";

import { getAllClothes } from "./endpoints/get_all_clothes";
import { getCarmaValue } from "./endpoints/get_carma_value";
import { getAllClothingTypes } from "./endpoints/get_all_types";
import { getAllDonatedItems } from "./endpoints/get_all_donated_items";
import { getAllOutfits } from "./endpoints/get_all_outfits";
import { getAchievements } from "./endpoints/get_achievements";

import { postClothingItem } from "./endpoints/post_clothing_item";
import { postOutfit } from "./endpoints/post_outfit";

import { markItemsAsDonate } from "./endpoints/post_items_to_donate";

import { initCloset } from "./endpoints/init_closet";
import { initUsers } from "./endpoints/init_users";
import { initOutfits } from "./endpoints/init_outfits";
import { initAchievementTypes } from "./endpoints/init_achievement_types";


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

  app.get("/getAchievements", (req: Request, res: Response) => {
    getAchievements(req, res, db);
    return;
  })

  app.get("/closet/allClothes", (req: Request, res: Response) => {
    getAllClothes(req, res, db);
    return;
  });

  app.get("/getAllClothingTypes", (req: Request, res: Response) => {
    getAllClothingTypes(res);
    return;
  });

  app.get("/closet/allDonatedItems", (req: Request, res: Response)=> {
    getAllDonatedItems(req, res, db);
    return;
  });

  app.get("/outfits", (req: Request, res: Response) => {
    getAllOutfits(req, res, db);
    return;
  })

  app.get("/dummy", (req: Request, res: Response) => {
    console.log("called dummy");
    res.status(200).json({ data: "dsfdf" });
    return;
  });



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

  app.post("/postOutfit", (req: Request, res:Response) => {
    postOutfit(req, res, db);
    return;
  });


  app.get("/closet/allDonatedItems", (req: Request, res: Response)=> {
    getAllDonatedItems(req, res, db);
    return;
  });

  app.get("/outfits", (req: Request, res: Response) => {
    getAllOutfits(req, res, db);
    return;
  })

  app.post("/outfits/add", (req: Request, res: Response) => {
    postOutfit(req, res, db);
    return;
  })
};
