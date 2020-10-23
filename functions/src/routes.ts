import { Request, Response, Router } from "express";
import { getAllClothes } from "./endpoints/get_all_clothes";
import { postClothingItem } from "./endpoints/post_clothing_item";
import { getCarmaValue } from "./endpoints/get_carma_calc";

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


  app.get("/dummy", (req: Request, res: Response) => {
    return res.send("hehe");
  })
};
