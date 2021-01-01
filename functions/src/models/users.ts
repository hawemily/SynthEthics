export interface User {
  userId: string;
  lastName: string;
  firstName: string;
  carmaPoints: number;
  itemsDonated: number;
  itemsWorn: number;
  itemsBought: number;
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
