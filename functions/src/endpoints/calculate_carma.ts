import { Request, Response } from "express";
import { LatLng } from "../helper_components/coordinates";
import { MaterialCF } from "../helper_components/materials_cf";

const DEFAULT_LAT = 51.5074;
const DEFAULT_LONG = 0.1278;

const Weights: { [key: string]: number } = {
  tops: 1.0,
  bottoms: 1.3,
};

export const calculateCarmaAPI = async (
  req: Request,
  res: Response,
  db: FirebaseFirestore.Firestore
) => {
  const { category, materials, currLocation, origin } = req.body;

  let preWeighted = calculateCarma(materials, currLocation, origin);

  res.status(200).send(preWeighted * Weights[category]);
};

export const calculateCarma = (
  materials: string[],
  currLocation: LatLng,
  origin: String
) => {
  const cdts: LatLng = {
    latitude: currLocation["latitude"] || DEFAULT_LAT,
    longitude: currLocation["longitude"] || DEFAULT_LONG,
  };
  return (
    calculateMaterialsCarma(materials) +
    calculateManufacturingCarma(origin) +
    calculateTransportCarma(cdts, origin)
  );
};

const calculateMaterialsCarma = (materials: any) => {
  // assume materials is a list of name-percentage pairs, with material to %
  let total = 0;

  materials.forEach((each: any) => {
    total += MaterialCF[each.name] * (each.percentage || 1);
  });

  return total;
};

const calculateManufacturingCarma = (origin: any) => {
  return 0;
};

const calculateTransportCarma = (origin: any, destination: any) => {
  return 0;
};