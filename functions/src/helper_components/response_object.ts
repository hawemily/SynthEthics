// interface AxiosResp {
//   data: JSON;
//   status: number;
//   statusText: string;
//   headers: string;
// }

export interface AddressComponents {
  longName?: string;
  shortName?: string;
}

export enum Status {
  Ok = "OK",
  ZeroResults = "ZERO_RESULTS",
  OverDailyLimit = "OVER_DAILY_LIMIT",
  OverQueryLimit = "OVER_QUERY_LIMIT",
  InvalidReq = "INVALID_REQUEST",
  RequestDenied = "REQUEST_DENIED",
  UnknownError = "UNKNOWN_ERROR",
}
