import { User } from "../models/users";
import * as moment from 'moment';

var today = moment("2020-11-30");
var anotherDay = moment("2020-11-01");
// var lastWeek = today.subtract(1, 'month');
console.log(today);
console.log(anotherDay);
console.log(anotherDay.add(1, 'month'));
console.log(anotherDay);


function updateFieldAccordingTo(record: any,
                                resolution: string,
                                offset: number,
                                factor: "day" | "month" | "year",
                                current: moment.Moment,
                                carmaAmount: number) {
  if (record[resolution].length > 0 &&
        current.isSame(moment(record[resolution][0][factor]), factor)) {
        record[resolution][0]["value"] += carmaAmount;
    } else {
        record[resolution] = record[resolution].filter(entry => {
            const entryMoment = moment(entry[factor]);
            return entryMoment.add(offset, factor).isSameOrAfter(current);
        });
        console.log(record[resolution]);
        record[resolution].unshift({
            [factor]: current.format("YYYY-MM-DD"),
            "value": carmaAmount,
        })
    }
}


export const updateCarmaRecord = (user: User, carmaAmount: number) => {
    const currentDay: moment.Moment = moment();
    const currentMonth: moment.Moment = moment(currentDay.format("YYYY-MM-01"));
    const currentYear: moment.Moment = moment(currentDay.format("YYYY-01-01"));
    const carmaRecord = user['carmaRecord'];

    updateFieldAccordingTo(carmaRecord, "days", 6, "day", currentDay, carmaAmount);
    updateFieldAccordingTo(carmaRecord, "months", 11, "month", currentMonth, carmaAmount);
    updateFieldAccordingTo(carmaRecord, "years", 4, "year", currentYear, carmaAmount);
}


var user = {
  userId: "ha",
  carmaPoints: 0,
  itemsDonated: 0,
  achieved: [],
  carmaRecord: {
                "days": [
                {
                  day: "2020-11-10",
                  value: 10
                },
                {
                  day: "2020-11-11",
                  value: 10
                },
                {
                  day: "2020-11-09",
                  value: 10
                }],
                "months": [{
                  month: "2020-10-10",
                  value: 10
                },
                {
                  month: "2019-11-02",
                  value: 10
                },
                {
                  month: "2019-10-31",
                  value: 10
                }],
                "years": [{
                  year: "2014-01-01",
                  value: 10
                },
                {
                  year: "2016-01-01",
                  value: 10
                },
                {
                  year: "2015-12-31",
                  value: 10
                },
                {
                  year: "2015-11-18",
                  value: 10
                }],
  }
}
console.log(JSON.stringify(user));
updateCarmaRecord(user, 20);
console.log(JSON.stringify(user));
