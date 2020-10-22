interface AxiosResp {
  data: JSON;
  status: number;
  statusText: string;
  headers: string;
}

export interface DistanceMatrixRespObj {
  status?: Status;
  rows?: Array<Element[]>;
}

export interface Element {
  status?: Status;
  distanceInMeters?: number;
  distanceInText?: string;
}

export enum Status {
  Ok = "OK",
  Invalid_Req = "INVALID_REQUEST",
  Max_elems_exceeded = "MAX_ELEMENTS_EXCEEDED",
  Over_daily_limit = "OVER_DAILY_LIMIT",
  Over_query_limit = "OVER_QUERY_LIMIT",
  Request_denied = "REQUEST_DENIED",
  Unknown_error = "UNKNOWN_ERROR",
  Not_found = "NOT_FOUND",
  Zero_results = "ZERO_RESULTS",
  Max_route_length_exceeded = "MAX_ROUTE_LENGTH_EXCEEDED",
}
