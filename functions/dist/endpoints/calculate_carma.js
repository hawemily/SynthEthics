"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateCarma = exports.calculateCarmaAPI = void 0;
const materials_cf_1 = require("../helper_components/materials_cf");
const DEFAULT_LAT = 51.5074;
const DEFAULT_LONG = 0.1278;
const Weights = {
    tops: 1.0,
    bottoms: 1.3,
};
exports.calculateCarmaAPI = async (req, res, db) => {
    const { category, materials, currLocation, origin } = req.body;
    let preWeighted = exports.calculateCarma(materials, currLocation, origin);
    res.status(200).send(preWeighted * Weights[category]);
};
exports.calculateCarma = (materials, currLocation, origin) => {
    const cdts = {
        latitude: currLocation["latitude"] || DEFAULT_LAT,
        longitude: currLocation["longitude"] || DEFAULT_LONG,
    };
    return (calculateMaterialsCarma(materials) +
        calculateManufacturingCarma(origin) +
        calculateTransportCarma(cdts, origin));
};
const calculateMaterialsCarma = (materials) => {
    // assume materials is a list of name-percentage pairs, with material to %
    let total = 0;
    materials.forEach((each) => {
        total += materials_cf_1.MaterialCF[each.name] * (each.percentage || 1);
    });
    return total;
};
const calculateManufacturingCarma = (origin) => {
    return 0;
};
const calculateTransportCarma = (origin, destination) => {
    return 0;
};
//# sourceMappingURL=calculate_carma.js.map