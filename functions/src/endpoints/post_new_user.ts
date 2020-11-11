import {Request, Response} from "express";
import { Collections } from "../helper_components/db_collections";
import {User} from "../models/users";


export const addNewUser = async (req:Request, res:Response, db:FirebaseFirestore.Firestore) => {
   try {
    const {uid} = req.body;
    const userRef = db.collection(Collections.Users);

    const newUser: User = {
        userId: uid,
        carmaPoints: 0,
        carmaAccumulated: []
    }

    await userRef.doc(uid).set(newUser);
    res.send(200);
   } catch (e) {
       console.log("User could not be created!");
       res.status(400).send(`User could not be created!`);
   }

}