import { Request, Response } from "express";
import { LatLng } from "../helper_components/coordinates";
import { getMaterialCF } from "../helper_components/materials_cf";
import axios from "axios";
import { googleMapsApiKey, googleMapsApiUri } from "../maps_api";
import {
  DistanceMatrixRespObj,
  Status,
  Element,
} from "../helper_components/response_object";

const DEFAULT_LAT = 51.5074;
const DEFAULT_LONG = 0.1278;
const CO2_PER_TONNE_KM_FLIGHT = 0.755;

const Weights: { [key: string]: number } = {
  tops: 1.0,
  bottoms: 1.5,
  skirts: 1.5,
  dresses: 2.0,
  outerwear: 3.0,
  headgear: 0.8,
};

export const calculateCarmaAPI = async (req: Request, res: Response) => {
  const { category, materials, currLocation, origin } = req.body;

  let preWeighted = calculateCarma(materials, currLocation, origin);

  res.status(200).send(preWeighted * Weights[category]);
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

  callMapsApi(cdts, origin).then((distanceMatrix) => {
    if (distanceMatrix.status == Status.Ok) {
      if (distanceMatrix.rows != null) {
        const dist = distanceMatrix.rows[0][0].distanceInMeters;
        res = calculateCFOfFlight(dist);
      }
    }
  });

  return res;
};

const calculateCFOfFlight = (dist: any) => {
  return dist * CO2_PER_TONNE_KM_FLIGHT;
};

const callMapsApi = async (
  cdts: LatLng,
  origin: any
): Promise<DistanceMatrixRespObj> => {
  const reqUri = createReqURI(cdts, origin);
  const resp = await axios.get(reqUri);

  console.log("response received with code");
  console.log(resp.data);

  const { status, rows } = resp["data"];

  const distances = parseRowsAsElements(rows);

  const distanceMatrix: DistanceMatrixRespObj = {
    status: (<any>Status)[status],
    rows: distances,
  };
  return distanceMatrix;
};

const parseRowsAsElements = (rows: Array<any>): Array<Element[]> => {
  const res: Array<Element[]> = [];

  rows.forEach((row) => {
    const list: Element[] = [];
    const elements: Array<any> = row["elements"];

    elements.forEach((e) => {
      const { status, distance } = e;

      const elem: Element = {
        status = (<any>Status)[status],
        distanceInMeters = distance["value"],
        distanceInText = distance["text"],
      };

      list.push(elem);
    });
    res.push(list);
  });
  return res;
};

const createReqURI = (cdts: LatLng, origin: string): string => {
  return (
    googleMapsApiUri +
    "origins=" +
    cdts.latitude +
    "," +
    cdts.longitude +
    "&" +
    "&destinations=" +
    origin +
    "&key=" +
    googleMapsApiKey
  );
};
