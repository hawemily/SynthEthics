"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.db = void 0;
const admin = require("firebase-admin");
// import * as functions from 'firebase-functions';
admin.initializeApp();
exports.db = admin.firestore();
// export const getSubCollections = functions.https.onCall(async (data, context) => {
//     const docPath = data.docPath;
//     const collections = await admin.firestore().doc(docPath).listCollections();
// })
//# sourceMappingURL=firebase.js.map