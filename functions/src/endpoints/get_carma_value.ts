import { Request, Response } from "express";
import { LatLng } from "../helper_components/coordinates";
import { getMaterialCF } from "../helper_components/materials_cf";
import { callMapsApi } from "../helper_components/maps_geolocator_api";
import {
  findSeaDistance,
  findCountryCode,
  initCSVs,
} from "../helper_components/cf_calculations_by_sea";

const DEFAULT_LAT = 51.5074;
const DEFAULT_LONG = 0.1278;
const CO2_PER_TONNE_KM_SHIP = 0.012;
var csvReadIn = false;

const Weights: { [key: string]: number } = {
  tops: 1.0,
  bottoms: 1.5,
  skirts: 1.5,
  dresses: 2.0,
  outerwear: 3.0,
  headgear: 0.8,
};

export const getCarmaValue = async (req: Request, res: Response) => {
  const { category, materials, currLocation, origin } = req.body;

  let preWeighted = await calculateCarma(materials, currLocation, origin);
  console.log(`carma: ${preWeighted}`);
  const result = {
    carma: Math.round(preWeighted * Weights[category]),
  };
  console.log(`result: ${result}`);
  res.json(result);
};

export const calculateCarma = async (
  materials: string[],
  currLocation: LatLng,
  org: String
) => {
  const cdts: LatLng = {
    latitude: currLocation["latitude"] || DEFAULT_LAT,
    longitude: currLocation["longitude"] || DEFAULT_LONG,
  };
  const origin = org || "";

  var transportCarma = 0;
  try {
    transportCarma = await calculateTransportCarma(cdts, origin);
  } catch (e) {
    console.log("transport carma await failing");
    console.log(e);
  }

  return (
    calculateMaterialsCarma(materials) +
    calculateManufacturingCarma(origin) +
    transportCarma
  );
};

const calculateMaterialsCarma = (materials: any) => {
  // assume materials is a list of name-variant-percentage, with material to %
  let total = 0;

  materials.forEach((each: any) => {
    total +=
      getMaterialCF(each.name, each.variant) *
      (each.percentage || 100 / materials.length);
  });

  console.log(`total = ${total}`);

  return total;
};

const calculateManufacturingCarma = (origin: any) => {
  return 0;
};

const calculateTransportCarma = async (
  cdts: LatLng,
  origin: any
): Promise<number> => {
  let res = 0;

  if (!csvReadIn) {
    console.log("reading csv in");
    try {
      await initCSVs();
    } catch (e) {
      console.log("Error occured while reading CSV data files");
      console.log(e);
    }

    csvReadIn = !csvReadIn;
  }
  try {
    const address = await callMapsApi(cdts);

    const currLoc = findCountryCode(address.longName || "");
    const org = findCountryCode(origin);
    const dist = findSeaDistance(currLoc, org);
    console.log(`dist: ${dist}`);
    res = dist;
  } catch (e) {
    console.log("Error occured while calling Maps API");
  }

  return calculateCFOfShip(res);
};

const calculateCFOfShip = (dist: any) => {
  return dist * CO2_PER_TONNE_KM_SHIP;
};
