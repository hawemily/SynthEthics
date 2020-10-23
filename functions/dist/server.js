"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.api = void 0;
const firebase_functions_1 = require("firebase-functions");
const rest_api_1 = require("./rest_api");
const firebase_1 = require("./firebase");
const cf_calculations_1 = require("./helper_components/cf_calculations");
// Initialize Rest API
const express = rest_api_1.rest(firebase_1.db);
const settings = {
    timeoutSeconds: 60,
    memory: "512MB",
};
cf_calculations_1.initCSVs();
// add firebase functions here
exports.api = firebase_functions_1.runWith(settings).https.onRequest(express);
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
//# sourceMappingURL=server.js.map