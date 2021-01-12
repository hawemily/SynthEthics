import 'package:synthetics/components/carma_chart/carma_series.dart';

class RecordDatesPadder {
  static final List<String> daysOrder = [
    "SUN",
    "MON",
    "TUE",
    "WED",
    "THU",
    "FRI",
    "SAT"
  ];
  static final List<String> monthsOrder = [
    "JA",
    "FB",
    "MR",
    "AP",
    "MY",
    "JN",
    "JY",
    "AG",
    "SP",
    "OT",
    "NV",
    "DC"
  ];

  // Size of days > 0
  static padDays(List<dynamic> days) {
    return padDateResolution(days, "day", daysOrder);
  }

  // Size of months > 0
  static padMonths(List<dynamic> months) {
    return padDateResolution(months, "month", monthsOrder);
  }

  // Fill in any empty years, size of years > 0
  static padYears(List<dynamic> years) {
    String resolution = "year";

    // Insert the most recent year
    // Carma data is floating point, so need to round first
    List<CarmaSeries> dateSeries = [
      CarmaSeries(
          dateLabel: years[0][resolution].toString(),
          carma: years[0]["value"].round())
    ];

    // Go backwards and if a year is missing then
    // add a 0 entry for the year
    int currentDate = years[0][resolution];
    int i = 1;
    while (dateSeries.length != 5) {
      currentDate--;

      if (i > years.length - 1 || years[i][resolution] != currentDate) {
        dateSeries
            .add(CarmaSeries(dateLabel: currentDate.toString(), carma: 0));
      } else {
        dateSeries.add(CarmaSeries(
            dateLabel: years[i][resolution].toString(),
            carma: years[i]["value"].round()));
        i++;
      }
    }

    return dateSeries.reversed.toList();
  }

  // Goes through list of carma records, and adds any missing dates
  // with 0 carma entries to fulfill a complete record history
  static padDateResolution(
      List<dynamic> dates, String resolution, List<String> dateNames) {
    List<CarmaSeries> dateSeries = [
      CarmaSeries(
          dateLabel: dateNames[dates[0][resolution]],
          carma: dates[0]["value"].round())
    ];

    int currentDate = dates[0][resolution];
    int i = 1;
    while (dateSeries.length != dateNames.length) {
      currentDate = (currentDate - 1) % dateNames.length;

      if (i > dates.length - 1 || dates[i][resolution] != currentDate) {
        dateSeries
            .add(CarmaSeries(dateLabel: dateNames[currentDate], carma: 0));
      } else {
        dateSeries.add(CarmaSeries(
            dateLabel: dateNames[dates[i][resolution]],
            carma: dates[i]["value"].round()));
        i++;
      }
    }

    return dateSeries.reversed.toList();
  }
}
