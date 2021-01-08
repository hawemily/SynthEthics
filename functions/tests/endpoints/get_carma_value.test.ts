import {expect} from "chai";
import {calculateTransportCarma} from "../../src/endpoints/get_carma_value";
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