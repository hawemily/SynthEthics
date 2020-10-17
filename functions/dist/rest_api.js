"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.rest = void 0;
const routes_1 = require("./routes");
exports.rest = (db) => {
    const express = require('express');
    const bodyParser = require('body-parser');
    const app = express();
    const API_PREFIX = 'api';
    // Strip /API from the request URI
    app.use((req, res, next) => {
        if (req.url.indexOf(`/${API_PREFIX}/`) === 0) {
            req.url = req.url.substring(API_PREFIX.length + 1);
        }
        next();
    });
    app.use(bodyParser.urlencoded({ extended: false }));
    app.use(bodyParser.text());
    app.use(bodyParser.json());
    routes_1.routes(app, db);
    return app;
};
//# sourceMappingURL=rest_api.js.map