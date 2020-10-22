import { Request, Response, Router } from "express";
import { getAllClothes } from "./endpoints/get_all_clothes";
import { postClothingItem } from "./endpoints/post_clothing_item";
import { getCarmaValue } from "./endpoints/get_carma_calc";
import { findCountryCode, initCSVs } from "./helper_components/cf_calculations";

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

  app.get("/calc", (req: Request, res: Response) => {
    initCSVs().then((sicc) => {
      console.log(sicc);
      const code = findCountryCode("China");
      res.sendStatus(200).send(code);
    });
  });

  app.post("/closet/addItem", (req: Request, res: Response) => {
    postClothingItem(req, res, db);
    return;
  });
};
