"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.db = void 0;
const admin = require("firebase-admin");
admin.initializeApp();
exports.db = admin.firestore();
//# sourceMappingURL=firebase.js.map