"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.calculateCarma = exports.getCarmaValue = void 0;
const materials_cf_1 = require("../helper_components/materials_cf");
const maps_geolocator_api_1 = require("../helper_components/maps_geolocator_api");
const cf_calculations_by_sea_1 = require("../helper_components/cf_calculations_by_sea");
const DEFAULT_LAT = 51.5074;
const DEFAULT_LONG = 0.1278;
const CO2_PER_TONNE_KM_SHIP = 0.012;
var csvReadIn = false;
const Weights = {
    Tops: 1.0,
    Bottoms: 1.5,
    Skirts: 1.5,
    Dresses: 2.0,
    Outerwear: 3.0,
    Headgear: 0.8,
};
exports.getCarmaValue = async (req, res) => {
    const { category, materials, currLocation, origin } = req.body;
    let carma = await exports.calculateCarma(materials, currLocation, origin, category);
    const result = {
        carma: carma,
    };
    console.log(result);
    res.json(result);
};
exports.calculateCarma = async (materials, currLocation, org, category) => {
    const cdts = {
        latitude: currLocation["latitude"] || DEFAULT_LAT,
        longitude: currLocation["longitude"] || DEFAULT_LONG,
    };
    const origin = org || "";
    var transportCarma = 0;
    try {
        transportCarma = await calculateTransportCarma(cdts, origin);
    }
    catch (e) {
        console.log("transport carma await failing");
        console.log(e);
    }
    const preWeighted = calculateMaterialsCarma(materials) +
        calculateManufacturingCarma(origin) +
        transportCarma;
    return Math.round(preWeighted * Weights[category]);
};
const calculateMaterialsCarma = (materials) => {
    // assume materials is a list of name-variant-percentage, with material to %
    let total = 0;
    materials.forEach((each) => {
        total +=
            materials_cf_1.getMaterialCF(each.name, each.variant) *
                (each.percentage || 100 / materials.length);
    });
    console.log(`totalMaterials = ${total}`);
    return total;
};
const calculateManufacturingCarma = (origin) => {
    return 0;
};
const calculateTransportCarma = async (cdts, origin) => {
    let res = 0;
    if (!csvReadIn) {
        console.log("reading csv in");
        try {
            await cf_calculations_by_sea_1.initCSVs();
        }
        catch (e) {
            console.log("Error occured while reading CSV data files");
            console.log(e);
        }
        csvReadIn = !csvReadIn;
    }
    const address = await maps_geolocator_api_1.callMapsApi(cdts);
    const currLoc = cf_calculations_by_sea_1.findCountryCode(address.longName || "");
    const org = cf_calculations_by_sea_1.findCountryCode(origin);
    const dist = cf_calculations_by_sea_1.findSeaDistance(currLoc, org);
    console.log(`dist: ${dist}`);
    res = dist;
    return calculateCFOfShip(res);
};
const calculateCFOfShip = (dist) => {
    return dist * CO2_PER_TONNE_KM_SHIP;
};
//# sourceMappingURL=get_carma_value.js.map