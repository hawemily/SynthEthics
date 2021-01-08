import {expect} from "chai";
import { findCountryCode, findSeaDistance, initCSVs } from "../../src/helper_components/cf_calculations_by_sea";

describe("calculates sea distance from CSV file", function () {
    const origin = "GBR";
    const currLoc = "CHN";
    var seaDist;

    it ("finds the correct country code given name of country", function () {
        initCSVs().then(_ => {
            const code = findCountryCode("China");
            expect(code).equal("CHN");})
    });

    it("finds the sea distance between two country codes", function() {
        initCSVs().then(_ => {
            seaDist = findSeaDistance(currLoc, origin);
            console.log(`SEADIST: ${seaDist}`);
            expect(seaDist).equal(19498);
        })
    });
    
    it("returns 0 if origin is not specified", function() {
        seaDist = findSeaDistance(currLoc, "");
        expect(seaDist).equal(0);
    })
})