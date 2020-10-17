import { Request, Response, Router } from 'express';
import {getAllClothes} from './endpoints/get_all_clothes';
import {postClothingItem} from './endpoints/post_clothing_item';

export const routes = (app:Router, db: FirebaseFirestore.Firestore) => {

    // GET /clothes
    app.get('/closet/allClothes', (req:Request, res:Response) => {
        getAllClothes(req, res, db);
        return;
    });

    app.get('/hello', (req:Request, res:Response) => {
        res.send(200);
        return;
    });

    app.post('/posting/double', (req:Request, res:Response) => {
       res.status(200).send("checking if this works");
       return;
    });


    app.post('/closet/addItem', (req:Request, res:Response) => {
        postClothingItem(req, res, db);
//        res.status(200).send("checking if this api works");
        return;
    });
};