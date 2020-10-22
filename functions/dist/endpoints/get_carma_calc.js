"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateCarma = exports.getCarmaValue = void 0;
const materials_cf_1 = require("../helper_components/materials_cf");
const carma_api_1 = require("../helper_components/carma_api");
const cf_calculations_1 = require("../helper_components/cf_calculations");
const DEFAULT_LAT = 51.5074;
const DEFAULT_LONG = 0.1278;
const CO2_PER_TONNE_KM_SHIP = 0.012;
const Weights = {
    tops: 1.0,
    bottoms: 1.5,
    skirts: 1.5,
    dresses: 2.0,
    outerwear: 3.0,
    headgear: 0.8,
};
exports.getCarmaValue = async (req, res) => {
    const { category, materials, currLocation, origin } = req.body;
    let preWeighted = exports.calculateCarma(materials, currLocation, origin);
    res.sendStatus(200).send(preWeighted * Weights[category]);
};
exports.calculateCarma = (materials, currLocation, org) => {
    const cdts = {
        latitude: currLocation["latitude"] || DEFAULT_LAT,
        longitude: currLocation["longitude"] || DEFAULT_LONG,
    };
    const origin = org || "";
    return (calculateMaterialsCarma(materials) +
        calculateManufacturingCarma(origin) +
        calculateTransportCarma(cdts, origin));
};
const calculateMaterialsCarma = (materials) => {
    // assume materials is a list of name-variant-percentage, with material to %
    let total = 0;
    materials.forEach((each) => {
        total +=
            materials_cf_1.getMaterialCF(each.name, each.variant) *
                (each.percentage || 100 / materials.length);
    });
    return total;
};
const calculateManufacturingCarma = (origin) => {
    return 0;
};
const calculateTransportCarma = (cdts, origin) => {
    let res = 0;
    cf_calculations_1.initCSVs()
        .then((succ) => {
        console.log(succ);
        return carma_api_1.callMapsApi(cdts);
    })
        .then((address) => {
        const currLoc = cf_calculations_1.findCountryCode(address.longName || "");
        const org = cf_calculations_1.findCountryCode(origin);
        const dist = cf_calculations_1.findSeaDistance(currLoc, org);
        res = dist;
    })
        .catch((e) => {
        console.log(e);
    });
    return calculateCFOfShip(res);
};
const calculateCFOfShip = (dist) => {
    return dist * CO2_PER_TONNE_KM_SHIP;
};
//# sourceMappingURL=get_carma_calc.js.map