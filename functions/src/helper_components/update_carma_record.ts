import { User } from "../models/users";



export const updateCarmaRecord = (user: User, carmaAmount: number) => {
    const currentDateTime: Date = new Date();
    const carmaRecord = user['carmaRecord'];

    // Update the days
    if (carmaRecord["days"].length > 0 && 
        currentDateTime == new Date(carmaRecord["days"][0]["day"])) {
        carmaRecord["days"][0]["value"] += carmaAmount;
    } else {
        carmaRecord["days"].filter(dayValue => {
            const date = new Date(dayValue["day"]);
            return currentDateTime.getTime() - date.getTime() < 0

        });
    }

}