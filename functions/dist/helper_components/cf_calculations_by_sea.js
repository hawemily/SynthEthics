"use strict";
Object.defineProperty(exports, "__esModule", { value: true });
exports.findCountryCode = exports.findSeaDistance = exports.initCSVs = exports.mapping = exports.seaDistanceDF = exports.countryCapitalDF = void 0;
const df = require("dataframe-js").DataFrame;
const fs = require("fs");
const csv = require("csv-parser");
exports.countryCapitalDF = null;
exports.seaDistanceDF = null;
exports.mapping = {};
const createDF = (filePath, string) => new Promise((resolve, reject) => {
    var ls = [];
    var keys = [];
    var keysFilled = false;
    var data = null;
    fs.createReadStream(filePath)
        .pipe(csv())
        .on("data", (row) => {
        var innerLs = [];
        for (const [key, value] of Object.entries(row)) {
            if (!keysFilled) {
                keys.push(key);
            }
            innerLs.push(value);
        }
        keysFilled = true;
        ls.push(innerLs);
    })
        .on("end", () => {
        console.log("read from csv using parser complete");
        data = new df(ls, keys);
        exports.mapping[string] = data;
        console.log(`count: ${data.count()}`);
    })
        .on("end", resolve);
});
exports.initCSVs = async () => {
    await createDF("data/sea_distance.csv", "seaDistance");
    exports.seaDistanceDF = exports.mapping["seaDistance"];
    await createDF("data/country_capital_dataset.csv", "countryCapital");
    exports.countryCapitalDF = exports.mapping["countryCapital"];
    return "successfully loaded csvs";
};
exports.findSeaDistance = (currLoc, origin) => {
    console.log(`origin: ${origin}`);
    console.log(`currLoc: ${currLoc}`);
    if (origin !== "") {
        var resDf = exports.seaDistanceDF.filter((row) => row.get("iso1") == currLoc && row.get("iso2") === origin);
        console.log(`count: ${resDf.count()}`);
        return resDf.getRow(0).get("seadistance");
    }
    return 0;
};
exports.findCountryCode = (countryName) => {
    if (countryName === "") {
        return "";
    }
    let resRow = exports.countryCapitalDF.filter((row) => row.get("Country") === countryName);
    let indivStrs = countryName.split(" ");
    // when there are no direct matches of the country name, check if the country is known by some other name
    if (resRow.count() == 0) {
        resRow = exports.countryCapitalDF.filter((row) => {
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
//# sourceMappingURL=cf_calculations_by_sea.js.map