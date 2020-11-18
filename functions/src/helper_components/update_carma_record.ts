import { User } from "../models/users";
import * as moment from 'moment';

type recordEntry = {
  [x: string]: string;
}

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
        cleanFieldAccordingTo(record, resolution, offset, factor, current);
        record[resolution].unshift({
            [factor]: current.format("YYYY-MM-DD"),
            "value": carmaAmount,
        })
    }
}

function cleanFieldAccordingTo(record: any,
                               resolution: string,
                               offset: number,
                               factor: "day" | "month" | "year",
                               current: moment.Moment) {
  record[resolution] = record[resolution].filter(
    (entry: recordEntry) => {
      const entryMoment = moment(entry[factor]);
      return entryMoment.add(offset, factor).isSameOrAfter(current);
  });
}


export const cleanCarmaRecord = (user: User) => {
  const currentDay: moment.Moment = moment();
  const currentMonth: moment.Moment = moment(currentDay.format("YYYY-MM-01"));
  const currentYear: moment.Moment = moment(currentDay.format("YYYY-01-01"));
  const carmaRecord = user['carmaRecord'];

  cleanFieldAccordingTo(carmaRecord, "days", 6, "day", currentDay);
  cleanFieldAccordingTo(carmaRecord, "months", 11, "month", currentMonth);
  cleanFieldAccordingTo(carmaRecord, "years", 4, "year", currentYear);
}

export const addToCarmaRecord = (user: User, carmaAmount: number) => {
    const currentDay: moment.Moment = moment();
    const currentMonth: moment.Moment = moment(currentDay.format("YYYY-MM-01"));
    const currentYear: moment.Moment = moment(currentDay.format("YYYY-01-01"));
    const carmaRecord = user['carmaRecord'];

    updateFieldAccordingTo(carmaRecord, "days", 6, "day", currentDay, carmaAmount);
    updateFieldAccordingTo(carmaRecord, "months", 11, "month", currentMonth, carmaAmount);
    updateFieldAccordingTo(carmaRecord, "years", 4, "year", currentYear, carmaAmount);
}


// Use the following code for testing at a later date

// var user = {
//   userId: "ha",
//   carmaPoints: 0,
//   itemsDonated: 0,
//   achieved: [],
//   carmaRecord: {
//                 "days": [
//                 {
//                   day: "2020-11-10",
//                   value: 10
//                 },
//                 {
//                   day: "2020-11-11",
//                   value: 10
//                 },
//                 {
//                   day: "2020-11-09",
//                   value: 10
//                 }],
//                 "months": [{
//                   month: "2020-10-10",
//                   value: 10
//                 },
//                 {
//                   month: "2019-11-02",
//                   value: 10
//                 },
//                 {
//                   month: "2019-10-31",
//                   value: 10
//                 }],
//                 "years": [{
//                   year: "2014-01-01",
//                   value: 10
//                 },
//                 {
//                   year: "2016-01-01",
//                   value: 10
//                 },
//                 {
//                   year: "2015-12-31",
//                   value: 10
//                 },
//                 {
//                   year: "2015-11-18",
//                   value: 10
//                 }],
//   }
// }
// console.log(JSON.stringify(user));
// updateCarmaRecord(user, 20);
// console.log(JSON.stringify(user));
