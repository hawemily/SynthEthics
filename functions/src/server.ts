import { RuntimeOptions, runWith } from "firebase-functions";
import { rest } from "./rest_api";
import { db } from "./firebase";

// Initialize Rest API
const express = rest(db);
const settings: RuntimeOptions = {
  timeoutSeconds: 60,
  memory: "512MB",
};
// add firebase functions here
export const api = runWith(settings).https.onRequest(express);

//// addmessage is a http endpoint
//exports.addMessage = functions.https.onRequest(async (req , res) => {
//    //grab the text parameter
//    const original = req.query.text;
//    // push the new message into Cloud Firestore using the FIrebase admin SDK
//    const writeResult = await admin.firestore().collection('messages').add({original:original});
//    // send back a message that message has been successfully written
//    res.json({result: 'message with ID: ${writeResult.id} added.'});
//});
//
//exports.makeUppercase = functions.firestore.document('messages/{documentId}')
//    .onCreate((snap, context) => {
//    // grab the current value of what was written
//    const original = snap.data().original;
//    // access pararmeter '{documentID}' with context.params
//    functions.logger.log('Uppercasing', context.params.documentId, original)
//
//    const uppercase = original.toUpperCase();
//
//    // return a promise when performing async tasks inside functions eg writing to cloud firestore
//
//    return snap.ref.set({uppercase}, {merge:true});
//    });
//
