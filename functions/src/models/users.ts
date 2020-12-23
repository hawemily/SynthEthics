export interface User {
  userId: string;
  carmaPoints: number;
  itemsDonated: number;
  achieved: number[];
  carmaRecord: {
    "days": {
                "day": string; // These are string representtions of datetime
                "value": number
    }[];
    "months": {
                "month": string;
                "value": number
    }[];
    "years": {
                "year": string;
                "value": number
    }[];
  };
}
