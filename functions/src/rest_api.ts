import { Request, Response, NextFunction } from 'express';
import { routes } from './routes';

export const rest = (db: FirebaseFirestore.Firestore) : any => {

    const express = require('express');
    const bodyParser = require('body-parser');
    const cors = require('cors');
    const app: any = express();
    const API_PREFIX = 'api';

    app.use(cors());

    // Strip /API from the request URI
    app.use((req: Request, res: Response, next: NextFunction) => {
        if (req.url.indexOf(`/${API_PREFIX}/`) === 0) {
            req.url = req.url.substring(API_PREFIX.length + 1);
        }
        next();
    });

    app.use(bodyParser.urlencoded({extended: false}));
    app.use(bodyParser.text());
    app.use(bodyParser.json());

    routes(app, db);

    return app;
}