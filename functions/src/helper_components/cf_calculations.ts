const df = require("dataframe-js").DataFrame;
import fs = require("fs");
const csv = require("csv-parser");

var countryCapitalDF: any = null;
var seaDistanceDF: any = null;

const mapping: any = {};

const createDF = (filePath: string, string: string) =>
  new Promise((resolve, reject) => {
    var ls: any = [];
    var keys: any = [];
    var keysFilled = false;
    var data = null;
    fs.createReadStream(filePath)
      .pipe(csv())
      .on("data", (row: any) => {
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
        mapping[string] = data;
        console.log(`count: ${data.count()}`);
      })
      .on("end", resolve);
  });

export const initCSVs = async () => {
  await createDF("data/country_capital_dataset.csv", "countryCapital");
  countryCapitalDF = mapping["countryCapital"];
  await createDF("data/sea_distance.csv", "seaDistance");
  seaDistanceDF = mapping["seaDistance"];

  return "successfully loaded csvs";
};

export const findSeaDistance = (currLoc: string, origin: string) => {
  console.log(`origin: ${origin}`);
  console.log(`currLoc: ${currLoc}`);
  if (origin !== "") {
    var resDf = seaDistanceDF.filter(
      (row: any) => row.get("iso1") == currLoc && row.get("iso2") === origin
    );
    return resDf.getRow(0).get("seadistance");
  }
  return 0;
};

export const findCountryCode = (countryName: string) => {
  if (countryName === "") {
    return "";
  }

  let resRow = countryCapitalDF.filter(
    (row: any) => row.get("Country") === countryName
  );

  let indivStrs = countryName.split(" ");

  // when there are no direct matches of the country name, check if the country is known by some other name
  if (resRow.count() == 0) {
    resRow = countryCapitalDF.filter((row: any) => {
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
    resRow.withColumn("MatchingSubStrings", (row: any) => {
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
