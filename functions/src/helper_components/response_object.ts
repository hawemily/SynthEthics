export interface AxiosResp {
  data: JSON;
  status: Status;
  statusText: string;
}

enum Status {
  Ok = "OK",
  Invalid_Req = "INVALID_REQUEST",
  Max_elems_exceeded = "MAX_ELEMENTS_EXCEEDED",
}
