import axios from "axios";
import { googleMapsApiKey, googleMapsApiUri } from "../maps_api";
import { Status, AddressComponents } from "./response_object";
import { LatLng } from "./coordinates";

const DEFAULT_COUNTRY = "United Kingdom";
const DEFAULT_COUNTRY_CODE = "UK";

export const callMapsApi = async (cdts: LatLng): Promise<AddressComponents> => {
  const reqUri = createReqURI(cdts);
  console.log(`uri: ${reqUri}`);
  var country: AddressComponents = {
    longName: DEFAULT_COUNTRY,
    shortName: DEFAULT_COUNTRY_CODE,
  };

  await axios
    .get(reqUri)
    .then((resp) => {
      console.log(`response received with code ${resp.status}`);
      // console.log(resp.data);
      const { results, status } = resp["data"];

      if (<string>status === Status.Ok) {
        country = parseResults(results);
        console.log(`longname: ${country.longName}`);
      }
    })
    .catch((e) => {
      console.log("Geolocator API error");
      console.log(e);
    });

  return country;
};

const parseResults = (results: Array<any>): AddressComponents => {
  const fstResult = results[0];

  const addrComponents = fstResult["address_components"][0];

  const addr: AddressComponents = {
    longName: addrComponents["long_name"],
    shortName: addrComponents["short_name"],
  };

  return addr;
};

const createReqURI = (cdts: LatLng): string => {
  return (
    googleMapsApiUri +
    "latlng=" +
    cdts.latitude +
    "," +
    cdts.longitude +
    "&result_type=country" +
    "&key=" +
    googleMapsApiKey
  );
};
