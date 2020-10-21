import {Request, Response} from 'express';

interface BaseCarmaIndex {
    Materials: {
        [key: string]: number
    },
    Manufacturing: {
        [key: string]: number
    },
    Transport: number
}

const BaseCarma: BaseCarmaIndex = {
    Materials: {
        cotton: 10,
        polyester: 10
    },
    Manufacturing: {
        cn: 50,
        us: 10,
        uk: 20,
        jp: 15
    },
    Transport: 1
}

const Weights: {[key: string]: number} = {
    tops: 1.0,
    bottoms: 1.3
}

export const calculateCarma = async (req:Request, res:Response, db: FirebaseFirestore.Firestore) => {
    const { category, materials, origin, destination } = req.body;

    let preWeighted = calculateMaterialsCarma(materials) + 
                        calculateManufacturingCarma(origin) +
                        calculateTransportCarma(origin, destination);

    res.status(200).send(preWeighted * Weights[category]);
};

const calculateMaterialsCarma = (materials: any) => {
    // assume materials is a list of name-percentage pairs, with material to %
    let total = 0;

    materials.forEach((each: any) => {
        total += BaseCarma.Materials[each.name] * each.percentage
    });

    return total;
}

const calculateManufacturingCarma = (origin: any) => {
    return 0;
}

const calculateTransportCarma = (origin: any, destination: any) => {
    // call an api to calc
    return 0;
}