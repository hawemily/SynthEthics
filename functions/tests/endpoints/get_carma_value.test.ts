import {expect} from "chai";
import {calculateMaterialsCarma, calculateTransportCarma, calculateManufacturingCarma, calculateCarma, TOTAL_CF_OFFSET, TOTAL_CF_FACTOR, Weights} from "../../src/endpoints/get_carma_value";
import { LatLng } from "../../src/helper_components/coordinates";

describe("calculates carma points of a clothing item from transportation", function() {
    const cdts:LatLng = {latitude: 37.4419, longitude:122.1430};
    var transportCarma:number;
    it("calculates carma points  given two coordinates", async function() {
        const origin = "United Kingdom";
        transportCarma = await calculateTransportCarma(cdts, origin);
        expect(Math.round(transportCarma)).equal(234);
    });

    it("returns 0 if origin of clothing is not specified",async function() {
        transportCarma = await calculateTransportCarma(cdts, "");
        expect(transportCarma).equal(0);
    })
});

describe("calculates carma ratio of given materials", function() {
    var materialCarma: number;
    it("calculate lyocell material carma", async function() {
        materialCarma = calculateMaterialsCarma(["lyocell"]);
        expect(materialCarma).equal(5);
    });
    it("returns 10 if undefined material", async function() {
        materialCarma = calculateMaterialsCarma(["undefined"]);
        expect(materialCarma).equal(10);
    })
});

describe("calculates manufacturing carma (Disabled)", function() {
    var manufacturingCarma: number;
    it("calculate manufacturing carma from China", async function() {
        manufacturingCarma = calculateManufacturingCarma("China");
        expect(manufacturingCarma).equal(0);
    })
})

describe("calculate total carma", function() {
    var total: number;
    it("cotton top from Peru", async function() {
        total = await calculateCarma(["cotton"], {latitude: 37.4419, longitude:122.1430}, "Peru", "Tops");
        expect(total).equal(1550);
    });
    it("leather outerwear from Australia", async function() {
        total = await calculateCarma(["leather"], {latitude: 37.4419, longitude:122.1430}, "Australia", "Outerwear");
        expect(total).equal(3130);
    });
});

describe("check if separate calculation matches result fronm calculateCarma", async function() {
    var manual: number;
    var auto: number;
    
    const cdts:LatLng = {latitude: 37.4419, longitude:122.1430};
    const origin = "India";
    const category = "Dresses";
    const materials = ["polyester"];
    var transportCarma = await calculateTransportCarma(cdts, origin);
    var materialCarma = calculateMaterialsCarma(materials);
    var manufacturingCarma = calculateManufacturingCarma(origin);

    var preWeighted = transportCarma + materialCarma + manufacturingCarma;
    manual = TOTAL_CF_OFFSET + TOTAL_CF_FACTOR * Math.round(preWeighted * Weights[category]);
    auto = await calculateCarma(materials, cdts, origin, category);
    expect(manual).equal(auto);
});