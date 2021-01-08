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
const TOTAL_CF_FACTOR = 5;
const TOTAL_CF_OFFSET = 500;

var csvReadIn = false;

const Weights: { [key: string]: number } = {
  Tops: 1.0,
  Bottoms: 1.5,
  Skirts: 1.5,
  Dresses: 2.0,
  Outerwear: 3.0,
  Accessories: 0.8,
};

export const getCarmaValue = async (req: Request, res: Response) => {
  const { category, materials, currLocation, origin } = req.body;

  let carma: number = await calculateCarma(
    materials,
    currLocation,
    origin,
    category
  );

  const result: any = {
    carma: carma,
  };
  console.log(result);

  res.json(result);
};

/**
 * calculates the total carma points associated to a clothing item
 * @param materials : materials used to manufacture item
 * @param currLocation : lat long cdts of curr location
 * @param org : place of manufacture
 * @param category : category of clothing
 */
export const calculateCarma = async (
  materials: string[],
  currLocation: LatLng,
  org: String,
  category: any
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
  console.log(`transport carma value: ${transportCarma}`);
  const preWeighted: number =
    calculateMaterialsCarma(materials) +
    calculateManufacturingCarma(origin) +
    transportCarma;

  console.log(`category: ${category}`);
  console.log(`preweighted: ${Math.round(preWeighted * Weights[category])}`);

  return TOTAL_CF_OFFSET + TOTAL_CF_FACTOR * Math.round(preWeighted * Weights[category]);
};

export const calculateMaterialsCarma = (materials: string[]) => {
  let total = 0;

  materials.forEach((each: any) => {
    total += getMaterialCF(each, "");
  });

  console.log(`totalMaterials = ${total}`);

  return total;
};

const calculateManufacturingCarma = (origin: any) => {
  return 0;
};

/**
 * calculates the total carbon footprint of transporting * an item from place of manufacture to user's location * in terms of carma points
 * @param cdts - latitude and longitude of location
 * @param origin - place of manufacture of clothing item as string
 */
export const calculateTransportCarma = async (
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

  const address = await callMapsApi(cdts);

  const currLoc = findCountryCode(address.longName || "");
  const org = findCountryCode(origin);
  const dist = findSeaDistance(currLoc, org);
  console.log(`dist: ${dist}`);
  res = dist;

  return calculateCFOfShip(res);
};

const calculateCFOfShip = (dist: any) => {
  return dist * CO2_PER_TONNE_KM_SHIP;
};
