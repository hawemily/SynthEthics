import * as admin from 'firebase-admin';
// import * as functions from 'firebase-functions';

admin.initializeApp();

export const db = admin.firestore();

// export const getSubCollections = functions.https.onCall(async (data, context) => {
//     const docPath = data.docPath;

//     const collections = await admin.firestore().doc(docPath).listCollections();

// })
