"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.callMapsApi = void 0;
const axios_1 = require("axios");
const maps_api_1 = require("../maps_api");
const response_object_1 = require("../helper_components/response_object");
const DEFAULT_COUNTRY = "United Kingdom";
const DEFAULT_COUNTRY_CODE = "UK";
exports.callMapsApi = async (cdts) => {
    const reqUri = createReqURI(cdts);
    console.log(`uri: ${reqUri}`);
    var country;
    try {
        const resp = await axios_1.default.get(reqUri);
        console.log(`response received with code ${resp.status}`);
        console.log(resp.data);
        const { results, status } = resp["data"];
        if (response_object_1.Status[status] == response_object_1.Status.Ok) {
            country = parseResults(results);
            console.log(`longname: ${country.longName}`);
            return country;
        }
    }
    catch (e) {
        console.log("Geolocator API error");
        console.log(e);
    }
    country = {
        longName: DEFAULT_COUNTRY,
        shortName: DEFAULT_COUNTRY_CODE,
    };
    return country;
};
const parseResults = (results) => {
    const fstResult = results[0];
    const addrComponents = fstResult["address_components"][0];
    const addr = {
        longName: addrComponents["long_name"],
        shortName: addrComponents["short_name"],
    };
    return addr;
};
const createReqURI = (cdts) => {
    return (maps_api_1.googleMapsApiUri +
        "latlng=" +
        cdts.latitude +
        "," +
        cdts.longitude +
        "&result_type=country" +
        "&key=" +
        maps_api_1.googleMapsApiKey);
};
//# sourceMappingURL=carma_api.js.map