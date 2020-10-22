"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.findCountryCode = exports.findSeaDistance = exports.initCSVs = void 0;
const df = require("dataframe-js").DataFrame;
const functions = require("firebase-functions");
var countryCapitalDF = new df([], []);
var seaDistanceDF = new df([], []);
exports.initCSVs = async () => {
    countryCapitalDF = await df
        .fromCSV("../../data/country_capital_dataset.csv")
        .then((df) => df);
    seaDistanceDF = await df
        .fromCSV("../../data/seadistance.csv")
        .then((df) => df);
    return "success";
};
exports.findSeaDistance = (currLoc, origin) => {
    if (origin !== "") {
        var resDf = seaDistanceDF.filter((row) => row.get("iso1") === currLoc && row.get("iso2") === origin);
        return resDf.getRow().get("seadistance");
    }
    return 0;
};
exports.findCountryCode = (countryName) => {
    if (countryName === "") {
        return "";
    }
    functions.logger.log(countryCapitalDF.count());
    let resRow = countryCapitalDF.filter((row) => row.get("Country") === countryName);
    let indivStrs = countryName.split(" ");
    // when there are no direct matches of the country name, check if the country is known by some other name
    if (resRow.count() == 0) {
        resRow = countryCapitalDF.filter((row) => {
            var countryName = row.get("Country");
            var containStr = false;
            indivStrs.forEach((str) => {
                if (str !== "and") {
                    containStr = containStr || countryName.includes(str);
                }
            });
            return containStr;
        });
    }
    // if country name contains names that are shared across more than one name in the list, then consider
    // name with highest match count
    if (resRow.count() > 1) {
        resRow.withColumn("MatchingSubStrings", (row) => {
            const countryName = row.get("Country");
            var matches = 0;
            indivStrs.forEach((str) => {
                if (countryName.includes(str)) {
                    matches++;
                }
            });
            return matches;
        });
        resRow = resRow.sortBy("MatchingSubStrings");
    }
    return resRow.getRow(0).get("Country Code");
};
//# sourceMappingURL=cf_calculations.js.map