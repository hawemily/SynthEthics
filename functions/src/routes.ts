import { Request, Response, Router } from "express";
import { getAllClothes } from "./endpoints/get_all_clothes";
import { postClothingItem } from "./endpoints/post_clothing_item";
import { getCarmaValue } from "./endpoints/get_carma_value";
import { initData } from "./endpoints/init_data";
import { getAllClothingTypes } from "./endpoints/get_all_types";
import { addNewUser } from "./endpoints/post_new_user";
import { getAllDonatedItems } from "./endpoints/get_all_donated_items";
import { postOutfit } from "./endpoints/post_outfit";
import { getAllOutfits } from "./endpoints/get_all_outfits";

export const routes = (app: Router, db: FirebaseFirestore.Firestore) => {
  // GET /clothes
  app.get("/closet/allClothes", (req: Request, res: Response) => {
    getAllClothes(req, res, db);
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

  app.get("/initData", (req: Request, res: Response) => {
    initData(res, db);
    return;
  });

  app.post("/addUser", (req:Request, res: Response) => {
    addNewUser(req, res, db);
    return;
  });

  app.get("/getAllClothingTypes", (req: Request, res: Response) => {
    getAllClothingTypes(res);
    return;
  });

  app.post("/markedAsDonate", (req: Request, res:Response) => {
    postClothingItem(req, res, db);
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

  app.get("/dummy", (req: Request, res: Response) => {
    console.log("called dummy");
    res.status(200).json({ data: "dsfdf" });
    return;
  });
};
