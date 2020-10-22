"use strict";
// interface AxiosResp {
//   data: JSON;
//   status: number;
//   statusText: string;
//   headers: string;
// }
Object.defineProperty(exports, "__esModule", { value: true });
exports.Status = void 0;
var Status;
(function (Status) {
    Status["Ok"] = "OK";
    Status["ZeroResults"] = "ZERO_RESULTS";
    Status["OverDailyLimit"] = "OVER_DAILY_LIMIT";
    Status["OverQueryLimit"] = "OVER_QUERY_LIMIT";
    Status["InvalidReq"] = "INVALID_REQUEST";
    Status["RequestDenied"] = "REQUEST_DENIED";
    Status["UnknownError"] = "UNKNOWN_ERROR";
})(Status = exports.Status || (exports.Status = {}));
//# sourceMappingURL=response_object.js.map