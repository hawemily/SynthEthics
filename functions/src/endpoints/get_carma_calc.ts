import { Request, Response } from "express";
import { LatLng } from "../helper_components/coordinates";
import { getMaterialCF } from "../helper_components/materials_cf";
import { callMapsApi } from "../helper_components/carma_api";
import {
  findSeaDistance,
  findCountryCode,
} from "../helper_components/cf_calculations";

const DEFAULT_LAT = 51.5074;
const DEFAULT_LONG = 0.1278;
const CO2_PER_TONNE_KM_SHIP = 0.012;

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

  let preWeighted = calculateCarma(materials, currLocation, origin);

  const returnVal = {
    carma: preWeighted * Weights[category],
  };
  res.sendStatus(200).json(returnVal);
};

export const calculateCarma = (
  materials: string[],
  currLocation: LatLng,
  org: String
) => {
  const cdts: LatLng = {
    latitude: currLocation["latitude"] || DEFAULT_LAT,
    longitude: currLocation["longitude"] || DEFAULT_LONG,
  };
  const origin = org || "";
  return (
    calculateMaterialsCarma(materials) +
    calculateManufacturingCarma(origin) +
    calculateTransportCarma(cdts, origin)
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

  return total;
};

const calculateManufacturingCarma = (origin: any) => {
  return 0;
};

const calculateTransportCarma = (cdts: LatLng, origin: any): number => {
  let res = 0;

  callMapsApi(cdts)
    .then((address) => {
      const currLoc = findCountryCode(address.longName || "");
      const org = findCountryCode(origin);
      const dist = findSeaDistance(currLoc, org);
      res = dist;
    })
    .catch((e) => {
      console.log(e);
    });

  return calculateCFOfShip(res);
};

const calculateCFOfShip = (dist: any) => {
  return dist * CO2_PER_TONNE_KM_SHIP;
};
