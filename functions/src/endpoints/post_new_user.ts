import {Request, Response} from "express";
import { Collections } from "../helper_components/db_collections";
import {User} from "../models/users";


export const addNewUser = async (req:Request, res:Response, db:FirebaseFirestore.Firestore) => {
   try {
    const {uid, username} = req.body;
    const usersCollectionRef = db.collection(Collections.Users)
    const userRef = usersCollectionRef.doc(uid);

    const userSnapshot = await userRef.get();

    const names: string[] = username.split(" ");
    const lastName = names[names.length - 1];
    const firstName = names[0]

    if (!userSnapshot.exists) {
        const newUser: User = {
            userId: uid,
            lastName: lastName,
            firstName: firstName,
            carmaPoints: 0,
            itemsDonated: 0,
            itemsBought: 0,
            itemsWorn: 0,
            achieved: [],
            carmaRecord: {days: [], months: [], years: []}
        };

        await usersCollectionRef.doc(uid).set(newUser);
    }

    res.send(200);
   } catch (e) {
       console.log("User could not be created!");
       res.status(400).send(`User could not be created!`);
   }

}